//
//  DiscoverVC.swift
//  myscrap
//
//  Created by MS1 on 7/9/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit
import MapKit


class DiscoverVC: BaseRevealVC {
    
    @IBOutlet weak var mapView:MKMapView!
    @IBOutlet weak var textField:UITextField!
    
    fileprivate var dataSource = [DiscoverItems]()
    fileprivate var filteredDataSource = [DiscoverItems]()
    fileprivate var service = DiscoverService()
    var inSearchMode = false
    
    var searchText = ""

    
    @IBOutlet weak var tableView:UITableView!
    
    let clusterManager = ClusterManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        //service.delegate = self
        self.getMapItems()
        
        setupMapView()
        setupTableView()
        setupTextField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let reveal = self.revealViewController() {
            self.mBtn.target(forAction: #selector(reveal.revealToggle(_:)), withSender: self.revealViewController())
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    private func setupTableView(){
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isHidden = true

        tableView.estimatedRowHeight = 89
        tableView.rowHeight = UITableView.automaticDimension
        tableView.keyboardDismissMode = .onDrag
        tableView.register(CompaniesCell.nib, forCellReuseIdentifier: CompaniesCell.identifier)
    }
    
    private func setupTextField(){
        textField.delegate = self
        textField.returnKeyType = .done
        textField.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        textField.textColor = UIColor.GREEN_PRIMARY
        textField.tintColor = UIColor.GREEN_PRIMARY
    }
    
    func getMapItems(){
        self.getDiscover(searchText: self.searchText,completion: { _ in
            print("Got DS values :\(self.dataSource.count)")
        })
    }
    
    func getDiscover(searchText: String, completion: @escaping (Bool) -> () ) {
        service.getDiscoverCompany(searchText: searchText) { (result) in
            DispatchQueue.main.async {
                switch result{
                case .Error(let _):
                    completion(false)
                case .Success(let data):
                    print("Company data count",self.dataSource.count)
                    
                    let newData = data
                    self.dataSource = newData
                    print("&&&&&&&&&&& DATA : \(newData.count), \(self.dataSource.count)")
                    self.tableView.reloadData()
                    self.addMarkers(data: data)
                    self.setLocation(true)
                    DispatchQueue.main.async {
                        self.hideActivityIndicator()
                    }
                    completion(true)
                }
            }
        }
    }
    
    @IBAction func textFieldChanged(_ sender: UITextField) {
        /*if sender.text == "" {
            tableView.isHidden = true
        } else {
            tableView.isHidden = false
        }*/
        tableView.isHidden = false
        if sender.text == nil || sender.text == ""{
            inSearchMode = false
            tableView.reloadData()
            view.endEditing(true)
        }
        else if textField.text?.count == 0{
            view.endEditing(true)
        } else {
            inSearchMode = true
            let lower = sender.text!.lowercased()
            
            filteredDataSource = dataSource.filter({$0.name.lowercased().range(of: lower) != nil })
            if filteredDataSource.count < 1 {
                tableView.isHidden = true
            }
            tableView.reloadData()
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        endEditing()
    }
    
    func endEditing(){
        view.endEditing(true)
    }
    
}

// MARK :- TEXTFIELD DELEGATE METHODS
extension DiscoverVC: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if searchText != ""{
            //inSearchMode = false
            tableView.isHidden = true
            searchText = ""
            self.getDiscover(searchText: self.searchText,completion: { _ in
                print("Got search results values :\(self.dataSource.count)")
                self.tableView.isHidden = false
            })
        } else {
            self.tableView.isHidden = false
        }
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchText = textField.text!
        if searchText == "" {
            self.tableView.isHidden = true
            textField.resignFirstResponder()
        } else {
            filteredDataSource.removeAll()
            inSearchMode = false
            self.getDiscover(searchText: self.searchText,completion: { _ in
                print("Got search results values :\(self.dataSource.count)")
                self.tableView.isHidden = false
                self.tableView.reloadData()
            })
            textField.resignFirstResponder()
        }
        
        return true
    }
}

extension DiscoverVC: CompanyDelegate{
    func didReceiveData(data: [CompanyItem]) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.setLocation(true)
        }
    }
    
    func didReceiveError(error: String) {
        print("error")
    }
}

// MARK :- TABLEVIEW DELEGATE AND DATASOURCE METHODS

extension DiscoverVC: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if inSearchMode{
            return filteredDataSource.count
        } else {
            return dataSource.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CompaniesCell.identifier, for: indexPath) as! CompaniesCell
        var com:DiscoverItems!
        if inSearchMode{
            com = filteredDataSource[indexPath.row]
        } else {
            com = dataSource[indexPath.row]
        }
        cell.configDiscoverCell(company: com)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var com:DiscoverItems!
        if inSearchMode{
            com = filteredDataSource[indexPath.row]
        } else {
            com = dataSource[indexPath.row]
        }
        let coordinate = CLLocationCoordinate2D(latitude: com.latitude, longitude: com.longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.0, longitudeDelta: 0.0)
        let coordinateRegion = MKCoordinateRegion(center: coordinate, span: span)
        self.textField.text = ""
        self.textField.resignFirstResponder()
        self.tableView.reloadData()
        self.tableView.isHidden = true
        self.mapView.setRegion(coordinateRegion, animated: true)
        
    }
}

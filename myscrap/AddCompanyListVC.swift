//
//  AddCompanyListVC.swift
//  myscrap
//
//  Created by MyScrap on 11/23/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit
import RealmSwift

class AddCompanyListVC: UIViewController {
    
    fileprivate var loadMore = true
    var searchText = ""
    
    let apiClient = CompanyService()
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    var noCompanyLbl = UILabel()
    
    fileprivate var dataSource = [SignUPCompanyItem]()
    fileprivate var filteredDataSource = [SignUPCompanyItem]()
    
    let searchController = CustomSearchController(searchResultsController: nil)
    
    typealias companyListSelection = (SignUPCompanyItem, AddCompanyListVC) -> ()
    
    var selection: companyListSelection?

    let activityIndicator: UIActivityIndicatorView = {
        let av = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        av.translatesAutoresizingMaskIntoConstraints = false
        return av
    }()
    
    var company_Local : Results<CompanySignupLoad>!
    
    var nocompanyContentView : UIView!
    var nocompanyImageView : UIImageView!
    var createcompanyButton : UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        self.view.backgroundColor = UIColor.white
        DispatchQueue.main.async {
            self.showActivityIndicator(with: "Loading Companies...")             //(Maha Manual edit)
        }
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.GREEN_PRIMARY
        
        setupViews()
        setupSearchController()
        title = "Company List"
        
        //Getting company list from Local db once stored
        var companyItem = [SignUPCompanyItem]()
        self.company_Local = uiRealm.objects(CompanySignupLoad.self)
        let jsonString = self.company_Local.last?.companyString
        if jsonString != "" && jsonString != nil {
            let data = jsonString?.data(using: .utf8)!
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: data!, options : .allowFragments) as? [String:AnyObject]
                {
                    print(jsonArray) // use the json here
                    if let companyData = jsonArray["locationData"] as? [[String:AnyObject]]{
                        
                        for comp in companyData{
                            let company = SignUPCompanyItem(companyDict: comp)
                            companyItem.append(company)
                        }
                        self.dataSource = companyItem
                        self.tableView.reloadData()
                        self.loadMore = true
                        print("Local Data Count : \(self.dataSource.count)")
                        DispatchQueue.main.async {
                            self.hideActivityIndicator()
                        }
                    }
                } else {
                    print("bad json")
                }
            } catch let error as NSError {
                print(error)
            }
        } else {
            getCompany()
        }
        
        self.setUpNoCompanyView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = true
        }
    }

    func setUpNoCompanyView() {
        
        //nocompanyContentView
        self.nocompanyContentView = UIView()
        self.nocompanyContentView.isHidden = true
        self.nocompanyContentView.translatesAutoresizingMaskIntoConstraints = false
        self.nocompanyContentView.backgroundColor = UIColor.clear
        self.view.addSubview(self.nocompanyContentView)
        
        //nocompanyImageView
        self.nocompanyImageView = UIImageView()
//        self.nocompanyImageView.isHidden = true
        self.nocompanyImageView.translatesAutoresizingMaskIntoConstraints = false
        self.nocompanyImageView.image = UIImage(named: "company")
        self.nocompanyContentView.addSubview(self.nocompanyImageView)

        
        //createcompanyButton
        self.createcompanyButton = UIButton()
        self.createcompanyButton.translatesAutoresizingMaskIntoConstraints = false
        self.createcompanyButton.setTitleColor(UIColor.white, for: .normal)
        self.createcompanyButton.layer.cornerRadius = 5
        self.createcompanyButton.layer.masksToBounds = true
        self.createcompanyButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        self.createcompanyButton.setTitle("Not in the list, create your company", for: .normal)
        self.createcompanyButton.backgroundColor = UIColor.GREEN_PRIMARY
        self.createcompanyButton.addTarget(self, action: #selector(createCompanyButtonAction), for: .touchUpInside)
        self.nocompanyContentView.addSubview(self.createcompanyButton)

        
        //nocompanyContentView
        self.nocompanyContentView.leadingAnchor.constraint(equalTo: self.nocompanyContentView.superview!.leadingAnchor, constant: 0).isActive = true
        self.nocompanyContentView.trailingAnchor.constraint(equalTo: self.nocompanyContentView.superview!.trailingAnchor, constant: 0).isActive = true
        self.nocompanyContentView.topAnchor.constraint(equalTo: self.nocompanyContentView.superview!.topAnchor, constant: 100).isActive = true
        
        
        //nocompanyImageView
        self.nocompanyImageView.centerXAnchor.constraint(equalTo: self.nocompanyImageView.superview!.centerXAnchor, constant: 0).isActive = true
        self.nocompanyImageView.topAnchor.constraint(equalTo: self.nocompanyImageView.superview!.topAnchor, constant: 20).isActive = true
        self.nocompanyImageView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        self.nocompanyImageView.heightAnchor.constraint(equalToConstant: 80).isActive = true

        
        //createcompanyButton
        self.createcompanyButton.leadingAnchor.constraint(equalTo: self.createcompanyButton.superview!.leadingAnchor, constant: 16).isActive = true
        self.createcompanyButton.trailingAnchor.constraint(equalTo: self.createcompanyButton.superview!.trailingAnchor, constant: -16).isActive = true
        self.createcompanyButton.topAnchor.constraint(equalTo: self.nocompanyImageView.bottomAnchor, constant: 15).isActive = true
        self.createcompanyButton.bottomAnchor.constraint(equalTo: self.createcompanyButton.superview!.bottomAnchor, constant: 0).isActive = true
        self.createcompanyButton.heightAnchor.constraint(equalToConstant: 45).isActive = true


    }
    private func setupViews(){
        setupCancelButton()
        //No Company List Label
        noCompanyLbl.textAlignment = .center
        noCompanyLbl.text = "No search results found"
        noCompanyLbl.textColor = UIColor.MyScrapGreen
        noCompanyLbl.font = UIFont(name: "HelveticaNeue", size: 18)
        noCompanyLbl.numberOfLines = 0
        
        view.addSubview(tableView)
        tableView.addSubview(noCompanyLbl)
        view.addSubview(activityIndicator)
        
        noCompanyLbl.setTop(to: tableView.safeTop, constant: 30)
        noCompanyLbl.setHorizontalCenter(to: tableView.centerXAnchor)
        
        activityIndicator.setTop(to: view.safeTop, constant: 30)
        activityIndicator.setHorizontalCenter(to: view.centerXAnchor)
        activityIndicator.setSize(size: CGSize(width: 30, height: 30))
        tableView.anchor(leading: view.safeLeading, trailing: view.safeTrailing, top: view.safeTop, bottom: view.safeBottom)
        self.tableView.estimatedRowHeight = 89
        self.tableView.rowHeight = UITableView.automaticDimension
        tableView.register(CompaniesCell.nib, forCellReuseIdentifier: CompaniesCell.identifier)
//        tableView.register(NoCompanyCell.nib, forCellReuseIdentifier: NoCompanyCell.identifier)
        tableView.sectionIndexColor = UIColor.GREEN_PRIMARY
        tableView.sectionIndexTrackingBackgroundColor = UIColor.lightGray
        tableView.sectionIndexBackgroundColor = UIColor.lightGray
    }
    
    func setupSearchController(){
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.showsCancelButton = false
        searchController.hidesNavigationBarDuringPresentation = false
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            // Fallback on earlier versions
            navigationItem.titleView = searchController.searchBar
        }
        definesPresentationContext = true
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.subviews[0].subviews.flatMap { $0 as? UITextField }.first?.tintColor = UIColor.GREEN_PRIMARY
        self.extendedLayoutIncludesOpaqueBars = true
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
    }
    
    private func setupCancelButton(){
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelPressed))
        self.navigationItem.rightBarButtonItem = cancelButton
    }
    
    @objc
    func cancelPressed(){
        searchController.isActive = false
        self.dismiss(animated: true, completion: nil)
    }
    
    private func getCompany(){
        
        self.getCompanyValues(pageLoad: self.dataSource.count, searchText: self.searchText, completion: { _ in
            print("Got DS values :\(self.dataSource.count)")
        })
    }
    
    private func getCompanyValues(pageLoad: Int, searchText: String, completion: @escaping (Bool) -> () ){
        apiClient.getSignUPCompanyLists(pageLoad: "\(pageLoad)", searchText: searchText.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!) { (result)  in
            DispatchQueue.main.async {
                
                switch result{
                case .Error(let _):
                    self.hideActivityIndicator()
                    completion(false)
                case .Success(let data):
                    self.hideActivityIndicator()
                    print("Company data count",self.dataSource.count)
                    if self.activityIndicator.isAnimating { self.activityIndicator.stopAnimating() }
                    let newData = data
                    if newData == [] {
                        print("No result for api")
                        self.noCompanyLbl.isHidden = false
                        self.dataSource = newData
                        self.tableView.reloadData()
                        self.loadMore = false
                        DispatchQueue.main.async {
                            self.hideActivityIndicator()
                        }
                        completion(true)
                    } else {
                        //newData.removeDuplicates()
                        //dump(newData)
                        self.dataSource = newData
                        self.tableView.reloadData()
                        self.loadMore = true
                        print("&&&&&&&&&&& DATA : \(newData.count), \(self.dataSource.count)")
                        //self.refreshTableView()
                        DispatchQueue.main.async {
                            self.hideActivityIndicator()
                        }
                        completion(true)
                    }
                    
                }
            }
        }
    }
    
    private func getCompaniesMore(pageLoad: Int, searchText: String, completion: @escaping (Bool) -> () ){
        apiClient.getSignUPCompanyLists(pageLoad: "\(pageLoad)", searchText: searchText) { (result)  in
            DispatchQueue.main.async {
                switch result{
                case .Error(let _):
                    completion(false)
                case .Success(let data):
                    /*print("Company data count load more",self.dataSource.count)
                    if self.activityIndicator.isAnimating { self.activityIndicator.stopAnimating() }
                    var newData = self.dataSource + data
                    newData.removeDuplicates()
                    self.dataSource = newData*/
                    if self.isFiltering(){
                        print("Company data count load more while searching...",self.filteredDataSource.count)
                        var newData = self.filteredDataSource + data
                        //newData.removeDuplicates()
                        self.filteredDataSource = newData
                        print("&&&&&&&&&&& DATA : \(newData.count)")
                    } else {
                        print("Company data count load more",self.dataSource.count)
                        var newData = self.dataSource + data
                        //newData.removeDuplicates()
                        self.dataSource = newData
                        print("&&&&&&&&&&& DATA : \(newData.count)")
                    }
                    self.tableView.reloadData()
                    self.loadMore = true
                    //self.refreshTableView()
                    DispatchQueue.main.async {
                        self.hideActivityIndicator()
                    }
                    completion(true)
                }
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if dataSource.isEmpty || !filteredDataSource.isEmpty{
            let currentOffset = scrollView.contentOffset.y
            let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
            let deltaOffset = maximumOffset - currentOffset
            if deltaOffset <= 0 {
                if loadMore{
                    loadMore = false
                    //self.getCompaniesMore(pageLoad: dataSource.count, searchText: self.searchText,completion: { _ in })
                    if isFiltering() {
                        self.getCompaniesMore(pageLoad: filteredDataSource.count, searchText: self.searchText,completion: { _ in })
                    } else {
                        self.getCompaniesMore(pageLoad: dataSource.count, searchText: self.searchText,completion: { _ in })
                    }
                }
            }
        }
    }
}
extension AddCompanyListVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if isFiltering(){
            return 1
        } else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isFiltering(){
            return nil
        } else {
            return nil
        }
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if isFiltering(){
            return nil
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       /* if isFiltering(){
            return filteredDataSource.count
        } else {
            print("Company list count : \(dataSource.count)")
            
            if dataSource.count != 0 {
                return dataSource.count
            } else {
                //No companies available
                return 1
            }
        } */
        if isFiltering(){
            if filteredDataSource.count != 0 {
                return filteredDataSource.count
            } else {
                //No companies available
                return 1
            }
//            return filteredDataSource.count
        } else {
            print("Company list count : \(dataSource.count)")
            
            if dataSource.count != 0 {
                return dataSource.count
            } else {
                //No companies available
                return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        /*
        if isFiltering(){
            let cell = tableView.dequeueReusableCell(withIdentifier: CompaniesCell.identifier, for: indexPath) as! CompaniesCell
            cell.configCellSignUP(company: filteredDataSource[indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CompaniesCell.identifier, for: indexPath) as! CompaniesCell
            if dataSource.count != 0 {
                if self.searchText != "" {
                    self.getCompany()
                } else {
                    cell.configCellSignUP(company: dataSource[indexPath.row])
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: NoCompanyCell.identifier, for: indexPath) as! NoCompanyCell
                return cell
            }
        } */
        
        if isFiltering(){
            if self.filteredDataSource.count != 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: CompaniesCell.identifier, for: indexPath) as! CompaniesCell
                cell.configCellSignUP(company: filteredDataSource[indexPath.row])
                return cell
            }
//            else {
//                let cell = tableView.dequeueReusableCell(withIdentifier: NoCompanyCell.identifier, for: indexPath) as! NoCompanyCell
//                cell.createCompanyButton.addTarget(self, action: #selector(createCompanyButtonAction), for: .touchUpInside)
//                return cell
//            }
        } else {
            if dataSource.count != 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: CompaniesCell.identifier, for: indexPath) as! CompaniesCell
                if self.searchText != "" {
                    self.getCompany()
                } else {
                    cell.configCellSignUP(company: dataSource[indexPath.row])
                }
                return cell
            }
//            else {
//                let cell = tableView.dequeueReusableCell(withIdentifier: NoCompanyCell.identifier, for: indexPath) as! NoCompanyCell
//                return cell
//            }
        }
        
        return UITableViewCell()

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var company : SignUPCompanyItem?
        if isFiltering(){
            company = self.filteredDataSource[indexPath.row]
            print("Selected company :\(company?.name)")
            selection?(company!, self)
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            if dataSource.count != 0 {
                company = dataSource[indexPath.row]
                print("Selected company :\(company?.name)")
                selection?(company!, self)
                tableView.deselectRow(at: indexPath, animated: true)
            } else {
                
            }
            
        }
        /*if  let vc = CompanyDetailVC.storyBoardInstance() {
            vc.title = company?.name
            vc.companyId = company?.id
            UserDefaults.standard.set(vc.title, forKey: "companyName")
            UserDefaults.standard.set(vc.companyId, forKey: "companyId")
            self.navigationController?.pushViewController(vc, animated: true)
        }*/
        
    }
        
    @objc func createCompanyButtonAction() {
        
        if self.isFiltering() {
                        
            let vc = UIStoryboard.init(name: "CreateCompany", bundle: nil).instantiateViewController(withIdentifier: "CreateCompanyTitleVC") as! CreateCompanyTitleVC

            let navVC = UINavigationController.init(rootViewController: vc)
            
            self.navigationController?.present(navVC, animated: true, completion: nil)
        }
    }
}

extension AddCompanyListVC: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        searchText = searchController.searchBar.text!
        filterContentForSearchText(searchText)
    }
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        self.getCompanyValues(pageLoad: 0, searchText: searchText) { _ in
            print("Filtered values")
            self.filteredDataSource = self.dataSource.filter({( company : SignUPCompanyItem) -> Bool in
                return company.name.lowercased().contains(searchText.lowercased())
            })
//            self.tableView.reloadData()
            
          if searchText != "" {
              
              if self.filteredDataSource.count == 0 {
                  self.tableView.isHidden = true
                  self.nocompanyContentView.isHidden = false
              }
              else {
                  self.tableView.isHidden = false
                  self.nocompanyContentView.isHidden = true
                  self.tableView.reloadData()
              }
          }
          else {
              self.tableView.isHidden = false
              self.nocompanyContentView.isHidden = true
              self.tableView.reloadData()
          }
        }
    }
}

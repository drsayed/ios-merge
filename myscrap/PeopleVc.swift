//
//  PeopleVc.swift
//  myscrap
//
//  Created by MS1 on 5/20/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit
import CoreLocation

class PeopleVc: BaseRevealVC, FriendControllerDelegate {
    
    fileprivate var service = PeopleService()
    
    fileprivate var dataSource = [PeopleNearByItem]() {
        didSet{
            self.refreshTableView()
        }
    }
    
    fileprivate var isLocationEnabled: Bool{
        return LocationService.sharedInstance.isLocationEnabled()
    }
    
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var restrictedView: UIView!
    @IBOutlet weak var topViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topLbl: UILabel!
    @IBOutlet weak var topLblHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var locSettingsBtn: UIButton!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControl.Event.valueChanged)
        return refreshControl
    }()
    
    var locSharedFromApi = ""
    
    
    private func refreshTableView(){
        DispatchQueue.main.async {
            self.hideActivityIndicator()
        }
        if refreshControl.isRefreshing { refreshControl.endRefreshing() }
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        NotificationCenter.default.addObserver(self, selector: #selector(locationAuthorisationChanged), name: .locationAuthorisationChanged, object: nil)
        self.title = "People NearBy"
        service.delegate = self
        tableView.refreshControl = refreshControl
        tableView.register(PeopleCell.nib, forCellReuseIdentifier: PeopleCell.identifier)
        
        locManager.requestWhenInUseAuthorization()
    }
    
    
    @objc func locationAuthorisationChanged(){
        if isLocationEnabled{
            restrictedView.isHidden = true
            topViewHeightConstraint.constant = 0
            topLblHeightConstraint.constant = 0
            dataSource = [PeopleNearByItem]()
            tableView.reloadData()
            getpeoples()
        } else {
            topViewHeightConstraint.constant = 86
            topLblHeightConstraint.constant = 54
            restrictedView.isHidden = true
//
//            if refreshControl.isRefreshing{
//                refreshControl.endRefreshing()
//            }
//            hideActivityIndicator()
            dataSource = [PeopleNearByItem]()
            tableView.reloadData()
            getpeoples()
            restrictedView.isHidden = true
        }
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl){
        self.getpeoples()
    }
    
    @IBAction func searchPressed(_ sender: Any) {
        self.statusDeniedAlert()
    }
    
    func getpeoples(){
        if refreshControl.isRefreshing { refreshControl.endRefreshing() }
        self.showActivityIndicator(with: "Searching For people")
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            if let currentLocation = locManager.location {
                print(currentLocation.coordinate.latitude)
                print(currentLocation.coordinate.longitude)
                let lat = String(currentLocation.coordinate.latitude)
                let long = String(currentLocation.coordinate.longitude)
                service.getPeopleNearBy(lat: lat, long: long)
            }
            
        } else {
            service.getPeopleNearBy(lat: "", long: "")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let reveal = self.revealViewController() {
            self.mBtn.target(forAction: #selector(reveal.revealToggle(_:)), withSender: self.revealViewController())
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
        if isLocationEnabled{
            topViewHeightConstraint.constant = 0
            topLblHeightConstraint.constant = 0
            self.restrictedView.isHidden = true
            if dataSource.isEmpty{
                
                getpeoples()
            }
        } else {
            self.restrictedView.isHidden = true
            topViewHeightConstraint.constant = 86
            topLblHeightConstraint.constant = 54
            getpeoples()
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    @IBAction func locSettingsTapped(_ sender: UIButton) {
        let settingsURL = URL(string: UIApplication.openSettingsURLString)!
        UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
    }
    
    
    func statusDeniedAlert() {
        let alertController = UIAlertController(title: "Location Access Disabled", message: "In order to show People NearBy, please open this app's settings and set location access to 'While Using'.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Open Settings", style: .default, handler: { (action) in
            let settingsURL = URL(string: UIApplication.openSettingsURLString)!
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        }))
        alertController.view.tintColor = UIColor.GREEN_PRIMARY
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func updateView(hide: Bool){
        restrictedView.isHidden = hide
        if hide{
            self.tableView.addSubview(refreshControl)
        } else {
            refreshControl.removeFromSuperview()
        }
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alertController.addAction(defaultAction)
        alertController.view.tintColor = UIColor.GREEN_PRIMARY
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    // Deinitializing location authorisation status observer
    deinit {
        NotificationCenter.default.removeObserver(self, name: .locationAuthorisationChanged, object: nil)
    }
    
}
 
 
extension PeopleVc: PeopleNearByDelegate{
    
    func DidReceiveData(data: [PeopleNearByItem], locShared : String) {
        DispatchQueue.main.async { [weak self] in
            self?.dataSource = data
            if locShared == "0" {
                self?.topViewHeightConstraint.constant = 86
                self?.topLblHeightConstraint.constant = 54
            } else {
                self?.topViewHeightConstraint.constant = 0
                self?.topLblHeightConstraint.constant = 0
            }
        }
    }
    
    func DidReceiveError(error: String) {
        print(error)
    }
}

extension PeopleVc: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performFriendView(friendId: dataSource[indexPath.row].userId)
    }
}

extension PeopleVc: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PeopleCell.identifier, for: indexPath) as? PeopleCell else { return UITableViewCell() }
        let people = dataSource[indexPath.row]
        cell.congigPeople(people: people)
        cell.delegate = self
        return cell
    }
}
extension PeopleVc: PeopleCellDelegate {
    func didPressChatButton(friendId: String, profileName: String?, colorCode: String?, profileImage: String?, jid: String) {
        performConversationVC(friendId: friendId, profileName: profileName, colorCode: colorCode, profileImage: profileImage, jid: jid, listingId: "", listingTitle: "", listingType: "", listingImg: "")
    }
}



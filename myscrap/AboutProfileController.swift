//
//  AboutProfileController.swift
//  myscrap
//
//  Created by MS1 on 2/3/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit
import SafariServices
import MapKit
import CoreLocation

//ScrollViewContainerController replaced as ScrollViewContainerController
class AboutProfileController: UIViewController, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate{
    
    var type: MemberType{
        return .about
    }

    
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.spacing = 8
        sv.alignment = .fill
        sv.axis = .vertical
        return sv
    }()
    
    private let showMapBtn: UIButton = {
       let btn = UIButton()
        btn.setTitle("[Show Map]", for: .normal)
        btn.tintColor = UIColor.black.withAlphaComponent(0.1)
        btn.addTarget(self, action: #selector(showMapTapped), for: .touchUpInside)
        return btn
    }()
    
    private let mapView: MKMapView = {
        let mapView = MKMapView()
        
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        return mapView
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let av = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        av.translatesAutoresizingMaskIntoConstraints = false
        return av
    }()
    let aboutArray = ["I'm from :", "I'm here to :", "I'm :", "I'm interested in :", "Member since :", "Bio :"]
    var expandedCells = [Int]()
    
    
    var profileItem: ProfileData?
    fileprivate let service = ProfileService()
    
    var friendId : String?
    var notificationId = ""
    
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        service.delegate = self
        
        //tableView.register(AboutTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.frame = self.view.bounds
        self.tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 450
        tableView!.cellLayoutMarginsFollowReadableWidth = false

//        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(UINib(nibName: "BusinessCardViewCell", bundle: nil), forCellReuseIdentifier: "BusinessCardViewCell")

        //self.view.addSubview(tableView)
        
        
        view.addSubview(activityIndicator)
        activityIndicator.setTop(to: view.safeTop, constant: 30)
        activityIndicator.setHorizontalCenter(to: view.centerXAnchor)
        activityIndicator.setSize(size: CGSize(width: 30, height: 30))
        NotificationCenter.default.addObserver(self, selector: #selector(self.enableScroll), name: Notification.Name("EnableScroll"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.disableScroll), name: Notification.Name("DisableScroll"), object: nil)
        if profileItem == nil {
            print("Profile data is nil")
            //setupViews()
            
        } else {
            //setupViews()
        }
        tableView!.isScrollEnabled = false
        
        
    }
    @objc
    func enableScroll(){
        tableView!.isScrollEnabled = true
    }
    @objc func disableScroll(){
        tableView!.isScrollEnabled = false
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if profileItem == nil {
            print("Profile data is nil")
            //setupViews()
            
        } else {
            print("Profile data is not nil  in view Appear")
            self.view.setNeedsLayout()
            //setupViews()
        }
        self.getProfile()
    }
    
    /*func contentDidChange(cell: AboutTableViewCell) {
        UIView.animate(withDuration: 1) {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
    }*/
    
    private func getProfile() {
        friendId = UserDefaults.standard.object(forKey: "friendId") as? String
        print("Friend ID in About   VC : \(String(describing: friendId!))")
        var notId = ""
        if notificationId != ""{
            notId = "&notId=\(notificationId)"
        }
        
        //service.getFriendProfile(friendId: friendId!, notId: notId)
        service.getAboutPage(friendId: friendId!)
    }
    
    private func setupViews(){
        
        
        
        view.addSubview(stackView)
        stackView.height = 30
        stackView.width = 375
        stackView.anchor(leading: view.leadingAnchor, trailing: view.trailingAnchor, top: view.topAnchor, bottom: view.bottomAnchor, padding: UIEdgeInsets(top: 10, left: 10, bottom: 300, right: 0), size: CGSize(width: 375, height: 30))
        //stackView.anchor(leading: view.leadingAnchor, trailing: view.trailingAnchor, top: view.topAnchor, bottom: view.bottomAnchor, size: CGSize(width: 30, height: 375))
        
        guard let item = profileItem else { return }
        print("Why :\(item.phone)")
        
        if item.country != "" && item.city != "" {
            let location = item.city + ", " + item.country
            stackView.addArrangedSubview(createButtonView(title: location, type: .location))
        }
        
        if item.city == "" {
            stackView.addArrangedSubview(createButtonView(title: item.country, type: .location))
        }
        print("I'm here to in About \(item.userType)")
        if item.userType != "" {
            stackView.addArrangedSubview(createButtonView(title: item.userType, type: .hereto))
            
        }
        if item.memInterest != [""] {
            stackView.addArrangedSubview(createButtonView(title: item.memInterest.joined(separator: " / "), type: .interested))
            
        }
        if item.memRoles != [""] {
            stackView.addArrangedSubview(createButtonView(title: item.memRoles.joined(separator: " / "), type: .profession))
            
        }
        if item.joinedDateNew != "" {
            stackView.addArrangedSubview(createButtonView(title: item.joinedDateNew, type: .dateofjoining))
            
        }
        stackView.addArrangedSubview(createButtonView(title: item.userBio, type: .userBio))
        
        //let date = item.joinedDateNew
        //let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "dd MMMM yyyy"
        //let dateString = dateFormatter.string(from: date)
        
    }
    @objc func sendCardShowRequest(_ sender : UIButton) {
        friendId = UserDefaults.standard.object(forKey: "friendId") as? String
        let spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
                    spinner.mode = MBProgressHUDMode.indeterminate
                    spinner.label.text = "Requesting..."
        self.sendCardShowRequestToFriend(friendId: friendId!,Type: "0")
    }
    @objc func sendAlreadyCardShowRequested()
    {
        self.showToast(message: "Your request already has been sent")

    }
    func sendCardShowRequestToFriend(friendId: String, Type: String) {
        let service = APIService()
        service.endPoint =  Endpoints.Send_ShowRequest_Friend
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&friendId=\(friendId)&type=\(Type)"
        print("URL : \(Endpoints.GET_FRIEND_PHOTOS), \nPARAMS for get profile:",service.params)
        service.getDataWith { [weak self] (result) in
            switch result{
            case .Success(let dict):
                       if let error = dict["error"] as? Bool{
                    if !error{
                          DispatchQueue.main.async {
                            MBProgressHUD.hide(for: (self?.view)!, animated: true)
                            self?.getProfile()
                              self?.showToast(message: "Request has been sent")
                        }
                         
                   //     delegate?.DidReceiveStories(item: items)
                    } else {
                          DispatchQueue.main.async {
                        self?.showToast(message: dict["status"] as? String ?? "Error in sending request")
                        }
                      //  delegate?.DidReceiveError(error: "Received Error in JSON Result...!")
                    }
                }
            case .Error(let error):
                  DispatchQueue.main.async {
                self?.showToast(message: error)
                }
            }
        }
    }
    @objc func showMapTapped() {
        let leftMargin:CGFloat = 10
        let topMargin:CGFloat = 60
        let mapWidth:CGFloat = view.frame.size.width-20
        let mapHeight:CGFloat = 300
        
        mapView.frame = CGRect(x: leftMargin, y: topMargin, width: mapWidth, height: mapHeight)
        //stackView.addArrangedSubview(mapView)
        
        // Or, if needed, we can position map in the center of the view
        //mapView.center = view.center
    }
    
    private func createButtonView(title: String,type: ButtonTextType) -> AboutProfileView {
        let view = AboutProfileView(viewType: type, title: title)
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        print(view, "About profile view" )
        print("Stack view height \(stackView.height)")
        return view
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0  {
              return aboutArray.count
        }
        else
    {
        return 1;
        }
      
        
    }
    
   func numberOfSections(in tableView: UITableView) -> Int {
    
    if profileItem?.cardFront  == "" && profileItem?.cardBack == "" {
        return 1
    }
    else
    {
      return 2
   }
    
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as!  AboutTableViewCell
            tableView.isHidden = true
            print("TV cell \(cell)")
            if profileItem != nil {
                tableView.isHidden = false
                cell.leftLabel.text = aboutArray[indexPath.row]
                cell.leftLabel.font = Fonts.DESIG_FONT
                cell.leftLabel.translatesAutoresizingMaskIntoConstraints = false
                cell.leftLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                
                cell.centerLabel.font = Fonts.DESIG_FONT
                //cell.centerLabel.translatesAutoresizingMaskIntoConstraints = false
                //cell.centerLabel.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                
                
                
                if aboutArray[indexPath.row] == "I'm from :" {
                    if profileItem?.city == "" && profileItem?.country != "" {
                        cell.centerLabel.text = (profileItem?.country)!
                        cell.mapBtn.isHidden = false
                        cell.centerLabel.sizeToFit()
                        //cell.centerLblWidthConstaint.isActive = false
                        cell.mapBtn.sizeToFit()
                      //  cell.btnWidthConstraint.isActive = false
                        
                        //Map implementation only for Country
                        let geoCoder = CLGeocoder()
                        geoCoder.geocodeAddressString((profileItem?.country)!) { (placemarks, error) in
                            if((error) != nil){
                                print("Error", error ?? "")
                            }
                            if let placemark = placemarks?.first {
                                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                                print("Lat: \(coordinates.latitude) -- Long: \(coordinates.longitude)")
                                
                                cell.mapView.mapType = MKMapType.standard
                                
                                let span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
                                let region = MKCoordinateRegion(center: coordinates, span: span)
                                cell.mapView.setRegion(region, animated: true)
                                
                                let annotation = MKPointAnnotation()
                                annotation.coordinate = coordinates
                                annotation.title = self.profileItem!.city
                                annotation.subtitle = (self.profileItem?.country)!
                                cell.mapView.addAnnotation(annotation)
                            }
                            
                        }
                    } else if profileItem?.city == "" && profileItem?.country == "" {
                        cell.centerLabel.text = "-"
                        cell.mapBtn.isHidden = true
                        
                    }
                    else if profileItem?.city != "" && profileItem?.country != "" {
                        cell.centerLabel.text = (profileItem?.city)! + ", " + (profileItem?.country)!
                        cell.mapBtn.isHidden = false
                        
                        let area = (profileItem?.country)!
                        //Map implementation for Country and city
                        let geoCoder = CLGeocoder()
                        geoCoder.geocodeAddressString(area) { (placemarks, error) in
                            if((error) != nil){
                                print("Error", error ?? "")
                            }
                            if let placemark = placemarks?.first {
                                let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                                print("Lat: \(coordinates.latitude) -- Long: \(coordinates.longitude)")
                                
                                cell.mapView.mapType = MKMapType.standard
                                
                                let span = MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)
                                let region = MKCoordinateRegion(center: coordinates, span: span)
                                cell.mapView.setRegion(region, animated: true)
                                
                                let annotation = MKPointAnnotation()
                                annotation.coordinate = coordinates
                                annotation.title = self.profileItem!.city
                                annotation.subtitle = (self.profileItem?.country)!
                                cell.mapView.addAnnotation(annotation)
                            }
                            
                        }
                    }
                    
                    
                    //cell.mapViewHeightConstraint.constant =  0
                    
                    
                    cell.actionBlock = {
                        //cell.mapViewHeightConstraint.constant = 179
                        
                        tableView.beginUpdates()
                        tableView.endUpdates()
                        
                        print("Height map view : \(cell.mapView.height)")
                    }
                    
                    print("Location Result label : \(String(describing: cell.centerLabel.text))")
                    
                    print("From label layout \(cell.centerLabel.width), \(cell.centerLabel.height)")
                }
                else if aboutArray[indexPath.row] == "I'm here to :" {
                    cell.centerLabel.text = profileItem!.userType
                    cell.mapBtn.isHidden = true
                    cell.mapViewHeightConstraint.constant =  0
                    print("Usertype Result label : \(String(describing: cell.centerLabel.text))")
                }
                else if aboutArray[indexPath.row] == "I'm interested in :" {
                    cell.centerLabel.text = profileItem!.memInterest.joined(separator: " / ")
                    //cell.mapBtn.isHidden = true
                    cell.mapViewHeightConstraint.constant =  0
                    cell.btnHeightConstraint.constant = 0
                    cell.btnWidthConstraint.constant = 0
                    //cell.centerLblWidthConstaint.constant = 233
                    print("Interest Result label : \(String(describing: cell.centerLabel.text))")
                }
                else if aboutArray[indexPath.row] == "I'm :" {
                    cell.centerLabel.text = profileItem!.memRoles.joined(separator: " / ")
                    cell.mapBtn.isHidden = true
                    cell.mapViewHeightConstraint.constant =  0
                    cell.btnHeightConstraint.constant = 0
                    cell.btnWidthConstraint.constant = 0
                    //cell.centerLblWidthConstaint.constant = 233
                    print("Member roles Result label : \(String(describing: cell.centerLabel.text))")
                }
                else if aboutArray[indexPath.row] == "Member since :"{
                    cell.centerLabel.text = profileItem!.joinedDateNew
                    cell.mapBtn.isHidden = true
                    cell.mapViewHeightConstraint.constant =  0
                    print("Member since Result label : \(String(describing: cell.centerLabel.text))")
                } else {
                    if profileItem?.userBio == "" {
                        cell.centerLabel.text = "-"
                    } else {
                        cell.centerLabel.text = profileItem!.userBio
                    }
                    cell.mapBtn.isHidden = true
                    cell.mapViewHeightConstraint.constant =  0
                    print("Member Bio Result label : \(String(describing: cell.centerLabel.text))")
                }
                
                //cell.configCell(item: profileItem!)
            }
            
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCard", for: indexPath) as!  BusinessCardViewCell

            
              if profileItem != nil {
                
                if profileItem?.cardShow != "1"
                {
                     cell.cardHideView.isHidden = true
                    cell.newItem = profileItem
                              cell.refreshTable()
                }
            else
                {
                    cell.cardHideView.isHidden = false
                    if profileItem?.cardreq == "" {
                        cell.sendRequestButton.setTitle("Send Request", for: .normal)
                        cell.sendRequestButton.addTarget(self, action: #selector(self.sendCardShowRequest), for: .touchUpInside)
                    }
                    else
                    {
                        cell.sendRequestButton.setTitle("Requested", for: .normal)
                        cell.sendRequestButton.addTarget(self, action: #selector(self.sendAlreadyCardShowRequested), for: .touchUpInside)

                    }
                }
                
            }
            cell.layoutIfNeeded()
            cell.businessCardTapDelegate = self
             return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        if indexPath.section == 0 {
            return  UITableView.automaticDimension
        } else {
          //  return  UITableView.automaticDimension
            return  240
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.stoppedScrolling()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.stoppedScrolling()
        }
    }

    func stoppedScrolling() {
        if tableView.contentOffset.y <= 2 {
           tableView!.isScrollEnabled = false
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let actualPosition = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        if (actualPosition.y > 0){
            // Dragging down
            //let screenSize = UIScreen.main.bounds
            if scrollView.contentOffset.y <= 2 {
               tableView!.isScrollEnabled = false
            }
        else
            {
                tableView!.isScrollEnabled = true
            }
            
        }else{
           
            // Dragging up
        }
    }
    /*func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        <#code#>
    }*/
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? AboutTableViewCell
        cell?.mapView.mapType = MKMapType.standard
        
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: locValue, span: span)
       cell?.mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = locValue
        annotation.title = "Javed Multani"
        annotation.subtitle = "current location"
        cell?.mapView.addAnnotation(annotation)
        
        //centerMap(locValue)
    }
    
}

extension AboutProfileController : ProfileServiceDelegate{
    
    func DidReceiveError(error: String) {
        DispatchQueue.main.async {
            self.stopRefreshing()
            print("error")
        }
    }
    
    func DidReceiveProfileData(item: ProfileData) {
        print("Profile in about : \(item)")
        
        DispatchQueue.main.sync {
            self.stopRefreshing()
            self.profileItem = item
            //viewWillAppear(true)
            //setupViews()
            tableView.reloadData()
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
            if self.activityIndicator.isAnimating{
                self.activityIndicator.stopAnimating()
                
            }
            
        }
    }
    
    func DidReceiveFeedItems(items: [FeedV2Item],pictureItems: [PictureURL]) {
        /*DispatchQueue.main.async {
            self.stopRefreshing()
            self.datasource = pictureItems
            print("Now on picture \(self.datasource)")
            if self.profile != nil && !self.datasource.isEmpty {
                print("Profile item : \(String(describing: self.profile)), Picture : \(self.datasource)")
                self.configPictureURL(profileItem: self.profile, dataSource: self.datasource)
                if self.activityIndicator.isAnimating{
                    self.activityIndicator.stopAnimating()
                    self.noPhotoLbl.isHidden = true
                }
            }
            else {
                print("Profile in photos is empty")
            }
            self.collectionView.reloadData()
        }*/
    }
    
    private func stopRefreshing(){
        if activityIndicator.isAnimating{
            activityIndicator.stopAnimating()
        }
    }
}

extension AboutProfileController: AboutProfileViewDelegate{
    func didTappedView(with type: ButtonTextType) {
        guard let item = profileItem else { return}
        /*switch type {
        case .website:
            if item.website != "" {
                let urlString = "http://" + item.website.replacingOccurrences(of: "http://", with: "").replacingOccurrences(of: "https://", with: "")
                if let url = URL(string: urlString) {
                    let svc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
                    svc.preferredBarTintColor = UIColor.GREEN_PRIMARY
                    self.present(svc, animated: true, completion: nil)
                }
            }
        case .phone:
            if item.phone != ""{
                if let url = URL(string: "tel://\(item.phone)") {
                    if UIApplication.shared.canOpenURL(url){
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            }
        default:
            print(type.rawValue)
        }*/
    }
}

extension AboutProfileController: BusinessCardTap {
    func businessCardTap(cell: UICollectionViewCell?, index: Int, dataSource: [PictureURL]) {
        
        let galleryPreview = INSPhotosViewController(photos: dataSource, initialPhoto: dataSource[index], referenceView: cell)
        present(galleryPreview, animated: true, completion: nil)
        
    }
}
    
  



protocol AboutProfileViewDelegate: class{
    func didTappedView(with type: ButtonTextType)
}

class AboutProfileView: UIView{
    
    private var type:ButtonTextType = .location
    
    weak var delegate : AboutProfileViewDelegate?
    
    private let imageView: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
   
    private let label: UILabel = {
        let lbl = UILabel()
        lbl.font = Fonts.DESIG_FONT
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let detailLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = Fonts.DESIG_FONT
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let borderView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.IMAGE_BG_COLOR
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let button: UIButton = {
        let btn = UIButton()
        btn.setTitle("[Show on map]", for: .normal)
        btn.tintColor = UIColor.black.withAlphaComponent(0.1)
        btn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews(){
        //addSubview(imageView)
        addSubview(label)
        addSubview(detailLabel)
        addSubview(button)
        addSubview(borderView)
        
        
        label.anchor(leading: leadingAnchor, trailing: nil, top: nil, bottom: nil, size: CGSize(width: 100, height: 20))
        detailLabel.anchor(leading: label.trailingAnchor, trailing: nil, top: nil, bottom: nil, size: CGSize(width: 200, height: 20))
        button.anchor(leading: detailLabel.trailingAnchor, trailing: nil, top: nil, bottom: nil, padding: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0))
        print("Button anchor : \(button.width), height \(button.height)")
        borderView.anchor(leading: leadingAnchor, trailing: trailingAnchor, top: nil, bottom: bottomAnchor, size: CGSize(width: 0, height: 0.5))
        self.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        detailLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        
        
        //imageView.anchor(leading: leadingAnchor, trailing: nil, top: nil, bottom: nil, size: CGSize(width: 20, height: 20))
        
        //imageView.anchor(leading: leadingAnchor, trailing: nil, top: nil, bottom: nil, size: CGSize(width: 20, height: 20))
        //label.anchor(leading: imageView.trailingAnchor, trailing: trailingAnchor, top: nil, bottom: nil,padding: UIEdgeInsets.init(top: 0, left: 8, bottom: 0, right: 0))
        
        
        //imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(AboutProfileView.tappedView))
        tap.numberOfTapsRequired = 1
        self.addGestureRecognizer(tap)
        
    }
    
    @objc private func buttonAction() {
        
    }
    
    @objc private func tappedView(){
        delegate?.didTappedView(with: type)
    }
    
    
    convenience init(viewType: ButtonTextType, title:String){
        self.init(frame: .zero)
        detailLabel.text = title
        /*label.text = title
        type = viewType
        switch viewType {
        case .phone:
            setImage(with: #imageLiteral(resourceName: "ic_phone"), enabled: true)
        case .website:
            setImage(with: #imageLiteral(resourceName: "ic_web"), enabled: true)
        case .address:
            setImage(with: #imageLiteral(resourceName: "ic_location_on_48pt"), enabled: false)
        case .info:
            setImage(with: #imageLiteral(resourceName: "ic_info"), enabled: false)
        case .joined:
            setImage(with: #imageLiteral(resourceName: "ic_access_time_black_48dp"), enabled: false)
        }*/
        
        type = viewType
        switch viewType {
        case .phone:
            print("No need changes")
        case .website:
            print("No need changes")
        case .address:
              label.text = "I'm here to:"
        case .card:
            print("No need changes")
        case .location:
            label.text = "I'm from:"
            // button.isHidden = false
        case .hereto:
            label.text = "I'm here to:"            
        case .profession:
            label.text = "I'm:"
        case .interested:
            label.text = "I'm interested in:"
        case .dateofjoining:
            label.text = "Member since:"
        case .info:
            print("No need changes")
        case .joined:
            print("No need changes")
        case .userBio:
            label.text = "Bio:"
        }
    }
    
    private func setImage(with img: UIImage, enabled: Bool){
        imageView.image = img.withRenderingMode(.alwaysTemplate)
        if enabled{
            label.textColor = UIColor.GREEN_PRIMARY
            self.isUserInteractionEnabled = true
            imageView.tintColor = UIColor.GREEN_PRIMARY
        } else {
            label.textColor = UIColor.BLACK_ALPHA
            self.isUserInteractionEnabled = false
            imageView.tintColor = UIColor.BLACK_ALPHA
        }
    }
}





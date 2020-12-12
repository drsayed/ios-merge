//
//  CompanyOverViewVC.swift
//  myscrap
//
//  Created by MyScrap on 6/19/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import MessageUI
import SafariServices

class CompanyOverViewVC: UIViewController , FriendControllerDelegate, MKMapViewDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var callBtnImg: UIButton!
    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var directBtnImg: UIButton!
    @IBOutlet weak var directionBtn: UIButton!
    @IBOutlet weak var emailBtnImg: UIButton!
    @IBOutlet weak var emailBtn: UIButton!
    @IBOutlet weak var webBtnImg: UIButton!
    @IBOutlet weak var webBtn: UIButton!
    @IBOutlet weak var empCountBtn: UIButton!
    @IBOutlet weak var placeLbl: UILabel!
    @IBOutlet weak var mapShowBtn: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var offAddressLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var websiteLbl: UILabel!
    @IBOutlet weak var mbrshipBtnImg: UIButton!
    @IBOutlet weak var mbrshipTypeLbl: UILabel!
    @IBOutlet weak var mbrshipYearsBtn: CorneredButton!
    @IBOutlet weak var timingHeightConstriant: NSLayoutConstraint!
    @IBOutlet weak var timingView: UIView!
    @IBOutlet weak var timingBtn: UIButton!
    @IBOutlet weak var mapViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mapOverallHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mapSeperatorView: UIView!
    
    @IBOutlet weak var mapBtn: UIButton!
    
    @IBOutlet weak var timingStackView: UIStackView!
    @IBOutlet weak var officeOpenLbl: UILabel!
    @IBOutlet weak var officeCloseLbl: UILabel!
    @IBOutlet weak var firstDayLbl: UILabel!
    @IBOutlet weak var openTimingDay: UILabel!
    @IBOutlet weak var openTiming: UILabel!
    @IBOutlet weak var dayoneTimeLbl: UILabel!
    @IBOutlet weak var dayTwoLbl: UILabel!
    @IBOutlet weak var dayTwoTimeLbl: UILabel!
    @IBOutlet weak var dayThreeLbl: UILabel!
    @IBOutlet weak var dayThreeTimeLbl: UILabel!
    @IBOutlet weak var dayFourLbl: UILabel!
    @IBOutlet weak var dayFourTimeLbl: UILabel!
    @IBOutlet weak var dayFiveLbl: UILabel!
    @IBOutlet weak var dayFiveTimeLbl: UILabel!
    @IBOutlet weak var daySixLbl: UILabel!
    @IBOutlet weak var daySixTimeLbl: UILabel!
    @IBOutlet weak var daySevLbl: UILabel!
    @IBOutlet weak var daySevTimeLbl: UILabel!
    @IBOutlet weak var aboutTextView: UITextView!
    @IBOutlet weak var aboutHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var empTVHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var employeeView: UIView!
    @IBOutlet weak var employeeStackView: UIStackView!
    
    
    var service = CompanyUpdatedService()
    var dataSource = [CompanyItems]()
    weak var delegate: CompanyUpdatedServiceDelegate?
    
    var company_lat = 0.0
    var company_long = 0.0
    
    var locationManager:CLLocationManager!
    
    override func loadView() {
        super.loadView()
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        
        
        //timingHeightConstriant.constant = 45
        //timingStackView.isHidden = true
//        mapViewHeightConstraint.constant = 0
//        mapOverallHeightConstraint.constant = 60
//        mapBtn.setTitle("[Show Map]", for: .normal)
//        mapSeperatorView.isHidden = true
        
        let timingViewTap = UITapGestureRecognizer(target: self, action: #selector(officeTimingGesture(_:)))
        timingView.addGestureRecognizer(timingViewTap)
        
        //empTVHeightConstraint.constant = 0
        //tableView.isHidden = true
        
        mapView.delegate = self
        mapView.isScrollEnabled = false
        mapView.isZoomEnabled = false
        mapView.isPitchEnabled = false
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(triggerTouchAction(_:)))
        mapView.addGestureRecognizer(gestureRecognizer)
        
        // Do any additional setup after loading the view.
    }
    
    func setupTableView() {
        //var frame = tableView.frame
        //frame.size.height = tableView.contentSize.height
        //tableView.frame = frame
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    func adjustUITextViewHeight(arg : UITextView)
    {
        //arg.translatesAutoresizingMaskIntoConstraints = true
        //arg.sizeToFit()
        arg.isScrollEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupTableView()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        service.delegate = self
        let companyId = UserDefaults.standard.object(forKey: "companyId") as? String
        service.getCompanyDetails(companyId: companyId!)
    }
    
    /*override func viewDidLayoutSubviews(){
         //tableView.frame = CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, tableView.contentSize.height)
        setupTableView()
        tableView.reloadData()
    }*/
    
    @IBAction func callBtnTapped(_ sender: UIButton) {
        let valid = self.validNumber()
        if valid != "" {
            if let phoneCallURL = URL(string: "telprompt://\(valid)") {
                
                let application:UIApplication = UIApplication.shared
                if (application.canOpenURL(phoneCallURL)) {
                    if #available(iOS 10.0, *) {
                        application.open(phoneCallURL, options: [:], completionHandler: nil)
                    } else {
                        // Fallback on earlier versions
                        application.openURL(phoneCallURL as URL)
                    }
                } else {
                    print("Can't open the url to make call")
                }
            } else {
                print("Phone num url not in proper format")
            }
        } else {
            print("Couldn't make a call for company Invalid number")
            let alert = UIAlertController(title: "Phone number not provided", message: nil, preferredStyle: .alert)
            alert.view.tintColor = UIColor.GREEN_PRIMARY
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func directionBtnTapped(_ sender: UIButton) {
        let coordinate = CLLocationCoordinate2DMake(company_lat,company_long)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        let companyName = UserDefaults.standard.object(forKey: "companyName") as! String
        mapItem.name = companyName
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }
    
    @objc func triggerTouchAction(_ gestureReconizer: UIGestureRecognizer) {
        //Add alert to show it works
        let coordinate = CLLocationCoordinate2DMake(company_lat,company_long)
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
        let companyName = UserDefaults.standard.object(forKey: "companyName") as! String
        mapItem.name = companyName
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }
    
    @IBAction func emailBtnTapped(_ sender: UIButton) {
        let email = self.dataSource.last!.email
        if email != "" {
            sendMail(with: email)
        } else {
            let alert = UIAlertController(title: "Email not provided", message: nil, preferredStyle: .alert)
            alert.view.tintColor = UIColor.GREEN_PRIMARY
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func websiteBtnTapped(_ sender: UIButton) {
        let website = self.dataSource.last!.website
        if self.dataSource.last?.website != "" {
            if website.contains("http://") || website.contains("https://") {
                let url = URL(string:website)!
                print(" website label : \(url), \(website)")
                let svc = SFSafariViewController(url: url)
                present(svc, animated: true, completion: nil)
            } else {
                let url = URL(string: "http://" + website)!
                print(" website label : \(url), \(website)")
                let svc = SFSafariViewController(url: url)
                present(svc, animated: true, completion: nil)
            }
            
        } else {
            let alert = UIAlertController(title: "Website not found", message: nil, preferredStyle: .alert)
            alert.view.tintColor = UIColor.GREEN_PRIMARY
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func validNumber() -> String {
        var phoneNumWithPlus = ""
        let phone = self.dataSource.last!.phone
        if phone.contains("+") {
            phoneNumWithPlus = phone
        } else {
            phoneNumWithPlus = "+" + phone
        }
        let scanner = Scanner(string: phone)
        
        if phoneNumWithPlus != "-" {
            let validChar = CharacterSet.decimalDigits
            let startChar = validChar.union(CharacterSet(charactersIn: "+"))
            
            var digits : NSString?
            var validNum = ""
            while !scanner.isAtEnd {
                if scanner.scanLocation == 0 {
                    scanner.scanCharacters(from: startChar, into: &digits)
                } else {
                    scanner.scanCharacters(from: validChar, into: &digits)
                }
                scanner.scanUpToCharacters(from: validChar, into: nil)
                
                if let digit = digits as String? {
                    validNum.append(digit)
                }
            }
            print("Valid number : \(validNum)")
            return validNum
        } else {
            let alert = UIAlertController(title: "Invalid number found", message: nil, preferredStyle: .alert)
            alert.view.tintColor = UIColor.GREEN_PRIMARY
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        return ""
    }
    
    func sendMail(with email: String){
        print("Email is : \(email.isValidEmail())")
        if MFMailComposeViewController.canSendMail() , email.isValidEmail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([email])
            present(mail, animated: true, completion: nil)
        }
        else {
            showToast(message: "Can't connect through email, not a valid email ID found")
        }
    }
    
    
    @objc func officeTimingGesture(_ recognizer: UIGestureRecognizer) {
        
        //timingHeightConstriant.constant = 239
    }
    @IBAction func emplListTapped(_ sender: UIButton) {
        if sender.tag == 0 {
            tableView.isHidden = true
            empTVHeightConstraint.constant = 0
            sender.tag = 1
            
        } else {
            
            //view.layoutIfNeeded()
            //var frame = tableView.frame
            //frame.size.height = tableView.contentSize.height
            //tableView.frame = frame
            empTVHeightConstraint.constant = tableView.contentSize.height
            tableView.isHidden = false
            sender.tag = 0
        }
    }
    
    @IBAction func officeTimingTapped(_ sender: UIButton) {
        if sender.tag == 0 {
//            mapSeperatorView.isHidden = false
            timingStackView.isHidden = true
            timingHeightConstriant.constant = 45
           
            sender.tag = 1
        } else {
//            mapSeperatorView.isHidden = true
             timingHeightConstriant.constant = 120   //239
            timingStackView.isHidden = false
            sender.tag = 0
        }
    }
    @IBAction func mapBtnTapped(_ sender: UIButton) {
        if sender.tag == 0 {
            mapOverallHeightConstraint.constant = 246
            mapViewHeightConstraint.constant = 186
            mapBtn.setTitle("[Hide Map]", for: .normal)
            sender.tag = 1
        } else {
            mapOverallHeightConstraint.constant = 60
            mapViewHeightConstraint.constant = 0
            mapBtn.setTitle("[Show Map]", for: .normal)
            sender.tag = 0
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue:CLLocationCoordinate2D = manager.location!.coordinate
        
        mapView.mapType = MKMapType.standard
        
        let span =  MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: locValue, span: span)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = locValue
        annotation.title = "MyScrap"
        annotation.subtitle = "current location"
        mapView.addAnnotation(annotation)
        
        //centerMap(locValue)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        if !(annotation is MKPointAnnotation) {
            return nil
        }
        
        let annotationIdentifier = "AnnotationIdentifier"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView!.canShowCallout = true
        }
        else {
            annotationView!.annotation = annotation
        }
        
        let pinImage = UIImage(named: "marker")
        annotationView!.image = pinImage
        return annotationView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.dataSource.count != 0 {
            if self.dataSource.last!.employees.count != 0 {
                return self.dataSource.last!.employees.count
            } else {
                return 0
            }
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: OverviewEmployeeListCell = tableView.dequeueReusableCell(withIdentifier: "overview_emp_list", for: indexPath) as! OverviewEmployeeListCell
        
        print("Name : \(self.dataSource.last!.employees[indexPath.row].first_name)  \(self.dataSource.last!.employees[indexPath.row].last_name)")
        print("Designation : \(self.dataSource.last!.employees[indexPath.row].designation)")
        print("company Name: \(self.dataSource.last!.employees[indexPath.row].companyName)")
        
        let name = self.dataSource.last!.employees[indexPath.row].first_name + " " + self.dataSource.last!.employees[indexPath.row].last_name
        let designation = self.dataSource.last!.employees[indexPath.row].designation
        let company = self.dataSource.last!.employees[indexPath.row].companyName
        cell.nameLbl.text = name
        cell.compDesigLbl.text = designation + " • " + company.capitalized
        
        cell.profileView.isUserInteractionEnabled = true
        let profiletap = UITapGestureRecognizer(target: self, action: #selector(toFriendView(_:)))
        profiletap.numberOfTapsRequired = 1
        cell.profileView.tag = indexPath.row
        cell.profileView.addGestureRecognizer(profiletap)
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(toFriendView(_:)))
        tap.numberOfTapsRequired = 1
        cell.nameLbl.tag = indexPath.row
        cell.nameLbl.isUserInteractionEnabled = true
        cell.nameLbl.addGestureRecognizer(tap)
        
        let destiTap = UITapGestureRecognizer(target: self, action: #selector(toFriendView(_:)))
        destiTap.numberOfTapsRequired = 1
        cell.compDesigLbl.tag = indexPath.row
        cell.compDesigLbl.isUserInteractionEnabled = true
        cell.compDesigLbl.addGestureRecognizer(destiTap)
        
        let profilePic = self.dataSource.last!.employees[indexPath.row].profilePic
        let colorCode = self.dataSource.last!.employees[indexPath.row].colorcode
        
        cell.profileView.updateViews(name: name, url: profilePic,  colorCode: colorCode)
        let isAdmin = dataSource.last!.employees[indexPath.row].isAdmin
        let isAdminView = dataSource.last!.employees[indexPath.row].isAdminView
        let isEmplView = dataSource.last!.employees[indexPath.row].isEmployeeView
        if isAdminView {
                if isAdmin {
                    cell.makeAsAdminBtn.setTitle("Admin", for: .normal)
                } else {
                    cell.makeAsAdminWidthConstraint.constant = 120
                    cell.makeAsAdminBtn.setTitle("Make as Admin", for: .normal)
                }
            //tableView.reloadData()
        } else {
            if isEmplView {
                if isAdmin {
                    cell.makeAsAdminWidthConstraint.constant = 80
                    cell.makeAsAdminBtn.setTitle("Admin", for: .normal)
                } else {
                    cell.makeAsAdminBtn.isHidden = true
                }
            }
            //tableView.reloadData()
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
    }
    
    @objc private func toFriendView(_ sender: UITapGestureRecognizer){
        let userId = dataSource.last!.employees[sender.view!.tag].userId
        performFriendView(friendId: userId)
    }

}
extension CompanyOverViewVC : CompanyUpdatedServiceDelegate {
    func didReceiveCompanyValues(data: [CompanyItems]) {
        DispatchQueue.main.async {
            
            
            
            self.dataSource = data
            
            self.tableView.reloadData()
            self.view.layoutIfNeeded()
            var frame = self.tableView.frame
            frame.size.height = self.tableView.contentSize.height
            self.tableView.frame = frame
            self.empTVHeightConstraint.constant = self.tableView.contentSize.height
            self.tableView.isHidden = false
            
            //Updating values into vc
            if self.dataSource.last!.employeeCount == 0 {
                self.empCountBtn.setTitle("No Employees", for: .normal)
                self.empCountBtn.isUserInteractionEnabled = false
            } else {
                self.empCountBtn.isUserInteractionEnabled = true
                self.empCountBtn.setTitle(String(self.dataSource.last!.employeeCount) + " Employees", for: .normal)
            }
            /*
            var frame = self.tableView.frame
            frame.size.height = self.tableView.contentSize.height
            self.tableView.frame = frame
            */
            /*var viewFrame = self.employeeView.frame
            viewFrame.size.height = self.tableView.height
            self.employeeView.frame = viewFrame
            */
            
            self.openTimingDay.text = self.dataSource.last!.openTimingDay
            self.openTiming.text = self.dataSource.last!.openTiming
            
            self.timingHeightConstriant.constant = 120   //239
            self.timingStackView.isHidden = false
            
            if self.dataSource.last!.address == "" {
                self.offAddressLbl.text = "-"
            } else {
                self.offAddressLbl.text = self.dataSource.last!.address
            }
            
            
            //Office Timings :
            /*var day = self.dataSource.last!.officeTimings
            if day != [] {
                let first = day[0]
                let listRange = first.range(of: "\t")
                let first_day = first[first.startIndex..<listRange!.lowerBound]
                let first_time = first[listRange!.upperBound..<first.endIndex]
                self.firstDayLbl.text = String(first_day)
                self.dayoneTimeLbl.text = String(first_time)
                
                let two = day[1]
                let twoRange = two.range(of: "\t")
                let two_day = two[two.startIndex..<twoRange!.lowerBound]
                let two_time = two[twoRange!.upperBound..<two.endIndex]
                self.dayTwoLbl.text = String(two_day)
                self.dayTwoTimeLbl.text = String(two_time)
                
                let three = day[2]
                let threeRange = three.range(of: "\t")
                let three_day = three[three.startIndex..<threeRange!.lowerBound]
                let three_time = three[threeRange!.upperBound..<three.endIndex]
                self.dayThreeLbl.text = String(three_day)
                self.dayThreeTimeLbl.text = String(three_time)
                
                let four = day[3]
                let fourRange = four.range(of: "\t")
                let four_day = four[four.startIndex..<fourRange!.lowerBound]
                let four_time = four[fourRange!.upperBound..<four.endIndex]
                self.dayFourLbl.text = String(four_day)
                self.dayFourTimeLbl.text = String(four_time)
                
                let five = day[4]
                let fiveRange = five.range(of: " ")
                let five_day = five[five.startIndex..<fiveRange!.lowerBound]
                let five_time = five[fiveRange!.upperBound..<five.endIndex]
                self.dayFiveLbl.text = String(five_day)
                self.dayFiveTimeLbl.text = String(five_time)
                
                let six = day[5]
                let sixRange = six.range(of: "\t")
                let six_day = six[six.startIndex..<sixRange!.lowerBound]
                let six_time = six[sixRange!.upperBound..<six.endIndex]
                self.daySixLbl.text = String(six_day)
                self.daySixTimeLbl.text = String(six_time)
                
                let seven = day[6]
                let sevenRange = seven.range(of: "\t")
                let seven_day = seven[seven.startIndex..<sevenRange!.lowerBound]
                let seven_time = seven[sevenRange!.upperBound..<seven.endIndex]
                self.daySevLbl.text = String(seven_day)
                self.daySevTimeLbl.text = String(seven_time)
            }*/
            
//                self.placeLbl.text = self.dataSource.last!.place
            if self.dataSource.last!.phone != "" {
                self.phoneLbl.text = self.dataSource.last!.phone
            } else {
                self.phoneLbl.text = "-"
            }
            
            if self.dataSource.last!.email == "" {
                self.emailLbl.text = "-"
            } else {
                self.emailLbl.text = self.dataSource.last!.email
            }
            
            if self.dataSource.last!.website == "no" || self.dataSource.last!.website == ""{
                self.websiteLbl.text = "-"
            } else {
                self.websiteLbl.text = self.dataSource.last!.website
            }
            //self.mbrshipTypeLbl.text = self.dataSource.last!.membershipType.firstLetterUppercased() + " member"
            //self.mbrshipYearsBtn.setTitle(self.dataSource.last!.membershipYearsCount, for: .normal)
            if self.dataSource.last!.compnayAbout == "" {
                //self.aboutHeightConstraint.constant = 40
                self.aboutTextView.text = "-"
            } else {
                
                //self.aboutHeightConstraint.constant = 400
                self.aboutTextView.text = self.dataSource.last!.compnayAbout
            }
            self.adjustUITextViewHeight(arg : self.aboutTextView)
            
            //let area = self.dataSource.last!.employees.last!.country
            let area = "Dubai"
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(area) { (placemarks, error) in
                if((error) != nil){
                    print("Error", error ?? "")
                }
                if let placemark = placemarks?.first {
                    let coordinates:CLLocationCoordinate2D = placemark.location!.coordinate
                    print("Lat: \(coordinates.latitude) -- Long: \(coordinates.longitude)")
                    
                    self.mapView.mapType = MKMapType.standard
                    
                    let lat = self.dataSource.last?.lat
                    let long = self.dataSource.last?.long
                    self.company_lat = lat!
                    self.company_long = long!
                    UserDefaults.standard.set(self.company_lat, forKey: "compLat")
                    UserDefaults.standard.set(self.company_long, forKey: "compLong")
                    let center = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
                    let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.06, longitudeDelta: 0.06))
                    
                    //set region on the map
                    self.mapView.setRegion(region, animated: true)
                    
                    
                    //let span = MKCoordinateSpanMake(0.08, 0.08)
                    //let region = MKCoordinateRegion(center: coordinates, span: span)
                    //self.mapView.setRegion(region, animated: true)
                    let company_name = UserDefaults.standard.object(forKey: "companyName") as? String
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = center
                    //annotation.title = company_name
                    //annotation.subtitle = area
                    self.mapView.addAnnotation(annotation)
                }
                
            }
        }
    }
    
    func DidReceivedError(error: String) {
        print("Error while loading OverviewVC : \(error)")
    }
    
    
}

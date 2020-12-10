//
//  CompanyReviewVC.swift
//  myscrap
//
//  Created by MyScrap on 6/19/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit
import Cosmos
import MapKit
import CoreLocation
import MessageUI
import SafariServices

class CompanyReviewVC: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var callBtnImg: UIButton!
    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var directBtnImg: UIButton!
    @IBOutlet weak var directionBtn: UIButton!
    @IBOutlet weak var emailBtnImg: UIButton!
    @IBOutlet weak var emailBtn: UIButton!
    @IBOutlet weak var webBtnImg: UIButton!
    @IBOutlet weak var webBtn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tvHeightConstrait: NSLayoutConstraint!
    @IBOutlet weak var five_bar: CircleView!
    @IBOutlet weak var four_bar: CircleView!
    @IBOutlet weak var three_bar: CircleView!
    @IBOutlet weak var two_bar: CircleView!
    @IBOutlet weak var one_bar: CircleView!
    @IBOutlet weak var five_barWidth: NSLayoutConstraint!
    @IBOutlet weak var four_barWidth: NSLayoutConstraint!
    
    @IBOutlet weak var three_barWidth: NSLayoutConstraint!
    @IBOutlet weak var two_barWidth: NSLayoutConstraint!
    @IBOutlet weak var one_barWidth: NSLayoutConstraint!
    
    @IBOutlet weak var avgRatingLbl: UILabel!
    @IBOutlet weak var totalReviewCountLbl: UILabel!
    @IBOutlet weak var profileView: ProfileView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var starRate: CosmosView!
    @IBOutlet weak var avgStarRate: CosmosView!
    @IBOutlet weak var review_textView: UITextView!
    @IBOutlet weak var postBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var reviewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var seperatorHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cancelBtnHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var postBtnHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var totalReviewTitleLbl: UILabel!
    var service = CompanyUpdatedService()
    
    weak var delegate: CompanyUpdatedServiceDelegate?
    
    var review_service = ReviewService()
    var dataSource = [UserReview]()
    var review_delegate: ReviewServiceDelegate?
    
    var phone = ""
    var email = ""
    var web = ""
    var company_lat = 0.0
    var company_long = 0.0
    var company_name = ""
    
    var locationManager:CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        
        self.hideKeyboardWhenTappedAround()
        //service.delegate = self
        
        
        starRate.didFinishTouchingCosmos = { rating in
            let vc = ReviewPopupVC.storyBoardInstance()
            vc?.rating = rating
            //vc?.navigationItem.title = "Admin View"
            if let cname = UserDefaults.standard.object(forKey: "companyName") as? String {
                //vc?.navigationItem.backBarButtonItem = UIBarButtonItem(title: cname, style: .plain, target: nil, action: nil)
                vc?.navigationItem.title = cname
            }
            
            //vc?.navigationItem.backBarButtonItem = UIBarButtonItem(title: self.company_name, style: .plain, target: nil, action: nil)
            self.navigationController?.pushViewController(vc!, animated: true)
            
        }
        avgStarRate.settings.updateOnTouch = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        service.delegate = self
        let companyId = UserDefaults.standard.object(forKey: "companyId") as? String
        service.getCompanyDetails(companyId: companyId!)
        
        review_service.delegate = self
        setupTableView()
        //let companyId = UserDefaults.standard.object(forKey: "companyId") as? String
        //service.getCompanyDetails(companyId: companyId!)
        review_service.reviewFetch(companyId: companyId!)
    }
    
    func setupTextView() {
        review_textView.delegate = self
        
        //review_textView.clipsToBounds = true
        //review_textView.layer.cornerRadius = 5
        //let color = UIColor.lightGray.withAlphaComponent(0.3)
        //review_textView.layer.borderColor = color.cgColor
        //review_textView.layer.borderWidth = 1
        
        review_textView.text = "Share details of your own experience at this place"
        review_textView.textColor = .lightGray
        
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        //tableView.register(EmployeeListTVCell.self, forCellReuseIdentifier: "employeeList")
        //tableView.isScrollEnabled = true
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Share details of your own experience at this place"
            textView.textColor = UIColor.lightGray
        }
    }
    
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
            let alert = UIAlertController(title: "Invalid number found", message: nil, preferredStyle: .alert)
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
        if email != "" {
            sendMail(with: email)
        } else {
            let alert = UIAlertController(title: "Invalid email found", message: nil, preferredStyle: .alert)
            alert.view.tintColor = UIColor.GREEN_PRIMARY
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func websiteBtnTapped(_ sender: UIButton) {
        let website = self.web
        if website != "no" || website != "" {
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
    
    @IBAction func postBtnTapped(_ sender: UIButton) {
        /*if starRate.rating == 0.0 {
            let alert = UIAlertController(title: "Please Rate the company", message: nil, preferredStyle: .alert)
            alert.view.tintColor = UIColor.GREEN_PRIMARY
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            if review_textView.text == "Share details of your own experience at this place" {
                let spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
                spinner.mode = MBProgressHUDMode.indeterminate
                spinner.label.text = "Submiting Review"
                let trim = review_textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
                let companyId = UserDefaults.standard.object(forKey: "companyId") as! String
                review_service.submitReview(companyId: companyId, userId: AuthService.instance.userId, reviewText: "", rating: String(starRate.rating))
            } else {
                let spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
                spinner.mode = MBProgressHUDMode.indeterminate
                spinner.label.text = "Submiting Review"
                let trim = review_textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
                let companyId = UserDefaults.standard.object(forKey: "companyId") as! String
                review_service.submitReview(companyId: companyId, userId: AuthService.instance.userId, reviewText: trim, rating: String(starRate.rating))
            }
            
        }*/
        
    }
    @IBAction func cancelBtnTapped(_ sender: UIButton) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataSource.count != 0 {
            
            return dataSource.count
        } else {
            
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CompanyReviewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CompanyReviewCell
        
        cell.delegate = self
        cell.userData = dataSource[indexPath.row]
        
        return cell
    }
    
    
    
    /*func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94
    }*/
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension CompanyReviewVC : CompanyUpdatedServiceDelegate {
    func didReceiveCompanyValues(data: [CompanyItems]) {
        DispatchQueue.main.async {
            self.phone = data.last!.phone
            self.email = data.last!.email
            self.web = data.last!.website
            self.company_lat = data.last!.lat
            self.company_long = data.last!.long
            self.company_name = data.last!.compnayName
        }
    }
    
    func DidReceivedError(error: String) {
        print("Error while loading company review")
    }
}
class ProgressView: UIView {
    
    var progress: CGFloat = 0
    var filledView: UIView
    
    override init(frame: CGRect) {
        filledView = UIView(frame: CGRect(x: frame.origin.x, y: frame.origin.y, width: 0, height: frame.height))
        filledView.backgroundColor = UIColor(hexString: "#f8b704")
        
        super.init(frame: frame)
        addSubview(filledView)
    }
    
    required init(coder aDecoder: NSCoder) { // <-- You need to implement this
        fatalError()
    }
    
    func setProgess(progress: CGFloat) {
        self.progress = min(max(progress, 0), 1) // Between 0 and 1
        self.progress = progress
        
        filledView.frame.size.width = self.frame.width * progress
    }
}
extension CompanyReviewVC : ReviewServiceDelegate {
    func didFetchReview(data: [ReviewItems]) {
        DispatchQueue.main.async {
            self.dataSource = data.last!.userReview
            
            for value in self.dataSource {
                if value.userId.contains(AuthService.instance.userId) {
                    //self.reviewHeightConstraint.constant = 0
                    //self.textViewHeightConstraint.constant = 0
                    //self.seperatorHeightConstraint.constant = 0
                    //self.cancelBtnHeightConstraint.constant = 0
                    //self.postBtnHeightConstraint.constant = 0
                    //self.cancelBtn.isHidden = true
                    //self.postBtn.isHidden = true
                    self.starRate.rating = value.ratting
                    self.starRate.settings.updateOnTouch = false
                } else {
                    self.starRate.settings.updateOnTouch = true
                    //self.reviewHeightConstraint.constant = 180
                    //self.textViewHeightConstraint.constant = 100
                    //self.seperatorHeightConstraint.constant = 1
                    //self.cancelBtnHeightConstraint.constant = 50
                    //self.postBtnHeightConstraint.constant = 50
                    //self.cancelBtn.isHidden = false
                    //self.postBtn.isHidden = false
                }
            }
       
            
            self.avgRatingLbl.text = data.last!.AvgRating
            self.avgStarRate.rating = (self.avgRatingLbl.text! as NSString).doubleValue
            self.totalReviewCountLbl.text = data.last!.totalReview + " reviews"
            self.totalReviewTitleLbl.text = "Total Reviews (" + String(data.last!.userReview.count) + ")"
            let rating = data.last!.ratingValues
            for value in rating {
                if value.rattingLable == "5" {
                    let percentage = Int(value.ratingPercentage)!
                    if percentage <= 10 && percentage >= 0{
                        self.five_bar.layer.cornerRadius = 0
                        self.five_bar.layer.masksToBounds = true
                        self.five_barWidth.constant = 10
                    } else if percentage <= 20 && percentage >= 10{
                        self.five_barWidth.constant = 40
                    } else if percentage <= 30 && percentage >= 20{
                        self.five_barWidth.constant = 60
                    } else if percentage <= 40 && percentage >= 30{
                        self.five_barWidth.constant = 80
                    } else if percentage <= 50 && percentage >= 40{
                        self.five_barWidth.constant = 100
                    } else if percentage <= 60 && percentage >= 50{
                        self.five_barWidth.constant = 120
                    } else if percentage <= 70 && percentage >= 60{
                        self.five_barWidth.constant = 140
                    } else if percentage <= 80 && percentage >= 70{
                        self.five_barWidth.constant = 160
                    } else if percentage <= 90 && percentage >= 80{
                        self.five_barWidth.constant = 180
                    } else {
                        self.five_barWidth.constant = 200
                    }
                } else if value.rattingLable == "4" {
                    let percentage = Int(value.ratingPercentage)!
                    if percentage <= 10 && percentage >= 0{
                        self.four_bar.layer.cornerRadius = 0
                        self.four_barWidth.constant = 10
                    } else if percentage <= 20 && percentage >= 10{
                        self.four_barWidth.constant = 40
                    } else if percentage <= 30 && percentage >= 20{
                        self.four_barWidth.constant = 60
                    } else if percentage <= 40 && percentage >= 30{
                        self.four_barWidth.constant = 80
                    } else if percentage <= 50 && percentage >= 40{
                        self.four_barWidth.constant = 100
                    } else if percentage <= 60 && percentage >= 50{
                        self.four_barWidth.constant = 120
                    } else if percentage <= 70 && percentage >= 60{
                        self.four_barWidth.constant = 140
                    } else if percentage <= 80 && percentage >= 70{
                        self.four_barWidth.constant = 160
                    } else if percentage <= 90 && percentage >= 80{
                        self.four_barWidth.constant = 180
                    } else {
                        self.four_barWidth.constant = 200
                    }
                } else if value.rattingLable == "3" {
                    let percentage = Int(value.ratingPercentage)!
                    if percentage <= 10 && percentage >= 0{
                        self.three_bar.layer.cornerRadius = 0
                        self.three_barWidth.constant = 10
                    } else if percentage <= 20 && percentage >= 10{
                        self.three_barWidth.constant = 40
                    } else if percentage <= 30 && percentage >= 20{
                        self.three_barWidth.constant = 60
                    } else if percentage <= 40 && percentage >= 30{
                        self.three_barWidth.constant = 80
                    } else if percentage <= 50 && percentage >= 40{
                        self.three_barWidth.constant = 100
                    } else if percentage <= 60 && percentage >= 50{
                        self.three_barWidth.constant = 120
                    } else if percentage <= 70 && percentage >= 60{
                        self.three_barWidth.constant = 140
                    } else if percentage <= 80 && percentage >= 70{
                        self.three_barWidth.constant = 160
                    } else if percentage <= 90 && percentage >= 80{
                        self.three_barWidth.constant = 180
                    } else {
                        self.three_barWidth.constant = 200
                    }
                } else if value.rattingLable == "2" {
                    let percentage = Int(value.ratingPercentage)!
                    if percentage <= 10 && percentage >= 0{
                        self.two_bar.layer.cornerRadius = 0
                        self.two_barWidth.constant = 10
                    } else if percentage <= 20 && percentage >= 10{
                        self.two_barWidth.constant = 40
                    } else if percentage <= 30 && percentage >= 20{
                        self.two_barWidth.constant = 60
                    } else if percentage <= 40 && percentage >= 30{
                        self.two_barWidth.constant = 80
                    } else if percentage <= 50 && percentage >= 40{
                        self.two_barWidth.constant = 100
                    } else if percentage <= 60 && percentage >= 50{
                        self.two_barWidth.constant = 120
                    } else if percentage <= 70 && percentage >= 60{
                        self.two_barWidth.constant = 140
                    } else if percentage <= 80 && percentage >= 70{
                        self.two_barWidth.constant = 160
                    } else if percentage <= 90 && percentage >= 80{
                        self.two_barWidth.constant = 180
                    } else {
                        self.two_barWidth.constant = 200
                    }
                } else if value.rattingLable == "1"{
                    let percentage = Int(value.ratingPercentage)!
                    print("1 percentage :\(percentage)")
                    if percentage <= 10 && percentage >= 0{
                        self.one_bar.layer.cornerRadius = 0
                        self.one_barWidth.constant = 10
                    } else if percentage <= 20 && percentage >= 10{
                        self.one_barWidth.constant = 40
                    } else if percentage <= 30 && percentage >= 20{
                        self.one_barWidth.constant = 60
                    } else if percentage <= 40 && percentage >= 30{
                        self.one_barWidth.constant = 80
                    } else if percentage <= 50 && percentage >= 40{
                        self.one_barWidth.constant = 100
                    } else if percentage <= 60 && percentage >= 50{
                        self.one_barWidth.constant = 120
                    } else if percentage <= 70 && percentage >= 60{
                        self.one_barWidth.constant = 140
                    } else if percentage <= 80 && percentage >= 70{
                        self.one_barWidth.constant = 160
                    } else if percentage <= 90 && percentage >= 80{
                        self.one_barWidth.constant = 180
                    } else {
                        self.one_barWidth.constant = 200
                    }
                } else {
                    print("Some weird value from api for rating bar")
                }
            }
            self.tableView.reloadData()
        }
    }
    
    func didReceiveReviewValues(status: String) {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
            
            //self.showMessage(with: status)
            let companyId = UserDefaults.standard.object(forKey: "companyId") as? String
            self.review_service.reviewFetch(companyId: companyId!)
            self.service.getCompanyDetails(companyId: companyId!)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateReview"), object: nil)
            
        }
    }
    
    func didReceivedError(error: String) {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
            //self.showMessage(with: error)
            print("Error in Compose email : \(error)")
        }
    }
}

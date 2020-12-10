//
//  CompanyInterestsVC.swift
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

class CompanyInterestsVC: BaseVC  {
    
    var service = CompanyUpdatedService()
    var dataSource = [CompanyItems]()
    weak var delegate: CompanyUpdatedServiceDelegate?
    
    let commodityService = Interests()
    
    var businessType = [String]()
    var commodities = [String]()
    var affiliation = [String]()
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var callBtnImg: UIButton!
    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var directBtnImg: UIButton!
    @IBOutlet weak var directionBtn: UIButton!
    @IBOutlet weak var emailBtnImg: UIButton!
    @IBOutlet weak var emailBtn: UIButton!
    @IBOutlet weak var webBtnImg: UIButton!
    @IBOutlet weak var webBtn: UIButton!
    
    var phone = ""
    var email = ""
    var web = ""
    var company_lat = 0.0
    var company_long = 0.0
    
    var locationManager:CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        setupCollectionView()
        
        service.delegate = self
        let companyId = UserDefaults.standard.object(forKey: "companyId") as? String
        service.getCompanyDetails(companyId: companyId!)
        
        
    }
    
    private func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        //view.layoutIfNeeded()
        //heightConstraint.constant = collectionView.collectionViewLayout.collectionViewContentSize.height
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension CompanyInterestsVC : CompanyUpdatedServiceDelegate {
    func didReceiveCompanyValues(data: [CompanyItems]) {
        DispatchQueue.main.async {
            if let busTypeArray = data.last?.businessTypeInterest.sorted(), let comArray = data.last?.commodityInterest.sorted(), let affArray = data.last?.affiliationInterest.sorted() {
                let obj = Interests()
                self.businessType = obj.getCompanyIndustries(input: busTypeArray)
                self.commodities = obj.getCompanyCommodities(input: comArray)
                self.affiliation = obj.getCompanyAffiliation(input: affArray)
                self.collectionView.reloadData()
                
                self.phone = data.last!.phone
                self.email = data.last!.email
                self.web = data.last!.website
                self.company_lat = data.last!.lat
                self.company_long = data.last!.long
            }
        }
    }
    
    func DidReceivedError(error: String) {
        print("Error while getting value in employee liset : \(error)")
    }
}

extension CompanyInterestsVC:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 1:
            return businessType.count
        case 4:
            return commodities.count
        case 7:
            return affiliation.count
        default:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "headerCell", for: indexPath) as! EditCompanyHeaderCell
            cell.label.text = "Business Type"
            return cell
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! EditCompanyCollectionCell
            cell.label.textColor = UIColor.WHITE_ALPHA
            cell.view.backgroundColor = UIColor.GREEN_PRIMARY
            cell.label.text = businessType[indexPath.item]
            return cell
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "separatorCell", for: indexPath) as! SeperatorCVCell
            cell.layoutIfNeeded()
            return cell
        case 3:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "headerCell", for: indexPath) as! EditCompanyHeaderCell
            cell.label.text = "Commodity"
            cell.layoutIfNeeded()
            return cell
        case 4:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! EditCompanyCollectionCell
            cell.label.textColor = UIColor.WHITE_ALPHA
            cell.view.backgroundColor = UIColor.GREEN_PRIMARY
            cell.label.text = commodities[indexPath.item]
            return cell
        case 5:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "separatorCell", for: indexPath) as! SeperatorCVCell
            cell.layoutIfNeeded()
            return cell
        case 6:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "headerCell", for: indexPath) as! EditCompanyHeaderCell
            cell.label.text = "Affiliation"
            cell.layoutIfNeeded()
            return cell
        case 7:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! EditCompanyCollectionCell
            cell.label.textColor = UIColor.WHITE_ALPHA
            cell.view.backgroundColor = UIColor.GREEN_PRIMARY
            cell.label.text = affiliation[indexPath.item]
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel()
        label.font = Fonts.DESIG_FONT
        
        switch indexPath.section {
            
        case 1:
            label.text = COMPANY_BUSINESS_TYPE_ARRAY[indexPath.item]
            return CGSize(width: label.intrinsicContentSize.width + 20, height: 40)
            
        case 2:
            //Seperator cell
            return CGSize(width: self.view.frame.width, height: 10)
            
        case 4:
            label.text = COMPANY_COMMODITY_ARRAY[indexPath.item]
            return CGSize(width: label.intrinsicContentSize.width + 20, height: 40)
            
        case 5:
            //Seperator Cell
            return CGSize(width: self.view.frame.width, height: 10)
            
        case 7:
            label.text = COMPANY_AFFILIATION_ARRAY[indexPath.item]
            return CGSize(width: label.intrinsicContentSize.width + 20, height: 40)
            
        default:
            return CGSize(width: self.view.frame.width, height: 35)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 1 || section == 4 || section == 7 {
            return UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        } else if section == 2 || section == 5 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        } else {
            return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        }
    }
}



//
//  CompanyDetailVC.swift
//  myscrap
//
//  Created by MyScrap on 6/20/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit
import Cosmos
import SDWebImage
import MapKit
import CoreLocation
import MessageUI
import SafariServices

class CompanyDetailVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    @IBOutlet weak var mainScroll: UIScrollView!
    var companyId : String?
    var companyImages : [String]?
    @IBOutlet weak var compName: UILabel!
    @IBOutlet weak var photoCV: UICollectionView!
    @IBOutlet weak var star: CosmosView!
    @IBOutlet weak var verifiedImg: UIButton!
    @IBOutlet weak var verifiedLbl: UILabel!
    @IBOutlet weak var yearImg: UIButton!
    @IBOutlet weak var yearLbl: UILabel!
    @IBOutlet weak var designationLbl: UILabel!
    var currentTabIndex : Int = 0
    @IBOutlet weak var affliationBtn: CorneredButton!
    @IBOutlet weak var isriBtn: CorneredButton!
    @IBOutlet weak var tabCV: UICollectionView!
    @IBOutlet weak var horizontalBar : UIView!
    @IBOutlet weak var horizontalBarWidthConstraint: NSLayoutConstraint?
    @IBOutlet weak var horizontalBarleftConstraint: NSLayoutConstraint?
    @IBOutlet weak var scrollView : UIScrollView!
    @IBOutlet weak var avgRatingLbl: UILabel!
    @IBOutlet weak var ownCompanyView: UIView!
    @IBOutlet weak var ownCompBtn: CorneredButton!
    @IBOutlet weak var commoImgOverView: CorneredView!
    @IBOutlet weak var commImgView: UIImageView!
    @IBOutlet weak var commoCount: UILabel!
    @IBOutlet weak var loadingView: UIView!
    
    @IBOutlet weak var insideScrollHeightConstraint: NSLayoutConstraint!
    
    //var titleArray = ["OVERVIEW", "EMPLOYEES", "REVIEWS", "PHOTOS", "INTEREST"]
    var titleArray = ["OVERVIEW", "UPDATES",  "INTEREST", "REVIEWS"] //["OVERVIEW", "UPDATES",  "MEDIA", "REVIEWS"]
    
    var service = CompanyUpdatedService()
    var dataSource = [CompanyItems]()
    weak var delegate: CompanyUpdatedServiceDelegate?
    
    let activityIndicator: UIActivityIndicatorView = {
        let av = UIActivityIndicatorView(style: .gray)
        av.hidesWhenStopped = true
        av.translatesAutoresizingMaskIntoConstraints = false
        return av
    }()

    var company_lat = 0.0
    var company_long = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        currentTabIndex = 0
        // Do any additional setup after loading the view.
        print("Company id : \(companyId)")
        
        //Initially button is hidden and disabled
        self.ownCompanyView.isHidden = true
        self.ownCompBtn.isHidden = true
        self.ownCompBtn.isEnabled = true
        self.commoImgOverView.isHidden = true
        self.commoImgOverView.layer.cornerRadius = 3
        self.commoImgOverView.layer.borderWidth = 0.5
        self.commoImgOverView.layer.borderColor = UIColor.black.cgColor
        self.commoImgOverView.clipsToBounds = true
        self.commoCount.isHidden = true
        self.commImgView.isHidden = true
        
        commoCount.layer.shadowColor = UIColor.black.cgColor
        commoCount.layer.shadowRadius = 3.0
        commoCount.layer.shadowOpacity = 1.0
        commoCount.layer.shadowOffset = CGSize(width: 4, height: 4)
        commoCount.layer.masksToBounds = false

        
        horizontalBarleftConstraint?.constant = 0
        horizontalBarWidthConstraint?.constant = self.view.frame.width / CGFloat(titleArray.count)
        
        view.addSubview(activityIndicator)
        activityIndicator.setTop(to: view.safeTop, constant: 30)
        activityIndicator.setHorizontalCenter(to: view.centerXAnchor)
        activityIndicator.setSize(size: CGSize(width: 30, height: 30))
        activityIndicator.startAnimating()
        service.getCompanyDetails(companyId: companyId!)
        service.delegate = self
        mainScroll.delegate = self
        setupCollectionView()
        
        star.text = "(2)"
        star.rating = 5
        
        affliationBtn.layer.borderColor = UIColor.MyScrapGreen.cgColor
        affliationBtn.layer.borderWidth = 1
        
        isriBtn.layer.borderColor = UIColor.MyScrapGreen.cgColor
        isriBtn.layer.borderWidth = 1
        NotificationCenter.default.addObserver(self, selector: #selector(handleReview(notif:)), name: NSNotification.Name(rawValue: "updateReview"), object: nil)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.hidesBackButton = false
        if self.navigationItem.title == "" {
            let companyName = UserDefaults.standard.object(forKey: "companyAdminView") as? String
            if companyName != "" {
                self.navigationItem.title = companyName
            } else {
                service.getCompanyDetails(companyId: companyId!)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationItem.title = " "
        NotificationCenter.default.post(name: Notification.Name("PauseAllProfileVideos"), object: nil)
        NotificationCenter.default.post(name: Notification.Name("PauseAllVideos"), object: nil)


    }
    
    @objc func handleReview(notif: Notification){
        service.getCompanyDetails(companyId: companyId!)
        service.delegate = self
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupCollectionView() {
        photoCV.delegate = self
        photoCV.dataSource = self
        
        photoCV.register(PhotoScrollCVCell.self, forCellWithReuseIdentifier: "photoScroll")
        
        scrollView.delegate = self
        scrollView.isScrollEnabled = true
        if scrollView.isTracking == true {
            print("Scroll view user interaction is enabled")
        }
        scrollView.keyboardDismissMode = .onDrag
        
        tabCV.dataSource = self
        tabCV.delegate = self
        tabCV.register(TabBarScrollCVCell.self, forCellWithReuseIdentifier: "tabScroll")
        //collectionView.register(TabBarScrollCVCell.self)
        
        if let flowLayout = tabCV.collectionViewLayout as? UICollectionViewFlowLayout{
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.scrollDirection = .horizontal
        }
        tabCV.isPagingEnabled = true
        tabCV.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .bottom)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == tabCV {
            print("Count : \(titleArray.count)")
            return titleArray.count
        } else {
            if dataSource.count != 0 {
                print("Value count in DS : \(dataSource.last?.companyImages.count)")
                return (dataSource.last?.companyImages.count)!
            } else {
                return 0
            }
            
        }
        
    }
    @IBAction func ownCompanyBtnTapped(_ sender: UIButton) {
        let vc = EditCompanyAdminViewVC.storyBoardInstance()
        vc?.navigationItem.title = "Admin View"
        vc?.companyId = self.companyId
        if self.navigationItem.title != nil {
            vc?.companyName = self.navigationItem.title!
        }
        vc?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == tabCV {
            let cell: TabBarScrollCVCell = collectionView.dequeueReusableCell(withReuseIdentifier: "tabScroll", for: indexPath) as! TabBarScrollCVCell
            print("Arra y values : \(titleArray[indexPath.item])")
            cell.label.text = titleArray[indexPath.item]
            print("Label width : \(cell.label.width)")
            return cell
        } else {
            let cell : PhotoScrollCVCell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoScroll", for: indexPath) as! PhotoScrollCVCell
            //        cell.compImage.image = #imageLiteral(resourceName: "pexels-photo-132038")
            let imgUrl = dataSource.last?.companyImages[indexPath.row]
            if let urlString = imgUrl , let url = URL(string: urlString){
                
                SDWebImageManager.shared().cachedImageExists(for: url) { (status) in
                    if status{
                        SDWebImageManager.shared().imageCache?.queryCacheOperation(forKey: url.absoluteString, done: { (image, data, type) in
                            
                            cell.compImage.image = image
                        })
                    } else {
                        SDWebImageManager.shared().imageDownloader?.downloadImage(with: url, options: SDWebImageDownloaderOptions.continueInBackground, progress: nil, completed: { (image, data, error, status) in
                            SDImageCache.shared().store(image, forKey: url.absoluteString)
                            
                            cell.compImage.image = image
                        })
                    }
                }
            } else {
                SDWebImageManager.shared().imageDownloader?.downloadImage(with: nil, progress: nil, completed: { (image, data, error, status) in
                    print("Company image cannot be downloaded : \(error)")
                })
            }
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == tabCV {
            let xOffset = self.scrollView.frame.width * CGFloat(indexPath.item)
            let point = CGPoint(x: xOffset, y: 0)
            self.currentTabIndex = indexPath.item
            if indexPath.item != 1 {
                NotificationCenter.default.post(name: Notification.Name("PauseAllVideos"), object: nil)
            }
            else
            {
                let screenRect = UIScreen.main.bounds
                let screenHeight = screenRect.size.height
                
                if mainScroll.contentOffset.y > 300 {
                    NotificationCenter.default.post(name: Notification.Name("PlayVideoFromTab"), object: nil)
                }else
                {
                    NotificationCenter.default.post(name: Notification.Name("PauseAllVideos"), object: nil)

                }
                
            }
            self.scrollView.setContentOffset(point, animated: true)
        } else {
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == tabCV {
            let num = CGFloat(titleArray.count)
            print("Cell width : \(self.view.frame.width / num)")
            return CGSize(width: self.view.frame.width / num, height: collectionView.frame.height)
        } else {
            if dataSource.count == 1 {
                return CGSize(width: collectionView.frame.width, height: 260)
            }
            return CGSize(width: 258, height: 260)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == photoCV {
            return 5
        } else {
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == photoCV {
            return 10
        } else {
            return 0
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if  scrollView == self.mainScroll {
            let screenRect = UIScreen.main.bounds
            let screenHeight = screenRect.size.height
            if scrollView.contentOffset.y < 300 {
                NotificationCenter.default.post(name: Notification.Name("PauseAllVideos"), object: nil)
            }
            else
            {
                if   self.currentTabIndex == 1 {
                    NotificationCenter.default.post(name: Notification.Name("PlayVideoFromTab"), object: nil)

                }

            }
        }
        else{
        guard scrollView == self.scrollView else { return }
        let num = CGFloat(titleArray.count)
        horizontalBarleftConstraint?.constant = self.scrollView.contentOffset.x / num
        print(self.scrollView.contentOffset)
        }
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard scrollView == self.scrollView else { return }
        let index = targetContentOffset.pointee.x / self.view.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        self.currentTabIndex = indexPath.item
        if indexPath.item != 1 {
            NotificationCenter.default.post(name: Notification.Name("PauseAllVideos"), object: nil)
        }
        else
        {
            let screenRect = UIScreen.main.bounds
            let screenHeight = screenRect.size.height
            if mainScroll.contentOffset.y > 300 {
                NotificationCenter.default.post(name: Notification.Name("PlayVideoFromTab"), object: nil)
            }else
            {
                NotificationCenter.default.post(name: Notification.Name("PauseAllVideos"), object: nil)

            }

        }
        tabCV.selectItem(at: indexPath, animated: true, scrollPosition: [])
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        segue.destination.view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    static func storyBoardInstance() -> CompanyDetailVC? {
        let st = UIStoryboard(name: "Companies", bundle: nil)
        return st.instantiateViewController(withIdentifier: CompanyDetailVC.id) as? CompanyDetailVC
    }

}
extension CompanyDetailVC: CompanyUpdatedServiceDelegate {
    func DidReceivedError(error: String) {
        print("Error while receiving company data : \(error)")
    }
    
    func didReceiveCompanyValues(data: [CompanyItems]) {
        DispatchQueue.main.async {
            self.dataSource = data
            
            // Showing values
            self.navigationItem.title = self.dataSource.last!.compnayName
            let lowerCased = self.dataSource.last!.compnayName.lowercased()
            self.compName.text = lowerCased.capitalized
            UserDefaults.standard.set(self.navigationItem.title, forKey: "companyName")
            UserDefaults.standard.set(self.navigationItem.title, forKey: "companyAdminView")
            
            if self.dataSource.last?.companyType == "" {
                self.designationLbl.text = "Not provided"
            } else {
                self.designationLbl.text = self.dataSource.last?.interest.last?.industry.last
            }
            self.avgRatingLbl.text = self.dataSource.last?.AvgRating
            self.affliationBtn.setTitle(self.dataSource.last?.affiliation.first, for: .normal)
            self.isriBtn.setTitle(self.dataSource.last?.affiliation.last, for: .normal)
            self.star.rating = (self.avgRatingLbl.text! as NSString).doubleValue
            self.star.text = " (" + self.dataSource.last!.totalReview + ")"
            /*
            if self.dataSource.last?.verified == true {
                self.verifiedLbl.isHidden = false
                self.verifiedImg.isHidden = false
            } else {
                self.verifiedLbl.isHidden = true
                self.verifiedImg.isHidden = true
            }
            
            let years = self.dataSource.last?.years
            if years == "" {
                self.yearLbl.isHidden = true
                self.yearImg.isHidden = true
            } else {
                self.yearLbl.isHidden = false
                self.yearImg.isHidden = false
                if years == "1" {
                    self.yearLbl.text = years! + " Year"
                } else {
                    self.yearLbl.text = years! + " Years"
                }
            }
            */
            //Checking Admin is Available for this comapny
            let isAdminAvailable = self.dataSource.last?.isAdminAvailable
            let commodImg = self.dataSource.last?.commodityAdminImage
            let commodCount = self.dataSource.last?.commodityImageCount
            if isAdminAvailable! {
                self.ownCompanyView.isHidden = true
                self.ownCompBtn.isHidden = true
                self.ownCompBtn.isEnabled = false
                self.commoImgOverView.isHidden = false
                self.commoCount.isHidden = false
                self.commImgView.isHidden = false
                //self.commImgView.sd_setImage(with: URL(string: commodImg!), completed: nil)
                /*if commodCount! >= 1 {
                    self.commoCount.text = String(format: "%d", commodCount!) + "+"
                } else {
                    self.commoCount.text = ""
                }*/
            } else {
                self.ownCompanyView.isHidden = false
                self.ownCompBtn.isHidden = false
                self.ownCompBtn.isEnabled = true
                self.commoImgOverView.isHidden = true
                self.commoCount.isHidden = true
                self.commImgView.isHidden = true
                self.commImgView.sd_setImage(with: URL(string: commodImg!), completed: nil)
                if commodCount! >= 1 {
                    self.commoCount.text = String(format: "%d +", commodCount!)
                } else {
                    self.commoCount.text = ""
                }
                
            }
            
            self.photoCV.reloadData()
            self.tabCV.reloadData()
            if self.activityIndicator.isAnimating{
                self.loadingView.isHidden = true
                self.activityIndicator.stopAnimating()
            }
            
            self.company_lat = data.last!.lat
            self.company_long = data.last!.long

        }
    }
}

extension CompanyDetailVC {
    
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
    
}

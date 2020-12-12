//
//  CompanyHeaderModuleVC.swift
//  myscrap
//
//  Created by Apple on 21/10/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit
import Cosmos
import SDWebImage
import MessageUI
import SafariServices
import MapKit

struct Page {
    
    var name = ""
    var vc = UIViewController()
    
    init(with _name: String, _vc: UIViewController) {
        
        name = _name
        vc = _vc
    }
}

struct PageCollection {
    
    var pages = [Page]()
    var selectedPageIndex = 0 //The first page is selected by default in the beginning
}

var topViewInitialHeight : CGFloat = 379

let topViewFinalHeight : CGFloat = 0 //UIApplication.shared.statusBarFrame.size.height + 10 //44 //navigation hieght

let topViewHeightConstraintRange = topViewFinalHeight..<topViewInitialHeight

class CompanyHeaderModuleVC: UIViewController {

    var companyId : String?

    let tabsArray = ["OVERVIEW", "UPDATES",  "MEDIA", "REVIEWS"]

    @IBOutlet weak var stickyHeaderView: UIView!
    @IBOutlet weak var photoCV: UICollectionView!
    
    @IBOutlet weak var countLabel : UILabel!

    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var avgRatingLbl: UILabel!
    @IBOutlet weak var companyRatingStar: CosmosView!
    @IBOutlet weak var designationLbl: UILabel!
    @IBOutlet weak var affliationBtn: CorneredButton!
    @IBOutlet weak var isriBtn: CorneredButton!
    @IBOutlet weak var ownCompBtn: UIButton! //CorneredButton!
    @IBOutlet weak var reportCompanyButton : UIButton!
    
//    @IBOutlet weak var commoImgOverView: CorneredView!
//    @IBOutlet weak var commImgView: UIImageView!
//    @IBOutlet weak var commoCount: UILabel!

    @IBOutlet weak var tabBarCollectionView: UICollectionView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!

    var pageViewController = UIPageViewController()
    var selectedTabView = UIView()

    //MARK:- View Model
    var pageCollection = PageCollection()

    
    var dragInitialY: CGFloat = 0
    var dragPreviousY: CGFloat = 0
    var dragDirection: DragDirection = .Up
    
    let activityIndicator: UIActivityIndicatorView = {
        let av = UIActivityIndicatorView(style: .gray)
        av.hidesWhenStopped = true
        av.translatesAutoresizingMaskIntoConstraints = false
        return av
    }()
    
    fileprivate var companyData = [CompanyItems]()
    var service = CompanyUpdatedService()
    weak var delegate: CompanyUpdatedServiceDelegate?

    var company_lat = 0.0
    var company_long = 0.0

    
    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var emailBtn: UIButton!
    @IBOutlet weak var webBtn: UIButton!
    @IBOutlet weak var directionBtn: UIButton!
        
    var ownthisCompanyStr = "   Own this company   "
    var reportStr = "Report"//"   Report   "
    var reportedStr = "Reported" //"   Reported   "
    var requestedStr = "   Requested   "

    var editButton : UIButton!
    
    var reportCompanyDropDown = DropDown()
    
    //MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //countLabel
        self.countLabel.isHidden = true
        self.countLabel.textAlignment = .center
        self.countLabel.layer.cornerRadius = 10
        self.countLabel.layer.masksToBounds = true
        self.countLabel.font = UIFont.boldSystemFont(ofSize: 15)
        
        self.companyName.text = ""
        
        //activityIndicator
        view.addSubview(activityIndicator)
        activityIndicator.setTop(to: view.safeTop, constant: 30)
        activityIndicator.setHorizontalCenter(to: view.centerXAnchor)
        activityIndicator.setSize(size: CGSize(width: 30, height: 30))
        activityIndicator.startAnimating()
        
//        if companyId  != "" {
//            service.delegate = self
//            service.getCompanyDetails(companyId: companyId!)
//        }

        setupCompanyPhotosCollectionView()
        setupCollectionView()
        setupPagingViewController()
        populateBottomView()
        addPanGestureToTopViewAndCollectionView()

        
        companyRatingStar.text = "(2)"
        companyRatingStar.rating = 5
        
        affliationBtn.layer.borderColor = UIColor.MyScrapGreen.cgColor
        affliationBtn.layer.borderWidth = 1
        
        isriBtn.layer.borderColor = UIColor.MyScrapGreen.cgColor
        isriBtn.layer.borderWidth = 1
        NotificationCenter.default.addObserver(self, selector: #selector(handleReview(notif:)), name: NSNotification.Name(rawValue: "updateReview"), object: nil)
       
        //ownCompanyView
//        self.ownCompanyView.isHidden = true
        self.ownCompBtn.isHidden = true
        self.ownCompBtn.setTitle(self.ownthisCompanyStr, for: .normal)
//        self.ownCompBtn.isEnabled = true
        self.ownCompBtn.layer.cornerRadius = 10
        self.ownCompBtn.layer.masksToBounds = true
        self.ownCompBtn.addTarget(self, action: #selector(ownCompanyBtnAction), for: .touchUpInside)
        
        //reportCompanyButton
        self.reportCompanyButton.isHidden = true
        self.reportCompanyButton.setImage(UIImage(named: "icReport"), for: .normal)
        self.reportCompanyButton.setTitle("Report", for: .normal)
        self.reportCompanyButton.setTitleColor(UIColor.gray, for: .normal)
        self.reportCompanyButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 14)
        self.reportCompanyButton.alignTextUnderImage(imgsize: CGSize(width: 25, height: 25), spacing: 2)
        self.reportCompanyButton.addTarget(self, action: #selector(reportCompanyButtonAction), for: .touchUpInside)
        
//        self.commoImgOverView.isHidden = true
//        self.commoImgOverView.layer.cornerRadius = 3
//        self.commoImgOverView.layer.borderWidth = 0.5
//        self.commoImgOverView.layer.borderColor = UIColor.black.cgColor
//        self.commoImgOverView.clipsToBounds = true
//        self.commoCount.isHidden = true
//        self.commImgView.isHidden = true
//
//        self.commoCount.layer.shadowColor = UIColor.black.cgColor
//        self.commoCount.layer.shadowRadius = 3.0
//        self.commoCount.layer.shadowOpacity = 1.0
//        self.commoCount.layer.shadowOffset = CGSize(width: 4, height: 4)
//        self.commoCount.layer.masksToBounds = false
        //callBtn
        self.callBtn.setImage(UIImage(named: "call_40x40"), for: .normal)
        self.callBtn.setTitle("CALL", for: .normal)
        self.callBtn.setTitleColor(UIColor.GREEN_PRIMARY, for: .normal)
        self.callBtn.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 14)
        self.callBtn.alignTextUnderImage(imgsize: CGSize(width: 40, height: 40), spacing: 2)
        self.callBtn.addTarget(self, action: #selector(callBtnAction), for: .touchUpInside)
        
        //emailBtn
        self.emailBtn.setImage(UIImage(named: "email_40x40"), for: .normal)
        self.emailBtn.setTitle("EMAIL", for: .normal)
        self.emailBtn.setTitleColor(UIColor.GREEN_PRIMARY, for: .normal)
        self.emailBtn.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 14)
        self.emailBtn.alignTextUnderImage(imgsize: CGSize(width: 40, height: 40), spacing: 2)
        self.emailBtn.addTarget(self, action: #selector(emailBtnAction), for: .touchUpInside)

        //webBtn
        self.webBtn.setImage(UIImage(named: "website_40x40"), for: .normal)
        self.webBtn.setTitle("WEBSITE", for: .normal)
        self.webBtn.setTitleColor(UIColor.GREEN_PRIMARY, for: .normal)
        self.webBtn.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 14)
        self.webBtn.alignTextUnderImage(imgsize: CGSize(width: 40, height: 40), spacing: 2)
        self.webBtn.addTarget(self, action: #selector(webBtnAction), for: .touchUpInside)

        //directionBtn
        self.directionBtn.setImage(UIImage(named: "direction_40x40"), for: .normal)
        self.directionBtn.setTitle("DIRECTIONS", for: .normal)
        self.directionBtn.setTitleColor(UIColor.GREEN_PRIMARY, for: .normal)
        self.directionBtn.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 14)
        self.directionBtn.alignTextUnderImage(imgsize: CGSize(width: 40, height: 40), spacing: 2)
        self.directionBtn.addTarget(self, action: #selector(directionBtnAction), for: .touchUpInside)

        self.setUpEditButton()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(reloadCompanyDetailsAPI), name: Notification.Name("kCallCompanyDetailsAPI"), object: nil)

    }
    
//    @objc func reloadCompanyDetailsAPI() {
//
//        service.getCompanyDetails(companyId: companyId!)
//        service.delegate = self
//
//    }
    private func setUpEditButton(){
        
//        editButton = UIButton(frame: CGRect(x: 0, y: 0, width: 65, height: 25))
        editButton = UIButton.init(type: .custom)
        editButton.isHidden = true
        editButton.addTarget(self, action: #selector(editButtonAction), for: .touchUpInside)
        editButton.setTitle("Edit", for: .normal)
        editButton.setTitleColor(UIColor.white, for: .normal)
        editButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        editButton.layer.borderColor = UIColor.white.cgColor
        editButton.layer.borderWidth = 1.0
        editButton.layer.cornerRadius = 5.0
        editButton.layer.masksToBounds = true
        
        let myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: editButton)
        self.navigationItem.rightBarButtonItem  = myCustomBackButtonItem
        
    }
    //MARK:- Button Actions
    
    @objc func editButtonAction() {

        let vc = EditCompanyAdminViewVC.storyBoardInstance()
        vc?.navigationItem.title = "Admin View"
        vc?.companyId = self.companyId
        if self.navigationItem.title != nil {
            vc?.companyName = self.navigationItem.title!
        }
        vc?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        self.navigationController?.pushViewController(vc!, animated: true)

    }
    @objc func ownCompanyBtnAction(sender : UIButton) {
                        
//        let isAdminAvailable = self.companyData.last!.isAdminAvailable
//
//        if isAdminAvailable {
//
//            self.reportCompanyDropDown.anchorView = sender
//            self.reportCompanyDropDown.bottomOffset = CGPoint(x: self.ownCompBtn.frame.origin.x, y:(self.reportCompanyDropDown.anchorView?.plainView.bounds.height)!)
//            self.reportCompanyDropDown.dataSource = ["Report Inappropriate company"]
//            self.reportCompanyDropDown.cellHeight = 45.0
//
//            self.reportCompanyDropDown.direction = .bottom
//
//            self.reportCompanyDropDown.dropDownWidth = 230
//            self.reportCompanyDropDown.setupCornerRadius(3)
//            self.reportCompanyDropDown.backgroundColor = UIColor.white
//
//            self.reportCompanyDropDown.show()
//            self.reportCompanyDropDown.selectionAction = {[unowned self] (index: Int, item: String) in
//
//                self.reportCompanyAlertView()
//            }
//        }
//        else {
            let vc = OwnThisCompanyVC()
            vc.viewDelegate = self

            if self.companyData.count > 0 {
                vc.getCompanyItems = self.companyData.last!
            }

            self.navigationController?.pushViewController(vc, animated: true)
//        }
    }
    
    @objc func reportCompanyButtonAction(sender : UIButton) {
        
//        let isAdminAvailable = self.companyData.last!.isAdminAvailable
//
//        if isAdminAvailable {
//            print(self.reportCompanyButton.frame.origin.x)
            
            self.reportCompanyDropDown.anchorView = sender
            self.reportCompanyDropDown.bottomOffset = CGPoint(x: self.reportCompanyButton.frame.origin.x, y:(self.reportCompanyDropDown.anchorView?.plainView.bounds.height)!)
            self.reportCompanyDropDown.dataSource = ["Report Inappropriate company"]
            self.reportCompanyDropDown.cellHeight = 45.0
            
            self.reportCompanyDropDown.direction = .bottom
            
            self.reportCompanyDropDown.dropDownWidth = 230
            self.reportCompanyDropDown.setupCornerRadius(3)
            self.reportCompanyDropDown.backgroundColor = UIColor.white

            self.reportCompanyDropDown.show()
            self.reportCompanyDropDown.selectionAction = {[unowned self] (index: Int, item: String) in

                self.reportCompanyAlertView()
            }
//        }
    }
    
    @objc func callBtnAction() {
        
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
    
    @objc func emailBtnAction() {
        
        let email = self.companyData.last!.email
        if email != "" {
            sendMail(with: email)
        } else {
            let alert = UIAlertController(title: "Email not provided", message: nil, preferredStyle: .alert)
            alert.view.tintColor = UIColor.GREEN_PRIMARY
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }

    @objc func webBtnAction() {
      
        let website = self.companyData.last!.website
        if self.companyData.last?.website != "" {
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

    @objc func directionBtnAction() {
        
        if company_lat != 0 && company_long != 0 {
            let coordinate = CLLocationCoordinate2DMake(company_lat,company_long)
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
            let companyName = UserDefaults.standard.object(forKey: "companyName") as! String
            mapItem.name = companyName
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
        }
    }
    
    //MARK:- Report About Company API
    func reportCompanyAlertView() {
        
        let reportView = ReportAlertView()
        
        reportView.displayAlert(withSuperView: self, title: "Are you sure you want to report this company?") {
            
            var reportDescStr = reportView.descriptionTextView.text!
               
            if reportDescStr == reportView.placeholderStr {
                reportDescStr = ""
            }
            if self.companyId  != "" {
                
                self.service.reportAboutCompanyAndAdmin(view: self.view,
                                                      companyId: self.companyId!,
                                                      reportType: "1", // Report About company
                                                      reportDesc: reportDescStr) { (isSuccess) in
                    
                    if isSuccess! {
                        reportView.doCloseAnimation()

                        self.reportCompanyButton.setTitle(self.reportedStr, for: .normal)
                        self.reportCompanyButton.isEnabled = false
                    }
                    else {
                        reportView.doCloseAnimation()
                    }
                }
            }
        }
    }
    
    //MARK:- Helpers
    func validNumber() -> String {
        var phoneNumWithPlus = ""
        let phone = self.companyData.last!.phone
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
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.hidesBackButton = false
        if self.navigationItem.title == "" {
            let companyName = UserDefaults.standard.object(forKey: "companyAdminView") as? String
            if companyName != "" {
                self.navigationItem.title = companyName
            } else {
//                service.getCompanyDetails(companyId: companyId!)
            }
        }
        
        if let companyIdStr = UserDefaults.standard.object(forKey: "companyId") as? String {
            if companyIdStr  != "" {
                service.delegate = self
                service.getCompanyDetails(companyId: companyIdStr)
            }
        }
        if let button = self.navigationItem.rightBarButtonItem?.customView {
            button.frame = CGRect(x:0, y:0, width:70, height:28)
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
    
    static func storyBoardInstance() -> CompanyHeaderModuleVC? {
        let st = UIStoryboard(name: "CompanyModule", bundle: nil)
        return st.instantiateViewController(withIdentifier: CompanyHeaderModuleVC.id) as? CompanyHeaderModuleVC
    }
    
    //MARK: View Setup
    func setupCompanyPhotosCollectionView() {
        photoCV.delegate = self
        photoCV.dataSource = self
        photoCV.register(PhotoScrollCVCell.self, forCellWithReuseIdentifier: "photoScroll")
        photoCV.showsHorizontalScrollIndicator = false
        photoCV.isPagingEnabled = true
    }
    
    func setupCollectionView() {
        
//        let layout = tabBarCollectionView.collectionViewLayout as? UICollectionViewFlowLayout
//        layout?.estimatedItemSize = CGSize(width: 100, height: 50)
        
        tabBarCollectionView.register(UINib(nibName: TabBarCollectionViewCellID, bundle: nil),
                                      forCellWithReuseIdentifier: TabBarCollectionViewCellID)
        tabBarCollectionView.dataSource = self
        tabBarCollectionView.delegate = self
        tabBarCollectionView.backgroundColor = UIColor(red: 222/255.0, green: 222/255.0, blue: 222/255.0, alpha: 1)//lightGray
        setupSelectedTabView()
    }
    
    func setupPagingViewController() {
        
        pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                      navigationOrientation: .horizontal,
                                                      options: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self
    }
    
    func setupSelectedTabView() {
        
        let label = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: 10, height: 10))
        label.text = "TAB \(1)"
        label.sizeToFit()
//        var width = label.intrinsicContentSize.width
//        width = width + 40
        
        let width = self.view.frame.width / CGFloat(tabsArray.count)
        
        selectedTabView.frame = CGRect(x: 0, y: 55, width: width, height: 5)
        selectedTabView.backgroundColor = UIColor.GREEN_PRIMARY //UIColor(red:0.65, green:0.58, blue:0.94, alpha:1)
        tabBarCollectionView.addSubview(selectedTabView)
    }

    
    func populateBottomView() {
        
        for subTabCount in 0..<tabsArray.count {
            
            var viewController = UIViewController()
            
            if subTabCount == 0 {
                let overViewVC = UIStoryboard.init(name: "CompanyModule", bundle: nil).instantiateViewController(withIdentifier: "CompanyModuleOverViewVC") as! CompanyModuleOverViewVC
                
                overViewVC.innerTableViewScrollDelegate = self

//                if self.companyData.count != 0 {
//                    overViewVC.companyOverViewDataSource = self.companyData
//                }
                viewController = overViewVC

            }
            else if subTabCount == 1 {
                let updatesVC = UIStoryboard.init(name: "CompanyModule", bundle: nil).instantiateViewController(withIdentifier: "CompanyModuleUpdatesVC") as! CompanyModuleUpdatesVC
                updatesVC.innerTableViewScrollDelegate = self
                viewController = updatesVC
            }
            else if subTabCount == 2 {
                let mediaVC = UIStoryboard.init(name: "CompanyModule", bundle: nil).instantiateViewController(withIdentifier: "CompanyModuleMediaVC") as! CompanyModuleMediaVC
                mediaVC.innerTableViewScrollDelegate = self

                viewController = mediaVC
            }
            else if subTabCount == 3 {
                let reviewVC = UIStoryboard.init(name: "CompanyModule", bundle: nil).instantiateViewController(withIdentifier: "CompanyModuleReviewsVC") as! CompanyModuleReviewsVC
                reviewVC.innerTableViewScrollDelegate = self

                viewController = reviewVC

            }

            let page = Page(with: tabsArray[subTabCount], _vc: viewController)
            pageCollection.pages.append(page)

        }
        
        let initialPage = 0
        
        pageViewController.setViewControllers([pageCollection.pages[initialPage].vc],
                                                  direction: .forward,
                                                  animated: true,
                                                  completion: nil)
        
        
        addChild(pageViewController)
        pageViewController.willMove(toParent: self)
        bottomView.addSubview(pageViewController.view)
        
        pinPagingViewControllerToBottomView()
    }
    
    
    func pinPagingViewControllerToBottomView() {
        
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        pageViewController.view.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor).isActive = true
        pageViewController.view.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor).isActive = true
        pageViewController.view.topAnchor.constraint(equalTo: bottomView.topAnchor).isActive = true
        pageViewController.view.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor).isActive = true
    }

    func addPanGestureToTopViewAndCollectionView() {
        
        let topViewPanGesture = UIPanGestureRecognizer(target: self, action: #selector(topViewMoved))
        
        stickyHeaderView.isUserInteractionEnabled = true
        stickyHeaderView.addGestureRecognizer(topViewPanGesture)
        
        /* Adding pan gesture to collection view is overriding the collection view scroll.
         
        let collViewPanGesture = UIPanGestureRecognizer(target: self, action: #selector(topViewMoved))
        
        tabBarCollectionView.isUserInteractionEnabled = true
        tabBarCollectionView.addGestureRecognizer(collViewPanGesture)
         
        */
    }
    
    @objc func topViewMoved(_ gesture: UIPanGestureRecognizer) {
        
        var dragYDiff : CGFloat
        
        switch gesture.state {
            
        case .began:
            
            dragInitialY = gesture.location(in: self.view).y
            dragPreviousY = dragInitialY
            
        case .changed:
            
            let dragCurrentY = gesture.location(in: self.view).y
            dragYDiff = dragPreviousY - dragCurrentY
            dragPreviousY = dragCurrentY
            dragDirection = dragYDiff < 0 ? .Down : .Up
            innerTableViewDidScroll(withDistance: dragYDiff)
            
        case .ended:
            
            innerTableViewScrollEnded(withScrollDirection: dragDirection)
            
        default: return
        
        }
    }
    
    //MARK:- UI Laying Out Methods
    
    func setBottomPagingView(toPageWithAtIndex index: Int, andNavigationDirection navigationDirection: UIPageViewController.NavigationDirection) {
        
        pageViewController.setViewControllers([pageCollection.pages[index].vc],
                                                  direction: navigationDirection,
                                                  animated: true,
                                                  completion: nil)
    }
    
    func scrollSelectedTabView(toIndexPath indexPath: IndexPath, shouldAnimate: Bool = true) {
        
        UIView.animate(withDuration: 0.3) {
            
            if let cell = self.tabBarCollectionView.cellForItem(at: indexPath) {
                
                self.selectedTabView.frame.size.width = cell.frame.width
                self.selectedTabView.frame.origin.x = cell.frame.origin.x
            }
        }
    }
}

//MARK:- Collection View Data Source

extension CompanyHeaderModuleVC: UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        self.pageControll.currentPage = indexPath.item
        
        if companyData.last?.companyImages != nil {
            if companyData.last!.companyImages.count > 1 {
                self.countLabel.isHidden = false
                self.countLabel.text = "\(indexPath.item+1)/\(companyData.last!.companyImages.count as Int)"
            }else {
                self.countLabel.isHidden = true
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == self.photoCV {
            if companyData.count != 0 {
                return (companyData.last?.companyImages.count)!
            } else {
                return 0
            }
        }
        
        return pageCollection.pages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.photoCV   {
            
            let cell : PhotoScrollCVCell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoScroll", for: indexPath) as! PhotoScrollCVCell
            let imgUrl = companyData.last?.companyImages[indexPath.row]
            
            if imgUrl != "" && imgUrl != nil {
                cell.compImage.contentMode = .scaleAspectFill
                cell.compImage.setImageWithIndicator(imageURL: imgUrl!)
            }

            /*
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
            }*/
            return cell
    }
        else {
            
            if let tabCell = collectionView.dequeueReusableCell(withReuseIdentifier: TabBarCollectionViewCellID, for: indexPath) as? TabBarCollectionViewCell {
                
                tabCell.tabNameLabel.text = pageCollection.pages[indexPath.row].name
                return tabCell
            }
        }
        
        return UICollectionViewCell()
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.photoCV {
            if companyData.count == 1 {
                return CGSize(width: collectionView.frame.width, height: 260)
            }
            return CGSize(width: 258, height: 260)

        } else {
//            return CGSize(width: 100, height: 50)
            let num = CGFloat(tabsArray.count)
            return CGSize(width: self.view.frame.width / num, height: collectionView.frame.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == photoCV {
            return 0
        } else {
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == photoCV {
            return 0
        } else {
            return 0
        }
        
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

    // If the scroll animation ended, update the page control to reflect the current page we are on
//        self.pageControll.currentPage = Int((self.feedImages.contentOffset.x / self.feedImages.contentSize.width) * CGFloat((self.newItem?.pictureURL.count ?? 0) as Int))
//
//        if let countLable  = self.viewWithTag(1001) as? UILabel {
//    countLable.text = "\(Int((self.feedImages.contentOffset.x / self.feedImages.contentSize.width) * CGFloat((self.newItem?.pictureURL.count ?? 0) as Int))+1)/\(self.newItem!.pictureURL.count as Int)"
//              }
        
        if companyData.last?.companyImages != nil {
            if companyData.last!.companyImages.count > 1 {
                
                
                self.countLabel.text = "\(Int((self.photoCV.contentOffset.x / self.photoCV.contentSize.width) * CGFloat((companyData.last!.companyImages.count ) as Int))+1)/\(companyData.last!.companyImages.count as Int)"

            }
        }

    }
}
//MARK:- Collection View Delegate

extension CompanyHeaderModuleVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item == pageCollection.selectedPageIndex {
            
            return
        }
        
        var direction: UIPageViewController.NavigationDirection
        
        if indexPath.item > pageCollection.selectedPageIndex {
            
            direction = .forward
            
        } else {
            
            direction = .reverse
        }
        if indexPath.item != 1 {
            NotificationCenter.default.post(name: Notification.Name("PauseAllVideos"), object: nil)
        }
        else
        {
            let screenRect = UIScreen.main.bounds
            let screenHeight = screenRect.size.height
            NotificationCenter.default.post(name: Notification.Name("PlayVideoFromTab"), object: nil)

//            if mainScroll.contentOffset.y > 300 {
//                NotificationCenter.default.post(name: Notification.Name("PlayVideoFromTab"), object: nil)
//            }else
//            {
//                NotificationCenter.default.post(name: Notification.Name("PauseAllVideos"), object: nil)
//
//            }
        }
        pageCollection.selectedPageIndex = indexPath.item
        
        tabBarCollectionView.scrollToItem(at: indexPath,
                                          at: .centeredHorizontally,
                                          animated: true)
        
        scrollSelectedTabView(toIndexPath: indexPath)
        
        setBottomPagingView(toPageWithAtIndex: indexPath.item, andNavigationDirection: direction)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//
//        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
//    }
}

//MARK:- Delegate Method to give the next and previous View Controllers to the Page View Controller

extension CompanyHeaderModuleVC: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let currentViewControllerIndex = pageCollection.pages.firstIndex(where: { $0.vc == viewController }) {
            
            if (1..<pageCollection.pages.count).contains(currentViewControllerIndex) {
                
                // go to previous page in array
                
                return pageCollection.pages[currentViewControllerIndex - 1].vc
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if let currentViewControllerIndex = pageCollection.pages.firstIndex(where: { $0.vc == viewController }) {
            
            if (0..<(pageCollection.pages.count - 1)).contains(currentViewControllerIndex) {
                
                // go to next page in array
                
                return pageCollection.pages[currentViewControllerIndex + 1].vc
            }
        }
        return nil
    }
}

//MARK:- Delegate Method to tell Inner View Controller movement inside Page View Controller
//Capture it and change the selection bar position in collection View

extension CompanyHeaderModuleVC: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard completed else { return }
        
        guard let currentVC = pageViewController.viewControllers?.first else { return }
        
        guard let currentVCIndex = pageCollection.pages.firstIndex(where: { $0.vc == currentVC }) else { return }
        
        let indexPathAtCollectionView = IndexPath(item: currentVCIndex, section: 0)
        if indexPathAtCollectionView.item != 1 {
            NotificationCenter.default.post(name: Notification.Name("PauseAllVideos"), object: nil)
        }
        else
        {
            let screenRect = UIScreen.main.bounds
            let screenHeight = screenRect.size.height
            NotificationCenter.default.post(name: Notification.Name("PlayVideoFromTab"), object: nil)

//            if mainScroll.contentOffset.y > 300 {
//                NotificationCenter.default.post(name: Notification.Name("PlayVideoFromTab"), object: nil)
//            }else
//            {
//                NotificationCenter.default.post(name: Notification.Name("PauseAllVideos"), object: nil)
//
//            }
        }
        scrollSelectedTabView(toIndexPath: indexPathAtCollectionView)
        tabBarCollectionView.scrollToItem(at: indexPathAtCollectionView,
                                          at: .centeredHorizontally,
                                          animated: true)
    }
}

//MARK:- Sticky Header Effect

extension CompanyHeaderModuleVC: InnerTableViewScrollDelegate {
    
    var currentHeaderHeight: CGFloat {
        
        return headerViewHeightConstraint.constant
    }
    
    func innerTableViewDidScroll(withDistance scrollDistance: CGFloat) {
       
        headerViewHeightConstraint.constant -= scrollDistance
        
        /* Don't restrict the downward scroll.
 
        if headerViewHeightConstraint.constant > topViewInitialHeight {

            headerViewHeightConstraint.constant = topViewInitialHeight
        }
         
        */
        
        if headerViewHeightConstraint.constant < topViewFinalHeight {
            
            headerViewHeightConstraint.constant = topViewFinalHeight
        }
    }
    
    func innerTableViewScrollEnded(withScrollDirection scrollDirection: DragDirection) {
        
        let topViewHeight = headerViewHeightConstraint.constant
        
        /*
         *  Scroll is not restricted.
         *  So this check might cause the view to get stuck in the header height is greater than initial height.
 
        if topViewHeight >= topViewInitialHeight || topViewHeight <= topViewFinalHeight { return }
         
        */
        
        if topViewHeight <= topViewFinalHeight { //+ 20 {
            
            scrollToFinalView()
            
        } else if topViewHeight <= topViewInitialHeight {//} - 20 {
            
            switch scrollDirection {
                
            case .Down: scrollToInitialView()
            case .Up: scrollToFinalView()
            
            }
            
        } else {
            
            scrollToInitialView()
        }
    }
    
    func scrollToInitialView() {
        
        let topViewCurrentHeight = stickyHeaderView.frame.height
        
        let distanceToBeMoved = abs(topViewCurrentHeight - topViewInitialHeight)
        
        var time = distanceToBeMoved / 500
        
        if time < 0.25 {
            
            time = 0.25
        }
        
        headerViewHeightConstraint.constant = topViewInitialHeight
        
        UIView.animate(withDuration: TimeInterval(time), animations: {
            
            self.view.layoutIfNeeded()
        })
    }
    
    func scrollToFinalView() {
        
        let topViewCurrentHeight = stickyHeaderView.frame.height
        
        let distanceToBeMoved = abs(topViewCurrentHeight - topViewFinalHeight)
        
        var time = distanceToBeMoved / 500
        
        if time < 0.25 {
            
            time = 0.25
        }
        
        headerViewHeightConstraint.constant = topViewFinalHeight
        
        UIView.animate(withDuration: TimeInterval(time), animations: {
            
            self.view.layoutIfNeeded()
        })
    }
}


extension CompanyHeaderModuleVC: CompanyUpdatedServiceDelegate {
    func DidReceivedError(error: String) {
        print("Error while receiving company data : \(error)")
    }
    
    func didReceiveCompanyValues(data: [CompanyItems]) {
        DispatchQueue.main.async {
            self.companyData = data
            
            // Showing values
            self.navigationItem.title = self.companyData.last!.compnayName
            let lowerCased = self.companyData.last!.compnayName.lowercased()
            self.companyName.text = lowerCased.capitalized
            UserDefaults.standard.set(self.navigationItem.title, forKey: "companyName")
            UserDefaults.standard.set(self.navigationItem.title, forKey: "companyAdminView")
            
            if self.companyData.last?.companyType == "" {
                self.designationLbl.text = "Not provided"
            } else {
                self.designationLbl.text = self.companyData.last?.interest.last?.industry.last
            }
            self.avgRatingLbl.text = self.companyData.last?.AvgRating
            self.affliationBtn.setTitle(self.companyData.last?.affiliation.first, for: .normal)
            self.isriBtn.setTitle(self.companyData.last?.affiliation.last, for: .normal)
            self.companyRatingStar.rating = (self.avgRatingLbl.text! as NSString).doubleValue
            self.companyRatingStar.text = " (" + self.companyData.last!.totalReview + ")"

            //Checking Admin is Available for this comapny
            let isAdminAvailable = self.companyData.last?.isAdminAvailable

            let getOwnCompanyRequest = self.companyData.last?.ownCompanyRequest
//            let adminReport = self.companyData.last?.adminReport
            let reportedStatusOfCompany = self.companyData.last?.reportedStatusOfCompany

//          Own this company Button will show when there are no employees and admin for the company
            // Own this company Button
            self.ownCompBtn.layer.cornerRadius = 10
            self.ownCompBtn.layer.masksToBounds = true
            var ownCompanyButtonTitleStr = self.ownthisCompanyStr
            if self.companyData.last!.employeeCount == 0 && isAdminAvailable == false {
                self.ownCompBtn.isHidden = false
                self.ownCompBtn.isEnabled = true
                
                if getOwnCompanyRequest == "Requested" {
                    ownCompanyButtonTitleStr = self.requestedStr
                }
                self.ownCompBtn.setTitle(ownCompanyButtonTitleStr, for: .normal)
            }
            else {
                self.ownCompBtn.isHidden = true
                self.reportCompanyButton.isHidden = false
                
                var reportButtonTitleStr = ""
                if reportedStatusOfCompany == "Reported" {
                    reportButtonTitleStr = self.reportedStr
                }
                else {
                    reportButtonTitleStr = self.reportStr
                }

                self.reportCompanyButton.setTitle(reportButtonTitleStr, for: .normal)

            }
            
//            var buttonTitleStr = ""
//
////            if isAdminAvailable! {
//            let companyOwnerId = self.companyData.last!.companyOwnerId
//
//            if companyOwnerId != "" {
//
//                if companyOwnerId == AuthService.instance.userId && isAdminAvailable! {
//                    self.ownCompBtn.isHidden = true
//                    self.ownCompBtn.isEnabled = true
//
//                    self.editButton.isHidden = false
//                }
//                else if isAdminAvailable! { // Need to check
//                    self.ownCompBtn.isHidden = true//false
//                    self.reportCompanyButton.isHidden = false
//
//                    if reportedStatusOfCompany == "Reported" {
//                        buttonTitleStr = self.reportedStr
//                    }
//                    else {
//                        buttonTitleStr = self.reportStr
//                    }
//
//                    self.reportCompanyButton.setTitle(buttonTitleStr, for: .normal)
//
////                    self.ownCompBtn.layer.cornerRadius = 3
////                    self.ownCompBtn.layer.masksToBounds = true
//                }
//            }
//            else {
//
//                if reportedStatusOfCompany == "Reported" {
//                    buttonTitleStr = self.reportedStr
//                    self.ownCompBtn.isHidden = true
//                    self.reportCompanyButton.isHidden = false
//                    self.reportCompanyButton.setTitle(buttonTitleStr, for: .normal)
//                }
//                else if getOwnCompanyRequest == "Requested" {
//                    buttonTitleStr = self.requestedStr
//                   self.ownCompBtn.isHidden = false
//                    self.ownCompBtn.layer.masksToBounds = true
//               }
////               else if self.companyData.last!.employeeCount == 0 {
////
////                    self.reportCompanyButton.isHidden = false
////                    self.reportCompanyButton.setTitle(self.reportStr, for: .normal)
////
////                    self.ownCompBtn.isHidden = false
////                    self.ownCompBtn.isEnabled = true
////
////                    buttonTitleStr = self.ownthisCompanyStr
////               }
//            }
//
//            if buttonTitleStr != "" {
//                self.ownCompBtn.setTitle(buttonTitleStr, for: .normal)
//            }

            self.photoCV.reloadData()
            if self.activityIndicator.isAnimating{
                self.activityIndicator.stopAnimating()
            }
            
            self.company_lat = data.last!.lat
            self.company_long = data.last!.long

            self.tabBarCollectionView.reloadData()
        }
    }
}


public extension UIButton
{

  func alignTextUnderImage(imgsize:CGSize, spacing: CGFloat = 6.0)
  {
      if let image = self.imageView?.image
      {
          let imageSize: CGSize = image.size
          self.titleEdgeInsets = UIEdgeInsets(top: spacing, left: -imageSize.width, bottom: -(imageSize.height), right: 0.0)
          let labelString = NSString(string: self.titleLabel!.text!)
          let titleSize = labelString.size(withAttributes: [NSAttributedString.Key.font: self.titleLabel!.font])
          self.imageEdgeInsets = UIEdgeInsets(top: -(titleSize.height + spacing), left: 0.0, bottom: 0.0, right: -titleSize.width)
      }
  }
}

extension CompanyHeaderModuleVC : UpdateOwnCompanydelegate {
    
    func updateData() {
        self.ownCompBtn.setTitle(self.requestedStr, for: .normal)
        self.showAlert(message: "Request has been sent. You will be notified soon")
    }
}

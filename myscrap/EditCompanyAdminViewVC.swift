//
//  EditCompanyAdminViewVC.swift
//  myscrap
//
//  Created by MyScrap on 16/04/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit
import FlagPhoneNumber
import CoreTelephony
//import Gallery
import DKImagePickerController
import Alamofire

enum ImageType {
    case fromURL
    case fromLocal
}

struct CompanyPhotos {
    let imageType: ImageType
    var urlString: String?
    var data: Data?
    
    init(imageType: ImageType,
         urlString: String) {
        self.imageType = imageType
        self.urlString = urlString
        self.data = nil
    }
    
    init(imageType: ImageType,
         data: Data) {
        self.imageType = imageType
        self.urlString = nil
        self.data = data
    }
}

protocol EmplUserDelegate {
    func getUserData(id : String, name: String, firstName : String, lastName : String,designation : String, profilePic: String, colorCode: String)
}

class EditCompanyAdminViewVC: UIViewController , UIGestureRecognizerDelegate , FriendControllerDelegate{

    
    @IBOutlet weak var spinnerView: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var companyCollectionView: UICollectionView!
    @IBOutlet weak var commodityCollectionView: UICollectionView!
    @IBOutlet weak var companyView: UIView!
    @IBOutlet weak var commodityView: UIView!
    @IBOutlet weak var companyNameTF: ACFloatingTextfield!
    @IBOutlet weak var countryCodeTF: FPNTextField!
    @IBOutlet weak var phoneTF: ACFloatingTextfield!
    @IBOutlet weak var emailTF: ACFloatingTextfield!
    @IBOutlet weak var addressTF: CompanySearchTextField!
    @IBOutlet weak var websiteTF: ACFloatingTextfield!
    @IBOutlet weak var aboutTextView: UITextView!
    @IBOutlet weak var aboutView: UIView!
    @IBOutlet weak var dayFrom: ACFloatingTextfield!
    @IBOutlet weak var dayTo: ACFloatingTextfield!
    @IBOutlet weak var timeFrom: ACFloatingTextfield!
    @IBOutlet weak var timeTo: ACFloatingTextfield!
    @IBOutlet weak var typeCollectionView: UICollectionView!
    @IBOutlet weak var typeCVHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var employeeTableView: UITableView!
    @IBOutlet weak var emplTVHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var addEmplBtn: CorneredButton!
    
    
    let commodityService = Interests()
    
    lazy var businessType: [String] = {
        return commodityService.companyIndustryData
    }()
    
    lazy var commodities : [String] = {
        return commodityService.companyCommodityData
    }()
    
    
    lazy var affiliation : [String] = {
        return commodityService.companyAffiliationData
    }()
    
    var selectedBusinessType = [String]()
    var selectedCommodity = [String]()
    var selectedAffiliation = [String]()
    
    var counCode:String!
    var companyName = ""
    var companyId : String?
    var service = CompanyUpdatedService()
    var dataSource = [Employees]()
    var companyItems : CompanyItems?
    weak var delegate: CompanyUpdatedServiceDelegate?
    
    var dayFromPicker = UIPickerView()
    var dayToPicker = UIPickerView()
    var openTimePicker = UIPickerView()
    var closeTimePicker = UIPickerView()
    var selectedDayFrom: String?
    var selectedDayTo: String?
    var selectedTimeFrom: String?
    var selectedTimeTo: String?
    var days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday",  "Sunday"]
    var hrs =  ["01", "02",  "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"]
    var mnts = ["00", "15", "30", "45"]
    var meridian = ["AM", "PM"]
    fileprivate var activeTextField: ACFloatingTextfield?
    
    /*
    lazy var companyGallery: GalleryController = {
        let gry = GalleryController()
        gry.delegate = self
        return gry
    }()
    
    lazy var commodityGallery: GalleryController = {
        let gry = GalleryController()
        gry.delegate = self
        return gry
    }() */
    
    var companyImgLastIndex = 0
    var commodityImgLastIndex = 0
    
    var employeeUserIds: String = ""
    var empUserIDArray : [String] = []
    
    var companyPhotosPickerController = DKImagePickerController()

    var commodityPhotosPickerController = DKImagePickerController()
    
    var companyProfileImagesArray = [CompanyPhotos]()

    var commodityProfileImagesArray = [CompanyPhotos]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let button = UIButton.init(type: .custom)
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.white.cgColor
        button.backgroundColor = UIColor.MyScrapGreen
//        button.titleLabel?.font = UIFont(name: "HelveticaNeue", size : 11)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(self.updateCompany), for: .touchUpInside)

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        
        //Setting up company name from previous module
        self.companyNameTF.text = companyName
        
        dayFrom.isUserInteractionEnabled = true
        dayTo.isUserInteractionEnabled = true
        
        setupScrollView()
        setupCollectionView()
        setupTableView()
        setupDayPicker()
        setupTimePicker()
        
        setup(textFields: [companyNameTF,phoneTF,emailTF,addressTF,websiteTF,dayFrom,dayTo,timeFrom,timeTo])
        
        
        countryCodeTF.textColor = UIColor.black
        countryCodeTF.delegate = self
        countryCodeTF.editCompanySetBottomBorderEnabled()
        //codeTextField.parentViewController = self
        countryCodeTF.placeholder = ""
        countryCodeTF.flagButton.setSize(width: 35, height: 30)
        
        countryCodeTF.phoneCodeTextField.text = "+971" + " ▼"
        countryCodeTF.setFlag(for: FPNCountryCode(rawValue: "AE")!)
        
        aboutView.backgroundColor = UIColor.white
        aboutView.layer.borderColor = UIColor.black.cgColor
        aboutView.layer.borderWidth = 1.0
        aboutView.layer.cornerRadius = 5
        aboutView.clipsToBounds = true
        
        self.aboutTextView.backgroundColor = UIColor.white
        
        //Setting up the company view to open GALLERY
        let companyTap = UITapGestureRecognizer(target: self, action: #selector(tapCompanyView(_sender:)))
        companyTap.numberOfTapsRequired = 1
        companyView.addGestureRecognizer(companyTap)
        companyView.backgroundColor = UIColor.white
        
        let commodityTap = UITapGestureRecognizer(target: self, action: #selector(tapCommodityView(_sender:)))
        commodityTap.numberOfTapsRequired = 1
        commodityView.addGestureRecognizer(commodityTap)
        commodityView.backgroundColor = UIColor.white
        
        //Setting up the company Service
        getCompanyDetailsAdminView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //navigationController?.navigationBar.topItem?.title = " "
        
        if let button = self.navigationItem.rightBarButtonItem?.customView {
            button.frame = CGRect(x:0, y:0, width:70, height:28)
        }
    }
    
    private func setup(textFields: [ACFloatingTextfield]){
        for textfield in textFields{
            textfield.textColor = UIColor.black
            textfield.delegate = self
        }
    }
    
    func setupScrollView(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(cancelTap))
        tap.numberOfTapsRequired = 1
        tap.delegate = self
        tap.cancelsTouchesInView = false
        self.scrollView.addGestureRecognizer(tap)
    }
    
    @objc func cancelTap(){
        resignResponders()
    }
    
    func resignResponders(){
        activeTextField?.resignFirstResponder()
        aboutTextView.resignFirstResponder()
    }
    
    private func setupCollectionView(){
        //Company Photos
        companyCollectionView.delegate = self
        companyCollectionView.dataSource = self
        
        //Commodity Photos
        commodityCollectionView.delegate = self
        commodityCollectionView.dataSource = self
        
        //Business type / Commodity / Affliation collection view
        typeCollectionView.delegate = self
        typeCollectionView.dataSource = self
//        view.layoutIfNeeded()
//        typeCVHeightConstraint.constant = typeCollectionView.collectionViewLayout.collectionViewContentSize.height
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleCollectionViewTap(_:)))
        tap.numberOfTapsRequired = 1
        typeCollectionView.addGestureRecognizer(tap)
        
        //Setting up static Add more cell in company image and commodity image
        //companyCollectionView
//        companyCollectionView.register(AddMoreAdminViewCell.Nib, forCellWithReuseIdentifier: AddMoreAdminViewCell.identifier)
        
        companyCollectionView.register(CompanyAndCommoditiesPhotosCell.self, forCellWithReuseIdentifier:"CompanyAndCommoditiesPhotosCell")
        
        companyCollectionView.register(UINib(nibName: "AddMoreFooterCollectionResuableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "AddMoreFooterViewIdentifier")
        
        //commodityCollectionView
//        commodityCollectionView.register(AddMoreAdminViewCell.Nib, forCellWithReuseIdentifier: AddMoreAdminViewCell.identifier)
        commodityCollectionView.register(UINib(nibName: "AddMoreFooterCollectionResuableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "AddMoreFooterViewIdentifier")
        commodityCollectionView.register(CompanyAndCommoditiesPhotosCell.self, forCellWithReuseIdentifier:"CompanyAndCommoditiesPhotosCell")

    }
    
    @objc private func handleCollectionViewTap(_ sender: UITapGestureRecognizer){
        if let ip = self.typeCollectionView?.indexPathForItem(at: sender.location(in: self.typeCollectionView)) {
            collectionView(typeCollectionView, didSelectItemAt: ip)
        } else {
            resignResponders()
        }
    }
    
    private func setupTableView(){
        employeeTableView.delegate = self
        employeeTableView.dataSource = self
        employeeTableView.backgroundColor = UIColor.white
        
        view.layoutIfNeeded()
        var frame = employeeTableView.frame
        frame.size.height = employeeTableView.contentSize.height
        employeeTableView.frame = frame
        emplTVHeightConstraint.constant = employeeTableView.contentSize.height
        
    }
    
    func updateTableView (){
        var frame = employeeTableView.frame
        frame.size.height = employeeTableView.contentSize.height
        employeeTableView.frame = frame
        emplTVHeightConstraint.constant = employeeTableView.contentSize.height
    }
    
    override func viewDidLayoutSubviews(){
         //tableView.frame = CGRectMake(tableView.frame.origin.x, tableView.frame.origin.y, tableView.frame.size.width, tableView.contentSize.height)
        setupTableView()
        employeeTableView.reloadData()
    }
    func setupDayPicker() {
        dayFromPicker = UIPickerView()
        dayFromPicker.delegate = self
        dayFrom.inputView = dayFromPicker
        dayFromPicker.dataSource = self
        dayFrom.placeholder = ""
        dayFrom.text = "Mon   ▼"
        
        dayToPicker = UIPickerView()
        dayToPicker.delegate = self
        dayTo.inputView = dayToPicker
        dayToPicker.dataSource = self
        dayTo.placeholder = ""
        dayTo.text  = "Sun   ▼"
        
    }
    
    func setupTimePicker() {
        openTimePicker = UIPickerView()
        openTimePicker.delegate = self
        openTimePicker.dataSource = self
        
        
        
        closeTimePicker = UIPickerView()
        closeTimePicker.delegate = self
        closeTimePicker.dataSource = self
        
        
         //ToolBar
           let toolbar = UIToolbar();
           toolbar.sizeToFit()

           //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.action))
           toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)

        // add toolbar to textField
        timeFrom.inputAccessoryView = toolbar
         timeFrom.inputView = openTimePicker
        timeFrom.text = "00:00 AM"
        
        timeTo.inputAccessoryView = toolbar
        timeTo.inputView = closeTimePicker
        timeTo.text = "00:00 PM"
        
    }
    
    func dismissPickerView() {
       let toolBar = UIToolbar()
       toolBar.sizeToFit()
       let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
       toolBar.setItems([button], animated: true)
       toolBar.isUserInteractionEnabled = true
       dayFrom.inputAccessoryView = toolBar
        dayTo.inputAccessoryView = toolBar
    }
    @objc func action() {
        self.view.endEditing(true)
    }
    //MARK:- Get Company Details API
    private func getCompanyDetailsAdminView(){
        
        let spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
        spinner.mode = MBProgressHUDMode.indeterminate
        spinner.label.text = "Receiving Data..."

        service.adminViewGet(companyId: companyId!) { [self](data) in
            DispatchQueue.main.async {
                
                if let companyData = data{
                    self.configureTextFields(with: companyData)
                    self.configureImages(with: companyData)
                    
                    MBProgressHUD.hide(for: (self.view)!, animated: true)

                    self.spinnerView.isHidden = true
                    self.spinner.stopAnimating()
                    self.spinner.hidesWhenStopped = true
                    self.dataSource = companyData.employees
                    // Update employee table
                    self.employeeTableView.reloadData()
                    
                    self.view.layoutIfNeeded()
                    var frame = self.employeeTableView.frame
                    frame.size.height = self.employeeTableView.contentSize.height
                    self.employeeTableView.frame = frame
                    self.emplTVHeightConstraint.constant = self.employeeTableView.contentSize.height
                    
                }
                else {
                    MBProgressHUD.hide(for: (self.view)!, animated: true)
                }
            }
        }
        
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let touchView = touch.view, touchView.isDescendant(of: employeeTableView){
            return false
        }
        if let touchView = touch.view, touchView.isDescendant(of: typeCollectionView){
            return false
        }
        
        return true
    }
    
    func getcountryRegionCode(countryCallingCode:String)->String{
        
        let prefixCodes = ["93": "AF", "971": "AE", "355": "AL", "599": "AN", "376": "AD", "244": "AO", "54": "AR", "374": "AM", "297": "AW", "61":"AU", "43": "AT", "994": "AZ", "973":"BH", "226": "BF", "257": "BI", "880": "BD", "375": "BY", "32":"BE", "501": "BZ", "229": "BJ", "975" : "BT", "387" : "BA", "267": "BW", "55": "BR", "359": "BG", "591": "BO", "590": "BL", "673": "BN", "243":"CD","225": "CI", "855":"KH", "237": "CM", "238": "CV", "345" :"KY", "236" :"CF", "41": "CH", "56": "CL", "86":"CN", "57": "CO", "269": "KM", "242":"CG", "682": "CK", "506": "CR", "53":"CU", "537":"CY", "420": "CZ", "49": "DE", "45": "DK", "253":"DJ", "213": "DZ", "593": "EC", "20":"EG", "291": "ER", "372":"EE","34": "ES", "251": "ET", "691": "FM", "500": "FK", "298": "FO", "679": "FJ", "358":"FI", "33": "FR", "44":"GB", "594": "GF", "241":"GA", "220":"GM", "995":"GE","233":"GH", "350": "GI", "240": "GQ", "30": "GR", "299": "GL", "502": "GT", "224" : "GN", "245": "GW", "595": "GY", "509": "HT", "385": "HR", "504":"HN", "36": "HU", "852": "HK", "98": "IR", "972": "IL", "246":"IO", "354": "IS", "91": "IN", "62":"ID", "964":"IQ", "353": "IE","39":"IT", "81": "JP", "962": "JO", "850": "KP", "82": "KR","77":"KZ", "254": "KE", "686": "KI", "965": "KW", "996":"KG", "371": "LV", "961": "LB", "94":"LK", "266": "LS", "231":"LR", "423": "LI", "370": "LT", "352": "LU", "856": "LA", "218":"LY", "853": "MO", "389": "MK", "261":"MG", "265": "MW", "60": "MY","960": "MV", "223":"ML", "356": "MT", "692": "MH", "596": "MQ", "222":"MR", "230": "MU", "52": "MX","377": "MC", "976": "MN", "382": "ME", "212":"MA", "95": "MM", "373":"MD", "258": "MZ", "264":"NA", "674":"NR", "977":"NP", "31": "NL","687": "NC", "64":"NZ", "505": "NI", "227": "NE", "234": "NG", "683":"NU", "672": "NF", "47": "NO", "968": "OM", "92": "PK", "508": "PM", "680": "PW", "689": "PF", "507": "PA", "675" : "PG", "51": "PE", "63": "PH", "48":"PL", "872": "PN","351": "PT", "970": "PS", "974": "QA", "40":"RO", "262":"RE", "381": "RS", "7": "RU", "250": "RW", "378": "SM", "966":"SA", "221": "SN", "248": "SC", "232":"SL","65": "SG", "421": "SK", "386": "SI", "677":"SB", "290": "SH", "249": "SD", "597": "SR","268": "SZ", "46":"SE", "503": "SV", "239": "ST","252": "SO", "963":"SY", "886": "TW", "255": "TZ", "670": "TL", "235": "TD", "992": "TJ", "66": "TH", "228":"TG", "690": "TK", "676": "TO", "216":"TN","90": "TR", "993": "TM", "688":"TV", "256": "UG", "380": "UA", "1": "US", "598": "UY","998": "UZ", "379":"VA", "58":"VE", "84": "VN", "678":"VU", "685": "WS", "681": "WF", "967": "YE", "27": "ZA", "260": "ZM", "263":"ZW"]
        let countryRegCode = prefixCodes[countryCallingCode]
        return countryRegCode!
        
    }
    
    private func configureImages(with companyItem: CompanyItems){
        self.companyItems = companyItem
        
        if self.companyItems?.companyImages.count != 0 {
            
            for loopValue in self.companyItems!.companyImages {
                
                if loopValue != "https://test.myscrap.com/style/images/profile/company.jpg" && loopValue != "" {
                    companyProfileImagesArray.append(CompanyPhotos(imageType: .fromURL, urlString: loopValue))
                }
            }
            
            if companyProfileImagesArray.count > 0 {
                self.companyView.isHidden = true
            }
        }
        else {
            self.companyView.isHidden = false
        }
        
        //Commodity
        if self.companyItems?.commodityImages.count != 0 {
            
            for loopValue in self.companyItems!.commodityImages {
                if loopValue != "https://test.myscrap.com/style/images/profile/company.jpg" && loopValue != "" {
                    commodityProfileImagesArray.append(CompanyPhotos(imageType: .fromURL, urlString: loopValue))
                }
            }
            
            if commodityProfileImagesArray.count > 0 {
                self.commodityView.isHidden = true
            }
        }
        else {
            self.commodityView.isHidden = false
        }

        companyCollectionView.reloadData()
        commodityCollectionView.reloadData()
        
        typeCollectionView.reloadData()
        view.layoutIfNeeded()
        typeCVHeightConstraint.constant = typeCollectionView.collectionViewLayout.collectionViewContentSize.height

    }
    
    private func configureTextFields(with companyItem: CompanyItems){
        if companyItem.code == "" {
            countryCodeTF.phoneCodeTextField.text = "+971" + " ▼"
            countryCodeTF.setFlag(for: FPNCountryCode(rawValue: "AE")!)
            
        } else {
            counCode = companyItem.code
            
            if let code = counCode {
                    if code.contains("+") {
                        let dialerCode = code.replacingOccurrences(of: "+", with: "")
                        //Getting list of country Region code
                        let regionCode = getcountryRegionCode(countryCallingCode: dialerCode)
                        print("Result of region code :\(regionCode)")
                        //Assign region code into flag value
                        countryCodeTF.setFlag(for: FPNCountryCode(rawValue: regionCode)!)
                        countryCodeTF.phoneCodeTextField.text = counCode + " ▼"
                    } else {
                        //Getting list of country Region code
                        let regionCode = getcountryRegionCode(countryCallingCode: counCode)
                        print("Result of region code :\(regionCode)")
                        //Assign region code into flag value
                        countryCodeTF.setFlag(for: FPNCountryCode(rawValue: regionCode)!)
                        countryCodeTF.phoneCodeTextField.text = counCode + " ▼"
                    }
            }
            self.companyNameTF.text = companyItem.compnayName
            self.phoneTF.text = companyItem.phone
            self.emailTF.text = companyItem.email
            self.addressTF.text = companyItem.address
            self.websiteTF.text = companyItem.website
            self.aboutTextView.text = companyItem.compnayAbout
            let openDay = companyItem.officeOpenDay.prefix(3)
            if openDay != "" {
                self.dayFrom.text = String(openDay) + "   ▼"
            }
            
            let closeDay = companyItem.officeCloseDay.prefix(3)
            if closeDay != "" {
                self.dayTo.text = String(closeDay) + "   ▼"
            }
            if companyItem.adminOfficeOpen != "" {
                self.timeFrom.text = companyItem.adminOfficeOpen
            }
            if companyItem.adminOfficeClose != "" {
                self.timeTo.text = companyItem.adminOfficeClose
            }
            
            self.dayFrom.disableFloatingLabel = true
            self.dayTo.disableFloatingLabel = true
            self.timeFrom.disableFloatingLabel = true
            self.timeTo.disableFloatingLabel = true
            
            self.selectedBusinessType = companyItem.businessTypeArray
            self.selectedCommodity = companyItem.commodityArray
            self.selectedAffiliation = companyItem.affiliationArray
//             typeCollectionView.reloadData()
        }
    }
    
    @objc func tapCompanyView(_sender:UITapGestureRecognizer) {
//        Config.tabsToShow  = [.imageTab]
//        Config.Camera.imageLimit = 10
//        self.present(self.companyGallery, animated: true, completion: nil)
        
        self.callCompanyDKImagePickerController()
    }
    
    @objc func tapCommodityView(_sender:UITapGestureRecognizer) {
//        Config.tabsToShow  = [.imageTab]
//        Config.Camera.imageLimit = 10
//        self.present(self.commodityGallery, animated: true, completion: nil)
        
        self.callCommodityDKImagePickerController()

    }
    
    @IBAction func addEmplyBtnTapped(_ sender: UIButton) {
        if let memberVC = AddEmplAdminViewMembersVC.storyBoardInstance() {
            memberVC.delegate = self
            let navController = UINavigationController(rootViewController: memberVC)
            self.navigationController?.present(navController, animated: true, completion: nil)
        }
    }
    //MARK:- Save / UpDate company details API
    //Save or update the company details
    @objc func updateCompany( sender : UIButton ) {
        
        //Textfield validation
        if companyNameTF.text == nil { companyNameTF.showError()}
        if !self.isValidEmail(testStr: self.emailTF.text!){
            self.emailTF.showErrorWithText(errorText: "Enter a Valid Email Address")
            return
        }
        if companyId == "" {
            print("Couldn't get the company ID")
            return
        }
        
        let emailText = self.emailTF.text!
        
        let inValidDomains = ["gmail.com", "yahoo.com", "comcast.net", "hotmail.com", "msn.com", "verizon.net"]
        if let domain = emailText.components(separatedBy: "@").last, inValidDomains.contains(domain) {
            self.showAlert(message: "Enter a company email address")
            return
        }

        
        var business_type = ""
        var commd = ""
        var affil = ""
        
        if !selectedBusinessType.isEmpty {
            business_type = (selectedBusinessType.map{String($0)}).joined(separator: ",")
        }
        if !selectedCommodity.isEmpty {
            commd = (selectedCommodity.map{String($0)}).joined(separator: ",")
        }
        if !selectedAffiliation.isEmpty {
            affil = (selectedAffiliation.map{String($0)}).joined(separator: ",")
        }

        self.updateCompanyAPI(companyId: self.companyId!, name: self.companyName,
                              about: self.aboutTextView.text, commodity: commd,
                              industry: business_type, affiliation: affil,
                              address: self.addressTF.text ?? "", phone: self.phoneTF.text ?? "",
                              code: self.counCode ?? "", email: self.emailTF.text ?? "",
                              website: self.websiteTF.text ?? "", dayOpen: self.selectedDayFrom ?? "",
                              dayClose: self.selectedDayTo ?? "", openTime: self.timeFrom.text ?? "",
                              closeTime: self.timeTo.text ?? "", employeeId: self.employeeUserIds) { (isSuccess) in
            
            print(isSuccess)
        }

//        var companyMedia: [Media] = []
//        var commodityMedia: [Media] = []
        
//        var i = 0
//        for companyImg in self.companyProfileImagesArray{
////            if let img = imag{
////                companyMedia.append(Media(withImage: imag, forKey: "uploadfile[]")!)
////            }
//            if i >= 10 {
//                break
//            }
//            companyMedia.append(Media(withImage: companyImg, forKey: "uploadfile[]")!)
//            i += 1
//        }
//
//        var j = 0
//        for commodityImg in self.commodityProfileImages{
////            if let comImg = comImag{
////                commodityMedia.append(Media(withImage: comImag, forKey: "uploadcommodity[]")!)
////            }
//            if j >= 10 {
//                break
//            }
//            commodityMedia.append(Media(withImage: commodityImg, forKey: "uploadfile[]")!)
//            j += 1
//        }

//        self.post(companyId: self.companyId!,
//                  name: self.companyName,
//                  about: self.aboutTextView.text,
//                  commodity: commd, industry: business_type,affiliation: affil,
//                  address: self.addressTF.text ?? "",
//                  phone: self.phoneTF.text ?? "", code: self.counCode ?? "",
//                  email: self.emailTF.text ?? "", website: self.websiteTF.text ?? "",
//                  dayOpen: self.selectedDayFrom ?? "", dayClose: self.selectedDayTo ?? "",
//                  openTime: self.timeFrom.text ?? "", closeTime: self.timeTo.text ?? "",
//                  employeeId: self.employeeUserIds,
//                  companyPhotos: companyMedia, commodityPhotos: commodityMedia)

        
        /*
        Image.resolve(images: companyImageDS) { imgArray in
            var companyMedia: [Media] = []
            var commodityMedia: [Media] = []
            for imag in imgArray{
                if let img = imag{
                    companyMedia.append(Media(withImage: img, forKey: "uploadfile[]")!)
                }
            }
            Image.resolve(images: self.commodityImageDS) { comImgArray in
                for comImag in comImgArray{
                    if let comImg = comImag{
                        commodityMedia.append(Media(withImage: comImg, forKey: "uploadcommodity[]")!)
                    }
                }
                if (self.companyImageDS.count != 0 ||  !self.companyImageDS.isEmpty) && (self.commodityImageDS.count != 0 || !self.commodityImageDS.isEmpty){
                    //Both Photos have images
                    self.post(companyId: self.companyId!, name: self.companyName, about: self.aboutTextView.text, commodity: commd, industry: business_type, affiliation: affil, address: self.addressTF.text ?? "", phone: self.phoneTF.text ?? "", code: self.counCode ?? "", email: self.emailTF.text ?? "", website: self.websiteTF.text ?? "", dayOpen: self.selectedDayFrom ?? "", dayClose: self.selectedDayTo ?? "", openTime: self.timeFrom.text ?? "", closeTime: self.timeTo.text ?? "", employeeId: self.employeeUserIds, companyPhotos: companyMedia, commodityPhotos: commodityMedia)
                } else if (self.companyImageDS.count == 0 ||  self.companyImageDS.isEmpty)  && (self.commodityImageDS.count == 0  || self.commodityImageDS.isEmpty){
                    //Both are empty
                    self.post(companyId: self.companyId!, name: self.companyName, about: self.aboutTextView.text, commodity: commd, industry: business_type, affiliation: affil, address: self.addressTF.text ?? "", phone: self.phoneTF.text ?? "", code: self.counCode ?? "", email: self.emailTF.text ?? "", website: self.websiteTF.text ?? "", dayOpen: self.selectedDayFrom ?? "", dayClose: self.selectedDayTo ?? "", openTime: self.timeFrom.text ?? "", closeTime: self.timeTo.text ?? "", employeeId: self.employeeUserIds, companyPhotos: nil, commodityPhotos: nil)
                } else if (self.companyImageDS.count != 0  ||  !self.companyImageDS.isEmpty) && (self.commodityImageDS.count == 0 ||  self.commodityImageDS.isEmpty) {
                    //Company photos only have images
                    self.post(companyId: self.companyId!, name: self.companyName, about: self.aboutTextView.text, commodity: commd, industry: business_type, affiliation: affil, address: self.addressTF.text ?? "", phone: self.phoneTF.text ?? "", code: self.counCode ?? "", email: self.emailTF.text ?? "", website: self.websiteTF.text ?? "", dayOpen: self.selectedDayFrom ?? "", dayClose: self.selectedDayTo ?? "", openTime: self.timeFrom.text ?? "", closeTime: self.timeTo.text ?? "", employeeId: self.employeeUserIds, companyPhotos: companyMedia, commodityPhotos: nil)
                } else if (self.companyImageDS.count == 0 ||  self.companyImageDS.isEmpty)  && (self.commodityImageDS.count != 0 ||  !self.commodityImageDS.isEmpty){
                    //Commodity photos have images
                    self.post(companyId: self.companyId!, name: self.companyName, about: self.aboutTextView.text, commodity: commd, industry: business_type, affiliation: affil, address: self.addressTF.text ?? "", phone: self.phoneTF.text ?? "", code: self.counCode ?? "", email: self.emailTF.text ?? "", website: self.websiteTF.text ?? "", dayOpen: self.selectedDayFrom ?? "", dayClose: self.selectedDayTo ?? "", openTime: self.timeFrom.text ?? "", closeTime: self.timeTo.text ?? "", employeeId: self.employeeUserIds, companyPhotos: nil, commodityPhotos: commodityMedia)
                }
            }
        } */
    }
    
    /*
    func setUpPhotosForCompany(photosArr : [DKAsset],
                               parameter: String,
                               completionHandler: @escaping (_ mediaArray : [Media]) -> Void ) {
                
        
        completionHandler(companyMedia)
    }
    
    func setUpCompanyPhotosArray(photosArr : [DKAsset], parameter: String) -> [Media] {
       
        var companyMedia: [Media] = []

        var i = 0
        for loopValue in photosArr {
            
            loopValue.fetchOriginalImage(completeBlock: { image, info in
                if let img = image {
                    let uploadImg = String(format: "%@[%d]", parameter, i)
                    companyMedia.append(Media(withImage: img, forKey: uploadImg)!) //"uploadcommodity[\(0)]")!)
                }
            })
            i += 1
        }
        
        return companyMedia
    } */
    
    //MARK:- update Company API
    func updateCompanyAPI(companyId: String, name: String, about: String, commodity: String, industry: String,affiliation: String, address: String, phone: String, code: String, email: String, website: String, dayOpen: String, dayClose: String, openTime: String, closeTime: String, employeeId : String,completion: @escaping (Bool) -> ()){

        var ip = ""
        if !AuthService.instance.getIFAddresses().isEmpty{
            ip = AuthService.instance.getIFAddresses().description
        }

        let parameters = [
            CompanyPostKeys.userId : AuthService.instance.userId,
            CompanyPostKeys.apiKey : API_KEY,
            CompanyPostKeys.company_id   : companyId,
            CompanyPostKeys.company_name : name,
            CompanyPostKeys.company_about: about,
            CompanyPostKeys.company_commodity: commodity,
            CompanyPostKeys.company_industry: industry,
            CompanyPostKeys.company_affiliation: affiliation,
            CompanyPostKeys.company_address: address,
            CompanyPostKeys.company_phone : phone,
            CompanyPostKeys.company_code: code,
            CompanyPostKeys.company_email: email,
            CompanyPostKeys.company_website: website,
            CompanyPostKeys.company_dayOpen: dayOpen,
            CompanyPostKeys.company_dayClose : dayClose,
            CompanyPostKeys.company_openTime: openTime,
            CompanyPostKeys.company_closeTime: closeTime,
            CompanyPostKeys.company_addEmployeeID : employeeId,
            CompanyPostKeys.company_AddressCity : "",

            ] as [String : Any]

        let urlPath = Endpoints.COMPANY_UPDATE_ADMIN_VIEW

        self.showActivityIndicator(with: "Posting data...")

        Alamofire.upload(
            multipartFormData: { MultipartFormData in
            //    multipartFormData.append(imageData, withName: "user", fileName: "user.jpg", mimeType: "image/jpeg")

            for key in parameters.keys{
                let name = String(key)
                if let val = parameters[name] as? String{
                    MultipartFormData.append(val.data(using: .utf8)!, withName: name)
                }
            }
    
            //Company Images
            var i = 0
            for loopValue in self.companyProfileImagesArray {
                if loopValue.imageType == .fromLocal {
                    if let companyData = loopValue.data {
                        MultipartFormData.append(companyData, withName: "uploadfile[\(i)]", fileName: "1.jpg", mimeType: "image/jpeg")
                        i += 1
                    }
                }
            }
                
            //Commodity Images
            var j = 0
            for loopValue in self.commodityProfileImagesArray {
                if loopValue.imageType == .fromLocal {
                    if let companyData = loopValue.data {
                        MultipartFormData.append(companyData, withName: "uploadcommodity[\(j)]", fileName: "1.jpg", mimeType: "image/jpeg")
                        j += 1
                    }
                }
            }
        }, to: urlPath) { (result) in
            
            switch result {
            case .success(let upload, _, _):

                upload.responseJSON { response in
                    
                    switch response.result {
                    case .success(let value):
//                        DispatchQueue.main.async {
//                            self.hideActivityIndicator()
//                        }
                        if let dict = value as? [String: AnyObject] {
                            
//                            DispatchQueue.main.async {
                                self.hideActivityIndicator()
//                            }

                            let statusText = JSONUtils.GetStringFromObject(object: dict, key: "status")
                            
                            if let error = dict["error"] as? Bool{
                                if !error {
                                    self.navigationController?.popViewController(animated: true)
                                }
                                else {
                                    self.showAlert(message: statusText)
                                }
                            }
                            print(dict)
                        }
                    case .failure(_):
                        DispatchQueue.main.async {
                            self.hideActivityIndicator()
                        }
                        print("Response error from server")
                    }
             }

            case .failure(let encodingError): break
                print(encodingError)
                DispatchQueue.main.async {
                    self.hideActivityIndicator()
                }
            }


        }
    }
    static func storyBoardInstance() -> EditCompanyAdminViewVC?{
               return UIStoryboard.Company.instantiateViewController(withIdentifier: self.id) as? EditCompanyAdminViewVC
    }

    private func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    //MARK:- API
//    private func post(companyId: String, name: String, about: String, commodity: String, industry: String, affiliation: String, address: String, phone: String, code: String, email: String, website: String, dayOpen: String, dayClose: String, openTime: String, closeTime: String, employeeId: String, companyPhotos: [Media]?, commodityPhotos: [Media]?){
//        if let window = UIApplication.shared.keyWindow {
//            let overlay = UIView(frame: CGRect(x: window.frame.origin.x, y: window.frame.origin.y, width: window.frame.width, height: window.frame.height))
//            overlay.alpha = 0.5
//            overlay.backgroundColor = UIColor.black
//            window.addSubview(overlay)
//            let av = UIActivityIndicatorView(style: .whiteLarge)
//            av.center = overlay.center
//            av.startAnimating()
//            overlay.addSubview(av)
//            self.view.endEditing(true)
//
//            service.updateCompanyAPI(companyId: companyId, name: name, about: about, commodity: commodity, industry: industry,affiliation: affiliation, address: address, phone: phone, code: code, email: email, website: website, dayOpen: dayOpen, dayClose: dayClose, openTime: openTime, closeTime: closeTime, employeeId : employeeId, companyPhotos: companyPhotos , commodityPhotos: commodityPhotos){ (success) in
//                if success {
//                    print("Company Details updated")
////                    NotificationCenter.default.post(name: Notification.Name("kCallCompanyDetailsAPI"), object: nil, userInfo: nil)
//                    av.stopAnimating()
//                    overlay.removeFromSuperview()
//                    self.navigationController?.popViewController(animated: true)
//                }
//                else {
//                    av.stopAnimating()
//                    overlay.removeFromSuperview()
//                    self.showAlert(message: "Error while update data")
//                }
//            }
//        }
//    }

}
extension EditCompanyAdminViewVC: UIPickerViewDelegate , UIPickerViewDataSource  {
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == openTimePicker  || pickerView == closeTimePicker {
             return 4
        } else {
            return 1
        }
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == dayFromPicker  || pickerView == dayToPicker {
            return days.count
        } else {
            if component == 0 {
                return hrs.count
            } else if component == 1 {
                return 1
            } else if component == 2 {
                return mnts.count
            }  else {
                return meridian.count
            }
        }
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == openTimePicker  || pickerView == closeTimePicker {
            if component == 0 {
                return  "\(hrs[row])"
            } else if component == 1 {
                return ":"
            } else if component == 2 {
                return "\(mnts[row])"
            } else {
                return "\(meridian[row])"
            }
        } else {
            return days[row]
        }
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == dayFromPicker {
            
            selectedDayFrom = days[row]
            if days[row] == "Monday" {
                dayFrom.text = "Mon   ▼"
            } else if days[row] == "Tuesday" {
                dayFrom.text = "Tue   ▼"
            } else if days[row] == "Wednesday" {
                dayFrom.text = "Wed   ▼"
            } else if days[row] == "Thursday" {
                dayFrom.text = "Thu   ▼"
            } else if days[row] == "Friday" {
                dayFrom.text = "Fri   ▼"
            } else if days[row] == "Saturday" {
                dayFrom.text = "Sat   ▼"
            } else if days[row] == "Sunday" {
                dayFrom.text = "Sun   ▼"
            }
        } else if pickerView == dayToPicker {
            
            selectedDayTo = days[row]
            if days[row] == "Monday" {
                dayTo.text = "Mon   ▼"
            } else if days[row] == "Tuesday" {
                dayTo.text = "Tue   ▼"
            } else if days[row] == "Wednesday" {
                dayTo.text = "Wed   ▼"
            } else if days[row] == "Thursday" {
                dayTo.text = "Thu   ▼"
            } else if days[row] == "Friday" {
                dayTo.text = "Fri   ▼"
            } else if days[row] == "Saturday" {
                dayTo.text = "Sat   ▼"
            } else if days[row] == "Sunday" {
                dayTo.text = "Sun   ▼"
            }
        } else if pickerView == openTimePicker {
            let hrsSelected = pickerView.selectedRow(inComponent: 0)
            let mntsSelected = pickerView.selectedRow(inComponent: 2)
            let meridianSelected = pickerView.selectedRow(inComponent: 3)
            
            selectedTimeFrom = "\(hrs[hrsSelected]) : \(mnts[mntsSelected]) \(meridian[meridianSelected])"
            timeFrom.text = selectedTimeFrom
            
            
        } else if pickerView == closeTimePicker {
            let hrsSelected = pickerView.selectedRow(inComponent: 0)
            let mntsSelected = pickerView.selectedRow(inComponent: 2)
            let meridianSelected = pickerView.selectedRow(inComponent: 3)
            
            selectedTimeTo = "\(hrs[hrsSelected]) : \(mnts[mntsSelected]) \(meridian[meridianSelected])"
            timeTo.text = selectedTimeTo
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if pickerView == openTimePicker || pickerView == closeTimePicker {
            return 60.0
        } else {
            return pickerView.frame.width
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 40.0
    }
}
extension EditCompanyAdminViewVC: FPNTextFieldDelegate{
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        print(isValid)
    }
    func fpnDidSelectCountry(name: String, dialCode: String, code: String, textField: UITextField) {
        //self.countryCodeTF.text = dialCode
        if textField == countryCodeTF {
            self.counCode = dialCode
        }
        print("This is from Edit profile", name, dialCode, code)
    }
}
extension EditCompanyAdminViewVC: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == phoneTF{
            _ = emailTF.becomeFirstResponder()
        } else if textField == emailTF{
            _ = addressTF.becomeFirstResponder()
        } /*else if textField == codeTextField {
            return false
        } */
        else if textField == addressTF {
            _ = websiteTF.becomeFirstResponder()
        }
        else if textField == websiteTF {
            aboutTextView.becomeFirstResponder()
        } else if textField == timeFrom {
            _ = timeTo.becomeFirstResponder()
        } else if textField == timeTo {
            return false
        }
        else {
            let nextTage=textField.tag + 1;
            // Try to find next responder
            let nextResponder=textField.superview?.viewWithTag(nextTage) as UIResponder?
            if (nextResponder != nil){
                // Found next responder, so set it.
                nextResponder?.becomeFirstResponder()
            } else {
                // Not found, so remove keyboard
                textField.resignFirstResponder()
            }
        }
        return false
    }
    
    /*func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField == timeFrom {
            if (textField.text?.contains("AM"))! {
                textField.text = textField.text?.replacingOccurrences(of: "AM", with: "")
            }
            textField.text = "\(textField.text!) AM"
        }
        if textField == timeTo {
            if (textField.text?.contains("AM"))! {
                textField.text = textField.text?.replacingOccurrences(of: "AM", with: "")
            }
            textField.text = "\(textField.text!) AM"
        }
    }*/
    
    /*func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField == companyTextField {
            tableView.isHidden = true
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == companyTextField {
            _ = companyTextField.resignFirstResponder()
            tableView.isHidden = false
            return true
        }
        return true
    }*/
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == phoneTF{
            let maxLength = 10
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        else if textField == self.companyNameTF && self.companyName != "" {
            
            self.companyNameTF.showErrorWithText(errorText: "Kindly Contact Moderator for updating company name!")
            return false
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField as? ACFloatingTextfield
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeTextField = nil
    }
}
extension EditCompanyAdminViewVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.dataSource.count != 0 {
            print("Count of employees : \(self.dataSource.count)")
            return self.dataSource.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell: AdminViewEmployeeTVCell = tableView.dequeueReusableCell(withIdentifier: "admin_view_emp_list", for: indexPath) as? AdminViewEmployeeTVCell {
            
            print("Name : \(self.dataSource[indexPath.row].first_name)  \(self.dataSource[indexPath.row].last_name)")
            print("Designation : \(self.dataSource[indexPath.row].designation)")
            print("company Name: \(self.dataSource[indexPath.row].companyName)")
            
            let name = self.dataSource[indexPath.row].first_name + " " + self.dataSource[indexPath.row].last_name
            let designation = self.dataSource[indexPath.row].designation
            let company = self.dataSource[indexPath.row].companyName
            cell.nameLbl.text = name
            cell.compDesigLbl.text = designation + " • " + company.firstLetterUppercased()
            
            let profilePic = self.dataSource[indexPath.row].profilePic
            let colorCode = self.dataSource[indexPath.row].colorcode
            
            cell.profileView.updateViews(name: name, url: profilePic,  colorCode: colorCode)
            
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
            
            cell.adminBtn.isUserInteractionEnabled = false
            if self.dataSource[indexPath.row].isAdmin {
                cell.adminBtn.isHidden = false
            } else {
                cell.adminBtn.isHidden = true
            }
            
            //Employee UserID array
            self.empUserIDArray.removeDuplicates()
            let userId = dataSource[indexPath.row].userId
            self.empUserIDArray.append(userId)
            self.empUserIDArray.removeDuplicates()
            print("Appended userId : \(self.empUserIDArray)")
            self.employeeUserIds = self.empUserIDArray.joined(separator: ",")
            print("Employee id's : \(self.employeeUserIds)")
            return cell
        } else {
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 62
    }
    
    @objc private func toFriendView(_ sender: UITapGestureRecognizer){
        let userId = dataSource[sender.view!.tag].userId
        performFriendView(friendId: userId)
    }
}
/*
extension EditCompanyAdminViewVC: GalleryControllerDelegate{
    func DidLimitExceeded(_ controller: UIViewController) {
        let alert = UIAlertController(title: "limit Exceeded", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        controller.present(alert, animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        if controller == companyGallery {
            self.companyImageDS = images
            self.companyView.isHidden = true
            self.companyCollectionView.isHidden = false
            self.companyCollectionView.reloadData()
            companyGallery.dismiss(animated: true, completion: nil)
        }
        if controller == commodityGallery {
            self.commodityImageDS = images
            self.commodityView.isHidden = true
            self.commodityCollectionView.isHidden = false
            self.commodityCollectionView.reloadData()
            commodityGallery.dismiss(animated: true, completion: nil)
        }
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        if controller == companyGallery {
            companyGallery.cart.reload(companyImageDS)
            companyGallery.dismiss(animated: true, completion: nil)
        } else {
            commodityGallery.cart.reload(commodityImageDS)
            commodityGallery.dismiss(animated: true, completion: nil)
        }
    }
} */

extension EditCompanyAdminViewVC: EmplUserDelegate{
    func getUserData(id: String, name: String, firstName: String, lastName: String, designation: String, profilePic: String, colorCode: String) {
        DispatchQueue.main.async {
            let emplData: [String: AnyObject] = ["userId" : id as AnyObject, "name"  : name as AnyObject, "first_name" : firstName as AnyObject, "last_name" : lastName as AnyObject, "initials": name.initials(), "designation": designation as AnyObject,"profilePic" : profilePic as AnyObject, "colorcode" : colorCode as AnyObject, "companyName": self.companyName as AnyObject ]
            let viewItems = Employees(dict: emplData)
            
            self.dataSource.append(viewItems)
            
            print("Employee added : \(self.dataSource.last?.name) Userid : \(self.dataSource.last?.userId)")
            self.employeeTableView.beginUpdates()
            self.employeeTableView.insertRows(at: [IndexPath(row: self.dataSource.count - 1, section: 0)], with: .automatic)
            self.employeeTableView.endUpdates()
            self.employeeTableView.reloadData()
            self.emplTVHeightConstraint.constant = self.employeeTableView.contentSize.height + 28 + 63 + 28
        }
    }
}


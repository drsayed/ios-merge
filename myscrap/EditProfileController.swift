//
//  EditProfileController.swift
//  myscrap
//
//  Created by MS1 on 1/25/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import FlagPhoneNumber
import CoreTelephony
import DKImagePickerController
import ALCameraViewController
import CropViewController
import ADCountryPicker
import Firebase
import FirebaseAuth
protocol EditProfileDelegate: class {
    func didUpdateProfile()
}


class EditProfileController: BaseRevealVC,UIGestureRecognizerDelegate,CropViewControllerDelegate { //BaseVC
    
    @IBOutlet weak var biodataSeperator: UIView!
    var countrycodeArray: [Ccode]{
        return Ccode.getcountryCode() ?? []
    }
    @IBOutlet weak var frontCrossBtn: UIButton!
    @IBOutlet weak var backCrossBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var cardFrontImageView: UIImageView!
    @IBOutlet weak var hideMobileButton: UIButton!
    @IBOutlet weak var ccardBackImageView: UIImageView!
      var countrycode = ""
    var phone = ""
    var phoneExist : Bool = false
     var profileItemEdit : EditProfileItem?
    var isNeedToDismiss :Bool = false
    var isFromIncompleteProfile :Bool = false

    var paramterString : String = ""
    var cropViewController :CropViewController = CropViewController(image:UIImage())
    @IBOutlet weak var firstNameTextField: ACFloatingTextfield!
    @IBOutlet weak var lastNameTextField: ACFloatingTextfield!
    @IBOutlet weak var positionTextField: ACFloatingTextfield!
    @IBOutlet weak var businessCardFrontButton: UIButton!
    @IBOutlet weak var businessCardBackButton: UIButton!
    @IBOutlet weak var companyTextField: CompanySearchTextField!
    @IBOutlet weak var emailTextField: ACFloatingTextfield!
    @IBOutlet weak var countryTextField: ACFloatingTextfield!
    @IBOutlet weak var codeTextField: FPNTextField!
    @IBOutlet weak var phoneTextField: ACFloatingTextfield!
    @IBOutlet weak var subCodeTextField: FPNTextField!
    @IBOutlet weak var subPhoneTextField: ACFloatingTextfield!
    @IBOutlet weak var websiteTextField: ACFloatingTextfield!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bioTextView: RSKPlaceholderTextView!
    @IBOutlet weak var tableviewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var hideBussinessCardButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var postButton: UIBarButtonItem!
    @IBOutlet weak var hereTo: UISegmentedControl!
    @IBOutlet weak var cityTextField: ACFloatingTextfield!
    
    @IBOutlet weak var bioHeader: UILabel!

    var cardShow: String = "0"
       var showPhone: String = "0"
    var businessCardFront: String = ""
    var businessCardBack: String = ""
    var isFrontImage : Bool = true
    
    var isOfficeNumber : Bool = false
     var isOfficenumberVarified : Bool = false
     var isMobileNumberVarified : Bool = false
    var varifiedOfficeNumber : String = ""
        var varifiedMobileNumber : String = ""
    
    var selectedCompany: SignUPCompanyItem?{
        didSet{
            if let item = selectedCompany{
                companyTextField.text = item.name
            } else {
                companyTextField.text = ""
            }
        }
    }
    weak var delegate: EditProfileDelegate?
    
    var imageChanged = false
    
    let commodityService = Interests()
    
    lazy var commodities : [String] = {
        return commodityService.userCommodityDictionary
    }()
    
    lazy var roles : [String] = {
        return commodityService.usersRoleData
    }()
    
    var selectedCommodity = [String]()
    var selectedRoles = [String]()
    
    var countryCodePickerView = UIPickerView()
    
    
    fileprivate var activeTextField: ACFloatingTextfield?
    //fileprivate var profileData: ProfileData?
    
    
    fileprivate var companyDataSource = [CompanyItem]()
    fileprivate var filteredDataSource = [CompanyItem]()
    
    let apiClient = CompanyService()
    fileprivate var loadMore = true
    var searchText = ""
    var userHereTo = ""
    var counCode:String!
    var offCCode:String!
    
    let maxCharacters = 255

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        /*if countryTextField.text == "" && codeTextField.text == "" {
            countryTextField.text = "Afghanistan"
            codeTextField.text = "+93"
        }*/
         bioTextView.delegate = self

        codeTextField.textColor = UIColor.black
        postButton.isEnabled = false
        scrollView.isHidden = true
        //setup(textFields: [firstNameTextField,lastNameTextField,positionTextField,companyTextField,countryTextField,codeTextField,phoneTextField,websiteTextField])
        setup(textFields: [firstNameTextField,lastNameTextField,positionTextField,companyTextField,countryTextField,phoneTextField,subPhoneTextField,websiteTextField])
        setupCollectionView()
        getEditProfile()
        setupTableView()
        setupScrollView()
        fetchCompanies()
        setupImageView()
        
        codeTextField.delegate = self
        codeTextField.editProfileSetBottomBorderEnabled()
        //codeTextField.parentViewController = self
        codeTextField.placeholder = ""
        codeTextField.flagButton.setSize(width: 40, height: 35)
        
        
        subCodeTextField.delegate = self
        subCodeTextField.editProfileSetBottomBorderEnabled()
        //subCodeTextField.parentViewController = self
        subCodeTextField.placeholder = ""
        subCodeTextField.flagButton.setSize(width: 40, height: 35)
        
        codeTextField.phoneCodeTextField.text = "+971" + " ▼"
        codeTextField.setFlag(for: FPNCountryCode(rawValue: "AE")!)
        subCodeTextField.phoneCodeTextField.text = "+971" + " ▼"
        subCodeTextField.setFlag(for: FPNCountryCode(rawValue: "AE")!)
//        setupCodeTextField()
        
        if #available(iOS 13, *){
            self.bioHeader.font = UIFont(name: "Times New Roman", size: 13)
        }
        else {
            self.bioHeader.font = UIFont.systemFont(ofSize: 13)
        }

    }
    
    
    var countryArray : [CountryModel]!
//    private func setupCodeTextField(){
//        countryArray = [CountryModel]()
//
//        if let path = Bundle.main.path(forResource: "countrycode", ofType: "json") {
//            do {
//                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
//                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as! NSDictionary
//
//                if let jsonArray = jsonResult.object(forKey: "country_code") as? [NSDictionary] {
//                    // do stuff
//                    for dict in jsonArray{
//                        let countryModel = CountryModel.init(dict: dict)
//                        countryArray.append(countryModel!)
//                    }
//                }
//            } catch {
//                // handle error
//            }
//        }
//
//        // Top TextField
//        let dropDownTop = VPAutoComplete()
//        dropDownTop.dataSource = countryArray
//        dropDownTop.onTextField = codeTextField // Your TextField
//        dropDownTop.onView = self.view // ViewController's View
//        dropDownTop.isFilterByName = true
//        //        dropDownTop.textFieldView = self.topTextField // If There is custom view you used for textfield
//        dropDownTop.show { (str, index) in
//            print("string : \(str) and Index : \(index)")
//            let country : CountryModel = self.countryArray[index]
////            self.codeTextField.text = "\(String(describing: country.countryCode!)) \(String(describing: country.countryName!))"
//            self.codeTextField.text = String(describing: country.countryCode!)
//        }
//
//    }
    

    @IBAction func frontCrossedPressed(_ sender: Any) {
        
        self.cardFrontImageView.image = try! UIImage.init(imageName: "add-image")
        self.frontCrossBtn.isHidden = true
        self.businessCardFront = ""
    }
    @IBAction func backCrossPressed(_ sender: Any) {
       
        self.ccardBackImageView.image = try! UIImage.init(imageName: "add-image")
        self.backCrossBtn.isHidden = true
        self.businessCardBack = ""

    }
    @IBAction func cardFrontButtonPrressed(_ sender: Any) {
        
        
isFrontImage = true
        /// Provides an image picker wrapped inside a UINavigationController instance
//        let imagePickerViewController = CameraViewController.imagePickerViewController(croppingParameters:CroppingParameters(isEnabled: true, allowResizing: truebusinessCardFront, allowMoving: true, minimumSize: CGSize(width: 50, height: 50))) { [weak self] image, asset in
//                // Do something with your image here.
//                // If cropping is enabled this image will be the cropped version
//            self!.cardFrontImageView.image = image;
//                               //       self.businessCardFrontButton.setImage(fixOrientationImage, for: .normal)
//                      self!.businessCardFront = Common.encode(toBase64String: image!)
//            self?.dismiss(animated: true, completion: nil)
//        }

//        present(imagePickerViewController, animated: true, completion: nil)
//
//        let cameraViewController = CameraViewController.init(croppingParameters: CroppingParameters(), allowsLibraryAccess: true, allowsSwapCameraOrientation: true, allowVolumeButtonCapture: false, completion:{ [weak self] image, asset in
//            // Do something with your image here.
////            let fixOrientationImage=img.fixOrientation()
//
//            self?.dismiss(animated: true, completion: nil)
//        })

      //  self.present(imagePickerViewController, animated: true, completion: nil)
        
        let pickerController = DKImagePickerController()
              pickerController.assetType = .allPhotos
              pickerController.maxSelectableCount=1;
             pickerController.singleSelect = true
              pickerController.showsCancelButton = true;
              pickerController.showsEmptyAlbums = false;
            pickerController.inline = false
              pickerController.allowMultipleTypes = false;
             // pickerController.defaultSelectedAssets = self.imagesToPosts;
              pickerController.didSelectAssets = { (assets: [DKAsset]) in
                  print("didSelectAssets")
                  print(assets)
                for imageData in assets {
                imageData.fetchOriginalImage(completeBlock: { image, info in
                               if let img = image {

                                 self.cropViewController = CropViewController(image: img)
                                      self.cropViewController.delegate = self
   //                             self.cropViewController.showActivitySheetOnDone = true
                                self.present(self.cropViewController, animated: true, completion: nil)
                                
                                
                   //     let fixOrientationImage=img.fixOrientation()
                             //   self.cardFrontImageView.image = fixOrientationImage;
                 //       self.businessCardFrontButton.setImage(fixOrientationImage, for: .normal)
                       // self.businessCardFront = Common.encode(toBase64String: image!)
                             //    self.frontCrossBtn.isHidden = false
                            //    self.cropView.delegate = self

                    }
                           })
                }
              }
              pickerController.modalPresentationStyle = .overFullScreen
              self.present(pickerController, animated: true, completion: nil)
    }
    func cropViewController(_ cropViewController: CropViewController,
            didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        
        
        if isFrontImage  {
            let fixOrientationImage = image.fixOrientation()
                        self.cardFrontImageView.image = fixOrientationImage;
                                 //       self.businessCardFrontButton.setImage(fixOrientationImage, for: .normal)
                 self.businessCardFront = Common.encode(toBase64String: image)
             self.frontCrossBtn.isHidden = false
        }
        else
        {
            let fixOrientationImage = image.fixOrientation()
            self.ccardBackImageView.image = fixOrientationImage;
            self.businessCardBack = Common.encode(toBase64String: image)
                self.backCrossBtn.isHidden = false
        }
            
        self.cropViewController.dismiss(animated: true) {
            
        }
           // 'image' is the newly cropped version of the original image
       }
    @IBAction func cardBackButtonPressed(_ sender: Any) {
        
        isFrontImage = false
         let pickerController = DKImagePickerController()
                     pickerController.assetType = .allPhotos
                    pickerController.singleSelect = true
                     pickerController.maxSelectableCount=1;
                     pickerController.showsCancelButton = true;
                     pickerController.showsEmptyAlbums = false;
                     pickerController.allowMultipleTypes = false;
                    // pickerController.defaultSelectedAssets = self.imagesToPosts;
                     pickerController.didSelectAssets = { (assets: [DKAsset]) in
                         print("didSelectAssets")
                         print(assets)
                       for imageData in assets {
                       imageData.fetchOriginalImage(completeBlock: { image, info in
                                      if let img = image {
                                       
                            
                            self.cropViewController = CropViewController(image: img)
                           self.cropViewController.delegate = self
                                          //                             self.cropViewController.showActivitySheetOnDone = true
                         self.present(self.cropViewController, animated: true, completion: nil)
                                        
//                               let fixOrientationImage=img.fixOrientation()
//                                self.ccardBackImageView.image = fixOrientationImage;
//                             //  self.businessCardBackButton.setImage(fixOrientationImage, for: .normal)
//                                 self.businessCardBack = Common.encode(toBase64String: image!)
                                      }
                                  })
                       }
                     }
                     pickerController.modalPresentationStyle = .overFullScreen
                     self.present(pickerController, animated: true, completion: nil)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
      
        
        if let reveal = self.revealViewController() {
           // self.mBtn.target(forAction: #selector(reveal.revealToggle(_:)), withSender: self.revealViewController())
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        if isFromIncompleteProfile
        {
        self.mBtn.isHidden = true
        }
    }
  
    
    
    private func setupImageView(){
        imageView.layer.cornerRadius = imageView.bounds.size.width / 2
        imageView.clipsToBounds = true
        print("Profile image : \(AuthService.instance.profilePic)")
        if AuthService.instance.profilePic == "" || AuthService.instance.profilePic == "https://myscrap.com/style/images/icons/no-profile-pic-female.png"{
            imageView.image = #imageLiteral(resourceName: "default-profile-pic-png-5")
        } else {
            imageView.sd_setImage(with: URL(string: AuthService.instance.profilePic), completed: nil)
        }
        
        let userImgTap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(profileImageTapped(tapGesture:)))
        //tapGesture.delegate = self
        userImgTap.numberOfTapsRequired = 1
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(userImgTap)
    }
    
    func setupScrollView(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(cancelTap))
        tap.numberOfTapsRequired = 1
        tap.delegate = self
        tap.cancelsTouchesInView = false
        self.scrollView.addGestureRecognizer(tap)
    }
    
    @IBAction func hideMobileButtonPressed(_ sender: Any) {
        self.hideMobileButton.isSelected =  !self.hideMobileButton.isSelected
        if  self.hideMobileButton.isSelected {
                  showPhone = "1"
              }
              else
              {
                  showPhone = "0"
              }
    }
    @objc func profileImageTapped(tapGesture:UITapGestureRecognizer) {
        if let vc = ChangePhotoVC.storyBoardInstance(){
            vc.image = self.imageView.image
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let touchView = touch.view, touchView.isDescendant(of: tableView){
            return false
        }
        if let touchView = touch.view, touchView.isDescendant(of: collectionView){
            return false
        }
        
        return true
    }
    
    
    func setCountryText(_ index: Int){
        //countryTextField.text = CountryCode.countryNameArray[index]
        countryTextField.text = countrycodeArray[index].CountryName
        codeTextField.text = countrycodeArray[index].CountryCode
    }
    
    
    
    private func fetchCompanies(){
        
        /*apiClient.fetchCompanies { dataSource, error in
            DispatchQueue.main.async {
                guard let data = dataSource else { return }
                self.companyDataSource = data
            }
        }*/
        apiClient.getAllCompanies(pageLoad: "0", searchText: "", countryFilter: "") { (result) in
            DispatchQueue.main.async {
                switch result{
                case .Error(let _):
                    print("Error in company edit profile")
                case .Success(let data):
                    print("company data count",self.companyDataSource.count)
                    let newData = data
                    //newData.removeDuplicates()
                    self.companyDataSource = newData
                    self.tableView.reloadData()
                    
                    print("company Data count after appended: \(newData.count)")
                    DispatchQueue.main.async {
                        self.hideActivityIndicator()
                    }
                }
            }
        }
    }
    
    private func getCompaniesMore(pageLoad: Int, searchText: String, countryFilter: String, completion: @escaping (Bool) -> () ){
        apiClient.getAllCompanies(pageLoad: "\(pageLoad)", searchText: searchText, countryFilter: countryFilter) { (result)  in
            DispatchQueue.main.async {
                switch result{
                case .Error(let _):
                    completion(false)
                case .Success(let data):
                    print("Company data count load more",self.companyDataSource.count)
                    var newData = self.companyDataSource + data
                    newData.removeDuplicates()
                    self.companyDataSource = newData
                    self.tableView.reloadData()
                    self.loadMore = true
                    print("&&&&&&&&&&& DATA : \(newData.count)")
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
        if !companyDataSource.isEmpty{
            let currentOffset = scrollView.contentOffset.y
            let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
            let deltaOffset = maximumOffset - currentOffset
            if deltaOffset <= 0 {
                if loadMore{
                    loadMore = false
                    self.getCompaniesMore(pageLoad: companyDataSource.count, searchText: self.searchText, countryFilter: "",completion: { _ in })
                }
            }
        }
    }
    
    func resignResponders(){
        activeTextField?.resignFirstResponder()
        self.biodataSeperator.backgroundColor = .black
        bioTextView.resignFirstResponder()
    }
    
    @objc func cancelTap(){
        resignResponders()
    }
    
    
    private func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        view.layoutIfNeeded()
        heightConstraint.constant = collectionView.collectionViewLayout.collectionViewContentSize.height
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleCollectionViewTap(_:)))
        tap.numberOfTapsRequired = 1
        //    tap.delegate = self
        collectionView.addGestureRecognizer(tap)
        
    }
    
    @objc private func handleCollectionViewTap(_ sender: UITapGestureRecognizer){
        if let ip = self.collectionView?.indexPathForItem(at: sender.location(in: self.collectionView)) {
            collectionView(collectionView, didSelectItemAt: ip)
        } else {
            resignResponders()
        }
    }
    
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 89
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(CompaniesCell.nib, forCellReuseIdentifier: CompaniesCell.identifier)
        tableView.isHidden = true
    }
    
    private func setup(textFields: [ACFloatingTextfield]){
        for textfield in textFields{
            textfield.delegate = self
        }
    }
    
    private func getEditProfile(){
        EditProfileItem.getEditProfile { [weak self](profile) in
            DispatchQueue.main.async {
                if let profile = profile{
                    if let cName = profile.company, let cID = profile.companyId {
                                                                                  AuthService.instance.companyId = cID
                                                                                  AuthService.instance.company = cName
                                                                                   
                                                                              }
                    self!.profileItemEdit = profile;
                    self?.configureTextFields(with: profile)
                }
            }
        }
    }
    
    
    @IBAction func hideBusinessCardPressed(_ sender: Any) {
        self.hideBussinessCardButton.isSelected = !self.hideBussinessCardButton.isSelected
        if  self.hideBussinessCardButton.isSelected {
            cardShow = "1"
        }
        else
        {
            cardShow = "0"
        }
    }
    private func configureTextFields(with profileItem: EditProfileItem){
        self.scrollView.isHidden = false
        self.postButton.isEnabled = true
       
        if profileItem.userHereFor == "0" {
            self.hereTo.selectedSegmentIndex = 0
        } else {
            self.hereTo.selectedSegmentIndex = 1
        }
        if profileItem.cardShow == "0" {
             self.hideBussinessCardButton.isSelected = false
                    cardShow = "0"
              } else {
            self.hideBussinessCardButton.isSelected = true

                    cardShow  = "1"
              }
        if profileItem.showPhone == "0" {
            self.hideMobileButton.isSelected = false
                showPhone = "0"
                     } else {
              self.hideMobileButton.isSelected = true
                           showPhone = "1"
                     }
        if profileItem.cardFront == "" {
            self.cardFrontImageView.image = try! UIImage.init(imageName: "add-image")
              self.frontCrossBtn.isHidden = true
        } else {
            self.cardFrontImageView.setImageWithIndicator(imageURL: profileItem.cardFront!)
              self.frontCrossBtn.isHidden = false
                 }
        if profileItem.cardBack == "" {
         self.ccardBackImageView.image = try! UIImage.init(imageName: "add-image")
            self.backCrossBtn.isHidden = true
            
                 } else {
            self.ccardBackImageView.setImageWithIndicator(imageURL:profileItem.cardBack!)
              self.backCrossBtn.isHidden = false
                 }
        if profileItem.code == "" {
            codeTextField.phoneCodeTextField.text = "+971" + " ▼"
            codeTextField.setFlag(for: FPNCountryCode(rawValue: "AE")!)
            
        } else {
            
            /*counCode = profileItem.code
            let locale = Locale.current
            let regionCode = locale.regionCode
            print("Region code ",regionCode)
            if profileItem.userLocation != "" {
                //let isoCode = locale(for: profileItem.userLocation!)
                codeTextField.setFlag(for: FPNCountryCode(rawValue: regionCode!)!)
            } else {
                
            }
            codeTextField.phoneCodeTextField.text = counCode + " ▼"*/
            print("Fetched country dialer code : \(profileItem.code)")
            counCode = profileItem.code
            if let code = counCode {
                if code.contains("+") {
                    let dialerCode = code.replacingOccurrences(of: "+", with: "")
                    //Getting list of country Region code
                    let regionCode = getcountryRegionCode(countryCallingCode: dialerCode)
                    //let regionCode = getSingle(dialCode: dialerCode)
                    print("Result of region code :\(regionCode)")
                    //Assign region code into flag value
                    codeTextField.setFlag(for: FPNCountryCode(rawValue: regionCode)!)
                    codeTextField.phoneCodeTextField.text = counCode + " ▼"
                } else {
                    //Getting list of country Region code
                    let regionCode = getcountryRegionCode(countryCallingCode: counCode)
                    //let regionCode = getSingle(dialCode: code)
                    print("Result of region code :\(regionCode)")
                    //Assign region code into flag value
                    codeTextField.setFlag(for: FPNCountryCode(rawValue: regionCode)!)
                    codeTextField.phoneCodeTextField.text = counCode + " ▼"
                }
            }
        }
        
        if profileItem.officePhoneCode == "" {
            subCodeTextField.phoneCodeTextField.text = "+971" + " ▼"
            subCodeTextField.setFlag(for: FPNCountryCode(rawValue: "AE")!)
        } else {
            offCCode = profileItem.officePhoneCode
            if let code = offCCode {
                if code.contains("+") {
                    let dialerCode = code.replacingOccurrences(of: "+", with: "")
                    if dialerCode == "" {
                        print("Flag can't be set")
                        subCodeTextField.phoneCodeTextField.text = offCCode + " ▼"
                    } else {
                        //Getting list of country Region code
                        let regionCode = getcountryRegionCode(countryCallingCode: dialerCode)
                        //let regionCode = getSingle(dialCode: dialerCode)
                        print("Result of region code :\(regionCode)")
                        //Assign region code into flag value
                        subCodeTextField.setFlag(for: FPNCountryCode(rawValue: regionCode)!)
                        subCodeTextField.phoneCodeTextField.text = offCCode + " ▼"
                    }
                    
                } else {
                    //Getting list of country Region code
                    let regionCode = getcountryRegionCode(countryCallingCode: offCCode)
                    //let regionCode = getSingle(dialCode: code)
                    print("Result of region code :\(regionCode)")
                    //Assign region code into flag value
                    subCodeTextField.setFlag(for: FPNCountryCode(rawValue: regionCode)!)
                    subCodeTextField.phoneCodeTextField.text = offCCode + " ▼"
                }
            }
            subCodeTextField.phoneCodeTextField.text = offCCode + " ▼"
        }
        let mofileEditing = UserDefaults.standard.value(forKey: "MobileEdited" + AuthService.instance.userId) as? String
        if mofileEditing == "1" {
            codeTextField.isEnabled = false
            codeTextField.textColor = UIColor.darkGray
            phoneTextField.isEnabled = false
             phoneTextField.textColor = UIColor.darkGray
        }
        
        self.cityTextField.text = profileItem.city
        self.firstNameTextField.text = profileItem.firstName
        self.lastNameTextField.text = profileItem.lastName
        self.positionTextField.text = profileItem.designation
        self.companyTextField.text = profileItem.company
        self.bioTextView.text = profileItem.userBio
        self.countryTextField.text = profileItem.userLocation
        self.phoneTextField.text = profileItem.phoneNumber
        self.websiteTextField.text = profileItem.website
        self.selectedRoles = profileItem.userRolesArray
        self.selectedCommodity = profileItem.userCommoditiesArray
        self.emailTextField.text = profileItem.email
        
        //Missing  params
        self.subPhoneTextField.text = profileItem.officePhoneNumber
        collectionView.reloadData()
        self.firstNameTextField.becomeFirstResponder()
    }
    func getSingle(dialCode: String) -> String {
        let prefixCodes = ["380": "UA"]
        let countryRegCode = prefixCodes[dialCode]
        return countryRegCode!
    }
    
    func getcountryRegionCode(countryCallingCode:String)->String{
        
        let prefixCodes = ["93": "AF", "971": "AE", "355": "AL", "599": "AN", "376": "AD", "244": "AO", "54": "AR", "374": "AM", "297": "AW", "61":"AU", "43": "AT", "994": "AZ", "973":"BH", "226": "BF", "257": "BI", "880": "BD", "375": "BY", "32":"BE", "501": "BZ", "229": "BJ", "975" : "BT", "387" : "BA", "267": "BW", "55": "BR", "359": "BG", "591": "BO", "590": "BL", "673": "BN", "243":"CD","225": "CI", "855":"KH", "237": "CM", "238": "CV", "345" :"KY", "236" :"CF", "41": "CH", "56": "CL", "86":"CN", "57": "CO", "269": "KM", "242":"CG", "682": "CK", "506": "CR", "53":"CU", "537":"CY", "420": "CZ", "49": "DE", "45": "DK", "253":"DJ", "213": "DZ", "593": "EC", "20":"EG", "291": "ER", "372":"EE","34": "ES", "251": "ET", "691": "FM", "500": "FK", "298": "FO", "679": "FJ", "358":"FI", "33": "FR", "44":"GB", "594": "GF", "241":"GA", "220":"GM", "995":"GE","233":"GH", "350": "GI", "240": "GQ", "30": "GR", "299": "GL", "502": "GT", "224" : "GN", "245": "GW", "595": "GY", "509": "HT", "385": "HR", "504":"HN", "36": "HU", "852": "HK", "98": "IR", "972": "IL", "246":"IO", "354": "IS", "91": "IN", "62":"ID", "964":"IQ", "353": "IE","39":"IT", "81": "JP", "962": "JO", "850": "KP", "82": "KR","77":"KZ", "254": "KE", "686": "KI", "965": "KW", "996":"KG", "371": "LV", "961": "LB", "94":"LK", "266": "LS", "231":"LR", "423": "LI", "370": "LT", "352": "LU", "856": "LA", "218":"LY", "853": "MO", "389": "MK", "261":"MG", "265": "MW", "60": "MY","960": "MV", "223":"ML", "356": "MT", "692": "MH", "596": "MQ", "222":"MR", "230": "MU", "52": "MX","377": "MC", "976": "MN", "382": "ME", "212":"MA", "95": "MM", "373":"MD", "258": "MZ", "264":"NA", "674":"NR", "977":"NP", "31": "NL","687": "NC", "64":"NZ", "505": "NI", "227": "NE", "234": "NG", "683":"NU", "672": "NF", "47": "NO", "968": "OM", "92": "PK", "508": "PM", "680": "PW", "689": "PF", "507": "PA", "675" : "PG", "51": "PE", "63": "PH", "48":"PL", "872": "PN","351": "PT", "970": "PS", "974": "QA", "40":"RO", "262":"RE", "381": "RS", "7": "RU", "250": "RW", "378": "SM", "966":"SA", "221": "SN", "248": "SC", "232":"SL","65": "SG", "421": "SK", "386": "SI", "677":"SB", "290": "SH", "249": "SD", "597": "SR","268": "SZ", "46":"SE", "503": "SV", "239": "ST","252": "SO", "963":"SY", "886": "TW", "255": "TZ", "670": "TL", "235": "TD", "992": "TJ", "66": "TH", "228":"TG", "690": "TK", "676": "TO", "216":"TN","90": "TR", "993": "TM", "688":"TV", "256": "UG", "380": "UA", "1": "US", "598": "UY","998": "UZ", "379":"VA", "58":"VE", "84": "VN", "678":"VU", "685": "WS", "681": "WF", "967": "YE", "27": "ZA", "260": "ZM", "263":"ZW"]
        let countryRegCode = prefixCodes[countryCallingCode]
        return countryRegCode!
        
    }
    
    func counrtyNames() -> NSArray{
        
        let countryCodes = NSLocale.isoCountryCodes
        let countries:NSMutableArray = NSMutableArray()
        
        for countryCode  in countryCodes{
            let dictionary : NSDictionary = NSDictionary(object: countryCode, forKey: NSLocale.Key.countryCode as NSCopying)
            
            //get identifire of the counrty
            var identifier:NSString? = NSLocale.localeIdentifier(fromComponents: dictionary as! [String : String]) as NSString
            
            let locale = (Locale.current as NSLocale).displayName(forKey: .countryCode, value: countryCode)
            
            //get country name
            let country = locale
            //replace "NSLocaleIdentifier"  with "NSLocaleCountryCode" to get language name
            
            if country != nil {//check the country name is  not nil
                countries.add(country!)
            }
        }
        NSLog("\(countries)")
        return countries
    }
    
    private func locale(for fullCountryName : String) -> String {
        var locales : String = ""
        for localeCode in NSLocale.isoCountryCodes {
            let identifier = NSLocale(localeIdentifier: localeCode)
            let countryName = identifier.displayName(forKey: NSLocale.Key.countryCode, value: localeCode)
            if fullCountryName.lowercased() == countryName?.lowercased() {
                return localeCode as! String
            }
        }
        return locales
    }
    
    fileprivate var companyId = ""
    
    @IBAction func companyTextFieldDidChanged(_ sender: Any) {
        //companyId = ""
        //filterCompnay()
    }
    
    fileprivate func filterCompnay(){
        if let text = companyTextField.text , text != "" {
            tableView.isHidden = false
            let lower = text.lowercased()
            searchText = text
            apiClient.getAllCompanies(pageLoad: "0", searchText: searchText, countryFilter: "") { (result) in
                print("Filtered values")
                DispatchQueue.main.async {
                    switch result{
                    case .Error(let _):
                        print("Country fetch error")
                    case .Success(let data):
                        self.companyDataSource = data
                        self.filteredDataSource = self.companyDataSource.filter({( company : CompanyItem) -> Bool in
                            return company.name.lowercased().contains(self.searchText.lowercased())
                        })
                        self.tableView.reloadData()
                        print("Filtered data count :\(self.filteredDataSource.count)")
                    }
                }
            }
            //filteredDataSource = companyDataSource.filter({$0.name.lowercased().range(of: lower) != nil})
            //tableView.reloadData()
            updateConstraints()
        } else {
            filteredDataSource = [CompanyItem]()
            tableView.reloadData()
            tableView.isHidden = true
        }
    }
    
    func updateConstraints(){
        self.tableView.layoutIfNeeded()
        if tableView.contentSize.height > 267 {
            tableviewHeightConstraint.constant = 267
        } else {
            tableviewHeightConstraint.constant = tableView.contentSize.height
        }
    }
    
    @IBAction private func changePhotoPressed(){
        /*let croppingParameters = CroppingParameters(isEnabled: true, allowResizing: false, allowMoving: true, minimumSize: CGSize.zero)
        let cameraViewController = CameraViewController.imagePickerViewController(croppingParameters: croppingParameters) { [weak self](image, asset) in
            if let img = image {
                self?.imageView.image = img
                let service = APIService()
                service.endPoint = Endpoints.EDIT_PROFILE_PIC_URL
                
                let imageData: Data = UIImageJPEGRepresentation(img, 0.6)!
                let imageString =  imageData.base64EncodedString(options: .lineLength64Characters)
                service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&profilePic=\(imageString)".replacingOccurrences(of: "+", with: "%2B")
                service.getDataWith(completion: { (result) in
                })
            }
            self?.dismiss(animated: true, completion: nil)
        }
        present(cameraViewController, animated: true, completion: nil)*/
        if let vc = ChangePhotoVC.storyBoardInstance(){
            vc.image = self.imageView.image
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func postButtonClicked(_ sender: Any) {
        dismissKeyboard()
        guard let fnm = firstNameTextField.text , fnm != "" , let lnm = lastNameTextField.text , lnm != ""  else {
            // Alert for FirstName and lastname
            let alert = UIAlertController(title: "First Name and Last Name are mandatory. Please Fill", message: nil, preferredStyle: .alert)
            alert.view.tintColor = UIColor.GREEN_PRIMARY
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        guard let phone = phoneTextField.text, phone != "" else {
            // Alert for FirstName and lastname
            let alert = UIAlertController(title: "Phone number should not be empty", message: nil, preferredStyle: .alert)
            alert.view.tintColor = UIColor.GREEN_PRIMARY
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        guard let email = emailTextField.text, email != "" else {
            // Alert for FirstName and lastname
            let alert = UIAlertController(title: "Email address should not be empty", message: nil, preferredStyle: .alert)
            alert.view.tintColor = UIColor.GREEN_PRIMARY
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        
        if let window = UIApplication.shared.keyWindow{
            
            
            var int = ""
            var rls = ""
            
            if !selectedCommodity.isEmpty {
                int = (selectedCommodity.map{String($0)}).joined(separator: ",")
            }
            if !selectedRoles.isEmpty {
                rls = (selectedRoles.map{String($0)}).joined(separator: ",")
            }
            
            if hereTo.selectedSegmentIndex == 0 {
                //BUY
                userHereTo = "0"
            } else {
                //SELL
                userHereTo = "1"
            }
            
            if phone.length < 7 {
             
                phoneTextField.showErrorWithText(errorText: "Invalid number")
            } else if let offPhone = subPhoneTextField.text, offPhone.length < 7 && offPhone.length >= 1 {
          
                subPhoneTextField.showErrorWithText(errorText: "Invalid number")
            }
            else {
                print("Company id :\(companyId)")
                if counCode == "+" {
                    counCode = ""
                } else if offCCode == "+" {
                    offCCode = ""
                }
                
                
               let mofileEditing = UserDefaults.standard.value(forKey: "MobileEdited" + AuthService.instance.userId) as? String 

                
                if phoneTextField.text != self.profileItemEdit?.phoneNumber && mofileEditing != "1" {
                         
                    
         
                    
                   paramterString = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&dob=&city=\(cityTextField.text ?? "".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!)&website=\(websiteTextField.text ?? "".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!)&userLocation=\(countryTextField.text ?? "".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!)&designation=\(positionTextField.text ?? "")&email=\(email)&gender=&lastName=\(lnm.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!)&firstName=\(fnm.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!)&phoneNo=\(phone)&code=\(counCode ?? "")&officePhoneCode=\(offCCode ?? "")&userHereFor=\("\(userHereTo)".addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlPathAllowed)!)&cardFront=\(businessCardFront)&cardBack=\(businessCardBack)&cardShow=\(cardShow)&phoneShow=\(showPhone.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!)&officePhoneNumber=\(subPhoneTextField.text ?? "")&userInterest=\(int)&userRoles=\(rls)&company=\(companyTextField.text ?? "")&companyId=\(companyId)&userBio=\(bioTextView.text ?? "")"
                    
                    self.getCodeonMobileNumber(code: counCode, phoneNumberOnly: phoneTextField.text!)
                    
                   
                }
                else
                {
                    
                    let overlay = UIView(frame: CGRect(x: window.frame.origin.x, y: window.frame.origin.y, width: window.frame.width, height: window.frame.height))
                    overlay.alpha = 0.5
                    overlay.backgroundColor = UIColor.black
                    window.addSubview(overlay)
                    
                    let av = UIActivityIndicatorView(style: .whiteLarge)
                    av.center = overlay.center
                    av.startAnimating()
                    overlay.addSubview(av)
                    
                    
                    EditProfileItem.updateProfile(email: email, website: websiteTextField.text ?? "", country: countryTextField.text ?? "", city: cityTextField.text ?? "", position: positionTextField.text ?? "", lastName: lnm, firstName: fnm, phone: phoneTextField.text ?? "", code: counCode ?? "", officeCode: offCCode ?? "", officePhoneNo: subPhoneTextField.text ?? "", userInterest: int, userRoles: rls, company: companyTextField.text ?? "", companyId: companyId, bio: bioTextView.text ?? "",showPhone: showPhone,cardShow: cardShow,cardFront: businessCardFront,cardBack: businessCardBack,userHereFor: "\(userHereTo)", completion: {[weak self] (success, message) in
                        if success {
                            if let loggedinEmail = UserDefaults.standard.object(forKey: "storedEmail") as? String {
                                if loggedinEmail != email {
                                    UserDefaults.standard.set(email, forKey: "storedEmail")
                                }
                            }
                            
                            av.stopAnimating()
                            overlay.removeFromSuperview()
                            self?.delegate?.didUpdateProfile()
                            //self?.navigationController?.popViewController(animated: true)
                            if self!.isNeedToDismiss
                            {
                                self?.navigationController?.popViewController(animated: true)
                            }
                            else
                            {
                                self?.pushViewController(storyBoard: StoryBoard.PROFILE, Identifier: ProfileVC.id)

                            }
                        } else {
                            av.stopAnimating()
                            overlay.removeFromSuperview()
                            let alert = UIAlertController(title: "OOPS", message: message, preferredStyle: .alert)
                            alert.view.tintColor = UIColor.GREEN_PRIMARY
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self?.present(alert, animated: true, completion: nil)
                        }
                        
                        
                        /*let alert = UIAlertController(title: "Congratulations! Your profile is updated", message: nil, preferredStyle: .alert)
                         alert.view.tintColor = UIColor.GREEN_PRIMARY
                         alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                         self?.present(alert, animated: true, completion: nil)
                         self?.present(alert, animated: true, completion: {
                         })*/
                    })
                }
                
                

            }
        }
    }
    
    fileprivate func pushViewController(storyBoard: String,  Identifier: String,checkisGuest: Bool = false){
        guard !checkisGuest else {
            self.showGuestAlert(); return
        }
        let vc = UIStoryboard(name: storyBoard , bundle: nil).instantiateViewController(withIdentifier: Identifier)
        let nav = UINavigationController(rootViewController: vc)
        revealViewController().pushFrontViewController(nav, animated: true)
    }
}
extension EditProfileController: FPNTextFieldDelegate{
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        print(isValid)
    }
    func fpnDidSelectCountry(name: String, dialCode: String, code: String, textField: UITextField) {
        //self.countryCodeTF.text = dialCode
        if textField == codeTextField {
            self.counCode = dialCode
        }
        if textField == subCodeTextField {
            self.offCCode = dialCode
        }
        
        print("This is from Edit profile", name, dialCode, code)
    }
}
extension EditProfileController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameTextField{
            lastNameTextField.becomeFirstResponder()
        } else if textField == lastNameTextField{
            positionTextField.becomeFirstResponder()
        } /*else if textField == codeTextField {
            return false
        } */else if textField == phoneTextField{
            return false
        }
        else {
            let nextTage=textField.tag+1;
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
    
   /* func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField == companyTextField {
            tableView.isHidden = true
        }
    }*/
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        /*if textField == companyTextField {
            _ = companyTextField.resignFirstResponder()
            tableView.isHidden = false
            return true
        }
        return true*/
        if textField == companyTextField{
            let vc = AddCompanyListVC()
            vc.selection = { [weak self] (item, vc) in
                vc.searchController.isActive = false
                vc.dismiss(animated: true, completion: {
                    //self?.origin = item
                    self?.selectedCompany = item
                    self?.companyId = item.id
                })
            }
            let nav = UINavigationController(rootViewController: vc)
            self.present(nav, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == positionTextField{
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 20 // Bool
        }
        if textField == phoneTextField{
            let maxLength = 10
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        if textField == subPhoneTextField{
            let maxLength = 10
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
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


extension EditProfileController{
    static func storyBoardInstance() -> EditProfileController?{
        return UIStoryboard.profile.instantiateViewController(withIdentifier: self.id) as? EditProfileController
    }
}

extension EditProfileController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredDataSource.count != 0 {
            return filteredDataSource.count
        } else {
            return companyDataSource.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if filteredDataSource.count != 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: CompaniesCell.identifier, for: indexPath) as! CompaniesCell
            cell.configCell(company: filteredDataSource[indexPath.row])
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CompaniesCell.identifier, for: indexPath) as! CompaniesCell
            cell.configCell(company: companyDataSource[indexPath.row])
            return cell
        }
        
    }
    /*
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if filteredDataSource.count != 0 {
            let company = filteredDataSource[indexPath.row]
            companyTextField.text = company.name
            companyId = company.id
            
            let country = company.country
            if let i = CountryCode.countryNameArray.index(of: country){
                //Skip crash
                //setCountryText(i)
            }
            tableView.isHidden = true
        } else {
            let company = companyDataSource[indexPath.row]
            companyTextField.text = company.name
            companyId = company.id
            
            let country = company.country
            if let i = CountryCode.countryNameArray.index(of: country){
                //skip crash
                //setCountryText(i)
            }
            tableView.isHidden = true
        }
        
        
    }*/
    
}

class TriangleView : UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.beginPath()
        context.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        context.addLine(to: CGPoint(x: (rect.maxX / 2.0), y: rect.minY))
        context.closePath()
        
        context.setFillColor(red: 1.0, green: 0.5, blue: 0.0, alpha: 0.60)
        context.fillPath()
    }
}
extension EditProfileController : UITextViewDelegate
{
    func textViewDidBeginEditing(_ textView: UITextView) {
           print("exampleTextView: BEGIN EDIT")
        self.biodataSeperator.backgroundColor = UIColor.MyScrapGreen
       }

       func textViewDidEndEditing(_ textView: UITextView) {
           print("exampleTextView: END EDIT")
        self.biodataSeperator.backgroundColor = .black
       }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if self.maxCharacters - self.bioTextView.text.count == 0 {
            
            if range.length != 1 {
                self.showAlert(message: "You have exceeded the maximum character limit")
                return false
            }
        }
        return true
    }

}
extension EditProfileController
{
  

    @IBAction func getCodeonMobileNumber(code: String , phoneNumberOnly : String) {
          countrycode = code
          showActivityIndicator(with: "Sending...")
          if countrycode == "" {
              countrycode = "+971"
          }
          checkPhoneExists { (exists) in
              if !exists {
                  DispatchQueue.main.async {
                      let phoneNumber = self.countrycode + phoneNumberOnly
                      let appDelegate = UIApplication.shared.delegate as! AppDelegate
                      if !appDelegate.fireBaseConfig {
                          
                          if FirebaseApp.app() == nil {
                              FirebaseApp.configure()
                          }
                      }
                      //        self.hideActivityIndicator()
                      //        self.performSegue(withIdentifier: "verifySmsOTP", sender: self)
                      PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
                          if let error = error {
                               self.hideActivityIndicator()
                              
                              print("My phone : \(phoneNumber)")
                              print("error from Firebase: \(error.localizedDescription)")
                              let alertVC = UIAlertController(title: "OOPS",message: "Not a valid phone number", preferredStyle: .alert)
                              let okAction = UIAlertAction(title: "OK",style:.cancel, handler: nil)
                              alertVC.addAction(okAction)
                              self.present(alertVC,animated: true,completion: nil)
                              return
                          } else {
                            self.hideActivityIndicator()

                              self.phone = phoneNumber
                             let vc = UIStoryboard(name: StoryBoard.PROFILE , bundle: nil).instantiateViewController(withIdentifier: EditProfileCodeVerifyVC.id) as! EditProfileCodeVerifyVC
                            vc.countrycode = self.countrycode
                            vc.sep_phone = phoneNumber
                           // vc.email = self.profileItemEdit.e
                             vc.email = self.emailTextField.text!
                            vc.editDataString = self.paramterString
                            vc.comb_phone = self.countrycode + "-" + phoneNumberOnly
                                  self.navigationController?.pushViewController(vc, animated:true)
                           //   self.performSegue(withIdentifier: "verifySmsOTP", sender: self)
                              UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                              
                          }
                          // Sign in using the verificationID and the code sent to the user
                          // ...
                      }
                  }
                  
              } else {
                  print("This will not be triggered")
              }
          }
      }
      typealias completionHandler = (_ exist: Bool) -> ()
      func checkPhoneExists(completion: @escaping completionHandler){
          //This function is to check the email already used in MyScrap. It will works vice versa manner
          
          let service = APIService()
          service.endPoint = Endpoints.VERIFY_EMAIL_OR_PHONE
          
          service.params = "reg_email=&reg_mobile=\(phoneTextField.text!)&countryCode=\(countrycode)"
          service.getDataWith { [weak self] (result) in
              switch result{
              case .Success(let dict):
                  if let error = dict["error"] as? Bool {
                      if !error {
                          DispatchQueue.main.async {
                              self?.hideActivityIndicator()
                              self?.showToast(message: "Already Phone number registered")
                           //   self?.phoneNoTF.showErrorWithText(errorText: "Already Phone number registered")
                          }
                          //return true
                          completion(true)
                          self?.phoneExist = true
                      } else {
                          //return false
                          completion(false)
                          self?.phoneExist = false
                      }
                  }
              case .Error(let error):
                  //self?.emailTF.showErrorWithText(errorText: "Already Email registered")
                  completion(false)
                  self?.phoneExist = false
              }
          }
      }
      
}

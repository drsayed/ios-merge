//
//  AddListingVC.swift
//  Market
//
//  Created by MyScrap on 7/14/18.
//  Copyright © 2018 mybucket. All rights reserved.
//

import UIKit
import Gallery
import IQKeyboardManagerSwift
import DLRadioButton
import FlagPhoneNumber


class AddListingVC: UIViewController{
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segment: UISegmentedControl!
//    @IBOutlet weak var anonymSegment: UISegmentedControl!
    
    @IBOutlet weak var commodityTextField: MyScrapTextfield!            //
    @IBOutlet weak var paymentTextField: MyScrapTextfield!              //Payment Mode picker
    @IBOutlet weak var pricingTextField: MyScrapTextfield!              //Pricing set picker
    @IBOutlet weak var rateTextField: MyScrapTextfield!
    @IBOutlet weak var quantityTextField: MyScrapTextfield!             //Quantity textfield
    @IBOutlet weak var packingTextField: MyScrapTextfield!              //Packing type (bag) text field
    @IBOutlet weak var originTextField: MyScrapTextfield!               //Item origin text field
    @IBOutlet weak var portTextField: MyScrapTextfield!                 //Port text field
    @IBOutlet weak var expiryTextField: MyScrapTextfield!               //Expiry date which is not editable once setted picker
    @IBOutlet weak var textView: MyScrapTextView!                       //Description text view
    @IBOutlet weak var anonymousRB: DLRadioButton!
    @IBOutlet weak var nonAnonymRB: DLRadioButton!
    @IBOutlet weak var postList: UIButton!
    @IBOutlet weak var chatCheckBox: UIButton!
    @IBOutlet weak var callCheckBox: UIButton!
    @IBOutlet weak var emailCheckBox: UIButton!
    @IBOutlet weak var cCodeTF: FPNTextField!
    @IBOutlet weak var phoneTF: MyScrapTextfield!
    @IBOutlet weak var emailTF: MyScrapTextfield!
    
    
    private var pickerViewModel: AddListingPickerViewModel?
    
    private lazy var gallery: GalleryController = {
        let gry = GalleryController()
        gry.delegate = self
        return gry
    }()
    
    var dataSource = [UIImage?](repeating: nil, count: 10)
    var imageDataSource : [Image] = []
    
    var listing_id : String?
    var user_id : String?
    var anonym : Int!
    let tfRightview = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: 10))
    let tfRightLabel = UILabel(frame: CGRect(x: 0, y: 4, width: 70, height: 10))
    var chatSelected = ""
    var codeSelected = ""
    var phoneSelected = ""
    var emailSelected = ""
    
    
    var shipment: AddListingShipment? {
        didSet{
            paymentTextField.text = shipment!.description
        }
    }
    
    var pricing: AddListingPriceTerms?{
        didSet{
            pricingTextField.text = pricing!.description
        }
    }
    
    var rate: String? {
        didSet{
//            if pricingTextField.text == "Fixed" {
//                rateTextField.placeholder = "Rate - USD"
//            }
//            if pricingTextField.text == "Other" || pricingTextField.text == "Unknown" {
//                rateTextField.placeholder = "Rate - MT"
//            }
//            if pricingTextField.text == "Spot" {
//                rateTextField.placeholder = "Rate - USD/MT"
//            }
            rateTextField.placeholder = "Rate - USD/MT"
        }
    }
    
    var packing: AddListingPacking?{
        didSet{
            packingTextField.text = packing!.description
        }
    }
    
    var expiry: AddListingExpiry?{
        didSet{
            expiryTextField.text = expiry!.description
        }
    }
    
    var commodity: ISRI? {
        didSet{
            commodityTextField.text = commodity!.name
        }
    }
    var origin: PortList?{
        didSet{
            if let item = origin {
                originTextField.text = item.country
                port = nil
                if item.country == "Uae" {
                    pushtoPort(with: item.port_list, vcTitle: item.country.uppercased())
                } else {
                    pushtoPort(with: item.port_list, vcTitle: item.country)
                }
            }
        }
    }
    
    var port: MSPortList?{
        didSet{
            if let item = port{
                portTextField.text = item.port_name
            } else {
                portTextField.text = ""
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        setupCollectionView()
        setupPickerViewModel()
        setupTextField()
        setupTextView()
        segmentChanged(segment)
        //nonAnonymRB.isSelected = true
        anonym = 0
        postList.layer.cornerRadius = 5
        postList.clipsToBounds = true
        hideKeyboardWhenTappedAround()
     //   NotificationCenter.default.addObserver(self, selector: #selector(self.OpenEditProfileView(notification:)), name: Notification.Name("editButtonPressed"), object: nil)

        chatCheckBox.setImage(UIImage(named:"chekbox_uncheck"), for: .normal)
        callCheckBox.setImage(UIImage(named:"chekbox_uncheck"), for: .normal)
        emailCheckBox.setImage(UIImage(named:"chekbox_uncheck"), for: .normal)
    }

    private func setupCollectionView(){
        collectionView.register(AddListingImageCollectionCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            layout.minimumInteritemSpacing = (collectionView.frame.width - 250) / 4
            layout.minimumLineSpacing = 5
        }
    }
    
    private func setupPickerViewModel(){
        pickerViewModel = AddListingPickerViewModel(paymentTextField: paymentTextField, packingTextField: packingTextField, priceTextField: pricingTextField, expiryTextField: expiryTextField)
        
        pickerViewModel?.shipment = { item in
            self.shipment = item
        }
        
        pickerViewModel?.pricing = { item in
            self.pricing = item
//            if self.pricingTextField.text == "Fixed" {
//                self.rateTextField.placeholder = "Rate - USD"
//                self.tfRightLabel.text = "/USD"
//            }
//            else if self.pricingTextField.text == "Unknown" {
//                self.rateTextField.placeholder = "Rate - MT"
//                self.tfRightLabel.text = "/MT"
//            }
//            else if self.pricingTextField.text == "Other" {
//                self.rateTextField.placeholder = "Rate - MT"
//                self.tfRightLabel.text = "/MT"
//            }
//            else {
//                self.rateTextField.placeholder = "Rate - USD/MT"
//                self.tfRightLabel.text = "USD/MT"
//            }
            self.rateTextField.placeholder = "Rate - USD/MT"
            //self.tfRightLabel.text = "USD/MT"

        }
        
        pickerViewModel?.packing = { item in
            self.packing = item
        }
        
        pickerViewModel?.expiry = { item in
            self.expiry = item
        }
    }
    
    private func setupTextField(){
        commodityTextField.delegate = self
        originTextField.delegate = self
        portTextField.delegate = self
        rateTextField.delegate = self
        
        
        //tfRightLabel.text = "USD/MT"
        tfRightLabel.textColor = .black
        tfRightLabel.textAlignment = .right
        tfRightLabel.font = UIFont.systemFont(ofSize: 14)
        tfRightview.addSubview(tfRightLabel)
        tfRightview.backgroundColor = .white
        rateTextField.rightView = tfRightview
        rateTextField.rightViewMode = .always
        phoneTF.delegate = self
        cCodeTF.delegate = self
        cCodeTF.setBottomBorder()
    }
    
    private func setupTextView(){
        textView.delegate = self
    }
    
    static func controllerInstance(with id: String?,with1 user_id: String?) -> AddListingVC{
        let vc = AddListingVC()
        if let id = id{
            vc.listing_id = id
            //vc.title = "Listing ID \(id)"
            vc.user_id = user_id
        }
        return vc
    }
    
    /*@IBAction func rateLengthUpdate(_ sender: Any) {
      
        let maxLength = 10
        let currentString: NSString = rateTextField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
        
    }*/
    
    private func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    @IBAction func editButtonPressed(_ sender: UIButton) {
        Config.tabsToShow = [.imageTab]
        Config.Camera.imageLimit = 5
        Config.Grid.FrameView.borderColor = UIColor.MyScrapGreen
        present(gallery, animated: true, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender: UIButton){
        
        if AuthStatus.instance.isLoggedIn{
  
        //do the error handling things
            var phone = phoneTF.text
            var email = emailTF.text
            rate = rateTextField.text
            
            if commodity == nil { commodityTextField.showError() }
            if origin == nil { originTextField.showError() }
            if port == nil { portTextField.showError() }
            if packing == nil { packingTextField.showError() }
            if pricing == nil { pricingTextField.showError() }
            if shipment == nil { paymentTextField.showError() }
            if expiry == nil { expiryTextField.showError() }
            if rate == nil { rateTextField.showError() }
            if quantityTextField.text == nil || quantityTextField.text == "" {
                quantityTextField.showError()
            }
            if self.emailCheckBox.isSelected {
                if email == nil || email == "" {
                    emailTF.showErrorWithText(errorText: "Enter a Valid Email Address")
                }
            }
            if self.callCheckBox.isSelected == true {
                if phone == nil || phone == "" { phoneTF.showErrorWithText(errorText: "Enter Phone number")}
            }
            
            
            if textView.text == nil || textView.text.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
                let alert = UIAlertController(title: nil, message: "Please fill Description", preferredStyle: .alert)
                alert.view.tintColor = UIColor.GREEN_PRIMARY
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
            if chatCheckBox.isSelected == true {
                chatSelected = "1"
            } else {
                chatSelected = "0"
            }
            
            if emailCheckBox.isSelected == true {
                emailSelected = emailTF.text!
                print("email : \(emailTF.text!)")
            }
            
            var pricingNewValue = ""
            var expiryRaw = ""
            
            if let isri = commodity,
                let prt = port,
                let desc = textView.text, desc.trimmingCharacters(in: .whitespacesAndNewlines) != "",
                let package = packing,
                let price = pricing,
                let ship = shipment,
                let quantity = quantityTextField.text , quantity != "",
                
                //!imageDataSource.isEmpty
                let dura = expiry {
                    self.view.endEditing(true)
                print("Quantity in Add list \(quantity), rate is \(rate!), dura selected : \(dura.rawValue)")
                if dura.rawValue == 2 {
                    expiryRaw = "4"     //manually considered as 90
                } else if dura.rawValue == 3 {
                    expiryRaw = "5"
                } else {
                    expiryRaw = "1"
                }
                if imageDataSource.isEmpty || imageDataSource.count < 3{
                    let Alert = UIAlertController(title: "Alert!! User have to post at least three images", message: nil, preferredStyle: .actionSheet)
                    let name = UIAlertAction(title: "Ok", style: .default)
                    Alert.addAction(name)
                    Alert.view.tintColor = UIColor.GREEN_PRIMARY
                    self.present(Alert, animated: true, completion: nil)
                } else {
                    Image.resolve(images: imageDataSource) { imgArray in
                        var media: [Media] = []
                        for imag in imgArray{
                            if let img = imag{
                                media.append(Media(withImage: img, forKey: "uploadfile[]")!)
                            }
                        }
                        if self.chatCheckBox.isSelected == false && self.emailCheckBox.isSelected == false && self.callCheckBox.isSelected == false {
                            let alert = UIAlertController(title: nil, message: "Choose at least one option to contact!!", preferredStyle: .alert)
                            alert.view.tintColor = UIColor.GREEN_PRIMARY
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        } else if self.emailCheckBox.isSelected == true {
                            //Email Checkbox
                            if !self.isValidEmail(testStr: self.emailTF.text!){
                                self.emailTF.showErrorWithText(errorText: "Enter a Valid Email Address")
                            }else {
                                
                                if price.description == "Spot" {
                                    pricingNewValue = "3"
                                } else if price.description == "Message to quote" {
                                    pricingNewValue = "4"
                                } else if price.description == "Highest bid" {
                                    pricingNewValue = "5"
                                } else if price.description == "Other" {
                                    pricingNewValue = "2"
                                } else if price.description == "Unknown" {
                                    pricingNewValue = "1"
                                } else {
                                    pricingNewValue = "0"
                                }
                                self.post(portId:prt.port_id, isri: isri.id, descriptn: desc,quantity: quantity, duration: expiryRaw, pack: "\(package.rawValue)", price: pricingNewValue, ratePrice: self.rate!,  shipment: "\(ship.description)",chat: self.chatSelected, code: self.codeSelected, phone: self.phoneSelected, email: self.emailSelected, media: media)
                            }
                        } else if self.callCheckBox.isSelected == true {
                            //Phone Checkbox
                            if self.codeSelected == "" || self.phoneTF.text == "" {
                                let alert = UIAlertController(title: nil, message: "Contact through Call is selected!! Please fill the Phone number/select Country Code", preferredStyle: .alert)
                                alert.view.tintColor = UIColor.GREEN_PRIMARY
                                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            } else {
                                //codeSelected = cCodeTF.text!
                                self.phoneSelected = self.phoneTF.text!
                                print("Country Code :" , self.codeSelected , self.phoneTF.text!)
                                
                                if price.description == "Spot" {
                                    pricingNewValue = "3"
                                } else if price.description == "Message to quote" {
                                    pricingNewValue = "4"
                                } else if price.description == "Highest bid" {
                                    pricingNewValue = "5"
                                } else if price.description == "Other" {
                                    pricingNewValue = "2"
                                } else if price.description == "Unknown" {
                                    pricingNewValue = "1"
                                } else {
                                    pricingNewValue = "0"
                                }
                                self.post(portId:prt.port_id, isri: isri.id, descriptn: desc,quantity: quantity, duration: expiryRaw, pack: "\(package.rawValue)", price: pricingNewValue, ratePrice: self.rate!, shipment: "\(ship.description)",chat: self.chatSelected, code: self.codeSelected, phone: self.phoneSelected, email: self.emailSelected, media: media)
                            }
                            
                        }
                        else {
                            //Chat Checkbox
                            if price.description == "Spot" {
                                pricingNewValue = "3"
                            } else if price.description == "Message to quote" {
                                pricingNewValue = "4"
                            } else if price.description == "Highest bid" {
                                pricingNewValue = "5"
                            } else if price.description == "Other" {
                                pricingNewValue = "2"
                            } else if price.description == "Unknown" {
                                pricingNewValue = "1"
                            } else {
                                pricingNewValue = "0"
                            }
                            self.post(portId:prt.port_id, isri: isri.id, descriptn: desc,quantity: quantity, duration: expiryRaw, pack: "\(package.rawValue)", price: pricingNewValue, ratePrice: self.rate!, shipment: "\(ship.description)",chat: self.chatSelected, code: self.codeSelected, phone: self.phoneSelected, email: self.emailSelected, media: media)
                        }
                    }
                }
                
            } else {
                print("please fill the details")
            }
            
        }
        else {
            showGuestAlert()
        }
    }
    
       // func postMarket(port: String, isri: String, description: String, quantity: String, duration: String,type: Int,packing: String, pricing:String,payment: String,  media: [Media]? , completion: @escaping (Bool) -> ()){
    
    private func post(portId: String, isri: String, descriptn: String, quantity: String, duration: String, pack: String, price: String, ratePrice: String, shipment: String, chat: String, code: String, phone: String, email: String, media: [Media]?){
        if let window = UIApplication.shared.keyWindow {
            let overlay = UIView(frame: CGRect(x: window.frame.origin.x, y: window.frame.origin.y, width: window.frame.width, height: window.frame.height))
            overlay.alpha = 0.5
            overlay.backgroundColor = UIColor.black
            window.addSubview(overlay)
            let av = UIActivityIndicatorView(style: .whiteLarge)
            av.center = overlay.center
            av.startAnimating()
            overlay.addSubview(av)
            self.view.endEditing(true)
            
            let service = MarketService()
            service.postMarket(port: portId, isri: isri, description: descriptn, quantity: quantity, duration: duration, type: self.segment.selectedSegmentIndex, packing: pack, pricing: price, rate: ratePrice, shipment: shipment,anonym: anonym,chat: chat, code: code, phone: phone, email: email, media: media) { (_) in
                print("completed")
                av.stopAnimating()
                overlay.removeFromSuperview()
                self.navigationController?.popViewController(animated: true)
                
            }
        }
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl){
        if sender.selectedSegmentIndex == 0 {
            originTextField.placeholder = "Origin"
        } else {
            originTextField.placeholder = "Destination"
        }
    }
    
    @IBAction func anonymSegmChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            print("Anonymous")
        } else {
            print("Not Anonymous")
        }
        
    }
    @IBAction func notAnonymousRB(_ sender: DLRadioButton) {
        anonym = 0      //profile is visible
    }
    @IBAction func anonymousRB(_ sender: DLRadioButton) {
        anonym = 1      //hide user profile
    }
    @IBAction func chatCheckBoxTapped(_ sender: UIButton) {
        if sender.tag == 0 {
            chatCheckBox.setImage(UIImage(named:"chekbox_check"), for: .normal)
            sender.tag = 1
            chatCheckBox.isSelected = true
        } else {
            chatCheckBox.setImage(UIImage(named:"chekbox_uncheck"), for: .normal)
            sender.tag = 0
            chatCheckBox.isSelected = false
        }
    }
    @IBAction func callCheckBoxTapped(_ sender: UIButton) {
        if sender.tag == 0 {
            callCheckBox.setImage(UIImage(named:"chekbox_check"), for: .normal)
            sender.tag = 1
            callCheckBox.isSelected = true
        } else {
            callCheckBox.setImage(UIImage(named:"chekbox_uncheck"), for: .normal)
            sender.tag = 0
            callCheckBox.isSelected = false
        }
        
    }
    
    @IBAction func emailCheckBoxTapped(_ sender: UIButton) {
        if sender.tag == 0 {
            emailCheckBox.setImage(UIImage(named:"chekbox_check"), for: .normal)
            sender.tag = 1
            emailCheckBox.isSelected = true
        } else {
            emailCheckBox.setImage(UIImage(named:"chekbox_uncheck"), for: .normal)
            sender.tag = 0
            emailCheckBox.isSelected = false
        }
        
    }
    static func storyBoardInstance() -> AddListingVC?{
        let st = UIStoryboard.Market
        return st.instantiateViewController(withIdentifier: AddListingVC.id) as? AddListingVC
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.sharedManager().enable = true
        
    }
}

extension AddListingVC: GalleryControllerDelegate{
    func DidLimitExceeded(_ controller: UIViewController) {
        let alert = UIAlertController(title: "limit Exceeded", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        controller.present(alert, animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        self.imageDataSource = images
        self.collectionView.reloadData()
        controller.dismiss(animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Image]) {
        
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        gallery.cart.reload(imageDataSource)
        controller.dismiss(animated: true, completion: nil)
    }
    
    func pushtoPort(with dataSource: [MSPortList], vcTitle: String){
        
        let vc = PortListController(dataSource: dataSource, title: vcTitle) { (port) in
            self.port = port
        }
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
}

extension AddListingVC: UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == commodityTextField{
            let vc = ISRISearchController()
            vc.selection = { item in
                self.commodity = item
            }
            let nav = UINavigationController(rootViewController: vc)
            self.present(nav, animated: true, completion: nil)
            return false
        }
        if textField == originTextField{
            let vc = AddListOriginListController()
            vc.selection = { [weak self] (item, vc) in
                vc.searchController.isActive = false
                vc.dismiss(animated: true, completion: {
                    self?.origin = item
                })
            }
            let nav = UINavigationController(rootViewController: vc)
            self.present(nav, animated: true, completion: nil)
            return false
        }
        if textField == portTextField{
            if let origin = origin{
                if origin.country == "Uae" {
                    pushtoPort(with: origin.port_list, vcTitle: origin.country.uppercased())
                } else {
                    pushtoPort(with: origin.port_list, vcTitle: origin.country)
                }
                
            } else {
                print("please select Origin")
            }
            return false
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == rateTextField{
            let maxLength = 10
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        if textField == phoneTF {
            let maxLength = 10
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        return true
    }
}
extension AddListingVC: UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in : currentText) else { return false }
        let changedText = currentText.replacingCharacters(in: stringRange, with: text).components(separatedBy: .whitespacesAndNewlines)
        let filterWords = changedText.filter { (word) -> Bool in
            word != ""
        }
        return filterWords.count <= 100
    }
}


extension AddListingVC: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let Alert = UIAlertController(title: "Choose an option", message: nil, preferredStyle: .actionSheet)
        let name = UIAlertAction(title: "Camera", style: .default) { [unowned self] (action) in
            Config.tabsToShow  = [.cameraTab]
            Config.Camera.imageLimit = 10
            self.present(self.gallery, animated: true, completion: nil)
        }
        let country = UIAlertAction(title: "Gallery", style: .default) { [unowned self] (action) in
            Config.tabsToShow  = [.imageTab]
            Config.Camera.imageLimit = 10
            self.present(self.gallery, animated: true, completion: nil)
                
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        Alert.addAction(name)
        Alert.addAction(country)
        Alert.addAction(cancel)
        Alert.view.tintColor = UIColor.GREEN_PRIMARY
        self.present(Alert, animated: true, completion: nil)
        
        
    }
}

extension AddListingVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: AddListingImageCollectionCell = collectionView.dequeReusableCell(forIndexPath: indexPath)
        
        if imageDataSource.count - 1 >= indexPath.item{
            cell.image = imageDataSource[indexPath.item]
        } else {
            cell.image = nil
        }
        
        return cell
    }
}

extension AddListingVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
}
extension AddListingVC: FPNTextFieldDelegate {
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        print(isValid)
    }
    
    func fpnDidSelectCountry(name: String, dialCode: String, code: String,textField: UITextField) {
        self.codeSelected = dialCode
        //self.cCodeTF.text = self.codeSelected
        print("Country Name" ,name, "Dial_ code", dialCode,"Flag_code", code)
    }
}
extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor(hexString: "#D3D3D3").cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    func editProfileSetBottomBorderDisabled() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        //self.layer.shadowColor = UIColor(hexString: "#000000").cgColor
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    func editCompanySetBottomBorderEnabled() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        //self.layer.shadowColor = UIColor(hexString: "#000000").cgColor
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
    func editProfileSetBottomBorderEnabled() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor(hexString: "#000000").cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}




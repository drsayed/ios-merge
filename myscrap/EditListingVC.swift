//
//  EditListingVC.swift
//  myscrap
//
//  Created by MyScrap on 11/10/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit
import Gallery
import SDWebImage
import DLRadioButton
import IQKeyboardManagerSwift
import FlagPhoneNumber

class EditListingVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    @IBOutlet weak var commodityTextField: MyScrapTextfield!
    @IBOutlet weak var paymentTextField: MyScrapTextfield!
    @IBOutlet weak var pricingTextField: MyScrapTextfield!
    @IBOutlet weak var rateTextField: MyScrapTextfield!
    @IBOutlet weak var quantityTextField: MyScrapTextfield!
    @IBOutlet weak var packingTextField: MyScrapTextfield!
    @IBOutlet weak var originTextField: MyScrapTextfield!
    @IBOutlet weak var portTextField: MyScrapTextfield!
    @IBOutlet weak var expiryTextField: MyScrapTextfield!
    @IBOutlet weak var textView: MyScrapTextView!
    @IBOutlet weak var anonymousRB: DLRadioButton!
    @IBOutlet weak var nonAnonymRB: DLRadioButton!
    @IBOutlet weak var editList: UIButton!
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
    
    let service = MarketService()
    var dataSource = [UIImage?](repeating: nil, count: 10)
    var imageDataSource : [Image] = []
    var listing_id : String?
    var user_id : String?
    var listing_img : [String]?
    var imageArray : [UIImage] = []
    var count : Int = 0
    var anonym : Int!
    let tfRightview = UIView(frame: CGRect(x: 0, y: 0, width: 70, height: 10))
    let tfRightLabel = UILabel(frame: CGRect(x: 0, y: 4, width: 70, height: 10))
    
    var port_id = ""
    var port_name = ""
    var isriCodeId = ""
    var isriCodeName = ""
    var desc = ""
    var quantity = ""
    var dura = ""
    var timeDura = ""
    var pack = ""
    var price = ""
    var ship = ""
    //var listing_id = ""
    var chatSelected = ""
    var codeSelected = ""
    var phoneSelected = ""
    var emailSelected = ""
    var fetchedCount = 0
    
    //Delete image
    var deletedImg = ""
    var delImgArray = [String]()
    
    //Add image
    var combImage = [String]()
    var appdImg = [UIImage]()
    
    
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
//                rateTextField.placeholder = "Rate(USD)"
//                //rate = rateTextField.text
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
                pushtoPort(with: item.port_list, vcTitle: item.country)
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
    
    private var data: DetailListing?{
        didSet{
            if let _ = data{
                reloadCollectionViews()
            }
        }
    }
    
    let activityIndicator: UIActivityIndicatorView = {
        let av = UIActivityIndicatorView(style: .gray)
        av.hidesWhenStopped = true
        av.translatesAutoresizingMaskIntoConstraints = false
        return av
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        chatCheckBox.setImage(UIImage(named:"chekbox_uncheck"), for: .normal)
        callCheckBox.setImage(UIImage(named:"chekbox_uncheck"), for: .normal)
        emailCheckBox.setImage(UIImage(named:"chekbox_uncheck"), for: .normal)
        
        fetchListing()
        setupCollectionView()
        setupPickerViewModel()
        setupTextField()
        setupTextView()
        segmentChanged(segment)
        
        view.addSubview(activityIndicator)
        activityIndicator.setHorizontalCenter(to: view.centerXAnchor)
        activityIndicator.topAnchor.constraint(equalTo: view.safeTop, constant: 20).isActive = true
        activityIndicator.setSize(size: CGSize(width: 30, height: 30))
        
        activityIndicator.startAnimating()
        
        //nonAnonymRB.isSelected = true
        editList.layer.cornerRadius = 5
        editList.clipsToBounds = true
        hideKeyboardWhenTappedAround()
        
        
    }
    
    private func reloadCollectionViews(){
        if activityIndicator.isAnimating{
            activityIndicator.stopAnimating()
        }
        if refreshControl.isRefreshing{
            refreshControl.endRefreshing()
        }
        
        if let item = data , let user = item.user_data , let id = user.userId , id == AuthService.instance.userId{
            self.collectionView.reloadData()
        } else {
            //self.bottomView.isHidden = false
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            }) { (_) in
                self.collectionView.reloadData()
            }
        }
    }
    
    private lazy var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return rc
    }()
    
    @objc
    private func refresh(){
        if activityIndicator.isAnimating {
            activityIndicator.stopAnimating()
        }
    }
    
    private func setupCollectionView(){
        collectionView.register(EditListingImageCollectionCell.self)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout{
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
    func fetchListing(){
        if let listingId = listing_id {
            service.detailMarketLists(listingId: listingId)
            service.delegate = self
        }
    }
    private func configureTextFields(with listingItem: ViewListingItems){
        print("Commodity : \(listingItem.listingIsriCode), \nPayment : \(listingItem.paymentTerms), \nPricing : \(listingItem.priceTerms), \nQuantity : \(listingItem.quantity), \nPacking \(listingItem.packaging), \nOrigin : \(listingItem.countryName), \nPort : \(listingItem.portName), \nexpiry : \(listingItem.expiry), \nDescription : \(listingItem.description), \nDuration : \(listingItem.duration), \nPort_ID : \(listingItem.portID), \nISRI ID : \(listingItem.listingIsriCodeID)")
        
        
        port_id = listingItem.portID
        port_name = listingItem.portName
        isriCodeId = listingItem.listingIsriCodeID
        isriCodeName = listingItem.listingIsriCode
        desc = listingItem.description
        dura = listingItem.duration
        timeDura = listingItem.timeDuration
        pack = listingItem.packaging
        price = listingItem.priceTerms
        ship = listingItem.shipmentTerm
        //rate = listingItem.rate
        //listing_id = listingItem.listingId
        
        let userData = listingItem.user_data.last
        
        if userData?.contactMeChat == "1" {
            chatCheckBox.isSelected = true
            chatCheckBox.setImage(UIImage(named: "chekbox_check"), for: .normal)
            chatSelected = (userData?.contactMeChat)!
        }
        if userData?.contactMeEmail != "" {
            emailCheckBox.isSelected = true
            emailCheckBox.setImage(UIImage(named: "chekbox_check"), for: .normal)
            emailTF.text = userData?.contactMeEmail
            emailSelected = (userData?.contactMeEmail)!
        }
        if userData?.contactMePhoneNo != "" && userData?.contactMePhoneCode != "" {
            callCheckBox.isSelected = true
            callCheckBox.setImage(UIImage(named: "chekbox_check"), for: .normal)
            cCodeTF.parentViewController = self
            cCodeTF.phoneCodeTextField.text = (userData?.contactMePhoneCode)! + " ▼"
            cCodeTF.setFlag(for: FPNCountryCode(rawValue: (userData?.countryShortName)!)!)
            phoneTF.text = userData?.contactMePhoneNo
            codeSelected = (userData?.contactMePhoneCode)!
            phoneSelected = (userData?.contactMePhoneNo)!
        }
        
        
        self.commodityTextField.text = listingItem.listingIsriCode
        //Shipment Terms
        self.paymentTextField.text = listingItem.shipmentTerm
        
        //Pricing Terms
        if listingItem.priceTerms == "0" {
            self.pricingTextField.text = "Fixed"
        }
        else if listingItem.priceTerms == "1" {
            self.pricingTextField.text = "Unknown"
        } else if listingItem.priceTerms == "2" {
            self.pricingTextField.text = "Other"
        } else if listingItem.priceTerms == "3" {
            self.pricingTextField.text = "Spot"
        } else if listingItem.priceTerms == "4" {
            self.pricingTextField.text = "Message to quote"
        }
        else {
            self.pricingTextField.text = "Highest bid"
        }
        
        if listingItem.packaging == "0" {
            self.packingTextField.text = "Bags"
        }
        else if listingItem.packaging == "1" {
            self.packingTextField.text = "Bale"
        }
        else if listingItem.packaging == "2" {
            self.packingTextField.text = "Jumbo Bags"
        }
        else if listingItem.packaging == "3" {
            self.packingTextField.text = "Loose"
        }
        else if listingItem.packaging == "4" {
            self.packingTextField.text = "Pallets"
        } else {
            self.packingTextField.text = "Other"
        }
        
        //Segment
        if listingItem.listingType == "0" {
            segment.selectedSegmentIndex = 0            //Sell segment
        }
        else {
            segment.selectedSegmentIndex = 1            //Buy segment
        }
        
        if listingItem.anonymous == "0" {
            //Default value
            //nonAnonymRB.isSelected = true            //Not anonymous(show)
            anonym = 0
        }
        else {
            //anonymousRB.isSelected = true            //Anonymous(hidden)
            anonym = 1
        }
        
        self.rateTextField.text = listingItem.rate
        self.quantityTextField.text = listingItem.quantity
        self.originTextField.text = listingItem.countryName
        self.portTextField.text = listingItem.portName
        self.expiryTextField.text = listingItem.expiry
        self.textView.text = listingItem.description
        if listing_img != [""] {
            self.listing_img = listingItem.listingImg!
        }
        else {
            self.listing_img = [""]
        }
        
        collectionView.reloadData()
    }
    
    static func controllerInstance(with id: String?,with1 user_id: String?) -> EditListingVC{
        let vc = EditListingVC()
        if let id = id{
            vc.listing_id = id
            //vc.title = "Listing ID \(id)"
            vc.user_id = user_id
        }
        return vc
    }
    
    @IBAction func nonAnonymRB(_ sender: DLRadioButton) {
        anonym = 0
    }
    @IBAction func anonymousRB(_ sender: DLRadioButton) {
        anonym = 1
    }
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        if AuthStatus.instance.isLoggedIn{
            rate = rateTextField.text!
            //Pricing Terms
            if pricingTextField.text == "Fixed" {
                price = "0"
            }
            else if pricingTextField.text == "Unknown" {
                price = "1"
            } else if pricingTextField.text == "Other" {
                price = "2"
            }
            else if pricingTextField.text == "Spot"{
                price = "3"
            } else if pricingTextField.text == "Message to quote"{
                price = "4"
            } else {
                price = "5"
            }
            //Shipment Type
            ship = self.paymentTextField.text!
            
            if packingTextField.text == "Bags" {
                pack = "0"
            }
            else if packingTextField.text == "Bale" {
                pack = "1"
            }
            else if packingTextField.text == "Jumbo Bags" {
                pack = "2"
            }
            else if packingTextField.text == "Loose" {
                pack = "3"
            }
            else if packingTextField.text == "Pallets" {
                pack = "4"
            } else {
                pack = "5"
            }
            if port_name != portTextField.text {
                port_id = (port?.port_id)!
            }
            else {
                print("No changes required in port")
            }
            if isriCodeName != commodityTextField.text {
                isriCodeId = (commodity?.id)!
            }
            else {
                print("No changes required in ISRI")
            }
            if chatCheckBox.isSelected == true {
                chatSelected = "1"
            } else {
                chatSelected = "0"
            }
            if callCheckBox.isSelected == true {
                if codeSelected == "" || phoneTF.text == "" {
                    let alert = UIAlertController(title: nil, message: "Contact through Call is selected!! Please fill the Phone number/select Country Code", preferredStyle: .alert)
                    alert.view.tintColor = UIColor.GREEN_PRIMARY
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    //codeSelected = cCodeTF.text!
                    phoneSelected = phoneTF.text!
                }
                print("Country Code :" , cCodeTF.text! , phoneTF.text!)
            } else {
                phoneSelected = ""
            }
            if emailCheckBox.isSelected == true {
                emailSelected = emailTF.text!
                print("email : \(emailTF.text!)")
            } else {
                emailSelected = ""
            }
            if chatCheckBox.isSelected == false && emailCheckBox.isSelected == false && callCheckBox.isSelected == false {
                let alert = UIAlertController(title: nil, message: "Choose at least one option to contact!!", preferredStyle: .alert)
                alert.view.tintColor = UIColor.GREEN_PRIMARY
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                if imageDataSource.isEmpty{
                    if delImgArray.count > 1 {
                        deletedImg = delImgArray.joined(separator: "||")
                    } else if delImgArray.count == 1 {
                        deletedImg = delImgArray.last!
                    } else {
                        deletedImg = ""
                    }
                    self.post(portId: self.port_id, isri: self.isriCodeId, descriptn: self.textView.text, quantity: self.quantityTextField.text!, duration: self.timeDura, pack: self.pack, price: self.price, ratePrice: self.rate!, shipment: self.ship,chat: self.chatSelected, code: self.codeSelected, phone: self.phoneSelected, email: self.emailSelected, delImg: deletedImg, media: nil)
                } else {
                    print(" Image data source count: \(imageDataSource)")
                    Image.resolve(images: imageDataSource) { imgArray in
                        print("IMDS Count :\(self.imageDataSource.count)")
                        var media: [Media] = []
                        for imag in imgArray{
                            if let img = imag{
                                media.append(Media(withImage: img, forKey: "uploadfile[]")!)
                            }
                        }
                        if self.delImgArray.count > 1 {
                            self.deletedImg = self.delImgArray.joined(separator: "||")
                        } else if self.delImgArray.count == 1 {
                            self.deletedImg = self.delImgArray.last!
                        } else {
                            self.deletedImg = ""
                        }
                        dump(media)
                        print("Media image count :\(media)")
                        if self.chatCheckBox.isSelected == false && self.emailCheckBox.isSelected == false && self.callCheckBox.isSelected == false {
                            let alert = UIAlertController(title: nil, message: "Choose at least one option to contact!!", preferredStyle: .alert)
                            alert.view.tintColor = UIColor.GREEN_PRIMARY
                            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            /*if !self.isValidEmail(testStr: self.emailTF.text!){
                             self.emailTF.showErrorWithText(errorText: "Enter a Valid Email Address")
                             } else {
                             self.post(portId: self.port_id, isri: self.isriCodeId, descriptn: self.textView.text, quantity: self.quantityTextField.text!, duration: self.dura, pack: self.pack, price: self.price, ratePrice: self.rate!, shipment: self.ship,chat: self.chatSelected, code: self.codeSelected, phone: self.phoneSelected, email: self.emailSelected, media: media)
                             }*/
                            self.post(portId: self.port_id, isri: self.isriCodeId, descriptn: self.textView.text, quantity: self.quantityTextField.text!, duration: self.timeDura, pack: self.pack, price: self.price, ratePrice: self.rate!, shipment: self.ship,chat: self.chatSelected, code: self.codeSelected, phone: self.phoneSelected, email: self.emailSelected, delImg: self.deletedImg, media: media)
                        }
                    }
                }
            }
            
            //pack = packingTextField.text!
            //price = pricingTextField.text!
            //paymnt = paymentTextField.text!
            
            //do the error handling things
            
            
        } else {
            showGuestAlert()
        }
    }
    
    private func post(portId: String, isri: String, descriptn: String, quantity: String, duration: String, pack: String, price: String, ratePrice: String, shipment: String, chat: String, code: String, phone: String, email: String, delImg: String, media: [Media]?){
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
            print("EDIT LISTING ID ***** \(listing_id!)")
            
            let service = MarketService()
            service.editMarket(editId : listing_id!,port: portId, isri: isri, description: descriptn, quantity: quantity, duration: duration, type: self.segment.selectedSegmentIndex, packing: pack, pricing: price, rate: ratePrice, shipment: shipment,anonym: anonym, chat: chat, code: code, phone: phone, email: email, delImg: delImg, media: media) { (_) in
                print("completed")
                av.stopAnimating()
                overlay.removeFromSuperview()
                self.navigationController?.popViewController(animated: true)
                //self.pushViewController(storyBoard: StoryBoard.MARKET, Identifier: MarketVC.id)
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

    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            originTextField.placeholder = "Origin"
        } else {
            originTextField.placeholder = "Destination"
        }
    }
    private func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    static func storyBoardInstance() -> EditListingVC?{
        let st = UIStoryboard.Market
        return st.instantiateViewController(withIdentifier: EditListingVC.id) as? EditListingVC
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.sharedManager().enable = true
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}



extension EditListingVC: GalleryControllerDelegate {
    func DidLimitExceeded(_ controller: UIViewController) {
        let alert = UIAlertController(title: "limit Exceeded", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        controller.present(alert, animated: true, completion: nil)
    }
    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Image]) {
        self.combImage.removeAll()
        print("removed values :\(combImage)")
        for img in images {
            let imgString = "1.jpg"
            self.combImage.append(imgString)
        }
        
        self.imageDataSource = images
        print("combined img count :\(self.combImage)")
        for list in listing_img! {
            self.combImage.append(list)
        }
        
        //combImage = listing_img!
        print("IMDS Count :\(self.imageDataSource.count)")
        print("Image added array :\(self.combImage)")
        
        Config.tabsToShow  = [.imageTab]
        Config.Camera.imageLimit = 10 - self.combImage.count
        print("Image limit count : \(Config.Camera.imageLimit)")
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

extension EditListingVC: UITextFieldDelegate {
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
                pushtoPort(with: origin.port_list, vcTitle: origin.country)
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

extension EditListingVC: UITextViewDelegate {
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

extension EditListingVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //Replacing with old code
        if indexPath.item > 0 {
            print("Contains image, \(indexPath.count), \(indexPath.item)")
            present(gallery, animated: true, completion: nil)
        }
        else if indexPath.item == 0 {
            print("Existing image touched")
            Config.tabsToShow  = [.imageTab]
            Config.Camera.imageLimit = 10
            present(gallery, animated: true, completion: nil)
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: EditListingImageCollectionCell = collectionView.dequeReusableCell(forIndexPath: indexPath)
        cell.closeBtn.isHidden = true
        cell.closeBtnAction = {
            if !self.combImage.isEmpty {
                if self.imageDataSource.count - 1 >= indexPath.row {
                    cell.imageView.image = #imageLiteral(resourceName: "add-bg")
                    cell.closeBtn.isHidden = true
                    self.imageDataSource.remove(at: indexPath.row)
                    self.combImage.remove(at: indexPath.row)
                    self.collectionView.reloadData()
                } else {
                    cell.imageView.image = #imageLiteral(resourceName: "add-bg")
                    cell.closeBtn.isHidden = true
                    let splitString = self.combImage[indexPath.row].split(separator: "/")
                    print("Split string : \(splitString[5])/\(splitString[6])")
                    let afterSplit = String(splitString[5] + "/" + splitString[6])
                    self.delImgArray.append(afterSplit)
                    print("Deleted Image inside *** \(self.delImgArray.count), \(self.delImgArray)")
                    self.combImage.remove(at: indexPath.row)
                    self.collectionView.reloadData()
                }
            } else {
                cell.imageView.image = #imageLiteral(resourceName: "add-bg")
                cell.closeBtn.isHidden = true
                let splitString = self.listing_img![indexPath.row].split(separator: "/")
                print("Split string : \(splitString[5])/\(splitString[6])")
                let afterSplit = String(splitString[5] + "/" + splitString[6])
                self.delImgArray.append(afterSplit)
                print("Deleted Image inside *** \(self.delImgArray.count), \(self.delImgArray)")
                self.listing_img!.remove(at: indexPath.row)
                self.collectionView.reloadData()
            }
        }
        
        if !combImage.isEmpty && indexPath.row <= combImage.count - 1{
            print("count ### : \(combImage.count)")
            if let imgUrl = combImage[indexPath.item] as? String {
                if let url = URL(string: imgUrl) {
                    SDWebImageManager.shared().cachedImageExists(for: url) { (status) in
                        if status{
                            SDWebImageManager.shared().imageCache?.queryCacheOperation(forKey: url.absoluteString, done: { (image, data, type) in
                                print("Image DS 1: \(self.imageDataSource.count)")
                                if cell.image == nil {
                                    if self.imageDataSource.count - 1 >= indexPath.item{
                                        cell.image = self.imageDataSource[indexPath.item]
                                        print("May i know", self.imageDataSource[indexPath.item])
                                        print("Index path item :\(indexPath.item)")
                                        cell.closeBtn.isHidden = false
                                        
                                    } else {
                                        print("Cell has no Image is nil")
                                        cell.imageView.image = image
                                        cell.closeBtn.isHidden = false
                                    }
                                }
                                else {
                                    print("After appended count :one \(self.imageDataSource.count)")
                                }
                            })
                        } else {
                            SDWebImageManager.shared().imageDownloader?.downloadImage(with: url, options: SDWebImageDownloaderOptions.continueInBackground, progress: nil, completed: { (image, data, error, status) in
                                SDImageCache.shared().store(image, forKey: url.absoluteString)
                                if cell.image == nil {
                                    if self.imageDataSource.count - 1 >= indexPath.item{
                                        cell.image = self.imageDataSource[indexPath.item]
                                        print("May i know", self.imageDataSource[indexPath.item])
                                        print("Index path item :\(indexPath.item)")
                                        cell.closeBtn.isHidden = false
                                        
                                    } else {
                                        print("Cell has no Image is nil")
                                        cell.imageView.image = image
                                        cell.closeBtn.isHidden = false
                                    }
                                }
                                else {
                                    print("After appended count :one \(self.imageDataSource.count)")
                                }
                            })
                        }
                    }
                }
                else {
                    print("Here occurs")
                    cell.imageView.image = #imageLiteral(resourceName: "add-bg")
                }
            }
        } else if !combImage.isEmpty && indexPath.row > combImage.count - 1 {
            print("Nothing will happen")
            cell.imageView.image = #imageLiteral(resourceName: "add-bg")
        } else {
            print("came in")
            if let images = listing_img ,!images.isEmpty, images.count > indexPath.item{

                if let imgUrl = images[indexPath.item] as? String {
                    if let url = URL(string: imgUrl) {
                        SDWebImageManager.shared().cachedImageExists(for: url) { (status) in
                            if status{
                                SDWebImageManager.shared().imageCache?.queryCacheOperation(forKey: url.absoluteString, done: { (image, data, type) in
                                    self.appdImg.append(image!)
                                    print("Image added count #Cache :\(self.appdImg.count)")
                                    print("Image DS 2: \(self.imageDataSource.count)")
                                    if cell.image == nil {
                                        print("Cell has no Image is nil")
                                        cell.imageView.image = image
                                        cell.closeBtn.isHidden = false
                                    }
                                    else {
                                        print("After appended count :one \(self.imageDataSource.count)")
                                    }
                                })
                            } else {
                                SDWebImageManager.shared().imageDownloader?.downloadImage(with: url, options: SDWebImageDownloaderOptions.continueInBackground, progress: nil, completed: { (image, data, error, status) in
                                    SDImageCache.shared().store(image, forKey: url.absoluteString)
                                    if cell.image == nil {
                                        print("Cell contans no Image is nil")
                                        cell.imageView.image = image
                                        cell.closeBtn.isHidden = false
                                    }
                                    else {
                                        print("After appended count two: \(self.imageDataSource.count)")
                                    }
                                })
                            }
                        }
                    }
                }
                print("Image data source i $$$$$$$$$$ \(images.count), index path \(indexPath.item)")
                activityIndicator.stopAnimating()
            }
        }
        activityIndicator.stopAnimating()
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 50, height: 50)
    }
}
extension EditListingVC : MarketServiceDelegate {
    func DidReceivedData(data: [MyListingItems]) {
        print("Not needed")
    }
    func didReceiveViewListings(data: [ViewListingItems]) {
        DispatchQueue.main.async {
            self.configureTextFields(with: data.last!)
        }
    }
    func DidReceivedError(error: String) {
        print("Error found : \(error)")
        showMessage(with: error)
    }
}
extension EditListingVC: FPNTextFieldDelegate {
    func fpnDidSelectCountry(name: String, dialCode: String, code: String, textField: UITextField) {
        self.codeSelected = dialCode
        print("This is from edit listing", name, dialCode, code)
    }
    
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        print(isValid)
    }
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
        self.codeSelected = dialCode
        print(name, dialCode, code)
    }
}
extension String {
    func leftPadding(toLength: Int, withPad: String = " ") -> String {
        guard toLength > self.count else { return self }
        let padding = String(repeating: withPad, count: toLength - self.count)
        return padding + self
    }
}

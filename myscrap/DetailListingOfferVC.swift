//
//  DetailOfferVC.swift
//  myscrap
//
//  Created by MyScrap on 7/19/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit
import MessageUI

class DetailListingOfferVC: UIViewController{
    
    private var data: DetailListing?{
        didSet{
            if let _ = data{
                reloadCollectionViews()
            }
        }
    }
    
    var service = MarketService()
    var dataSource = [ViewListingItems]()
    weak var delegate: MarketDataCellDelegate?
    weak var chatDelegate: ListDetailDelegate?
    var id: String?
    var user_id : String?
    var listing_id : String?
    var anonym : Bool!
    var phoneStore = ""
    
    lazy var client : APIClient = {
        let client = APIClient()
        return client
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return rc
    }()
    
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = UIColor.white
        cv.registerNibLoadable(ListDetailCell.self)
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    let bottomView: AddListingBottomView = {
        let view = AddListingBottomView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let av = UIActivityIndicatorView(style: .gray)
        av.hidesWhenStopped = true
        av.translatesAutoresizingMaskIntoConstraints = false
        return av
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        
        service.detailMarketLists(listingId: listing_id!)
        service.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        self.hideKeyboardWhenTappedAround()
        
        bottomView.isHidden = true
        
        view.backgroundColor = UIColor.white
        
        
        let stackView = UIStackView(arrangedSubviews: [collectionView, bottomView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        view.addSubview(stackView)
        
        bottomView.setSize(size: CGSize(width: 0, height: 60))
        stackView.anchor(leading: view.safeLeading, trailing: view.safeTrailing, top: view.safeTop, bottom: view.safeBottom)
        
        view.addSubview(activityIndicator)
        activityIndicator.setHorizontalCenter(to: view.centerXAnchor)
        activityIndicator.topAnchor.constraint(equalTo: view.safeTop, constant: 20).isActive = true
        activityIndicator.setSize(size: CGSize(width: 30, height: 30))
        activityIndicator.startAnimating()
        
        //fetchData()
        
        
        //setupBottomViewListners()
    }
    
    @objc func rightBarPressed(sender: UIButton) {
        let Alert = UIAlertController(title: "Can Edit/Delete", message: nil, preferredStyle: .actionSheet)
        let name = UIAlertAction(title: "Edit", style: .default) { [weak self] (action) in
//            let vc = AddListingVC()
//            let rearViewController = MenuVC()
//            let frontNavigationController = UINavigationController(rootViewController: vc)
//            let mainRevealController = SWRevealViewController()
//            mainRevealController.rearViewController = rearViewController
//            mainRevealController.frontViewController = frontNavigationController
//            self!.present(mainRevealController, animated: true, completion: {
//                //NotificationCenter.default.post(name: .userSignedIn, object: nil)
//            })
            
            print("Listing Id : \(self?.listing_id), User Id : \(self?.user_id)")
            //let vc = AddListingVC.controllerInstance(with: self?.listing_id, with1: self?.user_id)
            //self?.navigationController?.pushViewController(vc, animated: true)
            
            if let vc = EditListingVC.storyBoardInstance() {
                if AuthStatus.instance.isGuest{
                    print("Guest user")
                    self?.showGuestAlert()
                } else {
                    vc.user_id = self?.user_id
                    vc.listing_id = self?.listing_id
                    print("Edit btn pressed")
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
                
            }
            
        }
        let country = UIAlertAction(title: "Delete", style: .default) { [unowned self] (action) in
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
                self.getDeleteListing(with: self.listing_id ?? "", completion: { (result) in
                    /*if self.activityIndicator.isAnimating{
                     self.activityIndicator.stopAnimating()
                     }*/
                    self.showToast(message: "Listing has been deleted!!!")
                    self.activityIndicator.stopAnimating()
                    switch result{
                    case .success(let data):
                        print("JSON DATA \(data)")
                        //There is no data but deleting list is working
                    case .failure(let error):
                        print("Failure  ",error)
                        
                        self.pushViewController(storyBoard: StoryBoard.MARKET, Identifier: MarketVC.id)
                    }
                })
            }
            
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        Alert.addAction(name)
        Alert.addAction(country)
        Alert.addAction(cancel)
        Alert.view.tintColor = UIColor.GREEN_PRIMARY
        self.present(Alert, animated: true, completion: nil)
    }
    typealias deleteListingResponse = (Result<DetailListing,APIError>) -> Void
    
    
    func getDeleteListing(with listingId: String, completion: @escaping deleteListingResponse) {
        let params = [PostKeys.userId: AuthService.instance.userId,
                      PostKeys.apiKey : API_KEY,
                      PostKeys.delete_listId: listingId
        ]
        
        client.getDataWith(with: Endpoints.DELETE_LISTING_URL, params: params , completion: { (result: Result<DetailListing,APIError>) in
            DispatchQueue.main.async {
                completion(result)
                //print("error for delete \(result)")
            }
        })
    }
    func deleteListing() {
        
        
        let service = APIService()
        service.endPoint = Endpoints.DELETE_LISTING_URL
        print("user id \(AuthService.instance.userId), API KEY \(API_KEY), LIST ID \(listing_id!)")
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&listId=\(String(describing: self.listing_id))"
        service.getDataWith(completion: { (result) in
            
            
            //self.pushViewController(storyBoard: StoryBoard.MARKET, Identifier: MarketVC.id)
        })
    }
    
    fileprivate func pushViewController(storyBoard: String,  Identifier: String,checkisGuest: Bool = false){
        guard !checkisGuest else {
            self.showGuestAlert(); return
        }
        let vc = UIStoryboard(name: storyBoard , bundle: nil).instantiateViewController(withIdentifier: Identifier)
        let nav = UINavigationController(rootViewController: vc)
        revealViewController().pushFrontViewController(nav, animated: true)
    }
    
    /*private func fetchData(){
        let service = MarketService()
        if let listingId = id{
            service.viewListing(with: listingId) { (result) in
                if self.activityIndicator.isAnimating{
                    self.activityIndicator.stopAnimating()
                }
                switch result{
                case .success(let data):
                    self.data = data
                    let anony = data.anonymous
                    if anony == "1" {
                        self.anonym = true
                        //self.setupBottomViewListners()
                    } else if anony == "0" {
                        self.anonym = false
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }*/
    
    @objc
    private func refresh(){
        if activityIndicator.isAnimating {
            activityIndicator.stopAnimating()
        }
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
    
    private func setupBottomViewListners(){
        if self.anonym == true {
            bottomView.contactSellerButton.isEnabled = false
            bottomView.contactSellerButton.titleLabel?.textColor = .lightGray
            showToast(message: "User post this as anonymous, \n you can contact them through email.")
        } else {
            bottomView.didTapContact = { () in
                if !AuthStatus.instance.isGuest{
                    let item = self.dataSource.last?.user_data.last
                    let fullName = (item?.first_name)! + " " + (item?.last_name)!
                    if item?.user_id != "" || item?.jid != "" || fullName != "" || item?.colorcode != "" {
                        self.performConversationVC(friendId: (item?.user_id)!, profileName: fullName, colorCode: item?.colorcode, profileImage: item?.profile_img, jid: (item?.jid)!, listingId: "", listingTitle: "", listingType: "", listingImg: "")
                    } else {
                        print("Data fetching error")
                    }
//                    if let item = self.data, let userdata = item.user_data , let id = userdata.userId , let jid = userdata.jid, let name = userdata.fullName, let ccode = userdata.colorCode  {
//
//                        self.performConversationVC(friendId: id, profileName: name, colorCode: ccode, profileImage: userdata.profilePic, jid: jid)
//                    }
                } else {
                    self.showGuestAlert()
                }
            }
        }
        
        bottomView.didTapEmail = { () in
            if !AuthStatus.instance.isGuest{
                let item = self.dataSource.last?.user_data.last
                if item?.email != "" {
                    if self.anonym == true {
                        print("Navigating to AnonymEmailVC page")
                        //                        guard let vc = AnonymEmailVC.storyBoardInstance() else { return }
                        //                        vc.modalTransitionStyle = .coverVertical
                        //                        vc.modalPresentationStyle = .overCurrentContext
                        //                        self.navigationController?.pushViewController(vc, animated: true)
                        let popOverVC = UIStoryboard(name: "Email", bundle: nil).instantiateViewController(withIdentifier: "AnonymEmailVC") as! AnonymEmailVC
                        self.addChild(popOverVC)
                        popOverVC.listing_id = self.listing_id!
                        popOverVC.user_id = self.user_id!
                        popOverVC.view.frame = self.view.frame
                        self.view.addSubview(popOverVC.view)
                        popOverVC.didMove(toParent: self)
                        
                    } else {
                        self.sendMail(with: (item?.email)!)
                    }
                }
//                if let item = self.data, let data = item.user_data, let email = data.email{
//                    if self.anonym == true {
//                        print("Navigating to AnonymEmailVC page")
////                        guard let vc = AnonymEmailVC.storyBoardInstance() else { return }
////                        vc.modalTransitionStyle = .coverVertical
////                        vc.modalPresentationStyle = .overCurrentContext
////                        self.navigationController?.pushViewController(vc, animated: true)
//                        let popOverVC = UIStoryboard(name: "Email", bundle: nil).instantiateViewController(withIdentifier: "AnonymEmailVC") as! AnonymEmailVC
//                        self.addChildViewController(popOverVC)
//                        popOverVC.listing_id = self.listing_id!
//                        popOverVC.user_id = self.user_id!
//                        popOverVC.view.frame = self.view.frame
//                        self.view.addSubview(popOverVC.view)
//                        popOverVC.didMove(toParentViewController: self)
//
//                    } else {
//                        self.sendMail(with: email)
//                    }
//
//                }
            } else {
               self.showGuestAlert()
            }
            print("Email Tapped")
        }
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
    
    func phone(number: String) {
        let valid = self.validNumber(number: number)
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
    
    func validNumber(number: String) -> String {
        var phoneNumWithPlus = ""
        let phone = number
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
    
    /*func mailComposeController(controller: MFMailComposeViewController,
                               didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        // Check the result or perform other tasks.
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }*/
    
    static func controllerInstance(with id: String?,with1 user_id: String?) -> DetailListingOfferVC{
        let vc = DetailListingOfferVC()
        vc.listing_id = id
        vc.user_id = user_id
        if let id = id{
            vc.id = id
            let padZero = vc.id!.leftPadding(toLength: 6, withPad: "0")
            vc.title = "Listing ID \(padZero)"
            vc.user_id = user_id
            print("Show user Id passed :\(user_id)")
        }
        return vc
    }
    
    static func storyBoardInstance() -> MarketVC?{
        let st = UIStoryboard.Market
        return st.instantiateViewController(withIdentifier: MarketVC.id) as? MarketVC
    }
    
}

extension DetailListingOfferVC: MSSliderDelegate {
    func didSelect(photo: Images, in photos: [Images]) {
        let vc = MarketPhotosController()
        vc.photo = photo
        presentGallery(photos: photos, initialPhoto: photo)
    }
}





extension DetailListingOfferVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ListDetailCell = collectionView.dequeReusableCell(forIndexPath: indexPath)
        //cell.data = data
        cell.viewListingData = dataSource
        cell.chatDelegate = self
        cell.sliderView.delegate = self
        cell.emailActionBlock = {
            self.sendMail(with: cell.emailValue)
        }
        
        cell.phoneActionBlock = {
            //phoneStore = cell.callValue
            self.phone(number: cell.callValue)
        }
        view.layoutIfNeeded()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if dataSource.count == 0 {
            return 0
        } else {
            return dataSource.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
//        if let item = data{
//            let height = 8 + LabelHeight.heightForLabel(for: item.title, for: self.view.frame.width - 16, for: Fonts.listingDetailTitleFont) + 8 + (self.view.frame.width * 9/16) + 30 + 8 + 16 + 25 + 142 + 25 + 25 + 8 + LabelHeight.heightForLabel(for: item.description, for: self.view.frame.width - 34, for: Fonts.DESIG_FONT) + 8 + 1 + 25
//            return CGSize(width: view.frame.width, height: height)
//        }
        if dataSource.count != 0 {
            let item = dataSource[indexPath.row]
            if item.user_data.last?.user_id == AuthService.instance.userId {
                let height = 8 + LabelHeight.heightForLabel(for: item.title, for: self.view.frame.width - 16, for: Fonts.listingDetailTitleFont) + 8 + (self.view.frame.width * 9/16) + 30 + 8 + 16 + 25 + 142 + 25 + 25 + 8 + LabelHeight.heightForLabel(for: item.description, for: self.view.frame.width - 34, for: Fonts.DESIG_FONT) + 20 + 8 + 1 + 55
                return CGSize(width: view.frame.width, height: height)
            } else {
                if item.user_data.last?.contactMeChat == "0" && item.user_data.last?.contactMePhoneNo == "" && item.user_data.last?.contactMePhoneCode == "" && item.user_data.last?.contactMeEmail == "" {
                    //nothing will be there
                    let height = 8 + LabelHeight.heightForLabel(for: item.title, for: self.view.frame.width - 16, for: Fonts.listingDetailTitleFont) + 8 + (self.view.frame.width * 9/16) + 30 + 8 + 16 + 25 + 142 + 25 + 25 + 8 + LabelHeight.heightForLabel(for: item.description, for: self.view.frame.width - 34, for: Fonts.DESIG_FONT) + 20 + 168 + 8 + 1 + 55
                    return CGSize(width: view.frame.width, height: height)
                } /*else if item.user_data.last?.contactMeChat == "0" && (item.user_data.last?.contactMePhoneNo != "" && item.user_data.last?.contactMePhoneCode != "") || item.user_data.last?.contactMeEmail == ""{
                    //phone is there || email is not there
                    let height = 8 + LabelHeight.heightForLabel(for: item.title, for: self.view.frame.width - 16, for: Fonts.listingDetailTitleFont) + 8 + (self.view.frame.width * 9/16) + 30 + 8 + 16 + 25 + 142 + 25 + 25 + 8 + LabelHeight.heightForLabel(for: item.description, for: self.view.frame.width - 34, for: Fonts.DESIG_FONT) + 290 - 35
                    return CGSize(width: view.frame.width, height: height)
                }*/ else if item.user_data.last?.contactMeChat == "1" && item.user_data.last?.contactMePhoneNo == "" && item.user_data.last?.contactMePhoneCode == "" && item.user_data.last?.contactMeEmail == ""{
                    //chat alone is there
                    let height = 8 + LabelHeight.heightForLabel(for: item.title, for: self.view.frame.width - 16, for: Fonts.listingDetailTitleFont) + 8 + (self.view.frame.width * 9/16) + 30 + 8 + 16 + 25 + 142 + 25 + 25 + 8 + LabelHeight.heightForLabel(for: item.description, for: self.view.frame.width - 34, for: Fonts.DESIG_FONT) + 307
                    return CGSize(width: view.frame.width, height: height)
                } else if item.user_data.last?.contactMeChat == "0" && item.user_data.last?.contactMePhoneNo != "" &&  item.user_data.last?.contactMeEmail == "" {
                    //Phone alone is there
                    let height = 8 + LabelHeight.heightForLabel(for: item.title, for: self.view.frame.width - 16, for: Fonts.listingDetailTitleFont) + 8 + (self.view.frame.width * 9/16) + 30 + 8 + 16 + 25 + 142 + 25 + 25 + 8 + LabelHeight.heightForLabel(for: item.description, for: self.view.frame.width - 34, for: Fonts.DESIG_FONT) + 290 - 35
                    return CGSize(width: view.frame.width, height: height)
                } else if item.user_data.last?.contactMeChat == "0" && item.user_data.last?.contactMePhoneNo == "" && item.user_data.last?.contactMePhoneCode == "" && item.user_data.last?.contactMeEmail != "" {
                    //Email alone is there
                    let height = 8 + LabelHeight.heightForLabel(for: item.title, for: self.view.frame.width - 16, for: Fonts.listingDetailTitleFont) + 8 + (self.view.frame.width * 9/16) + 30 + 8 + 16 + 25 + 142 + 25 + 25 + 8 + LabelHeight.heightForLabel(for: item.description, for: self.view.frame.width - 34, for: Fonts.DESIG_FONT) + 290 - 35
                    return CGSize(width: view.frame.width, height: height)
                } /*else if item.user_data.last?.contactMeChat == "0" && (item.user_data.last?.contactMePhoneNo == "" && item.user_data.last?.contactMePhoneCode == "") || item.user_data.last?.contactMeEmail != "" {
                    //Email is there || phone not there
                    let height = 8 + LabelHeight.heightForLabel(for: item.title, for: self.view.frame.width - 16, for: Fonts.listingDetailTitleFont) + 8 + (self.view.frame.width * 9/16) + 30 + 8 + 16 + 25 + 142 + 25 + 25 + 8 + LabelHeight.heightForLabel(for: item.description, for: self.view.frame.width - 34, for: Fonts.DESIG_FONT) + 290 - 35
                    return CGSize(width: view.frame.width, height: height)
                }*/ else if item.user_data.last?.contactMeChat == "1" && item.user_data.last?.contactMePhoneNo == "" && item.user_data.last?.contactMePhoneCode == "" && item.user_data.last?.contactMeEmail != ""{
                    //chat + email is there
                    let height = 8 + LabelHeight.heightForLabel(for: item.title, for: self.view.frame.width - 16, for: Fonts.listingDetailTitleFont) + 8 + (self.view.frame.width * 9/16) + 30 + 8 + 16 + 25 + 142 + 25 + 25 + 8 + LabelHeight.heightForLabel(for: item.description, for: self.view.frame.width - 34, for: Fonts.DESIG_FONT) + 307 + 8 + 1 + 25
                    return CGSize(width: view.frame.width, height: height)
                } else if item.user_data.last?.contactMeChat == "1" && item.user_data.last?.contactMePhoneNo != "" && item.user_data.last?.contactMeEmail == ""{
                    //chat + phone is there
                    let height = 8 + LabelHeight.heightForLabel(for: item.title, for: self.view.frame.width - 16, for: Fonts.listingDetailTitleFont) + 8 + (self.view.frame.width * 9/16) + 30 + 8 + 16 + 25 + 142 + 25 + 25 + 8 + LabelHeight.heightForLabel(for: item.description, for: self.view.frame.width - 34, for: Fonts.DESIG_FONT) + 307 + 8 + 1 + 25
                    return CGSize(width: view.frame.width, height: height)
                }
                else {
                    //All values there exception
                    let height = 8 + LabelHeight.heightForLabel(for: item.title, for: self.view.frame.width - 16, for: Fonts.listingDetailTitleFont) + 8 + (self.view.frame.width * 9/16) + 30 + 8 + 16 + 25 + 142 + 25 + 25 + 8 + LabelHeight.heightForLabel(for: item.description, for: self.view.frame.width - 34, for: Fonts.DESIG_FONT) + 20 + 307 + 8 + 1 + 25
                    return CGSize(width: view.frame.width, height: height)
                }
            }
        }
        return CGSize(width: view.frame.width, height: view.frame.height + 50)
    }
    
    func presentGallery(photos: [MarketPhotoViewable], initialPhoto: MarketPhotoViewable){
        
        let gallery = MarketPhotosController(photos: photos, initialPhoto: initialPhoto, referenceView: nil)
        self.present(gallery, animated: true, completion: nil)
    }
}
extension DetailListingOfferVC: MarketServiceDelegate {
    func DidReceivedData(data: [MyListingItems]) {
        print("List items")
    }
    
    func didReceiveViewListings(data: [ViewListingItems]) {
        DispatchQueue.main.async {
            self.dataSource = data
            
            //Based on the market list selected and loggedin user this condition will work
            self.user_id = data.last?.userId
            if self.user_id == AuthService.instance.userId {
                //create a new button
                let button: UIButton = UIButton(type: UIButton.ButtonType.custom)
                //set image for button
                button.setImage(UIImage(named: "ellipsis2.png"), for: UIControl.State.normal)
                //add function for button
                button.addTarget(self, action: #selector(self.rightBarPressed(sender:)), for: UIControl.Event.touchUpInside)
                //set frame
                button.frame = CGRect(x: 0, y: 0, width: 53, height: 31)
                
                let barButton = UIBarButtonItem(customView: button)
                //assign button to navigationbar
                self.navigationItem.rightBarButtonItem = barButton
            }
            else {
                print("No editing or deleting for Add listing")
            }
            
            if self.user_id == AuthService.instance.userId {
                //self.bottomView.isHidden = true
            } else {
                //self.bottomView.isHidden = false
            }
            
            let anony = data.last?.anonymous
            if anony == "1" {
                self.anonym = true
                //self.setupBottomViewListners()
            } else if anony == "0" {
                self.anonym = false
                //self.setupBottomViewListners()
            }
            self.collectionView.reloadData()
            if self.activityIndicator.isAnimating{
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    func DidReceivedError(error: String) {
        print("Error in detail listing :\(error)")
        DispatchQueue.main.async {
            if self.activityIndicator.isAnimating{
                self.activityIndicator.stopAnimating()
            }
            let alertVC = UIAlertController(title: "Removed!!",message: "This market list has been removed",preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK",style:.default) { [unowned self] (action) in
                self.navigationController?.popViewController(animated: true)
            }
            alertVC.addAction(okAction)
            self.present(alertVC,animated: true,completion: nil)
        }
    }
}
extension DetailListingOfferVC: ListDetailDelegate {
    func chatBtnDelegate(listingId: String, listingTitle: String, listingType: String, listingImg: String) {
        if !AuthStatus.instance.isGuest{
            
            let item = self.dataSource.last?.user_data.last
            let fullName = (item?.first_name)! + " " + (item?.last_name)!
            if item?.user_id != "" || item?.jid != "" || fullName != "" || item?.colorcode != "" {
                //self.performConversationVC(friendId: (item?.user_id)!, profileName: fullName, colorCode: item?.colorcode, profileImage: item?.profile_img, jid: (item?.jid)!, listingId: listingId, listingTitle: listingTitle, listingType: listingType, listingImg: listingImg)
                let vc = ConversationVC.storyBoardInstance()
                vc!.friendId = item!.user_id
                vc!.profileName = fullName
                vc!.colorCode = item!.colorcode
                vc!.jid = item!.jid
                vc!.listingId = listingId
                vc!.listingTitle = listingTitle
                vc!.listingType = listingType
                vc!.listingImg = listingImg
                if item!.profile_img != "https://myscrap.com/style/images/icons/no-profile-pic-female.png" {
                    vc!.profileImage = item!.profile_img
                }
                self.navigationController?.pushViewController(vc!, animated: true)
            } else {
                print("Data fetching error")
            }
        } else {
            self.showGuestAlert()
        }
    }
}




struct DetailListing: Decodable{
    
    var title: String{
        if listingType == "0" {
            return "Sales : \(listingIsriCode.uppercased()), \(listingProductName.capitalized)"
        } else {
            return "Buy : \(listingIsriCode.uppercased()), \(listingProductName.capitalized)"
        }
    }
    
    var expiry: String{
        if let dt = Int(duration){
            let date = Date(timeIntervalSince1970: Double(dt))
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM YYYY"
            return formatter.string(from: date)
        }
        return ""
    }
    
    
    let listingId : String
    let userId: String
    let listingTitle :String
    let listingType : String
    let anonymous : String
    let description: String
    let listingProductName : String
    let listingIsriCode:  String
    let totalView: String
    let paymentTerms : String
    let portName: String
    let priceTerms: String
    let shipmentTerm: String
    let rate: String
    let commodity : String
    let packaging: String
    let countryName: String
    let flagCode: String
    let user_data: UserData?
    let duration: String
    let quantity: String
    let listingImg: [String]?
    let listingIsriCodeID: String
    let portID: String
    let countryID: String
    let isFav: Bool
    
}

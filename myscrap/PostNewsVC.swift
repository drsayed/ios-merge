//
//  PostNewsVC.swift
//  myscrap
//
//  Created by MS1 on 8/30/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit
import Photos
//import BSImagePicker
/*

class PostNewsVC: BaseVC,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var headline: UITextField!
    @IBOutlet weak var subHeadlineTxtFld: UITextField!
    @IBOutlet weak var contentTxtView: RSKPlaceholderTextView!
    @IBOutlet weak var locationTxtFld: AutoCompleteTextField!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var addPhotosButton: UIButton!
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var rightImageView: UIImageView!
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var headlinePassed = ""
    var subheadlinePassed = ""
    var contentPassed = ""
    
    var companyId = "0"
    var editPostId = ""
    fileprivate var dataTask:URLSessionDataTask?
    
    fileprivate let googleMapsKey = "AIzaSyBE0S9Fu1p7jaPE9Imp8jKod0OAqYlqLfQ"
    fileprivate let baseURLString = "https://maps.googleapis.com/maps/api/place/autocomplete/json"
    
    
    var selectedAssets = [PHAsset]()
    fileprivate var photoArray = [UIImage]()
    fileprivate var photoArray2 = [UIImage]()
    
    fileprivate var currentPage: Int = 0
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.hidesForSinglePage = true
        pc.currentPage = 1
        pc.isEnabled = false
        switch self.photoArray.count{
        case 0:
            pc.numberOfPages = 1
        default:
            pc.numberOfPages = self.photoArray.count
        }
        pc.currentPageIndicatorTintColor = UIColor.GREEN_PRIMARY
        pc.pageIndicatorTintColor = UIColor.gray
        pc.translatesAutoresizingMaskIntoConstraints = false
        return pc
    }()
    
    lazy var inputContainerView: UIView = {
       let cv = UIView()
        cv.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60)
        cv.backgroundColor = UIColor.white
        cv.addSubview(self.publishButton)
        return cv
    }()
    
    lazy var publishButton : CorneredButton = {
        let btn = CorneredButton()
        btn.frame = CGRect(x: self.view.frame.width - 98, y: 8, width: 90, height: 42)
        btn.backgroundColor = UIColor.GREEN_PRIMARY
        btn.setTitle("Publish", for: .normal)
        btn.addTarget(self, action: #selector(publishClicked(_:)), for: .touchUpInside)
        return btn
    }()
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPassViews()
        setupCollectionView()
        configureTextField()
        handleTextFieldInterfaces()
        setupTaps()
    }
    fileprivate func setupPassViews(){
        headline.text = headlinePassed
        subHeadlineTxtFld.text = subheadlinePassed
        contentTxtView.text = contentPassed
    }
    fileprivate func setupTaps(){
    
         /* let scrollTap = UITapGestureRecognizer(target: self, action: #selector(scrollTapped(_:)))
        scrollTap.numberOfTapsRequired = 1
        self.scrollView.addGestureRecognizer(scrollTap) */
        
        let leftTap = UITapGestureRecognizer(target: self, action: #selector(leftViewTapped(_:)))
        leftTap.numberOfTapsRequired = 1
        self.leftView.addGestureRecognizer(leftTap)
        
        let rightTap = UITapGestureRecognizer(target: self, action: #selector(rightViewTapped(_:)))
        rightTap.numberOfTapsRequired = 1
        self.rightView.addGestureRecognizer(rightTap)
        self.scrollView.keyboardDismissMode = .interactive
    }
    @objc fileprivate func scrollTapped(_ tap: UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    @objc fileprivate func leftViewTapped(_ tap: UITapGestureRecognizer){
        let ip = IndexPath(item: currentPage - 1, section: 0)
        if collectionView.hasRowAtIndexPath(indexPath: ip){
            self.collectionView.scrollToItem(at: ip, at: .left, animated: true)
        }
    }
    @objc fileprivate func rightViewTapped(_ tap: UITapGestureRecognizer){
         let ip = IndexPath(item: currentPage + 1, section: 0)
        if collectionView.hasRowAtIndexPath(indexPath: ip){
            self.collectionView.scrollToItem(at: ip, at: .right, animated: true)
        }
        
        
    }
    
    fileprivate func handleTextFieldInterfaces(){
        locationTxtFld.onTextChange = {[weak self] text in
            if !text.isEmpty{
                if let dataTask = self?.dataTask {
                    dataTask.cancel()
                }
                self?.fetchAutocompletePlaces(text)
            }
        }
    }
    fileprivate func fetchAutocompletePlaces(_ keyword:String) {
        let urlString = "\(baseURLString)?key=\(googleMapsKey)&input=\(keyword)"
        let s = (CharacterSet.urlQueryAllowed as NSCharacterSet).mutableCopy() as! NSMutableCharacterSet
        s.addCharacters(in: "+&")
        if let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: s as CharacterSet) {
            if let url = URL(string: encodedString) {
                let request = URLRequest(url: url)
                dataTask = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
                    if let data = data{
                        
                        do{
                            
                            if let result = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]{
                                if let status = result["status"] as? String{
                                    if status == "OK"{
                                        if let predictions = result["predictions"] as? [[String: AnyObject]]{
                                            var locations = [String]()
                                            for predi in predictions{
                                                locations.append(predi["description"] as! String)                                            }
                                            
                                            DispatchQueue.main.async(execute: {
                                                self.locationTxtFld.autoCompleteStrings = locations
                                            })
                                            return
                                        }
                                    }
                                }
                            }
                            
                            DispatchQueue.main.async(execute: { () -> Void in
                                self.locationTxtFld.autoCompleteStrings = nil
                            })
                        }
                        catch let error as NSError{
                            print("Error: \(error.localizedDescription)")
                        }
                    }
                })
                dataTask?.resume()
            }
        }
    }


    fileprivate func configureTextField(){
        locationTxtFld.autoCompleteTextColor = UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0)
        locationTxtFld.autoCompleteTextFont = UIFont(name: "HelveticaNeue-Light", size: 12.0)!
        locationTxtFld.autoCompleteCellHeight = 35.0
        locationTxtFld.maximumAutoCompleteCount = 20
        locationTxtFld.hidesWhenSelected = true
        locationTxtFld.hidesWhenEmpty = true
        locationTxtFld.enableAttributedText = true
        var attributes = [NSAttributedStringKey:AnyObject]()
        attributes[NSAttributedStringKey.foregroundColor] = UIColor.black
        attributes[NSAttributedStringKey.font] = UIFont(name: "HelveticaNeue", size: 16.0)
        locationTxtFld.autoCompleteAttributes = attributes
    }

    
    private func setupCollectionView(){
        collectionView.register(PostNewsCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.layer.borderWidth = 1.0
        collectionView.layer.borderColor = UIColor.black.cgColor
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            
        }
        
        //Setup PageControl
        view.addSubview(pageControl)
        pageControl.widthAnchor.constraint(equalToConstant: collectionView.frame.width).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: -10).isActive = true
        
        //Setup textview
        contentTxtView.layer.cornerRadius = 5
        contentTxtView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        contentTxtView.layer.borderWidth = 0.5
        contentTxtView.clipsToBounds = true
        contentTxtView.tintColor = UIColor.GREEN_PRIMARY
        contentTxtView.textContainerInset.top = 8
        
        let lftimg = #imageLiteral(resourceName: "arrow_left").withRenderingMode(.alwaysTemplate)
        self.leftImageView.image = lftimg
        self.leftView.tintColor = UIColor.white
        let rightImg = #imageLiteral(resourceName: "arrow_right").withRenderingMode(.alwaysTemplate)
        self.rightImageView.image = rightImg
        self.rightView.tintColor = UIColor.white

        
        }
    
    @objc private func publishClicked(_ sender: UIButton){
        let headlines = self.headline.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let subHeadlines = self.subHeadlineTxtFld.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let content = self.contentTxtView.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let location = self.locationTxtFld.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let pics = photoArray
        
        if headlines == "" || subHeadlines == "" || content == "" || location == "" || self.contentTxtView.text == ""{
            
           showerrorAlert()
        } else {
          
            
            
            self.showActivityIndicator(with: "Posting News.")
            self.view.endEditing(true)
            self.publishButton.isUserInteractionEnabled = false
            self.publishButton.alpha = 0.6
            self.postNews(heading: headlines!, subheadings: subHeadlines!, content: content!, location: location!, pics: pics)
        }
        
    }
    private func postNews(heading: String, subheadings: String, content: String , location: String, pics: [UIImage]){
     
        var ipAdress = ""
        if AuthService.instance.getIFAddresses().count >= 1 {
            ipAdress = AuthService.instance.getIFAddresses().description.replacingOccurrences(of: " ", with: "")
        }
        
        var multiImage = "&multiImage="
        var imageCount = "&imageCount="
        if !photoArray.isEmpty{
            imageCount += "\(photoArray.count)"
        }
        
        if !photoArray.isEmpty{
            let imageString:[String] = self.base64(images: photoArray)
            let multiImageParam = imageDictionary(base64Array: imageString)
            do {
                if let postData : Data = try? JSONSerialization.data(withJSONObject: multiImageParam, options: .prettyPrinted){
                    let json = String(data: postData, encoding: String.Encoding.utf8)!
//                    json = json.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                    multiImage = multiImage + "{\"multiImage\":\(json)}"
                }
                
            } catch {
                print("error")
            }
            
        }
        let api = APIService()
        api.endPoint = Endpoints.USER_PROFILE_INSERT_URL
        let userid = UserDefaults.standard.value(forKey: "userid") as! String
        api.params = "apiKey=\(API_KEY)&userId=\(userid)&friendId=0&companyId=\(companyId)&content=\(content)&location=\(location)&device=\(MOBILE_DEVICE)&newsHeading=\(heading)&subNewsHeading=\(subheadings)&ipAddress=\(ipAdress)&load=0\(imageCount)\(multiImage)".replacingOccurrences(of: "+", with: "%2B")
        api.getDataWith { (result) in
            switch result{
            case .Success( _):
                print("Success")
                DispatchQueue.main.async {
                    self.view.isUserInteractionEnabled = true
                    self.navigationController?.view.isUserInteractionEnabled = true
                    self.navigationController?.popViewController(animated: true)
                }
            case .Error(let error):
                print(error)
                DispatchQueue.main.async {
                    self.view.isUserInteractionEnabled = true
                    self.navigationController?.view.isUserInteractionEnabled = true
                }
            }
        }
    
    }
    private func showerrorAlert(){
        let alertController = UIAlertController(title: "Check all Fields", message: "All fields other than photos are required to publish a news.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "O.K", style: .cancel, handler: nil))
        alertController.view.tintColor = UIColor.GREEN_PRIMARY
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        updateCollectionView()
        updateScrollButtons()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        IQKeyboardManager.sharedManager().enable = true
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PostNewsCell
        cell.imageView.image = photoArray[indexPath.item]
        return cell
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoArray.count
    }
    
    override var inputAccessoryView: UIView?{
        get {
            return inputContainerView
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.view.frame.width - 40
        
        return CGSize(width: width, height: width / 2)
    }
    override var canBecomeFirstResponder: Bool{
        return true
    }
    @IBAction func addPhotosClicked(_ sender: UIButton){
        
        let vc = BSImagePickerViewController()
        vc.maxNumberOfSelections = 5
//        var cellsPerRow: (_ verticalSize: UIUserInterfaceSizeClass, _ horizontalSize: UIUserInterfaceSizeClass) = 
        
        
    
        bs_presentImagePickerController(vc, animated: true,
                                        select: { (asset: PHAsset) -> Void in
                                            // User selected an asset.
                                            // Do something with it, start upload perhaps?
        }, deselect: { (asset: PHAsset) -> Void in
            // User deselected an assets.
            // Do something, cancel upload?
        }, cancel: { (assets: [PHAsset]) -> Void in
            // User cancelled. And this where the assets currently selected.
        }, finish: { (assets: [PHAsset]) -> Void in
            // User finished with these assets
            
            self.selectedAssets = [PHAsset]()
            
            for aset in assets{
                self.selectedAssets.append(aset)
            }
            
            self.convertAssetintoImages()
            
        }, completion: nil)
    }
    private func convertAssetintoImages(){
        
        if selectedAssets.count != 0 {
            var picArray = [UIImage]()
            for i in 0..<selectedAssets.count{
                let manager = PHImageManager.default()
                let options = PHImageRequestOptions()
                var thumbnail = UIImage()
                options.isSynchronous = true
                manager.requestImage(for: selectedAssets[i], targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: options, resultHandler: { (result, info) in
                    
                    thumbnail = result!
                })
                
                picArray.append(thumbnail)
            }
           
            DispatchQueue.main.async {
                self.becomeFirstResponder()
                self.photoArray = picArray
                self.pageControl.numberOfPages = self.photoArray.count
                self.collectionView.reloadData()
                self.collectionView.isHidden = false
                let indexpath = IndexPath(item: 0, section: 0)
                self.collectionView.scrollToItem(at: indexpath, at: .left, animated: true)
                self.updateScrollButtons()
                self.view.setNeedsDisplay()
            }
        }
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == collectionView {
            let pageWidth = scrollView.frame.width
            let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
            self.currentPage = currentPage
            pageControl.currentPage = currentPage
            
            switch currentPage {
            case 0:
                self.leftView.isHidden = true
                self.rightView.isHidden = false
                self.view.layoutIfNeeded()
            case photoArray.count - 1:
                self.rightView.isHidden = true
                self.leftView.isHidden = false
                self.view.layoutIfNeeded()
            default:
                self.rightView.isHidden = false
                self.leftView.isHidden = false
                self.view.layoutIfNeeded()
            }
        }
    }
    private func updateScrollButtons(){
        
        switch photoArray.count {
        case 0, 1:
            self.leftView.isHidden = true
            self.rightView.isHidden = true
        default:
            self.leftView.isHidden = true
            self.rightView.isHidden = false
        }
    }
    
    private func updateCollectionView(){
        self.collectionView.reloadData()
        if photoArray.isEmpty{
            collectionView.isHidden = true
        } else {
            collectionView.isHidden = false
        }
        
        self.view.layoutIfNeeded()
    }
}
class PostNewsCell: UICollectionViewCell{
    
    let imageView : UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = #imageLiteral(resourceName: "placeholder")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imageView)
        
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
//MARK :- IMAGE TO BASE64 ARRAY FUNCTIONS
extension PostNewsVC {
    
    fileprivate func base64(images: [UIImage]) -> [String]{
        var base64Array = [String]()
        for image in images{
            let imageData = UIImageJPEGRepresentation(image, 1.0)
            if let imageString = imageData?.base64EncodedString(options: .lineLength64Characters){
                base64Array.append(imageString)
            }
        }
        return base64Array
    }
    
    fileprivate func imageDictionary(base64Array:[String]) -> [[String:String]]{
        
        var dictionary = [[String:String]]()
        
        for i in 0..<base64Array.count{
            var dict = [String:String]()
            dict["feedImage\(i)"] = base64Array[i]
            dictionary.append(dict)
        }
        return dictionary
    }
    static func storyBoardInstance() -> PostNewsVC? {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PostNewsVC") as? PostNewsVC
    }
}

extension UICollectionView {
    func hasRowAtIndexPath(indexPath: IndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.item < self.numberOfItems(inSection: indexPath.section)
    }
}
*/

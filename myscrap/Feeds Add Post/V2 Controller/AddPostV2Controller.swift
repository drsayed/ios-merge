//
//  AddPostV2Controller.swift
//  myscrap
//
//  Created by MyScrap on 2/9/20.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Alamofire
import RealmSwift
import Photos
import DKImagePickerController

class AddPostV2Controller: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var acttivityTagging: UIActivityIndicatorView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textView: RSKPlaceholderTextView!
    @IBOutlet weak var postButton: UIBarButtonItem!
    @IBOutlet private weak var profileView: ProfileView!
    @IBOutlet private weak var nameLabel : NameLabel!
    @IBOutlet private weak var cameraView: CircleView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet fileprivate weak var mentionsTableView: UITableView!
    @IBOutlet weak var mentionSpinner: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var tagBtn: UIButton!
    @IBOutlet weak var galleryBtn: UIButton!
    @IBOutlet weak var removeBtn: UIButton!
    var uploadPercentage :Int = 0
    var  imagesToPosts : Array = [DKAsset]()
    var  videosToPosts : Array = [DKAsset]()
    var  videosToData : Array = [String]()
    var  imagesToUpload : Array = [UIImage]()

    var   profileEditPopUp = AlartMessagePopupView()
    //DidPost -> (Bool.Bool -> isVideoPosted)
    typealias DidPost = (Bool, Bool) -> Void
    var didPost: DidPost?
    
    var postImage: UIImage?
    var postImageView : UIImageView?
    var postText:String?
    // params to post
    
    let cellId = "cellId"
    var friendId = "0"
    var editPostId = ""
    
    var eventId: String?
    var eventPost = "1"
    
    var dataManager: MentionsTableViewDataManager?
    var mentionsListner : SZMentionsListener?
    
    //var tagName = ""
    //var tagId = ""
    fileprivate var service = MemmberModel()
    var feed_TagOffline : Results<FeedTagListsDB>!
    
    var tagArray = [[String:String]]()
    
    fileprivate var loadMore = true
    
    convenience init(didPost: @escaping DidPost){
        self.init()
        self.didPost = didPost
    }
    
    let picker = UIImagePickerController()
    
    var placehoder = "What's on your mind? \nType '@' to tag members."
    
    var isVideo = false
    var isImage = false
    
    var videoPickedUrl = URL(string: "")
    
    var typeString : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        uploadPercentage = 0
        picker.delegate = self
        picker.allowsEditing = true
        
      //  NotificationCenter.default.addObserver(self, selector: #selector(self.OpenEditProfileView(notification:)), name: Notification.Name("editButtonPressed"), object: nil)
        mentionsTableView.register(MemberTVC.classForCoder(), forCellReuseIdentifier: "cell")
        mentionsListner = SZMentionsListener(mentionTextView: textView, mentionsManager: self)
        self.mentionsTableView.tableFooterView = UIView(frame: .zero)
        self.mentionsTableView.tableFooterView?.isHidden = true
        if let listner = mentionsListner{
            dataManager = MentionsTableViewDataManager(mentionTableView: mentionsTableView, mentionsListener: listner, mentionTextView: textView)
        } else {
            print("Listner is not available in view load")
        }
        
        mentionsTableView.delegate = dataManager
        mentionsTableView.dataSource = dataManager
        dataManager?.delegate = self
        cameraView.layer.borderColor = UIColor.lightGray.cgColor
        cameraView.layer.borderWidth = 1.0
        profileView.updateViews(name: AuthService.instance.fullName, url: AuthService.instance.profilePic,  colorCode: AuthService.instance.colorCode)
        nameLabel.text = AuthService.instance.fullName
        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        tap.delegate = self
        tap.numberOfTapsRequired = 1
        self.scrollView.addGestureRecognizer(tap)
        
        
        textView.placeholder = NSString(string: placehoder)
        
        //self.getmembers()
        /*Mention.getMentions { (receivedMentions) in
         DispatchQueue.main.async {
         if let mentions = receivedMentions {
         self.dataManager?.mentions = mentions
         //dump(self.dataManager?.mentions)
         }
         }
         }*/
        
        
        setupCV()
        
        if isImage {
            removeBtn.isHidden = false
        } else if isVideo {
            removeBtn.isHidden = false
        } else {
            removeBtn.isHidden = true
        }
        //NotificationCenter.default.addObserver(self, selector: #selector(textChanged), name:NSNotification.Name.UITextViewTextDidChange, object: nil)
        
    }
    @objc func pauseVisibleVideos()  {
        
        for videoParentCell in collectionView.visibleCells   {
            
                var indexPathNotVisible = collectionView!.indexPath(for: videoParentCell)
            
            if let videoParentwithoutTextCell = videoParentCell as? PreviewVideoPostCell
            {
                videoParentwithoutTextCell.player.pause()
            }
            }
    }
    //Not Using
    @objc func textChanged(notification: NSNotification) {
        if textView.text.contains("@") {
            if let text = textView.text , text != "" {
                self.acttivityTagging.isHidden = false
                self.acttivityTagging.startAnimating()
                self.view.bringSubviewToFront(self.acttivityTagging)
                if self.dataManager?.mentions.count != 0 {
                    self.getMembersValues(pageLoad: 0, searchText: text, orderBy: "",completion: { _ in
                        print("Got DS values :\(self.dataManager!.mentions.count)")
                    })
                }
            }
        }
    }
    func setupCV() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PreviewSImagePostCell.Nib, forCellWithReuseIdentifier: PreviewSImagePostCell.identifier)
        collectionView.register(PreviewVideoPostCell.Nib, forCellWithReuseIdentifier: PreviewVideoPostCell.identifier)
    }
    
    @objc func changeTextView(){
        togglePostBtn()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if videoPickedUrl != nil {
            self.videosToData.append(videoPickedUrl!.absoluteString)
            self.videoPickedUrl = nil
        }
        self.togglePostBtn()
        
        IQKeyboardManager.sharedManager().enable = false
        self.keyboardObserver()
        
        let storedTextView = UserDefaults.standard.object(forKey: "postText") as? String
        if storedTextView != "" {
            textView.text = storedTextView
        } else {
            print("No textview values stored before")
            textView.text = postText
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        friendId = "0"
        //editPostId = ""
        postImage = nil
        if postText == "" {
            postText = nil
        }
        //postText = nil
        //textView.text = nil
        IQKeyboardManager.sharedManager().enable = true
        self.removeKeyboardObserver()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text.contains("@") {
            if let text = textView.text , text != ""  {
                if self.dataManager?.mentions.count != 0 {
                    DispatchQueue.main.async {
                        self.acttivityTagging.isHidden = false
                        self.acttivityTagging.startAnimating()
                        self.view.bringSubviewToFront(self.acttivityTagging)
                    }
                    self.getMembersValues(pageLoad: (self.dataManager?.mentions.count)!, searchText: text, orderBy: "",completion: { _ in
                        print("Got DS values :\(self.dataManager!.mentions.count)")
                    })
                }
            }
        }
    }
    
    private func getmembers(){
        /*self.getMembersValues(pageLoad: 0, searchText: "", orderBy: "",completion: { _ in
         print("Got DS values :\(self.dataManager!.mentions.count)")
         })*/
        Mention.getMentionsV2(pageLoad: 0, searchText: "") { (receivedMentions) in
            DispatchQueue.main.async {
                if let mentions = receivedMentions {
                    self.dataManager?.mentions = mentions
                    //dump(self.dataManager?.mentions)
                }
            }
        }
    }
    
    private func getMembersValues(pageLoad: Int, searchText: String, orderBy: String, completion: @escaping (Bool) -> () ){
        Mention.getMentionsV2(pageLoad: 0, searchText: searchText) { (receivedMentions) in
            DispatchQueue.main.async {
                if let mentions = receivedMentions {
                    self.dataManager?.mentions = mentions
                    self.acttivityTagging.stopAnimating()
                    self.acttivityTagging.isHidden = true
                    self.mentionsTableView.reloadData()
                    self.loadMore = true
                    //dump(self.dataManager?.mentions)
                    
                    completion(true)
                }
                else {
                    completion(false)
                }

            }
        }
    }
    
    private func loadMore(pageLoad: Int, searchText: String, orderBy: String, completion: @escaping (Bool) -> () ){
        Mention.getMentionsV2(pageLoad: pageLoad, searchText: "") { (receivedMentions) in
            DispatchQueue.main.async {
                if let mentions = receivedMentions {
                    let newData = self.dataManager!.mentions + mentions
                    
                    self.dataManager?.mentions = newData
                    self.acttivityTagging.stopAnimating()
                    self.acttivityTagging.isHidden = true
                    self.mentionsTableView.reloadData()
                    self.loadMore = true
                    //dump(self.dataManager?.mentions)
                }
            }
        }
    }
    
    /*func scrollViewDidScroll(_ scrollView: UIScrollView) {
     if !dataManager!.mentions.isEmpty{
     let currentOffset = scrollView.contentOffset.y
     let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
     let deltaOffset = maximumOffset - currentOffset
     if deltaOffset <= 0 {
     if loadMore{
     loadMore = false
     self.loadMore(pageLoad: dataManager!.mentions.count, searchText: textView.text, orderBy: "",completion: { _ in })
     }
     }
     }
     }*/
    
    func togglePostBtn(){
        let text = validate(textView:textView ?? UITextView())
        if !text && self.imagesToPosts.count == 0 && self.videosToData.count == 0 { //&& self.videosToData.count == 0 {
            self.postButton.isEnabled = false
        } else {
            self.postButton.isEnabled = true
        }
    }
    
    
    func toggleNewPostBtn(){
        let text = validate(textView:textView ?? UITextView())
        if !text && !isVideo {
            self.postButton.isEnabled = false
        } else {
            self.postButton.isEnabled = true
        }
    }
    
    func toggleTagButton() {
        
        self.tagBtn.setImage(UIImage(named: "addPostTag")?.withRenderingMode(.alwaysTemplate), for: .normal)

        if self.tagBtn.tag == 1 {
            self.tagBtn.tag = 0
            self.tagBtn.tintColor = UIColor.BLACK_ALPHA
        }
    }
    
    func validate(textView: UITextView) -> Bool {
        guard let text = textView.text,
            !text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty else {
                return false
        }
        return true
    }
    
    @IBAction private func closeButton(_ sender: UIButton){
        if postImage == nil && textView.text == "" {
            dismissController()
        } else {
            let alert = UIAlertController(title: "Do you want to discard this post?", message: nil, preferredStyle: .actionSheet)
            alert.view.tintColor = UIColor.GREEN_PRIMARY
            let discardAction = UIAlertAction(title: "Discard", style: .destructive, handler: { [unowned self] (action) in
                self.postImage = nil
                self.textView.text = ""
                self.dismissController()
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(discardAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func dismissController(){
        self.view.endEditing(true)
        //didPost?(true)
        didPost?(false, false)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing()
    }
    
    @objc func endEditing(){
        view.endEditing(true)
    }
    @objc func refreshImages()
    {
        self.imagesToUpload.removeAll()
         for imageData in imagesToPosts {
            imageData.fetchOriginalImage(completeBlock: { image, info in
                           if let img = image {
                            let fixOrientationImage=img.fixOrientation()
                            self.imagesToUpload.append(fixOrientationImage)
                           }
                       })
        }
        self.togglePostBtn()
    }
    @objc func addMorePhotosPressed(_ sender : UIButton){
        
        let pickerController = DKImagePickerController()
        pickerController.assetType = .allPhotos
        pickerController.maxSelectableCount=10;
        pickerController.showsCancelButton = true;
        pickerController.showsEmptyAlbums = false;
        pickerController.allowMultipleTypes = false;
        pickerController.defaultSelectedAssets = self.imagesToPosts;
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            print("didSelectAssets")
            print(assets)
            self.imagesToPosts.removeAll()
            for asset in assets {
                self.imagesToPosts.append(asset)
            }
            self.isImage = true
            self.isVideo = false
            self.refreshImages()
            self.collectionView.reloadData()
        }
        pickerController.modalPresentationStyle = .overFullScreen
        self.present(pickerController, animated: true, completion: nil)
        
    }
    @objc func addMoreVideosPressed(_ sender : UIButton){
        //            self.picker.sourceType = .photoLibrary
        //            self.picker.videoMaximumDuration = TimeInterval(65.0)
        //            self.picker.mediaTypes = ["public.movie"]
        //self.present(self.picker, animated: true, completion: nil)
        
      
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "mediaType == %d", PHAssetMediaType.video.rawValue),
           // NSPredicate(format: "duration < %d", 66),
        ])
        
        let configuration = DKImageGroupDataManagerConfiguration()
        configuration.assetFetchOptions = fetchOptions
        
        let groupDataManager = DKImageGroupDataManager(configuration: configuration)
        let pickerController = DKImagePickerController(groupDataManager: groupDataManager)
        
        //  let pickerController = DKImagePickerController()
        pickerController.assetType = .allVideos
        pickerController.sourceType = .video
        pickerController.maxSelectableCount=10;
        pickerController.showsCancelButton = true;
        pickerController.showsEmptyAlbums = false;
        pickerController.allowMultipleTypes = false;
        pickerController.defaultSelectedAssets = self.videosToPosts;
        pickerController.didSelectAssets = { (assets: [DKAsset]) in
            print("didSelectAssets")
            print(assets)
            self.videosToPosts.removeAll()
            for asset in assets {
                self.videosToPosts.append(asset)
            }
            self.refreshVedioToUploadData()
            self.isImage = false
            self.isVideo = true
            self.showToast(message: "Video sent to MyScrap post will be trimmed to first 65 seconds")
            self.collectionView.reloadData()
        }
        pickerController.modalPresentationStyle = .overFullScreen
        self.present(pickerController, animated: true, completion: nil)
        
    }

    func refreshVedioToUploadData()  {
        //  videosToData
        if videosToPosts.count != 0{
          //  videosToData .removeAll()
            for imageData in videosToPosts {
                let option = PHVideoRequestOptions()
                imageData.fetchAVAsset(options: option, completeBlock: { video, info in
                    if let urlAsset = video as? AVURLAsset {
                        let url = urlAsset.url.absoluteString
                        if !self.videoAlreadyExist(abSring: url) {
                            self.videosToData.append(url)
                            DispatchQueue.main.async {
                                self.togglePostBtn()
                            self.collectionView.reloadData()
                            }
                        }
                      
                        
                    }
                })
            }
        }
     
    }
    func DeleteFromDKAssetData(abSring : String)  {
        //  videosToData
    
          //  videosToData .removeAll()
        var  i : Int = 0
            for imageData in videosToPosts {
                let option = PHVideoRequestOptions()
                imageData.fetchAVAsset(options: option, completeBlock: { video, info in
                    if let urlAsset = video as? AVURLAsset {
                        let url = urlAsset.url.absoluteString
                        if abSring == url  {
                            let index  =  self.videosToPosts.firstIndex(of: imageData)
                            self.videosToPosts.remove(at : index!)
                        }
                     
                        
                    }
                })
                i += 1
            }
     
   
    }
    func videoAlreadyExist(abSring : String)  -> Bool {
        //  videosToData
       var isFound = false
          //  videosToData .removeAll()
            for imageData in videosToData {
                if imageData == abSring {
                    isFound = true
                }
            }
       return isFound
   
    }
    @IBAction func galleryBtnTapped(_ sender: UIButton) {
        
        self.mentionsTableView.isHidden = true
        self.collectionView.isHidden = false

        if textView.text != nil || textView.text != "" {
            let storingTV = UserDefaults.standard.set(textView.text, forKey: "postText")
            print("Storing Text View in gallery :\(storingTV)")
        }
        let Alert = UIAlertController(title: "Pick one option", message: "Choose an option to post into Feeds", preferredStyle: .actionSheet)
        let photo = UIAlertAction(title: "Photo Library", style: .default) { [unowned self] (action) in
            
            let pickerController = DKImagePickerController()
            pickerController.assetType = .allPhotos
            pickerController.maxSelectableCount=10;
            pickerController.showsCancelButton = true;
            pickerController.showsEmptyAlbums = false;
            pickerController.allowMultipleTypes = false;
            pickerController.defaultSelectedAssets = self.imagesToPosts //  self.videosToPosts;
            pickerController.didSelectAssets = { (assets: [DKAsset]) in
                print("didSelectAssets")
                print(assets)
                self.imagesToPosts.removeAll()
                for asset in assets {
                    self.imagesToPosts.append(asset)
                }
                
                self.refreshImages()
                
                self.isImage = true
                self.isVideo = false
                self.collectionView.reloadData()
            }
            pickerController.modalPresentationStyle = .overFullScreen
            self.present(pickerController, animated: true, completion: nil)
//               destination.pickerController = pickerController
//                        self.picker.sourceType = .photoLibrary
//                        self.picker.mediaTypes = ["public.image"]
//                       // self.present(self.picker, animated: true, completion: nil)
//                        let pickerController = DKImagePickerController()
//                        pickerController.assetType = .allPhotos
//            
//            
//                        self.presentViewController(pickerController, animated: true) {}
//            
//                      //  destination.pickerController = pickerController
//                         self.present(pickerController, animated: true, completion: nil)
        }
//        let video = UIAlertAction(title: "Video Library", style: .default) { [unowned self] (action) in
//            self.picker.sourceType = .photoLibrary
//            self.picker.videoMaximumDuration = TimeInterval(65.0)
//            self.picker.mediaTypes = ["public.movie"]
//            self.present(self.picker, animated: true, completion: nil)
//
//        }
        //HAJA commented before Live
        let video = UIAlertAction(title: "Video Library", style: .default) { [unowned self] (action) in
            //            self.picker.sourceType = .photoLibrary
            //            self.picker.videoMaximumDuration = TimeInterval(65.0)
            //            self.picker.mediaTypes = ["public.movie"]
            //self.present(self.picker, animated: true, completion: nil)


            let fetchOptions = PHFetchOptions()
            fetchOptions.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
                NSPredicate(format: "mediaType == %d", PHAssetMediaType.video.rawValue),
               // NSPredicate(format: "duration < %d", 66),
            ])

            let configuration = DKImageGroupDataManagerConfiguration()
            configuration.assetFetchOptions = fetchOptions

            let groupDataManager = DKImageGroupDataManager(configuration: configuration)
            let pickerController = DKImagePickerController(groupDataManager: groupDataManager)

            //  let pickerController = DKImagePickerController()
            pickerController.assetType = .allVideos
            pickerController.sourceType = .video
            pickerController.maxSelectableCount=10;
            pickerController.showsCancelButton = true;
            pickerController.showsEmptyAlbums = false;
            pickerController.allowMultipleTypes = false;
            pickerController.defaultSelectedAssets = self.videosToPosts;
            pickerController.didSelectAssets = { (assets: [DKAsset]) in
                print("didSelectAssets")
                print(assets)
                self.videosToPosts.removeAll()
                for asset in assets {
                    self.videosToPosts.append(asset)
                }
                self.refreshVedioToUploadData()
                self.isImage = false
                self.isVideo = true
                self.collectionView.reloadData()
                self.showToast(message: "Video sent to MyScrap post will be trimmed to first 65 seconds")

            }
            pickerController.modalPresentationStyle = .overFullScreen
            self.present(pickerController, animated: true, completion: nil)

        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        Alert.addAction(photo)
        Alert.addAction(video)
        Alert.addAction(cancel)
        Alert.view.tintColor = UIColor.GREEN_PRIMARY
        self.present(Alert, animated: true, completion: nil)
    }
    @IBAction func tagBtnTapped(_ sender: UIButton) {
        sender.setImage(UIImage(named: "addPostTag")?.withRenderingMode(.alwaysTemplate), for: .normal)

        if sender.tag == 0 {
            sender.tintColor = UIColor.GREEN_PRIMARY
            sender.tag = 1
            let mentionLists = [Mention]()
            if mentionLists.count != 0 {
                getTagLists()
                self.mentionsTableView.isHidden = false
            } else {
//                Mention.getMentions { (receivedMentions) in
//                    DispatchQueue.main.async {
//                        if let mentions = receivedMentions {
//                            self.dataManager?.mentions = mentions
//                            self.mentionsTableView.isHidden = false
//                            //dump(self.dataManager?.mentions)
//                        }
//                    }
//                }

                self.getMembersValues(pageLoad: (self.dataManager?.mentions.count)!, searchText: self.typeString, orderBy: "",completion: { _ in
                    print("Got DS values :\(self.dataManager!.mentions.count)")
                    self.mentionsTableView.isHidden = false
                })
            }
        } else {
            sender.tag = 0
            sender.tintColor = UIColor.BLACK_ALPHA
            self.mentionsTableView.isHidden = true
        }
    }
    func getTagLists() {
        var mentionItem = [Mention]()
        self.feed_TagOffline = uiRealm.objects(FeedTagListsDB.self)
        let jsonString = self.feed_TagOffline.last?.feedString
        let data = jsonString?.data(using: .utf8)!
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data!, options : .allowFragments) as? [String:AnyObject]
            {
                //print(jsonArray) // use the json here
                
                if let AddContactsData = jsonArray["addContactsData"] as? [[String:AnyObject]]{
                    
                    for obj in AddContactsData{
                        let item = Mention(Dict:obj)
                        mentionItem.append(item)
                    }
                    self.dataManager?.mentions = mentionItem
                    self.mentionsTableView.reloadData()
                    //self.mentionsTableView.isHidden = false
                }
            } else {
                print("bad json")
            }
        } catch let error as NSError {
            print(error)
        }
    }
    @IBAction func cameraBtnTapped(_ sender: UIButton) {
        self.mentionsTableView.isHidden = true
        self.collectionView.isHidden = false

        if textView.text != nil || textView.text != "" {
            UserDefaults.standard.set(textView.text, forKey: "postText")
        }
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {

        
                    let Alert = UIAlertController(title: "Pick one option", message: "Choose an option to post into Feeds", preferredStyle: .actionSheet)
                    let photo = UIAlertAction(title: "Photo", style: .default) { [unowned self] (action) in
                        
                        let pickerController = DKImagePickerController()
                        pickerController.assetType = .allPhotos
                        pickerController.sourceType = .camera
                        //pickerController.isEditing = false
                        pickerController.maxSelectableCount=1;
                        pickerController.showsCancelButton = true;
                        pickerController.showsEmptyAlbums = false;
                        pickerController.allowMultipleTypes = false;
//                        pickerController.defaultSelectedAssets = self.videosToPosts;
                        pickerController.didSelectAssets = { (assets: [DKAsset]) in
                            print("didSelectAssets")
                            print(assets)
                         //   self.imagesToPosts.removeAll()
                            for asset in assets {
                                self.imagesToPosts.append(asset)
                            }
                            
                            self.refreshImages()
                            
                            self.isImage = true
                            self.isVideo = false
                            self.collectionView.reloadData()
                        }
                        pickerController.modalPresentationStyle = .overFullScreen
                        self.present(pickerController, animated: true, completion: nil)
                        //   destination.pickerController = pickerController
                        //            self.picker.sourceType = .photoLibrary
                        //            self.picker.mediaTypes = ["public.image"]
                        //           // self.present(self.picker, animated: true, completion: nil)
                        //            let pickerController = DKImagePickerController()
                        //            pickerController.assetType = .allPhotos
                        
                        //
                        //            self.presentViewController(pickerController, animated: true) {}
                        //
                        //          //  destination.pickerController = pickerController
                        //             self.present(pickerController, animated: true, completion: nil)
                    }
            //        let video = UIAlertAction(title: "Video Library", style: .default) { [unowned self] (action) in
            //            self.picker.sourceType = .photoLibrary
            //            self.picker.videoMaximumDuration = TimeInterval(65.0)
            //            self.picker.mediaTypes = ["public.movie"]
            //            self.present(self.picker, animated: true, completion: nil)
            //
            //        }
                    let video = UIAlertAction(title: "Video", style: .default) { [unowned self] (action) in
                        
                        
                        self.picker.sourceType = .camera
                        self.picker.mediaTypes = ["public.movie"]
                        self.picker.showsCameraControls = true
                        self.picker.isToolbarHidden = true
                        self.picker.delegate = self
                        self.picker.videoMaximumDuration = TimeInterval(65.0)
                        self.picker.allowsEditing = true
                        self.picker.cameraCaptureMode = .video
                        self.picker.videoQuality = .type640x480
                        
                        self.present(self.picker,animated: true,completion: nil)
                        
                        //            self.picker.sourceType = .photoLibrary
                        //            self.picker.videoMaximumDuration = TimeInterval(65.0)
                        //            self.picker.mediaTypes = ["public.movie"]
                        //self.present(self.picker, animated: true, completion: nil)


                        
//                        self.picker.sourceType = .camera
//                        self.picker.mediaTypes = ["public.movie"] //UIImagePickerController.availableMediaTypes(for: .camera)!
//                        self.picker.showsCameraControls = true
//                        self.picker.isToolbarHidden = true
//                        self.picker.videoMaximumDuration = TimeInterval(65.0)
//                        self.picker.allowsEditing = true
//                        self.picker.cameraCaptureMode = .video
//                        self.picker.videoQuality = .type640x480
//                        //self?.picker.cameraCaptureMode =  UIImagePickerControllerCameraCaptureMode.photo
//                        //self?.picker.cameraCaptureMode = .video
//                        //self?.picker.modalPresentationStyle = .custom
//                        self.present(self.picker,animated: true,completion: nil)
//                        let fetchOptions = PHFetchOptions()
//                        fetchOptions.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
//                            NSPredicate(format: "mediaType == %d", PHAssetMediaType.video.rawValue),
//                           // NSPredicate(format: "duration < %d", 66),
//                        ])
//
//                        let configuration = DKImageGroupDataManagerConfiguration()
//                        configuration.assetFetchOptions = fetchOptions
//
//                        let groupDataManager = DKImageGroupDataManager(configuration: configuration)
//                        let pickerController = DKImagePickerController(groupDataManager: groupDataManager)
//
//                        //  let pickerController = DKImagePickerController()
//                        pickerController.assetType = .allAssets
//                        pickerController.maxSelectableCount=10;
//                        pickerController.sourceType = .camera
//                       // pickerController.UIDelegate = CustomUIDelegate();
//                        pickerController.showsCancelButton = true;
//                        pickerController.showsEmptyAlbums = false;
//                        pickerController.allowMultipleTypes = true;
//                        pickerController.defaultSelectedAssets = self.videosToPosts;
//                        pickerController.didSelectAssets = { (assets: [DKAsset]) in
//                            print("didSelectAssets")
//                            print(assets)
//                            self.videosToPosts.removeAll()
//                            for asset in assets {
//                                self.videosToPosts.append(asset)
//                            }
//                            self.refreshVedioToUploadData()
//                            self.isImage = false
//                            self.isVideo = true
//                            self.collectionView.reloadData()
//                        }
//                        pickerController.modalPresentationStyle = .overFullScreen
//                        self.present(pickerController, animated: true, completion: nil)
//
                 }
                   let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    Alert.addAction(photo)
                    Alert.addAction(video)
                    Alert.addAction(cancel)
                    Alert.view.tintColor = UIColor.GREEN_PRIMARY
                 self.present(Alert, animated: true, completion: nil)
                
        }
        else
        {
            self.nocamera()
        }
    }
    
    /*MARK :- UICollectionViewDelegate and UICollectionViewDataSource*/
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isVideo {
             //   return 1
            if videosToData.count > 0 {
                return videosToData.count + 1
            }
            return 1 //videosToData.count
        }
        else if isImage {
            if imagesToPosts.count > 0 {
                return imagesToPosts.count + 1
            }
            return imagesToPosts.count
        } else {
            return 0
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if isVideo {
        var videoCell = cell as! PreviewVideoPostCell
        videoCell.player.pause()
        videoCell.playPauseBtn.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        videoCell.playPauseBtn.tag = 0
        }
       
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if isVideo {
        var videoCell = cell as! PreviewVideoPostCell
        videoCell.player.pause()
        videoCell.playPauseBtn.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        videoCell.playPauseBtn.tag = 0
        }
       
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isVideo {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PreviewVideoPostCell.identifier, for: indexPath) as?  PreviewVideoPostCell else { return UICollectionViewCell()}
//            print("In cell :\(videoPickedUrl)")
            
//            cell.addMorePhotos.isHidden = true
//            cell.addMorePhotosButton.isHidden = true
//
//            cell.deleteImage.isHidden = false
//            cell.deleteImage.tag  = indexPath.item
//            cell.deleteImage.addTarget(self, action: #selector(self.deleteVideoPressed(_:)), for: .touchUpInside) //<- use `#selector(...)`
//
//            cell.showVideo = videoPickedUrl
//            if let video = videoPickedUrl {
//                cell.setupVideoLayer(videoUrl: video)
//            }
//
            NotificationCenter.default.addObserver(self, selector: #selector(self.videoEnded(notification:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: cell)

       
            let option = PHVideoRequestOptions()
            //   NotificationCenter.default.addObserver(self, selector: #selector(self.videoEnded(notification:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: cell)
            if indexPath.item < videosToData.count {
                cell.addMorePhotos.isHidden = true
                cell.addMorePhotosButton.isHidden = true
                cell.deleteImage.isHidden = false
                let imageData = videosToData[indexPath.item]
                cell.deleteImage.tag  = indexPath.item
                cell.deleteImage.addTarget(self, action: #selector(self.deleteVideoPressed(_:)), for: .touchUpInside) //<- use `#selector(...)`
                cell.showVideo = URL(string: imageData)
                cell.setupVideoLayer(videoUrl: URL(string: imageData)!)
//                imageData.fetchAVAsset(options: option, completeBlock: { video, info in
//                    DispatchQueue.main.async {
//                        if let urlAsset = video as? AVURLAsset {
//                            let url = urlAsset.url
//                            cell.showVideo = url
//                            cell.setupVideoLayer(videoUrl: url)
//                        }
//                    }
//                    //  var url = video.url.lastPathComponent as String
//
//                })
                
            }
            else
            {
                cell.addMorePhotos.isHidden = false
                cell.addMorePhotosButton.isHidden = false
                cell.addMorePhotosButton.isHidden = false
                cell.addMorePhotosButton.addTarget(self, action: #selector(self.addMoreVideosPressed(_:)), for: .touchUpInside)

            }
            
            return cell
        } else if isImage {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PreviewSImagePostCell.identifier, for: indexPath) as?  PreviewSImagePostCell else { return UICollectionViewCell()}
            //cell.postImageView.image = postImage
            if indexPath.item < imagesToPosts.count {
                
                var imageData = imagesToPosts[indexPath.item]
                imageData.fetchOriginalImage(completeBlock: { image, info in
                    if let img = image {
                        let fixOrientationImage=img.fixOrientation()
                        // cell.postImageView.image = fixOrientationImage
                        cell.addMorePhotos.isHidden = true
                        cell.addMorePhotosButton.isHidden = true
                        cell.deleteImage.isHidden = false
                        cell.postImageView.isHidden = false
                        cell.deleteImage.tag = indexPath.item;
                        cell.deleteImage.addTarget(self, action: #selector(self.deleteImagePressed(_:)), for: .touchUpInside) //<- use `#selector(...)`
                        let imageFormate = self.imagesToUpload[indexPath.item]
                        cell.setupPostImageView(image: imageFormate)
                        cell.bringSubviewToFront(cell.deleteImage)
                    }
                })
                
//                __block UIImage *firstImage;
//                       [assetImage fetchOriginalImage:YES completeBlock:^(UIImage * image, NSDictionary *dict) {
//                           firstImage=image;
//                       }];
                
                
                
//                imageData.fetchImage(with:cell.postImageView.frame.size, options: nil, contentMode:.aspectFill , completeBlock: { image, info in
//                    if let img = image {
//                        let fixOrientationImage=img.fixOrientation()
//                        // cell.postImageView.image = fixOrientationImage
//                        cell.addMorePhotos.isHidden = true
//                        cell.addMorePhotosButton.isHidden = true
//                        cell.deleteImage.isHidden = false
//                        cell.postImageView.isHidden = false
//                        cell.deleteImage.tag = indexPath.item;
//                        cell.deleteImage.addTarget(self, action: #selector(self.deleteImagePressed(_:)), for: .touchUpInside) //<- use `#selector(...)`
//
//                        cell.setupPostImageView(image: fixOrientationImage)
//                        cell.bringSubviewToFront(cell.deleteImage)
//                    }
//                })
            }
            else
            {
                cell.addMorePhotos.isHidden = false
                cell.addMorePhotosButton.isHidden = false
                cell.deleteImage.isHidden = true
                cell.postImageView.isHidden = true
                cell.addMorePhotosButton.addTarget(self, action: #selector(self.addMorePhotosPressed(_:)), for: .touchUpInside)
                
            }
            // cell.setupPostImageView(image: img)
            //}
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selecting the item")
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let width = self.frame.width
        return CGSize(width: self.collectionView.frame.width, height: 382)    //187.5 h : 279
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    

    
    @objc func videoEnded(notification: NSNotification) {
        if let videoCell = notification.object as? PreviewVideoPostCell {
            print("video ended")
            videoCell.playPauseBtn.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            videoCell.playPauseBtn.tag = 0
            videoCell.player.seek(to: CMTime.zero)
            videoCell.player.pause()
            videoCell.player.actionAtItemEnd = .none
        }
        
        //player.play()
    }
    
    //MARK: -UIImagePickerControllerDelegate
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        
    
          if let video = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
            if picker.sourceType == .camera {
                UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(video.path)
                // Handle a movie capture
                UISaveVideoAtPathToSavedPhotosAlbum(video.path,self,#selector(video(_:didFinishSavingWithError:contextInfo:)),nil)
            }

            self.videosToData.append(video.absoluteString)
           // self.refreshVedioToUploadData()
            self.isImage = false
            self.isVideo = true
            self.collectionView.reloadData()
            
//            togglePostBtn()
            toggleNewPostBtn()
            
        }
        
        picker.dismiss(animated: true,completion: nil)
        
        
    }
    //Save photo into Photos
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            /*let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
             ac.addAction(UIAlertAction(title: "OK", style: .default))
             present(ac, animated: true)*/
            print("Store image into Photos error: \(error)")
        } else {
            /*let ac = UIAlertController(title: "Saved!", message: "Your captured picture has been saved to your photos.", preferredStyle: .alert)
             ac.addAction(UIAlertAction(title: "OK", style: .default))
             present(ac, animated: true)*/
            print("Image stored into Photos!!")
        }
    }
    
    //Save Video into Photos
    @objc func video(_ videoPath: String, didFinishSavingWithError error: Error?, contextInfo info: AnyObject) {
        let title = (error == nil) ? "Success" : "Error"
        let message = (error == nil) ? "Video was saved" : "Video failed to save"
        
        /*let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
         present(alert, animated: true, completion: nil)*/
        print(message)
    }
    
    
    //MARK: -UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
    
    func nocamera()
    {
        let alertVC = UIAlertController(title: "No Camera",message: "Sorry, this device has no camera",preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK",style:.default,handler: nil)
        alertVC.addAction(okAction)
        present(alertVC,animated: true,completion: nil)
    }
    @IBAction func removeBtnTapped(_ sender: UIButton) {
        if isImage {
            
            self.removeBtn.isHidden = true
            isImage = false
            isVideo = false
            postImage = nil
            collectionView.reloadData()
        } else if isVideo {
            
            self.removeBtn.isHidden = true
            isImage = false
            isVideo = false
            collectionView.reloadData()
            
        }
        togglePostBtn()
    }
//d
    func gotoEditProfilePopup() {
        profileEditPopUp.removeFromSuperview()
        let vc = UIStoryboard(name: StoryBoard.PROFILE , bundle: nil).instantiateViewController(withIdentifier: EditProfileController.id) as! EditProfileController
        vc.isNeedToDismiss = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func postClicked(_ sender: Any) {
        
        let profilePic = AuthService.instance.profilePic
        let email = AuthService.instance.email
        let mobile = AuthService.instance.mobile
        if (profilePic == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" || profilePic == "") || (mobile == "" || email == ""){
            // gotoEditProfilePopup()
            profileEditPopUp =  Bundle.main.loadNibNamed("AlartMessagePopupView", owner: self, options: nil)?[0] as! AlartMessagePopupView
            profileEditPopUp.frame = CGRect(x:0, y:0, width:self.view.frame.width,height: self.view.frame.height)
            profileEditPopUp.intializeUI()
            profileEditPopUp.delegate = self
            self.view.addSubview(profileEditPopUp)
            
        }
        else{
            let text = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
            if (text != ""  || isImage != false || isVideo != false){
                self.postButton.isEnabled = false
                showActivityIndicator(with: "Posting into Feeds")
                 DispatchQueue.main.async {
                    self.showActivityIndicator(with: "Posting into Feeds")
             }
                NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
                textView.resignFirstResponder()
                mentionsTableView.isHidden = true
                self.postData()
            }
        }
        
    }
    
    func postData(){
        
        uploadPercentage = 0
        if let window = UIApplication.shared.keyWindow {
            
            
            let overlay = UIView(frame: CGRect(x: window.frame.origin.x, y: window.frame.origin.y, width: window.frame.width, height: window.frame.height))
            overlay.alpha = 0.5
            overlay.backgroundColor = UIColor.black
            window.addSubview(overlay)
            
            if isVideo {
                var content = ""
                var tagParms = ""
                if validate(textView: textView){
                    content = textView.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                    content = content.replacingOccurrences(of: "+", with: "%2B")
                }
                var ipAdress = ""
                if AuthService.instance.getIFAddresses().count >= 1 {
                    ipAdress = AuthService.instance.getIFAddresses()[0].description
                }
                
                let dictionary: [[String: String]]?
                var dic = [[String:String]]()
                let item = ["taggedId": "", "taggedUserName":""]
                dic.append(item)
                
                if let listner = mentionsListner{
                    var dicts = [[String:String]]()
                    let array = listner.mentions
                    for obj in array{
                        let item = ["taggedId": obj.mentionObject.mentionId, "taggedUserName":obj.mentionObject.mentionName]
                        dicts.append(item)
                        dump(dicts)
                    }
                    /*if tagName != "" && tagId != "" {
                     if textView.text.contains(tagName) {
                     dicts.append(["taggedId": tagId, "taggedUserName":tagName])
                     }
                     }*/
                    for taglist in tagArray {
                        if let id = taglist["tagId"] {
                            if let name = taglist["tagName"] {
                                if name != "" && id != "" {
                                    if textView.text.contains(name) {
                                        dicts.append(["taggedId": id, "taggedUserName":name])
                                    }
                                }
                            }
                        }
                    }
                    dictionary = removeDuplicates(dicts)
                    dump(dictionary)
                    if let tag = dictionary {
                        let dict = ["tagging": tag]
                        if let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: []) , let string = String(data: jsonData, encoding: .ascii){
                            tagParms = "\(string)"
                        }
                    }
                    //Editing the post
                    if editPostId != "" {
                        if let url = videoPickedUrl?.absoluteString.contains(".mp4") {
                            Alamofire.request(videoPickedUrl!.absoluteString).downloadProgress(closure : { (progress) in
                                print(progress.fractionCompleted)
                                //self.progressView.progress = Float(progress.fractionCompleted)
                            }).responseData{ (response) in
                                print(response)
                                print(response.result.value!)
                                print(response.result.description)
                                if let data = response.result.value {
                                    
                                    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                                    let videoURL = documentsURL.appendingPathComponent("video.mp4")
                                    do {
                                        try data.write(to: videoURL)
                                    } catch {
                                        print("Something went wrong!")
                                    }
                                    print("Downloaded Video",videoURL)
                                    print("Edit post ID : \(self.editPostId)")
//                                    self.videosToData.append(videoURL.absoluteString);
                                    self.videoPickedUrl = videoURL
                                   /*
                                    //Setting maximum Timeout for Alamofire
                                    Alamofire.SessionManager.default.session.configuration.timeoutIntervalForRequest = 1200
                                    
                                    Alamofire.upload(multipartFormData: { (multipartFormData) in
                                        //multipartFormData.append(fileURL: videoUrl, name: "video")
                                        //multipartFormData.append(videoUrl, withName: "content")
                                        let timestamp = NSDate().timeIntervalSince1970
                                        multipartFormData.append(self.videoPickedUrl!, withName: "userfile", fileName: "\(timestamp).mp4", mimeType: "\(timestamp)/mp4")
                                        multipartFormData.append("\(content)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "content")
                                        multipartFormData.append("\(self.editPostId)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "editPostId")
                                        multipartFormData.append("\(AuthService.instance.userId)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "userId")
                                        multipartFormData.append(API_KEY.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "apiKey")
                                        multipartFormData.append(tagParms.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "tagged")
                                        multipartFormData.append("\(Int(Date().timeIntervalSince1970))".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "timeStamp")
                                        multipartFormData.append(MOBILE_DEVICE.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "device")
                                        multipartFormData.append(self.friendId.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "friendId")
                                        multipartFormData.append(ipAdress.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "ipAddress")
                                        
                                    }, usingThreshold: UInt64(0), to: "https://myscrap.com/video/ios/upload_video", method: .post, headers: nil, encodingCompletion: {
                                        encodingResult in
                                        switch encodingResult {
                                        case .success(let alamofireUploadTask, _, let url):
                                            /*alamofireUploadTask.suspend()
                                             defer {
                                             alamofireUploadTask.cancel()
                                             }*/
                                            if let alamofireUploadFileUrl = url {
                                                var request = URLRequest(url: URL(string: "https://myscrap.com/video/ios/upload_video")!)
                                                request.httpMethod = "POST"
                                                for (key, value) in alamofireUploadTask.request!.allHTTPHeaderFields! { // transfer headers from the request made by alamofire
                                                    request.addValue(value, forHTTPHeaderField: key)
                                                }
                                                // we want to own the multipart file to avoid alamofire deleting it when we tell it to cancel its task
                                                // so copy file on alamofireUploadFileUrl to a file you control
                                                // dispatch the request to the background session
                                                // don't forget to delete the file when you're done uploading
                                                //Enabled Screen LOCK based on device
                                                UIApplication.shared.isIdleTimerDisabled = false
                                                
                                                //Deleting the uploaded file from alamofire storage
                                                do {
                                                    try FileManager.default.removeItem(at: alamofireUploadFileUrl)
                                                } catch {
                                                    print("Failed to remove stream file at URL: \(alamofireUploadFileUrl) - error: \(error)")
                                                }
                                                overlay.removeFromSuperview()
                                                
                                                UIView.animate(withDuration: 0.5, delay: 2, options: .curveEaseOut, animations: {
                                                    self.dismiss(animated: true, completion: nil)
                                                    //Uploaded video is true to show app rating in feeds
                                                    self.didPost?(true, true)
                                                    UserDefaults.standard.set(self.textView.text, forKey: "postText")
                                                }, completion: nil)
                                            }
                                        case .failure(let error):
                                            // alamofire failed to encode the request file for some reason
                                            //Enabled Screen LOCK based on device
                                            UIApplication.shared.isIdleTimerDisabled = false
                                            print("Response error from server")
                                            DispatchQueue.main.async {
                                                self.hideActivityIndicator()
                                            }
                                            overlay.removeFromSuperview()
                                            
                                            if error._code == NSURLErrorTimedOut {
                                                print("Request timeout!")
                                                UIView.animate(withDuration: 0.5, delay: 2, options: .curveEaseOut, animations: {
                                                    self.dismiss(animated: true, completion: nil)
                                                    //Uploaded video is true to show app rating in feeds
                                                    self.didPost?(false, false)
                                                }, completion: nil)
                                            } else {
                                                let alert = UIAlertController(title: "OOPS", message: "Failed to post video", preferredStyle: .actionSheet)
                                                alert.view.tintColor = UIColor.GREEN_PRIMARY
                                                let discardAction = UIAlertAction(title: "OK", style: .default, handler: { [unowned self] (action) in
                                                    UIView.animate(withDuration: 0.5, delay: 2, options: .curveEaseOut, animations: {
                                                        self.dismiss(animated: true, completion: nil)
                                                        //Uploaded video is true to show app rating in feeds
                                                        self.didPost?(false, false)
                                                    }, completion: nil)
                                                })
                                                alert.addAction(discardAction)
                                                self.present(alert, animated: true, completion: nil)
                                            }
                                        }
                                    })*/
                                    
                                    
                                    Alamofire.upload(multipartFormData: { (multipartFormData) in
                                     //multipartFormData.append(fileURL: videoUrl, name: "video")
                                     //multipartFormData.append(videoUrl, withName: "content")
                                     let timestamp = NSDate().timeIntervalSince1970
                                  //   multipartFormData.append(self.videoPickedUrl!, withName: "userfile", fileName: "\(timestamp).mp4", mimeType: "\(timestamp)/mp4")
//                                        var vCount : Int = 0
//                                        for imageData in self.videosToData {
//                                       multipartFormData.append(URL(string: imageData)!, withName: "feedVideoContent\(vCount)", fileName: "\(timestamp).mp4", mimeType: "\(timestamp)/mp4")
//                                       vCount += 1
//                                        }
//                                        if self.videosToData.count > 0 {
//                                            let imageData = self.videosToData[0]
//                                            multipartFormData.append(URL(string: imageData)!, withName: "userfile", fileName: "\(timestamp).mp4", mimeType: "\(timestamp)/mp4")
//                                        }

                                     multipartFormData.append(self.videoPickedUrl!, withName: "userfile", fileName: "\(timestamp).mp4", mimeType: "\(timestamp)/mp4")
                                        
                                        multipartFormData.append("\(content)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "msgcontent")
                                     multipartFormData.append("\(content)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "content")
                                     multipartFormData.append("\(self.editPostId)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "editPostId")
                                     multipartFormData.append("\(AuthService.instance.userId)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "userId")
                                     multipartFormData.append(API_KEY.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "apiKey")
                                     multipartFormData.append(tagParms.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "tagged")
                                     multipartFormData.append("\(Int(Date().timeIntervalSince1970))".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "timeStamp")
                                     multipartFormData.append(MOBILE_DEVICE.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "device")
                                     multipartFormData.append(self.friendId.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "friendId")
                                     multipartFormData.append(ipAdress.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "ipAddress")
                                        multipartFormData.append("".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "multiImage")
                                        multipartFormData.append("".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "eventPost")
                                     }, to: "https://myscrap.com/video/ios/upload_video") { (response) in
                                     debugPrint(response)
                                     switch response {
                                     
                                     case .success(let request, _, _):
                                     //Prevents from Screen LOCK
                                     UIApplication.shared.isIdleTimerDisabled = true
                                     //Upload Progress
                                     request.uploadProgress(closure: { (progress) in
                                     let totalBytes = progress.fractionCompleted
                                     
                                     //self.uploadProgress.progress = Float(totalBytes)
                                     
                                     DispatchQueue.main.async {
                                     /*if totalBytes == 1.00000 {
                                     self.hideActivityIndicator()
                                     } else {
                                     //self.showActivityIndicator(with: String(format:"%f", totalBytes))
                                     self.uploadProgress.progress = Float(totalBytes)
                                     //self.showActivityIndicator(with: "Uploading")
                                     }*/
                                     }
                                     })
                                     
                                     request.responseJSON(completionHandler: { (jsonResponse) in
                                     print("Request of alamofire : \(jsonResponse)")
                                     print("Response from json : \(jsonResponse.result.value)")
                                     
                                     switch jsonResponse.result {
                                     case .success(let value):
                                     if let dict = value as? [String: AnyObject] {
                                     if let uploadedVideo = dict["status"] as? String {
                                     if uploadedVideo == "success" {
                                     //Enabled Screen LOCK based on device
                                     UIApplication.shared.isIdleTimerDisabled = false
                                     let fromServer = dict["videoUrl"] as? String
                                     print("Video url : \(fromServer)")
                                    
                                     
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.50, execute: {
                                            overlay.removeFromSuperview()

                                            UserDefaults.standard.set(self.textView.text, forKey: "postText")
                                            self.didPost?(true, true)
                                            self.dismiss(animated: true) {
                                                
                                                //self.showToast(message: "Post uploaded")
                                            }
                                            
                                        })
                                     //self.showMessage(with: "Post Added Succesfully")
                                     //self.showVideo = URL(string: fromServer!)
                                     }
                                     }
                                     }
                                     
                                     case .failure(let error):
                                     //Enabled Screen LOCK based on device
                                     UIApplication.shared.isIdleTimerDisabled = false
                                     print("Response error from server")
                                     DispatchQueue.main.async {
                                     self.hideActivityIndicator()
                                     }
                                     overlay.removeFromSuperview()
                                     
                                     if error._code == NSURLErrorTimedOut {
                                     print("Request timeout!")
                                     UIView.animate(withDuration: 0.5, delay: 2, options: .curveEaseOut, animations: {
                                     self.dismiss(animated: true, completion: nil)
                                     //Uploaded video is true to show app rating in feeds
                                     self.didPost?(false, false)
                                     }, completion: nil)
                                     } else {
                                     let alert = UIAlertController(title: "OOPS", message: "Failed to post video", preferredStyle: .actionSheet)
                                     alert.view.tintColor = UIColor.GREEN_PRIMARY
                                     let discardAction = UIAlertAction(title: "OK", style: .default, handler: { [unowned self] (action) in
                                     UIView.animate(withDuration: 0.5, delay: 2, options: .curveEaseOut, animations: {
                                     self.dismiss(animated: true, completion: nil)
                                     //Uploaded video is true to show app rating in feeds
                                     self.didPost?(false, false)
                                     }, completion: nil)
                                     })
                                     alert.addAction(discardAction)
                                     self.present(alert, animated: true, completion: nil)
                                     }
                                     }
                                     })
                                     
                                     case .failure(let error):
                                     print("Error while upload :\(error)")
                                     DispatchQueue.main.async {
                                     self.hideActivityIndicator()
                                     }
                                     overlay.removeFromSuperview()
                                     if error.localizedDescription.contains("bodyPartURLInvalid") {
                                     let alert = UIAlertController(title: "OOPS", message: "Please pick the video to post!", preferredStyle: .actionSheet)
                                     alert.view.tintColor = UIColor.GREEN_PRIMARY
                                     let discardAction = UIAlertAction(title: "OK", style: .default, handler: { [unowned self] (action) in
                                     })
                                     alert.addAction(discardAction)
                                     self.present(alert, animated: true, completion: nil)
                                     } else {
                                     let alert = UIAlertController(title: "OOPS", message: "Failed to post video, Please try again later..", preferredStyle: .actionSheet)
                                     alert.view.tintColor = UIColor.GREEN_PRIMARY
                                     let discardAction = UIAlertAction(title: "OK", style: .default, handler: { [unowned self] (action) in
                                     })
                                     alert.addAction(discardAction)
                                     
                                     self.present(alert, animated: true, completion: nil)
                                     }
                                     }
                                     }
                                }
                            }
                        }
                    } else {
                        //Setting maximum Timeout for Alamofire
                        
                        Alamofire.SessionManager.default.session.configuration.timeoutIntervalForRequest = 50000
                        Alamofire.SessionManager.default.session.configuration.timeoutIntervalForResource = 50000

//                        if self.videosToData.count > 0 {
//                            self.videoPickedUrl =  URL(string: self.videosToData[0])!
//                        }
                        
                      //  self.uploadVideos(friendId: friendId, editPostId: editPostId, content: content, videoFeed: "", feedImage: "", eventId: eventId, tagging: tagArray)
                        Networking.sharedInstance.sessionManager.upload(multipartFormData: { (multipartFormData) in
                            let timestamp = NSDate().timeIntervalSince1970


                         //    https://myscrap.com/android/msUserPostInsertV2/
                     //    https://test.myscrap.com/android/msUserPostInsertV2?
                        //     "https://myscrap.com/video/ios/upload_video", //

                            print("content:\(content)")
                            print("editPostId:\(self.editPostId)")
                            print("userId:\(AuthService.instance.userId)")
                            print("apiKey:\(API_KEY)")
                            print("tagged:\(tagParms)")
                            print("timeStamp:\((Int(Date().timeIntervalSince1970)))")
                            print("device:\(MOBILE_DEVICE)")
                            print("friendId:\(self.friendId)")
                            print("ipAddress:\(ipAdress)")

                            multipartFormData.append("\(content)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "msgcontent")
                             multipartFormData.append("\(content)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "content")
                             multipartFormData.append("\(self.editPostId)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "editPostId")
                             multipartFormData.append("\(AuthService.instance.userId)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "userId")
                             multipartFormData.append(API_KEY.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "apiKey")
                             multipartFormData.append(tagParms.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "tagged")
                             multipartFormData.append("\(Int(Date().timeIntervalSince1970))".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "timeStamp")
                             multipartFormData.append(MOBILE_DEVICE.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "device")
                             multipartFormData.append(self.friendId.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "friendId")
                             multipartFormData.append(ipAdress.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "ipAddress")
                            multipartFormData.append("".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "multiImage")
                            multipartFormData.append("".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "eventPost")
                            var vCount : Int = 0
                            for imageData in self.videosToData {
                             //   var videoString = imageData.replacingOccurrences(of: "file://", with: "")
                                multipartFormData.append(URL(string: imageData)!, withName: "feedVideoContent\(vCount)", fileName: "\(timestamp).mp4", mimeType: "\(timestamp)/mp4")
                              //  multipartFormData.append(URL(string: imageData)!, withName: "feedVideoContent\(vCount)", fileName: "\(timestamp).mp4", mimeType: "\(timestamp)/mp4")
                                vCount += 1
                            }

                         },usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold , to: "https://myscrap.com/android/msUserPostInsertV2/", method: .post,
                      headers: ["Content-Type":"multipart/form-data"],encodingCompletion:
                        { [self]
                                encodingResult in
                                        switch encodingResult {
                                        case .success(let upload, _, _):

                                         /**TRACK PROGRESS OF UPLOAD**/
                                            upload.uploadProgress { [self] progress in
                                                print(progress.fractionCompleted)
                                                uploadPercentage = Int(progress.fractionCompleted * 100)
                                            }
                                            /***/
                                           // ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];

                                            upload.responseJSON (completionHandler: { (jsonResponse) in
                                                print("Request of alamofire : \(jsonResponse)")
                                                print("Response from json : \(jsonResponse.result.value)")
                                                if jsonResponse.result.value == nil
                                                {
                                                    if uploadPercentage == 100 {
                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.50, execute: {
                                                            overlay.removeFromSuperview()

                                                            UserDefaults.standard.set(self.textView.text, forKey: "postText")
                                                            self.didPost?(true, true)
                                                            self.dismiss(animated: true) {

                                                                //self.showToast(message: "Post uploaded")
                                                            }

                                                        })
                                                    }
                                                    else
                                                    {
                                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.50, execute: {
                                                            let alert = UIAlertController(title: "OOPS", message: "Failed to post video", preferredStyle: .actionSheet)
                                                            alert.view.tintColor = UIColor.GREEN_PRIMARY
                                                            let discardAction = UIAlertAction(title: "OK", style: .default, handler: { [unowned self] (action) in
                                                                UIView.animate(withDuration: 0.5, delay: 2, options: .curveEaseOut, animations: {
                                                                    self.dismiss(animated: true, completion: nil)
                                                                    //Uploaded video is true to show app rating in feeds
                                                                    self.didPost?(false, false)
                                                                }, completion: nil)
                                                            })
                                                            alert.addAction(discardAction)
                                                            self.present(alert, animated: true, completion: nil)
                                                        })
                                                    }
                                                }
                                                 else
                                                {
                                                    switch jsonResponse.result {
                                                    case .success(let value):
                                                        if let dict = value as? [String: AnyObject] {
                                                            if let uploadedVideo = dict["status"] as? String {
                                                                if uploadedVideo == "success" {
                                                                    //Enabled Screen LOCK based on device
                                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.50, execute: {
                                                                        overlay.removeFromSuperview()

                                                                        UserDefaults.standard.set(self.textView.text, forKey: "postText")
                                                                        self.didPost?(true, true)
                                                                        self.dismiss(animated: true) {

                                                                            //self.showToast(message: "Post uploaded")
                                                                        }

                                                                    })
                                                                }
                                                                else
                                                                {
                                                                    //Enabled Screen LOCK based on device
                                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.50, execute: {
                                                                        overlay.removeFromSuperview()

                                                                        UserDefaults.standard.set(self.textView.text, forKey: "postText")
                                                                        self.didPost?(true, true)
                                                                        self.dismiss(animated: true) {

                                                                            //self.showToast(message: "Post uploaded")
                                                                        }

                                                                    })
                                                                }
                                                            }
                                                        }

                                                    case .failure(let error):
                                                        //Enabled Screen LOCK based on device
                                                        UIApplication.shared.isIdleTimerDisabled = false

                                                        DispatchQueue.main.async {
                                                            self.hideActivityIndicator()
                                                        }
                                                        overlay.removeFromSuperview()
                                                        if error._code == NSURLErrorTimedOut {
                                                            print("Request timeout!")
                                                            UIView.animate(withDuration: 0.5, delay: 2, options: .curveEaseOut, animations: {
                                                                self.dismiss(animated: true, completion: nil)
                                                                //Uploaded video is true to show app rating in feeds
                                                                self.didPost?(false, false)
                                                            }, completion: nil)
                                                        } else {
                                                            let alert = UIAlertController(title: "OOPS", message: "Failed to post video", preferredStyle: .actionSheet)
                                                            alert.view.tintColor = UIColor.GREEN_PRIMARY
                                                            let discardAction = UIAlertAction(title: "OK", style: .default, handler: { [unowned self] (action) in
                                                                UIView.animate(withDuration: 0.5, delay: 2, options: .curveEaseOut, animations: {
                                                                    self.dismiss(animated: true, completion: nil)
                                                                    //Uploaded video is true to show app rating in feeds
                                                                    self.didPost?(false, false)
                                                                }, completion: nil)
                                                            })
                                                            alert.addAction(discardAction)
                                                            self.present(alert, animated: true, completion: nil)
                                                        }
                                                        print("Response error from server")
                                                    }
                                                }
                                               
                                                
                                            })

                                        case .failure(let encodingError):
                                            print(encodingError)
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.50, execute: {
                                                let alert = UIAlertController(title: "OOPS", message: "Failed to post video", preferredStyle: .actionSheet)
                                                alert.view.tintColor = UIColor.GREEN_PRIMARY
                                                let discardAction = UIAlertAction(title: "OK", style: .default, handler: { [unowned self] (action) in
                                                    UIView.animate(withDuration: 0.5, delay: 2, options: .curveEaseOut, animations: {
                                                        self.dismiss(animated: true, completion: nil)
                                                        //Uploaded video is true to show app rating in feeds
                                                        self.didPost?(false, false)
                                                    }, completion: nil)
                                                })
                                                alert.addAction(discardAction)
                                                self.present(alert, animated: true, completion: nil)
                                            })
                                            
                                        }
                                    })
//                        encodingCompletion:{
//                            encodingResult in
//                            switch encodingResult {
//                            case .success(let alamofireUploadTask, _, let url):
//                                //Prevents from Screen LOCK
//                                UIApplication.shared.isIdleTimerDisabled = true
//                                //Upload Progress
//                                alamofireUploadTask.uploadProgress(closure: { (progress) in
//                                    let totalBytes = progress.fractionCompleted
//                                    print("Completed \(totalBytes)")
//                                    //self.uploadProgress.progress = Float(totalBytes)
//
//                                    DispatchQueue.main.async {
//                                        /*if totalBytes == 1.00000 {
//                                         self.hideActivityIndicator()
//                                         } else {
//                                         //self.showActivityIndicator(with: String(format:"%f", totalBytes))
//                                         self.uploadProgress.progress = Float(totalBytes)
//                                         //self.showActivityIndicator(with: "Uploading")
//                                         }*/
//                                    }
//                                })
//                                alamofireUploadTask.responseJSON(completionHandler: { (jsonResponse) in
//                                    print("Request of alamofire : \(jsonResponse)")
//                                    print("Response from json : \(jsonResponse.result.value)")
//
//                                    switch jsonResponse.result {
//                                    case .success(let value):
//                                        if let dict = value as? [String: AnyObject] {
//                                            if let uploadedVideo = dict["status"] as? String {
//                                                if uploadedVideo == "success" {
//                                                    //Enabled Screen LOCK based on device
//                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.50, execute: {
//                                                        overlay.removeFromSuperview()
//
//                                                        UserDefaults.standard.set(self.textView.text, forKey: "postText")
//                                                        self.didPost?(true, true)
//                                                        self.dismiss(animated: true) {
//
//                                                            //self.showToast(message: "Post uploaded")
//                                                        }
//
//                                                    })
//                                                }
//                                                else
//                                                {
//                                                    //Enabled Screen LOCK based on device
//                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.50, execute: {
//                                                        overlay.removeFromSuperview()
//
//                                                        UserDefaults.standard.set(self.textView.text, forKey: "postText")
//                                                        self.didPost?(true, true)
//                                                        self.dismiss(animated: true) {
//
//                                                            //self.showToast(message: "Post uploaded")
//                                                        }
//
//                                                    })
//                                                }
//                                            }
//                                        }
//
//                                    case .failure(let error):
//                                        //Enabled Screen LOCK based on device
//                                        UIApplication.shared.isIdleTimerDisabled = false
//
//                                        DispatchQueue.main.async {
//                                            self.hideActivityIndicator()
//                                        }
//                                        overlay.removeFromSuperview()
//                                        if error._code == NSURLErrorTimedOut {
//                                            print("Request timeout!")
//                                            UIView.animate(withDuration: 0.5, delay: 2, options: .curveEaseOut, animations: {
//                                                self.dismiss(animated: true, completion: nil)
//                                                //Uploaded video is true to show app rating in feeds
//                                                self.didPost?(false, false)
//                                            }, completion: nil)
//                                        } else {
//                                            let alert = UIAlertController(title: "OOPS", message: "Failed to post video", preferredStyle: .actionSheet)
//                                            alert.view.tintColor = UIColor.GREEN_PRIMARY
//                                            let discardAction = UIAlertAction(title: "OK", style: .default, handler: { [unowned self] (action) in
//                                                UIView.animate(withDuration: 0.5, delay: 2, options: .curveEaseOut, animations: {
//                                                    self.dismiss(animated: true, completion: nil)
//                                                    //Uploaded video is true to show app rating in feeds
//                                                    self.didPost?(false, false)
//                                                }, completion: nil)
//                                            })
//                                            alert.addAction(discardAction)
//                                            self.present(alert, animated: true, completion: nil)
//                                        }
//                                        print("Response error from server")
//                                    }
//                                })
//                            case .failure(let error):
//                                // alamofire failed to encode the request file for some reason
//                                //Enabled Screen LOCK based on device
//                                UIApplication.shared.isIdleTimerDisabled = false
//                                print("Response error from server")
//                                DispatchQueue.main.async {
//                                    self.hideActivityIndicator()
//                                }
//                                overlay.removeFromSuperview()
//
//                                if error._code == NSURLErrorTimedOut {
//                                    print("Request timeout!")
//                                    UIView.animate(withDuration: 0.5, delay: 2, options: .curveEaseOut, animations: {
//                                        self.dismiss(animated: true, completion: nil)
//                                        //Uploaded video is true to show app rating in feeds
//                                        self.didPost?(false, false)
//                                    }, completion: nil)
//                                } else {
//                                    let alert = UIAlertController(title: "OOPS", message: "Failed to post video", preferredStyle: .actionSheet)
//                                    alert.view.tintColor = UIColor.GREEN_PRIMARY
//                                    let discardAction = UIAlertAction(title: "OK", style: .default, handler: { [unowned self] (action) in
//                                        UIView.animate(withDuration: 0.5, delay: 2, options: .curveEaseOut, animations: {
//                                            self.dismiss(animated: true, completion: nil)
//                                            //Uploaded video is true to show app rating in feeds
//                                            self.didPost?(false, false)
//                                        }, completion: nil)
//                                    })
//                                    alert.addAction(discardAction)
//                                    self.present(alert, animated: true, completion: nil)
//                                }
//                            }
//                        })
                        
//                        Networking.sharedInstance.sessionManager.upload(multipartFormData: { (multipartFormData) in
//                           let timestamp = NSDate().timeIntervalSince1970
//                            var vCount : Int = 0
//                            for imageData in self.videosToData {
//                             //   var videoString = imageData.replacingOccurrences(of: "file://", with: "")
//                                multipartFormData.append(URL(string: imageData)!, withName: "feedVideoContent\(vCount)", fileName: "\(timestamp).mp4", mimeType: "\(timestamp)/mp4")
//                              //  multipartFormData.append(URL(string: imageData)!, withName: "feedVideoContent\(vCount)", fileName: "\(timestamp).mp4", mimeType: "\(timestamp)/mp4")
//                                vCount += 1
//                            }
////                          multipartFormData.append(self.videoPickedUrl!, withName: "userfile", fileName: "\(timestamp).mp4", mimeType: "\(timestamp)/mp4")
////
////                                multipartFormData.append("0".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "imageCount")
////                             multipartFormData.append("".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "location")
////                             multipartFormData.append("".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "albumId")
////                             multipartFormData.append("".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "feedImage")
////                              multipartFormData.append("".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "multiImage")
////                             multipartFormData.append("\(content)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "msgcontent")
////                            multipartFormData.append("\(content)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "content")
////                            multipartFormData.append("\(self.editPostId)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "editPostId")
////                            multipartFormData.append("\(AuthService.instance.userId)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "userId")
////                            multipartFormData.append(API_KEY.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "apiKey")
////                            multipartFormData.append(tagParms.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "tagged")
////                            multipartFormData.append("\(Int(Date().timeIntervalSince1970))".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "timeStamp")
////                            multipartFormData.append(MOBILE_DEVICE.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "device")
////                            multipartFormData.append(self.friendId.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "friendId")
////                            multipartFormData.append(ipAdress.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "ipAddress")
//                        //    https://myscrap.com/android/msUserPostInsertV2/
//                    //    https://test.myscrap.com/android/msUserPostInsertV2?
//                       //     "https://myscrap.com/video/ios/upload_video", //
//                           // let timestamp = NSDate().timeIntervalSince1970
//                         //   multipartFormData.append(self.videoPickedUrl!, withName: "userfile", fileName: "\(timestamp).mp4", mimeType: "\(timestamp)/mp4")
//                            multipartFormData.append("\(content)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "content")
//                            multipartFormData.append("\(self.editPostId)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "editPostId")
//                            multipartFormData.append("\(AuthService.instance.userId)".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "userId")
//                            multipartFormData.append(API_KEY.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "apiKey")
//                            multipartFormData.append(tagParms.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "tagged")
//                            multipartFormData.append("\(Int(Date().timeIntervalSince1970))".data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "timeStamp")
//                            multipartFormData.append(MOBILE_DEVICE.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "device")
//                            multipartFormData.append(self.friendId.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "friendId")
//                            multipartFormData.append(ipAdress.data(using: String.Encoding.utf8, allowLossyConversion: false)!, withName: "ipAddress")
//
//                        }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold,
//                           to:"https://myscrap.com/android/msUserPostInsertV2/", //https://myscrap.com/android/msUserPostInsertV2/",
 //                          method: .post,
//                           headers: ["Content-Type":"multipart/form-data"], encodingCompletion: {
//                            encodingResult in
//                            switch encodingResult {
//                            case .success(let alamofireUploadTask, _, let url):
//                                //Prevents from Screen LOCK
//                                UIApplication.shared.isIdleTimerDisabled = true
//                                //Upload Progress
//                                alamofireUploadTask.uploadProgress(closure: { (progress) in
//                                    let totalBytes = progress.fractionCompleted
//                                    print("Completed \(totalBytes)")
//                                    //self.uploadProgress.progress = Float(totalBytes)
//
//                                    DispatchQueue.main.async {
//                                        /*if totalBytes == 1.00000 {
//                                         self.hideActivityIndicator()
//                                         } else {
//                                         //self.showActivityIndicator(with: String(format:"%f", totalBytes))
//                                         self.uploadProgress.progress = Float(totalBytes)
//                                         //self.showActivityIndicator(with: "Uploading")
//                                         }*/
//                                    }
//                                })
//                                alamofireUploadTask.responseJSON(completionHandler: { (jsonResponse) in
//                                    print("Request of alamofire : \(jsonResponse)")
//                                    print("Response from json : \(jsonResponse.result.value)")
//
//                                    switch jsonResponse.result {
//                                    case .success(let value):
//                                        if let dict = value as? [String: AnyObject] {
//                                            if let uploadedVideo = dict["status"] as? String {
//                                                if uploadedVideo == "success" {
//                                                    //Enabled Screen LOCK based on device
//                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.50, execute: {
//                                                        overlay.removeFromSuperview()
//
//                                                        UserDefaults.standard.set(self.textView.text, forKey: "postText")
//                                                        self.didPost?(true, true)
//                                                        self.dismiss(animated: true) {
//
//                                                            //self.showToast(message: "Post uploaded")
//                                                        }
//
//                                                    })
//                                                }
//                                                else
//                                                {
//                                                    //Enabled Screen LOCK based on device
//                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.50, execute: {
//                                                        overlay.removeFromSuperview()
//
//                                                        UserDefaults.standard.set(self.textView.text, forKey: "postText")
//                                                        self.didPost?(true, true)
//                                                        self.dismiss(animated: true) {
//
//                                                            //self.showToast(message: "Post uploaded")
//                                                        }
//
//                                                    })
//                                                }
//                                            }
//                                        }
//
//                                    case .failure(let error):
//                                        //Enabled Screen LOCK based on device
//                                        UIApplication.shared.isIdleTimerDisabled = false
//
//                                        DispatchQueue.main.async {
//                                            self.hideActivityIndicator()
//                                        }
//                                        overlay.removeFromSuperview()
//                                        if error._code == NSURLErrorTimedOut {
//                                            print("Request timeout!")
//                                            UIView.animate(withDuration: 0.5, delay: 2, options: .curveEaseOut, animations: {
//                                                self.dismiss(animated: true, completion: nil)
//                                                //Uploaded video is true to show app rating in feeds
//                                                self.didPost?(false, false)
//                                            }, completion: nil)
//                                        } else {
//                                            let alert = UIAlertController(title: "OOPS", message: "Failed to post video", preferredStyle: .actionSheet)
//                                            alert.view.tintColor = UIColor.GREEN_PRIMARY
//                                            let discardAction = UIAlertAction(title: "OK", style: .default, handler: { [unowned self] (action) in
//                                                UIView.animate(withDuration: 0.5, delay: 2, options: .curveEaseOut, animations: {
//                                                    self.dismiss(animated: true, completion: nil)
//                                                    //Uploaded video is true to show app rating in feeds
//                                                    self.didPost?(false, false)
//                                                }, completion: nil)
//                                            })
//                                            alert.addAction(discardAction)
//                                            self.present(alert, animated: true, completion: nil)
//                                        }
//                                        print("Response error from server")
//                                    }
//                                })
//                            case .failure(let error):
//                                // alamofire failed to encode the request file for some reason
//                                //Enabled Screen LOCK based on device
//                                UIApplication.shared.isIdleTimerDisabled = false
//                                print("Response error from server")
//                                DispatchQueue.main.async {
//                                    self.hideActivityIndicator()
//                                }
//                                overlay.removeFromSuperview()
//
//                                if error._code == NSURLErrorTimedOut {
//                                    print("Request timeout!")
//                                    UIView.animate(withDuration: 0.5, delay: 2, options: .curveEaseOut, animations: {
//                                        self.dismiss(animated: true, completion: nil)
//                                        //Uploaded video is true to show app rating in feeds
//                                        self.didPost?(false, false)
//                                    }, completion: nil)
//                                } else {
//                                    let alert = UIAlertController(title: "OOPS", message: "Failed to post video", preferredStyle: .actionSheet)
//                                    alert.view.tintColor = UIColor.GREEN_PRIMARY
//                                    let discardAction = UIAlertAction(title: "OK", style: .default, handler: { [unowned self] (action) in
//                                        UIView.animate(withDuration: 0.5, delay: 2, options: .curveEaseOut, animations: {
//                                            self.dismiss(animated: true, completion: nil)
//                                            //Uploaded video is true to show app rating in feeds
//                                            self.didPost?(false, false)
//                                        }, completion: nil)
//                                    })
//                                    alert.addAction(discardAction)
//                                    self.present(alert, animated: true, completion: nil)
//                                }
//                            }
//                        })
                    }
                    
                }
            } else {
                var content = ""
                var allImages: [Dictionary<String, String>] = []
                var i =  0
                if imagesToUpload.count != 0{
                    for imageData in imagesToUpload {
                        // let fixOrientationImage=imageData.fixOrientation()
                        let imageDataObj: Data = imageData.jpegData(compressionQuality:0.6)!
                            let imageString =  imageDataObj.base64EncodedString(options: .lineLength64Characters)
                            var myImage = [String: String]()
                              myImage["image\(i)"] = imageString
                               allImages.append(myImage)
                        i += 1
                    }
                }
                var feedImage = [String: AnyObject]()
                feedImage["multiImage"] = allImages as AnyObject
                
                //                if imagesToPosts.count != 0{
                //                    let imageData: Data = postImage!.jpegData(compressionQuality: 0.6)!
                //                    let imageString =  imageData.base64EncodedString(options: .lineLength64Characters)
                //                    feedImage.append(imageString)
                //                }
                
                if validate(textView: textView){
                    content = textView.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
                }
                
                let dictionary: [[String: String]]?
                var dic = [[String:String]]()
                let item = ["taggedId": "", "taggedUserName":""]
                dic.append(item)
                if let listner = mentionsListner{
                    var dicts = [[String:String]]()
                    let array = listner.mentions
                    for obj in array{
                        let item = ["taggedId": obj.mentionObject.mentionId, "taggedUserName":obj.mentionObject.mentionName]
                        dicts.append(item)
                        dump(dicts)
                    }
                    for taglist in tagArray {
                        if let id = taglist["tagId"] {
                            if let name = taglist["tagName"] {
                                if name != "" && id != "" {
                                    if textView.text.contains(name) {
                                        dicts.append(["taggedId": id, "taggedUserName":name])
                                    }
                                }
                            }
                        }
                    }
                    
                    dictionary = removeDuplicates(dicts)
                    dump(dictionary)
                    
                    let service = DetailService()
                    service.insertPost_V2(friendId: friendId, editPostId: editPostId, content: content.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlPathAllowed)!, videoFeed:"",  feedImage: feedImage,eventId:eventId, tagging: dictionary) { (success) in
                        DispatchQueue.main.async {
                            if success {
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.50, execute: {
                                    overlay.removeFromSuperview()

                                    UserDefaults.standard.set(self.textView.text, forKey: "postText")
                                    self.didPost?(true, false)
                                    self.dismiss(animated: true) {
                                        
                                        //self.showToast(message: "Post uploaded")
                                    }
                                    
                                })
                                //self.showMessage(with: "Post Edited Succesfully")
                            } else {
                                //todo :- error
                                /*UIView.animate(withDuration: 0.5, delay: 2, options: .curveEaseOut, animations: {
                                 self.didPost?(false)
                                 self.dismiss(animated: true, completion: nil)
                                 }, completion: nil)*/
                                DispatchQueue.main.async {
                                    self.hideActivityIndicator()
                                }
                                overlay.removeFromSuperview()
                                let alert = UIAlertController(title: "OOPS", message: "Failed to posts into Feeds, Try again!", preferredStyle: .actionSheet)
                                alert.view.tintColor = UIColor.GREEN_PRIMARY
                                let discardAction = UIAlertAction(title: "OK", style: .default, handler: { [unowned self] (action) in
                                    
                                })
                                
                                alert.addAction(discardAction)
                                
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                } else {

                    var dic = [[String:String]]()
                    let item = ["taggedId": "", "taggedUserName":""]
                    dic.append(item)
                    
                    let service = DetailService()
                    service.insertPost_V2(friendId: friendId, editPostId: editPostId, content: content, videoFeed: "" , feedImage: feedImage,eventId:eventId, tagging: dic) { (success) in
                        DispatchQueue.main.async {
                            if success {
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.50, execute: {
                                    overlay.removeFromSuperview()
                                    UserDefaults.standard.set(self.textView.text, forKey: "postText")
                                    self.didPost?(true, false)
                                    self.dismiss(animated: true) {
                                        
                                        self.showToast(message: "Post added")
                                    }
                                    
                                })
                            
                                //self.showMessage(with: "Post Edited Succesfully")
                            } else {
                                //todo :- error
                                /*UIView.animate(withDuration: 0.5, delay: 2, options: .curveEaseOut, animations: {
                                 self.didPost?(false)
                                 self.dismiss(animated: true, completion: nil)
                                 }, completion: nil)*/
                                DispatchQueue.main.async {
                                    self.hideActivityIndicator()
                                }
                                overlay.removeFromSuperview()
                                let alert = UIAlertController(title: "OOPS", message: "Failed to posts into Feeds, Try again!", preferredStyle: .actionSheet)
                                alert.view.tintColor = UIColor.GREEN_PRIMARY
                                let discardAction = UIAlertAction(title: "OK", style: .default, handler: { [unowned self] (action) in
                                    
                                })
                                
                                alert.addAction(discardAction)
                                
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
        }
        
        
    }

    func uploadVideos(friendId:String,editPostId:String,content: String ,videoFeed: String ,feedImage: String,eventId:String?, tagging: [[String:String]]?)  {
        
        let spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
             spinner.mode = MBProgressHUDMode.indeterminate
             spinner.label.text = "Posting Feed Data"
        
        var semaphore = DispatchSemaphore (value: 0)
        
        
        var taggingStr = ""
        if let tag = tagging {
            let dict = ["tagging": tag]
            if let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: []) , let string = String(data: jsonData, encoding: .ascii){
                taggingStr = "\(string)"
            }
        }
        var ipAdress = ""
               if AuthService.instance.getIFAddresses().count >= 1 {
                   ipAdress = AuthService.instance.getIFAddresses().description
               }
        
        
        
        
        var parameters = [
            [
                "key": "userId",
                "value": "\(AuthService.instance.userId)",
                "type": "text"
            ],
            [
                "key": "apiKey",
                "value": API_KEY,
                "type": "text"
            ],
            [
                "key": "editPostId",
                "value": editPostId,
                "type": "text"
            ],
            [
                "key": "eventPost",
                "value": "1",
                "type": "text"
            ],
            [
                "key": "eventId",
                "value": "\(eventId ?? "")",
                "type": "text"
            ],
            [
                "key": "timeStamp",
                "value": "\((Int(Date().timeIntervalSince1970)))",
                "type": "text"
            ],
            [
                "key": "content",
                "value": content,
                "type": "text"
            ],
            [
                "key": "imageCount",
                "value": "0",
                "type": "text"
            ],
            [
                "key": "tagged",
                "value": taggingStr,
                "type": "text"
            ],
            [
                "key": "device",
                "value": "\(MOBILE_DEVICE)",
                "type": "text"
            ],
            [
                "key": "ipAddress",
                "value": "\(ipAdress)".replacingOccurrences(of: "+", with: "%2B"),
                "type": "text"
            ],
            [
                "key": "multiImage",
                "value": "",
                "type": "text"
            ]] as [[String : Any]]
        
        var imageObj = [[String : Any]]()
        var videosCount = 0;
        for imageData in videosToData {
        var populatedDictionary = ["key": "feedVideoContent\(videosCount)", "type": "file", "src": imageData]
            imageObj.append(populatedDictionary)
                     videosCount += 1
                           }
       parameters = parameters + imageObj
        
        let boundary = "Boundary-\(UUID().uuidString)"
        var body = ""
        var error: Error? = nil
        for param in parameters {
            if param["disabled"] == nil {
                let paramName = param["key"]!
                body += "--\(boundary)\r\n"
                body += "Content-Disposition:form-data; name=\"\(paramName)\""
                let paramType = param["type"] as! String
                if paramType == "text" {
                    let paramValue = param["value"] as! String
                    body += "\r\n\r\n\(paramValue)\r\n"
                } else {
                    let paramSrc = param["src"] as! String
                    let sourceFile = paramSrc.replacingOccurrences(of: "file://", with: "")
                         let fileData = try! NSData(contentsOfFile:sourceFile, options:[]) as Data
                    var backToString = String(data: fileData, encoding: String.Encoding.utf8) as String?
                    let stringValue = String(decoding: fileData, as: UTF8.self)

                         let fileContent = String(data: fileData, encoding: .utf8)
                         body += "; filename=\"\(paramSrc)\"\r\n"
                           + "Content-Type: \"content-type header\"\r\n\r\n\(fileContent)\r\n"
                    
                }
            }
        }
        body += "--\(boundary)--\r\n";
        let postData = body.data(using: .utf8)
        
        var request = URLRequest(url: URL(string: "https://myscrap.com/android/msUserPostInsertV2")!,timeoutInterval: Double.infinity)
        request.addValue("ci_session=0524dca71ee9fc9322ed322b347bff1092160c47", forHTTPHeaderField: "Cookie")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = postData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                                   self.hideActivityIndicator()
                            }
                print(String(describing: error))
                return
            }
            DispatchQueue.main.async {
                                              self.hideActivityIndicator()
                                       }
            print(String(data: data, encoding: .utf8)!)
            semaphore.signal()
        }
        
        task.resume()
        semaphore.wait()
    }
    static func storyBoardReference() -> AddPostV2Controller? {
        let storyboard = UIStoryboard(name: "POST", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "AddPostV2Controller") as? AddPostV2Controller
    }
    
    deinit {
        print("Add/Edit POST VC DEINITED")
    }
    @objc func deleteImagePressed(_ sender: UIButton){ //<- needs `@objc`
        print("\(sender)")
        self.imagesToPosts.remove(at: sender.tag)
        self.refreshImages()
        self.collectionView.reloadData()
        //        let vc = UIStoryboard(name: StoryBoard.MAIN , bundle: nil).instantiateViewController(withIdentifier: EditProfilePopupVC.id)
        //
        //      //  pushViewController(storyBoard: StoryBoard.MAIN, Identifier: EditProfilePopupVC.id)
        //  self.navigationController?.pushViewController(vc, animated: true)
        //  NotificationCenter.default.post(name: Notification.Name("ReportYourPriceButtonPressed"), object: nil, userInfo: ["code":"0"])
    }
    @objc func deleteVideoPressed(_ sender: UIButton){ //<- needs `@objc`
        print("\(sender)")
        let deletedObj =  self.videosToData[sender.tag]
        self.DeleteFromDKAssetData(abSring: deletedObj)
        self.videosToData.remove(at: sender.tag)
        self.refreshVedioToUploadData()
        
//        isImage = false
//        isVideo = false

        self.collectionView.reloadData()
        //        let vc = UIStoryboard(name: StoryBoard.MAIN , bundle: nil).instantiateViewController(withIdentifier: EditProfilePopupVC.id)
        //
        //      //  pushViewController(storyBoard: StoryBoard.MAIN, Identifier: EditProfilePopupVC.id)
        //  self.navigationController?.pushViewController(vc, animated: true)
        //  NotificationCenter.default.post(name: Notification.Name("ReportYourPriceButtonPressed"), object: nil, userInfo: ["code":"0"])
                
        self.toggleNewPostBtn()

    }
    /*
    @objc  func uploadVideo()
    {
        var semaphore = DispatchSemaphore (value: 0)

        let parameters = [
            [
                "key": "userId",
                "value": "\(AuthService.instance.userId)",
                "type": "text"
            ],
            [
                "key": "apiKey",
                "value": API_KEY,
                "type": "text"
            ],
          [
            "key": "friendId",
            "value": "0",
            "type": "text"
          ],
          [
            "key": "msgcontent",
            "value": "",
            "type": "text"
          ],
          [
            "key": "eventPost",
            "value": "",
            "type": "text"
          ],
          [
            "key": "timeStamp",
            "value": "",
            "type": "text"
          ],
          [
            "key": "location",
            "value": "",
            "type": "text"
          ],
          [
            "key": "albumId",
            "value": "",
            "type": "text"
          ],
          [
            "key": "device",
            "value": "",
            "type": "text"
          ],
          [
            "key": "ipAddress",
            "value": "",
            "type": "text"
          ],
          [
            "key": "tagged",
            "value": "",
            "type": "text"
          ],
          [
            "key": "multiImage",
            "value": "",
            "type": "text"
          ],
          [
            "key": "feedVideoContent0",
            "src": self.videosToData[0],
            "type": "file"
          ],
          [
            "key": "feedVideoContent1",
            "src": self.videosToData[1],
            "type": "file"
          ],
          [
            "key": "feedVideoContent2",
            "src": self.videosToData[2],
            "type": "file"
          ]
         ] as [[String : Any]]

        let boundary = "Boundary-\(UUID().uuidString)"
        var body = ""
        var error: Error? = nil
        for param in parameters {
          if param["disabled"] == nil {
            let paramName = param["key"]!
            body += "--\(boundary)\r\n"
            body += "Content-Disposition:form-data; name=\"\(paramName)\""
            let paramType = param["type"] as! String
            if paramType == "text" {
              let paramValue = param["value"] as! String
              body += "\r\n\r\n\(paramValue)\r\n"
            } else {
              let paramSrc = param["src"] as! String
                do {
              let fileData = try NSData(contentsOfFile:paramSrc, options:[]) as Data
              let fileContent = String(data: fileData, encoding: .utf8)!
              body += "; filename=\"\(paramSrc)\"\r\n"
                + "Content-Type: \"content-type header\"\r\n\r\n\(fileContent)\r\n"
                } catch {
                    print("Unexpected error: \(error).")
                }
                
            }
          }
        }
        body += "--\(boundary)--\r\n";
        let postData = body.data(using: .utf8)

        var request = URLRequest(url: URL(string: "https://myscrap.com/android/msUserPostInsertV2")!,timeoutInterval: Double.infinity)
        request.addValue("ci_session=e550e3dd4d5dca6236bf9a94dfb728b7bc38b14e", forHTTPHeaderField: "Cookie")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view , animated: true)
            }
            print(String(describing: error))
            return
          }
            DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view , animated: true)
            }
          print(String(data: data, encoding: .utf8)!)
          semaphore.signal()
        }

        task.resume()
        semaphore.wait()
    } */
}
extension AddPostV2Controller:EditProfileDelegate
{
    func didUpdateProfile() {
        
    }
    
    
}
extension AddPostV2Controller: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if let touchedView = touch.view{
            if touchedView.isDescendant(of: mentionsTableView){
                return false
            }
        }
        return true
    }
}
extension AddPostV2Controller: MentionsManagerDelegate{
    func textviewsCondition() {
        togglePostBtn()
        if textView.text.contains("@") {
            let mentionLists = [Mention]()
            if mentionLists.count != 0 {
                mentionsTableView.isHidden = false
            } else {
//                Mention.getMentions { (receivedMentions) in
//                    DispatchQueue.main.async {
//                        if let mentions = receivedMentions {
//                            self.dataManager?.mentions = mentions
//                            self.mentionsTableView.isHidden = false
//                            //dump(self.dataManager?.mentions)
//                        }
//                    }
//                }

                self.getMembersValues(pageLoad: (self.dataManager?.mentions.count)!, searchText: self.typeString, orderBy: "",completion: { (isSuccess) in
                    print("Got DS values :\(self.dataManager!.mentions.count)")
                    
                    if isSuccess {
                        self.mentionsTableView.isHidden = false
                    }
                    else {
                        self.mentionsTableView.isHidden = true
                    }
                })
            }
        }
    }
    func showMentionsListWithString(_ mentionsString: String) {
        self.typeString = mentionsString

        mentionsTableView.isHidden = false
        dataManager?.filter(mentionsString)
    }
    
    func hideMentionsList() {
        mentionsTableView.isHidden = true
        dataManager?.filter(nil)
    }
    
    func didHandleMentionOnReturn() -> Bool {
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        mentionsTableView.isHidden = true
        togglePostBtn()
    }
    
    
    fileprivate func removeDuplicates(_ arrayOfDicts: [[String: String]]) -> [[String: String]] {
        var removeDuplicates = [[String: String]]()
        var arrOfDict = [String]()
        for dict in arrayOfDicts {
            if let name = dict["taggedId"], !arrOfDict.contains(name) {
                removeDuplicates.append(dict)
                arrOfDict.append(name)
            }
        }
        return removeDuplicates
    }
    
}
extension AddPostV2Controller {
    func keyboardObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UITextInputMode.currentInputModeDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    func removeKeyboardObserver(){
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardHeight = value.cgRectValue.height
        self.bottomConstraint.constant = keyboardHeight
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
    }
    @objc private func keyboardWillHide(_ notification: Notification){
        self.bottomConstraint.constant = 0
        UIView.animate(withDuration: 0.1) {
            self.view.layoutIfNeeded()
        }
    }
}
extension AddPostV2Controller: mentionTableViewDelegate {
    func passMentioned(tagname: String, tagId: String) {
        print("name : \(tagname), id :\(tagId)")
        
        toggleTagButton() // HAJA
        mentionsTableView.isHidden = true
        tagArray.append(["tagId": tagId, "tagName": tagname])
        if textView.text != "" {
            
            /*let attbString = NSMutableAttributedString(string: " " + tagname, attributes: [NSAttributedStringKey.foregroundColor : UIColor.MyScrapGreen, NSAttributedStringKey.font : UIFont(name:"HelveticaNeue", size: 17.0)])
             
             let textViewAttrib = NSAttributedString(string: textView.text)
             let combinedAttrib = NSMutableAttributedString()
             combinedAttrib.append(textViewAttrib)
             combinedAttrib.append(attbString)
             textView.attributedText = combinedAttrib*/
            let attbString = NSMutableAttributedString(string: textView.text + " " + tagname, attributes: [NSAttributedString.Key.foregroundColor : UIColor.MyScrapGreen, NSAttributedString.Key.font : UIFont(name:"HelveticaNeue", size: 17.0)])
            textView.attributedText = attbString
        } else {
            self.textView.attributedText = NSAttributedString(string: tagname, attributes: [NSAttributedString.Key.foregroundColor : UIColor.MyScrapGreen, NSAttributedString.Key.font : UIFont(name:"HelveticaNeue", size: 17.0)])
        }
        togglePostBtn()
    }
}
class Networking {
    static let sharedInstance = Networking()
    public var sessionManager: Alamofire.SessionManager // most of your web service clients will call through sessionManager
    public var backgroundSessionManager: Alamofire.SessionManager // your web services you intend to keep running when the system backgrounds your app will use this
    private init() {
        self.sessionManager = Alamofire.SessionManager(configuration: URLSessionConfiguration.default)
        self.backgroundSessionManager = Alamofire.SessionManager(configuration: URLSessionConfiguration.background(withIdentifier: "com.myscrap.app.backgroundtransfer"))
    }
}
extension AddPostV2Controller : AlartMessagePopupViewDelegate
{
    func openEditProfileView() {
     self.gotoEditProfilePopup()
    }
    
    
}

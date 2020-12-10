//
//  CompanyUpdatesVC.swift
//  myscrap
//
//  Created by MyScrap on 23/04/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import StoreKit
import Photos
import UserNotifications
import MapKit
import CoreLocation
import MessageUI
import SafariServices

class CompanyUpdatesVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var callBtnImg: UIButton!
    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var directBtnImg: UIButton!
    @IBOutlet weak var directionBtn: UIButton!
    @IBOutlet weak var emailBtnImg: UIButton!
    @IBOutlet weak var emailBtn: UIButton!
    @IBOutlet weak var webBtnImg: UIButton!
    @IBOutlet weak var webBtn: UIButton!
    @IBOutlet weak var cvHeightConstraint: NSLayoutConstraint!
    
    var phone = ""
    var email = ""
    var web = ""
    var company_lat = 0.0
    var company_long = 0.0
    
    var locationManager:CLLocationManager!
    
    let activityIndicator: UIActivityIndicatorView = {
        let av = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        av.translatesAutoresizingMaskIntoConstraints = false
        return av
    }()
    
    lazy var refreshControl : UIRefreshControl = {
        let rc = UIRefreshControl(frame: .zero)
        rc.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return rc
    }()
    
    var feedsManualCount = 0
    fileprivate var loadMore = true
    
    fileprivate var datasource = [FeedV2Item]()
    
    fileprivate let service = CompanyUpdatedService()
    
  var index = IndexPath()
  var visibleCellIndex = IndexPath()
  var muteVideo = true

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
    
        NotificationCenter.default.addObserver(self, selector: #selector(self.pauseVisibleVideos), name: Notification.Name("SharedOpen"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.pauseVisibleVideos), name: Notification.Name("DeletedVideo"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.pauseVisibleVideos), name: Notification.Name("PauseAllVideos"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.pauseVisibleVideos), name: Notification.Name("PauseAllProfileVideos"), object: nil)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(self.enableScroll), name: Notification.Name("EnableScroll"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.disableScroll), name: Notification.Name("DisableScroll"), object: nil)
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        NotificationCenter.default.addObserver(self, selector: #selector(self.scrollViewDidEndScrolling), name: Notification.Name("SharedClosed"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.scrollViewDidEndScrolling), name: Notification.Name("PlayVideoFromTab"), object: nil)
        getEmployeeData(pageLoad: 0, completion: { _ in })
        service.delegate = self
        let companyId = UserDefaults.standard.object(forKey: "companyId") as? String
        service.getCompanyDetails(companyId: companyId!)
        
    }
    override func viewWillDisappear(_ animated: Bool) {

        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "SharedClosed"), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "PlayVideoFromTab"), object: nil)


    }
    func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FeedTextCell.Nib, forCellWithReuseIdentifier: FeedTextCell.identifier)
        collectionView.register(FeedImageCell.Nib, forCellWithReuseIdentifier: FeedImageCell.identifier)
        collectionView.register(FeedImageTextCell.Nib, forCellWithReuseIdentifier: FeedImageTextCell.identifier)
        collectionView.register(EmplPortraitVideoCell.Nib, forCellWithReuseIdentifier: EmplPortraitVideoCell.identifier)
        collectionView.register(EmplLandscVideoCell.Nib, forCellWithReuseIdentifier: EmplLandscVideoCell.identifier)
        collectionView.register(EmplPortrVideoTextCell.Nib, forCellWithReuseIdentifier: EmplPortrVideoTextCell.identifier)
        collectionView.register(EmplLandsVideoTextCell.Nib, forCellWithReuseIdentifier: EmplLandsVideoTextCell.identifier)
        collectionView.register(EmptyStateView.nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: EmptyStateView.id)
        collectionView.register(EmplPortrVideoTextCell.Nib, forCellWithReuseIdentifier: EmplPortrVideoTextCell.identifier)

        collectionView.register(EmplPortraitVideoCell.Nib, forCellWithReuseIdentifier: EmplPortraitVideoCell.identifier)
              collectionView.register(LandScapVideoTextCell.Nib, forCellWithReuseIdentifier: LandScapVideoTextCell.identifier)
              collectionView.register(LandScapVideoCell.Nib, forCellWithReuseIdentifier: LandScapVideoCell.identifier)
              collectionView.register(EmplLandsVideoTextCell.Nib, forCellWithReuseIdentifier: EmplLandsVideoTextCell.identifier)
              collectionView.register(AdvertismentCell.Nib, forCellWithReuseIdentifier: AdvertismentCell.identifier)
              collectionView.register(MarketScrollCell.Nib, forCellWithReuseIdentifier: MarketScrollCell.identifier)
              collectionView.register(NewUserScrollCell.Nib, forCellWithReuseIdentifier: NewUserScrollCell.identifier)
              collectionView.register(NewsScrollCell.Nib, forCellWithReuseIdentifier: NewsScrollCell.identifier)
              collectionView.register(CompanyOfMonthCell.Nib, forCellWithReuseIdentifier: CompanyOfMonthCell.identifier)
              collectionView.register(PersonOfWeek.Nib, forCellWithReuseIdentifier: PersonOfWeek.identifier)
              collectionView.register(PersonWeekScrollCell.Nib, forCellWithReuseIdentifier: PersonWeekScrollCell.identifier)
              collectionView.register(VotingScrollCell.Nib, forCellWithReuseIdentifier: VotingScrollCell.identifier)
    }
    @objc func pauseVisibleVideos()  {
        
        for videoParentCell in collectionView.visibleCells   {
            
                var indexPathNotVisible = collectionView!.indexPath(for: videoParentCell)
            
            if let videoParentwithoutTextCell = videoParentCell as? EmplPortraitVideoCell
            {
                for videoCell in videoParentwithoutTextCell.videosCollection.visibleCells  as [PortraitVideoCell]    {
                    print("You can stop play the video from here")
                        videoCell.pause()

                }
            }
            if let videoParentTextCell = videoParentCell as? EmplPortrVideoTextCell
            {
                for videoCell in videoParentTextCell.videosCollection.visibleCells  as [PortraitVideoCell]    {
                    print("You can stop play the video from here")
                        videoCell.pause()
                    

                }
            }
            if let videoParentTextCell = videoParentCell as? LandScapVideoCell
            {
                for videoCell in videoParentTextCell.videosCollection.visibleCells  as [LandScapCell]    {
                    print("You can stop play the video from here")
                        videoCell.pause()
                    

                }
            }
            if let videoParentTextCell = videoParentCell as? LandScapVideoTextCell
            {
                for videoCell in videoParentTextCell.videosCollection.visibleCells  as [LandScapCell]    {
                    print("You can stop play the video from here")
                        videoCell.pause()
                    

                }
            }
            }
        
    }
    @objc func scrollViewDidEndScrolling() {
        
        let centerPoint = CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
        let collectionViewCenterPoint = self.view.convert(centerPoint, to: collectionView)

   let muteImg = #imageLiteral(resourceName: "mute-60x60")
   let tintMuteImg = muteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
   
   let unMuteImg = #imageLiteral(resourceName: "unmute-60x60")
   let tintUnmuteImg = unMuteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
var muteVideo : Bool = false
   
        if let indexPath = collectionView.indexPathForItem(at: collectionViewCenterPoint) {
            self.pauseAllVideos(indexPath: indexPath)
            if   let collectionViewCell = collectionView.cellForItem(at: indexPath) as? EmplPortraitVideoCell
            {
                
                let data  = datasource[indexPath.item]

               for videoCell in collectionViewCell.videosCollection.visibleCells  as [PortraitVideoCell]    {
               
              //  videoCell.backgroundColor = .red

                   let muteValue =  UserDefaults.standard.value(forKey: "MuteValue") as? String
                   if muteValue == "1"
                   {
                    muteVideo =  false
                   }
                    else
                   {
                    muteVideo =  true
                   }
                   videoCell.playerView.isMuted = muteVideo
                   if  videoCell.playerView.isMuted {
                       videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
                   } else {
                       videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
                   }
                if data.isReported {
                    videoCell.pause()
                }
                else
                {
                    videoCell.resume()
                   
                }
                      
                self.pauseAllVideos(indexPath: indexPath)
               }
              
            }
          else if   let collectionViewCell = collectionView.cellForItem(at: indexPath) as? EmplPortrVideoTextCell
          {
             for videoCell in collectionViewCell.videosCollection.visibleCells  as [PortraitVideoCell]    {
              //  videoCell.backgroundColor = .red
                let data  = datasource[indexPath.item]
               let muteValue =  UserDefaults.standard.value(forKey: "MuteValue") as? String
               if muteValue == "1"
               {
                muteVideo =  false
               }
                else
               {
                muteVideo =  true
               }
               videoCell.playerView.isMuted = muteVideo
               if  videoCell.playerView.isMuted {
                   videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
               } else {
                   videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
               }

                if data.isReported {
                    videoCell.pause()
                }
                else
                {
                    videoCell.resume()
                    
                }
                self.pauseAllVideos(indexPath: indexPath)
             }
          }
          else if   let collectionViewCell = collectionView.cellForItem(at: indexPath) as? LandScapVideoCell
          {
             for videoCell in collectionViewCell.videosCollection.visibleCells  as [LandScapCell]    {
              //  videoCell.backgroundColor = .red
                let data  = datasource[indexPath.item]
               let muteValue =  UserDefaults.standard.value(forKey: "MuteValue") as? String
               if muteValue == "1"
               {
                muteVideo =  false
               }
                else
               {
                muteVideo =  true
               }
               videoCell.playerView.isMuted = muteVideo
               if  videoCell.playerView.isMuted {
                   videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
               } else {
                   videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
               }

                if data.isReported {
                    videoCell.pause()
                }
                else
                {
                    videoCell.resume()
                    
                }
                self.pauseAllVideos(indexPath: indexPath)
             }
          }
          else if   let collectionViewCell = collectionView.cellForItem(at: indexPath) as? LandScapVideoTextCell
          {
             for videoCell in collectionViewCell.videosCollection.visibleCells  as [LandScapCell]    {
              //  videoCell.backgroundColor = .red
                let data  = datasource[indexPath.item]
               let muteValue =  UserDefaults.standard.value(forKey: "MuteValue") as? String
               if muteValue == "1"
               {
                muteVideo =  false
               }
                else
               {
                muteVideo =  true
               }
               videoCell.playerView.isMuted = muteVideo
               if  videoCell.playerView.isMuted {
                   videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
               } else {
                   videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
               }

                if data.isReported {
                    videoCell.pause()
                }
                else
                {
                    videoCell.resume()
                    
                }
                self.pauseAllVideos(indexPath: indexPath)
             }
          }
   }
}
    func pauseAllVideos(indexPath : IndexPath)  {
        
        for videoParentCell in collectionView.visibleCells   {
            
                var indexPathNotVisible = collectionView!.indexPath(for: videoParentCell)
            if indexPath != indexPathNotVisible {
            
            if let videoParentwithoutTextCell = videoParentCell as? EmplPortraitVideoCell
            {
                for videoCell in videoParentwithoutTextCell.videosCollection.visibleCells  as [PortraitVideoCell]    {
                    print("You can stop play the video from here")
                        videoCell.pause()

                }
            }
            if let videoParentTextCell = videoParentCell as? EmplPortrVideoTextCell
            {
                for videoCell in videoParentTextCell.videosCollection.visibleCells  as [PortraitVideoCell]    {
                    print("You can stop play the video from here")
                        videoCell.pause()
                    

                }
            }
                if let videoParentTextCell = videoParentCell as? LandScapVideoCell
                {
                    for videoCell in videoParentTextCell.videosCollection.visibleCells  as [LandScapCell]    {
                        print("You can stop play the video from here")
                            videoCell.pause()
                        

                    }
                }
                if let videoParentTextCell = videoParentCell as? LandScapVideoTextCell
                {
                    for videoCell in videoParentTextCell.videosCollection.visibleCells  as [LandScapCell]    {
                        print("You can stop play the video from here")
                            videoCell.pause()
                        

                    }
                }
            }
        }
    }
    @objc
       func handleRefresh(){
           if activityIndicator.isAnimating{
               activityIndicator.stopAnimating()
           }
        getEmployeeData(pageLoad: 0, completion: { _ in })
       }
    
    func getEmployeeData(pageLoad: Int, completion: @escaping (Bool) -> ()) {
        let companyId = UserDefaults.standard.object(forKey: "companyId") as? String
        service.getEmployeeFeeds(companyId: companyId!, pageLoad: "\(pageLoad)") { (result) in
            DispatchQueue.main.async {
                if self.refreshControl.isRefreshing { self.refreshControl.endRefreshing() }
                
                switch result{
                case .Error(let _):
                    completion(false)
                case .Success(let data):
                    print("Feed data count",self.datasource.count)
                    self.feedsManualCount = self.datasource.count
                    let newData = data
                    //newData.removeDuplicates()
                    self.datasource = newData
                    self.collectionView.reloadData()
                    self.collectionView.performBatchUpdates(nil, completion: {
                        (result) in
                        // ready
                        self.pauseVisibleVideos()
                    })
                    self.loadMore = true
                    print("&&&&&&&&&&& DATA : \(newData.count)")
                    DispatchQueue.main.async {
                        self.hideActivityIndicator()
                    }
                    completion(true)
                }
            }
        }
    }
    
    private func getFeedsMore(pageLoad: Int, completion: @escaping (Bool) -> () ){
        let companyId = UserDefaults.standard.object(forKey: "companyId") as? String
        service.getEmployeeFeeds(companyId: companyId!, pageLoad: "\(pageLoad)") { (result) in
            DispatchQueue.main.async {
                
                switch result{
                case .Error(let _):
                    completion(false)
                case .Success(let data):
                    print("Feed data count",self.datasource.count)
                    self.feedsManualCount = self.datasource.count
                    var newData = self.datasource + data
                    //newData.removeDuplicates()
                    self.datasource = newData
                    self.collectionView.reloadData()
                    self.collectionView.performBatchUpdates(nil, completion: {
                        (result) in
                        // ready
                        self.pauseVisibleVideos()
                    })
                    print("&&&&&&&&&&& DATA : \(newData.count)")
                    completion(true)
                }
            }
        }
    }
    
    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !datasource.isEmpty{
            let currentOffset = scrollView.contentOffset.y
            let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
            let deltaOffset = maximumOffset - currentOffset
            if deltaOffset <= 0 {
                if loadMore{
                    
                    loadMore = false
                    self.getFeedsMore(pageLoad: datasource.count, completion: { _ in })
                }
            }
        }
        self.scrollViewDidEndScrolling()
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
        
        if web != "no" || web != "" {
            if web.contains("http://") || web.contains("https://") {
                let url = URL(string:web)!
                print(" website label : \(url), \(web)")
                let svc = SFSafariViewController(url: url)
                present(svc, animated: true, completion: nil)
            } else {
                let url = URL(string: "http://" + web)!
                print(" website label : \(url), \(web)")
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
extension CompanyUpdatesVC : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if datasource.count != 0 {
            return datasource.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data  = datasource[indexPath.item]
        print("Initialized cell type : \(data.cellType)")
        
        switch data.cellType{
        /*case .feedNewUserCell:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedNewUserCell.identifier, for: indexPath) as? FeedNewUserCell else { return UICollectionViewCell()}
            cell.delegate = self
            cell.item = data
            print("Cell item in wall : \(cell.item)")
            return cell*/
        case .feedTextCell:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedTextCell.identifier, for: indexPath) as? FeedTextCell else { return UICollectionViewCell()}
            cell.updatedDelegate = self
            cell.newItem = data
            cell.editButton.isHidden = true
         /*   if data.rank == "MOD" {
                cell.profileTypeView.label.text = data.rank
                cell.profileTypeView.label.textColor = UIColor.WHITE_ALPHA
                cell.profileTypeView.backgroundColor = UIColor.MOD_COLOR
                cell.profileTypeView.isHidden = false
            } else if data.rank == "NEW" {
                cell.profileTypeView.label.text = data.rank
                cell.profileTypeView.label.textColor = UIColor.WHITE_ALPHA
                cell.profileTypeView.backgroundColor = UIColor.NEW_COLOR
                cell.profileTypeView.isHidden = false
            } else if data.rank == "ADMIN" {
                cell.profileTypeView.label.text = data.rank
                cell.profileTypeView.label.textColor = UIColor.WHITE_ALPHA
                cell.profileTypeView.backgroundColor = UIColor.GREEN_PRIMARY
                cell.profileTypeView.isHidden = false
            } else if data.rank == "NoRank"{
                //cell.profileTypeView.label.text = "NoRank"
                //cell.profileTypeView.label.textColor = UIColor.WHITE_ALPHA
                //cell.profileTypeView.backgroundColor = UIColor.GREEN_PRIMARY
                cell.profileTypeView.isHidden = true
            }
            else {
                cell.profileTypeView.label.text = data.rank
                cell.profileTypeView.label.textColor = UIColor.WHITE_ALPHA
                cell.profileTypeView.backgroundColor = UIColor.GREEN_PRIMARY
                cell.profileTypeView.isHidden = false
            }*/
            return cell
        case .feedImageCell:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedImageCell.identifier, for: indexPath) as? FeedImageCell else { return UICollectionViewCell()}
            cell.updatedDelegate = self
            cell.newItem = data
            cell.refreshTable()
            cell.editButton.isHidden = true
           /* if data.rank == "MOD" {
                cell.profileTypeView.label.text = data.rank
                cell.profileTypeView.label.textColor = UIColor.WHITE_ALPHA
                cell.profileTypeView.backgroundColor = UIColor.MOD_COLOR
                cell.profileTypeView.isHidden = false
            } else if data.rank == "NEW" {
                cell.profileTypeView.label.text = data.rank
                cell.profileTypeView.label.textColor = UIColor.WHITE_ALPHA
                cell.profileTypeView.backgroundColor = UIColor.NEW_COLOR
                cell.profileTypeView.isHidden = false
            } else if data.rank == "ADMIN" {
                cell.profileTypeView.label.text = data.rank
                cell.profileTypeView.label.textColor = UIColor.WHITE_ALPHA
                cell.profileTypeView.backgroundColor = UIColor.GREEN_PRIMARY
                cell.profileTypeView.isHidden = false
            } else if data.rank == "NoRank"{
                //cell.profileTypeView.label.text = "NoRank"
                //cell.profileTypeView.label.textColor = UIColor.WHITE_ALPHA
                //cell.profileTypeView.backgroundColor = UIColor.GREEN_PRIMARY
                cell.profileTypeView.isHidden = true
            }
            else {
                cell.profileTypeView.label.text = data.rank
                cell.profileTypeView.label.textColor = UIColor.WHITE_ALPHA
                cell.profileTypeView.backgroundColor = UIColor.GREEN_PRIMARY
                cell.profileTypeView.isHidden = false
            }*/
            cell.dwnldBtnAction = {
                cell.dwnldBtn.isEnabled = false
                for imageCell in cell.feedImages.visibleCells   {
                   let image = imageCell as! CompanyImageslCell
                    UIImageWriteToSavedPhotosAlbum(image.companyImageView.image!, self, #selector(self.feed_image(_:didFinishSavingWithError:contextInfo:)), nil)
                    cell.dwnldBtn.isEnabled = true
                    }
            }
            cell.offlineBtnAction = {
                self.showToast(message: "No internet connection")
            }
            return cell
        case .feedImageTextCell:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedImageTextCell.identifier, for: indexPath) as? FeedImageTextCell else { return UICollectionViewCell()}
            cell.updatedDelegate = self
            cell.newItem = data
               cell.refreshTable()
            cell.editButton.isHidden = true
            cell.dwnldBtnAction = {
                cell.dwnldBtn.isEnabled = false
                for imageCell in cell.feedImages.visibleCells   {
                   let image = imageCell as! CompanyImageslCell
                    UIImageWriteToSavedPhotosAlbum(image.companyImageView.image!, self, #selector(self.feed_image(_:didFinishSavingWithError:contextInfo:)), nil)
                    cell.dwnldBtn.isEnabled = true
                    }
            }
            cell.offlineBtnAction = {
                self.showToast(message: "No internet connection")
            }
           /* if data.rank == "MOD" {
                cell.profileTypeView.label.text = data.rank
                cell.profileTypeView.label.textColor = UIColor.WHITE_ALPHA
                cell.profileTypeView.backgroundColor = UIColor.MOD_COLOR
                cell.profileTypeView.isHidden = false
            } else if data.rank == "NEW" {
                cell.profileTypeView.label.text = data.rank
                cell.profileTypeView.label.textColor = UIColor.WHITE_ALPHA
                cell.profileTypeView.backgroundColor = UIColor.NEW_COLOR
                cell.profileTypeView.isHidden = false
            } else if data.rank == "ADMIN" {
                cell.profileTypeView.label.text = data.rank
                cell.profileTypeView.label.textColor = UIColor.WHITE_ALPHA
                cell.profileTypeView.backgroundColor = UIColor.GREEN_PRIMARY
                cell.profileTypeView.isHidden = false
            } else if data.rank == "NoRank"{
                //cell.profileTypeView.label.text = "NoRank"
                //cell.profileTypeView.label.textColor = UIColor.WHITE_ALPHA
                //cell.profileTypeView.backgroundColor = UIColor.GREEN_PRIMARY
                cell.profileTypeView.isHidden = true
            }
            else {
                cell.profileTypeView.label.text = data.rank
                cell.profileTypeView.label.textColor = UIColor.WHITE_ALPHA
                cell.profileTypeView.backgroundColor = UIColor.GREEN_PRIMARY
                cell.profileTypeView.isHidden = false
            }*/
            return cell
        case .feedPortrVideoCell:
                       guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmplPortraitVideoCell.identifier, for: indexPath) as? EmplPortraitVideoCell else { return UICollectionViewCell()}
                       cell.updatedDelegate = self
                       cell.newItem = data
                      self.visibleCellIndex = indexPath
            cell.delegateVideoChange = self
            cell.editButton.isHidden = true
                       cell.refreshTable()
            cell.dwnldBtnAction = {
    cell.dwnldBtn.isEnabled = false
   for imageCell in cell.videosCollection.visibleCells   {
      let videoCell = imageCell as! PortraitVideoCell
       self.downloadVideo(path: videoCell.newVedio!.video)
       cell.dwnldBtn.isEnabled = true
       }
 
}
                       /*let videoTap = UITapGestureRecognizer(target: self, action: #selector(videoViewTapped(tapGesture:)))
                        videoTap.numberOfTapsRequired = 1
                        cell.thumbnailImg.isUserInteractionEnabled = true
                        cell.thumbnailImg.addGestureRecognizer(videoTap)
                        cell.thumbnailImg.tag = indexPath.row*/
                   //    self.visibleCellIndex = indexPath
                       //cell.player.isMuted = muteVideo
//                           cell.muteBtnAction = {
//                               self.index = indexPath
//                               self.updateMuteBtn()
//                           }
//                           cell.playBtnAction = {
//                               let urlString = data.videoUrl
//                               let videoURL = URL(string: urlString)
//                               let player = AVPlayer(url: videoURL!)
//                               let playerViewController = AVPlayerViewController()
//                               playerViewController.player = player
//                               self.present(playerViewController, animated: true) {
//                                   playerViewController.player!.play()
//                               }
//                           }
 
//                           cell.offlineBtnAction = {
//                               self.showToast(message: "No internet connection")
//                           }
                       return cell
                   case .feedLandsVideoCell:
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LandScapVideoCell.identifier, for: indexPath) as? LandScapVideoCell else { return UICollectionViewCell()}
                    cell.updatedDelegate = self
                    cell.newItem = data
                    cell.delegateVideoChange = self
                    cell.editButton.isHidden = true
                    cell.refreshTable()
                    /*let videoTap = UITapGestureRecognizer(target: self, action: #selector(videoViewTapped(tapGesture:)))
                     videoTap.numberOfTapsRequired = 1
                     cell.thumbnailImg.isUserInteractionEnabled = true
                     cell.thumbnailImg.addGestureRecognizer(videoTap)
                     cell.thumbnailImg.tag = indexPath.row*/
                    self.visibleCellIndex = indexPath
                    //cell.player.isMuted = muteVideo
                    cell.muteBtnAction = {
//                            self.index = indexPath
//                            self.updateMuteBtn()
                    }
                    cell.playBtnAction = {
                        let urlString = data.videoUrl
                        let videoURL = URL(string: urlString)
                        let player = AVPlayer(url: videoURL!)
                        let playerViewController = AVPlayerViewController()
                        playerViewController.player = player
                        self.present(playerViewController, animated: true) {
                            playerViewController.player!.play()
                        }
                    }
                    cell.dwnldBtnAction = {
                        cell.dwnldBtn.isEnabled = false
                       for imageCell in cell.videosCollection.visibleCells   {
                          let videoCell = imageCell as! LandScapCell
                           self.downloadVideo(path: videoCell.newVedio!.video)
                           cell.dwnldBtn.isEnabled = true
                           cell.dwnldBtn.isEnabled = true
                           }
                     
                    }
                    cell.offlineBtnAction = {
                        self.showToast(message: "No internet connection")
                    }
                      cell.layoutIfNeeded()
                    return cell
                   case .feedPortrVideoTextCell:
                       guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmplPortrVideoTextCell.identifier, for: indexPath) as? EmplPortrVideoTextCell else { return UICollectionViewCell()}
                       cell.updatedDelegate = self
                    cell.delegateVideoChange = self
                       cell.newItem = data
                    cell.editButton.isHidden = true
                    self.visibleCellIndex = indexPath

                       cell.refreshTable()
                    cell.dwnldBtnAction = {
            cell.dwnldBtn.isEnabled = false
           for imageCell in cell.videosCollection.visibleCells   {
              let videoCell = imageCell as! PortraitVideoCell
               self.downloadVideo(path: videoCell.newVedio!.video)
               cell.dwnldBtn.isEnabled = true
               }
         
        }
                       /*let videoTap = UITapGestureRecognizer(target: self, action: #selector(videoViewTapped(tapGesture:)))
                        videoTap.numberOfTapsRequired = 1
                        cell.thumbnailImg.isUserInteractionEnabled = true
                        cell.thumbnailImg.addGestureRecognizer(videoTap)
                        cell.thumbnailImg.tag = indexPath.row*/
//                           self.visibleCellIndex = indexPath
//                           //cell.player.isMuted = muteVideo
//                           cell.muteBtnAction = {
//                               self.index = indexPath
//                               self.updateMuteBtn()
//                           }
//                           cell.playBtnAction = {
//                               let urlString = data.videoUrl
//                               let videoURL = URL(string: urlString)
//                               let player = AVPlayer(url: videoURL!)
//                               let playerViewController = AVPlayerViewController()
//                               playerViewController.player = player
//                               self.present(playerViewController, animated: true) {
//                                   playerViewController.player!.play()
//                               }
//                           }
//                           cell.dwnldBtnAction = {
//                               cell.dwnldBtn.isEnabled = false
//                               self.downloadVideo(path: data.downloadVideoUrl)
//                               cell.dwnldBtn.isEnabled = true
//                           }
//                           cell.offlineBtnAction = {
//                               self.showToast(message: "No internet connection")
//                           }
                       return cell
                   case .feedLandsVideoTextCell:
                    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LandScapVideoTextCell.identifier, for: indexPath) as? LandScapVideoTextCell else { return UICollectionViewCell()}
                    cell.updatedDelegate = self
                    cell.newItem = data
                    cell.editButton.isHidden = true
                    cell.delegateVideoChange = self
                    cell.refreshTable()

                  
                    /*let videoTap = UITapGestureRecognizer(target: self, action: #selector(videoViewTapped(tapGesture:)))
                     videoTap.numberOfTapsRequired = 1
                     cell.thumbnailImg.isUserInteractionEnabled = true
                     cell.thumbnailImg.addGestureRecognizer(videoTap)
                     cell.thumbnailImg.tag = indexPath.row*/
                    self.visibleCellIndex = indexPath
                    //cell.player.isMuted = muteVideo
                    cell.muteBtnAction = {
//                            self.index = indexPath
//                            self.updateMuteBtn()
                    }
                    cell.playBtnAction = {
                        let urlString = data.videoUrl
                        let videoURL = URL(string: urlString)
                        let player = AVPlayer(url: videoURL!)
                        let playerViewController = AVPlayerViewController()
                        playerViewController.player = player
                        self.present(playerViewController, animated: true) {
                            playerViewController.player!.play()
                        }
                    }
                    cell.dwnldBtnAction = {
                        cell.dwnldBtn.isEnabled = false
                       for imageCell in cell.videosCollection.visibleCells   {
                          let videoCell = imageCell as! LandScapCell
                           self.downloadVideo(path: videoCell.newVedio!.video)
                           cell.dwnldBtn.isEnabled = true
                           }
                     
                    }
                    cell.offlineBtnAction = {
                        self.showToast(message: "No internet connection")
                    }
                    cell.layoutSubviews()
                       cell.layoutIfNeeded()
                    return cell
        default:
            return UICollectionViewCell()
    }
    }
    
    func downloadVideo(path : String) {
           self.showMessage(with: "Download begins!")
           let videoImageUrl = path
           let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
           let filePath="\(documentsPath)/MSVIDEO.mp4"
           DispatchQueue.global(qos: .background).async {
               if let url = URL(string: videoImageUrl),
                   let urlData = NSData(contentsOf: url) {
                  
                   DispatchQueue.main.async {
                       urlData.write(toFile: filePath, atomically: true)
                       PHPhotoLibrary.shared().performChanges({
                           PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(fileURLWithPath: filePath))
                       }) { completed, error in
                           if completed {
                               
                               DispatchQueue.main.async {
                                   //Triggering the videoDownloadNotify method.
                                   NotificationCenter.default.post(name: .videoDownloaded, object: nil)
                               }
                           } else {
                               if let dwnldError = error {
                                   DispatchQueue.main.async {
                                       print("Download Failed : \(dwnldError.localizedDescription)")
                                       self.showMessage(with: "Failed to download the video")
                                   }
                                   
                               }
                               
                           }
                       }
                   }
               }
           }
       }
    
    func updateMuteBtn() {
        if let cell = collectionView.cellForItem(at: index) as? EmplPortraitVideoCell {
            
            let muteImg = #imageLiteral(resourceName: "mute-60x60")
            let tintMuteImg = muteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            
            let unMuteImg = #imageLiteral(resourceName: "unmute-60x60")
            let tintUnmuteImg = unMuteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            
            if muteVideo {
                muteVideo = false
                cell.player.isMuted = false
                cell.muteBtn.setImage(tintUnmuteImg, for: .normal)
            } else {
                muteVideo = true
                cell.player.isMuted = true
                cell.muteBtn.setImage(tintMuteImg, for: .normal)
            }
        }
        if let cell = collectionView.cellForItem(at: index) as? EmplLandscVideoCell {
            let muteImg = #imageLiteral(resourceName: "mute-60x60")
            let tintMuteImg = muteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            
            let unMuteImg = #imageLiteral(resourceName: "unmute-60x60")
            let tintUnmuteImg = unMuteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            
            if muteVideo {
                muteVideo = false
                cell.player.isMuted = false
                cell.muteBtn.setImage(tintUnmuteImg, for: .normal)
            } else {
                muteVideo = true
                cell.player.isMuted = true
                cell.muteBtn.setImage(tintMuteImg, for: .normal)
            }
        }
        if let cell = collectionView.cellForItem(at: index) as? EmplPortrVideoTextCell {
            let muteImg = #imageLiteral(resourceName: "mute-60x60")
            let tintMuteImg = muteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            
            let unMuteImg = #imageLiteral(resourceName: "unmute-60x60")
            let tintUnmuteImg = unMuteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            
            if muteVideo {
                muteVideo = false
                cell.player.isMuted = false
                cell.muteBtn.setImage(tintUnmuteImg, for: .normal)
            } else {
                muteVideo = true
                cell.player.isMuted = true
                cell.muteBtn.setImage(tintMuteImg, for: .normal)
            }
        }
        if let cell = collectionView.cellForItem(at: index) as? EmplLandsVideoTextCell {
            let muteImg = #imageLiteral(resourceName: "mute-60x60")
            let tintMuteImg = muteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            
            let unMuteImg = #imageLiteral(resourceName: "unmute-60x60")
            let tintUnmuteImg = unMuteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            
            if muteVideo {
                muteVideo = false
                cell.player.isMuted = false
                cell.muteBtn.setImage(tintUnmuteImg, for: .normal)
            } else {
                muteVideo = true
                cell.player.isMuted = true
                cell.muteBtn.setImage(tintMuteImg, for: .normal)
            }
        }
    }
    
    @objc func videoDownloadNotify(_ notification: Notification){
        print("Video saved!")
        
        //self.showMessage(with: "Video Downloaded")
        
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent() // Содержимое уведомления
        let userActions = "User Actions"
        
        content.title = "MyScrap"
        content.body = "Video downloaded to the Gallery"
        content.sound = UNNotificationSound.default
        content.badge = 1
        content.categoryIdentifier = userActions
        
        
        let identifier = "Local Notification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: nil)
        
        center.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
    }
    
    @objc func feed_image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: EmptyStateView.id, for: indexPath) as! EmptyStateView
        cell.textLbl.text = "No Social Activity"
        cell.imageView.image = #imageLiteral(resourceName: "emptysocialactivity")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let bounds = UIScreen.main.bounds
        let width = view.safeAreaLayoutGuide.layoutFrame.width
        print("Width of cell : \(width)")
        //let width = view.frame.width
        let item = datasource[indexPath.item]
        print("Get the raw values",item.cellType.rawValue)
        var height : CGFloat = 0
        //#8
        switch item.cellType{
        case .feedTextCell:
            height = FeedsHeight.heightforFeedTextCellV2(item: item , labelWidth: width - 16)
            return CGSize(width: width , height: height)
        case .feedImageCell:
            height = FeedsHeight.heightForImageCellV2(item: item, width: width)
            return CGSize(width: width, height: height)
        case .feedImageTextCell:
            height = FeedsHeight.heightForImageTextCellV2(item: item, width: width, labelWidth: width - 16)
            print("Feed image text cell width : \(width)")
            return CGSize(width: width, height: height)
        case .feedVideoCell:
            return CGSize(width: 0, height: 0)
        case .feedVideoTextCell:
            return CGSize(width: 0, height: 0)
        case .ads:
            return CGSize(width: 0, height: 0)
        case .market:
            return CGSize(width: 0, height: 0)
        case .userFeedTextCell:
            return CGSize(width: 0, height: 0)
        case .userFeedImageCell:
            return CGSize(width: 0, height: 0)
        case .userFeedImageTextCell:
            return CGSize(width: 0, height: 0)
        case .newUser:
            return CGSize(width: width, height: 355)
        case .news:
            return CGSize(width: width, height: 355)
        case .companyMonth:
            return CGSize(width: 0, height: 0)
        case .personWeek:
            return CGSize(width: 0, height: 0)
        case .vote:
            return CGSize(width: 0, height: 0)
        case .personWeekScroll:
            return CGSize(width: 0, height: 0)
        case .covidPoll:
            return CGSize(width: 0, height: 0)
        case .feedPortrVideoCell:
            height = FeedsHeight.heightForPortraitVideoCellV2(item: item, width: width)
            return CGSize(width: width, height: height + 20)
        case .feedLandsVideoCell:
            height = FeedsHeight.heightForLandsVideoCellV2(item: item, width: width)
            return CGSize(width: width, height: height + 20)
        case .feedPortrVideoTextCell:
            height = FeedsHeight.heightForPortraitVideoTextCellV2(item: item, width: width, labelWidth: width - 16)
            print("Video Cell height : \(height)")
            return CGSize(width: width, height: height + 15)    //height + 30
        case .feedLandsVideoTextCell:
            height = FeedsHeight.heightForLandsVideoTextCellV2(item: item, width: width, labelWidth: width - 16)
            print("Video Cell height : \(height)")
            return CGSize(width: width, height: height + 15)    //height + 30
        }
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout();
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //let visibleCell = collectionView.dequeReusableCell(forIndexPath: indexPath) as?  FeedVideoTextCell
            //NotificationCenter.default.post(name:.videoCellPlay, object: nil)
            let muteImg = #imageLiteral(resourceName: "mute-60x60")
            let tintMuteImg = muteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            
            let unMuteImg = #imageLiteral(resourceName: "unmute-60x60")
            let tintUnmuteImg = unMuteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
            
            
            if let portrateCell = cell as? EmplPortraitVideoCell {
             
                for videoCell in portrateCell.videosCollection.visibleCells  as! [PortraitVideoCell]    {
                      
                    //cell.player.isMuted = true
                    //if videoCell.player.timeControlStatus == .playing {
                    var muteVideo : Bool = false
                        let muteValue =  UserDefaults.standard.value(forKey: "MuteValue") as? String
                        if muteValue == "1"
                        {
                         muteVideo =  false
                        }
                         else
                        {
                         muteVideo =  true
                        }
                        videoCell.playerView.isMuted = muteVideo
                        if  videoCell.playerView.isMuted {
                            videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
                        } else {
                            videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
                        }
                    let item = datasource[indexPath.item]
                    if item.isReported {
                        videoCell.pause()
                    }
                    else
                    {
                        videoCell.resume()
                    }
                    //}
                }
            }
            else if let portrateCell = cell as? EmplPortrVideoTextCell {
                 
                    for videoCell in portrateCell.videosCollection.visibleCells  as! [PortraitVideoCell]    {
                        
                        //cell.player.isMuted = true
                        //if videoCell.player.timeControlStatus == .playing {
                        var muteVideo : Bool = false

                            let muteValue =  UserDefaults.standard.value(forKey: "MuteValue") as? String
                            if muteValue == "1"
                            {
                             muteVideo =  false
                            }
                             else
                            {
                             muteVideo =  true
                            }
                            videoCell.playerView.isMuted = muteVideo
                            if  videoCell.playerView.isMuted {
                                videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
                            } else {
                                videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
                            }
                        let item = datasource[indexPath.item]
                        if item.isReported {
                            videoCell.pause()
                        }
                        else
                        {
                            videoCell.resume()
                        }                            //}
                    }
                }
            else if let portrateCell = cell as? LandScapVideoCell {
                 
                    for videoCell in portrateCell.videosCollection.visibleCells  as! [LandScapCell]    {
                        
                        //cell.player.isMuted = true
                        //if videoCell.player.timeControlStatus == .playing {
                        var muteVideo : Bool = false

                            let muteValue =  UserDefaults.standard.value(forKey: "MuteValue") as? String
                            if muteValue == "1"
                            {
                             muteVideo =  false
                            }
                             else
                            {
                             muteVideo =  true
                            }
                            videoCell.playerView.isMuted = muteVideo
                            if  videoCell.playerView.isMuted {
                                videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
                            } else {
                                videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
                            }
                        let item = datasource[indexPath.item]
                        if item.isReported {
                            videoCell.pause()
                        }
                        else
                        {
                            videoCell.resume()
                        }                            //}
                    }
                }
            else if let portrateCell = cell as? LandScapVideoTextCell {
                 
                    for videoCell in portrateCell.videosCollection.visibleCells  as! [LandScapCell]    {
                        
                        //cell.player.isMuted = true
                        //if videoCell.player.timeControlStatus == .playing {
                        var muteVideo : Bool = false

                            let muteValue =  UserDefaults.standard.value(forKey: "MuteValue") as? String
                            if muteValue == "1"
                            {
                             muteVideo =  false
                            }
                             else
                            {
                             muteVideo =  true
                            }
                            videoCell.playerView.isMuted = muteVideo
                            if  videoCell.playerView.isMuted {
                                videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
                            } else {
                                videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
                            }
                        let item = datasource[indexPath.item]
                        if item.isReported {
                            videoCell.pause()
                        }
                        else
                        {
                            videoCell.resume()
                        }                            //}
                    }
                }
        cell.layoutSubviews()
        cell.layoutIfNeeded()
 
        
}
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let muteImg = #imageLiteral(resourceName: "mute-60x60")
        let tintMuteImg = muteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        
        let unMuteImg = #imageLiteral(resourceName: "unmute-60x60")
        let tintUnmuteImg = unMuteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        
        if let portrateCell = cell as? EmplPortraitVideoCell {
         
            for videoCell in portrateCell.videosCollection.visibleCells  as! [PortraitVideoCell]    {
              
            //cell.player.isMuted = true
            //if videoCell.player.timeControlStatus == .playing {
                videoCell.playerView.isMuted = true
                if  videoCell.player.isMuted {
                    videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
                } else {
                    videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
                }
                videoCell.pause()
//                videoCell.player.actionAtItemEnd = .pause
//                NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoCell.player.currentItem)
          }
        }
        else if let portrateCell = cell as? EmplPortrVideoTextCell {
             
                for videoCell in portrateCell.videosCollection.visibleCells  as! [PortraitVideoCell]    {
                  
                //cell.player.isMuted = true
                //if videoCell.player.timeControlStatus == .playing {
                    videoCell.playerView.isMuted = true
                    if  videoCell.player.isMuted {
                        videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
                    } else {
                        videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
                    }
                    videoCell.pause()
    //                videoCell.player.actionAtItemEnd = .pause
    //                NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoCell.player.currentItem)
                //}
            }
        }
        else if let portrateCell = cell as? LandScapVideoCell {
             
                for videoCell in portrateCell.videosCollection.visibleCells  as! [LandScapCell]    {
                  
                //cell.player.isMuted = true
                //if videoCell.player.timeControlStatus == .playing {
                    videoCell.playerView.isMuted = true
                    if  videoCell.player.isMuted {
                        videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
                    } else {
                        videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
                    }
                    videoCell.pause()
    //                videoCell.player.actionAtItemEnd = .pause
    //                NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoCell.player.currentItem)
                //}
            }
        }
            else if let portrateCell = cell as? LandScapVideoTextCell {
                 
                    for videoCell in portrateCell.videosCollection.visibleCells  as! [LandScapCell]    {
                      
                    //cell.player.isMuted = true
                    //if videoCell.player.timeControlStatus == .playing {
                        videoCell.playerView.isMuted = true
                        if  videoCell.player.isMuted {
                            videoCell.muteBtn.setImage(tintMuteImg, for: .normal)
                        } else {
                            videoCell.muteBtn.setImage(tintUnmuteImg, for: .normal)
                        }
                        videoCell.pause()
        //                videoCell.player.actionAtItemEnd = .pause
        //                NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: videoCell.player.currentItem)
                    //}
                }
        }
    }
       
       /*func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 1 && datasource.count == 0 {
        return CGSize(width: self.view.frame.width, height: view.frame.height - 300)
        }
        return CGSize.zero
        }
       
       func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
           return 10
       }*/
}
extension CompanyUpdatesVC : UpdatedFeedsDelegate, FriendControllerDelegate {
    func didTapForFriendView(id: String) {
        print("Friend view")
        performFriendView(friendId: id)
    }
    
    //#2#7api after count
    var feedsV2DataSource: [FeedV2Item] {
        get {
            return datasource
        }
        set {
            datasource = newValue
        }
    }
    
    var feedCollectionView: UICollectionView {
        return collectionView
    }
}
extension CompanyUpdatesVC : CompanyUpdatedServiceDelegate {
    func didReceiveCompanyValues(data: [CompanyItems]) {
        DispatchQueue.main.async {
            self.phone = data.last!.phone
            self.email = data.last!.email
            self.web = data.last!.website
            self.company_lat = data.last!.lat
            self.company_long = data.last!.long
            
        }
    }
    
    func DidReceivedError(error: String) {
        print("Error while loading company review")
    }
}
extension CompanyUpdatesVC : PortraitVideoDelegate
{
    func PortraitVideoChanged() {
        self.scrollViewDidEndScrolling()
    }
    
    
}
extension CompanyUpdatesVC : PortraitVideoTextDelegate
{
    func PortraitTextVideoChanged() {
        self.scrollViewDidEndScrolling()
    }
    
    
}
extension CompanyUpdatesVC : LandScapVideoDelegate
{
    func LandScapVideoChanged() {
        self.scrollViewDidEndScrolling()
    }
    
    
}
extension CompanyUpdatesVC : LandScapVideoTextDelegate
{
    func LandScapTextVideoChanged() {
        self.scrollViewDidEndScrolling()
    }
   
}

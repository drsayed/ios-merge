//
//  ViewBioVoteVC.swift
//  myscrap
//
//  Created by MyScrap on 8/5/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit
import SDWebImage
import Reachability

class ViewBioVoteVC: UIViewController , UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var hiddenView: UIView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var designationLbl: UILabel!
    @IBOutlet weak var companyLbl: UILabel!
    @IBOutlet weak var officeLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var countryLbl: UILabel!
    @IBOutlet weak var bioDescLbl: UILabel!
    @IBOutlet weak var awardsDescLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var shareBtn: UIBarButtonItem!
    @IBOutlet weak var bioBorderView: UIView!
    @IBOutlet weak var awardsBorderView: UIView!
    @IBOutlet weak var backToPoll: UIButton!
    @IBOutlet weak var profileNavig: UIButton!
    @IBOutlet weak var bioMoreBtn: UIButton!
    @IBOutlet weak var bioMoreBtnHeight: NSLayoutConstraint!
    @IBOutlet weak var bioLblBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileStackView: UIStackView!
    
    var service = VotingService()
    var pictureUrl = [""]
    
    var voterId = ""
    var userId = ""
    var fromPoll = false
    var selectedIndex = 0
    var bioText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        getBioAPI()
        //setupCollectionView()
        
        
        //profileNavig.titleLabel?.font = UIFont.fontAwesome(ofSize: 20, style: .solid)
        //profileNavig.setTitleColor(UIColor(hex: "#434343"), for: .normal)
        //profileNavig.setTitle(String.fontAwesomeIcon(name: .chevronRight), for: .normal)
        
        profileImgView.layer.cornerRadius = 15
        profileImgView.layer.masksToBounds = true
        profileImgView.clipsToBounds = true
        
        let userImgTap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(friendTap(tapGesture:)))
        //tapGesture.delegate = self
        userImgTap.numberOfTapsRequired = 1
        profileImgView.isUserInteractionEnabled = true
        profileImgView.addGestureRecognizer(userImgTap)
        
        let userNameTap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(friendTap(tapGesture:)))
        userNameTap.numberOfTapsRequired = 1
        nameLbl.isUserInteractionEnabled = true
        nameLbl.addGestureRecognizer(userNameTap)
        
        let desigaTap: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(friendTap(tapGesture:)))
        desigaTap.numberOfTapsRequired = 1
        designationLbl.isUserInteractionEnabled = true
        designationLbl.addGestureRecognizer(desigaTap)
        
        let companyTap: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(friendTap(tapGesture:)))
        companyTap.numberOfTapsRequired = 1
        companyLbl.isUserInteractionEnabled = true
        companyLbl.addGestureRecognizer(companyTap)
        
        let profileStackTap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(friendTap(tapGesture:)))
        //tapGesture.delegate = self
        profileStackTap.numberOfTapsRequired = 1
        profileStackView.isUserInteractionEnabled = true
        profileStackView.addGestureRecognizer(profileStackTap)
        
        bioBorderView.layer.cornerRadius = 5
        bioBorderView.layer.borderWidth = 0.6
        bioBorderView.layer.borderColor = UIColor.darkGray.cgColor
        
        awardsBorderView.layer.cornerRadius = 5
        awardsBorderView.layer.borderWidth = 0.6
        awardsBorderView.layer.borderColor = UIColor.darkGray.cgColor
        //self.showAnimate()
        //self.popupView.clipsToBounds = true
        //self.popupView.layer.cornerRadius = 5
        //self.view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //navigationItem.hidesBackButton = true
        //navigationController?.navigationItem.hidesBackButton = true
        //shareBtn.setTitleTextAttributes([NSAttributedStringKey.font : UIFont.fontAwesome(ofSize: 20, style: .solid)], for: .normal)
        //shareBtn.title = String.fontAwesomeIcon(name: .shareAlt)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        
        if fromPoll {
            backToPoll.setTitle("BACK TO POLL", for: .normal)
        } else {
            backToPoll.setTitle("GO TO POLL", for: .normal)
        }
    }
    
    func getBioAPI(){
        self.spinner.startAnimating()
        print("Voter id : \(voterId)")
        service.getVoterBio(voterId: voterId)
        service.delegate = self
    }
    @IBAction func shareBtnTapped(_ sender: UIBarButtonItem) {
        if voterId != "" {
            let encodedVoterId = voterId.toBase64()
            //let id = Int(listingId)!
            //let firstActivityItem = "Vote for Best Trader"
            let secondActivityItem : NSURL = NSURL(string: "https://myscrap.com/ms/vote/\(encodedVoterId)")!
            //let secondActivityItem : NSURL = NSURL(string: "iOSMyScrapApp://myscrap.com/marketLists/\(id)/userId\(userId)")!
            
            
            let activityViewController : UIActivityViewController = UIActivityViewController(
                activityItems: [ secondActivityItem], applicationActivities: [])
            
            // This lines is for the popover you need to show in iPad
            //activityViewController.popoverPresentationController?.sourceView = (sender as! UIBarButtonItem)
            
            // This line remove the arrow of the popover to show in iPad
            activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.any
            activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
            
            // Anything you want to exclude
            activityViewController.excludedActivityTypes = [
                UIActivity.ActivityType.assignToContact
            ]
            
            self.present(activityViewController, animated: true, completion: nil)
        }
        
    }
    
    @IBAction func backToPollTapped(_ sender: UIButton) {
        if fromPoll {
            navigationController?.popViewController(animated: true)
        } else {
            let vc = VoterPollScreenVC.storyBoardInstance()
            /*if selectedIndex == 0 {
                vc?.oneRB = true
                
            } else if selectedIndex == 1 {
                vc?.twoRB = true
            } else if selectedIndex == 2 {
                vc?.threeRB = true
            } else if selectedIndex == 3 {
                vc?.fourRB = true
            } else if selectedIndex == 4 {
                vc?.fiveRB = true
            } else if selectedIndex == 5 {
                vc?.sixRB = true
            } else if selectedIndex == 6 {
                 vc?.sevenRB = true
            } else if selectedIndex == 7 {
                vc?.eightRB = true
            } else if selectedIndex == 8 {
                vc?.nineRB = true
            } else if selectedIndex == 9 {
                vc?.tenRB = true
            }*/
            //let indexPath = IndexPath(row: selectedIndex, section: 0)
            //vc?.voterId = voterId
            //vc?.selectedIndex = indexPath
            //vc?.navigationItem.title = "Poll"
            self.navigationController?.pushViewController(vc!, animated: true)
            
        }
    }
    @objc func friendTap(tapGesture:UITapGestureRecognizer){
        
        //let userData = marketItem[tapGesture.view!.tag].user_data.last
        //print("Market \n \n Listing Id : \(String(describing: marketItem[tapGesture.view!.tag]._listingId)), User Id : \((userData?.user_id)!)")
        //delegate?.didTapMarketView(listingId: marketItem[tapGesture.view!.tag]._listingId, userId: (userData?.user_id)!)
        performFriendView(friendId: userId)
        
    }
    
    @IBAction func viewProfile(_ sender: UIButton) {
        performFriendView(friendId: userId)
    }
    @IBAction func dismissVC(_ sender: UIButton) {
        //self.removeAnimate()
        navigationController?.popViewController(animated: true)
    }
    @IBAction func bioMoreTapped(_ sender: UIButton) {
        if sender.tag == 0 {
            //Read more tapped
            self.bioDescLbl.numberOfLines = 0
            self.bioDescLbl.text = bioText
            self.bioMoreBtn.setTitle("Show Less..", for: .normal)
            self.bioMoreBtnHeight.constant = 40
            sender.tag = 1
        } else {
            //Show Less tapped
            self.bioDescLbl.numberOfLines = 30
            self.bioDescLbl.text = bioText
            self.bioMoreBtn.setTitle("Read More..", for: .normal)
            self.bioMoreBtnHeight.constant = 40
            sender.tag = 0
        }
    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.0, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.0, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ViewBioImagesCell.Nib, forCellWithReuseIdentifier: ViewBioImagesCell.identifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if pictureUrl != [""]{
            return pictureUrl.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewBioImagesCell.identifier, for: indexPath) as? ViewBioImagesCell else { return UICollectionViewCell()}
        let downloadURL = URL(string: pictureUrl[indexPath.item])
        SDWebImageManager.shared().imageDownloader?.downloadImage(with: downloadURL, options: SDWebImageDownloaderOptions.continueInBackground, progress: nil, completed: { (image, data, error, status) in
            if let error = error {
                print("Error while downloading : \(error), Status :\(status), url :\(String(describing: downloadURL))")
                cell.userImageView.image = #imageLiteral(resourceName: "no-image")
            } else {
                SDImageCache.shared().store(image, forKey: downloadURL!.absoluteString)
                cell.userImageView.image = image
            }
        })
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 60)
    }
    
    static func storyBoardInstance() -> ViewBioVoteVC? {
        let st = UIStoryboard.Vote
        return st.instantiateViewController(withIdentifier: ViewBioVoteVC.id) as? ViewBioVoteVC
    }
    
    func performFriendView(friendId: String){
        if network.reachability.isReachable == true {
            switch friendId {
            case nil:
                return
            case "":
                return
            case AuthService.instance.userId:
                if let vc = ProfileVC.storyBoardInstance() {
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            default:
                if let vc = FriendVC.storyBoardInstance() {
                    vc.friendId = friendId
                    UserDefaults.standard.set(friendId, forKey: "friendId")
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        } else {
            self.showToast(message: "No internet connection")
        }
        
    }

    static func controllerInstance(voterId: String) -> ViewBioVoteVC {
        print("Voter id from sharing : \(voterId)")
        let vc = ViewBioVoteVC()
        vc.voterId = voterId
        vc.title = "Vote For Best Trader"
        return vc
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
extension ViewBioVoteVC : VotingServiceDelegate {
    func didReceiveVotingResult(lists: [VotingItems], isPollClosed: Bool) {
        print("This will not triggered")
    }
    func didVoteStatus(message: String) {
        print("This will not triggered")
    }
    
    func didReceiveVoters(lists: [VotingItems], isVoteDone : Bool, isPollClosed: Bool) {
        print("This will not triggered")
    }
    
    func didReceiveError(error: String) {
        DispatchQueue.main.async {
            print("Got error results from fetching voters bio : \(error)")
            if self.spinner.isAnimating {
                self.spinner.stopAnimating()
            }
            if network.reachability.isReachable == true {
                if error == "Invalid voterid" {
                    print("Voter id wrong")
                } else if error == "Invalid userid" {
                    print("User id is wrong")
                } else {
                    let alert = UIAlertController(title: "Oops!", message: "\(error)", preferredStyle: .alert)
                    alert.view.tintColor = UIColor.GREEN_PRIMARY
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                        //self.dismiss(animated: true, completion: nil)
                        self.navigationController?.popViewController(animated: true)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                let alert = UIAlertController(title: "ERROR!", message: "Seems no Internet Connection", preferredStyle: .alert)
                alert.view.tintColor = UIColor.GREEN_PRIMARY
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                    //self.dismiss(animated: true, completion: nil)
                    self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }
            
            self.hiddenView.isHidden = false
            self.nameLbl.text = ""
            self.designationLbl.text = ""
            self.companyLbl.text = ""
            self.profileImgView.image = #imageLiteral(resourceName: "no-image")
            //self.officeLbl.text = ""
            //self.phoneLbl.text = ""
            //self.emailLbl.text = ""
            //self.countryLbl.text = ""
            self.bioDescLbl.text = ""
            self.awardsDescLbl.text = ""
            self.pictureUrl = [""]
        }
    }
    
    func didReceiveBio(name: String, designation: String, company: String, profile_img: String, office: String, phone: String, email: String, country: String, bioDescription: String, awardDescription: String, pictureUrl: [String], userId: String) {
        DispatchQueue.main.async {
            self.hiddenView.isHidden = true
            if self.spinner.isAnimating { self.spinner.stopAnimating()}
            self.nameLbl.text = name
            self.designationLbl.text = designation
            self.companyLbl.text = company
            self.profileImgView.sd_setImage(with: URL(string: profile_img), completed: nil)
            //self.officeLbl.text = office
            //self.phoneLbl.text = phone
            //self.emailLbl.text = email
            //self.countryLbl.text = country
            if bioDescription == "" {
                self.bioDescLbl.text = "Not Available"
            } else {
                //self.bioDescLbl.setHTMLFromString(text: bioDescription)
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 2
                self.bioDescLbl.text = bioDescription
                print("No of lines : \(self.bioDescLbl.numberOfLines)")
                self.bioDescLbl.numberOfLines = 30
                self.bioText = bioDescription
                if self.bioDescLbl.calculateMaxLines() < 30 {
                    self.bioMoreBtn.isHidden = true
                    self.bioMoreBtnHeight.constant = 8
                }
                /*let paragraphStyle = NSMutableParagraphStyle()
                //paragraphStyle.tabStops = [NSTextTab(textAlignment: NSTextAlignment.left, location: 15, options: [:])]
                paragraphStyle.headIndent = 4
                self.bioDescLbl.attributedText = NSAttributedString(string: bioDescription, attributes: [NSAttributedStringKey.paragraphStyle: paragraphStyle])*/
            }
            
            if awardDescription == "" {
                self.awardsDescLbl.text = "Not Available"
            } else {
                /*if awardDescription.contains("-") {
                    let paragraphStyle = NSMutableParagraphStyle()
                    //paragraphStyle.tabStops = [NSTextTab(textAlignment: NSTextAlignment.left, location: 15, options: [:])]
                    paragraphStyle.headIndent = 10
                    //paragraphStyle.alignment = .justified
                    self.awardsDescLbl.attributedText = NSAttributedString(string: awardDescription, attributes: [NSAttributedStringKey.paragraphStyle: paragraphStyle])
                } else {
                    //self.awardsDescLbl.text = awardDescription.trimmingCharacters(in: .newlines)
                    self.awardsDescLbl.text = awardDescription
                }*/
                self.awardsDescLbl.setHTMLFromString(text: awardDescription)
                //self.awardsDescLbl.text = awardDescription
            }
            
            //self.pictureUrl = pictureUrl
            self.userId = userId
            //self.collectionView.reloadData()
        }
    }
}
extension UILabel {
    func setHTMLFromString(text: String) {
        let modifiedFont = NSString(format:"<span style=\"font-family: Helvetica; font-size: 15px; color: #000000;\">%@</span>" as NSString, text)
        
        let attrStr = try! NSAttributedString(
            data: modifiedFont.data(using: String.Encoding.unicode.rawValue, allowLossyConversion: true)!,
            options: [NSAttributedString.DocumentReadingOptionKey.documentType:NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue],
            documentAttributes: nil)
        
        self.attributedText = attrStr
    }
}
extension UILabel {
    func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(Float.infinity))
        let charSize = font.lineHeight
        let text = (self.text ?? "") as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
}


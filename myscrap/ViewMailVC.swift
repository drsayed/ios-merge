//
//  ViewMailVC.swift
//  myscrap
//
//  Created by MyScrap on 1/30/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit

class ViewMailVC: UIViewController{
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var layout: UICollectionViewFlowLayout!
    
    //Getting data from previous VC
    var user_id = ""
    var listing_id = ""
    var initial = ""
    
    var openValue = false
    
    var service = EmailService()
    var viewMailDS = [ViewMailLists]()
    
    let activityIndicator: UIActivityIndicatorView = {
        let av = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        av.translatesAutoresizingMaskIntoConstraints = false
        return av
    }()
    
    lazy var refreshControll : UIRefreshControl = {
        let rc = UIRefreshControl(frame: .zero)
        rc.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return rc
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        print("User id :\(user_id), Listing id :\(listing_id)")
        setupCollectionView()
        fetchItems()
        service.eDelegate = self
        activityIndicator.startAnimating()
        hideKeyboardWhenTappedAround()
        //layout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width, height: 50)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Inbox"
        navigationItem.hidesBackButton = false
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.addSubview(refreshControll)
        collectionView.refreshControl = refreshControll
    }
    
    @objc
    func handleRefresh(){
        if activityIndicator.isAnimating{
            activityIndicator.stopAnimating()
        }
        fetchItems()
    }
    
    func fetchItems(){
        service.getMailInDetail(userId: user_id, listingID: listing_id)
    }
    
    func scrollToBottom(){
        if !viewMailDS.isEmpty{
            let ip = IndexPath(item: 1, section: viewMailDS.count - 1)
            self.collectionView?.scrollToItem(at: ip, at: .bottom, animated: true)
        }
    }
    
    fileprivate func messageHeight(for text: String) -> CGFloat{
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        let maxLabelWidth:CGFloat = 335
        let maxsize = CGSize(width: maxLabelWidth, height: .greatestFiniteMagnitude)
        let neededSize = label.sizeThatFits(maxsize)
        return neededSize.height
    }
}
extension ViewMailVC : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewMailDS.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if viewMailDS[section]._opened == true {
            if viewMailDS.count - 1 == section && viewMailDS.count != 1 {
                return 3
            } else if viewMailDS.count == 1 {
                viewMailDS.last?._opened = false
                return 3
            }
            return  2
        } else {
            if viewMailDS.count == 1 {
                viewMailDS.last?._opened = false
                return 3
            } else if viewMailDS.count - 1 == section && viewMailDS.count != 1 {
                return 2
            }
            viewMailDS.last?._opened = true
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MailSectionCell", for: indexPath) as! ViewMailSectionCell
            cell.layer.borderWidth = 0.3
            cell.layer.borderColor = UIColor.lightGray.cgColor
            cell.circleView.backgroundColor = UIColor.MyScrapGreen
            cell.initialLabel.text = initial
            cell.subjectLbl.text = viewMailDS[indexPath.section].mail_subject
            cell.dateLbl.text = viewMailDS[indexPath.section].createDate
            return cell
        } else if indexPath.row == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ViewMailCell", for: indexPath) as! ViewMailCell
//            cell.layer.borderWidth = 0.5
//            cell.layer.borderColor = UIColor.lightGray.cgColor
            
            let mailLists = viewMailDS[indexPath.section]
            cell.bodyMessageTV.text = mailLists.message_plain_text
            if indexPath.section == self.viewMailDS.count - 1 {
                cell.adjustUITextViewHeight(arg: cell.bodyMessageTV!)
            }
            
            // :- MARK: Send Button set a "Callback Closure" in the cell
            cell.btnTapAction = {
                () in
                print("Send button tapped", indexPath)
                
                let trim = mailLists.mail_subject.trimmingCharacters(in: .whitespaces)
                
                let str = cell.sendMsgTV.text!
                let trimmed = str.trimmingCharacters(in: .whitespacesAndNewlines)
                
                self.service.sendEmail(userId: self.user_id, subj: trim, body: trimmed, listingID: self.listing_id)
                cell.sendMsgTV.text = ""
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ViewMailBottomCell", for: indexPath) as! ViewMailBottomCell
//            cell.layer.borderWidth = 0.2
//            cell.layer.borderColor = UIColor.lightGray.cgColor
            // :- MARK: Reply Button set a "Callback Closure" in the cell
            cell.btnTapAction = {
                () in
                self.openValue = true
                print("Reply button tapped", indexPath.row)
                
                if self.viewMailDS.last?._opened == true{
                    let section = IndexSet.init(integer: indexPath.section)
                    collectionView.reloadSections(section)
                } else {
                    self.viewMailDS.last?._opened = true
                    let section = IndexSet.init(integer: indexPath.section)
                    collectionView.reloadSections(section)
                }
                self.scrollToBottom()
            }
            return cell
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            if viewMailDS[indexPath.section]._opened == true {
                viewMailDS[indexPath.section]._opened = false
                let section = IndexSet.init(integer: indexPath.section)
                collectionView.reloadSections(section)
            } else {
                viewMailDS[indexPath.section]._opened = true
                let section = IndexSet.init(integer: indexPath.section)
                collectionView.reloadSections(section)
            }
        }
        else if indexPath.row == 1 {
            print("Else")
        } else {
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == viewMailDS.count - 1 {
            if indexPath.row == 1 {
                if openValue == true {
                    return CGSize(width: 375, height: 347)
                } else {
                    return CGSize(width: 375, height: 0)      //change the default height 347
                }
            } else if indexPath.row == 2 {
                if openValue == false {
                    return CGSize(width: 375, height: 60)
                } else {
                    return CGSize(width: 375, height: 0)
                }
                
            } else {
                return CGSize(width: 375, height: 58)
            }
        } else  if indexPath.row == 0 {
            return CGSize(width: 375, height: 58)
        }
        else {
            let body = viewMailDS[indexPath.section].message_plain_text
            let height = messageHeight(for: body)
            print("Body height is : \(height)")
            return CGSize(width: 375, height: height + 22)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ViewMailCell", for: indexPath) as! ViewMailCell
        if indexPath.section == viewMailDS.count - 1 {
            cell.sendMsgHeightConstraint.constant = 40
            cell.sendBtnHeightConstraint.constant = 100
            cell.adjustUITextViewHeight(arg: cell.bodyMessageTV!)
        } else {
            cell.sendMsgHeightConstraint.constant = 0
            cell.sendBtnHeightConstraint.constant = 0
            cell.bodySpacingConstraint.constant = 0
            cell.sendMsgSpacingConstraint.constant = 0
            cell.bottomConstraint.constant = 0
        }
    }
}
extension ViewMailVC : EmailServiceDelegate {
    func DidSentMail(data: String) {
        DispatchQueue.main.async {
            self.showMessage(with: data)
            print("Status : \(data)")
        }
        
    }
    
    func DidReceivedData(array: [EmailInboxLists]) {
        print("Not receive")
    }
    
    func DidReceivedError(error: String) {
        DispatchQueue.main.async {
            self.showMessage(with: error)
        }
        
    }
    
    func DidReceiveMailData(data: [MailData]) {
        print("This won't happen anymore")
    }
    
    func DidReceiveViewMail(data: [ViewMailLists]) {
        DispatchQueue.main.async {
            print("View email in Detail ##DidReceive : \(data.count)")
            self.viewMailDS = data
            self.collectionView.reloadData()
            if self.activityIndicator.isAnimating {
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    
}
/*extension UIImage {
    
    public convenience init?(systemItem sysItem: UIBarButtonItem.SystemItem, renderingMode:UIImage.RenderingMode = .automatic) {
        guard let sysImage = UIImage.imageFromSystemItem(sysItem, renderingMode: renderingMode)?.cgImage else {
            return nil
        }
        
        self.init(cgImage: sysImage)
    }
    
    private class func imageFromSystemItem(_ systemItem: UIBarButtonItem.SystemItem, renderingMode:UIImage.RenderingMode = .automatic) -> UIImage? {
        
        let tempItem = UIBarButtonItem(barButtonSystemItem: systemItem, target: nil, action: nil)
        
        // add to toolbar and render it
        let bar = UIToolbar()
        bar.setItems([tempItem], animated: false)
        bar.snapshotView(afterScreenUpdates: true)
        
        // got image from real uibutton
        let itemView = tempItem.value(forKey: "view") as! UIView
        
        for view in itemView.subviews {
            if view is UIButton {
                let button = view as! UIButton
                let image = button.imageView!.image!
                image.withRenderingMode(renderingMode)
                return image
            }
        }
        
        return nil
    }
}
extension UIBarButtonItem.SystemItem {
    func image() -> UIImage? {
        let tempItem = UIBarButtonItem(barButtonSystemItem: self,
                                       target: nil,
                                       action: nil)
        
        // add to toolbar and render it
        let bar = UIToolbar()
        bar.setItems([tempItem],
                     animated: false)
        bar.snapshotView(afterScreenUpdates: true)
        
        // got image from real uibutton
        let itemView = tempItem.value(forKey: "view") as! UIView
        for view in itemView.subviews {
            if let button = view as? UIButton,
                let image = button.imageView?.image {
                return image.withRenderingMode(.alwaysTemplate)
            }
        }
        
        return nil
    }
}*/

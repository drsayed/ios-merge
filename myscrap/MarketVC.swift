//
//  MarketVC.swift
//  myscrap
//
//  Created by MyScrap on 6/5/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit

class MarketVC: BaseRevealVC {

    fileprivate var identifier = "identifier"
    var titleArray = ["SELL", "BUY" ]
    
    @IBOutlet weak var horizontalBar: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var horizontalBarWidthConstraint: NSLayoutConstraint?
    @IBOutlet weak var horizontalBarleftConstraint: NSLayoutConstraint?
      var   profileEditPopUp = AlartMessagePopupView()
    
    var floaty = Floaty()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        horizontalBarleftConstraint?.constant = 0
        horizontalBarWidthConstraint?.constant = self.view.frame.width / CGFloat(titleArray.count)
        setupCollectionView()
        setupFloaty()
        
//        let _ = ISRI.loadJson()
        
    }
    
    private func setupCollectionView(){
        scrollView.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self

        
        collectionView.register(NewsBarCell.self)
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.scrollDirection = .horizontal
        }
        collectionView.isPagingEnabled = true
        collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .bottom)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let reveal = self.revealViewController() {
            self.mBtn.target(forAction: #selector(reveal.revealToggle(_:)), withSender: self.revealViewController())
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    private func setupFloaty(){
        floaty.respondsToKeyboard = false
        floaty.paddingX = 30
        floaty.title.text = ""
        floaty.buttonImage = #imageLiteral(resourceName: "baseline_add_white_48pt_1x")
        floaty.hasShadow = true
        floaty.buttonColor = UIColor.MyScrapGreen
        floaty.fabDelegate = self
        

        
        self.view.addSubview(floaty)
    }
       @objc func OpenEditProfileView(notification: Notification) {
      //         profileEditPopUp.removeFromSuperview()
      //       let vc = UIStoryboard(name: StoryBoard.PROFILE , bundle: nil).instantiateViewController(withIdentifier: EditProfileController.id) as! EditProfileController
      //            self.navigationController?.pushViewController(vc, animated: true)
                  // activityIndicator.stopAnimating()]
              self.gotoEditProfilePopup()
             }
    func gotoEditProfilePopup() {
                      profileEditPopUp.removeFromSuperview()
                        let vc = UIStoryboard(name: StoryBoard.PROFILE , bundle: nil).instantiateViewController(withIdentifier: EditProfileController.id) as! EditProfileController
                            vc.isNeedToDismiss = true
                          self.navigationController?.pushViewController(vc, animated: true)
              
            }
    static func storyBoardInstance() -> MarketVC?{
        let st = UIStoryboard.Market
        return st.instantiateViewController(withIdentifier: MarketVC.id) as? MarketVC
    }
}
extension MarketVC: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: NewsBarCell = collectionView.dequeReusableCell(forIndexPath: indexPath)
        cell.label.text = titleArray[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleArray.count
    }
}

extension MarketVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let num = CGFloat(titleArray.count)
        return CGSize(width: self.view.frame.width / num, height: collectionView.frame.height)
    }
}

extension MarketVC: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let xOffset = self.scrollView.frame.width * CGFloat(indexPath.item)
        let point = CGPoint(x: xOffset, y: 0)
        self.scrollView.setContentOffset(point, animated: true)
    }
}

extension MarketVC: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == self.scrollView else { return }
        let num = CGFloat(titleArray.count)
        horizontalBarleftConstraint?.constant = self.scrollView.contentOffset.x / num
        print(self.scrollView.contentOffset)
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard scrollView == self.scrollView else { return }
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
    }
}

extension MarketVC: FloatyDelegate{
    func emptyFloatySelected(_ floaty: Floaty) {
        let profilePic = AuthService.instance.profilePic
                          let email = AuthService.instance.email
                          let mobile = AuthService.instance.mobile
              if (profilePic == "https://myscrap.com/style/images/icons/no-profile-pic-female.png" || profilePic == "") || (mobile == "" || email == ""){
                      
                self.profileEditPopUp =  Bundle.main.loadNibNamed("AlartMessagePopupView", owner: self, options: nil)?[0] as! AlartMessagePopupView
                    self.profileEditPopUp.frame = CGRect(x:0, y:0, width:self.view.frame.width,height: self.view.frame.height)
                    self.profileEditPopUp.intializeUI()
                self.profileEditPopUp.delegate = self
                    self.view.addSubview(self.profileEditPopUp)
                 
             }
             else{
        if let vc = AddListingVC.storyBoardInstance() {
            if AuthStatus.instance.isGuest{
                print("Guest user")
                self.showGuestAlert()
            } else {
                print("ADD btn pressed")
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
        }

    }
}
extension MarketVC : AlartMessagePopupViewDelegate
{
    func openEditProfileView() {
        self.gotoEditProfilePopup()
    }
    
    
}

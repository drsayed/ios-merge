//
//  AboutUserVC.swift
//  myscrap
//
//  Created by MyScrap on 12/13/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit
import SafariServices
import SDWebImage
class AboutUserVC: UIViewController { //ScrollViewContainerController{
    

    @IBOutlet weak var cardsCollecction: UICollectionView!
    @IBOutlet var mainscroll: UIScrollView!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var pageCountView: UIView!
    @IBOutlet weak var pageCountLable: UILabel!
    @IBOutlet weak var cardUIStackView: UIView!
    @IBOutlet weak var phoneIcon: UIImageView!
    @IBOutlet weak var phoneTitle: UILabel!
    @IBOutlet weak var phoneValue: UIButton!
    @IBOutlet weak var phoneVieewHight: NSLayoutConstraint!
    @IBOutlet weak var websiteIcon: UIImageView!
    @IBOutlet weak var websiteTitle: UILabel!
    
    @IBOutlet weak var cardUIHeight: NSLayoutConstraint!
    @IBOutlet weak var websiteViewHeight: NSLayoutConstraint!
    @IBOutlet weak var webSiteTitle: UIButton!
    @IBOutlet weak var locationIcon: UIImageView!
    @IBOutlet weak var locationTtitle: UILabel!
    @IBOutlet weak var locattionValue: UIButton!
    
    @IBOutlet weak var locationViewHeight: NSLayoutConstraint!
    

    @IBOutlet weak var memberIcon: UIImageView!
    @IBOutlet weak var memberTitle: UILabel!
    @IBOutlet weak var memberVlaue: UIButton!
    @IBOutlet weak var memberViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var bioContentView: UIView!
    @IBOutlet weak var bioIcon: UIImageView!
    @IBOutlet weak var bioTitle: UILabel!
    @IBOutlet weak var bioDescLbl: UILabel!
    @IBOutlet weak var bioValue: UIButton!
    @IBOutlet weak var bioViiewHeightt: NSLayoutConstraint!
    
    @IBOutlet weak var cardSeperator: UIView!
    @IBOutlet weak var cardViewTop: NSLayoutConstraint!
    var cardFront = ""
    var cardBack   = ""
    var cardCount = 0
    var cardsDataSource:[PictureURL] = []
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.spacing = 8
        sv.alignment = .fill
        sv.axis = .vertical
        return sv
    }()
    
      
    var profileItem: ProfileData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        self.cardsCollecction.register(BusinessCardCell.Nib, forCellWithReuseIdentifier: BusinessCardCell.identifier)

        pageCountView.layer.cornerRadius = pageCountView.frame.size.height/2
        view.backgroundColor = UIColor.white
        NotificationCenter.default.addObserver(self, selector: #selector(self.enableScroll), name: Notification.Name("EnableScroll"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.disableScroll), name: Notification.Name("DisableScroll"), object: nil)
        title = "About"
        
    //    containerView.addSubview(stackView)
        
        
//        stackView.anchor(leading: containerView.leadingAnchor, trailing: containerView.trailingAnchor, top: containerView.topAnchor, bottom: nil,padding: UIEdgeInsets.init(top: 20, left: 16, bottom: 0, right: 16))
       // cardUIStackView.anchor(leading: containerView.leadingAnchor, trailing: containerView.trailingAnchor, top: nil, bottom: containerView.bottomAnchor,padding: UIEdgeInsets.init(top: 20, left: 0, bottom: 0, right: 0))
        
        //        if #available(iOS 11.0, *) {
        //            stackView.widthAnchor.constraint(equalToConstant: view.safeAreaLayoutGuide.layoutFrame.size.width - 32).isActive = true
        //        } else {
        //            stackView.widthAnchor.constraint(equalToConstant: view.frame.size.width - 32).isActive = true
        //        }
        
        
      setupViews()
        mainscroll.isScrollEnabled = false
        mainscroll.delegate = self
    }
    @objc
    func enableScroll(){
        mainscroll.isScrollEnabled = true
    }
    @objc func disableScroll(){
        mainscroll.isScrollEnabled = false
    }
    override func viewWillLayoutSubviews() {
        self.cardsCollecction.reloadData()
    }
    
    @objc func phonePreessed(_ sender: UIButton){
        guard let item = profileItem else { return}//<- needs `@objc`
      if item.phone != ""{
            if let url = URL(string: "tel://\(item.phone)") {
                if UIApplication.shared.canOpenURL(url){
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
    }
    @objc func websitePreessed(_ sender: UIButton){ //<- needs `@objc`
        guard let item = profileItem else { return}
          if item.website != "" {
                        let urlString = "http://" + item.website.replacingOccurrences(of: "http://", with: "").replacingOccurrences(of: "https://", with: "")
                        if let url = URL(string: urlString) {
                            let svc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
                            svc.preferredBarTintColor = UIColor.GREEN_PRIMARY
                            self.present(svc, animated: true, completion: nil)
                        }
                    }
       }
    
    private func setupViews(){
        
        
        guard let item = profileItem else { return }
        
        if item.phone != ""{
              self.phoneVieewHight.constant = 65
            self.phoneValue.setTitle(item.phone, for: .normal)
            self.phoneValue.setTitleColor(UIColor.GREEN_PRIMARY, for: .normal)
            self.phoneValue.isUserInteractionEnabled = true
              self.phoneIcon.image =   self.phoneIcon.image?.withRenderingMode(.alwaysTemplate)
              self.phoneIcon.tintColor = UIColor.GREEN_PRIMARY
             self.phoneValue.addTarget(self, action: #selector(self.phonePreessed(_:)), for: .touchUpInside) //<- use `#selector(...)`

          //  stackView.addArrangedSubview(createButtonView(title: item.phone, type: .phone))
        }
        else
        {
            self.phoneVieewHight.constant = 0
        }
        if item.website != "" {
             self.websiteViewHeight.constant = 65
            self.webSiteTitle .setTitle(item.website, for: .normal)
            self.webSiteTitle.setTitleColor(UIColor.GREEN_PRIMARY, for: .normal)
              self.webSiteTitle.isUserInteractionEnabled = true
            self.websiteIcon.image =   self.websiteIcon.image?.withRenderingMode(.alwaysTemplate)
            self.websiteIcon.tintColor = UIColor.GREEN_PRIMARY
            self.webSiteTitle.addTarget(self, action: #selector(self.websitePreessed(_:)), for: .touchUpInside) //<- use `#selector(...)`

        } else
               {
                   self.websiteViewHeight.constant = 0
               }
        
        if item.location != ""
            {
                 self.locationViewHeight.constant = 65
                self.locattionValue .setTitle(item.location, for: .normal)
                self.locattionValue.setTitleColor(UIColor.BLACK_ALPHA, for: .normal)
                self.locattionValue.isUserInteractionEnabled = false
                self.locationIcon.image =   self.locationIcon.image?.withRenderingMode(.alwaysTemplate)
                self.locationIcon.tintColor = UIColor.BLACK_ALPHA
            } else
                   {
                       self.locationViewHeight.constant = 0
                   }
        //    stackView.addArrangedSubview(createButtonView(title:item.location, type: .address))
        
        let date = item.joinedDate
             let dateFormatter = DateFormatter()
             dateFormatter.dateFormat = "dd MMMM yyyy"
             let dateString = dateFormatter.string(from: date)
             self.memberViewHeight.constant = 65
            self.memberVlaue .setTitle(dateString, for: .normal)
        self.memberVlaue.setTitleColor(UIColor.BLACK_ALPHA, for: .normal)
        self.memberVlaue.isUserInteractionEnabled = false
       
        self.memberIcon.tintColor = UIColor.BLACK_ALPHA
        self.memberIcon.image = self.memberIcon.image?.withRenderingMode(.alwaysTemplate)
        self.memberIcon.tintColor = UIColor.BLACK_ALPHA
        
        if item.userBio != ""   {
            self.bioContentView.isHidden = false
      //     self.bioViiewHeightt.constant = 65
//            self.bioValue .setTitle(item.userBio, for: .normal)
//            self.bioValue.setTitleColor(UIColor.BLACK_ALPHA, for: .normal)
//            self.bioValue.isUserInteractionEnabled = false
            self.cardSeperator.isHidden = true
            self.bioDescLbl.numberOfLines = 0
            self.bioDescLbl.text =  item.userBio
            self.bioDescLbl.textColor = UIColor.BLACK_ALPHA
            self.cardViewTop.constant = 5
//
            //bioIcon
//            self.bioIcon.image =   self.bioIcon.image?.withRenderingMode(.alwaysTemplate)
//            self.bioIcon.tintColor = UIColor.BLACK_ALPHA
                    
        } else
        {
            
            self.cardSeperator.isHidden = false

            self.bioContentView.isHidden = true
            self.cardViewTop.constant = -65
       //     self.bioContentView.frame = CGRect(x:  self.bioContentView.frame.origin.x, y: self.bioContentView.frame.origin.y, width: self.bioContentView.frame.size.width, height: 0)
      //   self.bioViiewHeightt.constant = 0
        }
        //    stackVie
       
           //  stackView.addArrangedSubview(createButtonView(title: dateString, type: .joined))
        
        if item.cardFront != "" ||  item.cardBack != "" {
            self.cardUIHeight.constant = 300
                 // stackView.addArrangedSubview(createButtonView(title:"Business Card", type: .card))
           if item.cardFront != "" &&  item.cardBack != ""
           {
            cardCount = 2
            cardFront = item.cardFront
            cardBack = item.cardBack
            cardsDataSource.append(PictureURL(imageURL: URL(string: item.cardFront), thumbnailImageURL:nil))
            cardsDataSource.append(PictureURL(imageURL: URL(string: item.cardBack), thumbnailImageURL: nil))
           }
          else  if item.cardFront != ""
            {
             cardCount = 1
             cardFront =  item.cardFront
             cardBack = ""
            cardsDataSource.append(PictureURL(imageURL: URL(string: item.cardFront), thumbnailImageURL: nil))
               }
            else  if item.cardBack != ""
            {
             cardCount = 1
             cardFront = ""
             cardBack =  item.cardBack
                cardsDataSource.append(PictureURL(imageURL: URL(string: item.cardBack), thumbnailImageURL: nil))
               }
            self.pageController.currentPage = 0
            self.pageController.numberOfPages = cardCount
            self.pageCountLable.text = "1/\(cardCount)"
            if cardCount == 0 {
                self.pageController.isHidden = true
                 self.pageCountLable.isHidden = true
            }
            else
            {
                self.pageController.isHidden = false
                self.pageCountLable.isHidden = false
            }
            self.cardsCollecction.delegate = self
            self.cardsCollecction.dataSource = self
            cardsCollecction.reloadData()

                //   stackView.addArrangedSubview(cardUIStackView)

         //   containerView.addSubview(cardUIStackView)

              
              }
        else
        {
            self.cardUIHeight.constant = 0
        }
        
        
           let height = cardUIStackView.frame.size.height
           let pos = cardUIStackView.frame.origin.y
           let sizeOfContent = height + pos + 10
        self.mainscroll.contentSize.height = sizeOfContent

        
    }
    
    private func createButtonView(title: String,type: ButtonTextType) -> AboutView {
        let view = AboutView(viewType: type, title: title)
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let actualPosition = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        if (actualPosition.y > 0){
            // Dragging down
            //let screenSize = UIScreen.main.bounds
            if scrollView.contentOffset.y <= 2 {
                self.mainscroll.isScrollEnabled = false
            }
        else
            {
                self.mainscroll.isScrollEnabled = true
            }
            
        }else{
           
            // Dragging up
        }
      
    }
}

extension AboutUserVC: AboutViewDelegate{
    func didTappedView(with type: ButtonTextType) {
        guard let item = profileItem else { return}
        switch type {
        case .website:
            if item.website != "" {
                let urlString = "http://" + item.website.replacingOccurrences(of: "http://", with: "").replacingOccurrences(of: "https://", with: "")
                if let url = URL(string: urlString) {
                    let svc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
                    svc.preferredBarTintColor = UIColor.GREEN_PRIMARY
                    self.present(svc, animated: true, completion: nil)
                }
            }
        case .phone:
            if item.phone != ""{
                if let url = URL(string: "tel://\(item.phone)") {
                    if UIApplication.shared.canOpenURL(url){
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            }
        default:
            print(type.rawValue)
        }
    }
}



protocol AboutViewDelegate: class{
    func didTappedView(with type: ButtonTextType)
}

class AboutView: UIView{
    
    private var type:ButtonTextType = .phone
    
    weak var delegate : AboutViewDelegate?
    
    private let imageView: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
//    private let myCollectionView: UICollectionView = {
//           let myCards = UICollectionView()
//           myCards.translatesAutoresizingMaskIntoConstraints = false
//           return myCards
//       }()
    private let label: UILabel = {
        let lbl = UILabel()
        lbl.font = Fonts.DESIG_FONT
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let borderView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.IMAGE_BG_COLOR
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews(){
        addSubview(imageView)
        addSubview(label)
        addSubview(borderView)
        
        imageView.anchor(leading: leadingAnchor, trailing: nil, top: nil, bottom: nil, size: CGSize(width: 20, height: 20))
        label.anchor(leading: imageView.trailingAnchor, trailing: trailingAnchor, top: nil, bottom: nil,padding: UIEdgeInsets.init(top: 0, left: 8, bottom: 0, right: 0))
        borderView.anchor(leading: leadingAnchor, trailing: trailingAnchor, top: nil, bottom: bottomAnchor, size: CGSize(width: 0, height: 0.5))
        
        self.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(AboutView.tappedView))
        tap.numberOfTapsRequired = 1
        self.addGestureRecognizer(tap)
        
    }
    
    @objc private func tappedView(){
        delegate?.didTappedView(with: type)
    }
    
    
    convenience init(viewType: ButtonTextType, title:String){
        self.init(frame: .zero)
        label.text = title
        type = viewType
        switch viewType {
        case .phone:
            setImage(with: #imageLiteral(resourceName: "ic_phone"), enabled: true)
        case .website:
            setImage(with: #imageLiteral(resourceName: "ic_web"), enabled: true)
        case .address:
            setImage(with: #imageLiteral(resourceName: "ic_location_on_48pt"), enabled: false)
        case .info:
            setImage(with: #imageLiteral(resourceName: "ic_info"), enabled: false)
        case .joined:
            setImage(with: #imageLiteral(resourceName: "ic_access_time_black_48dp"), enabled: false)
        case .card:
         setImage(with: #imageLiteral(resourceName: "ic_web"), enabled: true)
        case .location:
            print("location")
        case .hereto:
            print("Here to")
        case .profession:
            print("Profession")
        case .interested:
            print("Interested in")
        case .dateofjoining:
            print("Date of joining")
        case .userBio:
            print("Member Bio")
        }
    }
    
    private func setImage(with img: UIImage, enabled: Bool){
        imageView.image = img.withRenderingMode(.alwaysTemplate)
        if enabled{
            label.textColor = UIColor.GREEN_PRIMARY
            self.isUserInteractionEnabled = true
            imageView.tintColor = UIColor.GREEN_PRIMARY
        } else {
            label.textColor = UIColor.BLACK_ALPHA
            self.isUserInteractionEnabled = false
            imageView.tintColor = UIColor.BLACK_ALPHA
        }
    }
}

class ScrollViewContainerController: UIViewController{

    

    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.backgroundColor = UIColor.white
        return sv
    }()
    
    
    let containerView: UIView = {
        let cv = UIView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        //        cv.isUserInteractionEnabled = true
        cv.backgroundColor = UIColor.white
        return cv
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        return rc
    }()
    
    @objc
    func refresh(_ sender: UIRefreshControl){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            sender.endRefreshing()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        setupScrollViewandContainerView()
    }
    
    
    func setupScrollViewandContainerView(){
        view.addSubview(scrollView)
        
        scrollView.refreshControl = refreshControl
        scrollView.alwaysBounceVertical = true
        
        scrollView.anchor(leading: view.safeLeading, trailing: view.safeTrailing, top: view.safeTop, bottom: view.safeBottom)
        scrollView.addSubview(containerView)
        
        containerView.anchor(leading: scrollView.leadingAnchor, trailing: scrollView.trailingAnchor, top: scrollView.topAnchor, bottom: scrollView.bottomAnchor)
        
        containerView.anchorSize(to: scrollView)
        
        
    }
    
    
}
extension AboutUserVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return cardCount
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BusinessCardCell.identifier, for: indexPath) as? BusinessCardCell else { return UICollectionViewCell()}
            var downloadURL : URL =   URL(string: cardFront)!
            if indexPath.item == 0 {
                 downloadURL = URL(string: cardFront)!
            }
            else
            {
                downloadURL = URL(string: cardBack)!

            }
                SDWebImageManager.shared().cachedImageExists(for: downloadURL) { (status) in
                    if status{
                        SDWebImageManager.shared().imageCache?.queryCacheOperation(forKey: downloadURL.absoluteString, done: { (image, data, type) in
                            cell.companyImageView.image = image
                        })
                    } else {
                        SDWebImageManager.shared().imageDownloader?.downloadImage(with: downloadURL, options: SDWebImageDownloaderOptions.continueInBackground, progress: nil, completed: { (image, data, error, status) in
                            if let error = error {
                                print("Error while downloading : \(error), Status :\(status), url :\(downloadURL)")
                               
                                //cell.bigProfileIV.image = #imageLiteral(resourceName: "no-image")
                            } else {
                                SDImageCache.shared().store(image, forKey: downloadURL.absoluteString)
                                cell.companyImageView.image = image
                            }
                            
                        })
                    }
                }
            

            
            return cell
        }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            //let width = self.frame.width
            return CGSize(width:self.cardsCollecction.frame.size.width, height: self.cardsCollecction.frame.size.height)
        }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 0
        }
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
           
          //  let cell = collectionView.cellForItem(at: indexPath)
            let galleryPreview = INSPhotosViewController(photos: cardsDataSource, initialPhoto: cardsDataSource[indexPath.row], referenceView: nil)
            galleryPreview.modalPresentationStyle = .overFullScreen

            present(galleryPreview, animated: true, completion: nil)
            
    }
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        // If the scroll animation ended, update the page control to reflect the current page we are on
            self.pageController.currentPage = Int((self.cardsCollecction.contentOffset.x / self.cardsCollecction.contentSize.width) * CGFloat(cardCount))
              self.pageCountLable.text = "\(Int((self.cardsCollecction.contentOffset.x / self.cardsCollecction.contentSize.width) * CGFloat(cardCount))+1)/\(cardCount)"
        }

    
    
}

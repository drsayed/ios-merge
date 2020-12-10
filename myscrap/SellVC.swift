//
//  SellVC.swift
//  myscrap
//
//  Created by MyScrap on 6/5/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit

class SellVC: UICollectionViewController {
    
    var type: MarketType{
        return .sell
    }
    
    var pushTitle: String{
        return "Sell Offer"
    }
    
    var sectionTitle: String{
        return "Sell Offers".uppercased()
    }
    
    var postNotification: Notification.Name{
        return .marketListingSellPosted
    }
    
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
    
    var dataSource = [CountryListing?]()
    var updatedCounDS = [CountryListing?]()
    var productDS = [ProductListing?]()
    var updatedProdDs = [ProductListing?]()
    var marketDataSource = [MarketData]()
    var sellActionBlock: (() -> Int)? = nil
    var newSellActBlock: (() -> Int)? = nil
    var searchText = ""
    var assignProductId = ""
    var assignCountryId = ""
    var countryBtnn = true
    var productBtnn = false
    var selectedCountIndex : Int!
    var selectedProdIndex : Int!
    var selectedIndex : Int?
    var countryId : String?
    var productId : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        setupViews()
        activityIndicator.startAnimating()
        addObserver()
        
    }
    
    private func addObserver(){
        NotificationCenter.default.addObserver(forName: postNotification, object: nil, queue: nil) { [weak self] (notif) in
            self?.handleRefresh()
        }
    }
    
    
    
    private func setupViews(){
        setupCollectionView()
        
        view.addSubview(activityIndicator)
        activityIndicator.setTop(to: view.safeTop, constant: 30)
        activityIndicator.setHorizontalCenter(to: view.centerXAnchor)
        activityIndicator.setSize(size: CGSize(width: 30, height: 30))
    }
    
    private func setupCollectionView(){
        collectionView?.register(MarketCell.self)
        collectionView?.registerNibLoadable(MarketListingCell.self)
        collectionView?.register(HeaderCell.self)
        collectionView?.register(CollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "hello")
        
        
        collectionView?.showsVerticalScrollIndicator = false
        collectionView?.shouldIgnoreScrollingAdjustment = true
        collectionView?.keyboardDismissMode = .onDrag
        
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout{
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 0
        }
        collectionView?.refreshControl = refreshControll
    }
    let service = MarketService()
    
    func fetchItems(){
        service.getMarketItemsWithSearchText(with: type, searchText: searchText, productId: assignProductId, country: assignCountryId) { [weak self] (result) in
            switch result{
            case .success(let data):
                self!.updatedCounDS = data.listingCountryCount!
                self!.updatedProdDs = data.productFilter!
                self?.reloadViews(with: nil, countryListing: data.listingCountryCount!, productDS: data.productFilter!,marketData: data.data, productId: self!.assignProductId,countryId: self!.assignCountryId)
            case .failure(let error):
                self?.reloadViews(with: error, countryListing: [], productDS: [],marketData: nil,productId: "", countryId: "")
            }
        }
    }
    
    @objc
    func handleRefresh(){
        if activityIndicator.isAnimating{
            activityIndicator.stopAnimating()
        }
        searchText = ""
        assignCountryId = ""
        assignProductId = ""
        countryBtnn = true
        productBtnn = false
        fetchItems()
    }
    
    func reloadViews(with error: APIError?, countryListing: [CountryListing?], productDS: [ProductListing?],marketData: [MarketData]?,productId: String, countryId: String){
        if activityIndicator.isAnimating{
            self.activityIndicator.stopAnimating()
        }
        if refreshControll.isRefreshing{
            self.refreshControll.endRefreshing()
        }

        if let data = marketData{
            self.marketDataSource = data.filter({$0.isriCode != nil})
        }
        if countryBtnn == true && productBtnn == false{
            if countryId != "" {
                collectionView?.reloadSections(IndexSet(integer: 2))
                assignCountryId = ""
            } else {
                let listing = countryListing
                print("Reload country : \(listing.count)")
                self.dataSource = listing
                print("DS count : \(dataSource.count)")
                collectionView?.reloadData()
            }
        } else if countryBtnn == false && productBtnn == true {
            print("Product Id : \(productId)")
            if productId != "" {
                collectionView?.reloadSections(IndexSet(integer: 2))
                assignProductId = ""
            }
            else {
                let productData = productDS
                print("Reload product : \(productData.count)")
                self.productDS = productData
                collectionView?.reloadData()
            }
            //collectionView?.reloadSections(IndexSet(integer: 2))
        }
        else {
            let listing = countryListing
            print("Reload all country : \(listing.count)")
            self.dataSource = listing
            print("DS all count : \(dataSource.count)")
            let productData = productDS
            print("Reload all product : \(productData.count)")
            self.productDS = productData
            collectionView?.reloadData()
        }
    }
    
    fileprivate func messageHeight(for text: String) -> CGFloat{
        let label = UILabel()
        label.text = text
        label.font = UIFont(name: "HelveticaNeue", size: 14)!
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        let maxLabelWidth:CGFloat = 240
        let maxsize = CGSize(width: maxLabelWidth, height: .greatestFiniteMagnitude)
        let neededSize = label.sizeThatFits(maxsize)
        return neededSize.height
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            if dataSource.count == 0 && productDS.count == 0 {
                return 1
            } else {
                return 1
            }
            
        } else if section == 1 {
            print("Country count : \(dataSource.count), Product count : \(productDS.count)")
            if dataSource.count == 0 && productDS.count != 0{
                print("***1##")
                return productDS.count
            } else if dataSource.count != 0 && productDS.count == 0 {
                print("***2##")
                return dataSource.count
            } else if dataSource.count != 0 && productDS.count != 0 {
                if countryBtnn == true && productBtnn == false {
                    print("***3 - 1##")
                    return dataSource.count
                } else if countryBtnn == false && productBtnn == true {
                    print("***3 - 2##")
                    return productDS.count
                }
                
            } else {
                print("***4##")
                return section == 0 ? dataSource.count : productDS.count
            }
        } else {
            if marketDataSource.count != 0 {
                print("Market count : \(marketDataSource.count)")
                return marketDataSource.count
            } else {
                return 0
            }
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {          
        if indexPath.section == 0 {
            if dataSource.count == 0 && productDS.count == 0 {
                let cell : HeaderCell = collectionView.dequeReusableCell(forIndexPath: indexPath)
                cell.searchText.setTop(to: cell.topAnchor, constant: 15)
                cell.searchText.setLeading(to: cell.leadingAnchor, constant: 12)
                cell.searchText.setTrailing(to: cell.trailingAnchor, constant: 12)
                cell.searchText.setSize(size: CGSize(width: cell.contentView.width, height: 40))
                cell.button.setSize(width: 10, height: 25)
                cell.contentView.addSubview(cell.title)
                //cell.title.text = "No Results Found!!!"
                return cell
            } else {
                let cell : HeaderCell = collectionView.dequeReusableCell(forIndexPath: indexPath)
                cell.title.removeFromSuperview()
                cell.searchText.setTop(to: cell.topAnchor, constant: 15)
                cell.searchText.setLeading(to: cell.leadingAnchor, constant: 12)
                cell.searchText.setTrailing(to: cell.trailingAnchor, constant: 12)
                cell.searchText.setSize(size: CGSize(width: cell.contentView.width, height: 40))
                cell.button.setSize(width: 10, height: 25)
                cell.coutActionBlock = {
                    self.countryBtnn = cell.countryBtn.isSelected
                    self.productBtnn = cell.productBtn.isSelected
                    print("1.Country btn tapped : \(cell.countryBtn.isSelected), Product btn tapped : \(cell.productBtn.isSelected)")
                    if self.updatedCounDS.count == 0 {
                        self.reloadViews(with: nil, countryListing: self.dataSource, productDS: [], marketData: self.marketDataSource, productId: "", countryId: "")
                    } else {
                        if self.searchText != "" {
                            self.reloadViews(with: nil, countryListing: self.updatedCounDS, productDS: self.productDS, marketData: self.marketDataSource, productId: self.assignCountryId, countryId: self.assignCountryId)
                        } else {
                            self.reloadViews(with: nil, countryListing: self.dataSource, productDS: [], marketData: self.marketDataSource, productId: "", countryId: "")
                        }
                    }
                    
                }
                cell.prodActionBlock = {
                    self.countryBtnn = cell.countryBtn.isSelected
                    self.productBtnn = cell.productBtn.isSelected
                    print("2.Country btn tapped : \(cell.countryBtn.isSelected), Product btn tapped : \(cell.productBtn.isSelected)")
                    if self.productDS.count == 0{
                        self.reloadViews(with: nil, countryListing: [], productDS: self.updatedProdDs, marketData: self.marketDataSource, productId: "", countryId: "")
                    } else {
                        if self.searchText != "" {
                            self.reloadViews(with: nil, countryListing: self.updatedCounDS, productDS: self.updatedProdDs, marketData: self.marketDataSource, productId: "", countryId: "")
                        } else {
                            self.reloadViews(with: nil, countryListing: [], productDS: self.productDS, marketData: self.marketDataSource, productId: "", countryId: "")
                        }
                        
                    }
                }
                cell.searchActionBlock = {
                    self.searchText = cell.searchText.text!.trimmingCharacters(in: .whitespaces)
                    self.activityIndicator.startAnimating()
                    self.fetchItems()
                }
                cell.searchCloseActBlock = {
                    self.searchText = cell.searchText.text!
                    self.fetchItems()
                }
                return cell
            }
            
        } else if indexPath.section == 1 {
            let cell : MarketCell = collectionView.dequeReusableCell(forIndexPath: indexPath)
            
            if dataSource.count == 0 {
                cell.productList = self.productDS[indexPath.row]
                print("If")
            } else if productDS.count == 0 {
                print("else if")
                cell.marketItem = dataSource[indexPath.row]
            } else {
                if countryBtnn == true  && productBtnn == false {
                    print("Else if happened")
                    cell.marketItem = dataSource[indexPath.row]
                    
                    if countryId == dataSource[indexPath.row]?.countryId {
                        cell.label.textColor = UIColor.MyScrapGreen
                    } else if countryId == dataSource[selectedIndex ?? 0]?.countryId {
                        cell.label.textColor = UIColor.black
                    } else {
                        cell.label.textColor = UIColor.black
                    }
                } else if countryBtnn == false && productBtnn == true {
                    print("Else else happened")
                    cell.productList = self.productDS[indexPath.row]
                    if productId == productDS[indexPath.row]?.productId {
                        cell.productList = self.productDS[indexPath.row]
                        cell.label.textColor = UIColor.MyScrapGreen
                    } else if productId == productDS[selectedIndex ?? 0]?.productId {
                        cell.productList = self.productDS[indexPath.row]
                        cell.label.textColor = UIColor.black
                    } else {
                        cell.productList = self.productDS[indexPath.row]
                        cell.label.textColor = UIColor.black
                    }
                }
//                else {
//
//                    if countryId == dataSource[indexPath.row]?.countryId {
//                        cell.marketItem = dataSource[indexPath.row]
//                        cell.label.textColor = UIColor.MyScrapGreen
//
//                    } else if countryId == dataSource[selectedIndex ?? 0]?.countryId {
//                        cell.marketItem = dataSource[indexPath.row]
//                        cell.label.textColor = UIColor.black
//                    } else {
//                        cell.marketItem = dataSource[indexPath.row]
//                        cell.label.textColor = UIColor.black
//                    }
//
//                    if productId == productDS[indexPath.row]?.productId {
//                        cell.productList = self.productDS[indexPath.row]
//                        cell.label.textColor = UIColor.MyScrapGreen
//                    } else if productId == productDS[selectedIndex ?? 0]?.productId {
//                        cell.productList = self.productDS[indexPath.row]
//                        cell.label.textColor = UIColor.black
//                    } else {
//                        cell.productList = self.productDS[indexPath.row]
//                        cell.label.textColor = UIColor.black
//                    }
//                }
            }
            
            return cell
        }
        else {
            let cell : MarketListingCell = collectionView.dequeReusableCell(forIndexPath: indexPath)
            
            cell.marketData = marketDataSource[indexPath.item]
            cell.delegate = self
            
            let imageTap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(viewListing(tapGesture:)))
            imageTap.numberOfTapsRequired = 1
            cell.imageView.isUserInteractionEnabled = true
            cell.imageView.tag = indexPath.row
            cell.imageView.addGestureRecognizer(imageTap)
            
            let titleTap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(viewListing(tapGesture:)))
            titleTap.numberOfTapsRequired = 1
            cell.titleLabel.isUserInteractionEnabled = true
            cell.titleLabel.tag = indexPath.row
            cell.titleLabel.addGestureRecognizer(titleTap)
            
            
            return cell
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if indexPath.section == 0 {
            return UICollectionReusableView()
        } else if indexPath.section == 1 {
            return UICollectionReusableView()
        }
        else {
            let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "hello", for: indexPath) as! CollectionReusableView
            cell.label.text = sectionTitle
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        var height : CGFloat
        
        if section == 0{
            height = 0         //changed from 25
        } else if section == 1 {
            height = 0
        }
        else {
            height = 40
        }
        return dataSource.count == 0 ? CGSize.zero : CGSize(width: view.bounds.width, height: height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            
        } else if indexPath.section == 1 {
//            let cell: MarketCell = collectionView.cellForItem(at: indexPath) as! MarketCell
            if dataSource.count == 0 && productDS.count != 0{
                let data = productDS[indexPath.item]
                assignProductId = (data?.productId)!
                print("Prod ID : \(String(describing: data?.productId!))")
                activityIndicator.startAnimating()
                fetchItems()
                print("If did select")
            } else if dataSource.count != 0 && productDS.count == 0 {
                print("else if did select")
                let data = dataSource[indexPath.item]
                assignCountryId = (data?.countryId)!
                activityIndicator.startAnimating()
                fetchItems()
            } else if dataSource.count != 0 && productDS.count != 0 {
                if countryBtnn == true && productBtnn == false {
                    print("Else happened did select")
                    let data = dataSource[indexPath.item]
                    assignCountryId = (data?.countryId)!
                    activityIndicator.startAnimating()
                    fetchItems()
                    
                } else if countryBtnn == false && productBtnn == true {
                    print("Else happened did select")
                    let data = productDS[indexPath.item]
                    assignProductId = (data?.productId)!
                    activityIndicator.startAnimating()
                    fetchItems()
                }
            }
            let cell: MarketCell = collectionView.cellForItem(at: indexPath) as! MarketCell
            
            selectedIndex = indexPath.row
            countryId = cell.marketItem?.countryId
            
            //Product
            productId = cell.productList?.productId
//            if countryId != dataSource[selectedIndex!]?.countryId {
//                cell.label.textColor = UIColor.black
//                selectedIndex = indexPath.last
//            } else {
//                cell.label.textColor = UIColor.MyScrapGreen
//                //selectedIndex = indexPath.last
//            }
            
            
            
            //print("Selected index in did select:\(selectedIndex), country ID : \(countryId) || dsCountry id : \(dataSource[indexPath.row]?.countryId) sele ds : \(dataSource[selectedIndex ?? 0]?.countryId) ")
        }
        else {
//            performDetailVC(indexPath: indexPath)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        print("Selected index de select:\(selectedIndex)")
//        if selectedIndex != indexPath.row {
//            let cell: MarketCell = collectionView.cellForItem(at: indexPath) as! MarketCell
//            cell.label.textColor = UIColor.black
//        }
        
    }
    
    @objc func viewListing(tapGesture:UITapGestureRecognizer) {
        performDetailVC(indexPath: tapGesture.view!.tag)
    }
    
    func performDetailVC(indexPath: Int){
        let data = marketDataSource[indexPath]
        print("User id confusion : \(String(describing: data.user_data?.userId))")
        let vc = DetailListingOfferVC.controllerInstance(with: data.listingID, with1: data.user_data?.userId)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func performDetailVC(indexPath: IndexPath){
        let data = marketDataSource[indexPath.row]
        print("User id confusion : \(String(describing: data.user_data?.userId))")
        let vc = DetailListingOfferVC.controllerInstance(with: data.listingID, with1: data.user_data?.userId)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    private func handleFavourite(){
//        if AuthStatus.instance.isGuest{
//            showGuestAlert()
//        } else {
//            guard let profile = profileItem  else { return }
//            profile.isFav = !profile.isFav
//            let member = MemmberModel()
//            let indexPath = IndexPath(item: 0, section: 0)
//            print("Friend ID in friend VC: \(profile.memUserId)")
//            if profile.isFav == true {
//                member.clickFav(friendId: profile.memUserId, action: "fav")
//            } else {
//                member.clickFav(friendId: profile.memUserId, action: "unfav")
//            }
//            //member.postFavourite(friendId: profile.memUserId)
//            self.collectionView.reloadItems(at: [indexPath])
//        }
    
    }
    

}

extension SellVC: MarketDataCellDelegate{
    func didTapViewMore(cell: MarketListingCell) {
        if let indexPath = collectionView?.indexPathForItem(at: cell.center){
            let list = marketDataSource[indexPath.row]
            if let data = list.user_data, let userid = data.userId {
                print("User Id: \(userid)")
                performDetailVC(indexPath: indexPath)
            }
            //performDetailVC(indexPath: indexPath)
        }
    }
    
    func didTap(cell: MarketListingCell) {
        if let ip = collectionView?.indexPathForItem(at: cell.center){
            let list = marketDataSource[ip.row]
            if let data = list.user_data, let firstName = data.firstName, let lastName = data.lastName, let colorCode = data.colorCode, let userid = data.userId, let jid = data.jid, let profilePic = data.profilePic {
                performConversationVC(friendId: userid, profileName: "\(firstName) \(lastName)", colorCode: colorCode, profileImage: profilePic, jid: jid, listingId: "", listingTitle: "", listingType: "", listingImg: "")
            }
        }
    }
    func didPressFavourite(cell: MarketListingCell) {
        handleFavourite()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchItems()
        hideKeyboardWhenTappedAround()
    }

}
extension SellVC: UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: collectionView.bounds.width, height: 120)
//            return CGSize(width: view.bounds.width / 2, height: 30)         //height changed from 35
        } else if indexPath.section == 1 {
            if dataSource.count == 0 && productDS.count != 0{
                let values = productDS[indexPath.item]
                let valueHeight = (values?.isri_code)! + " [" + (values?.total_product)! + "]"
                let height = messageHeight(for: valueHeight)
                print("If size : \(height)")
                return CGSize(width: view.bounds.width / 2, height: height + 18)
            } else if dataSource.count != 0 && productDS.count == 0 {
                let values = dataSource[indexPath.item]
                let valueHeight = (values?.country)! + " [" + (values?.count)! + "]"
                let height = messageHeight(for: valueHeight)
                print("else if size : \(height)")
                return CGSize(width: view.bounds.width / 2, height: height + 18)
                
            } else if dataSource.count != 0 && productDS.count != 0 {
                if countryBtnn == true && productBtnn == false {
                    let values = dataSource[indexPath.item]
                    let valueHeight = (values?.country)! + " [" + (values?.count)! + "]"
                    let height = messageHeight(for: valueHeight)
                    print("if happened size : \(height)")
                    return CGSize(width: view.bounds.width / 2, height: height + 18)
                    
                } else if countryBtnn == false && productBtnn == true {
                    let values = productDS[indexPath.item]
                    let valueHeight = (values?.isri_code)! + " [" + (values?.total_product)! + "]"
                    let height = messageHeight(for: valueHeight)
                    print("else if happened size : \(height)")
                    return CGSize(width: view.bounds.width / 2, height: height + 18)
                }
                else {
                    return CGSize(width: view.bounds.width / 2, height: 35)
                }
            }
            else {
                return CGSize(width: view.bounds.width / 2, height: 35)
            }
        }
        else {
            return CGSize(width: view.bounds.width, height: 108 - 30)
        }
    }
    
}

class HeaderCell: BaseCVCell, UITextFieldDelegate{
    
    let service = MarketService()
    var type: MarketType{
        return .sell
    }
    var coutActionBlock: (() -> Void)? = nil
    var prodActionBlock: (() -> Void)? = nil
    var searchActionBlock: (() -> Void)? = nil
    var searchCloseActBlock: (() -> Void)? = nil
//    let label: UILabel = {
//        let lbl = UILabel()
//        lbl.translatesAutoresizingMaskIntoConstraints = false
//        lbl.text = "Refine By Country"
//        lbl.font = Fonts.newsTitleFont
//        return lbl
//    }()
    
    let seperatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.seperatorColor
        return view
    }()
    
    let searchText : UITextField = {
        let textField = UITextField()
        textField.x = 12
        textField.y = 18
        textField.width = 375
        textField.height = 40
        textField.borderStyle = .roundedRect
        textField.borderRect(forBounds: CGRect(x: 8, y: 8, width: 2, height: 2))
        //textField.placeholder = "\"Search\""
        textField.returnKeyType = .search
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let btnView : UIView = {
        let view = UIView()
        //view.x =  12
        view.width = 375
        view.height = 40
        //view.backgroundColor = .blue
        return view
    }()
    
    let countryBtn : UIButton = {
        let btn = UIButton()
        //btn.x =  0
        //btn.width = 175
        btn.height = 50
        btn.backgroundColor = .MyScrapGreen
        btn.setTitle("By Country", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 15)
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        btn.isSelected = true
        return btn
    }()
    
    let productBtn : UIButton = {
        let btn = UIButton()
        //btn.x =  12
        //btn.width = 175
        btn.height = 50
        btn.backgroundColor = .lightGray
        btn.setTitle("By Product", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .boldSystemFont(ofSize: 15)
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        btn.isSelected = false
        return btn
    }()
    
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.spacing = 12
        sv.alignment = .fill
        sv.distribution = .fillEqually
        sv.axis = .horizontal
        return sv
    }()
    
    //Cell behaves like Collectionvie
    
    let activityIndicator: UIActivityIndicatorView = {
        let av = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        av.translatesAutoresizingMaskIntoConstraints = false
        return av
    }()
    let title = UILabel(frame: CGRect(x: 0, y: 120, width: 375, height: 40))
    let button = UIButton(type: .custom)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        buttonConfig()
        searchText.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
        buttonConfig()
        searchText.delegate = self
    }
    
    override func setupViews(){
        let imageView = UIImageView()
        addSubview(searchText)
        searchText.addSubview(imageView)
        addSubview(btnView)
        btnView.addSubview(stackView)
//        btnView.addSubview(countryBtn)
//        btnView.addSubview(productBtn)
        addSubview(seperatorView)
        
        //searchText.width = self.contentView.width
        title.textColor = .lightGray
        title.textAlignment = .center
        addSubview(title)
        
//        let searchImage =  #imageLiteral(resourceName: "ic_search")
        let btn = UIButton()
//        btn.setImage(searchImage, for: .normal)
//        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -20)
        btn.frame = CGRect(x: CGFloat(10), y: CGFloat(), width: CGFloat(30), height: CGFloat(20))
        btn.tintColor = UIColor.seperatorColor
        btn.setTitle("  ", for: .normal)
        btn.titleLabel?.font = UIFont.fontAwesome(ofSize: 15, style: .solid)
        btn.setTitle(String.fontAwesomeIcon(name: .search), for: .normal)
        btn.setTitleColor(UIColor.lightGray, for: .normal)
        searchText.leftViewMode = .always
        searchText.leftView = btn
        
        btnView.y = searchText.y + 50
        countryBtn.translatesAutoresizingMaskIntoConstraints = false
        productBtn.translatesAutoresizingMaskIntoConstraints = false

        btnView.widthAnchor.constraint(equalToConstant: self.width).isActive = true
        
        stackView.height = 50
        stackView.width = self.width
        stackView.anchor(leading: leadingAnchor, trailing: trailingAnchor, top: btnView.topAnchor, bottom: btnView.bottomAnchor, padding: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12), size: CGSize(width: self.width, height: 50))

        stackView.addArrangedSubview(countryBtn)
        stackView.addArrangedSubview(productBtn)
        print("Stack view width : \(stackView.width), Search Text width : \(searchText.width), button view width : \(btnView.width)")
        /*NSLayoutConstraint.activate([
            
            seperatorView.heightAnchor.constraint(equalToConstant: 1),
            seperatorView.leadingAnchor.constraint(equalTo: searchText.leadingAnchor),
            seperatorView.trailingAnchor.constraint(equalTo:  trailingAnchor, constant: -8),
            seperatorView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1)
            ])
         */
    }
    func buttonConfig(){
        
        countryBtn.addTarget(self, action: #selector(countryBtnTapped), for: .touchUpInside)
        productBtn.addTarget(self, action: #selector(productBtnTapped), for: .touchUpInside)
    }
    @objc func countryBtnTapped(){
        countryBtn.isSelected = true
        productBtn.isSelected = false
        countryBtn.backgroundColor = .MyScrapGreen
        productBtn.backgroundColor = .lightGray
        coutActionBlock?()
    }
    @objc func productBtnTapped(){
        countryBtn.isSelected = false
        productBtn.isSelected = true
        productBtn.backgroundColor = .MyScrapGreen
        countryBtn.backgroundColor = .lightGray
        prodActionBlock?()
    }
    @IBAction func closeBtn(_ sender: Any) {
        if searchText.text != "" {
            print("close btn pressed")
            searchText.text = ""
//            searchText.placeholder = "\"Search\""
            searchCloseActBlock?()
        } else {
            print("Empty textfield")
            searchCloseActBlock?()
        }
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchActionBlock?()
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let closeImg = #imageLiteral(resourceName: "closegallery12x12")
        button.setImage(closeImg, for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        button.frame = CGRect(x: CGFloat(textField.width - 50), y: CGFloat(), width: CGFloat(10), height: CGFloat(20))
        button.addTarget(self, action: #selector(self.closeBtn), for: .touchUpInside)
        textField.rightView = button
        textField.rightViewMode = .whileEditing
        return true
    }
}



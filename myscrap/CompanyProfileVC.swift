//
//  ComapnyProfileVC.swift
//  myscrap
//
//  Created by MS1 on 11/29/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

class CompanyProfileVC: BaseVC, CompanyDetailInnerDelegate{
    
    @IBOutlet fileprivate weak var collectionView: UICollectionView!
    @IBOutlet fileprivate weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet fileprivate weak var editButton: UIBarButtonItem!
    @IBOutlet fileprivate weak var cameraBtn: CircularButton!
    
    fileprivate var companyprofile : CompanyProfileItem? {
        didSet{
            self.collectionView.reloadData()
            if let item = companyprofile{
                toggleButton(show: item.ownerUserId == AuthService.instance.userId)
            }
        }
    }
    
    fileprivate var pictures : [PictureURL]?
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControl.Event.valueChanged)
        return refreshControl
    }()
    
    var companyId : String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        // Do any additional setup after loading the view.
        setupViews()
        activityIndicator.startAnimating()
        self.getCompanyDetails()
        toggleButton(show: false)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    private func setupViews(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CompanyProfileCell.Nib, forCellWithReuseIdentifier: CompanyProfileCell.identifier)
        collectionView.register(CompanyDetailInnerCell.Nib, forCellWithReuseIdentifier: CompanyDetailInnerCell.identifier)
        collectionView.refreshControl = refreshControl
    }
    
    @objc private func handleRefresh(_ refreshControl: UIRefreshControl){
        if activityIndicator.isAnimating{
            activityIndicator.stopAnimating()
        }
        getCompanyDetails()
    }
    
    
    fileprivate func getCompanyDetails(){
        let service = CompanyProfileService()
        guard let id = companyId else { return }
        service.getCompany(companyId: id, completion: {[weak self] success , error, profileItem , pics in
            DispatchQueue.main.async {
                guard let companyProfile = profileItem else { return }
                self?.updateData(item: companyProfile, pictureItem: pics)
            }
        })
    }
    
    private func updateData(item: CompanyProfileItem, pictureItem: [PictureURL]?){
        activityIndicator.stopAnimating()
        refreshControl.endRefreshing()
        companyprofile = item
        pictures = pictureItem
        collectionView.reloadData()
    }
    
    
    fileprivate func toggleButton(show: Bool){
        if !show{
            editButton.isEnabled = false
            editButton.tintColor = UIColor.clear
            cameraBtn.isHidden = true
        } else{
            cameraBtn.isHidden = false
            editButton.isEnabled = true
            editButton.tintColor = UIColor.white
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
}

extension CompanyProfileVC: UICollectionViewDelegate{
    
}

extension CompanyProfileVC: UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        guard let  _ = companyprofile else { return 0 }
        
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompanyProfileCell.identifier, for: indexPath) as! CompanyProfileCell
            cell.companyProfile = companyprofile
            cell.delegate = self
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompanyDetailInnerCell.identifier, for: indexPath) as! CompanyDetailInnerCell
            cell.delegate = self
            cell.companyItem = companyprofile
            return cell
        }
        

    }
}

extension CompanyProfileVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.width
        if indexPath.item == 0 {
            return CGSize(width: width, height: (width / 2 ) + 20 + 48 + 30 + 60 + 44)
        } else {
            guard let item = companyprofile else { return .zero}
            
            var height:CGFloat = 40.0
            
            if item.companyEmployees != 0 {
                height += 40.0
            }
            
            if item.companyLike != 0 {
                height += 40.0
            }
            
            return CGSize(width: width, height: height)
        }
    }
}

extension CompanyProfileVC: ProfileCellDelegate{
    func DidPressPhotosBtn(cell: BaseCell) {
        guard let profile = companyprofile else { return }
        if let vc = PhotosUserVC.storyBoardInstance(){
            print(pictures?.count ?? "No pictures")
            if let pics = pictures {
                vc.configPictureURL(profileItem: profile, dataSource: pics)
            } else {
                vc.configPictureURL(profileItem: profile, dataSource: [PictureURL]())
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func DidPressFavourite(cell: BaseCell) {
        if let item = companyprofile{
            let message  = item.isFavourite ? "Removed From Favourites" : "Added To Favourites"
            showToast(message: message)
            item.isFavourite = !item.isFavourite
            collectionView.reloadData()
            item.insertCompanyFavourite()
        }
    }
    
    func DidPressCompanyBtn(cell: BaseCell) {
        //
    }
    
    func DidPressIntrestBtn(cell: BaseCell) {
        goToInterestVC()
    }
    
    func DidPressAboutBtn(cell: BaseCell) {
        goToAboutVC()
    }
    
    func DidPressChat(cell: BaseCell) {
        //
    }
    
    func DidPressEmail(cell: BaseCell) {
        //
    }
    
    func DidPressLike() {
        guard let item = companyprofile, let id = item.companyId else { return }
        if item.isFollowing {
            item.companyLike -= 1
        } else {
            item.companyLike += 1
        }
        item.isFollowing = !item.isFollowing
        collectionView.reloadData()
        
        let service = APIService()
        service.endPoint = Endpoints.COMPANY_LIKES_URL
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&companyId=\(id)"
        service.getDataWith { (result) in
        }
        
    }
}


// Helper functions
extension CompanyProfileVC{
    
    //MARK:- INTEREST VC
    private func goToInterestVC(){
        let vc = CompanyInterestVC()
        vc.title = "Company Interests"
        self.navigationController?.pushViewController(vc, animated: true)
        if let commodities = companyprofile?.interest.sorted(), let industry = companyprofile?.roles.sorted(), let affiliation = companyprofile?.affiliation.sorted() {
            let obj = Interests()
            vc.commoditiesArray = obj.getCompanyCommodities(input: commodities)
            vc.industryArray = obj.getCompanyIndustries(input: industry)
            vc.affiliationArray = obj.getCompanyAffiliation(input: affiliation)
        }
    }
    
    //MARK:- ABOUTVC
    private func goToAboutVC(){
        guard let profile = companyprofile else { return }
        let vc = CompanyAboutVC()
        vc.companyProfileItem = profile
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


extension CompanyProfileVC{
    static func storyBoardInstance() -> CompanyProfileVC? {
        let st = UIStoryboard(name: "Companies", bundle: nil)
        return st.instantiateViewController(withIdentifier: CompanyProfileVC.id) as? CompanyProfileVC
    }
}





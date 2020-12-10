//
//  CompanyModuleMediaVC.swift
//  myscrap
//
//  Created by Apple on 21/10/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit

class CompanyModuleMediaVC: UIViewController {

    enum CompanyMediaType{
        case all
        case company
        case commodity
        case employee
    }
    
    fileprivate var companyMediaType: CompanyMediaType = .all {
        didSet{
            self.collectionView.reloadData()
            updateBtns()
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!

    var getPictureUrl : [PictureURL]?

    @IBOutlet weak var mediaAllBtn: UIButton!
    @IBOutlet weak var mediaCompanyBtn: UIButton!
    @IBOutlet weak var mediaCommodityBtn: UIButton!
    @IBOutlet weak var mediaEmployeeBtn: UIButton!

    @IBOutlet weak var noImageView : UIImageView!
    var imageUrlStr : String?

    var companyProfile : CompanyItems?

    var apiService = CompanyUpdatedService()

    //MARK:- Scroll Delegate
    weak var innerTableViewScrollDelegate: InnerTableViewScrollDelegate?

    //MARK:- Stored Properties for Scroll Delegate
    private var dragDirection: DragDirection = .Up
    private var oldContentOffset = CGPoint.zero

    var companyID : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = .white
    
        self.getCompanyDetailsAPI()
        setupCollectionView()

        self.mediaAllBtn.tag = 100
        self.mediaCompanyBtn.tag = 111
        self.mediaCommodityBtn.tag = 222
        self.mediaEmployeeBtn.tag = 333

        self.updateBtns()

//        NotificationCenter.default.addObserver(self, selector: #selector(reloadCompanyDetailsAPI), name: Notification.Name("kCallCompanyDetailsAPI"), object: nil)

    }
//    @objc func reloadCompanyDetailsAPI() {
//        
//        self.getCompanyDetailsAPI()
//    }
    //MARK:- API
    func getCompanyDetailsAPI(){
        
        if let companyId = UserDefaults.standard.object(forKey: "companyId") as? String {
            self.companyID = companyId
            if companyId != "" {
                apiService.delegate = self
                apiService.getCompanyDetails(companyId: companyID)
            }
        }
    }
    
    private func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.collectionView.register(CompanyImageslCell.Nib, forCellWithReuseIdentifier: CompanyImageslCell.identifier)

        //view.layoutIfNeeded()
        //heightConstraint.constant = collectionView.collectionViewLayout.collectionViewContentSize.height
    }
    
    
    private func updateBtns(){
        
        self.mediaAllBtn.setTitleColor(UIColor.BLACK_ALPHA, for: .normal)
        self.mediaCompanyBtn.setTitleColor(UIColor.BLACK_ALPHA, for: .normal)
        self.mediaCommodityBtn.setTitleColor(UIColor.BLACK_ALPHA, for: .normal)
        self.mediaEmployeeBtn.setTitleColor(UIColor.BLACK_ALPHA, for: .normal)

        if companyMediaType == .all {
            self.mediaAllBtn.setTitleColor(UIColor.GREEN_PRIMARY, for: .normal)
        }
        else if companyMediaType == .company {
            self.mediaCompanyBtn.setTitleColor(UIColor.GREEN_PRIMARY, for: .normal)
        }
        else if companyMediaType == .commodity {
            self.mediaCommodityBtn.setTitleColor(UIColor.GREEN_PRIMARY, for: .normal)
        }
        else if companyMediaType == .employee {
            self.mediaEmployeeBtn.setTitleColor(UIColor.GREEN_PRIMARY, for: .normal)
        }
    }
    
    @IBAction func mediaButtonPressed(sender : UIButton) {
        
        if sender.tag == 100 {
            companyMediaType = .all
        }
        else if sender.tag == 111 {
            companyMediaType = .company
        }
        else if sender.tag == 222 {
            companyMediaType = .commodity
        }
        else if sender.tag == 333 {
            companyMediaType = .employee
        }
    }
}

extension CompanyModuleMediaVC:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        self.collectionView.isHidden = false
        self.noImageView.isHidden = true

        if self.companyProfile != nil {
            switch companyMediaType {
                
            case .all:
                 if self.companyProfile?.mediaAllImagesArray != nil {
                    
                    if self.companyProfile!.mediaAllImagesArray!.count == 0 {
                        self.noImageView.isHidden = false
                    }
                    return self.companyProfile!.mediaAllImagesArray!.count
                }
                 else {
                    self.noImageView.isHidden = false
                 }
            case .company:
                if self.companyProfile?.mediaCompanyImagesArray != nil {
                    if self.companyProfile!.mediaCompanyImagesArray!.count == 0 {
                        self.noImageView.isHidden = false
                    }
                    return self.companyProfile!.mediaCompanyImagesArray!.count
                }
            case .commodity:
                if self.companyProfile?.mediaCommodityImagesArray != nil {
                    if self.companyProfile!.mediaCommodityImagesArray!.count == 0 {
                        self.noImageView.isHidden = false
                    }
                    return self.companyProfile!.mediaCommodityImagesArray!.count
                }
            case .employee:
                if self.companyProfile?.mediaEmployeesImagesArray != nil {
                    if self.companyProfile!.mediaEmployeesImagesArray!.count == 0 {
                        self.noImageView.isHidden = false
                    }
                    return self.companyProfile!.mediaEmployeesImagesArray!.count
                }
            default:
                return 0
            }
        }
        else {
            self.collectionView.isHidden = true
            self.noImageView.isHidden = false
        }
        
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompanyImageslCell.identifier, for: indexPath) as? CompanyImageslCell else { return UICollectionViewCell()}
//        cell.updatedDelegate = self
        
//        cell.newItem = data
//        cell.refreshTable()
//        cell.deleteButton.isHidden = true
        
        if self.companyProfile != nil
        {
            imageUrlStr = ""
            switch companyMediaType {
                
            case .all:
                 if self.companyProfile!.mediaAllImagesArray != nil {
                    
                    let data = self.companyProfile!.mediaAllImagesArray![indexPath.row] as! PictureURL
                    imageUrlStr =  data.images as String // self.companyProfile!.mediaAllImagesArray![indexPath.row]
                    
                    self.getPictureUrl = self.companyProfile!.mediaAllImagesArray
                }
            case .company:
                if self.companyProfile!.mediaCompanyImagesArray != nil {
                    let data = self.companyProfile!.mediaCompanyImagesArray![indexPath.row] as! PictureURL
                    imageUrlStr =  data.images as String
                    
                    self.getPictureUrl = self.companyProfile!.mediaCompanyImagesArray

//                    cell.deleteButton.isHidden = false
//                    cell.deleteButton.tag = indexPath.row
//                    cell.deleteButton.addTarget(self, action: #selector(deleteButtonAction), for: .touchUpInside)

//                    imageUrlStr =  self.companyProfile!.mediaCompanyImagesArray![indexPath.row]
                }
            case .commodity:
                if self.companyProfile!.mediaCommodityImagesArray != nil {
                    let data = self.companyProfile!.mediaCommodityImagesArray![indexPath.row] as! PictureURL
                    imageUrlStr =  data.images as String
                    
                    self.getPictureUrl = self.companyProfile!.mediaCommodityImagesArray
                    
//                    cell.deleteButton.isHidden = false
//                    cell.deleteButton.tag = indexPath.row
//                    cell.deleteButton.addTarget(self, action: #selector(deleteButtonAction), for: .touchUpInside)

//                    imageUrlStr =  self.companyProfile!.mediaCommodityImagesArray![indexPath.row]
                }
            case .employee:
                if self.companyProfile?.mediaEmployeesImagesArray != nil {
                    let data = self.companyProfile!.mediaEmployeesImagesArray![indexPath.row] as! PictureURL
                    imageUrlStr =  data.images as String
                    
                    self.getPictureUrl = self.companyProfile!.mediaEmployeesImagesArray

//                    imageUrlStr =  self.companyProfile!.mediaEmployeesImagesArray![indexPath.row]
                }
            default:
                imageUrlStr = ""
            }
        
            if imageUrlStr != "" && imageUrlStr != nil {
                cell.companyImageView.setImageWithIndicator(imageURL: imageUrlStr!)
            }
            
            cell.tag = indexPath.row
            let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
            tap.numberOfTapsRequired = 1
            cell.addGestureRecognizer(tap)

        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: ( view.frame.width - 2) / 3, height: view.frame.width / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    @objc func deleteButtonAction(sender: UIButton) {
        let getImageUrl = self.getPictureUrl![sender.tag]
                
        print(getImageUrl.images)
        
        self.showPopUpAlert(title: "Do you want to delete this photo?", message: "", actionTitles: ["No","Yes"], actions: [{action1 in

        },
        {action2 in
            
            if self.companyMediaType == .company {
                if self.companyProfile!.mediaCompanyImagesArray != nil {
                    self.companyProfile!.mediaCompanyImagesArray!.remove(at: sender.tag)
                }
            }
            else if self.companyMediaType == .commodity {
                if self.companyProfile!.mediaCommodityImagesArray != nil {
                    self.companyProfile!.mediaCommodityImagesArray!.remove(at: sender.tag)
                }
            }
//            if getImageUrl.images != "" {
//                self.apiService.deleteCompanyPhotos(companyId: self.companyID, urlStr: getImageUrl.images) { (isSuccess) in
//                    
//                    if isSuccess! {
//                        self.getCompanyDetailsAPI()
//                    }
//                }
//
//            }
        }])
    }
    
   @objc private func handleTap(_ sender: UITapGestureRecognizer){

       let itemIndex = sender.view!.tag
            
       if getPictureUrl != nil {
        guard !(getPictureUrl!.isEmpty) else { return }

        let vc = AlbumVC(index: itemIndex, dataSource: self.getPictureUrl!)
       vc.modalPresentationStyle = .overFullScreen
       self.navigationController?.present(vc, animated: true, completion: nil )
       }

   }
    
    //MARK:- Scroll View Actions

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let delta = scrollView.contentOffset.y - oldContentOffset.y
        
        let topViewCurrentHeightConst = innerTableViewScrollDelegate?.currentHeaderHeight
        
        if let topViewUnwrappedHeight = topViewCurrentHeightConst {
            
            /**
             *  Re-size (Shrink) the top view only when the conditions meet:-
             *  1. The current offset of the table view should be greater than the previous offset indicating an upward scroll.
             *  2. The top view's height should be within its minimum height.
             *  3. Optional - Collapse the header view only when the table view's edge is below the above view - This case will occur if you are using Step 2 of the next condition and have a refresh control in the table view.
             */
            
            if delta > 0,
                topViewUnwrappedHeight > topViewHeightConstraintRange.lowerBound,
                scrollView.contentOffset.y > 0 {
                
                dragDirection = .Up
                innerTableViewScrollDelegate?.innerTableViewDidScroll(withDistance: delta)
                scrollView.contentOffset.y -= delta
            }
            
            /**
             *  Re-size (Expand) the top view only when the conditions meet:-
             *  1. The current offset of the table view should be lesser than the previous offset indicating an downward scroll.
             *  2. Optional - The top view's height should be within its maximum height. Skipping this step will give a bouncy effect. Note that you need to write extra code in the outer view controller to bring back the view to the maximum possible height.
             *  3. Expand the header view only when the table view's edge is below the header view, else the table view should first scroll till it's offset is 0 and only then the header should expand.
             */
            
            if delta < 0,
                // topViewUnwrappedHeight < topViewHeightConstraintRange.upperBound,
                scrollView.contentOffset.y < 0 {
                
                dragDirection = .Down
                innerTableViewScrollDelegate?.innerTableViewDidScroll(withDistance: delta)
                scrollView.contentOffset.y -= delta
            }
        }
        
        oldContentOffset = scrollView.contentOffset
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        //You should not bring the view down until the table view has scrolled down to it's top most cell.
        
        if scrollView.contentOffset.y <= 0 {
            
            innerTableViewScrollDelegate?.innerTableViewScrollEnded(withScrollDirection: dragDirection)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        //You should not bring the view down until the table view has scrolled down to it's top most cell.
        
        if decelerate == false && scrollView.contentOffset.y <= 0 {
            
            innerTableViewScrollDelegate?.innerTableViewScrollEnded(withScrollDirection: dragDirection)
        }
    }
}


extension CompanyModuleMediaVC : CompanyUpdatedServiceDelegate {
    func didReceiveCompanyValues(data: [CompanyItems]) {
        DispatchQueue.main.async {
            
            if let companyData = data.last {
                self.companyProfile = companyData
            }
            
            self.collectionView.reloadData()
        }
    }
    
    func DidReceivedError(error: String) {
        print("Error while getting value in employee liset : \(error)")
    }
}

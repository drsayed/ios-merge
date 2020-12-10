//
//  Helper-EditCompanyAdminViewVC.swift
//  myscrap
//
//  Created by MyScrap on 16/04/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import Foundation
import Gallery
import DKImagePickerController

extension EditCompanyAdminViewVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == typeCollectionView {
            return 6
        } else if collectionView == companyCollectionView {
            return 1
        } else if collectionView == commodityCollectionView {
            return 1
        } else {
            return 1
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == typeCollectionView {
            switch section {
            case 1:
                return businessType.count
            case 3:
                return commodities.count
            case 5:
                return affiliation.count
            default:
                return 1
            }
        } else if collectionView == companyCollectionView {
            
            print("ItemsCount",self.companyProfileImagesArray.count)
            return self.companyProfileImagesArray.count

        } else if collectionView == commodityCollectionView {
            return self.commodityProfileImagesArray.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == typeCollectionView {
            switch indexPath.section {
            case 0:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "headerCell", for: indexPath) as! EditCompanyHeaderCell
                cell.label.text = "Business Type"
                return cell
            case 1:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! EditCompanyCollectionCell
                let i = String(indexPath.item)
                if selectedBusinessType.contains(i) {
                    self.selectCell(cell)
                } else {
                    self.deselectCell(cell)
                }
                cell.label.text = businessType[indexPath.item]
                return cell
            case 2:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "headerCell", for: indexPath) as! EditCompanyHeaderCell
                cell.label.text = "Commodity"
                cell.layoutIfNeeded()
                return cell
            case 3:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! EditCompanyCollectionCell
                cell.label.text = commodities[indexPath.item]
                let i = String(indexPath.item)
                if selectedCommodity.contains(i) {
                    self.selectCell(cell)
                } else {
                    self.deselectCell(cell)
                }
                return cell
            case 4:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "headerCell", for: indexPath) as! EditCompanyHeaderCell
                cell.label.text = "Affiliation"
                cell.layoutIfNeeded()
                return cell
            case 5:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! EditCompanyCollectionCell
                cell.label.text = affiliation[indexPath.item]
                let i = String(indexPath.item)
                if selectedAffiliation.contains(i) {
                    self.selectCell(cell)
                } else {
                    self.deselectCell(cell)
                }
                return cell
            default:
                return UICollectionViewCell()
            }
        } else if collectionView == companyCollectionView {

            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"CompanyAndCommoditiesPhotosCell", for: indexPath) as? CompanyAndCommoditiesPhotosCell {
                
                cell.cellDelegate = self

                let companyPhotosData = self.companyProfileImagesArray[indexPath.item]
                if companyPhotosData.imageType == .fromURL{
                    if let urlString = companyPhotosData.urlString {
                        cell.contentImageView.sd_setImage(with: URL(string: urlString), completed: nil)
                    }
                }
                else if companyPhotosData.imageType == .fromLocal {
                    if let imageData = companyPhotosData.data
                    {
                        cell.contentImageView.image = UIImage(data: imageData)
                    }
                }
                return cell
               }
        } else if collectionView == commodityCollectionView {
            
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"CompanyAndCommoditiesPhotosCell", for: indexPath) as? CompanyAndCommoditiesPhotosCell {
                
                cell.cellDelegate = self

                let companyPhotosData = self.commodityProfileImagesArray[indexPath.item]
                if companyPhotosData.imageType == .fromURL{
                    if let urlString = companyPhotosData.urlString {
                        cell.contentImageView.sd_setImage(with: URL(string: urlString), completed: nil)
                    }
                }
                else if companyPhotosData.imageType == .fromLocal {
                    if let imageData = companyPhotosData.data
                    {
                        cell.contentImageView.image = UIImage(data: imageData)
                    }
                }
                return cell
            }
            else {
                return UICollectionViewCell()

            }
        }
        
        return UICollectionViewCell()

    }
        
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellWidth = self.view.frame.width / 3 - 20

        if collectionView == typeCollectionView {
            let label = UILabel()
            label.font = Fonts.DESIG_FONT
            
            switch indexPath.section {
                
            case 1:
                label.text = COMPANY_BUSINESS_TYPE_ARRAY[indexPath.item]
                return CGSize(width: label.intrinsicContentSize.width + 20, height: 40)
                
            case 3:
                label.text = COMPANY_COMMODITY_ARRAY[indexPath.item]
                return CGSize(width: label.intrinsicContentSize.width + 20, height: 40)
                
            case 5:
                label.text = COMPANY_AFFILIATION_ARRAY[indexPath.item]
                return CGSize(width: label.intrinsicContentSize.width + 20, height: 40)
                
            default:
                return CGSize(width: self.view.frame.width, height: 35)
            }
        } else if collectionView == companyCollectionView {
            
            return CGSize(width: cellWidth, height: 70) //CGSize(width: 106, height: 70)
        } else  if collectionView == commodityCollectionView {
            return CGSize(width: cellWidth, height: 70)
        } else {
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if collectionView == typeCollectionView {
            if section == 1 || section == 3 || section == 5{
                return UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
                
            } else {
                return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
            }
        } else {
             return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {

        let cellWidth = self.view.frame.width / 3 - 20

        if collectionView == self.companyCollectionView || collectionView == self.commodityCollectionView {
            return CGSize(width: cellWidth, height: 70)
        }
        else {
            return CGSize(width: 0, height: 0)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//
        if collectionView == self.companyCollectionView {
            if kind == UICollectionView.elementKindSectionFooter {
                let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "AddMoreFooterViewIdentifier", for: indexPath) as! AddMoreFooterCollectionResuableView
                
                footerView.contentBackgroundView.tag = 11
                
                footerView.viewDelegate = self
                
                return footerView
            }
        }
        else if collectionView == self.commodityCollectionView {
            if kind == UICollectionView.elementKindSectionFooter {
                let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "AddMoreFooterViewIdentifier", for: indexPath) as! AddMoreFooterCollectionResuableView
                
                footerView.contentBackgroundView.tag = 22
                
                footerView.viewDelegate = self
                
                return footerView
            }
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == typeCollectionView {
            let i = String(indexPath.item)
            if let cell = collectionView.cellForItem(at: indexPath) as? EditCompanyCollectionCell, indexPath.section == 1 {
                if selectedBusinessType.contains(i){
                    animateDeselect(cell)
                    if let index = selectedBusinessType.index(of: i){
                        selectedBusinessType.remove(at: index)
                    }
                } else {
                    animateSelect(cell)
                    selectedBusinessType.append(i)
                }
            }
            
            if let cell = collectionView.cellForItem(at: indexPath) as? EditCompanyCollectionCell, indexPath.section == 3 {
                if selectedCommodity.contains(i){
                    animateDeselect(cell)
                    if let index = selectedCommodity.index(of: i){
                        selectedCommodity.remove(at: index)
                    }
                } else {
                    animateSelect(cell)
                    selectedCommodity.append(i)
                }
            }
            if let cell = collectionView.cellForItem(at: indexPath) as? EditCompanyCollectionCell, indexPath.section == 5{
                if selectedAffiliation.contains(i){
                    animateDeselect(cell)
                    if let index = selectedAffiliation.index(of: i){
                        selectedAffiliation.remove(at: index)
                    }
                } else {
                    animateSelect(cell)
                    selectedAffiliation.append(i)
                }
            }
        } else if collectionView == companyCollectionView {
            
           /* if !companyItems!.companyImages!.isEmpty && companyItems!.companyImages!.count < 10 {
                Config.tabsToShow = [.imageTab]
                Config.Camera.imageLimit = 10 - companyItems!.companyImages!.count
                self.present(self.companyGallery, animated: true, completion: nil)
            } else {
                Config.tabsToShow = [.imageTab]
                Config.Camera.imageLimit = 10
                self.present(self.companyGallery, animated:  true, completion: nil)
            } */
        } else if collectionView == commodityCollectionView {
            
           /* if !companyItems!.commodityImages.isEmpty && companyItems!.commodityImages.count < 10 {
                Config.tabsToShow = [.imageTab]
                Config.Camera.imageLimit = 10 - companyItems!.commodityImages.count
                self.present(self.commodityGallery, animated:  true, completion: nil)
            } else {
                Config.tabsToShow = [.imageTab]
                Config.Camera.imageLimit = 10
                self.present(self.commodityGallery, animated:  true, completion: nil)
            } */
        } else {
            
        }
        
    }

    //MARK:- Call Image Picker Controller
    func callCompanyDKImagePickerController() {
        
        var selectMaximumSelectableCount = 10
        
        if self.companyProfileImagesArray.count > 0 {
            selectMaximumSelectableCount = selectMaximumSelectableCount - self.companyProfileImagesArray.count
        }
        self.companyPhotosPickerController = DKImagePickerController()
        self.companyPhotosPickerController.assetType = .allPhotos
        self.companyPhotosPickerController.maxSelectableCount=selectMaximumSelectableCount;
        self.companyPhotosPickerController.showsCancelButton = true;
        self.companyPhotosPickerController.showsEmptyAlbums = false;
        self.companyPhotosPickerController.allowMultipleTypes = false;
//        self.companyPhotosPickerController.defaultSelectedAssets = self.companyAssetImages;
        self.companyPhotosPickerController.didSelectAssets = { (assets: [DKAsset]) in
            
            for (index, asset) in assets.enumerated() {
                asset.fetchOriginalImage(completeBlock: { image, info in
                    if let img = image {
                        if let companyData = img.jpegData(compressionQuality: 0.4) {
                            self.companyProfileImagesArray.append(CompanyPhotos(imageType: .fromLocal, data: companyData))
                        }
                        if index == (assets.count-1) {
                            self.companyView.isHidden = true
                            self.companyCollectionView.reloadData()
                        }
                    }
                })
            }
        }
        self.companyPhotosPickerController.modalPresentationStyle = .overFullScreen
        self.companyPhotosPickerController.didCancel = {
        }
        self.present(self.companyPhotosPickerController, animated: true, completion: nil)

    }
    
    
    func callCommodityDKImagePickerController() {
        var selectMaximumSelectableCount = 10
        
        if self.commodityProfileImagesArray.count > 0 {
            selectMaximumSelectableCount = selectMaximumSelectableCount - self.commodityProfileImagesArray.count
        }

        self.commodityPhotosPickerController = DKImagePickerController()
        self.commodityPhotosPickerController.assetType = .allPhotos
        self.commodityPhotosPickerController.maxSelectableCount = selectMaximumSelectableCount;
        self.commodityPhotosPickerController.showsCancelButton = true;
        self.commodityPhotosPickerController.showsEmptyAlbums = false;
        self.commodityPhotosPickerController.allowMultipleTypes = false;
//        self.commodityPhotosPickerController.defaultSelectedAssets = self.commodityAssetImages;
        self.commodityPhotosPickerController.didSelectAssets = { (assets: [DKAsset]) in
            
            for (index, asset) in assets.enumerated() {
                asset.fetchOriginalImage(completeBlock: { image, info in
                    if let img = image {
                        if let commodityData = img.jpegData(compressionQuality: 0.4) {
                            self.commodityProfileImagesArray.append(CompanyPhotos(imageType: .fromLocal, data: commodityData))
                        }
                        if index == (assets.count-1) {
                            self.commodityView.isHidden = true
                            self.commodityCollectionView.reloadData()
                        }
                    }
                })
            }
        }
        self.commodityPhotosPickerController.modalPresentationStyle = .overFullScreen
        self.commodityPhotosPickerController.didCancel = {
          
        }
        self.present(self.commodityPhotosPickerController, animated: true, completion: nil)

    }

    func selectCell(_ cell : EditCompanyCollectionCell){
        cell.label.textColor = UIColor.WHITE_ALPHA
        cell.view.backgroundColor = UIColor.MyScrapGreen
    }
    
    func deselectCell(_ cell: EditCompanyCollectionCell){
        cell.view.backgroundColor = UIColor.WHITE_ALPHA
        cell.label.textColor = UIColor.MyScrapGreen
    }
    
    
    func animateSelect(_ cell: EditCompanyCollectionCell){
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            cell.label.textColor = UIColor.WHITE_ALPHA
            cell.view.backgroundColor = UIColor.GREEN_PRIMARY
        }) { (cmp) in
            self.typeCollectionView.reloadData()
        }
    }
    
    func animateDeselect(_ cell: EditCompanyCollectionCell){
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            cell.label.textColor = UIColor.BLACK_ALPHA
            cell.view.backgroundColor = UIColor.WHITE_ALPHA
        }) { (cmp) in
            self.typeCollectionView.reloadData()
        }
    }
}

extension EditCompanyAdminViewVC : CloseCellButtonDelegate, AddMoreButtonDelegate {
    
    func didAddMoreButtonTapped(_ view: AddMoreFooterCollectionResuableView) {

        if view.contentBackgroundView.tag == 11 {
            if self.companyProfileImagesArray.count < 10 {
                self.callCompanyDKImagePickerController()
            }
            else {
                self.showAlert(message: "Cannot select more than 10 images")
            }
        }
        else if view.contentBackgroundView.tag == 22 {
            if self.commodityProfileImagesArray.count < 10 {
                self.callCommodityDKImagePickerController()
            }
            else {
                self.showAlert(message: "Cannot select more than 10 images")
            }

        }
        
    }
    
    func didCloseButtonTapped(_ cell: CompanyAndCommoditiesPhotosCell) {
        
        if let indexPath = self.companyCollectionView.indexPath(for: cell) {

            print("MyIndex",indexPath.item)
            
            let companyPhotosData = self.companyProfileImagesArray[indexPath.item]
            
            if companyPhotosData.imageType == .fromURL {
                
                if let urlString = companyPhotosData.urlString {
                    
                    self.showPopUpAlert(title: "", message: "Are you sure you want to delete this photo", actionTitles: ["NO","YES"], actions: [{ (action) in
                    },
                    {action2 in
                        if  self.companyProfileImagesArray.count > 1 {
                            self.deleteCompanyPhotosAPI(urlStr:urlString, index:indexPath.item, isFromCompany: true)
                        }
                        else {
                            self.showAlert(message: "Should atleast one logo")
                        }
                    }])
                }
            }
            else if companyPhotosData.imageType == .fromLocal {
                
                if let imageData = companyPhotosData.data {
                    self.showPopUpAlert(title: "", message: "Are you sure you want to delete this photo", actionTitles: ["NO","YES"], actions: [{ (action) in
                    },
                    {action2 in
                        if  self.companyProfileImagesArray.count > 1 {
                            self.companyProfileImagesArray.remove(at: indexPath.item)
                            self.companyCollectionView.reloadData()
                        }
                        else {
                            self.showAlert(message: "Should atleast one logo")
                        }
                    }])
                }
            }
        }
        
        if let indexPath = self.commodityCollectionView.indexPath(for: cell) {

            let commodityPhotosData = self.commodityProfileImagesArray[indexPath.item]
            
            if commodityPhotosData.imageType == .fromURL {
                
                if let urlString = commodityPhotosData.urlString {
                    
                    self.showPopUpAlert(title: "", message: "Are you sure you want to delete this photo", actionTitles: ["NO","YES"], actions: [{ (action) in
                    },
                    {action2 in
                        self.deleteCompanyPhotosAPI(urlStr:urlString, index:indexPath.item, isFromCompany: false)
                    }])
                }
            }
            else if commodityPhotosData.imageType == .fromLocal {
                
                if let imageData = commodityPhotosData.data {
                    self.showPopUpAlert(title: "", message: "Are you sure you want to delete this photo", actionTitles: ["NO","YES"], actions: [{ (action) in
                    },
                    {action2 in
                        self.commodityProfileImagesArray.remove(at: indexPath.item)
                        self.commodityCollectionView.reloadData()
                    }])
                }
            }
        }

    }
    
    //MARK:- delete Company Photos API
    func deleteCompanyPhotosAPI(urlStr : String,
                                index:Int,
                                isFromCompany:Bool) {
        
        self.service.deleteCompanyPhotos(companyId: self.companyId!, urlStr: urlStr) { (isSuccess) in

            if isSuccess! {

                DispatchQueue.main.async {
                    
                    if isFromCompany {
                        print("Before delete Company photos",self.companyProfileImagesArray.count)

                        if self.companyProfileImagesArray.count > index {
                            self.companyProfileImagesArray.remove(at: index)
                        }
                        self.companyCollectionView.reloadData()
                        print("After delete Company photos",self.companyProfileImagesArray.count)
                    }
                    else {
                        print("Before delete commodity photos",self.commodityProfileImagesArray.count)
                        
                        if self.commodityProfileImagesArray.count > index {
                            self.commodityProfileImagesArray.remove(at: index)
                        }
                        self.commodityCollectionView.reloadData()
                        print("After delete commodity photos",self.commodityProfileImagesArray.count)
                    }
                }
            }
        }
    }
}

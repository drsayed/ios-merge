//
//  CompanyPhotosVC.swift
//  myscrap
//
//  Created by MyScrap on 6/19/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit

class CompanyPhotosVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noPhotosLbl: UILabel!
    
    var service = CompanyUpdatedService()
    var dataSource = [CompanyItems]()
    weak var delegate: CompanyUpdatedServiceDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        service.delegate = self
        let companyId = UserDefaults.standard.object(forKey: "companyId") as? String
        service.getCompanyDetails(companyId: companyId!)
        setupCollectionView()
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(PhotoGridCell.Nib, forCellWithReuseIdentifier: PhotoGridCell.identifier)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if dataSource.last?.companyImages.count != nil {
            noPhotosLbl.isHidden = true
            return (dataSource.last?.companyImages.count)!
        } else {
            noPhotosLbl.isHidden = false
            return 0
        }
        
        //return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoGridCell.identifier, for: indexPath) as? PhotoGridCell else { return UICollectionViewCell() }
        //cell.configCell(datasource[indexPath.item])
        cell.profilePicCell(url: (dataSource.last?.companyImages[indexPath.item])!)
        cell.delegate = self
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension CompanyPhotosVC : CompanyUpdatedServiceDelegate {
    func didReceiveCompanyValues(data: [CompanyItems]) {
        DispatchQueue.main.async {
            self.dataSource = data
            self.collectionView.reloadData()
            
        }
    }
    
    func DidReceivedError(error: String) {
        print("Fetching photo error : \(error)")
    }
}
extension CompanyPhotosVC: PhotoGridDelegate{
    func DidTapImageView(cell: PhotoGridCell) {
        if let indexPath = collectionView.indexPathForItem(at: cell.center){
            
            if let vc = ScrollableImageVC.storyBoardInstance(){
                vc.image = dataSource.last?.companyImages[indexPath.row]
                self.present(vc, animated: true, completion: nil)
            }
        }
        
        /*if let indexPath = collectionView.indexPathForItem(at: cell.center){
         //toImageVC(indexPath)
         
         }*/
    }
}

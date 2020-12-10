//
//  InvitationVC.swift
//  myscrap
//
//  Created by MS1 on 1/8/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import Foundation

class InvitationVC: UPComingVC{
    
    private var isInitiallyLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        collectionView.register(EmptyStateView.nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: EmptyStateView.id)
    }
    
    override func getEvents() {
        EventItem.getInvitedEvents { (success, error, dataSource) in
            DispatchQueue.main.async {
                if self.activityIndicatorView.isAnimating {
                    self.activityIndicatorView.stopAnimating()
                }
                if self.refreshControl.isRefreshing{
                    self.refreshControl.endRefreshing()
                }
                self.isInitiallyLoaded = true
                self.dataSource = dataSource
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let data = dataSource , data.isEmpty  else {
            return CGSize.zero
        }
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: EmptyStateView.id, for: indexPath) as! EmptyStateView
        cell.textLbl.text = "No Invited Events"
        cell.imageView.image = #imageLiteral(resourceName: "ic_no_invitation")
        return cell
    }
    
}

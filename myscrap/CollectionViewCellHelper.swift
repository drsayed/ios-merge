//
//  CollectionViewCellHelper.swift
//  myscrap
//
//  Created by Hassan Jaffri on 12/31/20.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import Foundation
import UIKit
final class CheckCellStatus {
    static func PauseCellifNededOnFeedPage (cell : UICollectionViewCell)
    {
        
        
        if let portrateCell = cell as? EmplPortraitVideoCell {
            for videoCell in portrateCell.videosCollection.visibleCells  as! [PortraitVideoCell]    {
              
                videoCell.playerView.isMuted = true
               
                videoCell.pause()

          }
        }
        else if let portrateCell = cell as? EmplPortrVideoTextCell {
             
                for videoCell in portrateCell.videosCollection.visibleCells  as! [PortraitVideoCell]    {
                
                    videoCell.playerView.isMuted = true
                    videoCell.pause()
  
            }
        }
        else if let portrateCell = cell as? LandScapVideoCell {
             
                for videoCell in portrateCell.videosCollection.visibleCells  as! [LandScapCell]    {
                
                   videoCell.playerView.isMuted = true

                    videoCell.pause()
    
            }
        }
        else if let portrateCell = cell as? LandScapVideoTextCell {
             
                for videoCell in portrateCell.videosCollection.visibleCells  as! [LandScapCell]    {
                
                    videoCell.playerView.isMuted = true
                    videoCell.pause()
   
            }
        }
    }
    static func PlayVideoifNededOnFeedPage (index : IndexPath)
    {
        let muteImg = #imageLiteral(resourceName: "mute-60x60")
        let tintMuteImg = muteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        
        let unMuteImg = #imageLiteral(resourceName: "unmute-60x60")
        let tintUnmuteImg = unMuteImg.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
     var muteVideo : Bool = false
    }
}

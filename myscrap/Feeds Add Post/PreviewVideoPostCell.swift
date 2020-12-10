//
//  PreviewVideoPostCell.swift
//  myscrap
//
//  Created by MyScrap on 2/5/20.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class PreviewVideoPostCell: BaseCell {

    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var playPauseBtn: UIButton!
    
    @IBOutlet weak var deleteImage: UIButton!
    
    @IBOutlet weak var addMorePhotosButton: UIButton!
    @IBOutlet weak var addMorePhotos: UIView!
    
    var playPauseBntAction : ( () -> Void)? = nil
    
    var player = AVPlayer()
    var showVideo = URL(string: "")
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        player = AVPlayer(playerItem: nil)
        /*if let video = showVideo {
            player.replaceCurrentItem(with: AVPlayerItem(url: video))
        }*/
        
    }
    
    func setupVideoLayer(videoUrl: URL) {
        
        player.replaceCurrentItem(with: AVPlayerItem(url: videoUrl))
        /*if let video = showVideo {
            player.replaceCurrentItem(with: AVPlayerItem(url: video))
        }*/
        
        //2. Create AVPlayer object
        //let asset = AVAsset(url: showVideo!)
        //let playerItem = AVPlayerItem(asset: asset)
        //player = AVPlayer(playerItem: playerItem)
        
        //3. Create AVPlayerLayer object
        let playerLayer = AVPlayerLayer(player: player)
        //playerLayer.frame = self.videoView.bounds //bounds of the view in which AVPlayer should be displayed
        playerLayer.frame = contentView.frame
        playerLayer.videoGravity = .resizeAspectFill
        
        //4. Add playerLayer to view's layer
        self.videoView.layer.addSublayer(playerLayer)
        
        //NotificationCenter.default.addObserver(self, selector: #selector(videoDidEnd), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    @objc func videoDidEnd(notification: NSNotification) {
        print("video ended")
        playPauseBtn.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        player.seek(to: CMTime.zero)
        playPauseBtn.tag = 0
        //player.play()
    }
    
    @IBAction func playBtnTapped(_ sender: UIButton) {
        
        if sender.tag == 0 {
            
            playPauseBtn.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            
            //5. Play Video
            player.play()
            sender.tag = 1
            playPauseBntAction?()
        } else {
            playPauseBtn.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            sender.tag = 0
            player.pause()
            playPauseBntAction?()
        }
    }
}

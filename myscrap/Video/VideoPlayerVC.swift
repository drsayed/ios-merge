//
//  VideoPlayerVC.swift
//  myscrap
//
//  Created by MyScrap on 2/3/20.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class VideoPlayerVC: UIViewController {

    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var cameraView: CircleView!
    
    let picker = UIImagePickerController()
    
    var player = AVPlayer()
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }

        if let url = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4") {
            //2. Create AVPlayer object
            let asset = AVAsset(url: url)
            let playerItem = AVPlayerItem(asset: asset)
            player = AVPlayer(playerItem: playerItem)
            
            //3. Create AVPlayerLayer object
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = self.videoView.bounds //bounds of the view in which AVPlayer should be displayed
            playerLayer.videoGravity = .resizeAspect
            
            //4. Add playerLayer to view's layer
            self.videoView.layer.addSublayer(playerLayer)
            
            NotificationCenter.default.addObserver(self, selector: #selector(videoDidEnd), name:
                NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
            
            
            
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    @objc func videoDidEnd(notification: NSNotification) {
        print("video ended")
        playBtn.setImage(#imageLiteral(resourceName: "play"), for: .normal)
        player.seek(to: CMTime.zero)
        playBtn.tag = 0
        //player.play()
    }
    
    @IBAction func playVideoBtnTapped(_ sender: UIButton) {
        if sender.tag == 0 {
            
            playBtn.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            
            //5. Play Video
            player.play()
            sender.tag = 1
        } else {
            playBtn.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            sender.tag = 0
            player.pause()
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //let url = URL(string: "http://myscrap.com/style/video/samsung-galaxy-s3-30-seconds-sample-video.mp4")!
        
        //playVideo(url: url)
    }
    
    func playVideo(url: URL) {
        let player = AVPlayer(url: url)
        
        let vc = AVPlayerViewController()
        vc.player = player
        
        self.present(vc, animated: true) { vc.player?.play() }
    }
    
    static func storyBoardInstance() -> VideoPlayerVC?{
        let st = UIStoryboard.LAND
        return st.instantiateViewController(withIdentifier: VideoPlayerVC.id) as? VideoPlayerVC
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

/*
 Reference for video upload
 */
/*do {
 let data = try Data(contentsOf: videoUrl, options: .mappedIfSafe)
 print(data)
 //  here you can see data bytes of selected video, this data object is upload to server by multipartFormData upload
 //let fileURL = Bundle.main.url(forResource: "video", withExtension: "mp4")!
 Alamofire.upload(data, to: "https://myscrap.com/video/upload_file?userId=\(AuthService.instance.userId)", method: .post, headers: nil).uploadProgress { progress in
 print("Upload Progress: \(progress.fractionCompleted)")
 }
 .responseJSON { response in
 debugPrint(response.response)
 }
 } catch  {
 
 }*/
/*
 // upload event
 func uploadMedia(videoUrl: URL){
 let service = APIService()
 let path = "https://myscrap.com/video/upload_video"
 /*service.getMultipartData(with: path, params: "userId:\(AuthService.instance.userId)", media: media!) { (result) in
 switch result{
 case .Success(_):
 DispatchQueue.main.async {
 completion(true)
 }
 case .Error(_):
 DispatchQueue.main.async {
 completion(false)
 }
 }
 }*/
 let url = URL(string: path)
 var request = URLRequest(url: url!)
 let boundary = generateBoundary()
 
 request.httpMethod = "POST"
 request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
 
 var movieData: Data?
 do {
 movieData = try Data(contentsOf: videoUrl, options: Data.ReadingOptions.alwaysMapped)
 } catch _ {
 movieData = nil
 return
 }
 
 var body = Data()
 
 // change file name whatever you want
 let filename = "upload.mov"
 let mimetype = "video/mov"
 
 body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
 body.append("Content-Disposition:form-data; name=\"content\"; filename=\"\(filename)\"\r\n".data(using: String.Encoding.utf8)!)
 body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
 body.append(movieData!)
 request.httpBody = body
 
 let task = URLSession.shared.dataTask(with: request) { (data: Data?, reponse: URLResponse?, error: Error?) in
 if let `error` = error {
 print(error)
 return
 }
 if let `data` = data {
 //print(String(data: data, encoding: String.Encoding.utf8))
 print("Response : \(reponse)")
 }
 }
 
 task.resume()
 }
 
 private func generateBoundary() -> String {
 return "Boundary-\(NSUUID().uuidString)"
 }*/

//
//  BGWallListView.swift
//  myscrap
//
//  Created by MyScrap on 7/8/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit

class BGWallListView: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var closeBtn: UIButton!
    
    var delegate: BGWallListDelegate?
    
    let cellIds = ["bg_one","bg_two","bg_three","bg_four"]
    let cellSizes = Array(repeatElement(CGSize(width:100, height:150), count: 5))
    let image = ["live_bg_img", "live_bg_img_02", "live_bg_img_03", "live_bg_img_04"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        setupView()
        animateView()
//        topView.layer.borderWidth = 1
//        topView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func setupView() {
        alertView.layer.cornerRadius = 15
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    func animateView() {
        alertView.alpha = 0;
        self.alertView.frame.origin.y = self.alertView.frame.origin.y + 50
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.alertView.alpha = 1.0;
            self.alertView.frame.origin.y = self.alertView.frame.origin.y - 50
        })
    }
    
    @IBAction func closeBtnTapped(_ sender: UIButton) {
        delegate?.cancelButtonTapped()
        BGWallListView().dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellIds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIds[indexPath.item], for: indexPath)
        let imageview:UIImageView=UIImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 150));
        imageview.contentMode = .scaleAspectFill
        let img : UIImage = UIImage(named:image[indexPath.item])!
        imageview.image = img
        cell.contentView.addSubview(imageview)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSizes[indexPath.item]
    }
    
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("User tapped on \(cellIds[indexPath.row])")
        //call api to send bg image
        let spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
        spinner.mode = MBProgressHUDMode.indeterminate
        spinner.label.text = "Wallpaper updating..."
        let service = APIService()
        service.endPoint = Endpoints.BG_WALL_SET
        
        let imageData: Data = UIImage(named: image[indexPath.item])!.jpegData(compressionQuality: 0.9)!
        let imageString =  imageData.base64EncodedString(options: .lineLength64Characters)
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&bgImage=\(imageString)".replacingOccurrences(of: "+", with: "%2B")
        service.getDataWith(completion: { (result) in
            switch result{
            case .Success(let dict):
                DispatchQueue.main.async {
                    print("Uploaded background wall \(dict)")
                    self.getBackgroundWall()
                    self.delegate?.uploadDone(status: true)
                    MBProgressHUD.hide(for: self.view, animated: true)
                    self.dismiss(animated: true, completion: nil)
                }
            case .Error(let error):
                DispatchQueue.main.async {
                    self.delegate?.uploadDone(status: false)
                    MBProgressHUD.hide(for: self.view, animated: true)
                    let alert = UIAlertController(title: "Failed", message: "Failed to upload Background Wall" + error, preferredStyle: .alert)
                    alert.view.tintColor = UIColor.GREEN_PRIMARY
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        })
    }
    
    func getBackgroundWall(){
        let service = APIService()
        service.endPoint = Endpoints.BG_WALL_GET
        
        service.params = "apiKey=\(API_KEY)"
        service.getDataWith(completion: { (result) in
            switch result{
            case .Success(let dict):
                DispatchQueue.main.async {
                    if let data = dict["data"] as? [String: AnyObject]{
                        if let bgImage = data["bgImage"] as? String {
                            self.delegate?.getBGWall(image: bgImage)
                        }
                    }
                }
            case .Error(let error):
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Failed", message: "Failed to fetch background live" + error, preferredStyle: .alert)
                    alert.view.tintColor = UIColor.GREEN_PRIMARY
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        })
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

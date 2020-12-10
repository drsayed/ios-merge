//
//  ChangePhotoVC.swift
//  myscrap
//
//  Created by MyScrap on 7/1/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit
import SDWebImage

class ChangePhotoVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    let picker = UIImagePickerController()
    var image : UIImage!
    
    
    @IBOutlet weak var imageView: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        //imageView.image = image
        if AuthService.instance.bigProfilePic != "" {
            imageView.sd_setImage(with: URL(string: AuthService.instance.bigProfilePic!), completed: nil)
        } else {
            imageView.image = image
        }
        picker.delegate = self
        picker.allowsEditing = true
        
    }
    
    @IBAction func uploadPhoto(_ sender: UIBarButtonItem) {
        let spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
        spinner.mode = MBProgressHUDMode.indeterminate
        spinner.label.text = "Uploading"
        let service = APIService()
        service.endPoint = Endpoints.EDIT_PROFILE_PIC_URL
        
        let imageData: Data = imageView.image!.jpegData(compressionQuality: 0.6)!
        let imageString =  imageData.base64EncodedString(options: .lineLength64Characters)
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&profilePic=\(imageString)".replacingOccurrences(of: "+", with: "%2B")
        service.getDataWith(completion: { (result) in
            switch result{
            case .Success(let dict):
                DispatchQueue.main.async {
                    if let editProfileData = dict["HdEditProfileData"] as? String{
                        let edit = editProfileData.replacingOccurrences(of: "/style/images/user_profile", with: "")
                        print("HD image edit : \(edit)")
                        AuthService.instance.bigProfilePic = edit
                    }
                    if let profilePic = dict["EditProfileData"] as? String {
                        AuthService.instance.profilePic = profilePic
                    }
                    print("Profile image in change photo vc :\(AuthService.instance.profilePic)")
                    MBProgressHUD.hide(for: self.view, animated: true)
                    let alert = UIAlertController(title: "Success", message: "Profile Photo updated successfully!!", preferredStyle: .alert)
                    alert.view.tintColor = UIColor.GREEN_PRIMARY
                    alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action) in
                        alert.dismiss(animated: true, completion: nil)
                        //self.pushViewController(storyBoard: StoryBoard.PROFILE, Identifier: EditProfileController.id, checkisGuest: AuthStatus.instance.isGuest)
                        let vc = EditProfileController.storyBoardInstance()!
                        let rearViewController = MenuTVC()
                        let frontNavigationController = UINavigationController(rootViewController: vc)
                        let mainRevealController = SWRevealViewController()
                        mainRevealController.rearViewController = rearViewController
                        mainRevealController.frontViewController = frontNavigationController
                        self.present(mainRevealController, animated: true, completion: {
                            //NotificationCenter.default.post(name: .userSignedIn, object: nil)
                        })
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                
            case .Error(let error):
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Failed", message: "Failed to upload profile picture" + error, preferredStyle: .alert)
                    alert.view.tintColor = UIColor.GREEN_PRIMARY
                    alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        })
    }
    
    fileprivate func pushViewController(storyBoard: String,  Identifier: String,checkisGuest: Bool = false){
        guard !checkisGuest else {
            self.showGuestAlert(); return
        }
        let vc = UIStoryboard(name: storyBoard , bundle: nil).instantiateViewController(withIdentifier: Identifier)
        let nav = UINavigationController(rootViewController: vc)
        revealViewController().pushFrontViewController(nav, animated: true)
    }
    
    //MARK: -UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        
        var image : UIImage!
        if let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        {
            image = img
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            
        }
        else if let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            image = img
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
        }
        picker.dismiss(animated: true,completion: nil)
    }
    
    //MARK: -PickImage
    
    @IBAction func album(_ sender: UIBarButtonItem)
    {
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
    }
    
    //MARK: -UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: -ShootImage
    
    @IBAction func shoot(_ sender: UIBarButtonItem)
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {  picker.sourceType = UIImagePickerController.SourceType.camera
            picker.cameraCaptureMode =  UIImagePickerController.CameraCaptureMode.photo
            picker.modalPresentationStyle = .custom
            present(picker,animated: true,completion: nil)
        }
        else
        {
            nocamera()
        }
    }
    func nocamera()
    {
        let alertVC = UIAlertController(title: "No Camera",message: "Sorry, this device has no camera",preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK",style:.default,handler: nil)
        alertVC.addAction(okAction)
        present(alertVC,animated: true,completion: nil)
    }

    static func storyBoardInstance() -> ChangePhotoVC? {
        let st = UIStoryboard(name: StoryBoard.PROFILE, bundle: nil)
        return st.instantiateViewController(withIdentifier: ChangePhotoVC.id) as? ChangePhotoVC
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
extension UIImageView
{
    func imageFrame()->CGRect
    {
        let imageViewSize = self.frame.size
        guard let imageSize = self.image?.size else
        {
            return CGRect.zero
        }
        let imageRatio = imageSize.width / imageSize.height
        let imageViewRatio = imageViewSize.width / imageViewSize.height
        if imageRatio < imageViewRatio
        {
            let scaleFactor = imageViewSize.height / imageSize.height
            let width = imageSize.width * scaleFactor
            let topLeftX = (imageViewSize.width - width) * 0.5
            return CGRect(x: topLeftX, y: 0, width: width, height: imageViewSize.height)
        }
        else
        {
            let scalFactor = imageViewSize.width / imageSize.width
            let height = imageSize.height * scalFactor
            let topLeftY = (imageViewSize.height - height) * 0.5
            return CGRect(x: 0, y: topLeftY, width: imageViewSize.width, height: height)
        }
    }
}
extension UIImage
{
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage
    {
        let size = image.size
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        var newSize: CGSize
        if(widthRatio > heightRatio)
        {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        }
        else
        {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
class CropView: UIView {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    override func point(inside point: CGPoint, with event:   UIEvent?) -> Bool {
        return false
    }
}

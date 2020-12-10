//
//  MainSignUpVC.swift
//  myscrap
//
//  Created by MyScrap on 4/10/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit
import FlagPhoneNumber

class MainSignUpVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var profileIV: UIImageView!
    @IBOutlet weak var addProfileBtn: UIButton!
    @IBOutlet weak var countryCodeTF: FPNTextField!
    @IBOutlet weak var mobileNoTF: ACFloatingTextfield!
    @IBOutlet weak var signUpBtn: CorneredButton!
    
    var firstName = ""
    var lastName = ""
    var email = ""
    var pwd = ""
    var counCode = ""
    var mobileText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        print("First Name : \(firstName), Last Name : \(lastName), Email : \(email), Pwd : \(pwd)")
        //AuthService.instance.delegate = self
        hideKeyboardWhenTappedAround()
        mobileNoTF.delegate = self
        countryCodeTF.delegate = self
        countryCodeTF.setBottomBorder()
        countryCodeTF.parentViewController = self
        countryCodeTF.phoneCodeTextField.text = "+971" + " ▼"
        countryCodeTF.setFlag(for: FPNCountryCode(rawValue: "AE")!)
    }
    
    @IBAction func addProfileTapped(_ sender: UIButton) {
        let croppingParameters = CroppingParameters(isEnabled: true, allowResizing: false, allowMoving: true, minimumSize: CGSize.zero)
        let cameraViewController = CameraViewController.imagePickerViewController(croppingParameters: croppingParameters) { [weak self](image, asset) in
            if let img = image {
                self?.profileIV.image = img
            }
            self?.dismiss(animated: true, completion: nil)
        }
        present(cameraViewController, animated: true, completion: nil)
    }
    
    @IBAction func signpBtnTapped(_ sender: UIButton) {
        _ = mobileNoTF.resignFirstResponder()
        guard let mobile = mobileNoTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) , mobile != "" else { mobileNoTF.showErrorWithText(errorText: "Enter Mobile number");  return }
        guard let validate = mobileNoTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) , validate != "" else { mobileNoTF.showErrorWithText(errorText: "Enter Mobile number");  return }
        
//        let reachability = Reachability()!
//        if reachability.connection != .none{
            self.showActivityIndicator(with: "Loading...")
            self.signUpBtn.isEnabled = false
            
            mobileText = mobileNoTF.text!
            addProfileImageAPI()
//        }
        
    }
    
    func addProfileImageAPI() {
        let service = APIService()
        service.endPoint = Endpoints.EDIT_PROFILE_PIC_URL
        let img_name = UIImage(named: "noprofile")
        if profileIV.image == img_name {
            DispatchQueue.main.async {
                self.hideActivityIndicator()
            }
            
            let alert = UIAlertController(title: "Choose the Profile photo to upload", message: nil, preferredStyle: .alert)
            alert.view.tintColor = UIColor.GREEN_PRIMARY
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
            self.signUpBtn.isEnabled = true
        } else {
            DispatchQueue.main.async {
                self.hideActivityIndicator()
            }
            let imageData: Data = profileIV.image!.jpegData(compressionQuality: 0.6)!
            let imageString =  imageData.base64EncodedString(options: .lineLength64Characters)
            service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&profilePic=\(imageString)".replacingOccurrences(of: "+", with: "%2B")
            service.getDataWith(completion: { (result) in
            
                switch result{
                case .Success(let dict):
                    DispatchQueue.main.async {
                        if AuthService.instance.isDeviceRegistered{
                            AuthService.instance.signUpUser(mail: self.email, pwd: self.pwd, fname: self.firstName, lname: self.lastName, ccode: self.counCode, mobile: self.mobileText)
//                            AuthService.instance.signUpUser(mail: self.email, pwd: self.pwd, fname: self.firstName, lname: self.lastName, ccode: self.counCode, mobile: self.mobileNoTF.text!)
                        } else {
                            AuthService.instance.deviceRegistration { _ in
                                if AuthService.instance.isDeviceRegistered{
//                                    AuthService.instance.signUpUser(mail: self.email, pwd: self.pwd, fname: self.firstName, lname: self.lastName, ccode: self.counCode, mobile: self.mobileNoTF.text!)
                                    AuthService.instance.signUpUser(mail: self.email, pwd: self.pwd, fname: self.firstName, lname: self.lastName, ccode: self.counCode, mobile: self.mobileText)
                                }
                            }
                        }
                    }
                case .Error(_):
                    print("Error while uploading image")
                }
                
            })
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == mobileNoTF{
            let maxLength = 10
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        return true
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
extension MainSignUpVC: FPNTextFieldDelegate {
    func fpnDidSelectCountry(name: String, dialCode: String, code: String, textField: UITextField) {
        self.counCode = dialCode
        print(name, dialCode, code)
    }
    
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        print(isValid)
    }
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
        //self.countryCodeTF.text = dialCode
        self.counCode = dialCode
        print(name, dialCode, code)
    }
}
/*extension MainSignUpVC: AuthServiceDelegate{
    func didFailure(error: String) {
        print(error)
        self.hideActivityIndicator()
        self.showMessage(with: error)
    }
    
    func didSuccessDeviceRegistration(status: Bool, message: String) {
        if status{
            AuthService.instance.isDeviceRegistered = true
            AuthService.instance.signUpUser(mail: email, pwd: pwd, fname: firstName, lname: lastName, ccode: counCode, mobile: mobileText)
        } else {
            DispatchQueue.main.async {
                self.hideActivityIndicator()
                self.showMessage(with: "Some Error Occured. Try again. \(message)")
            }
        }
    }
    
    func didSuccessAuthService(status: Bool) {
        DispatchQueue.main.async {
            if status{
                if let vc = FeedsVC.storyBoardInstance(){
                    self.hideActivityIndicator()
                    let rearViewController = MenuTVC()
                    let frontNavigationController = UINavigationController(rootViewController: vc)
                    let mainRevealController = SWRevealViewController()
                    mainRevealController.rearViewController = rearViewController
                    mainRevealController.frontViewController = frontNavigationController
                    self.present(mainRevealController, animated: true, completion: {
                        NotificationCenter.default.post(name: .userSignedIn, object: nil)
                    })
                }
            } else {
                self.hideActivityIndicator()
                self.showMessage(with: "Some Error Occured. Try again")
                //self.nextBtn.isEnabled = true
            }
        }
    }
    
    static func storyBoardInstance() -> MainSignUpVC? {
        return UIStoryboard(name: StoryBoard.MAIN, bundle: nil).instantiateViewController(withIdentifier: MainSignUpVC.id) as? MainSignUpVC
    }
}*/

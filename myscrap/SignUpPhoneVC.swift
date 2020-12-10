//
//  SignUpPhoneVC.swift
//  myscrap
//
//  Created by MyScrap on 12/17/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit
import ADCountryPicker
import Firebase
import FirebaseAuth


class SignUpPhoneVC: UIViewController {

    @IBOutlet weak var selectCountryTF: UITextField!
    @IBOutlet weak var phoneNoTF: ACFloatingTextfield!
    @IBOutlet weak var getCodeBtn: CorneredButton!
    @IBOutlet weak var backBtn: UIButton!
    
    let count_picker = ADCountryPicker()
    var dropDownBtn = UIButton(type: .custom)
    var bottomLine = CALayer()
    
    var first_name = ""
    var last_name = ""
    var email = ""
    var password = ""
    var lat = ""
    var long = ""
    
    var countrycode = ""
    var phone = ""
    
    var phoneExist = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        hideKeyboardWhenTappedAround()
        let img = UIImage(named: "drop_down")?.withRenderingMode(.alwaysTemplate)
        dropDownBtn.setImage(img , for: .normal)
        dropDownBtn.tintColor = UIColor.black
        dropDownBtn.addTarget(self, action: #selector(showCountryList), for: .touchUpInside)
        dropDownBtn.frame = CGRect(x:0, y:0, width:30, height:35)
        selectCountryTF.rightViewMode = .always
        selectCountryTF.rightView = dropDownBtn
        
        selectCountryTF.delegate = self
        selectCountryTF.text = "United Arab Emirates (+971)"
        phoneNoTF.delegate = self
        
        
        bottomLine.frame = CGRect(x: 0, y: selectCountryTF.frame.size.height - 1, width: selectCountryTF.frame.size.width + 30, height: 1)
        bottomLine.backgroundColor = UIColor.black.cgColor
        selectCountryTF.borderStyle = UITextField.BorderStyle.none
        selectCountryTF.layer.addSublayer(bottomLine)
        
        
        //Country picker customize
        /// delegate
        count_picker.delegate = self
        
        /// Optionally, set this to display the country calling codes after the names
        count_picker.showCallingCodes = true
        
        /// Flag to indicate whether country flags should be shown on the picker. Defaults to true
        count_picker.showFlags = true
        
        /// The nav bar title to show on picker view
        count_picker.pickerTitle = "Select the country"
        
        /// Flag to indicate whether the defaultCountryCode should be used even if region can be deteremined. Defaults to false
        count_picker.forceDefaultCountryCode = false
        
        /// The text color of the alphabet scrollbar. Defaults to black
        count_picker.alphabetScrollBarTintColor = UIColor.black
        
        /// The background color of the alphabet scrollar. Default to clear color
        count_picker.alphabetScrollBarBackgroundColor = UIColor.clear
        
        /// The tint color of the close icon in presented pickers. Defaults to black
        count_picker.closeButtonTintColor = UIColor.white
        
        /// The font of the country name list
        count_picker.font = UIFont(name: "Helvetica Neue", size: 15)
        
        /// The height of the flags shown. Default to 40px
        count_picker.flagHeight = 40
        
        /// Flag to indicate if the navigation bar should be hidden when search becomes active. Defaults to true
        count_picker.hidesNavigationBarWhenPresentingSearch = true
        
        /// The background color of the searchbar. Defaults to lightGray
        count_picker.searchBarBackgroundColor = UIColor.lightGray
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @objc
    func showCountryList(button: UIButton){
        let pickerNavigationController = UINavigationController(rootViewController: count_picker)
        self.present(pickerNavigationController, animated: true, completion: nil)
    }
    
    @IBAction func getCodeBtnTapped(_ sender: UIButton) {
        
        guard let phone = phoneNoTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) , phone != "" else { phoneNoTF.showErrorWithText(errorText: "Enter Phone Number");
            return
        }
        showActivityIndicator(with: "Sending...")
        if countrycode == "" {
            countrycode = "+971"
        }
        checkPhoneExists { (exists) in
            if !exists {
                DispatchQueue.main.async {
                    let phoneNumber = self.countrycode + phone
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    if !appDelegate.fireBaseConfig {
                        
                        if FirebaseApp.app() == nil {
                            FirebaseApp.configure()
                        }
                    }
                    //        self.hideActivityIndicator()
                    //        self.performSegue(withIdentifier: "verifySmsOTP", sender: self)
                    PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
                        if let error = error {
                             self.hideActivityIndicator()
                            
                            print("My phone : \(phoneNumber)")
                            print("error from Firebase: \(error.localizedDescription)")
                            let alertVC = UIAlertController(title: "OOPS",message: "Not a valid phone number", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK",style:.cancel, handler: nil)
                            alertVC.addAction(okAction)
                            self.present(alertVC,animated: true,completion: nil)
                            return
                        } else {
                            self.phone = phoneNumber
                            self.performSegue(withIdentifier: "verifySmsOTP", sender: self)
                            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                             self.hideActivityIndicator()
                            
                        }
                        // Sign in using the verificationID and the code sent to the user
                        // ...
                    }
                }
                
            } else {
                print("This will not be triggered")
            }
        }
    }
    typealias completionHandler = (_ exist: Bool) -> ()
    func checkPhoneExists(completion: @escaping completionHandler){
        //This function is to check the email already used in MyScrap. It will works vice versa manner
        
        let service = APIService()
        service.endPoint = Endpoints.VERIFY_EMAIL_OR_PHONE
        
        service.params = "reg_email=&reg_mobile=\(phoneNoTF.text!)&countryCode=\(countrycode)"
        service.getDataWith { [weak self] (result) in
            switch result{
            case .Success(let dict):
                if let error = dict["error"] as? Bool {
                    if !error {
                        DispatchQueue.main.async {
                            self?.hideActivityIndicator()
                            self?.phoneNoTF.showErrorWithText(errorText: "Already Phone number registered")
                        }
                        //return true
                        completion(true)
                        self?.phoneExist = true
                    } else {
                        //return false
                        completion(false)
                        self?.phoneExist = false
                    }
                }
            case .Error(let error):
                //self?.emailTF.showErrorWithText(errorText: "Already Email registered")
                completion(false)
                self?.phoneExist = false
            }
        }
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "verifySmsOTP" {
            let vc = segue.destination as? SignUpCodeVerficVC
            
            vc?.first_name = first_name
            vc?.last_name = last_name
            vc?.email = email
            vc?.password = password
            vc?.lat = lat
            vc?.long = long
            vc?.countrycode = countrycode
            vc?.sep_phone = phoneNoTF.text!
            
            vc!.comb_phone = countrycode + "-" + phoneNoTF.text!
        }
    }

}
extension SignUpPhoneVC : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneNoTF{
            let maxLength = 10
            let minimumLength = 7
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        if textField == selectCountryTF{
            let pickerNavigationController = UINavigationController(rootViewController: count_picker)
            self.present(pickerNavigationController, animated: true, completion: nil)
            return false
        }
        return true
    }
}
extension SignUpPhoneVC : ADCountryPickerDelegate {
    func countryPicker(_ picker: ADCountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String) {
        print("Picker value Name : \(name) \nCode : \(code) \nDial code : \(dialCode)")
        selectCountryTF.text = name + " (" + dialCode + ")"
        countrycode = dialCode
         self.dismiss(animated: true, completion: nil)
    }
}

//
//  CreateCompanyVC.swift
//  myscrap
//
//  Created by myscrap on 13/09/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit
//import FlagPhoneNumber
import Photos

class CreateCompanyVC: UIViewController {

    @IBOutlet weak var closeButton: UIBarButtonItem!

    @IBOutlet weak var companyNameTextField: CompanySearchTextField!

    @IBOutlet weak var addressTextField: ACFloatingTextfield!
    @IBOutlet weak var emailTextField: ACFloatingTextfield!

    @IBOutlet weak var phoneCodeTextField: ACFloatingTextfield! //FPNTextField!
    @IBOutlet weak var phoneTextField: ACFloatingTextfield!

    @IBOutlet weak var firstImageButton : UIButton!
    @IBOutlet weak var secondImageButton : UIButton!
    @IBOutlet weak var thirdImageButton : UIButton!
    @IBOutlet weak var fourthImageButton : UIButton!
    

    @IBOutlet weak var submitButton : UIButton!
    
    let imagePicker = UIImagePickerController()

    var firstSelectedImage : UIImage?
    var secondSelectedImage : UIImage?
    var thirdSelectedImage : UIImage?
    var fourthSelectedImage : UIImage?

    var firstSelectedImageBool : Bool = false
    var secondSelectedImageBool : Bool = false
    var thirdSelectedImageBool : Bool = false
    var fourthSelectedImageBool : Bool = false

    
    @IBOutlet weak var firstCloseImageButton : UIButton!
    @IBOutlet weak var secondCloseImageButton : UIButton!
    @IBOutlet weak var thirdCloseImageButton : UIButton!
    @IBOutlet weak var fourthCloseImageButton : UIButton!

    var firstImageStr : String = ""
    var secondImageStr : String = ""
    var thirdImageStr : String = ""
    var fourthImageStr : String = ""

    var countrycodeArray: [Ccode]{
        return Ccode.getcountryCode() ?? []
    }

    var countryCodePickerView = UIPickerView()

    var getCompanyText : String?
    
    fileprivate var activeTextField: ACFloatingTextfield?

    var countryRow: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.GREEN_PRIMARY
        self.closeButton.image = UIImage(named: "back")?.withRenderingMode(.alwaysTemplate)
        self.closeButton.tintColor = UIColor.white

        if self.getCompanyText != nil {
            self.companyNameTextField.text = self.getCompanyText
        }
        
        self.setup(textFields: [addressTextField,emailTextField,phoneTextField])

        self.setUpViews()
        
        self.setUpPickerView()
        
    }
    
    private func setup(textFields: [ACFloatingTextfield]){
        for textfield in textFields{
            textfield.delegate = self
        }
    }
    
    //MARK:- setupPickerView
    func setUpPickerView() {

        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.GREEN_PRIMARY
        toolBar.sizeToFit()

//        phoneCodeTextField.isUserInteractionEnabled = false

        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(CompanyEditProfileVC.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(CompanyEditProfileVC.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        phoneCodeTextField.inputAccessoryView = toolBar



        countryCodePickerView.backgroundColor = UIColor.white.withAlphaComponent(0.95)

        countryCodePickerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 200)

        countryCodePickerView.delegate = self
        countryCodePickerView.dataSource = self



        phoneCodeTextField.delegate = self
        phoneCodeTextField.inputView = countryCodePickerView

        emailTextField.keyboardType = .emailAddress
        phoneTextField.keyboardType = .phonePad
    }
    
    //MARK:- setUpViews
    func setUpViews(){
                
        //self.codeTextField
        self.phoneCodeTextField.textColor = UIColor.black
        self.phoneCodeTextField.placeholder = "Country Code"
        self.phoneCodeTextField.text = "+971" + " ▼"

        self.firstImageButton.tag = 111
        self.firstImageButton.addTarget(self, action: #selector(addPhotosButtonAction), for: .touchUpInside)
        
        self.secondImageButton.tag = 222
        self.secondImageButton.addTarget(self, action: #selector(addPhotosButtonAction), for: .touchUpInside)
        
        self.thirdImageButton.tag = 333
        self.thirdImageButton.addTarget(self, action: #selector(addPhotosButtonAction), for: .touchUpInside)
        
        self.fourthImageButton.tag = 444
        self.fourthImageButton.addTarget(self, action: #selector(addPhotosButtonAction), for: .touchUpInside)

        //submitButton
        self.submitButton.backgroundColor = UIColor.GREEN_PRIMARY
        self.submitButton.setTitleColor(UIColor.white, for: .normal)
        self.submitButton.layer.cornerRadius = 10
        self.submitButton.layer.masksToBounds = true
        self.submitButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        self.submitButton.addTarget(self, action: #selector(submitButtonAction), for: .touchUpInside)
        
        //firstCloseImageButton
        self.firstCloseImageButton.isHidden = true
        self.firstCloseImageButton.tag = 11
        self.firstCloseImageButton.addTarget(self, action: #selector(closePicAction), for: .touchUpInside)
        
        
        //secondCloseImageButton
        self.secondCloseImageButton.isHidden = true
        self.secondCloseImageButton.tag = 22
        self.secondCloseImageButton.addTarget(self, action: #selector(closePicAction), for: .touchUpInside)
        
        //thirdCloseImageButton
        self.thirdCloseImageButton.isHidden = true
        self.thirdCloseImageButton.tag = 33
        self.thirdCloseImageButton.addTarget(self, action: #selector(closePicAction), for: .touchUpInside)
        
        //fourthCloseImageButton
        self.fourthCloseImageButton.isHidden = true
        self.fourthCloseImageButton.tag = 44
        self.fourthCloseImageButton.addTarget(self, action: #selector(closePicAction), for: .touchUpInside)
    }
        
    //MARK:- Actions
    @objc func closePicAction(sender : UIButton) {
            
            if sender.tag == 11 {
//                self.firstSelectedImageBool = false
                self.firstImageButton.setImage(UIImage(named: "ic_AddImage"), for: .normal)
                self.firstCloseImageButton.isHidden = true
                self.firstImageStr = ""
                self.firstSelectedImage = nil
            }
            else if sender.tag == 22 {
//                self.secondSelectedImageBool = false
                self.secondImageButton.setImage(UIImage(named: "ic_AddImage"), for: .normal)
                self.secondCloseImageButton.isHidden = true
                self.secondImageStr = ""
                self.secondSelectedImage = nil
            }
            else if sender.tag == 33 {
//                self.thirdSelectedImageBool = false
                self.thirdImageButton.setImage(UIImage(named: "ic_AddImage"), for: .normal)
                self.thirdCloseImageButton.isHidden = true
                self.thirdImageStr = ""
                self.thirdSelectedImage = nil
            }
            else if sender.tag == 44 {
//                self.fourthSelectedImageBool = false
                self.fourthImageButton.setImage(UIImage(named: "ic_AddImage"), for: .normal)
                self.fourthCloseImageButton.isHidden = true
                self.fourthImageStr = ""
                self.fourthSelectedImage = nil
            }
    }

    @objc func submitButtonAction() {
        
        self.callCreateCompanyAPI()
    }

    @IBAction func closeButtonAction(_ sender: Any) {

        self.navigationController?.dismiss(animated: true, completion: nil)
//        self.navigationController?.popViewController(animated: true)
    }
    
    
    @objc func addPhotosButtonAction(sender : UIButton) {
        
        if sender.tag == 111 {
            self.firstSelectedImageBool = true
        }
        else if sender.tag == 222 {
            self.secondSelectedImageBool = true
        }
        else if sender.tag == 333 {
            self.thirdSelectedImageBool = true
        }
        else if sender.tag == 444 {
            self.fourthSelectedImageBool = true
        }
        
        let alert = UIAlertController(title: "Upload Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.goToGallery()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)

    }
    
    func convertDataIntoBase64String(image : UIImage) -> String {
        
        let imageData: Data = image.jpegData(compressionQuality: 0.6)!
        let imageString =  imageData.base64EncodedString(options: .lineLength64Characters)

        return imageString
    }
    
//MARK:- API Calling
    func callCreateCompanyAPI() {
        
        let companyNameStr = self.companyNameTextField.text!
        let addressStr = self.addressTextField.text!
        let emailStr = self.emailTextField.text!
        
        var countryCodeStr = self.phoneCodeTextField.text!
        let phoneNumberStr = self.phoneTextField.text!
        
        if self.firstSelectedImage != nil {
            self.firstImageStr = self.convertDataIntoBase64String(image: self.firstSelectedImage!)
        }
        
        if self.secondSelectedImage != nil {
            self.secondImageStr = self.convertDataIntoBase64String(image: self.secondSelectedImage!)
        }
        
        if self.thirdSelectedImage != nil {
            self.thirdImageStr = self.convertDataIntoBase64String(image: self.thirdSelectedImage!)
        }
        
        if self.fourthSelectedImage != nil {
            self.fourthImageStr = self.convertDataIntoBase64String(image: self.fourthSelectedImage!)
        }
        // convert image to base 64 string
        if companyNameStr != "" && addressStr != "" && emailStr != "" && countryCodeStr != "" && phoneNumberStr != "" {
         
            if firstImageStr != "" || secondImageStr != "" || thirdImageStr != "" || fourthImageStr != "" {

                            countryCodeStr = countryCodeStr.replacingOccurrences(of: " ▼", with: "")
                
                            let inValidDomains = ["gmail.com", "yahoo.com", "comcast.net", "hotmail.com", "msn.com", "verizon.net"]
                
                            let emailTextBlockText = emailStr //"example@gmail.com"
                
                            if let domain = emailTextBlockText.components(separatedBy: "@").last, inValidDomains.contains(domain) {
                                // Entered email has valid domain.
                
                                self.showAlert(message: "Enter a company email address")
                            }
                            else {
                                let checkValidEmail = JSONUtils.isValidEmail(testStr: emailStr)
                
                                if checkValidEmail { // Checking Valid Email
                
                                if phoneNumberStr.length > 7 { // Checking phone Number count
                
                                     let urlStr = "https://myscrap.com/user/addUserCompanyApp"
                
                                     let parameterDic : [String : Any] = ["apiKey" : "009f39bc-1075-4146-aa74-ebda062d4f1a",
                                                                          "userId" : AuthService.instance.userId, //"10164", // Need to check with live user
                                     "phone_code" : countryCodeStr,
                                     "phone" : phoneNumberStr,
                                     "email" : emailStr,
                                     "address" : addressStr,
                                     "company" : companyNameStr,
                                     "image1" : firstImageStr,
                                     "image2" : secondImageStr,
                                     "image3" : thirdImageStr,
                                     "image4" : fourthImageStr]
                
                                     APIClientManager.ExecuteRequest(url: urlStr, parameters: parameterDic, httpmethod: .post, showIndicator: true, view: self.view, requestCode: 0) { (responseData, isSuccess, responseCode, message) in
                
                                         if responseData != nil {
                
                                             let status = JSONUtils.GetStringFromObject(object: responseData!, key: "status")
                
                                            if isSuccess {
                                                if status != "" {
                //                                   self.showAlert(message: status)
                
                                                    self.showPopUpAlert(title: "", message: status, actionTitles: ["OK"], actions: [{action in
                
                                                        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                
                                                        }])
                                                }
                                            }
                                            else {
                                                if status != "" {
                                                   self.showAlert(message: status)
                                                }
                                            }
                
                                         }
                                         else {
                
                                         }
                                     }
                                    }
                                    else {
                                        self.showAlert(message: "Invalid number")
                                    }
                                }
                                else {
                                    self.showAlert(message: "Email is not valid")
                                }
                            }
                
            }
            else {
                showAlert(message: "Please Upload File")
            }
        }
        else {
            self.showAlert(message: "Fill all the mandatory fields")
        }
    }
}

extension CreateCompanyVC: UITextFieldDelegate{

    //MARK:- UItextField Delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        return false
        
        let nextTage=textField.tag+1;
        // Try to find next responder
        let nextResponder=textField.superview?.viewWithTag(nextTage) as UIResponder?
        if (nextResponder != nil){
            // Found next responder, so set it.
            nextResponder?.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard
            textField.resignFirstResponder()
        }
            return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if textField == phoneTextField {
            let maxLength = 10
            let currentString: NSString = textField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        return true
    }
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        activeTextField = textField as? ACFloatingTextfield
//    }
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        activeTextField = nil
//    }

}

// MARK:- PickerView Delegate
extension CreateCompanyVC: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countrycodeArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countrycodeArray[row].CountryName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        countryRow = row

        setCountryText(row)
//        countryTextField.resignFirstResponder()
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let myView = UIView(frame: CGRect(x: 0, y: 0, width: pickerView.bounds.width - 30 , height: 60))
        
//        let myImageView = UIImageView(frame: CGRect(x: 0, y: 5, width: 50 , height: 50))
        
        let myLabel = UILabel(frame: CGRect(x:60, y:0, width:pickerView.bounds.width - 90, height:60 ))

        myLabel.text = String(format: "%@\t%@", countrycodeArray[row].CountryCode, countrycodeArray[row].CountryName)
        myLabel.font = UIFont.systemFont(ofSize: 17)
        
        myView.addSubview(myLabel)
//        myView.addSubview(myImageView)
        
        return myView
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
    
    @objc func doneClick() {
        
        self.setCountryText(countryRow)
        phoneCodeTextField.resignFirstResponder()
    }
    @objc func cancelClick() {
        phoneCodeTextField.resignFirstResponder()
    }

        
    func setCountryText(_ index: Int){
        
        self.phoneCodeTextField.text = countrycodeArray[index].CountryCode + " ▼"
    }
}


extension CreateCompanyVC : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    // MARK:- ImagePicker
       func openCamera()
       {
           let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
           switch (status)
           {
           case .authorized:
               self.showCamera()
               
           case .notDetermined:
               AVCaptureDevice.requestAccess(for: AVMediaType.video) { (granted) in
                   if (granted)
                   {
                       self.showCamera()
                   }
                   else
                   {
                       self.camDenied()
                   }
               }
               
           case .denied:
               self.camDenied()
               
           case .restricted:
            DispatchQueue.main.async
                {
                        let alert = UIAlertController(title: "Restricted",
                                                      message: "You've been restricted from using the camera on this device. Without camera access this feature won't work. Please contact the device owner so they can give you access.",
                                                      preferredStyle: .alert)
                        
                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                }
           }
           
       }
       
       func showCamera() {
           
        DispatchQueue.main.async {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.imagePicker.sourceType = .camera
                self.imagePicker.allowsEditing = true
                self.imagePicker.delegate = self
                self.present(self.imagePicker, animated: true, completion: nil)
            }
            else {
             self.nocamera()
            }
        }
       }
    
        func nocamera()
        {
            let alertVC = UIAlertController(title: "No Camera",message: "Sorry, this device has no camera",preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK",style:.default,handler: nil)
            alertVC.addAction(okAction)
            present(alertVC,animated: true,completion: nil)
        }
       
       func goToGallery()
       {
           //Photos
           let photos = PHPhotoLibrary.authorizationStatus()
           if photos == .notDetermined {
               PHPhotoLibrary.requestAuthorization({status in
                   if status == .authorized{
                       
                       self.openGallery()
                   }
                   else {
                       self.camDenied()
                   }
               })
           }
           else if photos == .denied {
               self.camDenied()
           }
           else if photos == .authorized {
               self.openGallery()
           }
       }
       
       func openGallery () {
           
        DispatchQueue.main.async {
            self.imagePicker.sourceType = .photoLibrary
            self.imagePicker.allowsEditing = true
            self.imagePicker.delegate = self
            
            self.present(self.imagePicker, animated: true, completion: nil)
        }
           
       }
       
       func camDenied()
       {
           DispatchQueue.main.async
               {
                   let alertText = "Camera Denied, please go to the settings and enable"
                   
                   var alertButton = "OK"
                   var goAction = UIAlertAction(title: alertButton, style: .default, handler: nil)
                   
                   if UIApplication.shared.canOpenURL(URL(string: UIApplication.openSettingsURLString)!)
                   {
                       
//                       alertButton = "Denied"
                       
                       goAction = UIAlertAction(title: alertButton, style: .default, handler: {(alert: UIAlertAction!) -> Void in
                           UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                       })
                   }
                   
                   let okButtonAction = UIAlertAction(title: "Cancel", style: .default, handler: { (alert: UIAlertAction) in
                       
                       
                   })
                   
                   let alert = UIAlertController(title: "Oops!", message: alertText, preferredStyle: .alert)
                   alert.addAction(goAction)
                   alert.addAction(okButtonAction)
                   self.present(alert, animated: true, completion: nil)
           }
       }
    
    
    // MARK:- ImagePicker
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                        
        picker.dismiss(animated: true, completion: nil)

        guard let image = info[.editedImage] as? UIImage else {
            
            return
        }
        
        if self.firstSelectedImageBool {
            self.firstSelectedImage = image
            self.firstImageButton.setImage(image, for: .normal)
            self.firstSelectedImageBool = false
            self.firstCloseImageButton.isHidden = false
        }
        else if self.secondSelectedImageBool {
            self.secondSelectedImage = image
            self.secondImageButton.setImage(image, for: .normal)
            self.secondSelectedImageBool = false
            self.secondCloseImageButton.isHidden = false
        }
        else if self.thirdSelectedImageBool {
            self.thirdSelectedImage = image
            self.thirdImageButton.setImage(image, for: .normal)
            self.thirdSelectedImageBool = false
            self.thirdCloseImageButton.isHidden = false
        }
        else if self.fourthSelectedImageBool {
            self.fourthSelectedImage = image
            self.fourthImageButton.setImage(image, for: .normal)
            self.fourthSelectedImageBool = false
            self.fourthCloseImageButton.isHidden = false
        }
        
    }
}

extension UITextField{
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }

    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        self.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
}

extension UITextView {
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }

    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))

        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()

        self.inputAccessoryView = doneToolbar
    }

    @objc func doneButtonAction()
    {
        self.resignFirstResponder()
    }
}

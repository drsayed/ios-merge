//
//  ChangePasswordVC.swift
//  myscrap
//
//  Created by MS1 on 1/14/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit

class ChangePasswordVC: UIViewController {

    @IBOutlet private weak var topConstraint: NSLayoutConstraint!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet weak var currentPasswordtxtFld: ACFloatingTextfield!
    @IBOutlet weak var newPasswordTextField: ACFloatingTextfield!
    
    @IBOutlet weak var changePasswordButton: LoginButton!
    
    var currentPwdBtn  = UIButton(type: .custom)      //Password Show or hide button
    var newPwdBtn  = UIButton(type: .custom)      //Password Show or hide button
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(scrollViewTapped))
        tap.numberOfTapsRequired = 1
        scrollView.addGestureRecognizer(tap)
        
        setupViews()
        
        //Password eye icon
        currentPwdBtn.setImage(UIImage(named: "password_hide") , for: .normal)
        currentPwdBtn.addTarget(self, action: #selector(currentPwdShowHide), for: .touchUpInside)
        currentPwdBtn.frame = CGRect(x:0, y:0, width:30, height:30)
        
        newPwdBtn.setImage(UIImage(named: "password_hide") , for: .normal)
        newPwdBtn.addTarget(self, action: #selector(newPwdShowHide), for: .touchUpInside)
        newPwdBtn.frame = CGRect(x:0, y:0, width:30, height:30)
        
        currentPasswordtxtFld.rightViewMode = .always
        currentPasswordtxtFld.rightView = currentPwdBtn
        currentPasswordtxtFld.isSecureTextEntry = true
        
        newPasswordTextField.rightViewMode = .always
        newPasswordTextField.rightView = newPwdBtn
        newPasswordTextField.isSecureTextEntry = true
        
        currentPasswordtxtFld.autocapitalizationType = .words
        newPasswordTextField.autocapitalizationType = .words
    }
    
    @objc
    func currentPwdShowHide(button: UIButton) {
        currentPwdToggle()
    }
    
    @objc
    func newPwdShowHide(button: UIButton) {
        newPwdToggle()
    }
    
    func currentPwdToggle() {
        currentPasswordtxtFld.isSecureTextEntry = !currentPasswordtxtFld.isSecureTextEntry
        if currentPasswordtxtFld.isSecureTextEntry {
            currentPwdBtn.setImage(UIImage(named: "password_hide") , for: .normal)
        } else {
            currentPwdBtn.setImage(UIImage(named: "password_show") , for: .normal)
        }
    }
    
    func newPwdToggle() {
        newPasswordTextField.isSecureTextEntry = !newPasswordTextField.isSecureTextEntry
        if newPasswordTextField.isSecureTextEntry {
            newPwdBtn.setImage(UIImage(named: "password_hide") , for: .normal)
        } else {
            newPwdBtn.setImage(UIImage(named: "password_show") , for: .normal)
        }
    }
    
    private func setupViews(){
        currentPasswordtxtFld.placeholder = "Current Password"
        newPasswordTextField.placeholder = "New Password"
        changePasswordButton.setTitle("Change Password", for: .normal)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        currentPasswordtxtFld.becomeFirstResponder()
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    @objc private func scrollViewTapped(){
        view.endEditing(true)
    }
    
    private var currentPassword: String?
    private var newPassword: String?
    
    
    @IBAction func changePasswordTapped(_ sender: Any) {
        self.resignFirstResponder()
        dismissKeyboard()
        self.showActivityIndicator(with: "Updating...")
        currentPassword = currentPasswordtxtFld.text
        newPassword = newPasswordTextField.text
        
        guard let current = currentPassword, current != "",  let new = newPassword , new != "" else {
            
            if currentPassword == nil || currentPassword == ""{
                currentPasswordtxtFld.showError()
            }
            
            if (newPassword == nil || newPassword == "") {
                newPasswordTextField.showError()
            }
            
            return
        }
        //if isValidPassword(pwd: newPassword!) {
            AuthService.instance.changePassword(currentPassword: current, newPassword: new) { [weak self](success, status) in
                DispatchQueue.main.async {
                    self?.hideActivityIndicator()
                }
                
                if success{
                    self?.showAlert(title: "Success", message: "You have successfully changed the Password.", ifChangeSuccess: success)
                } else {
                    self?.showAlert(title: "Error", message: "Current Password is incorrect. Try again.", ifChangeSuccess: success)
                }
            }
        /*} else {
            let alertController = UIAlertController(title: "OOPS", message: "Password must be at least 6 characters and must contain the following: an upper case character, a number and a special character ( !@#$%^&* )", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(okAction)
            /*alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                
            }))*/
            alertController.view.tintColor = UIColor.GREEN_PRIMARY
            self.present(alertController, animated: true, completion: nil)
        }*/
        
    }
    
    private func showAlert(title:String,message: String, ifChangeSuccess: Bool){
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            //alertController.addAction(okAction)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                if ifChangeSuccess{
                    if let new = self.newPassword, new != ""{
                        AuthService.instance.password = new
                        UserDefaults.standard.set(new, forKey: "storedPassword")
                    }
                    self.view.endEditing(true)
                    //ChangePasswordVC().dismiss(animated: true, completion: nil)
                    self.navigationController?.popViewController(animated: true)
                }
            }))
            alertController.view.tintColor = UIColor.GREEN_PRIMARY
            self.present(alertController, animated: true, completion: nil)
            
            
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    static func storyBoardInstance() -> ChangePasswordVC?{
        return UIStoryboard.profile.instantiateViewController(withIdentifier: ChangePasswordVC.id) as? ChangePasswordVC
    }
    
    public func isValidPassword(pwd: String) -> Bool {
        //6 characters
        //1 uppercase alphabet
        //1 lowercase alphabet
        //1 special character
        //1 numeral
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{6,}"
        let testPwd =  NSPredicate(format:"SELF MATCHES %@", passwordRegex)
        return testPwd.evaluate(with: pwd)
    }

}

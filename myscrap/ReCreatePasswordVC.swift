//
//  ReCreatePasswordVC.swift
//  myscrap
//
//  Created by MyScrap on 12/5/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit

class ReCreatePasswordVC: UIViewController {

    @IBOutlet weak var borderPwdView: CorneredView!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var updatePwdBtn: CorneredButton!
    
    var email = ""
    
    let service = ForgotPwdService()
    
    var rightButton  = UIButton(type: .custom)      //Password Show or hide button
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        hideKeyboardWhenTappedAround()
        service.delegate = self
        
        borderPwdView.layer.cornerRadius = 5
        borderPwdView.layer.borderWidth = 2
        borderPwdView.layer.borderColor = UIColor.MyScrapGreen.cgColor
        passwordTF.autocapitalizationType = .words

        //Password eye icon
        rightButton.setImage(UIImage(named: "password_hide") , for: .normal)
        rightButton.addTarget(self, action: #selector(toggleShowHide), for: .touchUpInside)
        rightButton.frame = CGRect(x:0, y:0, width:30, height:30)
        
        passwordTF.rightViewMode = .always
        passwordTF.rightView = rightButton
        passwordTF.isSecureTextEntry = true
        // Do any additional setup after loading the view.
    }
    
    @objc
    func toggleShowHide(button: UIButton) {
        toggle()
    }
    
    func toggle() {
        passwordTF.isSecureTextEntry = !passwordTF.isSecureTextEntry
        if passwordTF.isSecureTextEntry {
            rightButton.setImage(UIImage(named: "password_hide") , for: .normal)
        } else {
            rightButton.setImage(UIImage(named: "password_show") , for: .normal)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //navigationItem.title = "Inbox"
        //navigationItem.hidesBackButton = false
        self.navigationController?.isNavigationBarHidden = false
        //self.navigationItem.hidesBackButton = true
        
        
        //navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: Selector(("back:")))
        navigationController?.setNavigationBarHidden(false, animated:true)
        let myBackButton:UIButton = UIButton(type: .custom) as UIButton
        myBackButton.addTarget(self, action: #selector(back), for: .touchUpInside)
        //myBackButton.setTitle("LOGIN", for: .normal)
        let image = UIImage(named: "back")?.withRenderingMode(.alwaysTemplate)
        myBackButton.setImage(image, for: .normal)
        myBackButton.tintColor = UIColor.white
        myBackButton.sizeToFit()
        let myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
        self.navigationItem.leftBarButtonItem  = myCustomBackButtonItem
    }
    
    @objc func back(sender: UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func updatePwdTapped(_ sender: UIButton) {
        _ = passwordTF.resignFirstResponder()
        if let pwd = passwordTF.text, pwd != ""  {
            if isValidPassword(pwd: pwd) {
                if email != "" {
                    DispatchQueue.main.async {
                        self.showActivityIndicator(with: "Updating..")             //(Maha Manual edit)
                    }
                    service.recreatePwd(email: email, password: pwd)
                } else {
                    self.showToast(message: "Something went wrong. Please try again!")
                }
            } else {
                let alertController = UIAlertController(title: "OOPS", message: "Password should match the criteria. ", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(okAction)
                /*alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                 
                 }))*/
                alertController.view.tintColor = UIColor.GREEN_PRIMARY
                self.present(alertController, animated: true, completion: nil)
            }
            
        } else {
            //passwordTF.showErrorWithText(errorText: "Please enter the new password")
            let alertVC = UIAlertController(title: "OOPS",message: "New password cannot be empty",preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK",style:.cancel, handler: nil)
            alertVC.addAction(okAction)
            self.present(alertVC,animated: true,completion: nil)
        }
    }
    
    public func isValidPassword(pwd: String) -> Bool {
        //6 characters
        //1 uppercase alphabet
        //1 lowercase alphabet
        //1 special character
        //1 numeral
        //let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#_\"'`/:;<>{|}~,.{|}])[A-Za-z@!%*?&#_\"'`/:;<>{|}~,.{|}]\\dd{6,}$"
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{6,}"
        let testPwd =  NSPredicate(format:"SELF MATCHES %@", passwordRegex)
        return testPwd.evaluate(with: pwd)
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
extension ReCreatePasswordVC : ForgotPwdDelegate {
    func didReceiveResponse(message: String) {
        DispatchQueue.main.async {
            self.hideActivityIndicator()
            if message == "Something wrong" {
                let alertVC = UIAlertController(title: "OOPS",message: message, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK",style:.cancel, handler: nil)
                alertVC.addAction(okAction)
                self.present(alertVC,animated: true,completion: nil)
            } else if message == "Your password changed successfully." {
                UserDefaults.standard.set(self.passwordTF.text!, forKey: "storedPassword")
                let alertVC = UIAlertController(title: "SUCCESS",message: message, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: {  [weak self] (action) in
                    if let delegate = UIApplication.shared.delegate as? AppDelegate , let window = delegate.window , let signInController = SignInViewController.storyBoardInstance() {
                        window.rootViewController = signInController
                    }
                })
                alertVC.addAction(okAction)
                self.present(alertVC,animated: true,completion: nil)
            }
        }
    }
    
    func didReceiveError(error: String) {
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: "OOPS", message: error, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK",style:.cancel, handler: nil)
            alertVC.addAction(okAction)
            self.present(alertVC,animated: true,completion: nil)
        }
    }
}

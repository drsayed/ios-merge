//
//  CreateCompanyTitleVC.swift
//  myscrap
//
//  Created by myscrap on 14/09/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit

class CreateCompanyTitleVC: UIViewController {

    
    @IBOutlet weak var companyTextField : UITextField!
    
    @IBOutlet weak var nextButton : UIButton!

    @IBOutlet weak var closeButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        // Do any additional setup after loading the view.
        
        self.setUpViews()
    }
    
    func setUpViews() {

        //companyTextField
        self.companyTextField.autocorrectionType = .no
        
        //submitButton
        self.nextButton.backgroundColor = UIColor.GREEN_PRIMARY
        self.nextButton.setTitleColor(UIColor.white, for: .normal)
        self.nextButton.layer.cornerRadius = 10
        self.nextButton.layer.masksToBounds = true
        self.nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        self.nextButton.addTarget(self, action: #selector(nextButtonAction), for: .touchUpInside)

    }
    
    @objc func nextButtonAction() {
        
        let companyNameStr = self.companyTextField.text!
        
        if companyNameStr != "" {
           
            let vc = UIStoryboard.init(name: "CreateCompany", bundle: nil).instantiateViewController(withIdentifier: "CreateCompanyVC") as! CreateCompanyVC
            vc.getCompanyText = companyNameStr

            let navVC = UINavigationController.init(rootViewController: vc)
                    
            self.navigationController?.present(navVC, animated: true, completion: nil)
        }
        else {
            self.showAlert(message: "Enter company name")
        }

    }
    
    @IBAction func closeButtonAction(_ sender: Any) {

        self.navigationController?.dismiss(animated: true, completion: nil)
    }
}

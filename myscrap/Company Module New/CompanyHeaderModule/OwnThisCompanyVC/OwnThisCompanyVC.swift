//
//  OwnThisCompanyVC.swift
//  myscrap
//
//  Created by Apple on 27/10/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit
import SDWebImage

protocol UpdateOwnCompanydelegate: class {
    
    func updateData()
}

class OwnThisCompanyVC: UIViewController {
    
    var closeButton: UIBarButtonItem!
    
    var firstDescLabel : UILabel!
    var secondDescLabel : UILabel!
    
    var firstContentView : UIView!
    var checkEmailButton : UIButton!
    var emailDescLabel : UILabel!

    var secondContentView : UIView!
    var checkModeratorButton : UIButton!
    var moderatorDescLabel : UILabel!
    var moderatorProfilePic : UIImageView!
    var moderatorNameLabel : UILabel!

    var submitButton : UIButton!
    
    weak var viewDelegate : UpdateOwnCompanydelegate?

    var getCompanyItems : CompanyItems?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.backgroundColor = UIColor.GREEN_PRIMARY
        
        let backbutton = UIBarButtonItem(image: UIImage(named: "back")?.withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(backButtonAction))
        backbutton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = backbutton

        self.view.backgroundColor = UIColor.white
        
        var emailStr = ""
        if getCompanyItems != nil {
            
            if getCompanyItems!.compnayName != "" {
                self.navigationItem.title = getCompanyItems!.compnayName
            }
            
            if getCompanyItems!.email != "" {
                emailStr = getCompanyItems!.email
            }
        }
                
        self.setUpViews()
        
        let font = UIFont.systemFont(ofSize: 17)
        
        let firstStr = NSAttributedString(string: "Via Email\nConfirmation email will be sent to ", attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor : UIColor.black])

        let secondStr = NSAttributedString(string: emailStr, attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor : UIColor.lightGray, NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
        let attr = NSMutableAttributedString()
        attr.append(firstStr)
        attr.append(secondStr)

        self.emailDescLabel.attributedText = attr
        
        self.getMainPage(friendId: "745") // Moderator Picture
    }
    
    @objc func backButtonAction() {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func setUpViews() {
        
        //firstDescLabel
        self.firstDescLabel = UILabel()
        self.firstDescLabel.translatesAutoresizingMaskIntoConstraints = false
        self.firstDescLabel.numberOfLines = 0
        self.firstDescLabel.font = UIFont.systemFont(ofSize: 17)
        self.firstDescLabel.textColor = .BLACK_ALPHA
        self.firstDescLabel.text = "In order to manage this company, you will need to confirm this is yours."
        self.view.addSubview(self.firstDescLabel)
        
        //secondDescLabel
        self.secondDescLabel = UILabel()
        self.secondDescLabel.translatesAutoresizingMaskIntoConstraints = false
        self.secondDescLabel.font = UIFont.systemFont(ofSize: 17)
        self.secondDescLabel.textColor = .BLACK_ALPHA
        self.secondDescLabel.text = "Select how would you like to get confirmation:"
        self.view.addSubview(self.secondDescLabel)

        
        //firstContentView
        self.firstContentView = UIView()
        self.firstContentView.translatesAutoresizingMaskIntoConstraints = false
        self.firstContentView.backgroundColor = .white
        self.view.addSubview(firstContentView)
        
        //checkEmailButton
        self.checkEmailButton = UIButton()
        self.checkEmailButton.translatesAutoresizingMaskIntoConstraints = false
        self.checkEmailButton.setTitleColor(UIColor.BLACK_ALPHA, for: .normal)
        self.checkEmailButton.setImage(UIImage(named: "chekbox_uncheck")?.withRenderingMode(.alwaysOriginal), for: .normal)
        self.checkEmailButton.tintColor = UIColor.GREEN_PRIMARY
        self.checkEmailButton.tag = 11
        self.checkEmailButton.addTarget(self, action: #selector(checkEmailButtonAction), for: .touchUpInside)
        self.firstContentView.addSubview(checkEmailButton)

        //emailDescLabel
        self.emailDescLabel = UILabel()
        self.emailDescLabel.translatesAutoresizingMaskIntoConstraints = false
        self.emailDescLabel.font = UIFont.systemFont(ofSize: 17)
        self.emailDescLabel.textColor = .BLACK_ALPHA
        self.emailDescLabel.numberOfLines = 0
        self.emailDescLabel.text = "Via email\n"
        self.firstContentView.addSubview(self.emailDescLabel)

        //secondContentView
        self.secondContentView = UIView()
        self.secondContentView.translatesAutoresizingMaskIntoConstraints = false
        self.secondContentView.backgroundColor = .white
        self.view.addSubview(secondContentView)
        
        //checkModeratorButton
        self.checkModeratorButton = UIButton()
        self.checkModeratorButton.translatesAutoresizingMaskIntoConstraints = false
        self.checkModeratorButton.setTitleColor(UIColor.BLACK_ALPHA, for: .normal)
        self.checkModeratorButton.setImage(UIImage(named: "chekbox_uncheck")?.withRenderingMode(.alwaysOriginal), for: .normal)
        self.checkModeratorButton.tintColor = UIColor.GREEN_PRIMARY
        self.checkModeratorButton.tag = 22
        self.checkModeratorButton.addTarget(self, action: #selector(checkModeratorButtonAction), for: .touchUpInside)
        self.secondContentView.addSubview(checkModeratorButton)

        //moderatorDescLabel
        self.moderatorDescLabel = UILabel()
        self.moderatorDescLabel.translatesAutoresizingMaskIntoConstraints = false
        self.moderatorDescLabel.font = UIFont.systemFont(ofSize: 17)
        self.moderatorDescLabel.textColor = .BLACK_ALPHA
        self.moderatorDescLabel.text = "Contact moderator"
        self.secondContentView.addSubview(self.moderatorDescLabel)

        //moderatorProfilePic
        self.moderatorProfilePic = UIImageView()
        self.moderatorProfilePic.translatesAutoresizingMaskIntoConstraints = false
        self.moderatorProfilePic.backgroundColor = UIColor.lightGray
        self.moderatorProfilePic.layer.cornerRadius = 15.0
        self.moderatorProfilePic.layer.masksToBounds = true
        self.secondContentView.addSubview(self.moderatorProfilePic)

        
        //moderatorNameLabel
        self.moderatorNameLabel = UILabel()
        self.moderatorNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.moderatorNameLabel.font = UIFont.boldSystemFont(ofSize: 17)
        self.moderatorNameLabel.textColor = .BLACK_ALPHA
        self.moderatorNameLabel.text = "Emma "
        self.secondContentView.addSubview(self.moderatorNameLabel)

        
        //submitButton
        self.submitButton = UIButton()
        self.submitButton.translatesAutoresizingMaskIntoConstraints = false
        self.submitButton.backgroundColor = UIColor.GREEN_PRIMARY
        self.submitButton.setTitleColor(UIColor.white, for: .normal)
        self.submitButton.layer.cornerRadius = 5
        self.submitButton.layer.masksToBounds = true
        self.submitButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        self.submitButton.setTitle("Submit", for: .normal)
        self.submitButton.addTarget(self, action: #selector(submitButtonAction), for: .touchUpInside)
        self.view.addSubview(self.submitButton)

        self.setUpConstraints()
    }
    
    func setUpConstraints()
    {
        //firstDescLabel
        self.firstDescLabel.leadingAnchor.constraint(equalTo: self.firstDescLabel.superview!.leadingAnchor, constant: 15).isActive = true
        self.firstDescLabel.trailingAnchor.constraint(equalTo: self.firstDescLabel.superview!.trailingAnchor, constant: -15).isActive = true
        self.firstDescLabel.topAnchor.constraint(equalTo: self.firstDescLabel.superview!.topAnchor, constant: 25).isActive = true
     
        
        //secondDescLabel
        self.secondDescLabel.leadingAnchor.constraint(equalTo: self.secondDescLabel.superview!.leadingAnchor, constant: 15).isActive = true
        self.secondDescLabel.trailingAnchor.constraint(equalTo: self.secondDescLabel.superview!.trailingAnchor, constant: -15).isActive = true
        self.secondDescLabel.topAnchor.constraint(equalTo: self.firstDescLabel.bottomAnchor, constant: 13).isActive = true

        
        //firstContentView
        self.firstContentView.leadingAnchor.constraint(equalTo: self.firstContentView.superview!.leadingAnchor, constant: 15).isActive = true
        self.firstContentView.trailingAnchor.constraint(equalTo: self.firstContentView.superview!.trailingAnchor, constant: -15).isActive = true
        self.firstContentView.topAnchor.constraint(equalTo: self.secondDescLabel.bottomAnchor, constant: 30).isActive = true

        
        //checkEmailButton
        self.checkEmailButton.leadingAnchor.constraint(equalTo: self.checkEmailButton.superview!.leadingAnchor, constant: 5).isActive = true
        self.checkEmailButton.topAnchor.constraint(equalTo: self.checkEmailButton.superview!.topAnchor, constant: 5).isActive = true
        self.checkEmailButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        self.checkEmailButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        
        //emailDescLabel
        self.emailDescLabel.leadingAnchor.constraint(equalTo: self.checkEmailButton.trailingAnchor, constant: 10).isActive = true
        self.emailDescLabel.trailingAnchor.constraint(equalTo: self.emailDescLabel.superview!.trailingAnchor, constant: 0).isActive = true
        self.emailDescLabel.topAnchor.constraint(equalTo: self.emailDescLabel.superview!.topAnchor, constant: 5).isActive = true
        self.emailDescLabel.bottomAnchor.constraint(equalTo: self.emailDescLabel.superview!.bottomAnchor, constant: -10).isActive = true
        
        
        //secondContentView
        self.secondContentView.leadingAnchor.constraint(equalTo: self.secondContentView.superview!.leadingAnchor, constant: 15).isActive = true
        self.secondContentView.trailingAnchor.constraint(equalTo: self.secondContentView.superview!.trailingAnchor, constant: -15).isActive = true
        self.secondContentView.topAnchor.constraint(equalTo: self.firstContentView.bottomAnchor, constant: 10).isActive = true

        
        //checkModeratorButton
        self.checkModeratorButton.leadingAnchor.constraint(equalTo: self.checkModeratorButton.superview!.leadingAnchor, constant: 5).isActive = true
        self.checkModeratorButton.topAnchor.constraint(equalTo: self.checkModeratorButton.superview!.topAnchor, constant: 5).isActive = true
        self.checkModeratorButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
        self.checkModeratorButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        
        //moderatorDescLabel
        self.moderatorDescLabel.leadingAnchor.constraint(equalTo: self.checkModeratorButton.trailingAnchor, constant: 10).isActive = true
        self.moderatorDescLabel.trailingAnchor.constraint(equalTo: self.moderatorDescLabel.superview!.trailingAnchor, constant: 0).isActive = true
        self.moderatorDescLabel.topAnchor.constraint(equalTo: self.moderatorDescLabel.superview!.topAnchor, constant: 5).isActive = true
        
        
        //checkModeratorButton
        self.moderatorProfilePic.leadingAnchor.constraint(equalTo: self.moderatorDescLabel.leadingAnchor, constant: 0).isActive = true
        self.moderatorProfilePic.topAnchor.constraint(equalTo: self.moderatorDescLabel.bottomAnchor, constant: 5).isActive = true
        self.moderatorProfilePic.widthAnchor.constraint(equalToConstant: 30).isActive = true
        self.moderatorProfilePic.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.moderatorProfilePic.bottomAnchor.constraint(equalTo: self.moderatorProfilePic.superview!.bottomAnchor, constant: -10).isActive = true

        
        //moderatorNameLabel
        self.moderatorNameLabel.leadingAnchor.constraint(equalTo: self.moderatorProfilePic.trailingAnchor, constant: 8).isActive = true
        self.moderatorNameLabel.centerYAnchor.constraint(equalTo: self.moderatorProfilePic.centerYAnchor, constant: 0).isActive = true
        
        
        //checkModeratorButton
        self.submitButton.leadingAnchor.constraint(equalTo: self.submitButton.superview!.leadingAnchor, constant: 15).isActive = true
        self.submitButton.topAnchor.constraint(equalTo: self.secondContentView.bottomAnchor, constant: 10).isActive = true
        self.submitButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        self.submitButton.heightAnchor.constraint(equalToConstant: 40).isActive = true

    }
    
    //MARK:- Actions
    @objc func checkEmailButtonAction(sender: UIButton) {
        
        if sender.tag == 11 {
            sender.tag = 0
            sender.setImage(UIImage(named: "chekbox_check"), for: .normal)
            sender.isSelected = true
        }
        else {
            sender.setImage(UIImage(named: "chekbox_uncheck"), for: .normal)
            sender.tintColor = UIColor.GREEN_PRIMARY
            sender.tag = 11
            sender.isSelected = false
        }
    }

    @objc func checkModeratorButtonAction(sender: UIButton) {
        
        if sender.tag == 22 {
            sender.tag = 0
            sender.setImage(UIImage(named: "chekbox_check"), for: .normal)
            sender.isSelected = true
        }
        else {
            sender.setImage(UIImage(named: "chekbox_uncheck"), for: .normal)
            sender.tintColor = UIColor.GREEN_PRIMARY
            sender.tag = 22
            sender.isSelected = false
        }
    }
    @objc func submitButtonAction() {
        
        var type = ""
        
        if self.checkEmailButton.isSelected && self.checkModeratorButton.isSelected {
            type = "2"
        }
        else if self.checkEmailButton.isSelected {
            type = "0"
        }
        else if self.checkModeratorButton.isSelected {
            type = "1"
        }

        if type != "" {
            self.callAPI(type: type)
        }
    }
    
    //MARK:- API
    
    func getMainPage(friendId: String) {
        let service = APIService()
        service.endPoint =  Endpoints.GET_MAINPAGE_FRIEND_PROFILE
        service.params = "userId=\(friendId)&apiKey=\(API_KEY)&friendId=\(AuthService.instance.userId)"
        print("URL : \(Endpoints.GET_FRIEND_PHOTOS), \nPARAMS for get profile:",service.params)
        service.getDataWith { [weak self] (result) in
            switch result{
            case .Success(let dict):
                
                    if let data = dict["data"] as? [String : AnyObject] {
                        
                        if let photosArr = data["photos"] as? [String] {
                            
                            if photosArr.count > 0 {
                                let profilePicUrl = photosArr[0] 
                                
                                    self?.moderatorProfilePic.sd_setImage(with: URL(string: profilePicUrl), completed: nil)

//                                }
                                
                            }
                        }
                    }
            case .Error(let error):
                print(error)
            }
        }
    }
    
    func callAPI(type: String) {
        
        let spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
        spinner.mode = MBProgressHUDMode.indeterminate
        spinner.label.text = "Requesting..."
        let service = APIService()

        let endPoint = Endpoints.MAKE_ADMIN_OF_COMPANY
        var companyId = ""
        
        if getCompanyItems?.compnayId != "" {
            companyId = getCompanyItems!.compnayId
        }
        
        service.endPoint = endPoint
        if companyId != "" {
            
            service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&companyId=\(companyId)&type=\(type)"
            service.getDataWith { [weak self] (result) in

                switch result{
                case .Success(let dict):
                    if let error = dict["error"] as? Bool{
                        if !error{
                            DispatchQueue.main.async {
                                MBProgressHUD.hide(for: (self?.view)!, animated: true)
    //                            self?.getNotifications()
                                
                                if self?.viewDelegate != nil {
                                    self?.navigationController?.popViewController(animated: true)
                                    self?.viewDelegate!.updateData()
                                }
                            }

                        } else {
                            DispatchQueue.main.async {
                                self?.showToast(message: dict["status"] as? String ?? "Error in sending request")
                            }
                        }
                    }
                case .Error(let error):
                    DispatchQueue.main.async {
                        self?.showToast(message: error)
                    }
                }
            }
        }
    }
}

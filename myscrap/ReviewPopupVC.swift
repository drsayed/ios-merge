//
//  ReviewPopupVC.swift
//  myscrap
//
//  Created by MyScrap on 6/23/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit
import Cosmos

class ReviewPopupVC: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var profileView: ProfileView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var star: CosmosView!
    @IBOutlet weak var review_textView: UITextView!
    @IBOutlet weak var postBtn: UIBarButtonItem!
    
    var rating = 0.0
    
    var review_service = ReviewService()
    var delegate: ReviewServiceDelegate?
    
    var vc = CompanyDetailVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        setupTextView()
        
        profileView.updateViews(name: AuthService.instance.fullName, url: AuthService.instance.profilePic, colorCode: AuthService.instance.colorCode)
        name.text = AuthService.instance.fullName
        
        print("rating :\(rating)")
        self.star.rating = rating
        
    }
    
    func setupTextView() {
        review_textView.delegate = self
        
        //review_textView.clipsToBounds = true
        //review_textView.layer.cornerRadius = 5
        //let color = UIColor.lightGray.withAlphaComponent(0.3)
        //review_textView.layer.borderColor = color.cgColor
        //review_textView.layer.borderWidth = 1
        
        review_textView.text = "Share details of your own experience at this place"
        review_textView.textColor = .lightGray
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Share details of your own experience at this place"
            textView.textColor = UIColor.lightGray
        }
    }
    
    @IBAction func postBtnTapped(_ sender: UIBarButtonItem) {
        if  self.star.rating == 0.0 {
            let alert = UIAlertController(title: "Please Rate the company", message: nil, preferredStyle: .alert)
            alert.view.tintColor = UIColor.GREEN_PRIMARY
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            if review_textView.text == "Share details of your own experience at this place" {
                let spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
                spinner.mode = MBProgressHUDMode.indeterminate
                spinner.label.text = "Submiting Review"
                //let trim = review_textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
                let companyId = UserDefaults.standard.object(forKey: "companyId") as! String
                review_service.submitReview(companyId: companyId, userId: AuthService.instance.userId, reviewText: "", rating: String( self.star.rating)){ (success) in
                    if success {
                        print("Review Added")
                        DispatchQueue.main.async {
                            spinner.hide(animated: true)
                        }
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        self.showToast(message: "Failed to Add review")
                        DispatchQueue.main.async {
                            spinner.hide(animated: true)
                        }
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            } else {
                let spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
                spinner.mode = MBProgressHUDMode.indeterminate
                spinner.label.text = "Submiting Review"
                let trim = review_textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
                let companyId = UserDefaults.standard.object(forKey: "companyId") as! String
                review_service.submitReview(companyId: companyId, userId: AuthService.instance.userId, reviewText: trim, rating: String( self.star.rating)){ (success) in
                    if success {
                        print("Review Added")
                        DispatchQueue.main.async {
                            spinner.hide(animated: true)
                        }
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        self.showToast(message: "Failed to Add review")
                        DispatchQueue.main.async {
                            spinner.hide(animated: true)
                        }
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
    
    static func storyBoardInstance() -> ReviewPopupVC? {
        let st = UIStoryboard(name: "Companies", bundle: nil)
        return st.instantiateViewController(withIdentifier: ReviewPopupVC.id) as? ReviewPopupVC
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


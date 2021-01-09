//
//  CustomAlertView.swift
//  myscrap
//
//  Created by MyScrap on 7/4/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit

class CustomAlertView: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var characterCountLabel: UILabel!
    @IBOutlet weak var alertTextField: UITextField!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var setButton: UIButton!
    
    var delegate: CustomAlertViewDelegate?
    var selectedOption = "First"
    let alertViewGrayColor = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1)

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        characterCountLabel.text = "Count : 25"
        alertTextField.keyboardType = .asciiCapable
        alertTextField.keyboardAppearance = .alert
        alertTextField.autocapitalizationType = .words
        alertTextField.delegate = self
        alertTextField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        animateView()
        cancelButton.layer.cornerRadius = 4
        setButton.layer.cornerRadius = 4
        setButton.layer.borderColor = UIColor.MyScrapGreen.cgColor
        setButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.MyScrapGreen.cgColor
        cancelButton.layer.borderWidth = 1
//        cancelButton.addBorder(side: .Top, color: alertViewGrayColor, width: 1)
//        cancelButton.addBorder(side: .Right, color: alertViewGrayColor, width: 1)
//        setButton.addBorder(side: .Top, color: alertViewGrayColor, width: 1)
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
    
    @IBAction func onTapCancelButton(_ sender: Any) {
        alertTextField.resignFirstResponder()
        delegate?.cancelButtonTapped()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onTapSetButton(_ sender: Any) {
        if alertTextField.text != "" {
            alertTextField.resignFirstResponder()
            delegate?.okButtonTapped(selectedOption: selectedOption, textFieldValue: alertTextField.text!)
            self.dismiss(animated: true, completion: nil)
        } else {
            characterCountLabel.textColor = .red
            characterCountLabel.text = "Topic should not be empty"
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        characterCountLabel.textColor = .darkGray
        let maxLength = 25
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        let max = maxLength - newString.length
        if max == -1 {
            self.characterCountLabel.text = "Count : 0"
        } else if max == 0 {
            self.characterCountLabel.text = "Count : 0"
        } else {
            self.characterCountLabel.text = "Count : \(max)"
        }
        
        return newString.length < maxLength
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

extension CustomAlertView: UINavigationControllerDelegate {
    
    static func storyBoardInstance() -> CustomAlertView?{
        return UIStoryboard(name: StoryBoard.LIVE, bundle: nil).instantiateViewController(withIdentifier: CustomAlertView.id) as? CustomAlertView
    }
}
public enum UIButtonBorderSide {
    case Top, Bottom, Left, Right
}

extension UIButton {
    
    public func addBorder(side: UIButtonBorderSide, color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        
        switch side {
        case .Top:
            border.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: width)
        case .Bottom:
            border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        case .Left:
            border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        case .Right:
            border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        }
        
        self.layer.addSublayer(border)
    }
}

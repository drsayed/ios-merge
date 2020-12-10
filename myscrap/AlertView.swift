//
//  AlertView.swift
//  myscrap
//
//  Created by MyScrap on 15/03/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import Foundation
import UIKit

class AlertView: UIView {
    static let instance = AlertView()
    
    @IBOutlet var parentView: UIView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var doneBtn: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        Bundle.main.loadNibNamed("AlertView", owner: self, options: nil)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        img.layer.cornerRadius = 30
        img.layer.borderColor = UIColor.white.cgColor
        img.layer.borderWidth = 2
        
        alertView.layer.cornerRadius = 10
        alertView.layer.borderColor = UIColor(hexString: "#D3D3D3").cgColor
        alertView.layer.borderWidth = 1
        
        parentView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        parentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    enum AlertType {
        case success
        case failure
    }
    
    func showAlert(title: String, message: String, alertType: AlertType) {
        self.titleLbl.text = title
        self.messageLbl.text = message
        switch alertType {
        case .success:
            img.image = UIImage(named: "Success")
            doneBtn.backgroundColor = #colorLiteral(red: 0.1649596691, green: 0.4849149585, blue: 0.2121850848, alpha: 1)
        case .failure:
            img.image = UIImage(named: "Failure")
            doneBtn.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        }
        UIApplication.shared.keyWindow?.addSubview(parentView)
    }
    @IBAction func onClickDone(_ sender: Any) {
        parentView.removeFromSuperview()
    }
}


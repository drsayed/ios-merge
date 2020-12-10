//
//  ViewMailBottomCell.swift
//  myscrap
//
//  Created by MyScrap on 2/10/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit

class ViewMailBottomCell: UICollectionViewCell {
    
    @IBOutlet weak var replyBtn: UIButton!
    
    // this will be our "call back" action
    var btnTapAction : (()->())?
    
    override func awakeFromNib() {
        DispatchQueue.main.async {
            self.replyBtn.setImage(UIBarButtonItem.SystemItem.reply.image(), for: .normal)
            self.replyBtn.tintColor = .black
        }
    }
    @IBAction func replyBtnTapped(_ sender: UIButton) {
        // use our "call back" action to tell the controller the button was tapped
        btnTapAction?()
    }
}
extension UIBarButtonItem.SystemItem {
    func image() -> UIImage? {
        let tempItem = UIBarButtonItem(barButtonSystemItem: self,
                                       target: nil,
                                       action: nil)
        
        // add to toolbar and render it
        let bar = UIToolbar()
        bar.setItems([tempItem],
                     animated: false)
        bar.snapshotView(afterScreenUpdates: true)
        
        // got image from real uibutton
        let itemView = tempItem.value(forKey: "view") as! UIView
        for view in itemView.subviews {
            if let button = view as? UIButton,
                let image = button.imageView?.image {
                return image.withRenderingMode(.alwaysTemplate)
            }
        }
        
        return nil
    }
}

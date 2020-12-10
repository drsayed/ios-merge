//
//  CompanyImageslCell.swift
//  myscrap
//
//  Created by MyScrap on 3/23/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit

//protocol NewsDelegate : class {
//    func didTapNews(Id: String)
//}

class CompanyImageslCell: BaseCell {
 
    @IBOutlet weak var companyImageView: UIImageView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        companyImageView.contentMode = .scaleAspectFill
        let pinchGesture = UIPinchGestureRecognizer(target: self, action:#selector(pinchRecognized(_:)))
            self.companyImageView.addGestureRecognizer(pinchGesture)
        
    }
    @IBAction func pinchRecognized(_ pinch: UIPinchGestureRecognizer) {

        TMImageZoom.shared()?.gestureStateChanged(pinch, withZoom: self.companyImageView)
    }
}

extension UIImageView {
    var contentClippingRect: CGRect {
        guard let image = image else { return bounds }
        guard contentMode == .scaleAspectFit else { return bounds }
        guard image.size.width > 0 && image.size.height > 0 else { return bounds }

        let scale: CGFloat
        if image.size.width > image.size.height {
            scale = bounds.width / image.size.width
        } else {
            scale = bounds.height / image.size.height
        }

        let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        let x = (bounds.width - size.width) / 2.0
        let y = (bounds.height - size.height) / 2.0

        return CGRect(x: x, y: y, width: size.width, height: size.height)
    }
    
}



import UIKit

class SenderView: UIView{
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.roundCorners([.bottomLeft, .bottomRight , .topLeft], radius: 16)
    }
}


extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}


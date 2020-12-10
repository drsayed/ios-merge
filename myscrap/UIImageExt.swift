//
//  UIImageExt.swift
//  myscrap
//
//  Created by MS1 on 9/25/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import Foundation
import UIKit
extension UIImage {
    func imageResize (sizeChange:CGSize)-> UIImage{
        let hasAlpha = true
        let scale: CGFloat = 0.0 // Use scale factor of main screen
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        self.draw(in: CGRect(origin: CGPoint.zero, size: sizeChange))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage!
    }
}

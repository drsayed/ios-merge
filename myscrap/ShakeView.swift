//
//  ShakeView.swift
//  himbo
//
//  Created by Marcus Kida on 29/11/2014.
//  Copyright (c) 2014 Marcus Kida. All rights reserved.
//

import UIKit

enum ShakeDirection {
    case Horizontal , Vertical
}

extension UIView {
    func shake(times: Int, direction: ShakeDirection) {
       // shake(times: times , iteration: 0, direction: 1.0 , shakeDirection: direction, delta: 6, speed: 0.1)
        self.transform = CGAffineTransform(scaleX: 1, y: 1)
        UIView.animate(withDuration: 1.0, delay:0, options: [.repeat, .autoreverse], animations: {
         //   UIView.setAnimationRepeatCount(3)
            self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            //self.layoutSubviews()
            self.layoutIfNeeded()
            }, completion: {completion in
                self.transform = CGAffineTransform(scaleX: 1, y: 1)
             //   self.layoutIfNeeded()
        })
    }
    private func shake(times: Int, iteration: Int, direction: CGFloat, shakeDirection: ShakeDirection, delta: CGFloat, speed: TimeInterval) {
        UIView.animate(withDuration: speed, animations: { () -> Void in
            self.layer.setAffineTransform((shakeDirection == ShakeDirection.Horizontal) ? CGAffineTransform(translationX: delta * direction, y: 0) : CGAffineTransform(translationX: 0, y: delta * direction))
                }) { (finished: Bool) -> Void in
            
            if iteration > 3 {
                UIView.animate(withDuration: speed, animations: { () -> Void in
                    self.layer.setAffineTransform(CGAffineTransform.identity)
                })
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.shake(times: (times - 1), iteration: 0, direction: (direction * -1), shakeDirection: shakeDirection, delta: delta, speed: speed)
                }
            }
    else
            {
                self.shake(times: (times - 1), iteration: (iteration + 1), direction: (direction * -1), shakeDirection: shakeDirection, delta: delta, speed: speed)
            }
                
            }
        }
}

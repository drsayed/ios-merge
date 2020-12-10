//
//  UIView-Frame-Ext.swift
//  TypeView
//
//  Created by MS1 on 2/4/18.
//  Copyright © 2018 xerox101. All rights reserved.
//

import UIKit

extension UIView{
    
    var x: CGFloat{
        get{
            return self.frame.origin.x
        }
        set{
            self.frame = CGRect(x: newValue, y: self.frame.origin.y, width: self.frame.width, height: self.frame.height)
        }
    }

    var y: CGFloat{
        get{
            return self.frame.origin.y
        }
        set{
            self.frame = CGRect(x: self.frame.origin.x, y: newValue, width: self.frame.width, height: self.frame.height)
        }
    }
    
    var width: CGFloat{
        get{
            return self.frame.width
        }
        set{
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: newValue, height: self.frame.height)
        }
    }
    
    var height: CGFloat{
        get{
            return self.frame.height
        }
        set{
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: newValue)
        }
    }
    
}

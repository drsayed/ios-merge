//
//  KCFABViewController.swift
//  KCFloatingActionButton-Sample
//
//  Created by LeeSunhyoup on 2015. 10. 13..
//  Copyright © 2015년 kciter. All rights reserved.
//

import UIKit

/**
    KCFloatingActionButton dependent on UIWindow.
*/
open class FloatyViewController: UIViewController {
    public let floaty = Floaty()
    var statusBarStyle: UIStatusBarStyle = .default

    override open func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        view.addSubview(floaty)
    }
    
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return statusBarStyle
        }
    }
}

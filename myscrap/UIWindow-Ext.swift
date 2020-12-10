//
//  UIWindow-Ext.swift
//  myscrap
//
//  Created by MyScrap on 5/23/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit

extension UIViewController {
    func topMostViewController() -> UIViewController {
        if self.presentedViewController == nil {
            return self
        }
        
        if let navigation = self.presentedViewController as? UINavigationController, let visble = navigation.visibleViewController {
            return visble.topMostViewController()
        }
        if let tab = self.presentedViewController as? UITabBarController {
            if let selectedTab = tab.selectedViewController {
                return selectedTab.topMostViewController()
            }
            return tab.topMostViewController()
        }
        return self.presentedViewController!.topMostViewController()
    }
}

extension UIApplication {
    func topMostViewController() -> UIViewController? {
        return self.keyWindow?.rootViewController?.topMostViewController()
    }
}

//
//  RateReviewMyScrap.swift
//  myscrap
//
//  Created by MyScrap on 2/17/20.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import Foundation
import StoreKit

struct UserDefaultsKeys {
    static let APP_OPENED_COUNT = "APP_OPENED_COUNT"
}
struct RateReviewMyScrap {
    let Defaults = UserDefaults.standard
    static func incrementAppOpenedCount() { // called from appdelegate didfinishLaunchingWithOptions:
        guard var appOpenCount = UserDefaults.standard.value(forKey: UserDefaultsKeys.APP_OPENED_COUNT) as? Int else {
            UserDefaults.standard.set(1, forKey: UserDefaultsKeys.APP_OPENED_COUNT)
            return
        }
        appOpenCount += 1
        UserDefaults.standard.set(appOpenCount, forKey: UserDefaultsKeys.APP_OPENED_COUNT)
    }
    static func checkAndAskForReview() { // call this whenever appropriate
        // this will not be shown everytime. Apple has some internal logic on how to show this.
        guard let appOpenCount = UserDefaults.standard.value(forKey: UserDefaultsKeys.APP_OPENED_COUNT) as? Int else {
            UserDefaults.standard.set(1, forKey: UserDefaultsKeys.APP_OPENED_COUNT)
            return
        }
        
        switch appOpenCount {
        case 10,50:
            RateReviewMyScrap().requestReview()
        case _ where appOpenCount%100 == 0 :
            RateReviewMyScrap().requestReview()
        default:
            print("App run count is : \(appOpenCount)")
            break;
        }
        
    }
    fileprivate func requestReview() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else {
            // Fallback on earlier versions
            // Try any other 3rd party or manual method here.
            rateApp(appId: "id1233167019?ls=1")
        }
    }
    
    fileprivate func rateApp(appId: String) {
        openUrl("itms-apps://itunes.apple.com/app/" + appId)
    }
    
    fileprivate func openUrl(_ urlString:String) {
        let url = URL(string: urlString)!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}

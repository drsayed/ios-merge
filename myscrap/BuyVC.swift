
//
//  BuyVC.swift
//  myscrap
//
//  Created by MyScrap on 6/5/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit

class BuyVC: SellVC {
    
    override var pushTitle: String{
        return "Buy Offer"
    }
    
    override var sectionTitle: String{
        return "Buy Offers".uppercased()
    }
    
    override var postNotification: Notification.Name{
        return Notification.Name.marketListingBuyPosted
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
    }
    
    override var type: MarketType{
        return .buy
    }

}

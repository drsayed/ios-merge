//
//  ActivityIndicator+Additions.swift
//  myscrap
//
//  Created by myscrap on 13/09/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit

class ActivityIndicator {
    
    var container: UIView = UIView()
    var loadingView: UIView = UIView()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    func showActivityIndicator(uiView: UIView) {
       
        container.frame = uiView.frame
        container.center = uiView.center
        container.backgroundColor = UIColor.white.withAlphaComponent(0.3) //UIColorFromHex(rgbValue: 0xffffff, alpha: 0.3)
        
        loadingView.frame = CGRect(x:0, y:0, width:80, height:80)
        loadingView.center = uiView.center
        loadingView.backgroundColor = UIColor(red: 68/255.0, green: 68/255.0, blue: 68/255.0, alpha: 0.7) //UIColorFromHex(rgbValue: 0x444444, alpha: 0.7)
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 10
        
        activityIndicator.frame = CGRect(x:0.0, y:0.0, width:40.0, height:40.0);
        activityIndicator.style = UIActivityIndicatorView.Style.whiteLarge
        activityIndicator.center = CGPoint(x:loadingView.frame.size.width / 2, y:loadingView.frame.size.height / 2);
        
        loadingView.addSubview(activityIndicator)
        container.addSubview(loadingView)
        uiView.addSubview(container)
        activityIndicator.startAnimating()
    }

    func hideActivityIndicator(uiView: UIView) {
        activityIndicator.stopAnimating()
        container.removeFromSuperview()
    }
    
}

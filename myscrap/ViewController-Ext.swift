//
//  ViewController-Ext.swift
//  myscrap
//
//  Created by MS1 on 2/6/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit


extension UIViewController{
    func showActivityIndicator(with text: String, color: UIColor? = nil, mode: MBProgressHUDMode? = nil){
        if let navView = navigationController?.view {
            createSpinner(loaderView: navView, color:  color, text: text, mode: mode)
        } else {
            createSpinner(loaderView: view, color: color, text: text, mode: mode)
        }
    }
    
    func createSpinner(loaderView: UIView, color: UIColor? = nil, text: String, mode: MBProgressHUDMode? = nil){
        let spinnerActivity = MBProgressHUD.showAdded(to: loaderView, animated: true)
        if let color = color{
            spinnerActivity.contentColor = color
        }
        if let mode = mode{
            spinnerActivity.mode = mode
        }
        spinnerActivity.label.text = text
        spinnerActivity.isUserInteractionEnabled = false
        
    }
    
    
    func hideActivityIndicator(){
        MBProgressHUD.hide(for: view, animated: true)
        if let navView = navigationController?.view {
            MBProgressHUD.hide(for: navView, animated: true)
        } else {
            MBProgressHUD.hide(for: view, animated: true)
        }
    }
    
    func showMessage(with text: String){
        if let navView = navigationController?.view {
            showLabel(with: text, loaderView :navView)
        } else {
            showLabel(with: text, loaderView: view)
        }
    }
    
    func showVideoDwnldMessage(with text: String){
        if let navView = navigationController?.view {
            showDwnldLabel(with: text, loaderView :navView)
        } else {
            showDwnldLabel(with: text, loaderView: view)
        }
    }
    
    private func showLabel(with text: String, loaderView: UIView){
        let spinner = MBProgressHUD.showAdded(to: loaderView, animated: true)
        spinner.label.text = text
        spinner.mode = .text
        spinner.offset = CGPoint(x: 0, y: MBProgressMaxOffset)
        spinner.hide(animated: true, afterDelay: 2.0)
    }
    
    private func showDwnldLabel(with text: String, loaderView: UIView){
        let spinner = MBProgressHUD.showAdded(to: loaderView, animated: true)
        spinner.label.text = text
        spinner.mode = .text
        spinner.offset = CGPoint(x: 0, y: MBProgressMaxOffset - 30)
        spinner.hide(animated: true, afterDelay: 2.0)
    }
}


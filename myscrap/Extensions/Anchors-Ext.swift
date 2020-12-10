//
//  Anchors-Ext.swift
//  MSInputView
//
//  Created by Mac on 3/14/18.
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit

extension UIView{
    
    func fillSuperView(){
        if let spView = superview{
            NSLayoutConstraint.activate([
                leadingAnchor.constraint(equalTo: spView.leadingAnchor),
                trailingAnchor.constraint(equalTo: spView.trailingAnchor),
                topAnchor.constraint(equalTo: spView.topAnchor),
                bottomAnchor.constraint(equalTo: spView.bottomAnchor)
                ])
        }
    }
    
    func setAnchors(leading: NSLayoutXAxisAnchor?, trailing: NSLayoutXAxisAnchor?, top: NSLayoutYAxisAnchor?, bottom: NSLayoutYAxisAnchor?, padding: UIEdgeInsets = .zero){
        
        if let leading = leading{
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        if let trailing = trailing{
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        if let bottom = bottom{
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
    }
    
    func setSize(width: CGFloat?, height: CGFloat? ){
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = height{
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    func setCenter(to view: UIView){
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func setVerticalCenter(to view: UIView){
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func setHorizontantalCenter(to view: UIView){
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    
}

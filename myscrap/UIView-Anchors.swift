
//  Copyright © 2018 xerox101. All rights reserved.
//

import UIKit

extension UIView{
    
    func centertoSuperView(){
        if let xAnchor = superview?.centerXAnchor, let yAnchor = superview?.centerYAnchor {
            NSLayoutConstraint.activate([
                self.centerXAnchor.constraint(equalTo: xAnchor),
                self.centerYAnchor.constraint(equalTo: yAnchor),
                ])
        }
    }
    
    
    
    func fillSuperview() {
        anchor(leading: superview?.leadingAnchor, trailing: superview?.trailingAnchor, top: superview?.topAnchor, bottom: superview?.bottomAnchor)
    }
    
    func anchorSize(to view: UIView) {
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    func anchorCenter(to view: UIView){
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    func setSize(size: CGSize){
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
    func setLeading(to anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0 ){
        leadingAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
    }
    func setTrailing(to anchor: NSLayoutXAxisAnchor, constant: CGFloat = 0 ){
        trailingAnchor.constraint(equalTo: anchor, constant: -constant).isActive = true
    }
    
    func setTop(to anchor: NSLayoutYAxisAnchor, constant: CGFloat = 0 ){
        topAnchor.constraint(equalTo: anchor, constant: constant).isActive = true
    }
    
    func setHorizontalCenter(to anchor: NSLayoutXAxisAnchor){
        centerXAnchor.constraint(equalTo: anchor, constant: 0).isActive = true
    }
    
    
    func anchor(leading: NSLayoutXAxisAnchor?, trailing: NSLayoutXAxisAnchor?, top: NSLayoutYAxisAnchor?, bottom: NSLayoutYAxisAnchor?, padding: UIEdgeInsets = .zero,size: CGSize = CGSize.zero){
        
        if let leading = leading{
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        if let trailing = trailing{
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
    func equealLeadingandTrailing(to view: UIView){
        leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    func aligntoVerticalCenter(_ views: [UIView]){
        for view in views{
            view.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        }
    }
    
    
    var safeLeading : NSLayoutXAxisAnchor{
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.leadingAnchor
        } else {
            return leadingAnchor
        }
    }
    
    var safeTrailing : NSLayoutXAxisAnchor{
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.trailingAnchor
        } else {
            return trailingAnchor
        }
    }
    
    var safeBottom : NSLayoutYAxisAnchor{
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.bottomAnchor
        } else {
            return bottomAnchor
        }
    }
    
    var safeTop : NSLayoutYAxisAnchor{
        if #available(iOS 11.0, *) {
            return safeAreaLayoutGuide.topAnchor
        } else {
            return topAnchor
        }
    }
    
}



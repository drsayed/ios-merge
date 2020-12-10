//
//  BorderClusterAnnotationView.swift
//  myscrap
//
//  Created by MS1 on 1/15/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit
import MapKit

class BorderedClusterAnnotationView: ClusterAnnotationView {
    let borderColor: UIColor
    
    init(annotation: MKAnnotation?, reuseIdentifier: String?, style: ClusterAnnotationStyle, borderColor: UIColor) {
        self.borderColor = borderColor
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier, style: style)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configure(with style: ClusterAnnotationStyle) {
        super.configure(with: style)
        
        switch style {
        case .image:
            layer.borderWidth = 0
        case .color:
            layer.borderColor = borderColor.cgColor
            layer.borderWidth = 2
        }
    }
}


/*
 class BorderedClusterAnnotationView: ClusterAnnotationView {
 var borderColor: UIColor?
 
 convenience init(annotation: MKAnnotation?, reuseIdentifier: String?, type: ClusterAnnotationType, borderColor: UIColor) {
 self.init(annotation: annotation, reuseIdentifier: reuseIdentifier, type: type)
 self.borderColor = borderColor
 }
 
 override func configure() {
 super.configure()
 
 switch type {
 case .image:
 layer.borderWidth = 0
 case .color:
 layer.borderColor = borderColor?.cgColor
 layer.borderWidth = 0
 }
 }
 }   */

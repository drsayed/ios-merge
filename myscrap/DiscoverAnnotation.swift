//
//  DiscoverAnnotation.swift
//  myscrap
//
//  Created by MS1 on 1/15/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import Foundation
import MapKit

final class DiscoverAnnotaion: Annotation{
    var companyId: String?
}

final class DiscoverAnnotationView: MKAnnotationView{

    private let btn : UIButton = {
        let btn = UIButton(type: .detailDisclosure)
        btn.tintColor = UIColor.GREEN_PRIMARY
        return btn
    }()
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(){
        image = #imageLiteral(resourceName: "pin")
        canShowCallout = true
        rightCalloutAccessoryView = btn
    }
    
}

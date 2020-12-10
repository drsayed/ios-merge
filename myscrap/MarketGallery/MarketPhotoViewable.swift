//
//  MarketPhotoViewable.swift
//  MarketGallery
//
//  Created by MyScrap on 7/28/18.
//  Copyright © 2018 mybucket. All rights reserved.
//

import UIKit

protocol MarketPhotoViewable: class {
    
    typealias imageHandler = ( _ image: UIImage?, _ error: Error?) -> ()
    
    var image: UIImage? {get}
    
    var title: String? { get }
    
    func loadImageWithCompletionHandler(_ completion : @escaping imageHandler)
    
}


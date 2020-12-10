//
//  ImageService.swift
//  myscrap
//
//  Created by MyScrap on 5/28/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit

public enum ImageFormat{
    case png
    case jpeg(CGFloat)
}

class ImageService {
    
    static let instance = ImageService()
    
    private init() {}
    
    func convertImageTobase64(format: ImageFormat, image: UIImage) -> String?{
        var imageData: Data?
        switch format {
        case .png:
            imageData = image.pngData()
        case .jpeg(let compression):
            imageData = image.jpegData(compressionQuality: compression)
        }
        return imageData?.base64EncodedString()
    }
    
}

//
//  BlurredLabel.swift
//  myscrap
//
//  Created by Hassan Jaffri on 11/1/20.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import Foundation
class BlurredLabel: UILabel {

    func blur(_ blurRadius: Double = 2.5,_ color: UIColor = .white) {
        let blurredImage = getBlurryImage(blurRadius)
        let blurredImageView = UIImageView(image: blurredImage)
        blurredImageView.translatesAutoresizingMaskIntoConstraints = false
        blurredImageView.tag = 100
        blurredImageView.contentMode = .center
        blurredImageView.backgroundColor =  color.withAlphaComponent(1)
        addSubview(blurredImageView)
        NSLayoutConstraint.activate([
            blurredImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            blurredImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func unblur() {
        subviews.forEach { subview in
            if subview.tag == 100 {
                subview.removeFromSuperview()
            }
        }
    }

    private func getBlurryImage(_ blurRadius: Double = 5.5) -> UIImage? {
        UIGraphicsBeginImageContext(bounds.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        guard let image = UIGraphicsGetImageFromCurrentImageContext(),
            let blurFilter = CIFilter(name: "CIGaussianBlur") else {
            UIGraphicsEndImageContext()
            return nil
        }
        UIGraphicsEndImageContext()

        blurFilter.setDefaults()

        blurFilter.setValue(CIImage(image: image), forKey: kCIInputImageKey)
        blurFilter.setValue(blurRadius, forKey: kCIInputRadiusKey)

        var convertedImage: UIImage?
        let context = CIContext(options: nil)
        if let blurOutputImage = blurFilter.outputImage,
            let cgImage = context.createCGImage(blurOutputImage, from: blurOutputImage.extent) {
            convertedImage = UIImage(cgImage: cgImage)
        }

        return convertedImage
    }
}

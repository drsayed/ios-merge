//
//  CropPhotoVC.swift
//  myscrap
//
//  Created by MyScrap on 7/1/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit

class CropPhotoVC: UIViewController {
    
    @IBOutlet weak var photo: UIImageView!
    
    var Value1 = UIImage()

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        photo.layer.borderWidth = 1
        // photo.layer.masksToBounds = false
        // photo.layer.borderColor = UIColor.black.cgColor
        // photo.layer.cornerRadius = photo.frame.height/2
        // photo.clipsToBounds = true
        photo.image = Value1
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

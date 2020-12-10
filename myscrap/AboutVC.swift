//
//  AboutVC.swift
//  myscrap
//
//  Created by MS1 on 7/3/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

class AboutVC: BaseVC,UIScrollViewDelegate {

 
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        scrollView.delegate = self
        
     
        
        
        self.scrollView.layer.shadowColor = UIColor(red: UIColor.SHADOW_GRAY, green: UIColor.SHADOW_GRAY, blue: UIColor.SHADOW_GRAY, alpha: 0.6).cgColor
        self.scrollView.layer.shadowOpacity = 0.8
        self.scrollView.layer.shadowRadius = 5.0
        self.scrollView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        self.scrollView.layer.cornerRadius = 2.0
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let verticalIndicator: UIImageView = (scrollView.subviews[(scrollView.subviews.count - 1)] as! UIImageView)
        verticalIndicator.backgroundColor = UIColor.GREEN_PRIMARY
        //        verticalIndicator.backgroundColor = UIColor.blue
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


class AboutLabel: UILabel{
    
    
    override func awakeFromNib() {
        
        
    }
    
    
}

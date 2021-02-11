//
//  LiveSuggessionCell.swift
//  myscrap
//
//  Created by MyScrap on 14/05/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit


final class LiveSuggessionCell: BaseCell{
    
    @IBOutlet weak var darkBackground: UIView!
    @IBOutlet weak var message: UILabel!
  
    
    override func layoutSubviews() {
        self.darkBackground.layer.cornerRadius =   5
        self.darkBackground.clipsToBounds = true
        self.darkBackground.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)

    }
    override func awakeFromNib() {
           super.awakeFromNib()
        self.darkBackground.backgroundColor = UIColor.darkGray.withAlphaComponent(0.5)

       }
    func configCell(item: String){
      
        self.message.text = item
        
         }
  
}


//
//  ReceiverImageCell.swift
//  myscrap
//
//  Created by MS1 on 11/7/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

class ReceiverImageCell: SenderImageCell {
 
    @IBOutlet weak var profileView: ProfileView!
    override func setReadImage(date: Date?, status: String, imageURL: String) {
        if let date = date{
            let dateFormatter = DateFormatter()
            let calendar = Calendar.current
            if calendar.isDateInToday(date){
                dateFormatter.dateFormat = "hh:mm a"
            } /*else if calendar.isDateInWeekend(date){
                 dateFormatter.dateFormat = "E hh:mm a"
                 } */
            else {
                dateFormatter.dateFormat = "MMM dd hh:mm a"
            }
            timeLbl.text = dateFormatter.string(from: date)
        }        
        if status == "3"{
            if lastSeen{
                readImageView.backgroundColor = UIColor.GREEN_PRIMARY
                if let url = URL(string: imageURL) {
                    readImageView.sd_setImage(with: url, completed: nil)
                } else {
                    readImageView.image = nil
                }
            } else {
                readImageView.backgroundColor = UIColor.clear
                readImageView.image = nil
            }
        }
    }
}




//
//  FeedPollResultCell.swift
//  myscrap
//
//  Created by MyScrap on 16/03/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit

class FeedPollResultCell: BaseCell {

    @IBOutlet weak var option1Lbl: UILabel!
    @IBOutlet weak var option2Lbl: UILabel!
    @IBOutlet weak var option3Lbl: UILabel!
    @IBOutlet weak var option4Lbl: UILabel!
    
    @IBOutlet weak var perctCount1Lbl: UILabel!
    @IBOutlet weak var perctCount2Lbl: UILabel!
    @IBOutlet weak var perctCount3Lbl: UILabel!
    @IBOutlet weak var perctCount4Lbl: UILabel!
    
    @IBOutlet weak var bar1View: UIView!
    @IBOutlet weak var bar2View: UIView!
    @IBOutlet weak var bar3View: UIView!
    @IBOutlet weak var bar4View: UIView!
    
    @IBOutlet weak var bar1WidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var bar2WidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var bar3WidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var bar4WidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var backBar1View: UIView!
    @IBOutlet weak var backBar2View: UIView!
    @IBOutlet weak var backBar3View: UIView!
    @IBOutlet weak var backBar4View: UIView!
    
    @IBOutlet weak var totalCountLbl: UILabel!
    var covidItem : CovidPollFeed!
    var item : FeedV2Item?{
            didSet{
                guard let item = item else { return }
                configCell(item: item)
                for lists in item.covidData {
                    covidItem = lists
                }
            }
        }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        backBar1View.layer.cornerRadius = 5
        backBar1View.clipsToBounds = true
        bar1View.layer.cornerRadius = 5
        bar1View.clipsToBounds = true
        
        backBar2View.layer.cornerRadius = 5
        backBar2View.clipsToBounds = true
        bar2View.layer.cornerRadius = 5
        bar2View.clipsToBounds = true
        
        backBar3View.layer.cornerRadius = 5
        backBar3View.clipsToBounds = true
        bar3View.layer.cornerRadius = 5
        bar3View.clipsToBounds = true
        
        backBar4View.layer.cornerRadius = 5
        backBar4View.clipsToBounds = true
        bar4View.layer.cornerRadius = 5
        bar4View.clipsToBounds = true
        
    }
    
    func configCell(item: FeedV2Item) {
        //Assinging the Total Vote Count
        let totalAttribString = NSMutableAttributedString(string: "Total Voters: ", attributes: [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 15)])
        let numberAttribString = NSMutableAttributedString(string: String(format: "%d", item.totalCount), attributes: [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-Medium", size: 15)])
        totalAttribString.append(numberAttribString)
        totalCountLbl.attributedText = totalAttribString
        
        //If covid item has values
        
            let option1 = item.covidData[0].option
            if item.covidData[0].isVoted {
                option1Lbl.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
                option1Lbl.text =  option1
            } else {
                option1Lbl.font = UIFont(name: "HelveticaNeue", size: 15)
                option1Lbl.text = item.covidData[0].option
            }
         let option2 = item.covidData[1].option
            if item.covidData[1].isVoted {
                option2Lbl.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
                option2Lbl.text = option2
            } else {
                option2Lbl.font = UIFont(name: "HelveticaNeue", size: 15)
                option2Lbl.text = item.covidData[1].option
            }
        let option3 = item.covidData[2].option
            if item.covidData[2].isVoted {
                option3Lbl.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
                option3Lbl.text = option3
            } else {
                option3Lbl.font = UIFont(name: "HelveticaNeue", size: 15)
                option3Lbl.text = option3
            }
        let option4 = item.covidData[3].option
            if item.covidData[3].isVoted {
                option4Lbl.font = UIFont(name: "HelveticaNeue-Medium", size: 15)
                option4Lbl.text = item.covidData[3].option
            } else {
                option4Lbl.font = UIFont(name: "HelveticaNeue", size: 15)
                option4Lbl.text = option4
            }
        
        
        
        
        
        let firstVoteCountString = item.covidData[0].votingCount
         let firstPercentageString = String(format: "%d", item.covidData[0].percentage)
        let firstAttribPercentString = NSMutableAttributedString(string: firstPercentageString + "%", attributes: [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue", size: 15)!])
        if firstVoteCountString == "1" || firstVoteCountString == "0" {
            let firstAttribVoteCountString = NSMutableAttributedString(string: ", (" + firstVoteCountString + " vote)", attributes: [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue", size: 15)!])
            firstAttribPercentString.append(firstAttribVoteCountString)
            perctCount1Lbl.attributedText = firstAttribPercentString
        } else {
            let firstAttribVoteCountString = NSMutableAttributedString(string: ", (" + firstVoteCountString + " votes)", attributes: [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue", size: 15)!])
            firstAttribPercentString.append(firstAttribVoteCountString)
            perctCount1Lbl.attributedText = firstAttribPercentString
        }
        
        let secVoteCountString = item.covidData[1].votingCount
         let secPercentageString = String(format: "%d", item.covidData[1].percentage)
        let secAttribPercentString = NSMutableAttributedString(string: secPercentageString + "%", attributes: [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue", size: 15)!])
        if secVoteCountString == "1" || secVoteCountString == "0" {
            let secAttribVoteCountString = NSMutableAttributedString(string: ", (" + secVoteCountString + " vote)", attributes: [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue", size: 15)!])
            secAttribPercentString.append(secAttribVoteCountString)
            perctCount2Lbl.attributedText = secAttribPercentString
        } else {
            let secAttribVoteCountString = NSMutableAttributedString(string: ", (" + secVoteCountString + " votes)", attributes: [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue", size: 15)!])
            secAttribPercentString.append(secAttribVoteCountString)
            perctCount2Lbl.attributedText = secAttribPercentString
        }
        
        let thirdVoteCountString = item.covidData[2].votingCount
         let thirdPercentageString = String(format: "%d", item.covidData[2].percentage)
        let thirdAttribPercentString = NSMutableAttributedString(string: thirdPercentageString + "%", attributes: [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue", size: 15)!])
        if thirdVoteCountString == "1" || thirdVoteCountString == "0" {
            let thirdAttribVoteCountString = NSMutableAttributedString(string: ", (" + thirdVoteCountString + " vote)", attributes: [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue", size: 15)!])
            thirdAttribPercentString.append(thirdAttribVoteCountString)
            perctCount3Lbl.attributedText = thirdAttribPercentString
        } else {
            let thirdAttribVoteCountString = NSMutableAttributedString(string: ", (" + thirdVoteCountString + " votes)", attributes: [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue", size: 15)!])
            thirdAttribPercentString.append(thirdAttribVoteCountString)
            perctCount3Lbl.attributedText = thirdAttribPercentString
        }
        
        let fourthVoteCountString = item.covidData[3].votingCount
             let fourthPercentageString = String(format: "%d", item.covidData[3].percentage)
            let fourthAttribPercentString = NSMutableAttributedString(string: fourthPercentageString + "%", attributes: [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue", size: 15)!])
            if fourthVoteCountString == "1" || fourthVoteCountString == "0" {
                let fourthAttribVoteCountString = NSMutableAttributedString(string: ", (" + fourthVoteCountString + " vote)", attributes: [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue", size: 15)!])
                fourthAttribPercentString.append(fourthAttribVoteCountString)
                perctCount4Lbl.attributedText = fourthAttribPercentString
            } else {
                let fourthAttribVoteCountString = NSMutableAttributedString(string: ", (" + fourthVoteCountString + " votes)", attributes: [NSAttributedString.Key.font : UIFont(name: "HelveticaNeue", size: 15)!])
                fourthAttribPercentString.append(fourthAttribVoteCountString)
                perctCount4Lbl.attributedText = fourthAttribPercentString
            }
        
        let firstPercentage = CGFloat(item.covidData[0].percentage)
        bar1WidthConstraint.constant = backBar1View.width  * (firstPercentage / 100)
        /*if firstPercentage <= 10 && firstPercentage > 0{
            bar1WidthConstraint.constant = backBar1View.width / 10
        } else if firstPercentage <= 20 && firstPercentage >= 10{
            bar1WidthConstraint.constant = backBar1View.width / 9
        } else if firstPercentage <= 30 && firstPercentage >= 20{
            bar1WidthConstraint.constant = backBar1View.width / 8
        } else if firstPercentage <= 40 && firstPercentage >= 30{
            bar1WidthConstraint.constant = backBar1View.width / 7
        } else if firstPercentage <= 50 && firstPercentage >= 40{
            bar1WidthConstraint.constant = backBar1View.width / 6
        } else if firstPercentage <= 60 && firstPercentage >= 50{
            bar1WidthConstraint.constant = backBar1View.width / 5
        } else if firstPercentage <= 70 && firstPercentage >= 60{
            bar1WidthConstraint.constant = backBar1View.width / 4
        } else if firstPercentage <= 80 && firstPercentage >= 70{
            bar1WidthConstraint.constant = backBar1View.width / 3
        } else if firstPercentage <= 90 && firstPercentage >= 80{
            bar1WidthConstraint.constant = backBar1View.width / 2
        } else if firstPercentage <= 100 && firstPercentage >= 90{
            bar1WidthConstraint.constant = backBar1View.width / 1
            //cell.percentBarWidthConstraint.constant = 343
        } else {
            bar1WidthConstraint.constant = 0
        }*/
        
        let secondPercentage = CGFloat(item.covidData[1].percentage)
        bar2WidthConstraint.constant = backBar2View.width  * (secondPercentage / 100)
        /*if secondPercentage <= 10 && secondPercentage > 0{
            bar2WidthConstraint.constant = backBar2View.width / 10
        } else if secondPercentage <= 20 && secondPercentage >= 10{
            bar2WidthConstraint.constant = backBar2View.width / 9
        } else if secondPercentage <= 30 && secondPercentage >= 20{
            bar2WidthConstraint.constant = backBar2View.width / 8
        } else if secondPercentage <= 40 && secondPercentage >= 30{
            bar2WidthConstraint.constant = backBar2View.width / 7
        } else if secondPercentage <= 50 && secondPercentage >= 40{
            bar2WidthConstraint.constant = backBar2View.width / 6
        } else if secondPercentage <= 60 && secondPercentage >= 50{
            bar2WidthConstraint.constant = backBar2View.width / 5
        } else if secondPercentage <= 70 && secondPercentage >= 60{
            bar2WidthConstraint.constant = backBar2View.width / 4
        } else if secondPercentage <= 80 && secondPercentage >= 70{
            bar2WidthConstraint.constant = backBar2View.width / 3
        } else if secondPercentage <= 90 && secondPercentage >= 80{
            bar2WidthConstraint.constant = backBar2View.width / 2
        } else if secondPercentage <= 100 && secondPercentage >= 90{
            bar2WidthConstraint.constant = backBar2View.width / 1
            //cell.percentBarWidthConstraint.constant = 343
        } else {
            bar2WidthConstraint.constant = 0
        }*/
        
        let thirdPercentage = CGFloat(item.covidData[2].percentage)
        bar3WidthConstraint.constant = backBar3View.width  * (thirdPercentage / 100)
        /*if thridPercentage <= 10 && thridPercentage > 0{
            bar3WidthConstraint.constant = backBar3View.width / 10
        } else if thridPercentage <= 20 && thridPercentage >= 10{
            bar3WidthConstraint.constant = backBar3View.width / 9
        } else if thridPercentage <= 30 && thridPercentage >= 20{
            bar3WidthConstraint.constant = backBar3View.width / 8
        } else if thridPercentage <= 40 && thridPercentage >= 30{
            bar3WidthConstraint.constant = backBar3View.width / 7
        } else if thridPercentage <= 50 && thridPercentage >= 40{
            bar3WidthConstraint.constant = backBar3View.width / 6
        } else if thridPercentage <= 60 && thridPercentage >= 50{
            bar3WidthConstraint.constant = backBar3View.width / 5
        } else if thridPercentage <= 70 && thridPercentage >= 60{
            bar3WidthConstraint.constant = backBar3View.width / 4
        } else if thridPercentage <= 80 && thridPercentage >= 70{
            bar3WidthConstraint.constant = backBar3View.width / 3
        } else if thridPercentage <= 90 && thridPercentage >= 80{
            bar3WidthConstraint.constant = backBar3View.width / 2
        } else if thridPercentage <= 100 && thridPercentage >= 90{
            bar3WidthConstraint.constant = backBar3View.width / 1
            //cell.percentBarWidthConstraint.constant = 343
        } else {
            bar3WidthConstraint.constant = 0
        }*/
        
        let fourthPercentage = CGFloat(item.covidData[3].percentage)
        bar4WidthConstraint.constant = backBar4View.width  * (fourthPercentage / 100)
        /*if fourthPercentage <= 10 && fourthPercentage > 0{
            bar4WidthConstraint.constant = 100 * (fourthPercentage / backBar4View.frame.width )
        } else if fourthPercentage <= 20 && fourthPercentage >= 10{
            bar4WidthConstraint.constant = backBar4View.width / 5
        } else if fourthPercentage <= 30 && fourthPercentage >= 20{
            bar4WidthConstraint.constant = backBar4View.width / 4
        } else if fourthPercentage <= 40 && fourthPercentage >= 30{
            bar4WidthConstraint.constant = backBar4View.width / 3
        } else if fourthPercentage <= 50 && fourthPercentage >= 40{
            bar4WidthConstraint.constant = backBar4View.width / 2
        } else if fourthPercentage <= 60 && fourthPercentage >= 50{
            bar4WidthConstraint.constant = backBar4View.width / 5
        } else if fourthPercentage <= 70 && fourthPercentage >= 60{
            bar4WidthConstraint.constant = backBar4View.width / 4
        } else if fourthPercentage <= 80 && fourthPercentage >= 70{
            bar4WidthConstraint.constant = backBar4View.width / 3
        } else if fourthPercentage <= 90 && fourthPercentage >= 80{
            bar4WidthConstraint.constant = backBar4View.width / 2
        } else if fourthPercentage <= 100 && fourthPercentage >= 90{
            bar4WidthConstraint.constant = backBar4View.width / 1
            //cell.percentBarWidthConstraint.constant = 343
        } else {
            bar4WidthConstraint.constant = 0
        }*/
    }
}

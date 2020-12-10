//
//  NewsTextCell.swift
//  myscrap
//
//  Created by MS1 on 10/25/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit


protocol FeedsNewsDelegate: class{
    func DidTapLikeCount(cell: NewsTextCell)
    func PerformLike(cell: NewsTextCell)
    func PerformContinueReading(cell: NewsTextCell)
    func PerformDetailNews(cell: NewsTextCell)
    func PerformComapny(cell: NewsTextCell)
    func performCompanyDetail(id: String)
}

extension FeedsNewsDelegate where Self: UIViewController{
    func performCompanyDetail(id: String){
        /*if  let vc = CompanyProfileVC.storyBoardInstance(){
            vc.companyId = id
            self.navigationController?.pushViewController(vc, animated: true)
        }*/
        if  let vc = CompanyDetailVC.storyBoardInstance() {
            vc.companyId = id
            UserDefaults.standard.set(vc.companyId, forKey: "companyId")
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


class NewsTextCell: BaseCell {

    weak var delegate : FeedsNewsDelegate?
    
    @IBOutlet weak var imageView: CircularImageView!
    @IBOutlet weak var newsHeadingLbl: UILabel!
    @IBOutlet weak var newSubHeadingLbl: NewsSubHeadingLabel!
    @IBOutlet weak var timeLbl: TimeLabel!
    @IBOutlet weak var companyButton: CompanyButton_News!
    @IBOutlet weak var newsDescriptionLbl: UILabel!
    @IBOutlet weak var likeCountBtn: LikeCountButton!
    @IBOutlet weak var commentCountBtn: CommentCountBtn!
    @IBOutlet weak var likeImgBtn: LikeImageButton!
    @IBOutlet weak var likeBtn: LikeButton!
    @IBOutlet weak var commentImgBtn: CommentImageButton!
    @IBOutlet weak var commentBtn: LikeButton!
    
    var feedItem: FeedItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupTaps()
    }
    
    func setupTaps(){
        newsDescriptionLbl.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleContiueReading(_:)))
        tap.numberOfTapsRequired = 1
        newsDescriptionLbl.addGestureRecognizer(tap)
        
        let imgTap = UITapGestureRecognizer(target: self, action: #selector(tappednewsProfileImage))
        imgTap.numberOfTapsRequired = 1
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(imgTap)
        
    }
    
    @objc
    private func tappednewsProfileImage(){
        if let item = feedItem{
            delegate?.performCompanyDetail(id: item.companyId)
        }
    }
    
    @objc private func handleContiueReading(_ sender: UITapGestureRecognizer){
        delegate?.PerformContinueReading(cell: self)
    }

    func configCell(item: FeedItem){
        
        imageView.setImageWithIndicator(imageURL: item.companyImage)
        
        newsHeadingLbl.text = item.heading
        newSubHeadingLbl.text = item.subHeading
        newsDescriptionLbl.attributedText = item.newsDescription
        timeLbl.text = item.timeStamp
        companyButton.companyName = item.companyName
        likeCountBtn.likeCount = item.likeCount
        commentCountBtn.likeCount = item.likeCount
        commentCountBtn.commentCount = item.commentCount
        likeImgBtn.isLiked = item.likeStatus 
    }
    
    @IBAction func likeCountPressed(){
        delegate?.DidTapLikeCount(cell: self)
    }
    
    @IBAction func likePressed(){
        delegate?.PerformLike(cell: self)
    }
    
    @IBAction func commentPressed(){
        delegate?.PerformDetailNews(cell: self)
    }
    
    @IBAction func companyPressed(){
        delegate?.PerformComapny(cell: self)
    }
}

//
//  AdvertismentCell.swift
//  myscrap
//
//  Created by MyScrap on 3/16/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit
import SDWebImage

class AdvertismentCell: BaseCell {
    @IBOutlet weak var adImageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var visitBtn: UIButton!
    @IBOutlet weak var outerView: UIView!
    @IBOutlet weak var websiteLbl: UILabel!
    @IBOutlet weak var shortNameLbl: UILabel!
    @IBOutlet weak var sponserLogoIV: UIImageView!
    @IBOutlet weak var sponserbyLbl: UILabel!
    @IBOutlet weak var sponsorCountryLbl: UILabel!
    @IBOutlet weak var bannerTitleLbl: UILabel!
    @IBOutlet weak var sliderAdImageView: MSSliderViewAd!
    
    
    var item : FeedV2Item? {
        didSet{
            guard let item = item else { return }
            configCell(withItem: item)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        outerView.layer.borderWidth = 0.5
//        outerView.layer.borderColor = UIColor.lightGray.cgColor
//        outerView.layer.shadowColor = UIColor.lightGray.cgColor
//        outerView.layer.shadowOffset = CGSize.zero
//        outerView.layer.shadowOpacity = 1
//        outerView.layer.shadowRadius = 10
//        outerView.layer.masksToBounds = true
        adImageView.layer.borderWidth = 0.2
        
        visitBtn.layer.cornerRadius = 10
        visitBtn.clipsToBounds = true
        visitBtn.layer.borderWidth = 0.5
        visitBtn.layer.borderColor = UIColor(hexString: "#959595").cgColor
        sliderAdImageView.pageControl.isHidden = false
        sliderAdImageView.countView.isHidden = true
        sliderAdImageView.img_count.isHidden = true
    }
    
    func configCell(withItem item: FeedV2Item) {
        titleLbl.text = item.title
        
        let attributedString = NSMutableAttributedString(string: item.description)
        // *** Create instance of `NSMutableParagraphStyle`
        let paragraphStyle = NSMutableParagraphStyle()
        
        // *** set LineSpacing property in points ***
        paragraphStyle.lineSpacing = 2 // Whatever line spacing you want in points
        
        // *** Apply attribute to string ***
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        descLbl.attributedText = attributedString
        
        downloadUrl(withItem: item)
        let urlLink = item.redirectURL.replacingOccurrences(of: "/", with: "")
        websiteLbl.text = urlLink
        sponserLogo(withItem: item)
        sponserbyLbl.text = item.sponserBy
        if item.adsType != "" {
            sponsorCountryLbl.text = "\(item.adsType) • \(item.bannerCountry)"
        } else {
            
            if item.bannerCountry != "" {
                sponsorCountryLbl.text = "\(item.bannerCountry)"
                sponsorCountryLbl.isHidden = false
            } else {
                sponsorCountryLbl.isHidden = true
            }
        }
        sponserbyLbl.textColor = UIColor(hexString: "\(item.ccodeAdv)")
        
        bannerTitleLbl.text = item.bannerTitle
        if let images = item.adsPictureUrl , !images.isEmpty {
            var data : [Images] = []
            for img in images{
                data.append(Images(imageURL: img, title: ""))
            }
            sliderAdImageView.dataSource = data
        } else {
            sliderAdImageView.dataSource = [Images(imageURL: "", title: "")]
        }
        
    }
    
    func downloadUrl(withItem item: FeedV2Item) {
         let downloadURL = URL(string: item.adImage)
        SDWebImageManager.shared().cachedImageExists(for: downloadURL) { (status) in
            if status{
                SDWebImageManager.shared().imageCache?.queryCacheOperation(forKey: downloadURL!.absoluteString, done: { (image, data, type) in
                    self.adImageView.image = image
                })
            } else {
                SDWebImageManager.shared().imageDownloader?.downloadImage(with: downloadURL, options: SDWebImageDownloaderOptions.continueInBackground, progress: nil, completed: { (image, data, error, status) in
                    if let error = error {
                        print("Error while downloading : \(error), Status :\(status), url :\(downloadURL)")
                    } else {
                        SDImageCache.shared().store(image, forKey: downloadURL!.absoluteString)
                        self.adImageView.image = image
                    }
                })
            }
        }
    }
    
    func sponserLogo(withItem item: FeedV2Item) {
        let downloadURL = URL(string: item.sponserLogo)
        
        SDWebImageManager.shared().cachedImageExists(for: downloadURL) { (status) in
            if status{
                SDWebImageManager.shared().imageCache?.queryCacheOperation(forKey: downloadURL!.absoluteString, done: { (image, data, type) in
                    self.sponserLogoIV.image = image
                })
            } else {
                SDWebImageManager.shared().imageDownloader?.downloadImage(with: downloadURL, options: SDWebImageDownloaderOptions.continueInBackground, progress: nil, completed: { (image, data, error, status) in
                    if let error = error {
                        print("Error while downloading : \(error), Status :\(status), url :\(downloadURL)")
                        self.shortNameLbl.text = item.sponserShortName
                    }
                    SDImageCache.shared().store(image, forKey: downloadURL!.absoluteString)
                    self.sponserLogoIV.image = image
                })
            }
        }
    }

    @IBAction func visitBtnNowTapped(_ sender: UIButton) {
        if network.reachability.isReachable == true {
            if let url = URL(string: (item?.visitMoreLink)!) {
                UIApplication.shared.open(url, options: [:])
            }
        } else {
            print("no internet")
        }
    }
}

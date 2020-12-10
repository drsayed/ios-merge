//
//  MarketListingCell.swift
//  myscrap
//
//  Created by MyScrap on 6/7/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit
import SDWebImage

protocol MarketDataCellDelegate: class {
    func didTap(cell: MarketListingCell)
    func didTapViewMore(cell: MarketListingCell)
    func didPressFavourite(cell: MarketListingCell)
}

class MarketListingCell: UICollectionViewCell {
    
    weak var delegate: MarketDataCellDelegate?
    
    var marketData: MarketData?{
        didSet {
            if let item = marketData{
                configure(with: item)
            }
        }
    }

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var viewImageButton: UIButton!
    @IBOutlet weak var viewCountButton: UIButton!
    @IBOutlet weak var viewMoreImgButton: UIButton!
    @IBOutlet weak var viewMoreButton: UIButton!
    @IBOutlet weak var favBtn: FavouriteButton!
    @IBOutlet weak var seenStatus: ProfileTypeView!
    @IBOutlet weak var expiredView: CorneredView!
    let favImg = #imageLiteral(resourceName: "fav").withRenderingMode(.alwaysTemplate)
    let fav = #imageLiteral(resourceName: "fav1").withRenderingMode(.alwaysTemplate)
    var listing_Id = ""
    
//    @IBOutlet weak var chatImageButton: UIButton!
//    @IBOutlet weak var chatButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        print("Inited")
        
    }
    
    
    func configure(with item: MarketData){
        //Right now userSeen parameters works as a opposite manner, so if seen = false (Normal) text.
        if item.userSeen == false {
            titleLabel.font = UIFont(name: "HelveticaNeue", size: 14)
            titleLabel.text = item.title ?? " "
        } else {
            titleLabel.text = item.title ?? " "
        }
        
        if item.postStatusExpire! {
            self.backgroundColor = UIColor(red: 209/255, green: 209/255, blue: 209/255, alpha: 1.0)
            self.expiredView.isHidden = false
        } else {
            self.backgroundColor = UIColor.white
            self.expiredView.isHidden = true
        }
        
        
        quantityLabel.text = item.quantity ?? ""
        flagImageView.image = UIImage(named: item.countryFlagCode) ?? nil
        countryLabel.text = item.place
        listing_Id = item.listingID!
        viewCountButton.setTitle(item.viewTitle, for: .normal)
        imageView.sd_setImage(with: URL(string: item.imageUrl ?? ""), placeholderImage: #imageLiteral(resourceName: "no-image"), options: .refreshCached, completed: nil)
        print("USER ID : \(AuthService.instance.userId), \(String(describing: item.user_data?.userId))")
        favBtn.isFavourite = item.isFav!
        
        if favBtn.isFavourite == false {
            favBtn.setImage(#imageLiteral(resourceName: "like"), for: .normal)
            favBtn.tintColor = UIColor.BLACK_ALPHA
        }
        else {
//            #imageLiteral(resourceName: "likeg")
            favBtn.setImage(UIImage(named: "likeg"), for: .normal)
            favBtn.tintColor = UIColor.GREEN_PRIMARY
        }
        
    }
    
    private func setButtonImage(type: MarketChatStatus){
        
    }
    
    
    @IBAction private func chatTapped(_ sender: UIButton){
        delegate?.didTap(cell: self)
    }
    
    @IBAction private func viewMoreTapped(_ sender: UIButton){
        delegate?.didTapViewMore(cell: self)
    }
    
    @IBAction func favBtnTapped(_ sender: UIButton) {
        if sender.tag == 0 {
            
            postFavourite(listingId: listing_Id)
            favBtn.isFavourite = true
            favBtn.setImage(UIImage(named: "likeg"), for: .normal)
            favBtn.tintColor = UIColor.GREEN_PRIMARY
            sender.tag = 1
        }
        else {
            postFavourite(listingId: listing_Id)
            favBtn.isFavourite = false
            favBtn.setImage(#imageLiteral(resourceName: "like"), for: .normal)
            favBtn.tintColor = UIColor.BLACK_ALPHA
            sender.tag = 0
        }
        
        //delegate?.didPressFavourite(cell: self)
    }
    //Insert/Remove favourite icon to the server
    func postFavourite(listingId: String){
        let api = APIService()
        api.endPoint = Endpoints.INSERT_FAVOURITE_LISTING
        api.params = "userId=\(AuthService.instance.userId)&ListingId=\(listingId)&apiKey=\(API_KEY)"
        api.getDataWith { (result) in
            switch result{
            case .Success(_):
                print("Successfully handled inserting / removing favourite posts")
            case .Error(let error):
                print("Error handled inserting / removing favourite posts." , error)
            }
        }
    }
    
}

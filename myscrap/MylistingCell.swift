//
//  MylistingCell.swift
//  myscrap
//
//  Created by MyScrap on 1/21/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit

protocol MylistingCellDelegate: class {
    func didTap(cell: MylistingCell)
    func didTapViewMore(cell: MylistingCell)
}

class MylistingCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var viewImageButton: UIButton!
    @IBOutlet weak var viewCountButton: UIButton!
    @IBOutlet weak var viewMoreImgButton: UIButton!
    @IBOutlet weak var viewMoreButton: UIButton!
    
    @IBOutlet weak var chatImageButton: UIButton!
    @IBOutlet weak var chatButton: UIButton!
    
    weak var delegate: MylistingCellDelegate?
    
    var mylistData: MyListingItems?{
        didSet {
            if let item = mylistData{
                configure(with: item)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(with item: MyListingItems){
        
        titleLabel.text = item.product
        quantityLabel.text = item.quantity + " MT"
        flagImageView.image = UIImage(named: item.flagcode) ?? nil
        countryLabel.text = " " + item.country_name
        viewCountButton.setTitle(item.total_view + " Views", for: .normal)
        imageView.sd_setImage(with: URL(string: item.imageUrl), placeholderImage: #imageLiteral(resourceName: "no-image"), options: .refreshCached, completed: nil)
        print("USER ID : \(AuthService.instance.userId), \(String(describing: item.user_id))")
        if item.type == "0" {
            chatButton.setTitle("SELL", for: .normal)
        } else {
            chatButton.setTitle("BUY", for: .normal)
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

}

//
//  ListDetailCell.swift
//  Market
//
//  Created by MyScrap on 7/12/18.
//  Copyright © 2018 mybucket. All rights reserved.
//

import UIKit
import SDWebImage
import MessageUI

protocol ListDetailDelegate : class{
    func chatBtnDelegate(listingId: String, listingTitle: String, listingType: String, listingImg: String)
}


class ListDetailCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var placeLabel: UILabel!
    
    
    @IBOutlet weak var listingIdlabel: UILabel!
    @IBOutlet weak var commodityLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var expiryLabel: UILabel!
    @IBOutlet weak var packingLabel: UILabel!
    @IBOutlet weak var shipmentLabel: UILabel!
    @IBOutlet weak var pricingLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var favBtn: FavouriteButton!
    @IBOutlet weak var publishedByView: UIView!
    @IBOutlet weak var origTitleLbl: UILabel!
    @IBOutlet weak var originLbl: UILabel!
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var profileView: ProfileView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var designationLbl: UILabel!
    @IBOutlet weak var companyLbl: UILabel!
    @IBOutlet weak var bottomLbl: UILabel!
    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var emailBtn: UIButton!
    @IBOutlet weak var chatBtn: UIButton!
    @IBOutlet weak var publishedByLbl: UILabel!
    
    //Layout Constraint
    @IBOutlet weak var callWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var emailWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var chatWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var chatHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var publishedViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var stackView: UIStackView!
    
    @IBOutlet weak var sliderView: MSSliderViewMarket!
    
    let favImg = #imageLiteral(resourceName: "fav").withRenderingMode(.alwaysTemplate)
    let fav = #imageLiteral(resourceName: "fav1").withRenderingMode(.alwaysTemplate)
    
    weak var delegate : MarketServiceDelegate?
    weak var chatDelegate : ListDetailDelegate?
    
    var emailValue = ""
    var callValue = ""
    
    var emailActionBlock: (() -> Void)? = nil
    var phoneActionBlock: (() -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        callBtn.layer.cornerRadius = 5
        callBtn.layer.borderWidth = 1
        callBtn.layer.borderColor = UIColor.lightGray.cgColor
        callBtn.clipsToBounds = true

        emailBtn.layer.cornerRadius = 5
        emailBtn.layer.borderWidth = 1
        emailBtn.layer.borderColor = UIColor.lightGray.cgColor
        emailBtn.clipsToBounds = true

        chatBtn.layer.cornerRadius = 5
        chatBtn.clipsToBounds = true
    }
    
    /*var data: DetailListing?{
        didSet{
            if let item = data{
                configure(with: item)
            }
        }
    }*/
    var viewListingData : [ViewListingItems]?{
        didSet{
            if let item = viewListingData{
                for lists in item {
                    for userData in lists.user_data {
                        configure(viewListing: lists, userData: userData)
                    }
                }
            }
        }
    }
    
    /*private func configure(with item: DetailListing){
        if let images = item.listingImg , !images.isEmpty {
            var data : [Images] = []
            for img in images{
                data.append(Images(imageURL: img, title: item.title))
            }
            sliderView.dataSource = data
        } else {
            sliderView.dataSource = [Images(imageURL: "", title: item.title)]
        }
        
        titleLabel.text = item.title
        
        flagImageView.image = UIImage(named: item.flagCode) ?? nil
        placeLabel.text = item.countryName + ", " + item.portName
        listingIdlabel.text = item.listingId
        commodityLabel.text = item.listingIsriCode
        favBtn.isFavourite = item.isFav
        
        if favBtn.isFavourite == false {
            favBtn.setImage(fav, for: .normal)
            favBtn.tintColor = UIColor.BLACK_ALPHA
        }
        else {
            favBtn.setImage(favImg, for: .normal)
            favBtn.tintColor = UIColor.GREEN_PRIMARY
        }
        
        //Payment Mode
        /*if item.paymentTerms == "0" {
            self.paymentLabel.text = "CAD"
        }
        else if item.paymentTerms == "1" {
            self.paymentLabel.text = "CASH"
        }
        else if item.paymentTerms == "2" {
            self.paymentLabel.text = "LC"
        }
        else if item.paymentTerms == "3" {
            self.paymentLabel.text = "TT"
        }*/
        //Shipment Type
        if item.shipmentTerm == "FOB" {
            self.shipmentLabel.text = "FOB"
        } else if item.shipmentTerm == "CNF"{
            self.shipmentLabel.text = "CNF"
        } else {
            self.shipmentLabel.text = "CIF"
        }
        //Pricing Terms
        if item.priceTerms == "0" {
            self.pricingLabel.text = "Fixed"
        }
        else if item.priceTerms == "1" {
            self.pricingLabel.text = "Unknown"
        }
        else if item.priceTerms == "2"{
            self.pricingLabel.text = "Other"
        } else {
            self.pricingLabel.text = "Spot"
        }
        
        if item.packaging == "0" {
            self.packingLabel.text = "Bags"
        }
        else if item.packaging == "1" {
            self.packingLabel.text = "Bale"
        }
        else if item.packaging == "2" {
            self.packingLabel.text = "Jumbo"
        }
        else if item.packaging == "3" {
            self.packingLabel.text = "Loose"
        }
        else if item.packaging == "4" {
            self.packingLabel.text = "Pallets"
        } else {
            self.packingLabel.text = "Other"
        }
        
        //packingLabel.text = AddListingPacking(rawValue: Int(item.packaging) ?? 0)?.description ?? " "
        //paymentLabel.text = AddListingPayment(rawValue: Int(item.paymentTerms) ?? 0)?.description ?? " "
        //pricingLabel.text = AddListingPriceTerms(rawValue: Int(item.priceTerms) ?? 0)?.description ?? ""
        rateLabel.text = item.rate
        quantityLabel.text = item.quantity + "MT"
        descriptionLabel.text = item.description
        expiryLabel.text = item.expiry
        
        
    }*/
    
    //Using ViewListingItems
    private func configure(viewListing: ViewListingItems, userData: PostedUserData) {
        if viewListing.listingType == "1" {
            origTitleLbl.text = "Destination"
        }
        
        originLbl.text = viewListing.countryName.firstLetterUppercased()
        if let images = viewListing.listingImg , !images.isEmpty {
            var data : [Images] = []
            for img in images{
                data.append(Images(imageURL: img, title: viewListing.title))
            }
            sliderView.dataSource = data
        } else {
            sliderView.dataSource = [Images(imageURL: "", title: viewListing.title)]
        }
        
        titleLabel.text = viewListing.title
        
        flagImageView.image = UIImage(named: viewListing.flagCode) ?? nil
        placeLabel.text = viewListing.countryName + ", " + viewListing.portName
        listingIdlabel.text = viewListing.listingId
        commodityLabel.text = viewListing.listingIsriCode
        favBtn.isFavourite = viewListing.isFav
        
        if favBtn.isFavourite == false {
            favBtn.setImage(fav, for: .normal)
            favBtn.tintColor = UIColor.BLACK_ALPHA
        }
        else {
            favBtn.setImage(favImg, for: .normal)
            favBtn.tintColor = UIColor.GREEN_PRIMARY
        }
        //Shipment Type
        if viewListing.shipmentTerm == "" {
            self.shipmentLabel.text = "-"
        } else {
            self.shipmentLabel.text = viewListing.shipmentTerm
        }
        
        //Pricing Terms
        if viewListing.priceTerms == "0" {
            self.pricingLabel.text = "Fixed"
        }
        else if viewListing.priceTerms == "1" {
            self.pricingLabel.text = "Unknown"
        }
        else if viewListing.priceTerms == "2"{
            self.pricingLabel.text = "Other"
        } else if viewListing.priceTerms == "3" {
            self.pricingLabel.text = "Spot"
        } else if viewListing.priceTerms == "4" {
            self.pricingLabel.text = "Message to quote"
        } else {
            self.pricingLabel.text = "Highest bid"
        }
        
        if viewListing.packaging == "0" {
            self.packingLabel.text = "Bags"
        }
        else if viewListing.packaging == "1" {
            self.packingLabel.text = "Bale"
        }
        else if viewListing.packaging == "2" {
            self.packingLabel.text = "Jumbo"
        }
        else if viewListing.packaging == "3" {
            self.packingLabel.text = "Loose"
        }
        else if viewListing.packaging == "4" {
            self.packingLabel.text = "Pallets"
        } else {
            self.packingLabel.text = "Others"
        }
        
        //packingLabel.text = AddListingPacking(rawValue: Int(item.packaging) ?? 0)?.description ?? " "
        //paymentLabel.text = AddListingPayment(rawValue: Int(item.paymentTerms) ?? 0)?.description ?? " "
        //pricingLabel.text = AddListingPriceTerms(rawValue: Int(item.priceTerms) ?? 0)?.description ?? ""
        rateLabel.text = viewListing.rate
        quantityLabel.text = viewListing.quantity + "MT"
        descriptionLabel.text = viewListing.description.firstLetterUppercased()
        expiryLabel.text = viewListing.expiry
        
        //emailBtn.translatesAutoresizingMaskIntoConstraints = false
        //callBtn.translatesAutoresizingMaskIntoConstraints = false
        //chatBtn.translatesAutoresizingMaskIntoConstraints = false
        
        //UserData
        if viewListing.listingType == "0" {
            publishedByLbl.text = "Seller"
        } else {
            publishedByLbl.text = "Buyer"
        }
        
        emailValue = userData.contactMeEmail
        callValue = userData.contactMePhoneCode + " - " + userData.contactMePhoneNo
        if userData.user_id == AuthService.instance.userId {
            publishedViewHeightConstraint.constant = 0
            publishedByView.isHidden = true
        } else {
            if userData.contactMeChat != "" && userData.contactMeEmail == "" && userData.contactMePhoneNo == "" {
                //Only chat
                publishedViewHeightConstraint.constant = 188
                emailWidthConstraint.constant = 0
                emailBtn.isHidden = true
                callWidthConstraint.constant = 0
                callBtn.isHidden = true
                stackViewHeightConstraint.constant = 0
                stackView.isHidden = true
                
                let name = userData.first_name + " " + userData.last_name
                profileView.updateViews(name: name, url: userData.profile_img, colorCode: userData.colorcode)
                userNameLbl.text = name
                if userData.company != "" {
                    designationLbl.text = userData.designation + "  •  " + userData.company
                } else {
                    designationLbl.text = userData.designation
                }
                //companyLbl.text = userData.company
                
            } else if userData.contactMeChat == "" && userData.contactMeEmail != "" && userData.contactMePhoneNo == "" {
                
                ////Only with Email
                publishedViewHeightConstraint.constant = 188
                callWidthConstraint.constant = 0
                callBtn.isHidden = true
                emailWidthConstraint.constant = stackView.width
                chatHeightConstraint.constant = 0
                chatBtn.isHidden = true
                
                let name = userData.first_name + " " + userData.last_name
                profileView.updateViews(name: name, url: userData.profile_img, colorCode: userData.colorcode)
                userNameLbl.text = name
                if userData.company != "" {
                    designationLbl.text = userData.designation + "  •  " + userData.company
                } else {
                    designationLbl.text = userData.designation
                }
                
                //companyLbl.text = userData.company
            } else if userData.contactMeChat == "" && userData.contactMeEmail == "" && userData.contactMePhoneNo != "" {
                ////Only with Call
                publishedViewHeightConstraint.constant = 188
                emailWidthConstraint.constant = 0
                emailBtn.isHidden = true
                callWidthConstraint.constant = stackView.width
                chatHeightConstraint.constant = 0
                chatBtn.isHidden = true
                
                let name = userData.first_name + " " + userData.last_name
                profileView.updateViews(name: name, url: userData.profile_img, colorCode: userData.colorcode)
                userNameLbl.text = name
                if userData.company != "" {
                    designationLbl.text = userData.designation + "  •  " + userData.company
                } else {
                    designationLbl.text = userData.designation
                }
                //companyLbl.text = userData.company
            } else if userData.contactMeChat == "" && userData.contactMeEmail != "" && userData.contactMePhoneNo != "" {
                // With Email and call
                publishedViewHeightConstraint.constant = 188
                chatHeightConstraint.constant = 0
                chatBtn.isHidden = true
                
                let name = userData.first_name + " " + userData.last_name
                profileView.updateViews(name: name, url: userData.profile_img, colorCode: userData.colorcode)
                userNameLbl.text = name
                if userData.company != "" {
                    designationLbl.text = userData.designation + "  •  " + userData.company
                } else {
                    designationLbl.text = userData.designation
                }
                //companyLbl.text = userData.company
            } else if userData.contactMeChat != "" && userData.contactMeEmail != "" && userData.contactMePhoneNo == "" {
                //With Email and chat
                publishedViewHeightConstraint.constant = 218
                callWidthConstraint.constant = 0
                callBtn.isHidden = true
                emailWidthConstraint.constant = stackView.width
                
                let name = userData.first_name + " " + userData.last_name
                profileView.updateViews(name: name, url: userData.profile_img, colorCode: userData.colorcode)
                userNameLbl.text = name
                if userData.company != "" {
                    designationLbl.text = userData.designation + "  •  " + userData.company
                } else {
                    designationLbl.text = userData.designation
                }
                //companyLbl.text = userData.company
            } else if userData.contactMeChat != "" && userData.contactMeEmail == "" && userData.contactMePhoneNo != "" {
                //With Call and chat
                publishedViewHeightConstraint.constant = 218
                callWidthConstraint.constant = stackView.width
                emailWidthConstraint.constant = 0
                emailBtn.isHidden = true
                
                
                let name = userData.first_name + " " + userData.last_name
                profileView.updateViews(name: name, url: userData.profile_img, colorCode: userData.colorcode)
                userNameLbl.text = name
                if userData.company != "" {
                    designationLbl.text = userData.designation + "  •  " + userData.company
                } else {
                    designationLbl.text = userData.designation
                }
                //companyLbl.text = userData.company
            } else if userData.contactMeChat != "" && userData.contactMeEmail != "" && userData.contactMePhoneNo != "" {
                if userData.contactMeChat == "0" {
                    publishedViewHeightConstraint.constant = 188
                    chatHeightConstraint.constant = 0
                    chatBtn.isHidden = true
                    
                } else {
                    publishedViewHeightConstraint.constant = 218
                }
                //With ALL (chat, email,phone)
                print("No design change")
                
                
                let name = userData.first_name + " " + userData.last_name
                profileView.updateViews(name: name, url: userData.profile_img, colorCode: userData.colorcode)
                userNameLbl.text = name
                if userData.company != "" {
                    designationLbl.text = userData.designation + "  •  " + userData.company
                } else {
                    designationLbl.text = userData.designation
                }
                //companyLbl.text = userData.company
            } else if userData.contactMeChat == "" && userData.contactMeEmail == "" && userData.contactMePhoneNo == "" {
                //All empty
                publishedViewHeightConstraint.constant = 148
                let name = userData.first_name + " " + userData.last_name
                profileView.updateViews(name: name, url: userData.profile_img, colorCode: userData.colorcode)
                userNameLbl.text = name
                if userData.company != "" {
                    designationLbl.text = userData.designation + "  •  " + userData.company
                } else {
                    designationLbl.text = userData.designation
                }
                //companyLbl.text = userData.company
                callWidthConstraint.constant = 0
                callBtn.isHidden = true
                emailWidthConstraint.constant = 0
                emailBtn.isHidden = true
                stackViewHeightConstraint.constant = 0
                stackView.isHidden = true
                chatHeightConstraint.constant = 0
                chatBtn.isHidden = true
            }
        }
    }
    
    @IBAction func favBtnPressed(_ sender: UIButton) {
        print("Listing ID : \(listingIdlabel.text!)")
        
        /*if favBtn.isFavourite == false {
            favBtn.setImage(fav, for: .normal)
            favBtn.tintColor = UIColor.BLACK_ALPHA
            postFavourite(listingId: listingIdlabel.text!)
        }
        else {
            favBtn.setImage(favImg, for: .normal)
            favBtn.tintColor = UIColor.GREEN_PRIMARY
            postFavourite(listingId: listingIdlabel.text!)
        }*/
        
        
        if sender.tag == 0 {
            
            postFavourite(listingId: listingIdlabel.text!)
            favBtn.isFavourite = true
            favBtn.setImage(favImg, for: .normal)
            favBtn.tintColor = UIColor.GREEN_PRIMARY
            sender.tag = 1
        }
        else {
            postFavourite(listingId: listingIdlabel.text!)
            favBtn.isFavourite = false
            favBtn.setImage(fav, for: .normal)
            favBtn.tintColor = UIColor.BLACK_ALPHA
            sender.tag = 0
        }
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
    
    @IBAction func emailBtnTapped(_ sender: UIButton) {
        /*if sender.tag == 0 {
            emailBtn.setTitle("\(emailValue)", for: .normal)
        }*/
        emailActionBlock?()
    }
    
    
    @IBAction func callBtnTapped(_ sender: UIButton) {
        /*if sender.tag == 0 {
            callBtn.setTitle("\(callValue)", for: .normal)
        }*/
        phoneActionBlock?()
    }
    @IBAction func chatBtnTapped(_ sender: UIButton) {
        if viewListingData?.last?.listingType == "0" {
            chatDelegate?.chatBtnDelegate(listingId: listingIdlabel.text!, listingTitle: (viewListingData?.last!.listingIsriCode)! + ", " + (viewListingData?.last!.listingProductName)!, listingType: "SELL", listingImg: (viewListingData?.last?.listingImg!.first)!)
        } else {
            chatDelegate?.chatBtnDelegate(listingId: listingIdlabel.text!, listingTitle: (viewListingData?.last!.listingIsriCode)! + ", " + (viewListingData?.last!.listingProductName)!, listingType: "BUY", listingImg: (viewListingData?.last?.listingImg!.first)!)
        }
        
    }
}

class Images: MSSliderDataSource, MarketPhotoViewable{
    var image: UIImage?
    
    var title: String?
    
    var imageURL: String?
    
    init(imageURL: String , title: String) {
        self.imageURL = imageURL
        self.title = title
    }
    
    
    func loadImageWithCompletionHandler(_ completion: @escaping MarketPhotoViewable.imageHandler) {
        if let urlString = imageURL , let url = URL(string: urlString){
            
            SDWebImageManager.shared().cachedImageExists(for: url) { (status) in
                if status{
                    SDWebImageManager.shared().imageCache?.queryCacheOperation(forKey: url.absoluteString, done: { (image, data, type) in
                        
                        completion(image, nil)
                    })
                } else {
                    SDWebImageManager.shared().imageDownloader?.downloadImage(with: url, options: SDWebImageDownloaderOptions.continueInBackground, progress: nil, completed: { (image, data, error, status) in
                        SDImageCache.shared().store(image, forKey: url.absoluteString)
                        
                        completion(image, error)
                    })
                }
            }
        } else {
            SDWebImageManager.shared().imageDownloader?.downloadImage(with: nil, progress: nil, completed: { (image, data, error, status) in
                
                completion(image, error)
            })
        }
    }
}

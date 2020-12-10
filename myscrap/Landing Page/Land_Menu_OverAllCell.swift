//
//  Land_Menu_OverAllCell.swift
//  myscrap
//
//  Created by MyScrap on 1/15/20.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit

protocol LandMenuDelegate : class {
    func didTapPrices()
    func didTapChat()
    func didTapDiscover()
    func didTapCompany()
    func didTapMembers()
}

class Land_Menu_OverAllCell: BaseCell {
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate : LandMenuDelegate?
    
    //var item = [LMenuItems]()
    var menuItem = [LMenuItems]()
    
    var item : LandingItems?{
        didSet{
            if let item = item?.dataMenuShortcut{
                menuItem = item
                //collectionView.reloadData()
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        //collectionView.register(Land_Menu_Scroll.Nib, forCellWithReuseIdentifier: Land_Menu_Scroll.identifier)
    }
    
}
extension Land_Menu_OverAllCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return menuItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Land_Menu_Scroll", for: indexPath) as? Land_Menu_Scroll else { return UICollectionViewCell()}
        
        let menuBtnTitle: [String] = ["Prices", "Chat", "Discover", "Companies", "Members"]
        let menuImgs: [UIImage] = [UIImage(named: "land-prices")!,
                                   UIImage(named: "land-chat")!,
                                   UIImage(named: "land-discover")!,
                                   UIImage(named: "land-companies")!,
                                   UIImage(named: "land-members")!]
        
        let menu = menuItem[indexPath.row]
        
        if menu.itemName == "prices" {
            cell.menuTxtLbl.text = menuBtnTitle[indexPath.item]
            cell.menuBtn.setImage(menuImgs[indexPath.item], for: .normal)
        } else if menu.itemName == "chat" {
            cell.menuTxtLbl.text = menuBtnTitle[indexPath.item]
            cell.menuBtn.setImage(menuImgs[indexPath.item], for: .normal)
        } else if menu.itemName == "discover" {
            cell.menuTxtLbl.text = menuBtnTitle[indexPath.item]
            cell.menuBtn.setImage(menuImgs[indexPath.item], for: .normal)
        } else if menu.itemName == "companies" {
            cell.menuTxtLbl.text = menuBtnTitle[indexPath.item]
            cell.menuBtn.setImage(menuImgs[indexPath.item], for: .normal)
        } else if menu.itemName == "members" {
            cell.menuTxtLbl.text = menuBtnTitle[indexPath.item]
            cell.menuBtn.setImage(menuImgs[indexPath.item], for: .normal)
        }
        
        cell.menuActionBlock = {
            if menu.itemName == "prices" {
                self.delegate?.didTapPrices()
            } else if menu.itemName == "chat" {
                self.delegate?.didTapChat()
            } else if menu.itemName == "discover" {
                self.delegate?.didTapDiscover()
            } else if menu.itemName == "companies" {
                self.delegate?.didTapCompany()
            } else if menu.itemName == "members" {
                self.delegate?.didTapMembers()
            }
        }
        
        let bgView: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(menuTapped(tapGesture:)))
        bgView.numberOfTapsRequired = 1
        cell.menuBGView.isUserInteractionEnabled = true
        cell.menuBGView.tag = indexPath.item
        cell.menuBGView.addGestureRecognizer(bgView)
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let menu = menuItem[indexPath.row]
        if indexPath.row == 0 {
            self.delegate?.didTapPrices()
        } else if indexPath.row == 1 {
            self.delegate?.didTapChat()
        } else if indexPath.row == 2 {
            self.delegate?.didTapDiscover()
        } else if indexPath.row == 3 {
            self.delegate?.didTapCompany()
        } else if indexPath.row == 4 {
            self.delegate?.didTapMembers()
        }
        /*if menu.itemName == "prices" {
         self.delegate?.didTapPrices()
         } else if menu.itemName == "chat" {
         self.delegate?.didTapChat()
         } else if menu.itemName == "discover" {
         self.delegate?.didTapDiscover()
         } else if menu.itemName == "companies" {
         self.delegate?.didTapCompany()
         } else if menu.itemName == "members" {
         self.delegate?.didTapMembers()
         }*/
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let width = self.frame.width
        return CGSize(width: 72, height: 80)    //187.5 h : 279
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    @objc func menuTapped(tapGesture: UITapGestureRecognizer) {
        let menu = menuItem[tapGesture.view!.tag]
        if menu.itemName == "prices" {
            self.delegate?.didTapPrices()
        } else if menu.itemName == "chat" {
            self.delegate?.didTapChat()
        } else if menu.itemName == "discover" {
            self.delegate?.didTapDiscover()
        } else if menu.itemName == "companies" {
            self.delegate?.didTapCompany()
        } else if menu.itemName == "members" {
            self.delegate?.didTapMembers()
        }
    }
}

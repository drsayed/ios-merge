//
//  UpdateProfileViewCell.swift
//  myscrap
//
//  Created by MyScrap on 11/3/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit




class UpdateProfileViewCell: BaseCell {
    
    weak var delegate: FeedsDelegate?
    
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var updateUserIV: UIImageView!
    @IBOutlet weak var update: UILabel!
    @IBOutlet weak var completeLbl: UILabel!
    @IBOutlet weak var completeBtn: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    
    
    
    
    
    @IBAction func completerBtnPressed(_ sender: Any) {
        //performEditProfile()
        delegate?.didTapCompleteProfile(cell: self)
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        delegate?.didTapClose(cell: self)
        
    }
    private func performEditProfile(){
//        if let vc = EditProfileController.storyBoardInstance(){
//            vc.delegate = self
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
    }
}

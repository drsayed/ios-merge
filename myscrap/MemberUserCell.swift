//
//  MemberUserCell.swift
//  myscrap
//
//  Created by MyScrap on 12/5/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit

class MemberUserCell: UICollectionViewCell {

    @IBOutlet weak var timeLbl: TimeLabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var designationLbl: DesignationLabel!
    @IBOutlet weak var likeCountBtn: LikeCountButton!
    @IBOutlet weak var commentCountBtn: CommentCountBtn!
    @IBOutlet weak var reportBtn: ReportButton!
    @IBOutlet weak var likeImage: LikeImageButton!
    @IBOutlet weak var likeBtn: LikeButton!
    
    @IBOutlet weak var commentBtn: LikeButton!
    @IBOutlet weak var reportedView: ReportedView!
    @IBOutlet weak var unReportBtn: UnReportBtn!
    @IBOutlet weak var profileView: ProfileView!
    @IBOutlet weak var profileTypeView: ProfileTypeView!
    @IBOutlet weak var cmntImgBtn: CommentImageButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    /*var item : FeedItem? {
        didSet{
            guard let item = item else { return }
            configCell(withItem: item)
        }
    }
    
    @IBAction func likePressed(_ sender: UIButton){
        print("like item pressed")
        guard let item = item else { return }
        if let del = delegate {
            print("delegate is there")
        }
        
        delegate?.didTapLike(item: item, cell: self)
    }
    @IBAction func toDetailsVC(_ sender: UIButton){
        guard let item = item else { return }
        delegate?.didTapcomment(item: item)
    }
    
    @IBAction func likeCountPressed(_ sender: LikeCountButton) {
        guard let item = item else { return }
        delegate?.didTapLikeCount(item: item)
    }
    
    @IBAction func unreportBtnPressed(_ sender: UnReportBtn) {
        guard  let item = item else { return }
        delegate?.didTapUnReport(item: item, cell: self)
    }
    
    @IBAction func reportBtnPressed(_ sender: ReportButton) {
        //        if let wd = UIApplication.shared.delegate?.window {
        //            let vc = wd!.rootViewController?.childViewControllers
        //            for viewController in vc! {
        //                if viewController.isKind(of: FeedController) {
        //                    print("Found it!!!")
        //                    let rvc = ReportedVC()
        //                    rvc.didTapReportMod(cell: self)
        //                }
        //                else
        //                {
        //                    guard  let item = item else { return }
        //                    delegate?.didTapReport(item: item, cell: self)
        //                }
        //            }
        //
        //        }
        if sender.tag == 0 {
            guard  let item = item else { return }
            delegate?.didTapReport(item: item, cell: self)
        } else {
            guard  let item = item else { return }
            delegate?.didTapReportMod(item: item, cell: self)
            
            //FeedTextCell.modReport()
        }
        
        //        let vc = FeedController().childViewControllers
        //        for vcs in vc {
        //            if vcs.isKind(of: ReportedVC.self)
        //            {
        //                print("Found it!!!")
        //                let rvc = ReportedVC()
        //                rvc.didTapReportMod(cell: self)
        //            }
        //            else
        //            {
        //                guard  let item = item else { return }
        //                delegate?.didTapReport(item: item, cell: self)
        //            }
        //
        //        }
        
        //        if self.window?.rootViewController is ReportedVC {
        //            let vc = ReportedVC()
        //            vc.didTapReportMod(cell: self)
        //        }
        //        else {
        //            guard  let item = item else { return }
        //            delegate?.didTapReport(item: item, cell: self)
        //        }
        
    }*/

}

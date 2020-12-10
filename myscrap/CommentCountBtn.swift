//
//  CommentCountBtn.swift
//  myscrap
//
//  Created by MS1 on 10/30/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

class CommentCountBtn: UIButton {

    var likeCount: Int = 0 {
        didSet{
            configureTitle()
        }
    }
    
    var commentCount: Int = 0{
        didSet{
            configureTitle()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupViews()
    }
    
    private func setupViews(){
        setTitleColor(UIColor.darkGray, for: .normal)
        titleLabel?.font =  Fonts.likeCountFont
    }
    
    private func configureTitle(){
        if likeCount == 0{
            switch commentCount {
            case 0:
                setTitle("", for: .normal)
            case 1:
                setTitle("1 Comment", for: .normal)
            default:
                setTitle("\(commentCount) Comments", for: .normal)
            }
        } else {
            switch commentCount {
            case 0:
                setTitle("", for: .normal)
            case 1:
                setTitle(" •  1 Comment", for: .normal)
            default:
                setTitle(" •  \(commentCount) Comments", for: .normal)
            }
        }
    }
    
    private func setTitle(string: String){
        self.setTitle(string, for: .normal)
    }
}
class VideoCommentCountBtn: UIButton {
    
    var viewCount: Int = 0 {
        didSet{
            configureTitle()
        }
    }
    
    var commentCount: Int = 0{
        didSet{
            configureTitle()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupViews()
    }
    
    private func setupViews(){
        setTitleColor(UIColor.darkGray, for: .normal)
        titleLabel?.font =  Fonts.likeCountFont
    }
    
    private func configureTitle(){
        if viewCount == 0{
            switch commentCount {
            case 0:
                setTitle("", for: .normal)
            case 1:
                setTitle("1 Comment", for: .normal)
            default:
                setTitle("\(commentCount) Comments", for: .normal)
            }
        } else {
            switch commentCount {
            case 0:
                setTitle("", for: .normal)
            case 1:
                setTitle(" • 1 Comment", for: .normal)
            default:
                setTitle(" • \(commentCount) Comments", for: .normal)
            }
        }
    }
    
    private func setTitle(string: String){
        self.setTitle(string, for: .normal)
    }
}
class CommentCountBtnV2: UIButton {
    
    var commentCount: Int = 0{
        didSet{
            configureTitle()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupViews()
    }
    
    private func setupViews(){
        setTitleColor(UIColor.darkGray, for: .normal)
        titleLabel?.font =  Fonts.likeCountFont
    }
    
    private func configureTitle(){
        switch commentCount {
        case 0:
            setTitle("", for: .normal)
        case 1:
            setTitle("1 Comment", for: .normal)
        default:
            setTitle("\(commentCount) Comments", for: .normal)
        }
    }
    
    private func setTitle(string: String){
        self.setTitle(string, for: .normal)
    }
}

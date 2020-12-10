//
//  LikeCountButton.swift
//  myscrap
//
//  Created by MS1 on 10/30/17.
//  Copyright © 2017 . All rights reserved.
//

import UIKit

@IBDesignable
final class LikeCountButton: UIButton {
    
    var likeCount: Int = 0 {
        didSet{
            configTitle()
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
    
    private func configTitle(){
        if likeCount == 0{
            //setTitle(string: "0 Like •")
            setTitle(string: "")
        } else if likeCount == 1 {
            setTitle(string: "1 Like")
        } else if likeCount == -1 {
            setTitle(string: "")
        } else {
            setTitle(string: "\(likeCount) Likes")
        }
    }
    
    private func setTitle(string: String){
        setTitle(string, for: .normal)
    }
}
@IBDesignable
final class ViewCountButton: UIButton {
    
    var viewCount: Int = 0 {
        didSet{
            configTitle()
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
    
    private func configTitle(){
        if viewCount == 0{
            //setTitle(string: "0 Like •")
            setTitle(string: "")
        } else if viewCount == 1 {
            setTitle(string: "1 View")
        } else if viewCount == -1 {
            setTitle(string: "")
        } else {
            setTitle(string: "\(viewCount) Views")
        }
    }
    
    private func setTitle(string: String){
        setTitle(string, for: .normal)
    }
}

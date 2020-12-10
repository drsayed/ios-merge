//
//  LikeImageButton.swift
//  myscrap
//
//  Created by MS1 on 10/30/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit
class LikeImageButton: UIButton {
    
    var isLiked: Bool = false {
        didSet{
            UIView.animate(withDuration: 0.3) {
                self.configureView()
            }
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
    
    private func setupViews(){
        configureView()
      //  addTarget(self, action: #selector(activateButton(_:)), for: .touchUpInside)
    }
    
    private func configureView(){
      //  withRenderingMode(.alwaysTemplate)
        let image = isLiked ? #imageLiteral(resourceName: "likeg") : #imageLiteral(resourceName: "likefeed_48x48")
        setImage(image, for: .normal)
        tintColor = isLiked ? UIColor.GREEN_PRIMARY : UIColor.BLACK_ALPHA
    }
    
    @objc private func activateButton(_ button: UIButton){
        isLiked = !isLiked
        UIView.animate(withDuration: 0.3) {
            self.configureView()
        }
    }
}
class LandLikeImageButton: UIButton {
    
    var isLiked: Bool = false {
        didSet{
            UIView.animate(withDuration: 0.3) {
                self.configureView()
            }
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
    
    private func setupViews(){
        configureView()
        //  addTarget(self, action: #selector(activateButton(_:)), for: .touchUpInside)
    }
    
    private func configureView(){
        let image = isLiked ? #imageLiteral(resourceName: "likeg") : #imageLiteral(resourceName: "likefeed_48x48")
        setImage(image, for: .normal)
        tintColor = isLiked ? UIColor.MyScrapGreen : UIColor.MyScrapGreen
    }
    
    @objc private func activateButton(_ button: UIButton){
        isLiked = !isLiked
        UIView.animate(withDuration: 0.3) {
            self.configureView()
        }
    }
}
class LikeImageV2FeedButton: UIButton {
    
    var isLiked: Bool = false {
        didSet{
            UIView.animate(withDuration: 0.3) {
                self.configureView()
            }
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
    
    private func setupViews(){
        configureView()
        //  addTarget(self, action: #selector(activateButton(_:)), for: .touchUpInside)
    }
    
    private func configureView(){
        let image = isLiked ? #imageLiteral(resourceName: "likeg") : #imageLiteral(resourceName: "likefeed_48x48")
        setImage(image, for: .normal)
        tintColor = isLiked ? UIColor.GREEN_PRIMARY : UIColor.BLACK_ALPHA
    }
    
    @objc private func activateButton(_ button: UIButton){
        isLiked = !isLiked
        UIView.animate(withDuration: 0.3) {
            self.configureView()
        }
    }
}

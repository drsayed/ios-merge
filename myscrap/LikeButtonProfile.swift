//
//  LikeButtonProfile.swift
//  myscrap
//
//  Created by MyScrap on 12/12/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

class LikeButtonProfile: UIButton {
    
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
        let image = isLiked ? #imageLiteral(resourceName: "like_96x96_fill").withRenderingMode(.alwaysTemplate) : #imageLiteral(resourceName: "like_96x96").withRenderingMode(.alwaysTemplate)
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


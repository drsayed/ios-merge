//
//  FavButtonProfile.swift
//  myscrap
//
//  Created by MyScrap on 12/12/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

class Like
    
    var isFavourite: Bool = false {
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
    }
    
    private func configureView(){
        let image = isFavourite ? #imageLiteral(resourceName: "fav").withRenderingMode(.alwaysTemplate) : #imageLiteral(resourceName: "fav1").withRenderingMode(.alwaysTemplate)
        setImage(image, for: .normal)
        tintColor = isFavourite ? UIColor.GREEN_PRIMARY : UIColor.BLACK_ALPHA
    }
}


//
//  MyScrapTextView.swift
//  myscrap
//
//  Created by MyScrap on 7/17/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

class MyScrapTextView: RSKPlaceholderTextView{
    
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        
        super.init(frame: frame, textContainer: textContainer)
        setupViews()
    }
    
    private func setupViews(){
        tintColor = UIColor.MyScrapGreen
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.5
        layer.cornerRadius = 2
    }
    
}



class MyScrapTextfield : ACFloatingTextfield{
    // MARK:- Loading From NIB
    override open func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    // MARK:- Intialization
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    func setupViews(){
        selectedLineColor = UIColor.MyScrapGreen
        selectedPlaceHolderColor = UIColor.MyScrapGreen
        tintColor = UIColor.MyScrapGreen
        lineColor = UIColor.gray
    }
}

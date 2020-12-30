//
//  BaseCollectionCell.swift
//  myscrap
//
//  Created by MS1 on 10/12/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

class BaseCollectionCell: UICollectionViewCell {
    
    class var identifier: String {
        return String(describing: self)
    }
    class var nib: UINib{
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
}

class BaseTableCell: UITableViewCell {
    class var identifier: String{
        return String(describing: self)
    }
    class var nib: UINib{
        return UINib(nibName: String(describing: self), bundle: nil)
    }
}


class BaseCell: UICollectionViewCell{
    class var Nib: UINib{
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    class var identifier: String{
        return String(describing: self)
    }
    
}






class BaseCVCell:UICollectionViewCell{
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews(){
        
    }

    class var identifier: String{
        return String(describing: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
}

class BaseTVC: UITableViewCell{

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    class var Nib: UINib{
        return UINib(nibName: String(describing: self), bundle: nil)
    }
    
    class var identifier:String{
        return String(describing: self)
    }
    
    func setupViews(){
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
}




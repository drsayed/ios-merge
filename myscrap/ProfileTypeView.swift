//
//  ProfileTypeView.swift
//  myscrap
//
//  Created by MS1 on 7/24/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//



import UIKit

enum ProfileType:String{
    case new = "NEW"
    case mod = "MOD"
    case Admin = "ADMIN"
    case top = "TOP"
    case level = "LEVEL"
    case none
}
enum OnlineProfileType:String{
    case new = "NEW"
    case mod = "MOD"
    case Admin = "ADMIN"
    case top = "TOP"
    case level = "LVL"
    case none
}

typealias ProfileTypeScore = (isAdmin:Bool,isMod: Bool, isNew:Bool, rank:String?, isLevel:Bool, level:String?)

class ProfileTypeView: UIView{
    
    var type: ProfileType = .none{
        didSet{
            switch type {
            case .none:
                updateColorAndText(color: .clear, text: nil)
                break
            case .Admin:
                updateColorAndText(color: .GREEN_PRIMARY, text: type.rawValue)
                break
            case .mod:
                updateColorAndText(color: .MOD_COLOR, text: type.rawValue)
                break
            case .new:
                updateColorAndText(color: .NEW_COLOR, text: type.rawValue)
                break
            case .top:
                updateColorAndText(color: .GREEN_PRIMARY, text: "\(type.rawValue) \(checkType.rank!)")
                break
            case .level:
                updateColorAndText(color: .GREEN_PRIMARY, text: "\(type.rawValue) \(checkType.level!)")
            }
        }
    }
    
    let label: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.white
        lbl.font = UIFont(name: "HelveticaNeue", size: 8)
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    
    var checkType: ProfileTypeScore = ProfileTypeScore(false,false,false,nil,false,nil){
        didSet{
            type = getType()
        }
    }
    
    private func commonInit(){
        addSubview(label)
        label.fillSuperview()
        type = .none
    }
    
    
    private func getType() -> ProfileType{
        if checkType.isAdmin{
            return .Admin
        } else {
            if checkType.isMod{
                return .mod
            } else if checkType.isLevel {
                return .level
            } else {
                guard let score = checkType.rank , let rank = Int(score), rank <= 10 else {
                    if checkType.isNew{
                        return .new
                    } else {
                        return .none
                    }
                }
                return .top
            }
        }
    }

    
    private func updateColorAndText(color: UIColor, text: String?){
        self.backgroundColor = color
        label.text = text
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func layoutSubviews() {
        self.layer.cornerRadius = self.height / 2
        self.clipsToBounds = true
    }
}
class NewMembsProfileTypeView: UIView{
    
    var type: ProfileType = .none{
        didSet{
            switch type {
            case .none:
                updateColorAndText(color: .clear, text: nil)
                break
            case .Admin:
                updateColorAndText(color: .GREEN_PRIMARY, text: type.rawValue)
                break
            case .mod:
                updateColorAndText(color: .MOD_COLOR, text: type.rawValue)
                break
            case .new:
                updateColorAndText(color: .NEW_COLOR, text: type.rawValue)
                break
            case .top:
                updateColorAndText(color: .GREEN_PRIMARY, text: "\(type.rawValue) \(checkType.rank!)")
                break
            case .level:
                updateColorAndText(color: .GREEN_PRIMARY, text: "\(type.rawValue) \(checkType.level!)")
            }
        }
    }
    
    let label: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.white
        lbl.font = UIFont(name: "HelveticaNeue", size: 10)
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    
    var checkType: ProfileTypeScore = ProfileTypeScore(false,false,false,nil,false,nil){
        didSet{
            type = getType()
        }
    }
    
    private func commonInit(){
        addSubview(label)
        label.fillSuperview()
        type = .none
    }
    
    
    private func getType() -> ProfileType{
        if checkType.isAdmin{
            return .Admin
        } else {
            if checkType.isMod{
                return .mod
            } else {
                guard let score = checkType.rank , let rank = Int(score), rank <= 10 else {
                    if checkType.isNew{
                        return .new
                    } else {
                        return .none
                    }
                }
                return .top
            }
        }
    }
    
    
    private func updateColorAndText(color: UIColor, text: String?){
        self.backgroundColor = color
        label.text = text
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func layoutSubviews() {
        self.layer.cornerRadius = self.height / 2
        self.clipsToBounds = true
    }
}
class OnlineProfileTypeView: UIView{
    
    var type: OnlineProfileType = .none{
        didSet{
            switch type {
            case .none:
                updateColorAndText(color: .clear, text: nil)
                break
            case .Admin:
                updateColorAndText(color: .GREEN_PRIMARY, text: type.rawValue)
                break
            case .mod:
                updateColorAndText(color: .MOD_COLOR, text: type.rawValue)
                break
            case .new:
                updateColorAndText(color: .NEW_COLOR, text: type.rawValue)
                break
            case .top:
                updateColorAndText(color: .GREEN_PRIMARY, text: "\(type.rawValue) \(checkType.rank!)")
                break
            case .level:
                updateColorAndText(color: .GREEN_PRIMARY, text: "\(type.rawValue) \(checkType.level!)")
            }
        }
    }
    
    let label: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.white
        lbl.font = UIFont(name: "HelveticaNeue", size: 8)
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    
    var checkType: ProfileTypeScore = ProfileTypeScore(false,false,false,nil,false,nil){
        didSet{
            type = getType()
        }
    }
    
    private func commonInit(){
        addSubview(label)
        label.fillSuperview()
        type = .none
    }
    
    
    private func getType() -> OnlineProfileType{
        if checkType.isAdmin{
            return .Admin
        } else {
            if checkType.isMod{
                return .mod
            } else if checkType.isLevel {
                return .level
            } else {
                guard let score = checkType.rank , let rank = Int(score), rank <= 10 else {
                    if checkType.isNew{
                        return .new
                    } else {
                        return .none
                    }
                }
                return .top
            }
        }
    }

    
    private func updateColorAndText(color: UIColor, text: String?){
        self.backgroundColor = color
        label.text = text
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func layoutSubviews() {
        self.layer.cornerRadius = self.height / 2
        self.clipsToBounds = true
    }
}
class FeedProfileTypeView: UIView{
    
    var type: OnlineProfileType = .none{
        didSet{
            switch type {
            case .none:
                updateColorAndText(color: .clear, text: nil)
                break
            case .Admin:
                updateColorAndText(color: .GREEN_PRIMARY, text: type.rawValue)
                break
            case .mod:
                updateColorAndText(color: .MOD_COLOR, text: type.rawValue)
                break
            case .new:
                updateColorAndText(color: .NEW_COLOR, text: type.rawValue)
                break
            case .top:
                updateColorAndText(color: .GREEN_PRIMARY, text: "\(type.rawValue) \(checkType.rank!)")
                break
            case .level:
                updateColorAndText(color: .GREEN_PRIMARY, text: "\(type.rawValue) \(checkType.level!)")
            }
        }
    }
    
    let label: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.white
        lbl.font = UIFont(name: "HelveticaNeue", size: 11)
        lbl.textAlignment = .center
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    
    var checkType: ProfileTypeScore = ProfileTypeScore(false,false,false,nil,false,nil){
        didSet{
            type = getType()
        }
    }
    
    private func commonInit(){
        addSubview(label)
        bringSubviewToFront(label)
        label.fillSuperview()
        type = .none
    }
    
    
    private func getType() -> OnlineProfileType{
        if checkType.isAdmin{
            return .Admin
        } else {
            if checkType.isMod{
                return .mod
            } else if checkType.isLevel {
                return .level
            } else {
                guard let score = checkType.rank , let rank = Int(score), rank <= 10 else {
                    if checkType.isNew{
                        return .new
                    } else {
                        return .none
                    }
                }
                return .top
            }
        }
    }

    
    private func updateColorAndText(color: UIColor, text: String?){
        self.backgroundColor = color
        label.text = text
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func layoutSubviews() {
        self.layer.cornerRadius = self.height / 2
        self.clipsToBounds = true
    }
}

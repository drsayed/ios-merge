//
//  AboutProfileVC.swift
//  myscrap
//
//  Created by MS1 on 1/31/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit

class CompanyAboutVC: BaseVC {

    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.alignment = .fill
        sv.axis = .vertical
        return sv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        view.addSubview(stackView)
        
        stackView.anchor(leading: view.leadingAnchor, trailing: view.trailingAnchor, top: view.topAnchor, bottom: nil,padding: UIEdgeInsets.init(top: 8, left: 8, bottom: 0, right: 8))

        let phoneView = createButtonView(title: "Phone", text: "12345678910",textType: .phone)
        stackView.addArrangedSubview(phoneView)
        
        let website = createButtonView(title: "WebSite", text: "wwww.google.com", textType: .website)
        stackView.addArrangedSubview(website)
        
    }
    
    
    private func createButtonView(title: String, text: String, textType: ButtonTextType) -> AboutButtonView {
        let view = AboutButtonView(title: title, buttonText: text, textType: textType)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension CompanyAboutVC: AboutButtonViewDelegate{
    func didTapAlertButton(with text: String, of type: ButtonTextType) {
        print("Button Type :-" ,type.rawValue )
    }
}





enum ButtonTextType:String{
    case phone
    case website
    case address
    case none
}

protocol AboutButtonViewDelegate: class {
    func didTapAlertButton(with text: String, of type: ButtonTextType)
}


class AboutButtonView: UIView{
    
    private var textType: ButtonTextType = .none
    
    weak var delegate: AboutButtonViewDelegate?

    private let label: UILabel = {
        let lbl = UILabel()
        lbl.text = "Phone"
        lbl.backgroundColor = UIColor.red
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    
    private let detailBtn: UIButton = {
        let btn =  UIButton()
        btn.backgroundColor = UIColor.green
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.titleLabel?.textColor = Colors.GREEN_PRIMARY
        btn.contentHorizontalAlignment = .left
        btn.addTarget(self, action: #selector(tappedView), for: .touchUpInside)
        return btn
    }()
    
    private let borderView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.blue
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews(){
        
       
        
        
        addSubview(label)
        label.anchor(leading: leadingAnchor, trailing: trailingAnchor, top: topAnchor, bottom: nil, padding: UIEdgeInsets.init(top: 0, left: 8, bottom: 0, right: 8))
        
        addSubview(detailBtn)
        detailBtn.anchor(leading: label.leadingAnchor, trailing: label.trailingAnchor, top: label.bottomAnchor, bottom: nil)
        
        addSubview(borderView)
        borderView.anchor(leading: label.leadingAnchor, trailing: label.trailingAnchor, top: detailBtn.bottomAnchor, bottom: bottomAnchor, size: CGSize.init(width: 0, height: 1))
    }
    
    @objc private func tappedView(){
        if let text = label.text {
            delegate?.didTapAlertButton(with: text, of: textType)
        }
    }
    
    convenience init(title: String, buttonText: String, textType: ButtonTextType){
        self.init(frame: .zero)
        self.label.text = title
        self.detailBtn.setTitle(buttonText, for: .normal)
        self.textType = textType
    }
    
    
    
}




extension UIView{
 
    func anchor(leading: NSLayoutXAxisAnchor?, trailing: NSLayoutXAxisAnchor?, top: NSLayoutYAxisAnchor?, bottom: NSLayoutYAxisAnchor?, padding: UIEdgeInsets = .zero,size: CGSize = CGSize.zero){
        
        if let leading = leading{
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        if let trailing = trailing{
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
    func equealLeadingamdTrailing(to view: UIView){
        leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
    
}




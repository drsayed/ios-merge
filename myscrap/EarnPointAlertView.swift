//
//  EarnPointAlertView.swift
//  myscrap
//
//  Created by MS1 on 1/14/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit

class EarnPointAlertView: UIView , Modal, CheckBoxButtonDelegate{

    var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var dialogView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 2.0
        view.clipsToBounds = true
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let titleLabel : UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "Earn Points"
        lbl.font = UIFont(name: "HelveticaNeue", size: 22)
        lbl.textColor = UIColor.BLACK_ALPHA
        lbl.sizeToFit()
        return lbl
    }()
    
    lazy var  checkBoxbtn: CheckBoxButton = {
        let btn = CheckBoxButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.delegate = self
        return btn
    }()
    
    let okBtn: UIButton = {
        let btn  = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("OK", for: .normal)
        btn.setTitleColor(UIColor.GREEN_PRIMARY, for: .normal)
        btn.addTarget(self, action: #selector(EarnPointAlertView.okButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    
    lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [
            //createInnerStackView(point: "+1", text: "Receive a like."),
            //createInnerStackView(point: "+1", text: "Like a post."),
            //createInnerStackView(point: "+1", text: "Message a member."),
            //createInnerStackView(point: "+1", text: "Receive a comment."),
            //createInnerStackView(point: "+2", text: "Add a new post."),
            //createInnerStackView(point: "+2", text: "Comment a post."),
            createInnerStackView(point: "+1", text: "Receive like"),
            createInnerStackView(point: "+1", text: "Receive comment"),
            createInnerStackView(point: "+1", text: "Receive message"),
            createInnerStackView(point: "+1", text: "Video view by member"),
            createInnerStackView(point: "+1", text: "Post shared by member"),
            createInnerStackView(point: "+1", text: "10 replies from member"),
            createInnerStackView(point: "+3", text: "Online for 3 consecutive days"),
            createInnerStackView(point: "+5", text: "Followed by member"),
            createInnerStackView(point: "+1", text: "Profile photo update"),
            createInnerStackView(point: "+2", text: "Market post"),
            createInnerStackView(point: "+2", text: "Company review"),
            
            ])
        sv.axis = .vertical
        sv.distribution = .fill
        sv.alignment = .leading
        sv.spacing = 8.0
        sv.translatesAutoresizingMaskIntoConstraints  = false
        return sv
    }()

    func DidTapCheckBox(checked: Bool) {
        // todo notification in userDefaults
        NotificationService.instance.isMemberAlertNotified = !NotificationService.instance.isMemberAlertNotified
        print(NotificationService.instance.isMemberAlertNotified)
        print("hello")
    }
    
    @objc private func okButtonTapped(){
        dismiss(animated: true)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    private func setupViews(){
        addSubview(backgroundView)
        backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        backgroundView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        backgroundView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        
        addSubview(dialogView)
        dialogView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        dialogView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        dialogView.widthAnchor.constraint(equalToConstant:280).isActive = true
        
        
        dialogView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: dialogView.leadingAnchor, constant: 24),
            titleLabel.topAnchor.constraint(equalTo: dialogView.topAnchor, constant: 16),
            ])
        
        dialogView.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant : 16).isActive = true
        stackView.leadingAnchor.constraint(equalTo: dialogView.leadingAnchor, constant: 16).isActive = true
        
        
        
        dialogView.addSubview(checkBoxbtn)
        
        checkBoxbtn.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 15).isActive = true
        checkBoxbtn.leadingAnchor.constraint(equalTo: dialogView.leadingAnchor, constant: 24).isActive = true
//        checkBoxbtn.widthAnchor.constraint(equalToConstant: 30).isActive = true
//        checkBoxbtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        let lbl = initalizePointLbl(text: "Never Show again")
        dialogView.addSubview(lbl)
        
        lbl.centerYAnchor.constraint(equalTo: checkBoxbtn.centerYAnchor).isActive = true
        lbl.leadingAnchor.constraint(equalTo: checkBoxbtn.trailingAnchor, constant: 8).isActive = true
        
        
        dialogView.addSubview(okBtn)
        
        checkBoxbtn.bottomAnchor.constraint(equalTo: okBtn.bottomAnchor, constant: 0).isActive = true
        okBtn.trailingAnchor.constraint(equalTo: dialogView.trailingAnchor, constant: -30).isActive = true
        okBtn.bottomAnchor.constraint(equalTo: dialogView.bottomAnchor, constant: -15).isActive = true
        

    }
    
    private func createInnerStackView(point: String, text: String) -> UIStackView {
        let sv = UIStackView(arrangedSubviews: [
            initializePointView(point: point),
            initalizePointLbl(text: text)
            ])
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.alignment = .center
        sv.spacing = 8.0
        sv.translatesAutoresizingMaskIntoConstraints  = false
        return sv
    }
    
    
    private func initalizePointLbl(text: String) -> UILabel{
        let lbl = UILabel()
        lbl.text = text
        lbl.textColor = UIColor.BLACK_ALPHA
        lbl.font = UIFont(name: "HelveticaNeue", size: 14)!
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.sizeToFit()
        return lbl
    }
    
    private func initializePointView(point: String) -> EarnPointGoldView{
        let view = EarnPointGoldView(frame: .zero, point: point)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 35).isActive = true
        view.heightAnchor.constraint(equalToConstant: 35).isActive = true
        return view
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(){
        self.init(frame: UIScreen.main.bounds)
        
    }
    
    convenience init(view: UIView){
        self.init(frame: view.frame)
        
        
    }
    
    private func initialize(){
        
    }
}


class EarnPointGoldView: UIView{
    
    
   
    let pointLbl : UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = UIColor.white
        lbl.font = UIFont.boldSystemFont(ofSize: 13)
        return lbl
    }()
  
    
    init(frame: CGRect, point: String) {
        self.pointLbl.text = point
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupViews(){
        addSubview(pointLbl)
        pointLbl.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        pointLbl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
  
    override func layoutSubviews() {
        super.layoutSubviews()
        updateCornerRadius()
    }
    
    @IBInspectable var rounded: Bool = false{
        didSet{
            updateCornerRadius()
        }
    }
    
    func updateCornerRadius(){
        layer.cornerRadius = layer.frame.height / 2
        self.clipsToBounds = true
        self.layer.borderWidth = 3.0
        self.layer.borderColor = UIColor.init(hexString: "#FFB300").cgColor
        self.layer.backgroundColor = UIColor.init(hexString: "#FFC107").cgColor
    }
}

protocol CheckBoxButtonDelegate:class{
    func DidTapCheckBox(checked: Bool)
}


class CheckBoxButton: UIButton{
    
    var checked = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func setimage(){
        if checked {
            setImage(#imageLiteral(resourceName: "ic_check_box").withRenderingMode(.alwaysTemplate), for: .normal)
            tintColor = UIColor.GREEN_PRIMARY
        } else {
            setImage(#imageLiteral(resourceName: "ic_check_box_outline_blank").withRenderingMode(.alwaysTemplate), for: .normal)
            tintColor = UIColor.lightGray
        }
    }
    
    private func commonInit(){
        setimage()
        addTarget(self, action: #selector(CheckBoxButton.tappedCheckBoxButton), for: .touchUpInside)
        
    }
    
    weak var delegate: CheckBoxButtonDelegate?
    
    @objc private func tappedCheckBoxButton(){
        checked = !checked
        UIView.transition(with: self, duration: 0.33, options: .showHideTransitionViews, animations: { [weak self] in
            self?.setimage()
        }, completion: nil)
        delegate?.DidTapCheckBox(checked: checked)
    }
}




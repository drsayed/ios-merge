//
//  BottomTextView.swift
//  myscrap
//
//  Created by MS1 on 11/23/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit
@objc
protocol BottomTextViewDelegate: class {
    func DidTapSendBtn(text:String)
}

class BottomTextView: UIView, GrowingTextViewDelegate{
    
    weak var delegate: BottomTextViewDelegate?
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var textView: GrowingTextView!
    @IBOutlet weak var sendBtn: UIButton!
    
    var placeholder: String = "Write Something" {
        didSet{
            setupTextview()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("BottomTextView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        textView.delegate = self
        setupTextview()
        setupButton()
        textView.autocorrectionType = .no
    }
    
    private func setupTextview(){
        textView.placeHolder = placeholder
    }
    
    private func setupButton(){
        let img = #imageLiteral(resourceName: "send").withRenderingMode(.alwaysTemplate)
        sendBtn.setImage(img, for: .normal)
        validate(textView: textView)
    }
    
    private func clearTextView(){
        textView.text = ""
        validate(textView: textView)
    }
    
    private func validate(textView: UITextView){
        guard let text = textView.text , text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).isEmpty else {
            updateSendBtn(alive: false)
            return
        }
        updateSendBtn(alive: true)
    }
    
    private func updateSendBtn(alive: Bool){
        sendBtn.tintColor = alive ? UIColor.gray : UIColor.GREEN_PRIMARY
        sendBtn.isUserInteractionEnabled = alive ? false : true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        validate(textView: textView)
    }
    
    @IBAction private func sendBtnPressed(_ sender: UIButton){
        guard let text = textView.text else { return }
        clearTextView()
        delegate?.DidTapSendBtn(text: text)
    }
}

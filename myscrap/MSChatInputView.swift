
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit



public class MSChatInputView: UIView{
    
    public weak var delegate: MSInputViewDelegate?
    
    public private(set) var isOverMaxTextViewHeight = false
    
    public var showGalleryBtn: Bool = false {
        didSet{
            if showGalleryBtn{
               setupGalleryButton()
            }
        }
    }
    
    private var inputTextViewHeightAnchor: NSLayoutConstraint?
    private var inputTextViewLeadingAnchor: NSLayoutConstraint?
    
    
    private var textViewConstraintSet: NSLayoutConstraintSet?
    private var galleryBtnConstraintSet: NSLayoutConstraintSet?
    
    open var maxTextViewHeight: CGFloat = (UIScreen.main.bounds.height / 6).rounded() {
        didSet {
            inputTextViewHeightAnchor?.constant = maxTextViewHeight
            invalidateIntrinsicContentSize()
        }
    }
    
    public let inputTextView: InputTextView = {
        let tv = InputTextView()
        tv.backgroundColor = UIColor.white
        tv.tintColor = UIColor.MyScrapGreen
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    private let borderView: UIView = {
        let bv = UIView()
        bv.backgroundColor = UIColor.lightGray
        bv.translatesAutoresizingMaskIntoConstraints = false
        return bv
    }()
    
    private let galleryButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.blue
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let bgView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.white
        v.layer.cornerRadius = 17
        v.layer.masksToBounds = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    public let sendButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        let sendImage = UIImage(named: "send", in: InputGlobal.instance.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
        btn.setImage(sendImage, for: .normal)
        return btn
    }()
    let emojiButton: UIButton = {
       let btn = UIButton()
       btn.translatesAutoresizingMaskIntoConstraints = false
       //btn.addTarget(self, action: #selector(emojiButtonTapped), for: .touchUpInside)
       let sendImage = UIImage(named: "emoji", in: InputGlobal.instance.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
       btn.setImage(sendImage, for: .normal)
        btn.tintColor = UIColor.darkGray
       return btn
   }()
    
    public let cameraButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
        let sendImage = UIImage(named: "camera", in: InputGlobal.instance.bundle, compatibleWith: nil)//?.withRenderingMode(.alwaysTemplate)
        btn.setImage(sendImage, for: .normal)
        return btn
    }()
    
    public let addButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(AddButtonTapped), for: .touchUpInside)
        let sendImage = UIImage(named: "add_new", in: InputGlobal.instance.bundle, compatibleWith: nil)//?.withRenderingMode(.alwaysTemplate)
        btn.setImage(sendImage, for: .normal)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
  
    
    
    private func setup(){
        setupViews()
        setupObservers()
        setSendButton()
    }
    
    private func setupViews(){
        backgroundColor = UIColor(red: 222/255, green: 222/255, blue: 227/255, alpha: 1)
        UserDefaults.standard.set(false, forKey: "EmojiKeyboard")
        autoresizingMask = [.flexibleHeight]
        addSubview(borderView)
        addSubview(bgView)
        bgView.addSubview(inputTextView)
        addSubview(sendButton)
        addSubview(cameraButton)
        addSubview(addButton)
        addSubview(emojiButton)
        emojiButton.removeTarget(nil, action: nil, for: .allEvents)
        emojiButton.addTarget(self, action: #selector(emojiButtonTapped), for: .touchUpInside)

        self.bringSubviewToFront(emojiButton)
        borderView.setAnchors(leading: leadingAnchor, trailing: trailingAnchor, top: topAnchor, bottom: nil)
        borderView.setSize(width: nil, height: 1)
        
        bgView.setAnchors(leading: leadingAnchor, trailing: nil, top: topAnchor, bottom: bottomAnchor, padding: UIEdgeInsets(top: 8, left: 50, bottom: 8, right: 0))
        
        inputTextView.setAnchors(leading: bgView.leadingAnchor, trailing: nil, top: bgView.topAnchor, bottom: bgView.bottomAnchor, padding: UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 15))
        
        inputTextViewLeadingAnchor = inputTextView.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -17)
        inputTextViewLeadingAnchor?.isActive = true
        inputTextViewHeightAnchor = inputTextView.heightAnchor.constraint(equalToConstant: maxTextViewHeight)
        
        sendButton.setSize(width: 30, height: 30)
        sendButton.setAnchors(leading: bgView.trailingAnchor, trailing: trailingAnchor, top: nil, bottom: nil, padding: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 17))
        sendButton.setVerticalCenter(to: inputTextView)
        
        cameraButton.setSize(width: 30, height: 30)
        cameraButton.setAnchors(leading: bgView.trailingAnchor, trailing: trailingAnchor, top: nil, bottom: nil, padding: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 17))
        cameraButton.setVerticalCenter(to: inputTextView)
        
        addButton.setSize(width: 30, height: 30)
        addButton.setAnchors(leading: leadingAnchor, trailing: nil, top: nil, bottom: nil, padding: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 18))
        addButton.setVerticalCenter(to: inputTextView)
        
        emojiButton.setSize(width: 20, height: 20)
        emojiButton.setAnchors(leading:nil , trailing: sendButton.trailingAnchor, top: nil, bottom: nil, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 41))
        emojiButton.setVerticalCenter(to: inputTextView)
        
    }
    
    private func setupGalleryButton(){
        inputTextViewLeadingAnchor?.isActive = false
        bgView.addSubview(galleryButton)
        galleryButton.leadingAnchor.constraint(equalTo: inputTextView.trailingAnchor, constant: 5).isActive = true
        galleryButton.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -17).isActive = true
        galleryButton.centerYAnchor.constraint(equalTo: bgView.centerYAnchor).isActive = true
        galleryButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        galleryButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    private func setupObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(abc), name: UITextView.textDidChangeNotification, object: nil)
    }

    
    override public var intrinsicContentSize: CGSize {
        return cachedIntrinsicContentSize
    }
    
    private var cachedIntrinsicContentSize: CGSize = .zero
    
    public private(set) var previousIntrinsicContentSize: CGSize?
    
    /// Invalidates the view’s intrinsic content size
    open override func invalidateIntrinsicContentSize() {
        super.invalidateIntrinsicContentSize()
        cachedIntrinsicContentSize = calculateIntrinsicContentSize()
        if previousIntrinsicContentSize != cachedIntrinsicContentSize {
            previousIntrinsicContentSize = cachedIntrinsicContentSize
        }
    }
    
    /// Calculates the correct intrinsicContentSize of the MessageInputBar
    ///
    /// - Returns: The required intrinsicContentSize
    open func calculateIntrinsicContentSize() -> CGSize {
        
        let maxTextViewSize = CGSize(width: inputTextView.bounds.width, height: .greatestFiniteMagnitude)
        var inputTextViewHeight = inputTextView.sizeThatFits(maxTextViewSize).height.rounded()
        if inputTextViewHeight >= maxTextViewHeight {
            if !isOverMaxTextViewHeight {
                inputTextViewHeightAnchor?.isActive = true
                inputTextView.isScrollEnabled = true
                isOverMaxTextViewHeight = true
            }
            inputTextViewHeight = maxTextViewHeight
        } else {
            if isOverMaxTextViewHeight {
                inputTextViewHeightAnchor?.isActive = false
                inputTextView.isScrollEnabled = false
                isOverMaxTextViewHeight = false
                inputTextView.invalidateIntrinsicContentSize()
            }
        }
        let height = inputTextViewHeight + 1
        return CGSize(width: bounds.width, height: height)
    }

    @objc private func abc(){
        invalidateIntrinsicContentSize()
        setSendButton()
    }
    
    private func setSendButton(){
        let text = inputTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard text != "" else {
            sendButton.isEnabled = false
            sendButton.tintColor = UIColor.gray
            return
        }
        sendButton.isEnabled = true
        sendButton.tintColor = UIColor.MyScrapGreen
    }
    
    @objc
    private func emojiButtonTapped(){
        if emojiButton.tag == 0 {
            emojiButton.tag = 1
            
            UserDefaults.standard.set(true, forKey: "EmojiKeyboard")
            inputTextView.reloadInputViews()
            
        }
        else
        {
            emojiButton.tag = 0
            UserDefaults.standard.set(false, forKey: "EmojiKeyboard")
//            inputTextView.keyboardType = .default
            inputTextView.reloadInputViews()
        }
      
    }
    
    @objc
    private func sendButtonTapped(){
        guard let text = inputTextView.text else { return }
        let refinedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard refinedText != "" else { return }
        inputTextView.text = ""
        setSendButton()
        delegate?.didPressSendButton(with: refinedText)
    }
    
    @objc
    private func cameraButtonTapped(){
        delegate?.didPressCameraButton()
    }
    @objc
    private func AddButtonTapped(){
        delegate?.didPressAddButton()
    }
    
    override public func didMoveToWindow() {
        super.didMoveToWindow()
        if #available(iOS 11.0, *) {
            if let window = self.window {
                self.bottomAnchor.constraint(lessThanOrEqualToSystemSpacingBelow: window.safeAreaLayoutGuide.bottomAnchor, multiplier: 1.0).isActive = true
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
extension InputTextView {

   // required for iOS 13
    open override var textInputContextIdentifier: String? { "" } // return non-nil to show the Emoji keyboard ¯\_(ツ)_/¯

    open override var textInputMode: UITextInputMode? {
        if UserDefaults.standard.bool(forKey: "EmojiKeyboard") {
            for mode in UITextInputMode.activeInputModes {
                if mode.primaryLanguage == "emoji" {
                    return mode
                }
            }
        }
        else
        {
            for mode in UITextInputMode.activeInputModes {
                if mode.primaryLanguage == "en-US" {
                    return mode
                }
            }
        }
//        for mode in UITextInputMode.activeInputModes {
//            if UserDefaults.standard.bool(forKey: "EmojiKeyboard") {
//                if mode.primaryLanguage == "emoji" {
//                    return mode
//                }
//            }
//            else
//              {
//                  if mode.primaryLanguage == "en-US" {
//                      return mode
//                  }
//              }
//
//        }
        return nil
    }
}

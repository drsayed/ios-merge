
//  Copyright © 2018 Mac. All rights reserved.
//

import UIKit



public class MSInputView: UIView{
    
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
    
    private let sendButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        let sendImage = UIImage(named: "send", in: InputGlobal.instance.bundle, compatibleWith: nil)?.withRenderingMode(.alwaysTemplate)
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
        
        autoresizingMask = [.flexibleHeight]
        addSubview(borderView)
        addSubview(bgView)
        bgView.addSubview(inputTextView)
        addSubview(sendButton)
        
        borderView.setAnchors(leading: leadingAnchor, trailing: trailingAnchor, top: topAnchor, bottom: nil)
        borderView.setSize(width: nil, height: 1)
        
        bgView.setAnchors(leading: leadingAnchor, trailing: nil, top: topAnchor, bottom: bottomAnchor, padding: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 0))
        
        inputTextView.setAnchors(leading: bgView.leadingAnchor, trailing: nil, top: bgView.topAnchor, bottom: bgView.bottomAnchor, padding: UIEdgeInsets(top: 0, left: 17, bottom: 0, right: 0))
        
        inputTextViewLeadingAnchor = inputTextView.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -17)
        inputTextViewLeadingAnchor?.isActive = true
        inputTextViewHeightAnchor = inputTextView.heightAnchor.constraint(equalToConstant: maxTextViewHeight)
        
        sendButton.setSize(width: 30, height: 30)
        sendButton.setAnchors(leading: bgView.trailingAnchor, trailing: trailingAnchor, top: nil, bottom: nil, padding: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 17))
        sendButton.setVerticalCenter(to: inputTextView)
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
    private func sendButtonTapped(){
        guard let text = inputTextView.text else { return }
        let refinedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard refinedText != "" else { return }
        inputTextView.text = ""
        setSendButton()
        delegate?.didPressSendButton(with: refinedText)
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

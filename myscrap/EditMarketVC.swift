
//
//  EditMarketVC.swift
//  myscrap
//
//  Created by MyScrap on 6/18/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//


/*
 import UIKit

class EditMarketVC: UIViewController {
    
    var marketType: MarketType? {
        didSet{
            if let item = marketType{
                marketTypeTextField.text = item.stringRepresentation
            }
        }
    }
    
    @IBOutlet weak var textView: RSKPlaceholderTextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageOuterView: UIView!
    @IBOutlet weak var isriTextFld: ACFloatingTextfield!
    @IBOutlet weak var loadPortTextFld: ACFloatingTextfield!
    @IBOutlet weak var quantityTextField: ACFloatingTextfield!
    @IBOutlet weak var unitTextField: ACFloatingTextfield!
    @IBOutlet weak var expiryTextField: ACFloatingTextfield!
    @IBOutlet weak var marketTypeTextField: ACFloatingTextfield!
    
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var unitPickerView: UIPickerView?
    var expiryPickerView: UIPickerView?
    var typePickerView: UIPickerView?
    
    
    var expiry: MarketDuration?{
        didSet{
            if let item = expiry{
                expiryTextField.text = item.expiry
            }
        }
    }
    var unit: String?{
        didSet{
            if let item = unit {
                unitTextField.text = item
            }
        }
    }
    
    
    var unitdataSource = ["MT"]
    var expiryDataSource = [MarketDuration(value: 1, expiry: "One Month"),
                            MarketDuration(value: 2, expiry: "Two Months"),
                            MarketDuration(value: 3, expiry: "Three Months")
                            ]
    
    
    var isriItem: ISRI?{
        didSet {
            if let item = isriItem{
                isriTextFld.text = item.isri_code
            }
        }
    }
    
    var portItem: PortList?{
        didSet {
            if let item = portItem{
                loadPortTextFld.text = "\(item.port_name) , \(item.country_name)"
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        imageOuterView.layer.cornerRadius = 30
        imageOuterView.layer.borderWidth = 1
        imageOuterView.layer.borderColor = UIColor.lightGray.cgColor
        imageOuterView.layer.masksToBounds = true
        
        setupViews()
        setupTap()
        
        
        
    }
    
    private func setupViews(){
        setupTextView()
        setupPickerView()
        setupDelegates()
    }
    
    private func setupTextView(){
        textView.tintColor = UIColor.GREEN_PRIMARY
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 0.5
        textView.delegate = self
    }
    
    private func setupPickerView(){
        setupUnitPickerView()
        setupExpiryPickerView()
        setuptypePickerView()
    }
    
    
    
    
    private func setupUnitPickerView(){
        unitPickerView = UIPickerView()
        unitPickerView?.delegate = self
        unitTextField.inputView = unitPickerView
        setupToolBars(with: unitTextField)
    }
    
    private func setupExpiryPickerView(){
        expiryPickerView = UIPickerView()
        expiryPickerView?.delegate = self
        expiryTextField.inputView = expiryPickerView
        setupToolBars(with: expiryTextField)
    }
    
    private func setuptypePickerView(){
        typePickerView = UIPickerView()
        typePickerView?.delegate = self
        marketTypeTextField.inputView = typePickerView
        setupToolBars(with: marketTypeTextField)
    }
    
    
    private func setupDelegates(){
        isriTextFld.delegate = self
        loadPortTextFld.delegate = self
        quantityTextField.delegate = self
        unitTextField.delegate = self
        expiryTextField.delegate = self
    }
    
    private func setupTap(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tap.numberOfTapsRequired = 1
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func tapImage(_ sender: Any) {
        pickImage()
    }
    
    
    @objc
    private func handleTap(){
        view.endEditing(true)
    }
    
    var errorMessage: String{
        return "Please Fill"
    }
    
    let service = MarketService()
    
    @IBAction func imageEditClicked(_ sender: UIButton) {
        pickImage()
    }
    
    func pickImage(){
        let croppingParameters = CroppingParameters(isEnabled: true, allowResizing: false, allowMoving: true, minimumSize: CGSize.zero)
        let cameraViewController = CameraViewController.imagePickerViewController(croppingParameters: croppingParameters) { [weak self](image, asset) in
            if let img = image {
                self?.imageView.image = img
            }
            self?.dismiss(animated: true, completion: nil)
        }
        present(cameraViewController, animated: true, completion: nil)
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
     
        showerrorMessage(textfields: [isriTextFld, loadPortTextFld, quantityTextField, unitTextField, expiryTextField, marketTypeTextField])
        checkDescription()
        
        var media: [Media]?
        
        if let image = imageView.image{
            media = [Media(withImage: image, forKey: "uploadfile")!]
        }
        
        if let isri = isriItem, let loadPort = portItem , let description = textView.text, description != "", let quantity = quantityTextField.text, quantity != "", let unit = unitTextField.text, unit != "", let duration = expiry?.value , let type = marketType {
            
            if let window = UIApplication.shared.keyWindow{
                let overlay = UIView(frame: CGRect(x: window.frame.origin.x, y: window.frame.origin.y, width: window.frame.width, height: window.frame.height))
                overlay.alpha = 0.5
                overlay.backgroundColor = UIColor.black
                window.addSubview(overlay)
                
                let av = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
                av.center = overlay.center
                av.startAnimating()
                overlay.addSubview(av)
                
                
                service.postMarket(port: loadPort.id, listing: "0", isri: isri.id, description: description, quantity: quantity, unit: unit, duration: "\(duration)", type: type.rawValue, media: media, completion: { success in
                    av.stopAnimating()
                    overlay.removeFromSuperview()
                    if type == .sell{
                        NotificationCenter.default.post(name: Notification.Name.marketListingSellPosted, object: nil)
                    } else {
                        NotificationCenter.default.post(name: Notification.Name.marketListingBuyPosted, object: nil)
                    }
                    self.navigationController?.popViewController(animated: true)
                })
            }
        }
        
    }
    
    
    
    func callService(){
        
    }
    
    
    
    func showerrorMessage(textfields: [ACFloatingTextfield]){
        for textfield in textfields{
            if textfield.text == nil || textfield.text == ""{
                textfield.showErrorWithText(errorText: errorMessage)
            }
        }
    }
    
    private func checkDescription(){
        if textView.text == nil || textView.text == ""{
            let alert = UIAlertController(title: "Error", message: "Please Fill Description", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.view.tintColor = UIColor.GREEN_PRIMARY
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    


    static func storyBoardInstance() -> EditMarketVC? {
        return UIStoryboard.Market.instantiateViewController(withIdentifier: EditMarketVC.id) as? EditMarketVC
    }
    
}


extension EditMarketVC: UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        switch textField {
        case loadPortTextFld:
            let vc = PortListSearchController()
            let nav = UINavigationController(rootViewController: vc)
            vc.selection = { portlist in
                self.portItem = portlist
            }
            present(nav, animated: true, completion: nil)
            return false
        case isriTextFld:
            let vc = ISRISearchController()
            let nav = UINavigationController(rootViewController: vc)
            vc.selection = { isri in
                self.isriItem = isri
            }
            present(nav, animated: true, completion: nil)
            return false
        default:
            return true
        }
    }
}



extension EditMarketVC: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch  pickerView {
        case unitPickerView:
            return unitdataSource.count
        case expiryPickerView:
            return expiryDataSource.count
        case typePickerView:
            return MarketType.caseCount
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return dataSource(pickerView: pickerView, for: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView {
        case unitPickerView:
            unit = unitdataSource[row]
            unitTextField.resignFirstResponder()
            break
        case expiryPickerView:
            expiry = expiryDataSource[row]
            expiryTextField.resignFirstResponder()
            break
        case typePickerView:
            marketType = MarketType(rawValue: row) ?? .sell
            marketTypeTextField.resignFirstResponder()
            break
        default:
            break
        }
        
    }
    
    
    func dataSource(pickerView: UIPickerView, for row: Int) -> String{
        
        switch pickerView{
        case unitPickerView:
            return unitdataSource[row]
        case expiryPickerView:
            return expiryDataSource[row].expiry
        case typePickerView:
            return MarketType(rawValue: row)?.stringRepresentation ?? "Nil"
        default:
            return "Nil"
        }
        
        
    }
    
    private func setupToolBars(with textfield: UITextField){
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        toolbar.tintColor = UIColor.GREEN_PRIMARY
        toolbar.sizeToFit()
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
       
        var cancelButton :  UIBarButtonItem!
        
        switch textfield {
        case unitTextField:
            cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelunit))
            break
        case expiryTextField:
            cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelExpiry))
            break
        case marketTypeTextField:
            cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelType))
            break
        default:
            break
        }
        
        toolbar.setItems([spaceButton, cancelButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        textfield.inputAccessoryView = toolbar
    }
    
    @objc
    func cancelunit(){
        unitTextField.resignFirstResponder()
    }
    
    @objc
    func cancelExpiry(){
        expiryTextField.resignFirstResponder()
    }
    
    @objc
    func cancelType(){
        marketTypeTextField.resignFirstResponder()
    }
    
}

extension EditMarketVC: UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let wordCount = newText.components(separatedBy: .whitespacesAndNewlines).filter{ !$0.isEmpty }.count
        return wordCount <= 100
    }
}



struct MarketDuration{
    let value: Int
    let expiry: String
}

*/




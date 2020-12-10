//
//  AddListingPickerViewModel.swift
//  myscrap
//
//  Created by MyScrap on 7/18/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import Foundation


class AddListingPickerViewModel: NSObject, UIPickerViewDelegate, UIPickerViewDataSource , UITextFieldDelegate{
    
    var shipment : ((AddListingShipment) -> ())?
    var pricing : ((AddListingPriceTerms) -> ())?
    var packing : ((AddListingPacking) -> ())?
    var expiry : ((AddListingExpiry) -> ())?
    
    private var paymentPickerView = UIPickerView()
    private var pricingPickerView = UIPickerView()
    private var packingPickerView = UIPickerView()
    private var expiryPickerView = UIPickerView()
    
    private var paymentTextField: UITextField
    private var packingTextField: UITextField
    private var priceTextField: UITextField
    private var expiryTextField: UITextField
    
    init(paymentTextField: UITextField, packingTextField: UITextField, priceTextField: UITextField, expiryTextField: UITextField) {
        self.paymentTextField = paymentTextField
        self.packingTextField = packingTextField
        self.priceTextField = priceTextField
        self.expiryTextField = expiryTextField
        super.init()
        self.setupViews()
    }
    
    private func setupViews(){
        
        setupDelegateAndDataSource(for: [paymentPickerView, pricingPickerView, packingPickerView, expiryPickerView])
        paymentTextField.inputView = paymentPickerView
        packingTextField.inputView = packingPickerView
        priceTextField.inputView = pricingPickerView
        expiryTextField.inputView = expiryPickerView

        setup(textFields: [paymentTextField, packingTextField, priceTextField, expiryTextField])
    }
    
    private func setup(textFields: [UITextField]){
        textFields.forEach { txtfield in
            txtfield.delegate = self
            txtfield.tintColor = UIColor.clear
            setupToolBars(textfield: txtfield)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return false
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == paymentTextField && paymentTextField.isEmpty {
            shipment?(AddListingShipment(rawValue: 0)!)
        }
        if textField == priceTextField && priceTextField.isEmpty {
            pricing?(AddListingPriceTerms(rawValue: 0)!)
        }
        if textField == packingTextField && packingTextField.isEmpty{
            packing?(AddListingPacking(rawValue: 0)!)
        }
        if textField == expiryTextField && expiryTextField.isEmpty{
            expiry?(AddListingExpiry(rawValue: 1)!)
        }
    }
    
    private func setupDelegateAndDataSource(for pickerViews : [UIPickerView]){
        pickerViews.forEach { picker in
            picker.delegate = self
            picker.dataSource = self
        }
    }
    
    
    private func setupToolBars(textfield: UITextField){
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.isTranslucent = true
        toolbar.tintColor = UIColor.GREEN_PRIMARY
        toolbar.sizeToFit()
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(cancelPacking(sender:)))
        toolbar.setItems([spaceButton, cancelButton], animated: false)
        toolbar.isUserInteractionEnabled = true
        textfield.inputAccessoryView = toolbar
    }
    
    
    
    @objc
    private func cancelPacking(sender: UIBarButtonItem){
        resignTextFields(textFields: [paymentTextField, priceTextField, packingTextField, expiryTextField])
    }
    
    private func resignTextFields(textFields : [UITextField]){
        textFields.forEach { (tf) in
            if tf.isFirstResponder{
                tf.resignFirstResponder()
            }
        }
    }
    
    @objc
    private func cancelPayment(){
        paymentTextField.resignFirstResponder()
    }
    
    @objc
    private func cancelPrice(){
        priceTextField.resignFirstResponder()
    }
    
    @objc
    private func cancelExpiry(){
        expiryTextField.resignFirstResponder()
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == packingPickerView {
            if let item = AddListingPacking(rawValue: row){
             packing?(item)
            }
        }
        if pickerView == paymentPickerView {
            if let item = AddListingShipment(rawValue: row){
                shipment?(item)
            }
        }
        if pickerView == pricingPickerView {
            if let item = AddListingPriceTerms(rawValue: row){
                pricing?(item)
            }
        }
        if pickerView == expiryPickerView{
            if let item = AddListingExpiry(rawValue: row + 1){
                expiry?(item)
            }
        }
    }
    
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == packingPickerView {
            return AddListingPacking.count
        }
        if pickerView == paymentPickerView {
            return AddListingShipment.count
        }
        if pickerView == pricingPickerView {
            return AddListingPriceTerms.count
        }
        if pickerView == expiryPickerView{
            return AddListingExpiry.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == packingPickerView {
            return AddListingPacking(rawValue: row)?.description
        }
        if pickerView == paymentPickerView {
            return AddListingShipment(rawValue: row)?.description
        }
        if pickerView == pricingPickerView {
            return AddListingPriceTerms(rawValue: row)?.description
        }
        if pickerView == expiryPickerView{
            return AddListingExpiry(rawValue: row + 1 )?.description
        }
        return ""
    }
}


private extension UITextField{
    var isEmpty: Bool{
        get {
            return self.text?.count == 0
        }
    }
}

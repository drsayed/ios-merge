//
//  Helper-EditProfileController.swift
//  myscrap
//
//  Created by MS1 on 1/28/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import Foundation


extension EditProfileController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 1:
            return commodities.count
        case 3:
            return roles.count
        default:
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
            
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "headerCell", for: indexPath) as! EditHeaderCell
            cell.label.text = "Commodity/Services"
            return cell
            
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! EditCollectionCell
            
            
            let i = String(indexPath.item)
            
            if selectedCommodity.contains(i) {
                self.selectCell(cell)
            } else {
                self.deselectCell(cell)
            }
            
            
            cell.label.text = commodities[indexPath.item]
            return cell
            
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "headerCell", for: indexPath) as! EditHeaderCell
            cell.label.text = "Roles"
            cell.layoutIfNeeded()
            return cell
            
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! EditCollectionCell
            cell.label.text = roles[indexPath.item]
            
            let i = String(indexPath.item)
            
            if selectedRoles.contains(i) {
                self.selectCell(cell)
            } else {
                self.deselectCell(cell)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let label = UILabel()
        label.font = Fonts.DESIG_FONT
        
        switch indexPath.section {
            
        case 1:
            label.text = FULL_COMMODITY_ARRAY[indexPath.item]
            return CGSize(width: label.intrinsicContentSize.width + 20, height: 40)
            
        case 3:
            label.text = ROLES_ARRAY[indexPath.item]
            return CGSize(width: label.intrinsicContentSize.width + 20, height: 40)
            
        default:
            return CGSize(width: self.view.frame.width, height: 35)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 1 || section == 3{
            return UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
            
        } else {
            return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let i = String(indexPath.item)
        if let cell = collectionView.cellForItem(at: indexPath) as? EditCollectionCell, indexPath.section == 1 {
            if selectedCommodity.contains(i){
                animateDeselect(cell)
                if let index = selectedCommodity.index(of: i){
                    selectedCommodity.remove(at: index)
                }
            } else {
                animateSelect(cell)
                selectedCommodity.append(i)
            }
        }
        
        if let cell = collectionView.cellForItem(at: indexPath) as? EditCollectionCell , indexPath.section == 3 {
            if selectedRoles.contains(i){
                animateDeselect(cell)
                if let index = selectedRoles.index(of: i){
                    selectedRoles.remove(at: index)
                }
            } else {
                animateSelect(cell)
                selectedRoles.append(i)
            }
        }
    }
    
    
  
    
    
    func selectCell(_ cell : EditCollectionCell){
        cell.label.textColor = UIColor.WHITE_ALPHA
        cell.view.backgroundColor = UIColor.GREEN_PRIMARY
    }
    
    func deselectCell(_ cell: EditCollectionCell){
        cell.view.backgroundColor = UIColor.WHITE_ALPHA
        cell.label.textColor = UIColor.BLACK_ALPHA
    }
    
    
    func animateSelect(_ cell: EditCollectionCell){
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            cell.label.textColor = UIColor.WHITE_ALPHA
            cell.view.backgroundColor = UIColor.GREEN_PRIMARY
        }) { (cmp) in
            self.collectionView.reloadData()
        }
    }
    
    func animateDeselect(_ cell: EditCollectionCell){
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            cell.label.textColor = UIColor.BLACK_ALPHA
            cell.view.backgroundColor = UIColor.WHITE_ALPHA
        }) { (cmp) in
            self.collectionView.reloadData()
        }
    }
    
}


extension EditProfileController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countrycodeArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countrycodeArray[row].CountryName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        setCountryText(row)
        countryTextField.resignFirstResponder()
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let myView = UIView(frame: CGRect(x: 0, y: 0, width: pickerView.bounds.width - 30 , height: 60))
        
        let myImageView = UIImageView(frame: CGRect(x: 0, y: 5, width: 50 , height: 50))
//        myImageView.image = UIImage(named: CountryCode.countryCodeArray[row])
        
        
        let myLabel = UILabel(frame: CGRect(x:60, y:0, width:pickerView.bounds.width - 90, height:60 ))
        //print("Rows : \(row)")
        //print("Country Code :\(countrycodeArray[row])")
        //print("Country Name : \(countrycodeArray[row].CountryName)")
        myLabel.text = countrycodeArray[row].CountryName
        myLabel.font = UIFont.systemFont(ofSize: 17)
        
        myView.addSubview(myLabel)
        myView.addSubview(myImageView)
        
        return myView
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
    
    func setupPickerView(){
        
        let pickerView = UIPickerView()
        countryTextField.inputView = pickerView
        codeTextField.inputView = countryCodePickerView
        pickerView.delegate = self
        countryCodePickerView.delegate = self
        setupToolbars()
    }
    
    private func setupToolbars(){
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.GREEN_PRIMARY
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(EditProfileController.cancelClick))
        toolBar.setItems([ spaceButton, cancelButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        countryTextField.inputAccessoryView = toolBar
        codeTextField.inputAccessoryView = toolBar
    }
    
    @objc private func cancelClick(){
        countryTextField.resignFirstResponder()
        codeTextField.resignFirstResponder()
    }
}
















struct CountryCode {
    var country: String
    var code: String
    
    static func CountryArray() -> [CountryCode]{
        var array = [CountryCode]()
        for (i, _) in CountryCode.countryNameArray.enumerated(){
            let country = CountryCode(country: CountryCode.countryNameArray[i], code: CountryCode.countryCodeArray[i])
            array.append(country)
        }
        return array
    }
    
    
    static var countryNameArray = ["Afghanistan","Albania","Algeria","American Samoa","Andorra","Angola","Anguilla","Antarctica","Antigua and Barbuda","Argentina","Armenia","Aruba","Australia","Austria","Azerbaijan","Bahamas","Bahrain","Bangladesh","Barbados","Belarus","Belgium","Belize","Benin","Bermuda","Bhutan","Bolivia","Bosnia and Herzegovina","Botswana","Bouvet Island","Brazil","British Indian Ocean Territory","Brunei Darussalam","Bulgaria","Burkina Faso","Burundi","Cambodia","Cameroon","Canada","Cape Verde","Cayman Islands","Central African Republic","Chad","Chile","China","Christmas Island","Cocos (Keeling) Islands","Colombia","Comoros","Congo","Congo, the Democratic Republic of the","Cook Islands","Costa Rica","Cote D'Ivoire","Croatia","Cuba","Cyprus","Czech Republic","Denmark","Djibouti","Dominica","Dominican Republic","Ecuador","Egypt","El Salvador","Equatorial Guinea","Eritrea","Estonia","Ethiopia","Falkland Islands (Malvinas)","Faroe Islands","Fiji","Finland","France","French Guiana","French Polynesia","French Southern Territories","Gabon","Gambia","Georgia","Germany","Ghana","Gibraltar","Greece","Greenland","Grenada","Guadeloupe","Guam","Guatemala","Guinea","Guinea-Bissau","Guyana","Haiti","Heard Island and Mcdonald Islands","Holy See (Vatican City State)","Honduras","Hong Kong","Hungary","Iceland","India","Indonesia","Iran, Islamic Republic of","Iraq","Ireland","Israel","Italy","Jamaica","Japan","Jordan","Kazakhstan","Kenya","Kiribati","Korea, Democratic People's Republic of","Korea, Republic of","Kuwait","Kyrgyzstan","Lao People's Democratic Republic","Latvia","Lebanon","Lesotho","Liberia","Libyan Arab Jamahiriya","Liechtenstein","Lithuania","Luxembourg","Macao","Macedonia, the Former Yugoslav Republic of","Madagascar","Malawi","Malaysia","Maldives","Mali","Malta","Marshall Islands","Martinique","Mauritania","Mauritius","Mayotte","Mexico","Micronesia, Federated States of","Moldova, Republic of","Monaco","Mongolia","Montserrat","Morocco","Mozambique","Myanmar","Namibia","Nauru","Nepal","Netherlands","Netherlands Antilles","New Caledonia","New Zealand","Nicaragua","Niger","Nigeria","Niue","Norfolk Island","Northern Mariana Islands","Norway","Oman","Pakistan","Palau","Palestinian Territory, Occupied","Panama","Papua New Guinea","Paraguay","Peru","Philippines","Pitcairn","Poland","Portugal","Puerto Rico","Qatar","Reunion","Romania","Russian Federation","Rwanda","Saint Helena","Saint Kitts and Nevis","Saint Lucia","Saint Pierre and Miquelon","Saint Vincent and the Grenadines","Samoa","San Marino","Sao Tome and Principe","Saudi Arabia","Senegal","Serbia and Montenegro","Seychelles","Sierra Leone","Singapore","Slovakia","Slovenia","Solomon Islands","Somalia","South Africa","South Georgia and the South Sandwich Islands","Spain","Sri Lanka","Sudan","Suriname","Svalbard and Jan Mayen","Swaziland","Sweden","Switzerland","Syrian Arab Republic","Taiwan, Province of China","Tajikistan","Tanzania, United Republic of","Thailand","Timor-Leste","Togo","Tokelau","Tonga","Trinidad and Tobago","Tunisia","Turkey","Turkmenistan","Turks and Caicos Islands","Tuvalu","Uganda","Ukraine","United Arab Emirates","United Kingdom","United States","United States Minor Outlying Islands","Uruguay","Uzbekistan","Vanuatu",        "Venezuela","Viet Nam","Virgin Islands, British","Virgin Islands, U.s.","Wallis and Futuna","Western Sahara","Yemen","Zambia","Zimbabwe"]
    
    static var countryCodeArray = ["93","355","213","1684","376","244","1264","0","1268","54","374","297","61","43","994","1242","973","880","1246","375","32","501","229","1441","975","591","387","267","0","55","246","673","359","226","257","855","237","1","238","1345","236","235","56","86","61","672","57","269","242","242","682","506","225","385","53","357","420","45","253","1767","1809","593","20","503","240","291","372","251","500","298","679","358","33","594","689","0","241","220","995","49","233","350","30","299","1473","590","1671","502","224","245","592","509","0","39","504","852","36","354","91","62","98","964","353","972","39","1876","81","962","7","254","686","850","82","965","996","856","371","961","266","231","218","423","370","352","853","389","261","265","60","960","223","356","692","596","222","230","269","52","691","373","377","976","1664","212","258","95","264","674","977","31","599","687","64","505","227","234","683","672","1670","47","968","92","680","970","507","675","595","51","63","0","48","351","1787","974","262","40","70","250","290","1869","1758","508","1784","684","378","239","966","221","381","248","232","65","421","386","677","252","27","0","34","94","249","597","47","268","46","41","963","886","992","255","66","670","228","690","676","1868","216","90","7370","1649","688","256","380","971","44","1","1","598","998","678","58","84","1284","1340","681","212","967","260","263"]
    
}




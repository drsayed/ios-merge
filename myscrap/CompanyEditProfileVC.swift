//
//  CompanyEditProfileVC.swift
//  myscrap
//
//  Created by MS1 on 7/19/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

class CompanyEditProfileVC: BaseVC {

    @IBOutlet var initialView: CircleView!
    
    @IBOutlet var initialLabel : UILabel!
    @IBOutlet var imageView: CircularImageView!
    
    @IBOutlet var changePhotoBtn: UIButton!
    
    @IBOutlet var companyNameTextField: ACFloatingTextfield!
    
    @IBOutlet var companyTypeTextfield: ACFloatingTextfield!
    
    @IBOutlet var countryTextfield: ACFloatingTextfield!

    
    @IBOutlet var bioHeader: UILabel!
    
    @IBOutlet var bioTextView: UITextView!
    
    
    @IBOutlet var contactInfoView: UIView!
    
    
    @IBOutlet var contactInfoLabel: UILabel!
    
    @IBOutlet var countryCodeTextField: ACFloatingTextfield!
    
    @IBOutlet var phoneTextField: ACFloatingTextfield!
    
    @IBOutlet var websiteTextField: ACFloatingTextfield!
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var active: UIActivityIndicatorView!
    
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var saveBtn:UIBarButtonItem!
    
    var activeField: ACFloatingTextfield?

    
    var edit:EditProfile?
    
    var countryRow: Int = 0
    
    var countryPickerView = UIPickerView()
    
    var company = [Companies]()
    var filteredCompany = [Companies]()
    
    var selectedCommodity = [String]()
    var selectedRoles = [String]()
    
    var imageChanged = false
    
    
    var companyId = ""
    

    
    
    
    
    let countryArray = ["Afghanistan","Albania","Algeria","American Samoa","Andorra","Angola","Anguilla","Antarctica","Antigua and Barbuda","Argentina","Armenia","Aruba","Australia","Austria","Azerbaijan","Bahamas","Bahrain","Bangladesh","Barbados","Belarus","Belgium","Belize","Benin","Bermuda","Bhutan","Bolivia","Bosnia and Herzegovina","Botswana","Bouvet Island","Brazil","British Indian Ocean Territory","Brunei Darussalam","Bulgaria","Burkina Faso","Burundi","Cambodia","Cameroon","Canada","Cape Verde","Cayman Islands","Central African Republic","Chad","Chile","China","Christmas Island","Cocos (Keeling) Islands","Colombia","Comoros","Congo","Congo, the Democratic Republic of the","Cook Islands","Costa Rica","Cote D'Ivoire","Croatia","Cuba","Cyprus","Czech Republic","Denmark","Djibouti","Dominica","Dominican Republic","Ecuador","Egypt","El Salvador","Equatorial Guinea","Eritrea","Estonia","Ethiopia","Falkland Islands (Malvinas)","Faroe Islands","Fiji","Finland","France","French Guiana","French Polynesia","French Southern Territories","Gabon","Gambia","Georgia","Germany","Ghana","Gibraltar","Greece","Greenland","Grenada","Guadeloupe","Guam","Guatemala","Guinea","Guinea-Bissau","Guyana","Haiti","Heard Island and Mcdonald Islands","Holy See (Vatican City State)","Honduras","Hong Kong","Hungary","Iceland","India","Indonesia","Iran, Islamic Republic of","Iraq","Ireland","Israel","Italy","Jamaica","Japan","Jordan","Kazakhstan","Kenya","Kiribati","Korea, Democratic People's Republic of","Korea, Republic of","Kuwait","Kyrgyzstan","Lao People's Democratic Republic","Latvia","Lebanon","Lesotho","Liberia","Libyan Arab Jamahiriya","Liechtenstein","Lithuania","Luxembourg","Macao","Macedonia, the Former Yugoslav Republic of","Madagascar","Malawi","Malaysia","Maldives","Mali","Malta","Marshall Islands","Martinique","Mauritania","Mauritius","Mayotte","Mexico","Micronesia, Federated States of","Moldova, Republic of","Monaco","Mongolia","Montserrat","Morocco","Mozambique","Myanmar","Namibia","Nauru","Nepal","Netherlands","Netherlands Antilles","New Caledonia","New Zealand","Nicaragua","Niger","Nigeria","Niue","Norfolk Island","Northern Mariana Islands","Norway","Oman","Pakistan","Palau","Palestinian Territory, Occupied","Panama","Papua New Guinea","Paraguay","Peru","Philippines","Pitcairn","Poland","Portugal","Puerto Rico","Qatar","Reunion","Romania","Russian Federation","Rwanda","Saint Helena","Saint Kitts and Nevis","Saint Lucia","Saint Pierre and Miquelon","Saint Vincent and the Grenadines","Samoa","San Marino","Sao Tome and Principe","Saudi Arabia","Senegal","Serbia and Montenegro","Seychelles","Sierra Leone","Singapore","Slovakia","Slovenia","Solomon Islands","Somalia","South Africa","South Georgia and the South Sandwich Islands","Spain","Sri Lanka","Sudan","Suriname","Svalbard and Jan Mayen","Swaziland","Sweden","Switzerland","Syrian Arab Republic","Taiwan, Province of China","Tajikistan","Tanzania, United Republic of","Thailand","Timor-Leste","Togo","Tokelau","Tonga","Trinidad and Tobago","Tunisia","Turkey","Turkmenistan","Turks and Caicos Islands","Tuvalu","Uganda","Ukraine","United Arab Emirates","United Kingdom","United States","United States Minor Outlying Islands","Uruguay","Uzbekistan","Vanuatu",        "Venezuela","Viet Nam","Virgin Islands, British","Virgin Islands, U.s.","Wallis and Futuna","Western Sahara","Yemen","Zambia","Zimbabwe"]
    
    
        var countryCode = ["93","355","213","1684","376","244","1264","0","1268","54","374","297","61","43","994","1242","973","880","1246","375","32","501","229","1441","975","591","387","267","0","55","246","673","359","226","257","855","237","1","238","1345","236","235","56","86","61","672","57","269","242","242","682","506","225","385","53","357","420","45","253","1767","1809","593","20","503","240","291","372","251","500","298","679","358","33","594","689","0","241","220","995","49","233","350","30","299","1473","590","1671","502","224","245","592","509","0","39","504","852","36","354","91","62","98","964","353","972","39","1876","81","962","7","254","686","850","82","965","996","856","371","961","266","231","218","423","370","352","853","389","261","265","60","960","223","356","692","596","222","230","269","52","691","373","377","976","1664","212","258","95","264","674","977","31","599","687","64","505","227","234","683","672","1670","47","968","92","680","970","507","675","595","51","63","0","48","351","1787","974","262","40","70","250","290","1869","1758","508","1784","684","378","239","966","221","381","248","232","65","421","386","677","252","27","0","34","94","249","597","47","268","46","41","963","886","992","255","66","670","228","690","676","1868","216","90","7370","1649","688","256","380","971","44","1","1","598","998","678","58","84","1284","1340","681","212","967","260","263"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        // Do any additional setup after loading the view.
        
        self.initialLabel.isHidden = true
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.GREEN_PRIMARY
        toolBar.sizeToFit()
        
        countryCodeTextField.isUserInteractionEnabled = false
        
     
        
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(CompanyEditProfileVC.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(CompanyEditProfileVC.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        countryTextfield.inputAccessoryView = toolBar
        
        
        
        countryPickerView.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        
        countryPickerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 150)
        
        countryPickerView.delegate = self
        countryPickerView.dataSource = self
        
        
        
        countryTextfield.delegate = self
        countryTextfield.inputView = countryPickerView
        
        
        
        
        
        changePhotoBtn.setTitleColor(UIColor.GREEN_PRIMARY, for: .normal)
        changePhotoBtn.titleLabel?.font = Fonts.INIITIAL_FONT
        initialLabel.font = Fonts.INIITIAL_FONT
        
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let alignedFlowLayout = collectionView?.collectionViewLayout as? AlignedCollectionViewFlowLayout
        alignedFlowLayout?.horizontalAlignment = .left
        alignedFlowLayout?.verticalAlignment = .top
        
        view.layoutIfNeeded()
        
        heightConstraint.constant = collectionView.collectionViewLayout.collectionViewContentSize.height
        
        
        bioTextView.layer.borderWidth = 0.5
        bioTextView.layer.borderColor = UIColor.clear.cgColor
        bioHeader.font = UIFont(name: "HelveticaNeue", size: 12)
        
        
        bioTextView.delegate = self

        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(cancelTap(_:)))
        
        tap.delegate = self
        tap.cancelsTouchesInView = false
        
        self.scrollView.addGestureRecognizer(tap)
        
        
        
        
        //textcolor for textfields
        
        companyNameTextField.textColor = UIColor.BLACK_ALPHA
        companyTypeTextfield.textColor = UIColor.BLACK_ALPHA
        countryTextfield.textColor = UIColor.BLACK_ALPHA
        bioTextView.textColor = UIColor.BLACK_ALPHA
        bioHeader.textColor = UIColor.lightGray
        
        self.contactInfoView.backgroundColor = UIColor.BACKGROUND_GRAY
        self.contactInfoLabel.textColor = UIColor.darkGray
        self.contactInfoLabel.text = "Contact Info"
        
        
        
        
        getProfile()
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
    

    @objc func cancelTap(_ sender: UITapGestureRecognizer){
        
        self.view.endEditing(true)
    }
    
    func getProfile(){
        
        
        
        self.active.isHidden = false
        self.active.startAnimating()
        
        let url = URL(string: Endpoints.COMPANY_EDIT_PROFILE)!
        
        let session = URLSession.shared
        
        let userId = UserDefaults.standard.value(forKey: "userid") as! String?
        
        let postString = "userId=\(userId!)&apiKey=\(API_KEY)&companyId=\(companyId)"
        
        print(postString)
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
        request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "content-Type")
        request.httpBody = postString.data(using: .ascii, allowLossyConversion: false)
        
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                return
            }
            guard let data = data else{
                
                return
            }
            
            do {
                
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? Dictionary<String,AnyObject>{
                    
                    
                    print(json)
                    
                    let jso = EditProfile(editDict: json)
                    
                    self.edit = jso
                    
                    
                    
                    DispatchQueue.main.async {
                        
                        // active .stop animating
                        
                        self.scrollView.isHidden = false
                        
                        self.active.stopAnimating()
                        
                        self.active.isHidden = true
                        
                        self.scrollView.bounces = false
                        
                        print(self.edit?.companyName)
                        
                        
                        self.companyNameTextField.text = self.edit?.companyName
                        self.companyTypeTextfield.text = self.edit?.companyType
                        self.countryTextfield.text = self.edit?.userLocation
                        
                        print(self.countryTextfield.text ?? "")
                        
                        
                        
                        if let i = self.countryArray.index(of: self.countryTextfield.text!){
                            
                            self.countryCodeTextField.text = self.countryCode[i]
                            
                        }
                        
                        
                        
                        self.bioTextView.text = self.edit?.userBio
                        self.countryCodeTextField.text = self.edit?.code
                        self.websiteTextField.text = self.edit?.website
                        
    
                        self.companyId = (self.edit?.companyId)!
                        
                //        self.initialView.backgroundColor = UIColor.init(hexString: (self.edit?.colorCode)!)
                        
//                        let firstName = "\(self.edit!.firstName!)"
//                        let lastName = "\(self.edit!.lastName!)"
//                        
//                        let fullName = "\(firstName) \(lastName)"
//                        print(fullName)
//                        
          //              self.initialLabel.text = fullName.initials()
                        
                        self.initialLabel.textColor = UIColor.clear
                        
                        if (self.edit?.userBio == nil || self.edit?.userBio == ""){
                            self.bioHeader.textColor = UIColor.lightGray
                            //        self.placeHolderLbl.isHidden = false
                        } else {
                            self.bioHeader.textColor = UIColor.GREEN_PRIMARY
                            //             self.placeHolderLbl.isHidden = true
                        }
                        if let edit = self.edit  {
                            self.imageView.setImageWithIndicator(imageURL: edit.profilePic)
                        }
                        let intrestString = self.edit!.userInterest.replacingOccurrences(of: " ", with: "")
                        let roleString = self.edit!.userInterestRoles.replacingOccurrences(of: " ", with: "")
                        print(intrestString)
                        print(roleString)
                        if (intrestString != ""){
                            self.selectedCommodity = intrestString.components(separatedBy: ",")
                        }
                        if (roleString != ""){
                            self.selectedRoles = roleString.components(separatedBy: ",")
                        }
                        self.collectionView.reloadData()
                    }
                }
            } catch let error{
                fatalError("JSON Processing Error")
                return
            }
        }
        task.resume()
    }
    
    @IBAction func saveProfile(_ sender: UIBarButtonItem){
        
        if (companyNameTextField.text == nil && companyTypeTextfield.text == nil){
            
            self.showToast(message: "Please provide Company Name and Type")
        } else {
            self.postData()
            if imageChanged{
                self.postImage()
            }
        }
    }
    
    func postImage(){
        self.scrollView.isHidden = true
        
        let url = URL(string: Endpoints.COMPANY_EDIT_PROFILE_PIC)!
        
        let session = URLSession.shared
        
        let userId = UserDefaults.standard.value(forKey: "userid") as! String?
        
        
        
        
        var image = ""
        
        if imageView.image != nil{
            
            
            let imageData: Data = imageView!.image!.jpegData(compressionQuality: 0.6)!
            
            let imageString =  imageData.base64EncodedString(options: .lineLength64Characters)
            
            image = imageString
            
        }
        
        
        print("hello\(image)hello")
        
        
        
        var postString = "userId=\(userId!)&apiKey=\(API_KEY)&profilePic=\(image)&companyId=\(companyId)"
        
        postString = postString.replacingOccurrences(of: "+", with: "%2B")
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
        request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "content-Type")
        request.httpBody = postString.data(using: .ascii, allowLossyConversion: false)
        
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                return
            }
            guard let data = data else{
                
                return
            }
            
            do {
                
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? Dictionary<String,AnyObject>{
                    
                    
                    print(json)
                    
                    DispatchQueue.main.async {
                        
                        
                        
                        print("profile picture updated")
                        
                        self.navigationController?.popViewController(animated: true)
                    }
                    
                    
                }
                
                
            } catch let error{
                
                fatalError("JSON Processing Error")
                
                return
            }
            
            
            
        }
        
        
        task.resume()
        
    }
    
    
    @IBAction func openCamera(_ sender: Any) {

        let croppingParameters = CroppingParameters(isEnabled: true, allowResizing: true, allowMoving: true, minimumSize: CGSize(width: 200, height: 200))
        let cameraViewController = CameraViewController.imagePickerViewController(croppingParameters: croppingParameters) { [weak self](image, asset) in
            self?.imageView.image = image
            self?.dismiss(animated: true, completion: nil)
            self?.imageChanged = true
        }
        present(cameraViewController, animated: true, completion: nil)
    }
}


// MARK:- PICKER VIEW DELEGATES


extension CompanyEditProfileVC:UIPickerViewDelegate,UIPickerViewDataSource{
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return countryArray[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return countryArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        countryRow = row
        
        countryCodeTextField.text = countryCode[row]
        
    }
    
    
}

//MARK :- UITEXTFIELD DELEGATES


extension CompanyEditProfileVC: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
    
            
            
            let nextTage=textField.tag+1;
            // Try to find next responder
        let nextResponder=textField.superview?.viewWithTag(nextTage) as UIResponder?
            
            if (nextResponder != nil){
                // Found next responder, so set it.
                nextResponder?.becomeFirstResponder()
            }
            else
            {
                // Not found, so remove keyboard
                textField.resignFirstResponder()
            }
            
            

        
        return false
        
    }

    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        
        if textField == companyTypeTextfield{
            
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 20 // Bool
        }
        
        
        return true
    }
    
    func postData(){
        
        
        self.saveBtn.isEnabled = false
        self.active.isHidden = false
        self.active.startAnimating()
        
        
        let url = URL(string: Endpoints.COMPANY_EDIT_PROFILE)!
        
        let session = URLSession.shared
        
        let userId = UserDefaults.standard.value(forKey: "userid") as! String?
        
        var int = ""
        
        if !selectedCommodity.isEmpty {
            
            int = (selectedCommodity.map{String($0)}).joined(separator: ",")
            
            print(int)
        }
        
        var rls = ""
        
        if !selectedRoles.isEmpty {
            
            rls = (selectedRoles.map{String($0)}).joined(separator: ",")
            
            print(rls)
            
        }
        
  
        
        
        let postString = "userId=\(userId!)&website=\(websiteTextField.text!)&companyLocation=\(countryTextfield.text!)&companyType=\(companyTypeTextfield.text!)&phoneNo=\(phoneTextField.text!)&code=\(countryCodeTextField.text!)&companyBio=\(bioTextView.text!)&companyInterest=\(int)&userRolers=\(rls)"
        
        print(postString)
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
        request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "content-Type")
        request.httpBody = postString.data(using: .ascii, allowLossyConversion: false)
        
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard error == nil else {
                return
            }
            guard let data = data else{
                
                return
            }
            
            do {
                
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? Dictionary<String,AnyObject>{
                    
                    
                    print(json)
                    
                    
                    
                    
                    DispatchQueue.main.async {
                        
                        self.active.stopAnimating()
                        
                        if !self.imageChanged{
                            self.navigationController?.popViewController(animated: true)
                        }
                        
                        
                        
                    }
                    
                    
                }
                
                
            } catch let error{
                
                fatalError("JSON Processing Error")
                
                return
            }
            
            
            
        }
        
        
        task.resume()
        
        
    }
    @objc func doneClick() {
        
        countryTextfield.text = countryArray[countryRow]
        countryCodeTextField.text = "+" + countryCode[countryRow]
        countryTextfield.resignFirstResponder()
    }
    @objc func cancelClick() {
        countryTextfield.resignFirstResponder()
    }
    
}

//MARK :- COLLECTIONVIEW DELEGATES

extension CompanyEditProfileVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case 1:
            return FULL_COMMODITY_ARRAY.count
        case 3:
            return COMPANY_ROLES_ARRAY.count
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
            
            cell.label.text = FULL_COMMODITY_ARRAY[indexPath.item]
            
            let i = String(indexPath.item)
            
            if selectedCommodity.contains(i) {
                
                self.selectCell(cell)
                
            } else {
                
                self.deselectCell(cell)
            }
            
            return cell
            
        case 2:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "headerCell", for: indexPath) as! EditHeaderCell
            
            
            cell.label.text = "Roles"
            
            
            
            cell.layoutIfNeeded()
            
            return cell
            
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! EditCollectionCell
            
            cell.label.text = COMPANY_ROLES_ARRAY[indexPath.item]
            
            let i = String(indexPath.item)
            
            if selectedRoles.contains(i){
                
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
            label.text = COMPANY_ROLES_ARRAY[indexPath.item]
            
            return CGSize(width: label.intrinsicContentSize.width + 20, height: 40)
            
        default:
            return CGSize(width: self.view.frame.width, height: 35)
            
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if section == 1 || section == 3{
            
            return UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 10)
        } else {
            
            return UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
            
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.section == 1 {
            
            print(indexPath.section)
            
            let cell = collectionView.cellForItem(at: indexPath) as! EditCollectionCell
            
            let i = String(indexPath.item)
            
            
            
            
            if selectedCommodity.contains(i){
                animateDeselect(cell)
                
                if let index = selectedCommodity.index(of: i) {
                    selectedCommodity.remove(at: index)
                }
            } else {
                
                animateSelect(cell)
                
                selectedCommodity.append(i)
                
            }
            
            
            
        } else  if indexPath.section == 3{
            
            
            let i = String(indexPath.item)
            
            let cell = collectionView.cellForItem(at: indexPath) as! EditCollectionCell
            
            
            if selectedRoles.contains(i){
                
                animateDeselect(cell)
                if let index = selectedRoles.index(of: i) {
                    selectedRoles.remove(at: index)
                }
            } else {
                
                animateSelect(cell)
                selectedRoles.append(i)
                
            }
            
            
        }
        
        
    }
    
}

// MARK :- TEXTVIEW DELEGATE

extension CompanyEditProfileVC: UITextViewDelegate{
    
    
    func textViewDidChange(_ textView: UITextView) {
        if (textView.text == nil ||  textView.text == ""){
            
            //    placeHolderLbl.isHidden = false
            bioHeader.textColor = UIColor.lightGray
        } else {
            
            //placeHolderLbl.isHidden = true
            bioHeader.textColor = UIColor.GREEN_PRIMARY
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.selectedRange = NSMakeRange(textView.text.count, 0)
    }
}

//MARK :- UIGESTURE DELEGATE

extension CompanyEditProfileVC: UIGestureRecognizerDelegate{
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        
        if (touch.view?.isDescendant(of: collectionView))!{
            
            return false
        }
        
        return true
    }
 
    
}

extension CompanyEditProfileVC{
    static func StoryBoardInstance() -> CompanyEditProfileVC? {
        let st = UIStoryboard(name: "Companies", bundle: nil)
        return st.instantiateViewController(withIdentifier: "CompanyEditProfileVC") as? CompanyEditProfileVC
    }
}


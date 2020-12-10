//
//  CompanyAboutVC.swift
//  myscrap
//
//  Created by MS1 on 1/31/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit
import SafariServices


class CompanyAboutVC: BaseVC {
    
    
    private struct titles {
        static let phone = "Phone"
        static let website = "WebSite"
        static let address = "Address"
    }
    
    var companyProfileItem: CompanyProfileItem?
    
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.spacing = 8
        sv.alignment = .fill
        sv.axis = .vertical
        return sv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        self.title = "About"
        
        view.backgroundColor = UIColor.white
        
        view.addSubview(stackView)
        stackView.anchor(leading: view.leadingAnchor, trailing: view.trailingAnchor, top: view.topAnchor, bottom: nil,padding: UIEdgeInsets.init(top: 8, left: 8, bottom: 0, right: 8))
        setupProfileViews()
    }
    
    private func setupProfileViews(){
        
        guard let item = companyProfileItem else { return }
    
        if let phone = item.companyPhoneNumber , phone != "" {
            stackView.addArrangedSubview(createButtonView(title: titles.phone, text: phone, textType: .phone))
        }
        
        if let website = item.companyWebsite , website != "" {
            stackView.addArrangedSubview(createButtonView(title: titles.website, text: website, textType: .website))
        }
        
        if let address = item.companyAddress , address != "" {
            var country = ""
            if let cntry = item.companyCountry , cntry != ""{ country = ", \(cntry)" }
            stackView.addArrangedSubview(createButtonView(title: titles.address, text: address + country, textType: .address))
        }
    }
    
    private func createButtonView(title: String, text: String, textType: ButtonTextType) -> AboutButtonView {
        let view = AboutButtonView(title: title, buttonText: text, textType: textType)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }
}
extension CompanyAboutVC: AboutButtonViewDelegate{
    func didTapAlertButton(with text: String, of type: ButtonTextType) {
        print("Button Type :-" ,type.rawValue )
        guard let item = companyProfileItem else { return}
        switch type {
        case .address:
            if let lattitude = item.companyLattitude, let longitude = item.companyLongitude {
                let url = URL(string: "http://maps.apple.com/?address=\(lattitude),\(longitude)")!
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        case .website:
            if let site = item.companyWebsite{
                let urlString = "http://" + site.replacingOccurrences(of: "http://", with: "").replacingOccurrences(of: "https://", with: "")
                if let url = URL(string: urlString) {
                    let svc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
                    svc.preferredBarTintColor = UIColor.GREEN_PRIMARY
                    self.present(svc, animated: true, completion: nil)
                }
            }
        case .phone:
            if let phone = item.companyPhoneNumber, let url = URL(string: "tel://\(phone)" ){
                let application:UIApplication = UIApplication.shared
                if (application.canOpenURL(url)) {
                    application.open(url, options: [:], completionHandler: nil)
                }
            }
        default:
            print("nothing needed")
        }
    }
}






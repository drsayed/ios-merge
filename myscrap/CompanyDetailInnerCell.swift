//
//  CompanyDetailInnerCell.swift
//  myscrap
//
//  Created by MS1 on 2/8/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit

protocol CompanyDetailInnerDelegate : class{
    func didTapLikeCountButton(companyItem: CompanyProfileItem)
    func didTapEmployeesCountButton(companyItem: CompanyProfileItem)
    func didTapCountryButton(companyItem: CompanyProfileItem)
    func didTapShowMapButton(companyItem: CompanyProfileItem)
}

extension CompanyDetailInnerDelegate where Self: CompanyProfileVC{

    func didTapLikeCountButton(companyItem: CompanyProfileItem){
        let vc = CompanyLikesController()
        vc.title = "Company Likes"
        vc.id = companyItem.companyId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func didTapEmployeesCountButton(companyItem: CompanyProfileItem){
        
        let vc = EmployeesController()
        vc.title = "Employees"
        vc.id = companyItem.companyId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func didTapCountryButton(companyItem: CompanyProfileItem){
        if let lattitude = companyItem.companyLattitude, let longitude = companyItem.companyLongitude {
            if let url = URL(string: "http://maps.apple.com/?address=\(lattitude),\(longitude)"){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    func didTapShowMapButton(companyItem: CompanyProfileItem){
        
        if let mapVC = MapVCPopUp.storyBoardInstance() , let lattitude = companyItem.companyLattitude, let longitude = companyItem.companyLongitude{
            mapVC.modalTransitionStyle = .crossDissolve
            mapVC.modalPresentationStyle = .overCurrentContext
            mapVC.lattitude = lattitude
            mapVC.longitude = longitude
            mapVC.maptitle = companyItem.companyName ?? ""
            self.present(mapVC, animated: true, completion: nil)
        }
    }
    
}


class CompanyDetailInnerCell: BaseCell {
    
    weak var delegate: CompanyDetailInnerDelegate?
    
    var companyItem : CompanyProfileItem?{
        didSet{
            guard let item = companyItem else { return }
            configCell(with: item)
        }
    }

    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeStack: UIStackView!
    @IBOutlet weak var employeeBtn: UIButton!
    @IBOutlet weak var employeeStack: UIStackView!
    @IBOutlet weak var countryBtn: UIButton!
    
    
    private func configCell(with item: CompanyProfileItem){
        likeStack.isHidden = item.companyLike == 0
        employeeStack.isHidden = item.companyEmployees == 0
        likeButton.setTitle("  \(getString(item: "Like", number: item.companyLike))", for: .normal)
        employeeBtn.setTitle("  \(getString(item: "Employee", number: item.companyEmployees))", for: .normal)
        countryBtn.setTitle("  \(item.companyCountry!)", for: .normal)
    }
    
    private func getString(item: String, number: Int) -> String{
        if number > 1 {
           return "\(number) \(item)s"
        }
        return "\(number) \(item)"
    }
    
    

    @IBAction func likeCountBtnPressed(_ sender: UIButton) {
        guard let item = companyItem else { return }
        delegate?.didTapLikeCountButton(companyItem: item)
    }
    
    @IBAction func employeesButtonPressed(_ sender: UIButton){
        guard let item = companyItem else { return }
        delegate?.didTapEmployeesCountButton(companyItem: item)
        
    }
    
    @IBAction func countryButtonPressed(_ sender: UIButton){
        guard let item = companyItem else { return }
        delegate?.didTapCountryButton(companyItem: item)
    }
    
    @IBAction func showMapButtonTapped(_ sender: UIButton){
        guard let item = companyItem else { return }
        delegate?.didTapShowMapButton(companyItem: item)
    }
    
    
}

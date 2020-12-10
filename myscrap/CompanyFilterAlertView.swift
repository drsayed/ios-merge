//
//  CompanyFilterAlertView.swift
//  myscrap
//
//  Created by MS1 on 1/30/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit

protocol CompanyFilterAlertDelegate: class {
    func didFilterCompanies(countryID: String)
}


class CompanyFilterAlertView: UIView, Modal{
    
    weak var delegate: CompanyFilterAlertDelegate?
    
    var completionHandler:((String) -> Int)?
    
    var datSource = [String: [CountryItem]]()
    var titles = [String]()
    var countryCount = [String]()
    var ds = [CompanyItem]()
    var cDs = [CountryItem]()
    
    
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
    
    private let titleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.GREEN_PRIMARY
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Select a country"
        lbl.textColor = UIColor.white
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    let closeButton : UIButton = {
        let btn = UIButton()
        btn.tintColor = UIColor.white
        btn.setImage(#imageLiteral(resourceName: "delete").withRenderingMode(.alwaysTemplate), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(dismissFromView), for: .touchUpInside)
        return btn
    }()
    
    lazy var tableView: UITableView = { [unowned self] in
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.delegate = self
        tv.dataSource = self
        tv.register(companyFilterTableCell.self, forCellReuseIdentifier: companyFilterTableCell.identifier)
        tv.separatorStyle = .none
        return tv
        }()
    
    
    @objc private func dismissFromView(){
        dismiss(animated: false)
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
        dialogView.heightAnchor.constraint(equalToConstant:300).isActive = true
        dialogView.widthAnchor.constraint(equalToConstant:300).isActive = true
        
        setupTitleView()
        
    }
    
    private func setupTitleView(){
        dialogView.addSubview(titleView)
        
        titleView.leadingAnchor.constraint(equalTo: dialogView.leadingAnchor).isActive = true
        titleView.trailingAnchor.constraint(equalTo: dialogView.trailingAnchor).isActive = true
        titleView.topAnchor.constraint(equalTo: dialogView.topAnchor).isActive = true
        titleView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        titleView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: titleView.leadingAnchor, constant: 8),
            titleLabel.centerYAnchor.constraint(equalTo: titleView.centerYAnchor)
            ])
        
        titleView.addSubview(closeButton)
        
        closeButton.trailingAnchor.constraint(equalTo: titleView.trailingAnchor, constant: -8).isActive = true
        closeButton.topAnchor.constraint(equalTo: titleView.topAnchor).isActive = true
        closeButton.bottomAnchor.constraint(equalTo: titleView.bottomAnchor).isActive = true
        
        setupTableView()
    }
    
    private func setupTableView(){
        dialogView.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: dialogView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: dialogView.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: dialogView.bottomAnchor),
            ])
    }
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    /*convenience init(titleData: [String],data: [String: [CountryItem]]){
        self.init(frame: UIScreen.main.bounds)
        self.datSource = data
        self.titles = titleData
        setupViews()
    }*/
    
    convenience init(country : [CountryItem]){
        self.init(frame: UIScreen.main.bounds)
        self.cDs = country
        setupViews()
    }
    
    /*convenience init(titleData: [String],countryCount: [String], ds: [CountryItem]){
        self.init(frame: UIScreen.main.bounds)
        self.dataSource = ds
        self.titles = titleData
        self.countryCount = countryCount
        setupViews()
    }*/
    
}

extension CompanyFilterAlertView: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cDs.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: companyFilterTableCell.identifier, for: indexPath) as! companyFilterTableCell
        /*let key = titles[indexPath.row]
        if let values = datSource[key]?[indexPath.row].totalCompany, let name = datSource[key]?[indexPath.row].countryName {
            cell.textLabel?.text = "\(name) [\(values)]"
        }*/
        let country = cDs[indexPath.row]
        let name = country.countryName
        let totalCompany = country.totalCompany
        cell.textLabel?.text = "\(name) [\(totalCompany)]"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*let key = titles[indexPath.row]
        if let values = datSource[key]{
            delegate?.didFilterCompanies(companies: values)
            dismiss(animated: false)
        }*/
        let countryId = cDs[indexPath.row].country_id
        
        delegate?.didFilterCompanies(countryID: countryId)
        dismiss(animated: false)
    }
}



class companyFilterTableCell: BaseTVC{
    
}






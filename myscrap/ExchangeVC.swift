//
//  ExchangeVC.swift
//  myscrap
//
//  Created by MS1 on 10/8/17.
//  Copyright © 2017 sayedmetal. All rights reserved.
//

import UIKit

class PricesVC: BaseRevealVC {
    

    @IBOutlet weak var tableView: UITableView!
    

    lazy var refreshControl :UIRefreshControl = {
        let rf = UIRefreshControl()
        rf.addTarget(self, action: #selector(handleRefresh(_:)),for: .valueChanged)
        return rf
    }()
    var timer: Timer!
    
    //MARK:- VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        
        title = "Prices"
    }
    
    
    //MARK:- VIEW WILL APPEAR
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AuthService.instance.updateFCM()
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(getData), userInfo: nil, repeats: true)
    }
    
    //MARK:- VIEW WILL DISAPPEAR
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }
    
    
    //MARK:- SETUP TABLEVIEW
    private func setupTableView(){
        tableView.separatorStyle = .none
//        tableView.addSubview(refreshControl)
        let nib = UINib(nibName: "ExchangeHeaderView", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ExchangeHeaderView")
    }
    
    //MARK:- REFRESH CONTROL
    @objc private func handleRefresh(_ rc: UIRefreshControl){
        self.getData()
    }
    
    //MARK:- GET DATA
    @objc private func getData(){
    }
    
    //MARK:- REFRESH CLICKED
    @IBAction func refreshClicked(_ sender: UIBarButtonItem){
        handleRefresh(refreshControl)
    }
}

extension PricesVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 25
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
 /*   func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ExchangeHeaderView") as! ExchangeHeaderView
//        let date = Date()
//        let formatter = DateFormatter()
//        formatter.dateFormat = "HH:mm"
//        if section == 0 {
//            formatter.timeZone = TimeZone(identifier: "Europe/London")
//            cell.timeLbl.text = "London : \(formatter.string(from: date))"
//            cell.lbl1.text = "LME"
//            cell.lbl2.text = "CONTRACT"
//        } else {
//            formatter.timeZone = TimeZone(identifier: "America/New_York")
//            cell.timeLbl.text = "New York : \(formatter.string(from: date))"
//            cell.lbl1.text = "NYMEX"
//            cell.lbl2.text = ""
//        }
//
//        return cell
    } */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExchangeCell", for: indexPath) as! ExchangeCell
        
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor.white
        } else {
            cell.backgroundColor = UIColor(hexString: "#EFEFEF")
        }
        return cell
    }
}















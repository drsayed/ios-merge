//
//  CompanyEmployeeVC.swift
//  myscrap
//
//  Created by MyScrap on 6/19/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit

class CompanyEmployeeVC: UIViewController, UITableViewDelegate, UITableViewDataSource, FriendControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var empLbl: UILabel!
    
    var service = CompanyUpdatedService()
    var dataSource = [Employees]()
    weak var delegate: CompanyUpdatedServiceDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        let companyId = UserDefaults.standard.object(forKey: "companyId") as? String
        service.getCompanyDetails(companyId: companyId!)
        service.delegate = self
        setupTableView()
    }
    
    override func loadView() {
        super.loadView()
        view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        //tableView.register(EmployeeListTVCell.self, forCellReuseIdentifier: "employeeList")
        tableView.isScrollEnabled = true
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataSource.count != 0 {
            return dataSource.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : EmployeeListTVCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! EmployeeListTVCell
        
        cell.delegate = self
        cell.employeeData = dataSource[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 94
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performFriendView(friendId: dataSource[indexPath.row].userId)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension CompanyEmployeeVC : CompanyUpdatedServiceDelegate {
    func didReceiveCompanyValues(data: [CompanyItems]) {
        DispatchQueue.main.async {
            
            if data.last!.employeeCount == 0 {
                self.empLbl.isHidden = false
            } else {
                self.dataSource = data.last!.employees
                self.empLbl.isHidden = true
            }
            //self.tableViewHeight.constant = CGFloat(self.dataSource.count * 94)
            self.tableView.reloadData()
        }
    }
    
    func DidReceivedError(error: String) {
        print("Error while getting value in employee liset : \(error)")
    }
    
    
}

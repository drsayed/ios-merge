//
//  CompanyModuleOverViewVC.swift
//  myscrap
//
//  Created by Apple on 21/10/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit
import MapKit

enum DragDirection {
    
    case Up
    case Down
}

protocol InnerTableViewScrollDelegate: class {
    
    var currentHeaderHeight: CGFloat { get }
    
    func innerTableViewDidScroll(withDistance scrollDistance: CGFloat)
    func innerTableViewScrollEnded(withScrollDirection scrollDirection: DragDirection)
}

class CompanyModuleOverViewVC: UIViewController, FriendControllerDelegate {

    @IBOutlet var tableView : UITableView!
    
    var companyOverViewDataSource : [CompanyItems]?

    //MARK:- Scroll Delegate
    weak var innerTableViewScrollDelegate: InnerTableViewScrollDelegate?

    //MARK:- Stored Properties for Scroll Delegate
    private var dragDirection: DragDirection = .Up
    private var oldContentOffset = CGPoint.zero

    

    var sectionTitleArray = [["headerImage" : "employees-40", "headerText" : "Employees"],
                        ["headerImage" : "time-40", "headerText" : "Timings"],
                        ["headerImage" : "", "headerText" : ""], //
                        ["headerImage" : "", "headerText" : "Business Type"],
                        ["headerImage" : "", "headerText" : "Commodity"],
                        ["headerImage" : "", "headerText" : "Affiliation"],
                        ["headerImage" : "", "headerText" : "About"]]

    var employeesArray = [Employees]()

//    var timingsArray = [[String : String]]()

    var companyDetailsArray = [[String : String]]()
    
    var sectionExpanded = [true,true, false, true, true, true, true]
//    let numberOfActualRows = 2

    var businessTypeArr = [String]()
    var commoditiesArr = [String]()
    var affiliationArr = [String]()

    var company_lat = 0.0
    var company_long = 0.0

    var adminText = "   Admin   "
    var makeAsAdminText = "Make As Admin"
    var reportText = "Report"
    var reportedText = "Reported"

    var isCurrentUserAsAdmin = false
    var isSomeoneRequestedForAdmin = false
    
    var rightBarButton : UIBarButtonItem!
    
//    fileprivate var companyData = [CompanyItems]()
    var apiService = CompanyUpdatedService()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = .white
        
        self.setupTableView()
        
//        if self.companyOverViewDataSource != nil {
//            self.reloadCompanyModulesData()
//        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let companyIdStr = UserDefaults.standard.object(forKey: "companyId") as? String {
            self.callGetCompanyAPI(companyId: companyIdStr)
        }
    }
    
    @objc func editButtonAction() {
        
    }
    //MARK:- Set Up TableView
    func setupTableView() {
    
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = .white
        self.tableView.register(CompanyModuleHeaderCell.self, forCellReuseIdentifier: "CompanyModuleHeaderCell")
        self.tableView.register(CompanyModuleInterestTableViewCell.self, forCellReuseIdentifier: "CompanyModuleInterestTableViewCell")
        self.tableView.separatorStyle = .none
    }

    //MARK:- Reload API Data
    func reloadCompanyModulesData() {
        
        if companyOverViewDataSource != nil {
            
            if companyOverViewDataSource?.last?.companyOwnerId == AuthService.instance.userId {
                self.isCurrentUserAsAdmin = true
            }
            
            if companyOverViewDataSource?.last?.ownCompanyRequest != "" {
                self.isSomeoneRequestedForAdmin = true
            }
            
                                    
            if companyOverViewDataSource!.last!.employees.count > 0 {
                employeesArray = companyOverViewDataSource!.last!.employees
            }
            
            var companyAddressStr = "-"
            if self.companyOverViewDataSource!.last!.address != "" {
                companyAddressStr = self.companyOverViewDataSource!.last!.address
            }
            
            var companyPhoneStr = "-"
            if self.companyOverViewDataSource!.last!.phone != "" {
                companyPhoneStr = self.companyOverViewDataSource!.last!.phone
            }
            
            var companyEmailStr = "-"
            if self.companyOverViewDataSource!.last!.email != "" {
                companyEmailStr = self.companyOverViewDataSource!.last!.email
            }
            
            var companyWebSiteStr = "-"
            if self.companyOverViewDataSource!.last!.website != "" {
                companyWebSiteStr = self.companyOverViewDataSource!.last!.website
            }
            
            if let businessTypeArray = self.companyOverViewDataSource!.last?.businessTypeInterest.sorted(), let commodityArray = companyOverViewDataSource!.last?.commodityInterest.sorted(), let affiliationArray = self.companyOverViewDataSource!.last?.affiliationInterest.sorted() {
                
                let obj = Interests()
                self.businessTypeArr = obj.getCompanyIndustries(input: businessTypeArray)
                self.commoditiesArr = obj.getCompanyCommodities(input: commodityArray)
                self.affiliationArr = obj.getCompanyAffiliation(input: affiliationArray)
            }
            
            self.company_lat = self.companyOverViewDataSource!.last!.lat
            self.company_long = self.companyOverViewDataSource!.last!.long
            
            if self.companyDetailsArray.count > 0 {
                self.companyDetailsArray.removeAll()
            }
            
            self.companyDetailsArray =  [["title" : companyAddressStr, "image" : "comp-location-40"],
                                         ["title" : companyPhoneStr, "image" : "call-40"],
                                         ["title" : companyEmailStr, "image" : "email-40"],
                                         ["title" : companyWebSiteStr, "image" : "web-40"],
                                         ["title" : "Interest", "image" : "icStarGreen"]]
            
            self.tableView.reloadData()
        }
        
        
    }
}


//MARK:- Scroll View Actions

extension CompanyModuleOverViewVC: UITableViewDelegate, UITableViewDataSource {
        
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitleArray.count
    }
    //MARK:- UITableViewDelegate , dataSource for Employees
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return sectionExpanded[section] ? (1 + employeesArray.count) : 1
        }
        else if section == 1 {
            return sectionExpanded[section] ? (1 + 1) : 1
        }
        else if section == 3 { // business Type
            
            var sectionCount = 0
            if self.businessTypeArr.count > 0 {
                sectionCount = 1
            }
            return sectionExpanded[section] ? (1 + sectionCount) : 1
        }
        else if section == 4 { // commodity
            var sectionCount = 0
            if self.commoditiesArr.count > 0 {
                sectionCount = 1
            }
            return sectionExpanded[section] ? (1 + sectionCount) : 1
        }
        else if section == 5 { // Affiliation
            var sectionCount = 0
            if self.affiliationArr.count > 0 {
                sectionCount = 1
            }
            return sectionExpanded[section] ? (1 + sectionCount) : 1
        }
        else if section == 6 {
            return sectionExpanded[section] ? (1 + 1) : 1
        }
        else {
            return self.companyDetailsArray.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        print("Section ", indexPath.section)
        print("Row ", indexPath.row)
        
        if indexPath.section == 2 { // Normal call like Call, website,
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyModuleHeaderCell") as? CompanyModuleHeaderCell ?? CompanyModuleHeaderCell()
            
            let dict = self.companyDetailsArray[indexPath.row]
            
            cell.wordLabel.font = UIFont.systemFont(ofSize: 17)
            cell.wordLabel.text = dict["title"]
            cell.wordLabel.textAlignment = .left
            
            cell.wordLabelTopConstraint.constant = 15
            cell.leftImageView.isHidden = false
            if dict["image"] != "" {
                cell.leftImageView.image = UIImage(named: dict["image"]!)
                cell.leftImageWidthConstraint.constant = 25
            }

            cell.rightArrowImageView.isHidden = true
            
            if indexPath.row == 0 {
                cell.mapIconImageView.isHidden = false
                cell.mapIconImageViewWidthConstraint.constant = 65
//                cell.mapIconImageViewHeightConstraint.constant = 65
                cell.mapIconImageView.isUserInteractionEnabled = true
                let gestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(triggerTouchAction(_:)))
                cell.mapIconImageView.addGestureRecognizer(gestureRecognizer)
            }
            else {
                cell.mapIconImageView.isHidden = true
                cell.mapIconImageViewWidthConstraint.constant = 0
//                cell.mapIconImageViewHeightConstraint.constant = 0
            }
            
            cell.wordLabelLeadingConstraint.constant = 12

            cell.topSeparatorLabel.isHidden = false
            return cell
        }
        else if indexPath.section == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyModuleHeaderCell") as? CompanyModuleHeaderCell ?? CompanyModuleHeaderCell()

            cell.wordLabel.font = UIFont.systemFont(ofSize: 17)
            cell.wordLabel.textAlignment = .left
            cell.wordLabelLeadingConstraint.constant = 12
            cell.wordLabelTopConstraint.constant = 15
            
            if indexPath.row == 0 { // timings Header
                         
                let dict = sectionTitleArray[indexPath.section]
                cell.wordLabel.text = dict["headerText"]

                cell.leftImageView.isHidden = false
                if dict["headerImage"] == "" {
                    cell.leftImageWidthConstraint.constant = 0
                }
                else {
                    cell.leftImageView.image = UIImage(named: dict["headerImage"]!)
                    cell.leftImageWidthConstraint.constant = 25
                }

                cell.rightArrowImageView.isHidden = false
                cell.leftImageView.isHidden = false

                cell.topSeparatorLabel.isHidden = false
                
            }
            else { // Open / Close Timings
                
                var openTimingDayStr = "NA"
                var openTimeStr : String = "NA"

                if companyOverViewDataSource != nil {
                    if companyOverViewDataSource!.last!.openTimingDay != "" {
                        openTimingDayStr = companyOverViewDataSource!.last!.openTimingDay
                    }
                    
                    if companyOverViewDataSource!.last!.openTiming != "" {
                        openTimeStr = companyOverViewDataSource!.last!.openTiming
                    }
                }
                
                let firstStr = "Open : " + openTimingDayStr
                let secondStr = "Time : " +  openTimeStr
                
                cell.wordLabel.text = String(format: "%@\n%@", firstStr, secondStr)
                
                cell.rightArrowImageView.isHidden = true
                
                cell.leftImageView.isHidden = true
                cell.leftImageWidthConstraint.constant = 25
                
                cell.topSeparatorLabel.isHidden = true
            }

            cell.mapIconImageView.isHidden = true
            cell.mapIconImageViewWidthConstraint.constant = 0
//            cell.mapIconImageViewHeightConstraint.constant = 0

            return cell
        }
        else if indexPath.section == 3 { // Business type

               if indexPath.row == 0 {
                   let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyModuleHeaderCell") as? CompanyModuleHeaderCell ?? CompanyModuleHeaderCell()

                   let dict = sectionTitleArray[indexPath.section]

                cell.wordLabel.font = UIFont.systemFont(ofSize: 17) //UIFont.boldSystemFont(ofSize: 17)
                   cell.wordLabel.text = dict["headerText"]
                   cell.wordLabel.textAlignment = .left
                   cell.leftImageView.isHidden = false
                   if dict["headerImage"] == "" {
                       cell.leftImageWidthConstraint.constant = 0
                   }
                   else {
                       cell.leftImageView.image = UIImage(named: dict["headerImage"]!)
                       cell.leftImageWidthConstraint.constant = 25
                   }

                cell.wordLabelLeadingConstraint.constant = 0
                cell.wordLabelTopConstraint.constant = 15
                cell.rightArrowImageView.isHidden = false
                cell.mapIconImageView.isHidden = true
                cell.mapIconImageViewWidthConstraint.constant = 0
   //             cell.mapIconImageViewHeightConstraint.constant = 0
                   return cell
               }
               else {

                let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyModuleInterestTableViewCell") as! CompanyModuleInterestTableViewCell
                cell.interestTypeArr = self.businessTypeArr
                cell.collectionView.reloadData()
//                cell.collectionViewHeightConstraint.constant = cell.collectionView.contentSize.height
                cell.collectionView.layoutIfNeeded()
                if let height = cell.collectionView?.collectionViewLayout.collectionViewContentSize.height {
                    cell.collectionViewHeightConstraint.constant = height
                }
//                cell.collectionViewHeightConstraint.constant = cell.collectionView.collectionViewLayout.collectionViewContentSize.height
                return cell
               }
        }
        else if indexPath.section == 4 { // Commodity

               if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyModuleHeaderCell") as? CompanyModuleHeaderCell ?? CompanyModuleHeaderCell()

                let dict = sectionTitleArray[indexPath.section]

                 cell.wordLabel.font = UIFont.systemFont(ofSize: 17) // UIFont.boldSystemFont(ofSize: 17)
                cell.wordLabel.text = dict["headerText"]
                cell.leftImageView.isHidden = false
                if dict["headerImage"] == "" {
                    cell.leftImageWidthConstraint.constant = 0
                }
                else {
                    cell.leftImageView.image = UIImage(named: dict["headerImage"]!)
                    cell.leftImageWidthConstraint.constant = 25
                }

                cell.wordLabelLeadingConstraint.constant = 0
                cell.wordLabelTopConstraint.constant = 15
                cell.rightArrowImageView.isHidden = false
                cell.mapIconImageView.isHidden = true
                cell.mapIconImageViewWidthConstraint.constant = 0
//                cell.mapIconImageViewHeightConstraint.constant = 0
                 cell.topSeparatorLabel.isHidden = false
                return cell
            }
               else {

                let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyModuleInterestTableViewCell") as! CompanyModuleInterestTableViewCell
                cell.interestTypeArr = self.commoditiesArr
                cell.collectionView.reloadData()
                cell.collectionView.layoutIfNeeded()
                if let height = cell.collectionView?.collectionViewLayout.collectionViewContentSize.height {
                    cell.collectionViewHeightConstraint.constant = height
                }
                return cell
               }
        }
        else if indexPath.section == 5 { // Affiliation

               if indexPath.row == 0 {
                   let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyModuleHeaderCell") as? CompanyModuleHeaderCell ?? CompanyModuleHeaderCell()
                   cell.wordLabel.textAlignment = .left
                
                   let dict = sectionTitleArray[indexPath.section]

                   cell.wordLabel.font = UIFont.systemFont(ofSize: 17) //UIFont.boldSystemFont(ofSize: 17)
                   cell.wordLabel.text = dict["headerText"]
                   cell.leftImageView.isHidden = false
                   if dict["headerImage"] == "" {
                       cell.leftImageWidthConstraint.constant = 0
                   }
                   else {
                       cell.leftImageView.image = UIImage(named: dict["headerImage"]!)
                       cell.leftImageWidthConstraint.constant = 25
                   }

                   cell.wordLabelLeadingConstraint.constant = 0
                cell.wordLabelTopConstraint.constant = 15
                   cell.rightArrowImageView.isHidden = false
                   cell.mapIconImageView.isHidden = true
                   cell.mapIconImageViewWidthConstraint.constant = 0
   //                cell.mapIconImageViewHeightConstraint.constant = 0
                
                    cell.topSeparatorLabel.isHidden = false

                   return cell
               }
               else {

                let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyModuleInterestTableViewCell") as! CompanyModuleInterestTableViewCell
                cell.interestTypeArr = self.affiliationArr
                cell.collectionView.reloadData()
                cell.collectionView.layoutIfNeeded()
                if let height = cell.collectionView?.collectionViewLayout.collectionViewContentSize.height {
                    cell.collectionViewHeightConstraint.constant = height
                }
                return cell
               }
        }
        else if indexPath.section == 6 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyModuleHeaderCell") as? CompanyModuleHeaderCell ?? CompanyModuleHeaderCell()

            cell.topSeparatorLabel.isHidden = false
            

            if indexPath.row == 0 { // About Header
                cell.wordLabel.font = UIFont.systemFont(ofSize: 17) //UIFont.boldSystemFont(ofSize: 17)
                cell.wordLabel.textAlignment = .left
                
               let dict = sectionTitleArray[indexPath.section]
               cell.wordLabel.text = dict["headerText"]
               
               cell.leftImageView.isHidden = false
               if dict["headerImage"] == "" {
                   cell.leftImageWidthConstraint.constant = 0
               }
               else {
                   cell.leftImageView.image = UIImage(named: dict["headerImage"]!)
                   cell.leftImageWidthConstraint.constant = 25
               }
                
                cell.wordLabelTopConstraint.constant = 15
            }
            else { // About Description
                cell.wordLabel.font = UIFont.systemFont(ofSize: 17)

                var aboutStr = "-"

                if self.companyOverViewDataSource != nil {
                    aboutStr = self.companyOverViewDataSource!.last!.compnayAbout
                }
                
//                cell.leftImageView.isHidden = true
                cell.wordLabel.text = aboutStr
                cell.leftImageWidthConstraint.constant = 0
                cell.topSeparatorLabel.isHidden = true
                
                cell.wordLabel.textAlignment = .justified
                cell.wordLabelTopConstraint.constant = 0
            }
              
            cell.wordLabelLeadingConstraint.constant = 0

            cell.rightArrowImageView.isHidden = true
            cell.mapIconImageView.isHidden = true
            cell.mapIconImageViewWidthConstraint.constant = 0
//            cell.mapIconImageViewHeightConstraint.constant = 0

            return cell
        }
        else {
         
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyModuleHeaderCell") as? CompanyModuleHeaderCell ?? CompanyModuleHeaderCell()

                let dict = sectionTitleArray[indexPath.section]
                
                cell.topSeparatorLabel.isHidden = false
                cell.wordLabel.font = UIFont.systemFont(ofSize: 17)
                cell.wordLabel.textAlignment = .left

                if indexPath.section == 0 && indexPath.row == 0 {
                    cell.topSeparatorLabel.isHidden = true

                    var headerText : String = JSONUtils.GetStringFromObject(object: dict, key: "headerText")

                    if self.employeesArray.count > 0 {
                        if employeesArray.count == 1 {
                            headerText = String(headerText.dropLast())
                        }
                        cell.wordLabel.text = String(format: "%d %@", self.employeesArray.count, headerText)
                    }
                    else {
                        cell.wordLabel.text = headerText
                    }
                }
                else {
                    cell.wordLabel.text = dict["headerText"]
                }
                cell.leftImageView.isHidden = false
                if dict["headerImage"] == "" {
                    cell.leftImageWidthConstraint.constant = 0
                }
                else {
                    cell.leftImageView.image = UIImage(named: dict["headerImage"]!)
                    cell.leftImageWidthConstraint.constant = 25
                }
    //            if sectionExpanded[indexPath.section] {
    //
    //            }
    //            else {}

                cell.wordLabelLeadingConstraint.constant = 12

                cell.rightArrowImageView.isHidden = false
                cell.mapIconImageView.isHidden = true
                cell.mapIconImageViewWidthConstraint.constant = 0
//                cell.mapIconImageViewHeightConstraint.constant = 0
                return cell
            }
            else {
                
                if indexPath.section == 0 { // Employess
                    
                    let cell: OverviewEmployeeListCell = tableView.dequeueReusableCell(withIdentifier: "overview_emp_list", for: indexPath) as! OverviewEmployeeListCell
                                
                    if companyOverViewDataSource != nil {
                        let dict = self.employeesArray[indexPath.row - 1]
                        let name = dict.first_name + " " + dict.last_name
                        let designation = dict.designation
                        let company = dict.companyName
                        cell.nameLbl.text = name
                        cell.compDesigLbl.text = designation + " • " + company.capitalized
                        
                        cell.adminLabel.isHidden = true
                        cell.adminLabel.backgroundColor = UIColor.GREEN_PRIMARY
                        cell.adminLabel.text = "  Admin  "
                        cell.adminLabel.layer.cornerRadius = 9.0
                        cell.adminLabel.textColor = UIColor.white
                        cell.adminLabel.layer.masksToBounds = true
                        
                        cell.profileView.isUserInteractionEnabled = true
                        
                        //makeAsAdminBtn
                        cell.makeAsAdminBtn.isHidden = true
                        cell.makeAsAdminBtn.layer.cornerRadius = 3.0
                        cell.makeAsAdminBtn.layer.borderWidth = 1.0
                        cell.makeAsAdminBtn.layer.borderColor = UIColor.GREEN_PRIMARY.cgColor
                        cell.makeAsAdminBtn.tag = indexPath.row
                        cell.makeAsAdminBtn.addTarget(self, action: #selector(makeAsAdminButtonAction), for: .touchUpInside)

                        //reportCompanyButton
                        cell.reportBtn.isHidden = true
                        cell.reportBtn.setImage(UIImage(named: "icReport"), for: .normal)
                        cell.reportBtn.setTitle("Report", for: .normal)
                        cell.reportBtn.setTitleColor(UIColor.gray, for: .normal)
                        cell.reportBtn.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 14)
                        cell.reportBtn.alignTextUnderImage(imgsize: CGSize(width: 25, height: 25), spacing: 2)
//                        cell.reportBtn.layer.cornerRadius = 3.0
                        cell.reportBtn.tag = indexPath.row
                        cell.reportBtn.addTarget(self, action: #selector(reportButtonAction), for: .touchUpInside)
                        
                        let profilePic = dict.profilePic
                        let colorCode = dict.colorcode
                        
                        cell.profileView.updateViews(name: name, url: profilePic,  colorCode: colorCode)
                        let isAdmin = dict.isAdmin
                        let isAdminView = dict.isAdminView
                        let isEmplView = dict.isEmployeeView
                        
                        let adminReported = dict.reportOfCompanyAdmin
                        let userId = dict.userId
                        
                        if userId != "" {
                            
                            if userId == AuthService.instance.userId && isAdminView { // Admin point of view
                                cell.reportBtn.isHidden = true
                                cell.reportBtnWidthConstraint.constant = 0
                                if isAdmin {
                                    cell.adminLabel.isHidden = false
                                }
                                else {
                                    cell.makeAsAdminBtn.isHidden = false
                                    cell.makeAsAdminBtn.setTitle(self.makeAsAdminText, for: .normal)
                                    cell.makeAsAdminWidthConstraint.constant = 120
                                }
                            }
                            else if self.companyOverViewDataSource!.last!.isAdminAvailable && isEmplView { // check if the company have admin and other users have employee
                                
                                if self.isCurrentUserAsAdmin {
                                    cell.reportBtn.isHidden = true
                                    cell.reportBtnWidthConstraint.constant = 0
                                    
                                    cell.makeAsAdminBtn.isHidden = false
                                    cell.makeAsAdminBtn.setTitle(self.makeAsAdminText, for: .normal)
                                    cell.makeAsAdminWidthConstraint.constant = 120
                                }
                                else {
                                    cell.reportBtn.isHidden = true
                                    cell.reportBtnWidthConstraint.constant = 0
                                    
//                                    cell.adminBtn.isHidden = true
                                }
                            }
                            else {
                                if isAdmin { // Show other user Admin
                                    cell.reportBtn.isHidden = false
                                    cell.adminLabel.isHidden = false

                                    cell.makeAsAdminWidthConstraint.constant = 0

                                    if adminReported == "Reported" {
                                        cell.reportBtn.setTitle(self.reportedText, for: .normal)
                                    }
                                    else {
                                        cell.reportBtn.setTitle(self.reportText, for: .normal)
                                    }
                                    cell.reportBtnWidthConstraint.constant = 70
                                }
                                else {
                                    cell.adminLabel.isHidden = true
                                    if userId == AuthService.instance.userId && !isSomeoneRequestedForAdmin{
                                        cell.makeAsAdminBtn.isHidden = false
                                        cell.makeAsAdminBtn.setTitle(self.makeAsAdminText, for: .normal)
                                        cell.makeAsAdminWidthConstraint.constant = 120
                                    }
                                    cell.reportBtn.isHidden = true
                                    cell.reportBtnWidthConstraint.constant = 0
                                }
                            }
                        }
                    }

                    return cell
                }
                else {
                    return UITableViewCell()
                }
            }
        }
}
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
        if indexPath.section != 6 {
            
            if indexPath.section == 0 && indexPath.row != 0 {

                let dict = self.employeesArray[indexPath.row - 1]

                if dict.userId != "" {
                    performFriendView(friendId: dict.userId)
                }
            }
            else {
                sectionExpanded[indexPath.section] = !sectionExpanded[indexPath.section]
                
                tableView.reloadSections([indexPath.section], with: .automatic)

            }
//           if indexPath.row == 0 {
//
//               sectionExpanded[indexPath.section] = !sectionExpanded[indexPath.section]
//
//               tableView.reloadSections([indexPath.section], with: .automatic)
//           }
       }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let delta = scrollView.contentOffset.y - oldContentOffset.y
        
        let topViewCurrentHeightConst = innerTableViewScrollDelegate?.currentHeaderHeight
        
        if let topViewUnwrappedHeight = topViewCurrentHeightConst {
            
            /**
             *  Re-size (Shrink) the top view only when the conditions meet:-
             *  1. The current offset of the table view should be greater than the previous offset indicating an upward scroll.
             *  2. The top view's height should be within its minimum height.
             *  3. Optional - Collapse the header view only when the table view's edge is below the above view - This case will occur if you are using Step 2 of the next condition and have a refresh control in the table view.
             */
            
            if delta > 0,
                topViewUnwrappedHeight > topViewHeightConstraintRange.lowerBound,
                scrollView.contentOffset.y > 0 {
                
                dragDirection = .Up
                innerTableViewScrollDelegate?.innerTableViewDidScroll(withDistance: delta)
                scrollView.contentOffset.y -= delta
            }
            
            /**
             *  Re-size (Expand) the top view only when the conditions meet:-
             *  1. The current offset of the table view should be lesser than the previous offset indicating an downward scroll.
             *  2. Optional - The top view's height should be within its maximum height. Skipping this step will give a bouncy effect. Note that you need to write extra code in the outer view controller to bring back the view to the maximum possible height.
             *  3. Expand the header view only when the table view's edge is below the header view, else the table view should first scroll till it's offset is 0 and only then the header should expand.
             */
            
            if delta < 0,
                // topViewUnwrappedHeight < topViewHeightConstraintRange.upperBound,
                scrollView.contentOffset.y < 0 {
                
                dragDirection = .Down
                innerTableViewScrollDelegate?.innerTableViewDidScroll(withDistance: delta)
                scrollView.contentOffset.y -= delta
            }
        }
        
        oldContentOffset = scrollView.contentOffset
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        //You should not bring the view down until the table view has scrolled down to it's top most cell.
        
        if scrollView.contentOffset.y <= 0 {
            
            innerTableViewScrollDelegate?.innerTableViewScrollEnded(withScrollDirection: dragDirection)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        //You should not bring the view down until the table view has scrolled down to it's top most cell.
        
        if decelerate == false && scrollView.contentOffset.y <= 0 {
            
            innerTableViewScrollDelegate?.innerTableViewScrollEnded(withScrollDirection: dragDirection)
        }
    }
    
    @objc func triggerTouchAction(_ gestureReconizer: UIGestureRecognizer) {
        
        if company_lat != 0 && company_long != 0 {
            let coordinate = CLLocationCoordinate2DMake(company_lat,company_long)
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary:nil))
            let companyName = UserDefaults.standard.object(forKey: "companyName") as! String
            mapItem.name = companyName
            mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
        }
    }
    
    //MARK: Cell Actions
    @objc func makeAsAdminButtonAction(sender : UIButton) {
        
        let isAdminAvailable = self.companyOverViewDataSource!.last!.isAdminAvailable
        
        if isAdminAvailable {
            
            if sender.tag != 0 {
                let dict = self.employeesArray[sender.tag - 1]

                let isEmployeeView = dict.isEmployeeView

                let userId = dict.userId
                
                if userId != "" {
                    if userId != AuthService.instance.userId && isEmployeeView
                    {
                        self.makeEmployeeAsAdmin(userIDForMakingAdmin: userId)
                    }
                }
            }
        }
        else {
            let vc = OwnThisCompanyVC()
            vc.viewDelegate = self

            if self.companyOverViewDataSource!.last != nil {//.count > 0 {
                vc.getCompanyItems = self.companyOverViewDataSource!.last!
            }

            self.navigationController?.pushViewController(vc, animated: true)

        }
    }

    @objc func reportButtonAction(sender: UIButton) {
      
        let dict = self.employeesArray[sender.tag - 1]

        if dict.reportOfCompanyAdmin == "Reported" {
            
        }
        else {
            
            let reportAdminDropDown = DropDown()
            
            reportAdminDropDown.anchorView = sender
            reportAdminDropDown.bottomOffset = CGPoint(x: sender.frame.origin.x, y:(reportAdminDropDown.anchorView?.plainView.bounds.height)!)
            reportAdminDropDown.dataSource = ["Report Inappropriate Admin"]
            reportAdminDropDown.cellHeight = 45.0
            reportAdminDropDown.direction = .bottom
            reportAdminDropDown.dropDownWidth = 225
            reportAdminDropDown.setupCornerRadius(3)
            reportAdminDropDown.backgroundColor = UIColor.white

            reportAdminDropDown.show()
            reportAdminDropDown.selectionAction = {[unowned self] (index: Int, item: String) in
                
                self.reportAdminAlertView { (isSuccess) in
                    
                    if isSuccess {
                        let dict = self.employeesArray[sender.tag - 1]

                        if dict.reportOfCompanyAdmin != "" {
                            dict.reportOfCompanyAdmin = "Reported"
                            self.tableView.reloadSections(IndexSet(integer: sender.tag - 1), with: .none)
                        }
    //                    if let cell = self.tableView.cellForRow(at: IndexPath(index: sender.tag)) as? OverviewEmployeeListCell {
    //
    //                        cell.reportBtn.
    //                    }
                    }
                }
            }
        }
    }
    
    
    func reportAdminAlertView(completion: @escaping (Bool) -> ()) { //(completion: @escaping (Bool) -> ())
        
        let reportAdminView = ReportAlertView()
                
//        print(self.parent?.topMostViewController())
        
//        let vc: CompanyHeaderModuleVC = view.parentViewController as! CompanyHeaderModuleVC
        
//       HeaderdModuleVC -> BottomView -> UIPageViewController -> View -> [ViewController, Tab1,Tab2]
        
        //overViewVC -> View
        
//        if let pageVC = self.view.superview?.superview?.superview as? UIPageViewController {
//
//            print(pageVC)
//        }
        
//        print(self.view.superview?.superview)
        
//        var vc : UIViewController = self
//
//        if let companyHeaderModuleVC = UIStoryboard.init(name: "CompanyModule", bundle: nil).instantiateViewController(withIdentifier: "CompanyHeaderModuleVC") as? CompanyHeaderModuleVC {
//
//            vc = companyHeaderModuleVC
//        }
        
        reportAdminView.displayAlert(withSuperView: self , title: "Are you sure you want to report this admin?") {
            
            let reportDescStr = reportAdminView.descriptionTextView.text!
                     
            var companyId = ""
            
            if self.companyOverViewDataSource!.last!.compnayId != "" {
                companyId = self.companyOverViewDataSource!.last!.compnayId
            }

            self.apiService.reportAboutCompanyAndAdmin(view: self.view,
                                                       companyId: companyId,
                                                  reportType: "0", // report about Admin of the Company
                                                  reportDesc: reportDescStr) { (isSuccess) in
                
                if isSuccess! {
                    // Change text to "Reported"
                    completion(true)
                    reportAdminView.doCloseAnimation()
                }
                else {
                    completion(true)
                    reportAdminView.doCloseAnimation()
                }
            }
        }
    }
    
    
    //MARK:- makeEmployeeAsAdmin API
    func makeEmployeeAsAdmin(userIDForMakingAdmin : String) {
        
        
        let spinner = MBProgressHUD.showAdded(to: self.view, animated: true)
        spinner.mode = MBProgressHUDMode.indeterminate
        spinner.label.text = "Requesting..."
        let service = APIService()

        let endPoint = Endpoints.MAKE_EMPLOYEES_AS_ADMIN
        var companyId = ""
        
        if self.companyOverViewDataSource!.last!.compnayId != "" {
            companyId = self.companyOverViewDataSource!.last!.compnayId
        }
        
        service.endPoint = endPoint
        if companyId != "" && userIDForMakingAdmin != "" {
            
            service.params = "userId=\(userIDForMakingAdmin)&apiKey=\(API_KEY)&companyId=\(companyId)"
            service.getDataWith { [weak self] (result) in

                switch result{
                case .Success(let dict):
                    if let error = dict["error"] as? Bool{
                        if !error{
                            self?.callGetCompanyAPI(companyId : companyId)
                            DispatchQueue.main.async {
                                MBProgressHUD.hide(for: (self?.view)!, animated: true)
                            }
                        } else {
                            DispatchQueue.main.async {
                                self?.showToast(message: dict["status"] as? String ?? "Error in sending request")
                            }
                        }
                    }
                case .Error(let error):
                    DispatchQueue.main.async {
                        self?.showToast(message: error)
                    }
                }
            }
        }
    }
    //MARK:- GetCompany Details API API
    func callGetCompanyAPI(companyId : String) {
        apiService.getCompanyDetails(companyId: companyId)
        apiService.delegate = self
    }
}

extension CompanyModuleOverViewVC: CompanyUpdatedServiceDelegate {
    func DidReceivedError(error: String) {
        print("Error while receiving company data : \(error)")
    }
    
    func didReceiveCompanyValues(data: [CompanyItems]) {
        DispatchQueue.main.async {
            self.companyOverViewDataSource = data
            
            self.reloadCompanyModulesData()
            
//            if self.companyOverViewDataSource!.last!.employees.count > 0 {
//                self.employeesArray = self.companyOverViewDataSource!.last!.employees
//            }
//
//            self.tableView.reloadData()
        }
    }
}

class CompanyModuleHeaderCell: UITableViewCell {
  
    let topSeparatorLabel = UILabel()

    let leftImageView = UIImageView()
    let wordLabel = UILabel()
    
    var wordLabelTopConstraint : NSLayoutConstraint!
    var wordLabelLeadingConstraint : NSLayoutConstraint!

    var leftImageWidthConstraint : NSLayoutConstraint!
    
    let rightArrowImageView = UIImageView()
    
    let mapIconImageView = UIImageView()
    var mapIconImageViewWidthConstraint : NSLayoutConstraint!
    var mapIconImageViewHeightConstraint : NSLayoutConstraint!

    var newItem : [String : String]? {
        didSet{
            guard let item = newItem else { return }
            configCell(withItem: item)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.backgroundColor = UIColor.white
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configCell(withItem item: [String : String]) {
        
//        reportedView.isHidden = true
        
    }
    
    func setupViews() {

        selectionStyle = .none

        //topSeparatorLabel
        topSeparatorLabel.translatesAutoresizingMaskIntoConstraints = false
        topSeparatorLabel.backgroundColor = UIColor(red: 222/255, green: 222/255, blue: 227/255, alpha: 1)
        self.contentView.addSubview(self.topSeparatorLabel)

        self.leftImageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(self.leftImageView)
        
        wordLabel.translatesAutoresizingMaskIntoConstraints = false
        wordLabel.text = " "
        wordLabel.textColor = UIColor.black
        wordLabel.numberOfLines = 0
        wordLabel.lineBreakMode = .byWordWrapping
        self.contentView.addSubview(wordLabel)
        
        
        self.rightArrowImageView.translatesAutoresizingMaskIntoConstraints = false
        self.rightArrowImageView.image = UIImage(named: "down-arrow-10")
        self.rightArrowImageView.isHidden = true
        self.contentView.addSubview(self.rightArrowImageView)

        
        self.mapIconImageView.translatesAutoresizingMaskIntoConstraints = false
        self.mapIconImageView.isHidden = true
        self.mapIconImageView.image = UIImage(named: "google_page_review")
        self.contentView.addSubview(self.mapIconImageView)

        
        self.setUpConstraints()
    }
    
    func setUpConstraints() {
       
        //topSeparatorLabel
        self.topSeparatorLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0).isActive = true
        self.topSeparatorLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 0).isActive = true
        self.topSeparatorLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0).isActive = true
        self.topSeparatorLabel.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //leftImageView
        leftImageView.leadingAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.leadingAnchor,constant: 0).isActive = true
        leftImageView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        leftImageView.centerYAnchor.constraint(equalTo: self.wordLabel.centerYAnchor, constant: 0).isActive = true
        self.leftImageWidthConstraint = leftImageView.widthAnchor.constraint(equalToConstant: 25)
        self.leftImageWidthConstraint.isActive = true
        
        //wordLabel
//        wordLabel.leadingAnchor.constraint(equalTo: self.leftImageView.trailingAnchor,constant: 12).isActive = true
        
        self.wordLabelLeadingConstraint = wordLabel.leadingAnchor.constraint(equalTo: self.leftImageView.trailingAnchor,constant: 12)
        self.wordLabelLeadingConstraint.isActive = true
        
        wordLabel.trailingAnchor.constraint(lessThanOrEqualTo: mapIconImageView.leadingAnchor, constant:  -16).isActive = true
        
        self.wordLabelTopConstraint = wordLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor,constant: 15)
        self.wordLabelTopConstraint.isActive = true
        
        wordLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,constant: -15).isActive = true
        
        rightArrowImageView.leadingAnchor.constraint(equalTo: self.wordLabel.trailingAnchor,constant: 10).isActive = true
        rightArrowImageView.centerYAnchor.constraint(equalTo: self.wordLabel.centerYAnchor, constant: 0).isActive = true
        
        //mapIconImageView
        mapIconImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,constant: 0).isActive = true
        mapIconImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor,constant: 0).isActive = true
//        mapIconImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,constant: 0).isActive = true
        
        self.mapIconImageViewWidthConstraint = mapIconImageView.widthAnchor.constraint(equalToConstant: 60)
        self.mapIconImageViewWidthConstraint.isActive = true
        
        self.mapIconImageViewHeightConstraint = mapIconImageView.heightAnchor.constraint(equalToConstant: 60)
        self.mapIconImageViewHeightConstraint.isActive = true

    }
}

//extension UIResponder {
//    public var parentViewController: UIViewController? {
//        return next as? UIViewController ?? next?.parentViewController
//    }
//}

//extension UIView {
//    var myParentViewController: UIViewController? {
//        var parentResponder: UIResponder? = self
//        while parentResponder != nil {
//            parentResponder = parentResponder?.next
//            if let viewController = parentResponder as? UIViewController {
//                return viewController
//            }
//        }
//        return nil
//    }
//}

extension CompanyModuleOverViewVC : UpdateOwnCompanydelegate {
    
    func updateData() {
//        self.ownCompBtn.setTitle(self.requestedStr, for: .normal)
        self.showAlert(message: "Request has been sent. You will be notified soon")
    }
}

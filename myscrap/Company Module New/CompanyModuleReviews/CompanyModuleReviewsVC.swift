//
//  CompanyModuleReviewsVC.swift
//  myscrap
//
//  Created by Apple on 21/10/2020.
//  Copyright © 2020 MyScrap. All rights reserved.
//

import UIKit
import Cosmos

class CompanyModuleReviewsVC: UIViewController {

    @IBOutlet weak var contentScrollView : UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tvHeightConstraint: NSLayoutConstraint!

    @IBOutlet weak var five_bar: CircleView!
    @IBOutlet weak var four_bar: CircleView!
    @IBOutlet weak var three_bar: CircleView!
    @IBOutlet weak var two_bar: CircleView!
    @IBOutlet weak var one_bar: CircleView!
    @IBOutlet weak var five_barWidth: NSLayoutConstraint!
    @IBOutlet weak var four_barWidth: NSLayoutConstraint!
    
    @IBOutlet weak var three_barWidth: NSLayoutConstraint!
    @IBOutlet weak var two_barWidth: NSLayoutConstraint!
    @IBOutlet weak var one_barWidth: NSLayoutConstraint!
    
    @IBOutlet weak var avgRatingLbl: UILabel!
    @IBOutlet weak var totalReviewCountLbl: UILabel!

    @IBOutlet weak var starRate: CosmosView!
    @IBOutlet weak var avgStarRate: CosmosView!

    
    @IBOutlet weak var totalReviewTitleLbl: UILabel!

    
    var review_service = ReviewService()
    var dataSource = [UserReview]()
    var review_delegate: ReviewServiceDelegate?

    
    weak var innerTableViewScrollDelegate: InnerTableViewScrollDelegate?
    
    //MARK:- Stored Properties for Scroll Delegate
    private var dragDirection: DragDirection = .Up
    private var oldContentOffset = CGPoint.zero

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
                
//        self.contentScrollView.contentSize = CGSize(width: self.view.frame.width, height: 2000)
        self.contentScrollView.delegate = self
        
        starRate.didFinishTouchingCosmos = { rating in
            let vc = ReviewPopupVC.storyBoardInstance()
            vc?.rating = rating
            //vc?.navigationItem.title = "Admin View"
            if let cname = UserDefaults.standard.object(forKey: "companyName") as? String {
                //vc?.navigationItem.backBarButtonItem = UIBarButtonItem(title: cname, style: .plain, target: nil, action: nil)
                vc?.navigationItem.title = cname
            }
            
            //vc?.navigationItem.backBarButtonItem = UIBarButtonItem(title: self.company_name, style: .plain, target: nil, action: nil)
            self.navigationController?.pushViewController(vc!, animated: true)
            
        }
        avgStarRate.settings.updateOnTouch = false

        
        review_service.delegate = self
        setupTableView()
        let companyId = UserDefaults.standard.object(forKey: "companyId") as? String
        //service.getCompanyDetails(companyId: companyId!)
        review_service.reviewFetch(companyId: companyId!)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
                
//        review_service.delegate = self
//        setupTableView()
//        let companyId = UserDefaults.standard.object(forKey: "companyId") as? String
//        //service.getCompanyDetails(companyId: companyId!)
//        review_service.reviewFetch(companyId: companyId!)
    }

    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.isScrollEnabled = false
        //tableView.register(EmployeeListTVCell.self, forCellReuseIdentifier: "employeeList")
        //tableView.isScrollEnabled = true
        
    }

}

extension CompanyModuleReviewsVC : UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if dataSource.count != 0 {
            
            return dataSource.count
        } else {
            
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CompanyReviewCell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CompanyReviewCell
        
        cell.delegate = self
        cell.userData = dataSource[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 150
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    //MARK:- Scroll View Actions

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let delta = scrollView.contentOffset.y - oldContentOffset.y
        
        let topViewCurrentHeightConst = innerTableViewScrollDelegate?.currentHeaderHeight
        
        if let topViewUnwrappedHeight = topViewCurrentHeightConst {
            
            if delta > 0,
                topViewUnwrappedHeight > topViewHeightConstraintRange.lowerBound,
                scrollView.contentOffset.y > 0 {
                
                dragDirection = .Up
                innerTableViewScrollDelegate?.innerTableViewDidScroll(withDistance: delta)
                scrollView.contentOffset.y -= delta
            }
 
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
}


extension CompanyModuleReviewsVC : ReviewServiceDelegate {
    func didFetchReview(data: [ReviewItems]) {
        DispatchQueue.main.async {
            self.dataSource = data.last!.userReview
            
            for value in self.dataSource {
                if value.userId.contains(AuthService.instance.userId) {
                    self.starRate.rating = value.ratting
                    self.starRate.settings.updateOnTouch = false
                } else {
                    self.starRate.settings.updateOnTouch = true
                }
            }
            
            self.avgRatingLbl.text = data.last!.AvgRating
            self.avgStarRate.rating = (self.avgRatingLbl.text! as NSString).doubleValue
            self.totalReviewCountLbl.text = data.last!.totalReview + " reviews"
//            self.totalReviewTitleLbl.text = "Total Reviews (" + String(data.last!.userReview.count) + ")"
            let rating = data.last!.ratingValues
            for value in rating {
                if value.rattingLable == "5" {
                    let percentage = Int(value.ratingPercentage)!
                    if percentage <= 10 && percentage >= 0{
                        self.five_bar.layer.cornerRadius = 0
                        self.five_bar.layer.masksToBounds = true
                        self.five_barWidth.constant = 10
                    } else if percentage <= 20 && percentage >= 10{
                        self.five_barWidth.constant = 40
                    } else if percentage <= 30 && percentage >= 20{
                        self.five_barWidth.constant = 60
                    } else if percentage <= 40 && percentage >= 30{
                        self.five_barWidth.constant = 80
                    } else if percentage <= 50 && percentage >= 40{
                        self.five_barWidth.constant = 100
                    } else if percentage <= 60 && percentage >= 50{
                        self.five_barWidth.constant = 120
                    } else if percentage <= 70 && percentage >= 60{
                        self.five_barWidth.constant = 140
                    } else if percentage <= 80 && percentage >= 70{
                        self.five_barWidth.constant = 160
                    } else if percentage <= 90 && percentage >= 80{
                        self.five_barWidth.constant = 180
                    } else {
                        self.five_barWidth.constant = 200
                    }
                } else if value.rattingLable == "4" {
                    let percentage = Int(value.ratingPercentage)!
                    if percentage <= 10 && percentage >= 0{
                        self.four_bar.layer.cornerRadius = 0
                        self.four_barWidth.constant = 10
                    } else if percentage <= 20 && percentage >= 10{
                        self.four_barWidth.constant = 40
                    } else if percentage <= 30 && percentage >= 20{
                        self.four_barWidth.constant = 60
                    } else if percentage <= 40 && percentage >= 30{
                        self.four_barWidth.constant = 80
                    } else if percentage <= 50 && percentage >= 40{
                        self.four_barWidth.constant = 100
                    } else if percentage <= 60 && percentage >= 50{
                        self.four_barWidth.constant = 120
                    } else if percentage <= 70 && percentage >= 60{
                        self.four_barWidth.constant = 140
                    } else if percentage <= 80 && percentage >= 70{
                        self.four_barWidth.constant = 160
                    } else if percentage <= 90 && percentage >= 80{
                        self.four_barWidth.constant = 180
                    } else {
                        self.four_barWidth.constant = 200
                    }
                } else if value.rattingLable == "3" {
                    let percentage = Int(value.ratingPercentage)!
                    if percentage <= 10 && percentage >= 0{
                        self.three_bar.layer.cornerRadius = 0
                        self.three_barWidth.constant = 10
                    } else if percentage <= 20 && percentage >= 10{
                        self.three_barWidth.constant = 40
                    } else if percentage <= 30 && percentage >= 20{
                        self.three_barWidth.constant = 60
                    } else if percentage <= 40 && percentage >= 30{
                        self.three_barWidth.constant = 80
                    } else if percentage <= 50 && percentage >= 40{
                        self.three_barWidth.constant = 100
                    } else if percentage <= 60 && percentage >= 50{
                        self.three_barWidth.constant = 120
                    } else if percentage <= 70 && percentage >= 60{
                        self.three_barWidth.constant = 140
                    } else if percentage <= 80 && percentage >= 70{
                        self.three_barWidth.constant = 160
                    } else if percentage <= 90 && percentage >= 80{
                        self.three_barWidth.constant = 180
                    } else {
                        self.three_barWidth.constant = 200
                    }
                } else if value.rattingLable == "2" {
                    let percentage = Int(value.ratingPercentage)!
                    if percentage <= 10 && percentage >= 0{
                        self.two_bar.layer.cornerRadius = 0
                        self.two_barWidth.constant = 10
                    } else if percentage <= 20 && percentage >= 10{
                        self.two_barWidth.constant = 40
                    } else if percentage <= 30 && percentage >= 20{
                        self.two_barWidth.constant = 60
                    } else if percentage <= 40 && percentage >= 30{
                        self.two_barWidth.constant = 80
                    } else if percentage <= 50 && percentage >= 40{
                        self.two_barWidth.constant = 100
                    } else if percentage <= 60 && percentage >= 50{
                        self.two_barWidth.constant = 120
                    } else if percentage <= 70 && percentage >= 60{
                        self.two_barWidth.constant = 140
                    } else if percentage <= 80 && percentage >= 70{
                        self.two_barWidth.constant = 160
                    } else if percentage <= 90 && percentage >= 80{
                        self.two_barWidth.constant = 180
                    } else {
                        self.two_barWidth.constant = 200
                    }
                } else if value.rattingLable == "1"{
                    let percentage = Int(value.ratingPercentage)!
                    print("1 percentage :\(percentage)")
                    if percentage <= 10 && percentage >= 0{
                        self.one_bar.layer.cornerRadius = 0
                        self.one_barWidth.constant = 10
                    } else if percentage <= 20 && percentage >= 10{
                        self.one_barWidth.constant = 40
                    } else if percentage <= 30 && percentage >= 20{
                        self.one_barWidth.constant = 60
                    } else if percentage <= 40 && percentage >= 30{
                        self.one_barWidth.constant = 80
                    } else if percentage <= 50 && percentage >= 40{
                        self.one_barWidth.constant = 100
                    } else if percentage <= 60 && percentage >= 50{
                        self.one_barWidth.constant = 120
                    } else if percentage <= 70 && percentage >= 60{
                        self.one_barWidth.constant = 140
                    } else if percentage <= 80 && percentage >= 70{
                        self.one_barWidth.constant = 160
                    } else if percentage <= 90 && percentage >= 80{
                        self.one_barWidth.constant = 180
                    } else {
                        self.one_barWidth.constant = 200
                    }
                } else {
                    print("Some weird value from api for rating bar")
                }
            }
            self.tableView.reloadData()
            self.tableView.layoutIfNeeded()

            print(self.tableView.contentSize.height)
            self.tvHeightConstraint.constant =  self.tableView.contentSize.height
            
        }
    }
    
    func didReceiveReviewValues(status: String) {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
            
            //self.showMessage(with: status)
            let companyId = UserDefaults.standard.object(forKey: "companyId") as? String
            self.review_service.reviewFetch(companyId: companyId!)
//            self.service.getCompanyDetails(companyId: companyId!)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateReview"), object: nil)
            
        }
    }
    
    func didReceivedError(error: String) {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
            //self.showMessage(with: error)
            print("Error in Compose email : \(error)")
        }
    }
}

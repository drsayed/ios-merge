//
//  VisitorsVC.swift
//  myscrap
//
//  Created by MS1 on 7/20/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

class VisitorsVC: BaseRevealVC, FriendControllerDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var active: UIActivityIndicatorView!
    
    fileprivate var datasource = [VisitorItem]()
    fileprivate var service = VisitorService()
    fileprivate var initiallyLoaded = false
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControl.Event.valueChanged)
        return refreshControl
    }()
    
    fileprivate var loadMore = true

    @IBOutlet weak var bottomSpinnerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomLoadMoreSpinner: NVActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        setupTableView()
        service.delegate = self
        
        self.setUpBottomActivityIndicator()
        self.getVisitors()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let reveal = self.revealViewController() {
            self.mBtn.target(forAction: #selector(reveal.revealToggle(_:)), withSender: self.revealViewController())
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        if datasource.isEmpty{
            self.active.startAnimating()
        }
        getVisitors()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        self.tableView.addSubview(refreshControl)
        self.navigationItem.title = "Visitors"
       
        self.tableView.register(EmptyCell.nib, forCellReuseIdentifier: EmptyCell.identifier)
    }
    
    func setUpBottomActivityIndicator() {
        
        //Load More Spinner
        self.bottomLoadMoreSpinner.type = .ballScaleMultiple
        self.bottomLoadMoreSpinner.color = .MyScrapGreen
        self.bottomSpinnerViewHeightConstraint.constant = 0

    }

    // MARK :- API For fetching Visitors
    private func getVisitors(){
//        service.getVisitors()
        self.loadMore(pageLoad: 0) { (data) in
            print(data)
        }
    }
    
    
    @objc func handleRefresh(_ sender: UIRefreshControl) {
        self.getVisitors()
    }
    
    // MARK Upating viewrs count
    private func updateViewers(){
        let userId = AuthService.instance.userId
        let api = APIService()
        api.endPoint = Endpoints.UPDATE_VIEWERS_URL
        api.params = "userId=\(userId)&apiKey=\(API_KEY)"
        api.getDataWith { (result) in
            switch result{
            case .Success(_):
                print("Successfully updated viewers")
            case .Error(_):
                print("Error in updating viewers")
            }
        }
    }
    
    fileprivate func refreshTableView(){
        if active.isAnimating{
            active.stopAnimating()
        }
        if refreshControl.isRefreshing{
            refreshControl.endRefreshing()
        }
        NotificationService.instance.visitorsCount = 0
        self.tableView.reloadData()
    }
}


//MARK:- TABLEVIEW DELEGATE AND DATASOURCE

extension VisitorsVC: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewersCell
        let visit = datasource[indexPath.row]
        cell.configCell(visit: visit)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performFriendView(friendId: datasource[indexPath.row].userId)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 93
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if initiallyLoaded && datasource.isEmpty{
            return self.view.frame.height
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: EmptyCell.identifier) as! EmptyCell
        cell.emptyImg.image = #imageLiteral(resourceName: "emptyPeople")
        cell.emptyLabel.text = "No Viewers"
        return cell
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !datasource.isEmpty{
            let currentOffset = scrollView.contentOffset.y
            let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
            let deltaOffset = maximumOffset - currentOffset
            if deltaOffset <= 0 {
                if loadMore{
                    if !bottomLoadMoreSpinner.isAnimating {
                            self.bottomSpinnerViewHeightConstraint.constant = 58
                            self.bottomLoadMoreSpinner.startAnimating()
                    }
                    loadMore = false
                    self.loadMore(pageLoad: datasource.count, completion: { _ in })
                }
            }
        }
    }
    
    private func loadMore(pageLoad: Int, completion: @escaping (Bool) -> () ){
        
        service.getVisitors(pageLoad: "\(pageLoad)"){ (result)  in
        DispatchQueue.main.async {
            
            if self.bottomLoadMoreSpinner.isAnimating {
                self.bottomSpinnerViewHeightConstraint.constant = 0
                self.bottomLoadMoreSpinner.stopAnimating()
            }
            
            switch result{
            case .Error(let _):
                completion(false)
            case .Success(let data):
                //print("Members data count load more",self.dataSource.count)
                var newData = self.datasource + data
                newData.removeDuplicates()
                self.datasource = newData
//                self.tableView.reloadData()
                self.loadMore = true
                print("&&&&&&&&&&& DATA : \(newData.count)")
                self.refreshTableView()
                DispatchQueue.main.async {
                    self.hideActivityIndicator()
                }
                completion(true)
            }
            }
        }
}
}


extension VisitorsVC: VisitorDelegate{
    func DidReceiveData(data: [VisitorItem]) {
//        DispatchQueue.main.async {
//            self.datasource = data
//            self.initiallyLoaded = true
//            self.refreshTableView()
//            self.service.updateVisitors({ (success) in
//                if success{
//                    DispatchQueue.main.async {
//                        NotificationService.instance.visitorsCount = 0
//                    }
//                }
//            })
//        }
    }
    
    func DidReceiveError(error: String) {
        DispatchQueue.main.async {
            self.initiallyLoaded = true
            self.refreshTableView()
        }  
    }
    
    
}






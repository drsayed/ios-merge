//
//  CompanyLikesController.swift
//  myscrap
//
//  Created by MS1 on 2/10/18.
//  Copyright © 2018 MyScrap. All rights reserved.


import UIKit

class LikesController: UITableViewController, FriendControllerDelegate{
    
    private let activityIndicator : UIActivityIndicatorView = {
        let av = UIActivityIndicatorView(style: .gray)
        av.translatesAutoresizingMaskIntoConstraints = false
        av.hidesWhenStopped = true
        return av
    }()
    
    //var videoPostId : String?
    var id : String?
    var cmId : String?
    var viewCountTitle : String?
    var powId : String?
    var followUserId : String?
    var isFollower : Bool!

    private lazy var rf: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControl.Event.valueChanged)
        return refreshControl
    }()
    
    
    lazy var noDataImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "emptysocialactivity")
        return image
    }()
    lazy var noDataLable: UILabel = {


        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "No Follower"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.darkGray
        return label
    }()
    private var isInitialyLoaded = false
    
    var dataSource = [MemberItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        
        setupViews()
        activityIndicator.startAnimating()
        if let id = id { getDataFromAPI(id: id)}
        if let cmId = cmId { getCMDataFromAPI(cmId: cmId)}
        if let powId = powId { getPOWDataFromAPI(powId: powId)}
        //if let videoPostId = videoPostId { getVideoUserViews(id: videoPostId)}
        
        if let userID = followUserId {
            getUserFollowersFromAPI(id: userID, isFollower: isFollower)
        }

    }
    override func viewWillAppear(_ animated: Bool) {
        if let viewTitle  = viewCountTitle
        {
            self.title = viewTitle
        }
        NotificationCenter.default.post(name: Notification.Name("PauseAllVideos"), object: nil)

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewCountTitle =  self.title
        self.title = " "
    }
    @objc func handleRefresh(_ sender: UIRefreshControl){
        if activityIndicator.isAnimating {
            activityIndicator.stopAnimating()
        }
        if let apiId = id {
            getDataFromAPI(id: apiId)
        }
        if let apiId = cmId {
            getCMDataFromAPI(cmId: apiId)
        }
        if let apiId = powId {
            getPOWDataFromAPI(powId: apiId)
        }
        /*if let postId = videoPostId {
            getVideoUserViews(id: postId)
        }*/
    }
    private func addNoDataLable()
    {
        self.noDataLable.removeFromSuperview()
        self.noDataImage.removeFromSuperview()
        self.noDataImage.contentMode = .scaleAspectFit
        if isFollower {
            self.noDataLable.text = "0 Follower"
        }
        else
        {
            self.noDataLable.text = "0 Following"
        }
       
        self.view.addSubview(self.noDataLable)
        self.view.addSubview(self.noDataImage)
        self.noDataLable.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.noDataLable.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        
        let horizontalConstraint = NSLayoutConstraint(item: noDataImage, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
            let verticalConstraint = NSLayoutConstraint(item: noDataImage, attribute: NSLayoutConstraint.Attribute.centerY, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerY, multiplier: 1, constant: -40)
            
        let widthConstraint = NSLayoutConstraint(item: noDataImage, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 100)
            let heightConstraint = NSLayoutConstraint(item: noDataImage, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 60)
            view.addConstraints([horizontalConstraint, verticalConstraint, widthConstraint, heightConstraint])
        
        
        
      //  self.noDataLable.center = self.view.center
    }
    private func setupViews(){
        view.addSubview(activityIndicator)
        
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 30).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        tableView.register(FriendsCell.nib, forCellReuseIdentifier: FriendsCell.identifier)
        tableView.separatorStyle = .none
        tableView.refreshControl = rf
    }
    /*
    //Video View users Lists
    func getVideoUserViews(id: String) {
        LikeService.getViewLists(postId: id) { [weak self](success, error, data) in
            guard let strongSelf = self else { return }
            strongSelf.refreshData(data: data)
        }
    }*/
    //Feed image/txt/image+txt
    func getDataFromAPI(id: String){
        LikeService.getLikes(id: id) { [weak self](success, error, data) in
            guard let strongSelf = self else { return }
            strongSelf.refreshData(data: data)
        }
    }
    //Company of Month
    func getCMDataFromAPI(cmId: String){
        LikeService.getCMLikes(cmId: cmId) { [weak self](success, error, data) in
            guard let strongSelf = self else { return }
            strongSelf.refreshData(data: data)
        }
    }
    //Person of Week
    func getPOWDataFromAPI(powId: String){
        LikeService.getPOWLikes(powId: powId) { [weak self](success, error, data) in
            guard let strongSelf = self else { return }
            strongSelf.refreshData(data: data)
        }
    }
    
    //MARK:- getUserFollowersFrom API
    func getUserFollowersFromAPI(id: String, isFollower: Bool){
        LikeService.getUserFollowers(id: id, isFollowers: isFollower) { [weak self] (success, error, data) in
            guard let strongSelf = self else { return }
            if data?.count == 0
            {
                Run.onMainThread {
                    self!.addNoDataLable()
                }
               
            }
        
            strongSelf.refreshData(data: data)
        }
    }

    func refreshData(data: [MemberItem]?){
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            if strongSelf.activityIndicator.isAnimating { strongSelf.activityIndicator.stopAnimating() }
            if strongSelf.rf.isRefreshing { strongSelf.rf.endRefreshing() }
            strongSelf.isInitialyLoaded = true
            if let datasource = data{
                strongSelf.dataSource = datasource
                print("DS count : \(strongSelf.dataSource.last)")
            }
            strongSelf.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FriendsCell.identifier, for: indexPath) as? FriendsCell else {
            return UITableViewCell()
        }
        cell.viewModel = LikeCellViewModel(member: dataSource[indexPath.item])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewModel = LikeCellViewModel(member: dataSource[indexPath.item])
        performFriendView(friendId: viewModel.id)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 125
    }
}

class VideoViewsVC: LikesController {
    override func getDataFromAPI(id: String) {
        LikeService.getViewLists(postId: id) { [weak self](success, error, data) in
            guard let strongSelf = self else { return }
            strongSelf.refreshData(data: data)
        }
    }
}

class CompanyLikesController: LikesController{
    
    override func getDataFromAPI(id: String) {
        LikeService.getCompanyLikes(id: id) { [weak self] (succes, error, data)  in
            guard let strongSelf = self else { return }
            strongSelf.refreshData(data: data)
        }
    }
}


class EmployeesController: LikesController{
    
    override func getDataFromAPI(id: String) {
        LikeService.getEmployees(id: id) { [weak self](success, error, data) in
            guard let strongSelf = self else { return }
            strongSelf.refreshData(data: data)
        }
    }
}





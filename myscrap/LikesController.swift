//
//  LikesController.swift
//  myscrap
//
//  Created by MS1 on 2/10/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit

class LikesController: UITableViewController, FriendControllerDelegate{
    
    private let activityIndicator : UIActivityIndicatorView = {
        let av = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        av.translatesAutoresizingMaskIntoConstraints = false
        av.hidesWhenStopped = true
        return av
    }()
    
    var id : String?
    
     private lazy var rf: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
        return refreshControl
    }()
    
    private var isInitialyLoaded = false
    
    var dataSource = [MemberItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        activityIndicator.startAnimating()
        if let id = id { getDataFromAPI(id: id)}
    }
    
    @objc func handleRefresh(_ sender: UIRefreshControl){
        if activityIndicator.isAnimating {
            activityIndicator.stopAnimating()
        }
        if let apiId = id {
            getDataFromAPI(id: apiId)
        }
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
    
    func getDataFromAPI(id: String){
        LikeService.getCompanyLikes(id: id) { [weak self] (succes, error, data)  in
            guard let strongSelf = self else { return }
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
        return 77
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





//
//  AddToContactsVC.swift
//  myscrap
//
//  Created by MS1 on 5/19/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

class MembersVC: BaseRevealVC, FriendControllerDelegate, UISearchBarDelegate {
    
    fileprivate enum SearchType: String{
        case FirstName = "First Name"
        case LastName = "Last Name"
        case Topper = "Score"
        case Company = "Company"
        case New = "New"
    }
    
    fileprivate var searchType: SearchType = .Topper {
        didSet{
            refreshTableView()
        }
    }
    
    
    fileprivate var filteredDataSource = [MemberItem]()
    
    fileprivate var dataSource = [MemberItem]()
    fileprivate var service = MemmberModel()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var active: UIActivityIndicatorView!
    

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControl.Event.valueChanged)
        return refreshControl
    }()
    
    @IBOutlet weak var sortBtn:UIBarButtonItem!
    
    var searchText = ""
    var orderBy = ""
    fileprivate var loadMore = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        // Do any additional setup after loading the view.
        if !NotificationService.instance.isMemberAlertNotified{
            let alert = EarnPointAlertView()
            alert.show(animated: true)
        }
        self.title = "Members"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        service.delegate = self
        active.startAnimating()
        self.getmembers()
        self.tableView.addSubview(refreshContol)
        
        tableView.register(MembersCell.nib, forCellReuseIdentifier: MembersCell.identifier)
        
        setupSearchController()
    }
    
    private func setupSearchController(){
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Members"
        searchController.isActive = true
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            // Fallback on earlier versions
            navigationItem.titleView = searchController.searchBar
        }
        definesPresentationContext = true
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.subviews[0].subviews.flatMap { $0 as? UITextField }.first?.tintColor = UIColor.GREEN_PRIMARY
        self.extendedLayoutIncludesOpaqueBars = true
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchText = searchBar.text!
        self.getMembersValues(pageLoad: 0, searchText: self.searchText, orderBy: orderBy,completion: { _ in
            print("Got search DS values :\(self.dataSource.count)")
        })
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchText = ""
        self.getMembersValues(pageLoad: 0, searchText: self.searchText, orderBy: orderBy,completion: { _ in
            print("Got cancel search DS values :\(self.dataSource.count)")
        })
    }
    
    private func refreshTableView(){
        /*if !dataSource.isEmpty{
            switch searchType {
            case .FirstName:
                
                self.dataSource = self.dataSource.sorted(by: { $0.firstName.localizedStandardCompare($1.firstName) == .orderedAscending
                })
            case .LastName:
                
                self.dataSource = self.dataSource.sorted(by: { $0.lastName.localizedStandardCompare($1.lastName) == .orderedAscending
                })
            case .Company:
                
                self.dataSource = self.dataSource.sorted(by: { (a, b) -> Bool in
                    if a.userCompany == "" { return false } else if b.userCompany == "" { return true } else {
                        return a.userCompany.localizedStandardCompare(b.userCompany) == .orderedAscending
                    }
                })
                
            case .Topper:
                
                self.dataSource = self.dataSource.sorted(by: {$0.score.localizedStandardCompare($1.score) == .orderedDescending })
            case .New:
                
                dataSource = dataSource.sorted(by: { $0.joinedDate > $1.joinedDate })
            }
        }*/
        
        if isFiltering(){
            self.searchText = searchController.searchBar.text!.trimmingCharacters(in: .whitespaces)
            filterContentForSearchText(self.searchText)
        } else {
            self.tableView.reloadData()
        }
        
    }
    
    @objc func handleRefresh (_ sender: UIRefreshControl){
        self.getmembers()
    }
    private func getmembers(){
        self.getMembersValues(pageLoad: self.dataSource.count, searchText: self.searchText, orderBy: orderBy,completion: { _ in
            print("Got DS values :\(self.dataSource.count)")
        })
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.post(name: Notification.Name("PauseAllVideos"), object: nil)

        if let reveal = self.revealViewController() {
            self.mBtn.target(forAction: #selector(reveal.revealToggle(_:)), withSender: self.revealViewController())
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    fileprivate var isRefreshControl = false
    
    
    fileprivate lazy var refreshContol : UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return rc
    }()
    
    @objc
    fileprivate func refresh(){
        searchText = ""
        orderBy = ""
        if active.isAnimating { active.stopAnimating() }
        isRefreshControl = true
        self.getMembersValues(pageLoad: 0, searchText: searchText, orderBy: orderBy, completion: {_ in })
    }

    static func storyBoardInstance() -> MembersVC?{
        let st = UIStoryboard.MAIN
        return st.instantiateViewController(withIdentifier: MembersVC.id) as? MembersVC
    }
    
    
    
    private func getMembersValues(pageLoad: Int, searchText: String, orderBy: String, completion: @escaping (Bool) -> () ){
        service.getMembers(pageLoad: "\(pageLoad)", searchText: searchText.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!, orderBy: orderBy) { (result)  in
            DispatchQueue.main.async {
                
                if self.refreshContol.isRefreshing { self.refreshContol.endRefreshing() }
                if self.active.isAnimating { self.active.stopAnimating() }
                if self.isRefreshControl{
                    self.dataSource = [MemberItem]()
                    self.isRefreshControl = false
                }
                switch result{
                case .Error(let _):
                    completion(false)
                case .Success(let data):
                    //print("Members data count",self.dataSource.count)
                    var newData = data
                    newData.removeDuplicates()
                    dump(newData)
                    self.dataSource = newData
                    self.tableView.reloadData()
                    self.loadMore = true
                    print("&&&&&&&&&&& DATA : \(newData.count), \(self.dataSource.count)")
                    self.refreshTableView()
                    DispatchQueue.main.async {
                        self.hideActivityIndicator()
                    }
                    completion(true)
                }
            }
        }
    }
    
    private func loadMore(pageLoad: Int, searchText: String, orderBy: String, completion: @escaping (Bool) -> () ){
        service.getMembers(pageLoad: "\(pageLoad)", searchText: searchText.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!, orderBy: orderBy) { (result)  in
            DispatchQueue.main.async {
                if self.refreshContol.isRefreshing { self.refreshContol.endRefreshing() }
                if self.active.isAnimating { self.active.stopAnimating() }
                if self.isRefreshControl{
                    self.dataSource = [MemberItem]()
                    self.isRefreshControl = false
                }
                switch result{
                case .Error(let _):
                    completion(false)
                case .Success(let data):
                    //print("Members data count load more",self.dataSource.count)
                    var newData = self.dataSource + data
                    newData.removeDuplicates()
                    self.dataSource = newData
                    self.tableView.reloadData()
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !dataSource.isEmpty{
            let currentOffset = scrollView.contentOffset.y
            let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
            let deltaOffset = maximumOffset - currentOffset
            if deltaOffset <= 0 {
                if loadMore{
                    loadMore = false
                    self.loadMore(pageLoad: dataSource.count, searchText: self.searchText, orderBy: self.orderBy, completion: { _ in })
                }
            }
        }
    }
  
// MARK:- Sort button Action
    
    @IBAction func sortClicked(_ sender: UIBarButtonItem) {
        
        let Alert = UIAlertController(title: "Sort By", message: nil, preferredStyle: .actionSheet)
        let toppers = UIAlertAction(title: SearchType.Topper.rawValue, style: .default) { [weak self] (action) in
            //self?.searchType = .Topper
            self?.orderBy = ""
            self?.getMembersValues(pageLoad: 0, searchText: self!.searchText, orderBy: self!.orderBy,completion: { _ in
                
            })
        }
        let fname = UIAlertAction(title: SearchType.FirstName.rawValue, style: .default) { [weak self] (action) in
            //self?.searchType = .FirstName
            self?.orderBy = "first_name"
            self?.getMembersValues(pageLoad: 0, searchText: self!.searchText, orderBy: self!.orderBy,completion: { _ in
                
            })
        }
        let lname = UIAlertAction(title: SearchType.LastName.rawValue, style: .default) { [weak self] (action) in
            //self?.searchType = .LastName
            self?.orderBy = "last_name"
            self?.getMembersValues(pageLoad: 0, searchText: self!.searchText, orderBy: self!.orderBy,completion: { _ in
                
            })
        }
        let Company = UIAlertAction(title: SearchType.Company.rawValue, style: .default) { [weak self] (action) in
            //self?.searchType = .Company
            self?.orderBy = "company"
            self?.getMembersValues(pageLoad: 0, searchText: self!.searchText, orderBy: self!.orderBy,completion: { _ in
                
            })
        }
        let New = UIAlertAction(title: SearchType.New.rawValue, style: .default) { [weak self] (action) in
            //self?.searchType = .New
            self?.orderBy = "newuser"
            self?.getMembersValues(pageLoad: 0, searchText: self!.searchText, orderBy: self!.orderBy,completion: { _ in
                
            })
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        Alert.addAction(toppers)
        Alert.addAction(fname)
        Alert.addAction(lname)
        Alert.addAction(Company)
        Alert.addAction(New)	
        Alert.addAction(cancel)
        Alert.view.tintColor = UIColor.GREEN_PRIMARY
        self.present(Alert, animated: true, completion: nil)
    }
    
    
}

extension MembersVC : MemberDelegate{
    func DidReceivedData(data: [MemberItem]) {
        DispatchQueue.main.async {
            self.dataSource = data
            
            if !NotificationService.instance.isMemberAlertNotified{
                let alert = EarnPointAlertView()
                alert.show(animated: true)
            }
            
            if self.active.isAnimating{ self.active.stopAnimating() }
            if self.refreshControl.isRefreshing { self.refreshControl.endRefreshing() }
            self.tableView.reloadData()
            self.refreshTableView()
        }
    }
    
    func DidReceivedError(error: String) {
        print(error)
        //if self.active.isAnimating{ self.active.stopAnimating() }
        DispatchQueue.main.async {
            self.active.isHidden = true
            
            let alert = UIAlertController(title: "ERROR", message: error, preferredStyle: UIAlertController.Style.alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in
                //Cancel Action
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        
    }
}

extension MembersVC : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering(){
            return filteredDataSource.count
        }
        
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, willDisplay cell: MembersCell, forRowAt indexPath: IndexPath) {
        var item : MemberItem!
        if isFiltering() {
            item = filteredDataSource[indexPath.row]
        } else {
            item = dataSource[indexPath.row]
        }
        if item.followStatusType == 2 {
            cell.followUserButton.semanticContentAttribute = .forceRightToLeft

        }
        else
        {
            cell.followUserButton.semanticContentAttribute = .forceLeftToRight

        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MembersCell.identifier, for: indexPath) as? MembersCell else { return UITableViewCell() }
        var item : MemberItem!
        if isFiltering() {
            item = filteredDataSource[indexPath.row]
        } else {
            item = dataSource[indexPath.row]
        }
        
        cell.delegate = self
        cell.configCell(item: item)
        return cell
    }
}

extension MembersVC : UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 114
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFiltering() {
            performFriendView(friendId: filteredDataSource[indexPath.row].userId)
        } else {
            performFriendView(friendId: dataSource[indexPath.row].userId)
        }
    }
}

extension MembersVC: MemberCellDelegate{
    func favouriteTapped(cell: MembersCell){
        if AuthStatus.instance.isGuest{
            self.showGuestAlert()
        } else {
            if let indexpath = self.tableView.indexPathForRow(at: cell.center){
                let obj = dataSource[indexpath.row]
                let message  = obj.FriendStatus ==  3 ? "Removed From Favourites" : "Added To Favourites"
                showToast(message: message)
                if obj.FriendStatus ==  3 { obj.FriendStatus = 0 } else { obj.FriendStatus = 3 }
                self.tableView.reloadRows(at: [indexpath], with: .none)
                service.postFavourite(friendId: obj.userId)
            }
        }
    }
    

    func followersBtnTapped(cell: MembersCell) {
        
        if AuthStatus.instance.isGuest{
              self.showGuestAlert()
          } else {
            if let indexpath = self.tableView.indexPathForRow(at: cell.center){
                let obj = dataSource[indexpath.row]
                if obj.followStatusType == 2 {
                   
                    
                    if let vc = UnFollowPopUpVC.storyBoardInstance(){
                        vc.friendName = obj.name
                        vc.modalPresentationStyle = .overFullScreen
                        vc.delegateUnfollow = self
                        vc.indexValue = indexpath.row
                        vc.friendID = obj.userId
                        self.present(vc, animated: true, completion: nil)
                    }
                    
                    let alertConroller = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
               
                    let changePassWordAction = UIAlertAction(title: "Unfollow \(obj.name)", style: .destructive) {[weak self] _ in
                        
                        obj.followStatusType = 0
                        self!.service.sendUnFollowRequest(friendId: obj.userId)
//                        let message = "Started Following" //"Successfully started following"
//                        showToast(message: message)
                        self!.tableView.reloadRows(at: [indexpath], with: .none)
                    }
                    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    alertConroller.view.tintColor = UIColor.GREEN_PRIMARY
                   // alertConroller.addAction(editProfileAction)
                    alertConroller.addAction(changePassWordAction)
                    alertConroller.addAction(cancelAction)
                    present(alertConroller, animated: true, completion: nil)
                        

                    
                }
                else
                {
                    if obj.followStatusType == 0 {
                        
                        obj.followStatusType = 2
                        service.sendFollowRequest(friendId: obj.userId)
                        let message = "Started Following" //"Successfully started following"
                        showToast(message: message)
                        self.tableView.reloadRows(at: [indexpath], with: .none)
                    }
                }
                
                
               
                
            }
        }
    }
}

extension MembersVC: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        searchText = searchController.searchBar.text!
        filterContentForSearchText(searchText)
    }
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        //self.getMembersValues(pageLoad: 0, searchText: searchText, orderBy: orderBy) { _ in
            self.filteredDataSource = self.dataSource.filter({( member : MemberItem) -> Bool in
                return member.name.lowercased().contains(searchText.lowercased())
            })
            self.tableView.reloadData()
        //}
        
    }
    
}
extension MembersVC: UnFollowDelegate{
  

    func UnFollowPressed(FriendID: String, AtIndex: Int) {
        let indexpath = IndexPath(item: AtIndex, section: 0);
        let obj = dataSource[indexpath.item]
        obj.followStatusType = 0
        self.service.sendUnFollowRequest(friendId: obj.userId)
//                        let message = "Started Following" //"Successfully started following"
//                        showToast(message: message)
        self.tableView.reloadRows(at: [indexpath], with: .none)
    }
    
   
}


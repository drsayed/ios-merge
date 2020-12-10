//
//  MemberSearchController.swift
//  myscrap
//
//  Created by MyScrap on 5/20/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit

struct MemberViewModel {
    
    let userId: String
    let name : String
    let jid: String
    let profilePic: String
    let colorCode: String
    let designation: String
    
}

class MemberSearchController: UIViewController, UISearchBarDelegate {
    
    let activityIndicator : UIActivityIndicatorView = {
        let av = UIActivityIndicatorView(frame: .zero)
        av.translatesAutoresizingMaskIntoConstraints = false
        av.style = .gray
        av.hidesWhenStopped = true
        return av
    }()
    
    var searchText = ""
    var orderBy = ""
    fileprivate var loadMore = true
    
    let operation = MemberOperation()

    var searchController = UISearchController(searchResultsController: nil)
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.delegate = self
        tv.dataSource = self
        tv.register(RecentChatCell.Nib, forCellReuseIdentifier: RecentChatCell.identifier)
//        tv.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tv
    }()
    
    
    var dataSource = [MemberItem]()
    
    var filteredDataSource = [MemberItem]()
    fileprivate var service = MemmberModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        title = "Members"
        setupSearchController()
        setupViews()
        //setupData()
//        fetchMembersFromRemote()
        self.getmembers()
    }
    
    private func getmembers(){
        self.getMembersValues(pageLoad: self.dataSource.count, searchText: self.searchText, orderBy: orderBy,completion: { _ in
            print("Got DS values :\(self.dataSource.count)")
        })
    }
    
    private func getMembersValues(pageLoad: Int, searchText: String, orderBy: String, completion: @escaping (Bool) -> () ){
        service.getMembers(pageLoad: "\(pageLoad)", searchText: searchText, orderBy: orderBy) { (result)  in
            DispatchQueue.main.async {
                
                switch result{
                case .Error(let _):
                    completion(false)
                case .Success(let data):
                    //print("Members data count",self.dataSource.count)
                    var newData = data
                    newData.removeDuplicates()
                    //dump(newData)
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
        service.getMembers(pageLoad: "\(pageLoad)", searchText: searchText, orderBy: orderBy) { (result)  in
            DispatchQueue.main.async {
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
    
    private func fetchMembersFromRemote(){
        operation.fetchMembersFromRemote()
    }
    
    private func setupViews(){
        view.addSubview(tableView)
        tableView.anchor(leading: view.safeLeading, trailing: view.safeTrailing, top: view.safeTop, bottom: view.safeBottom)
        
        view.addSubview(activityIndicator)
        activityIndicator.anchor(leading: nil, trailing: nil, top: view.safeTop, bottom: nil, padding:  UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0), size: CGSize(width: 30, height: 30))
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        
        
    }
    
    /*private func setupData(){
        
        let app = UIApplication.shared.delegate as! AppDelegate
        let moc = app.persistentContainer.viewContext
        var viewModel = [MemberViewModel]()
        if let members = operation.fetchMembers(with: moc){
            print(members.count)
            for member in members{
                if let name = member.name,
                    let jid = member.jid,
                    jid != AuthService.instance.userJID,
                    let id = member.id,
                    let designation = member.designation{
                    viewModel.append(MemberViewModel(userId: id, name: name, jid: jid, profilePic: member.profileImage, colorCode: member.cCode, designation: designation ))
                }
                
            }
        }
        
        self.dataSource = viewModel.sorted(by: { $0.name.localizedStandardCompare($1.name) == .orderedAscending })
        
        if dataSource.isEmpty{
            activityIndicator.startAnimating()
        }
        
        self.tableView.reloadData()
        
    }*/
    
    private func setupSearchController(){
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Members"
        searchController.isActive = true
        searchController.delegate = self
        searchController.searchBar.delegate = self
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
        self.getMembersValues(pageLoad: 0, searchText: self.searchText, orderBy: "") { (result) in
            print("Got search results :\(self.dataSource.count)")
            self.tableView.isHidden = false
        }
        /*self.getCompanyValues(pageLoad: 0, searchText: self.searchText, order: self.countryFilter,completion: { _ in
            print("Got search results :\(self.dataSource.count)")
        })*/
    }
    
    /*func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchText = ""
        self.getMembersValues(pageLoad: 0, searchText: self.searchText, orderBy: "",completion: { _ in
            print("Got cancel search DS values :\(self.dataSource.count)")
        })
    }*/
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchController.isActive = true
        DispatchQueue.main.async {
            self.searchController.searchBar.becomeFirstResponder()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(forName: Notification.Name.memberCorDataUpdated, object: nil, queue: nil) { (notif) in
            //self.setupData()
            if self.activityIndicator.isAnimating{
                self.activityIndicator.stopAnimating()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.memberCorDataUpdated, object: nil)
    }
    private func refreshTableView(){
        /*if !mainDataSource.isEmpty{
         var dataDict =  [String: [CompanyItem]]()
         var secTitles = [String]()
         switch searchType {
         case .Name:
         self.dataSource = self.mainDataSource.sorted(by: { $0.name.localizedStandardCompare($1.name) == .orderedAscending
         })
         
         for data in dataSource{
         let key = String(data.name.prefix(1))
         if var values = dataDict[key]{
         values.append(data)
         dataDict[key] = values
         } else {
         dataDict[key] = [data]
         }
         }
         secTitles = [String](dataDict.keys)
         secTitles = secTitles.sorted(by: { $0 < $1})
         dataDictionary = dataDict
         sectionTitles = secTitles
         case .Country:
         self.dataSource = self.mainDataSource.sorted(by: { $0.country.localizedStandardCompare($1.country) == .orderedAscending
         })
         }
         }*/
        if isFiltering(){
            self.searchText = searchController.searchBar.text!.trimmingCharacters(in: .whitespaces)
            filterContentForSearchText(self.searchText)
        } else {
            self.tableView.reloadData()
        }
    }
}


extension MemberSearchController: UISearchResultsUpdating, UISearchControllerDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredDataSource = dataSource.filter({( member : MemberItem) -> Bool in
            return member.name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    func presentSearchController(_ searchController: UISearchController) {
        self.searchController.searchBar.becomeFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            print("UISearchBar.text cleared!")
            self.searchText = searchText
            self.getMembersValues(pageLoad: 0, searchText: self.searchText, orderBy: "") { (result) in
                print("Got search results :\(self.dataSource.count)")
                self.tableView.isHidden = false
            }
        }
    }
}

extension MemberSearchController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering(){
            return filteredDataSource.count
        }
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 76
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecentChatCell.identifier, for: indexPath) as! RecentChatCell
//        let mem = dataSource[indexPath.item]
//        cell.textLabel?.text = "\(mem.name) \(mem.designation)"
        var mem : MemberItem
        if isFiltering(){
            mem = filteredDataSource[indexPath.item]
        } else{
            mem = dataSource[indexPath.item]
        }
        
        cell.memberItem = mem
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var member : MemberItem
        if isFiltering(){
            member = filteredDataSource[indexPath.item]
        } else{
            member = dataSource[indexPath.item]
        }
        performConversationVC(friendId: member.userId, profileName: member.name, colorCode: member.colorCode, profileImage: member.profilePic, jid: member.jId, listingId: "", listingTitle: "", listingType: "", listingImg: "")
    }
    
}










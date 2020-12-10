//
//  CompaniesVC.swift
//  myscrap
//
//  Created by MS1 on 7/8/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

class CompaniesVC: BaseRevealVC,UITableViewDelegate,UITableViewDataSource, UISearchBarDelegate {
    fileprivate enum SearchType{
        case Name
        case Country
    }
    
    fileprivate var searchType: SearchType = .Name {
        didSet{
            refreshTableView()
        }
    }
    
    let searchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var active:UIActivityIndicatorView!
    
    
    fileprivate var countryDataSource = [CountryItem]()
    fileprivate var dataSource = [CompanyItem]()
    fileprivate var filteredDataSource = [CompanyItem]()
    
    var dataDictionary =  [String: [CompanyItem]]()
    var sectionTitles = [String]()
    
    var companyOperation:BlockOperation?
    fileprivate var loadMore = true
    var searchText = ""
    var countryFilter = ""
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        setupTableView()
        setupSearchController()
        active.startAnimating()
        getCompany()
    }
    
    fileprivate var isRefreshControl = false
    
    
    fileprivate lazy var refreshContol : UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return rc
    }()
    
    @objc
    fileprivate func handleRefresh(){
        searchText = ""
        countryFilter = ""
        if active.isAnimating { active.stopAnimating() }
        isRefreshControl = true
        getCompanyValues(pageLoad: 0, searchText: searchText, countryFilter: "", completion: {_ in })
    }
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.estimatedRowHeight = 89
        self.tableView.rowHeight = UITableView.automaticDimension
        tableView.register(CompaniesCell.nib, forCellReuseIdentifier: CompaniesCell.identifier)
        tableView.sectionIndexColor = UIColor.GREEN_PRIMARY
        tableView.sectionIndexTrackingBackgroundColor = UIColor.lightGray
        tableView.sectionIndexBackgroundColor = UIColor.lightGray
    }
    
    private func setupSearchController(){
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Companies"
        
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
        self.getCompanyValues(pageLoad: 0, searchText: self.searchText, countryFilter: self.countryFilter,completion: { _ in
            print("Got search results :\(self.dataSource.count)")
        })
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchText = ""
        self.filteredDataSource = []
        self.dataSource = []
        self.getCompanyValues(pageLoad: 0, searchText: self.searchText, countryFilter: self.countryFilter,completion: { _ in
            print("Got search results :\(self.dataSource.count)")
            
        })
    }
    
    let apiClient = CompanyService()
    
    private func getCompany(){
        
        self.getCompanyValues(pageLoad: self.dataSource.count, searchText: self.searchText, countryFilter: self.countryFilter,completion: { _ in
            print("Got DS values :\(self.dataSource.count)")
        })
        
        /*apiClient.fetchCompanies { dataSource, error in
            DispatchQueue.main.async {
                if self.active.isAnimating {
                    self.active.stopAnimating()
                }
                guard let data = dataSource else { return }
                self.mainDataSource = data
                self.searchType = .Name
            }
        }*/
    }
    
    private func getCompanyValues(pageLoad: Int, searchText: String, countryFilter: String, completion: @escaping (Bool) -> () ){
        apiClient.getAllCompanies(pageLoad: "\(pageLoad)", searchText: searchText.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!, countryFilter: countryFilter) { (result)  in
            DispatchQueue.main.async {
                if self.refreshContol.isRefreshing { self.refreshContol.endRefreshing() }
                if self.active.isAnimating { self.active.stopAnimating() }
                if self.isRefreshControl{
                    //dump([CompanyItem]())
                    self.dataSource = [CompanyItem]()
                    self.isRefreshControl = false
                }
                switch result{
                case .Error(let _):
                    completion(false)
                case .Success(let data):
                    print("Company data count ",self.dataSource.count)
                    var newData = self.dataSource + data
                    newData.removeDuplicates()
                    self.dataSource = newData
                    print("&&&&&&&&&&& DATA : \(newData.count)")
                    self.tableView.reloadData()
                    self.loadMore = true
                    //self.refreshTableView()
                    DispatchQueue.main.async {
                        self.hideActivityIndicator()
                    }
                    completion(true)
                }
            }
        }
    }
    
    private func getCompaniesMore(pageLoad: Int, searchText: String, countryFilter: String, completion: @escaping (Bool) -> () ){
        apiClient.getAllCompanies(pageLoad: "\(pageLoad)", searchText: searchText.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!, countryFilter: countryFilter) { (result)  in
            DispatchQueue.main.async {
                if self.refreshContol.isRefreshing { self.refreshContol.endRefreshing() }
                if self.active.isAnimating { self.active.stopAnimating() }
                if self.isRefreshControl{
                    self.dataSource = [CompanyItem]()
                    self.isRefreshControl = false
                }
                switch result{
                case .Error(let _):
                    completion(false)
                case .Success(let data):
                    if self.isFiltering(){
                        print("Company data count load more while searching...",self.filteredDataSource.count)
                        var newData = self.filteredDataSource + data
                        //newData.removeDuplicates()
                        self.filteredDataSource = newData
                        print("&&&&&&&&&&& DATA : \(newData.count)")
                    } else {
                        print("Company data count load more",self.dataSource.count)
                        var newData = self.dataSource + data
                        //newData.removeDuplicates()
                        self.dataSource = newData
                        print("&&&&&&&&&&& DATA : \(newData.count)")
                    }
                    self.tableView.reloadData()
                    self.loadMore = true
                    
                    //self.refreshTableView()
                    DispatchQueue.main.async {
                        self.hideActivityIndicator()
                    }
                    completion(true)
                }
            }
        }
    }
    
    func getFilteredCountry(pageLoad: Int, searchText: String, countryFilter: String, completion: @escaping (Bool) -> () ) {
        apiClient.getAllCompanies(pageLoad: "\(pageLoad)", searchText: searchText.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!, countryFilter: countryFilter) { (result)  in
            DispatchQueue.main.async {
                if self.refreshContol.isRefreshing { self.refreshContol.endRefreshing() }
                if self.active.isAnimating { self.active.stopAnimating() }
                if self.isRefreshControl{
                    self.dataSource = [CompanyItem]()
                    self.isRefreshControl = false
                }
                switch result{
                case .Error(let _):
                    completion(false)
                case .Success(let data):
                    print("country filter data count",self.dataSource.count)
                    let newData = data
                    self.dataSource = newData
                    print("&&&&&&&&&&& DATA : \(newData.count)")
                    /*if self.isFiltering(){
                        print("Company data count load more while searching...",self.filteredDataSource.count)
                        var newData = self.filteredDataSource + data
                        newData.removeDuplicates()
                        self.filteredDataSource = newData
                        print("&&&&&&&&&&& DATA : \(newData.count)")
                    } else {
                        print("Company data count load more",self.dataSource.count)
                        var newData = self.dataSource + data
                        newData.removeDuplicates()
                        self.dataSource = newData
                        print("&&&&&&&&&&& DATA : \(newData.count)")
                    }*/
                    self.tableView.reloadData()
                    //self.refreshTableView()
                    DispatchQueue.main.async {
                        self.hideActivityIndicator()
                    }
                    completion(true)
                }
            }
        }
    }
    
    func getCountryLists() {
        apiClient.getAllCountry(pageLoad: "0", searchText: searchText.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!, countryFilter: countryFilter) { (result)  in
            DispatchQueue.main.async {
                if self.refreshContol.isRefreshing { self.refreshContol.endRefreshing() }
                if self.active.isAnimating { self.active.stopAnimating() }
                if self.isRefreshControl{
                    self.countryDataSource = [CountryItem]()
                    self.isRefreshControl = false
                }
                switch result{
                case .Error(let _):
                    print("Country fetch error")
                case .Success(let data):
                    print("Company data count",self.countryDataSource.count)
                    
                    let newData = data
                    //newData.removeDuplicates()
                    
                    self.countryDataSource = newData
                    self.tableView.reloadData()
                    
                    print("&&&&&&&&&&& DATA : \(newData.count), \(self.dataSource.count)")
                    //self.refreshTableView()
                    DispatchQueue.main.async {
                        self.hideActivityIndicator()
                    }
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isFiltering(){
            return 1
        } else{
            /*if searchType == .Name {
                return sectionTitles.count
            } else {
                return 1
            }*/
            return 1
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isFiltering(){
            return nil
        } else {
            /*if searchType == .Name{
                return sectionTitles[section]
            }*/
            return nil
        }
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if isFiltering(){
            return nil
        } else {
            /*if searchType == .Name{
                return sectionTitles
            }*/
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering(){
            if filteredDataSource.count != 0 {
                return filteredDataSource.count
            } else {
                return 0
            }
        } else {
            /*if searchType == .Name{
                let key = sectionTitles[section]
                if let values = dataDictionary[key]{
                    return values.count
                }
                return 0
            } else {
                return dataSource.count
            }*/
            return dataSource.count
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CompaniesCell.identifier, for: indexPath) as! CompaniesCell
        if filteredDataSource.count != 0 {
            if isFiltering(){
                cell.configCell(company: filteredDataSource[indexPath.row])
                if cell.nameLbl.text == "" {
                    print("Company name is empty")
                }
                 return cell
            } else {
                if self.searchText != "" {
                    self.getCompany()
                } else {
                    cell.configCell(company: dataSource[indexPath.row])
                }
                /*if searchType == .Name{
                    let key = sectionTitles[indexPath.section]
                    if let values = dataDictionary[key]{
                        cell.configCell(company: values[indexPath.row])
                    }
                } else {
                    cell.configCell(company: dataSource[indexPath.row])
                }*/
                 return cell
            }
            
        } else if dataSource.count != 0 {
            if isFiltering(){
                if filteredDataSource.count != 0 {
                    cell.configCell(company: filteredDataSource[indexPath.row])
                    if cell.nameLbl.text == "" {
                        print("Company name is empty")
                    }
                     
                } else {
                    print("Filetered data is empty")
                }
                return cell
            } else {
                if self.searchText != "" {
                    self.getCompany()
                } else {
                    cell.configCell(company: dataSource[indexPath.row])
                }
                /*if searchType == .Name{
                    let key = sectionTitles[indexPath.section]
                    if let values = dataDictionary[key]{
                        cell.configCell(company: values[indexPath.row])
                    }
                } else {
                    cell.configCell(company: dataSource[indexPath.row])
                }*/
                 return cell
            }
        }
        else {
            tableView.reloadData()
            return UITableViewCell()
        }
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        var company : CompanyItem?
        if isFiltering(){
            company = self.filteredDataSource[indexPath.row]
        } else {
            /*if searchType == .Name{
                let key = sectionTitles[indexPath.section]
                if let values = dataDictionary[key]{
                    company = values[indexPath.row]
                }
            } else {
                company = dataSource[indexPath.row]
            }*/
            company = dataSource[indexPath.row]
        }
        /*if  let vc = CompanyProfileVC.storyBoardInstance(), let id = company?.id{
            vc.companyId = id
            self.navigationController?.pushViewController(vc, animated: true)
        }*/
        /*
        if  let vc = CompanyDetailVC.storyBoardInstance() {
            vc.title = company?.name
            vc.companyId = company?.id
            UserDefaults.standard.set(vc.title, forKey: "companyName")
            UserDefaults.standard.set(vc.companyId, forKey: "companyId")
            self.navigationController?.pushViewController(vc, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true) */
        
        if  let vc = CompanyHeaderModuleVC.storyBoardInstance() {
            vc.title = company?.name
            vc.companyId = company?.id
            UserDefaults.standard.set(vc.title, forKey: "companyName")
            UserDefaults.standard.set(vc.companyId, forKey: "companyId")
            self.navigationController?.pushViewController(vc, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)

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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !dataSource.isEmpty || !filteredDataSource.isEmpty{
            tableView.keyboardDismissMode = .onDrag
            let currentOffset = scrollView.contentOffset.y
            let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
            let deltaOffset = maximumOffset - currentOffset
            if deltaOffset <= 0 {
                if loadMore{
                    loadMore = false
                    if isFiltering() {
                        self.getCompaniesMore(pageLoad: filteredDataSource.count, searchText: self.searchText.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!, countryFilter: self.countryFilter,completion: { _ in })
                    } else {
                        self.getCompaniesMore(pageLoad: dataSource.count, searchText: self.searchText.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!, countryFilter: self.countryFilter,completion: { _ in })
                    }
                    
                }
            }
        }
    }
    
    @IBAction func sortClicked(_ sender: UIBarButtonItem){
        if self.countryDataSource.isEmpty {
            self.getCountryLists()
        }
        
        let Alert = UIAlertController(title: "Sort By", message: nil, preferredStyle: .actionSheet)
        let name = UIAlertAction(title: "Name", style: .default) { [weak self] (action) in
            self!.searchText = ""
            self!.countryFilter = ""
            self?.getCompanyValues(pageLoad: 0, searchText: self!.searchText.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!, countryFilter: self!.countryFilter,completion: { _ in
                print("Got DS values :\(self!.dataSource.count)")
            })
        }
        let country = UIAlertAction(title: "Country", style: .default) { [unowned self] (action) in
            
            /*self.searchType = .Country
            if !self.countryDataSource.isEmpty{
                
                var dataDict =  [String: [CountryItem]]()
                var titles = [String]()

                for data in self.countryDataSource{
                    let key = data.countryName
                    let count = data.totalCompany
                    if var values = dataDict[key]{
                        values.append(data)
                        dataDict[key] = values
                    } else {
                        dataDict[key] = [data]
                    }
                }
                titles = [String](dataDict.keys)
                titles = titles.sorted(by: { $0 < $1})
                
                
                let alert = CompanyFilterAlertView(titleData: titles, data: dataDict)
                alert.delegate = self
                alert.show(animated: false)
                
            }*/
            print("Country Lists :\(self.countryDataSource.count)")
            let alert = CompanyFilterAlertView(country: self.countryDataSource)
            alert.delegate = self
            alert.show(animated: false)
            
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        Alert.addAction(name)
        Alert.addAction(country)
        Alert.addAction(cancel)
        Alert.view.tintColor = UIColor.GREEN_PRIMARY
        self.present(Alert, animated: true, completion: nil)
    }
}

extension CompaniesVC: CompanyFilterAlertDelegate{
    func didFilterCompanies(countryID: String) {
        self.searchText = ""
        self.countryFilter = countryID
        self.getFilteredCountry(pageLoad: 0, searchText: searchText, countryFilter: countryFilter, completion: { _ in })
        //self.dataSource = companies
        tableView.reloadData()
    }
}


extension CompaniesVC: UISearchResultsUpdating{
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
        self.getCompanyValues(pageLoad: 0, searchText: searchText.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!, countryFilter: countryFilter) { _ in
            print("Filtered values")
            self.filteredDataSource = self.dataSource.filter({( company : CompanyItem) -> Bool in
                return company.name.lowercased().contains(searchText.lowercased())
            })
            self.tableView.reloadData()
        }
    }
}







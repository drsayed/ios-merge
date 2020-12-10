

import UIKit

class AddListOriginListController : UIViewController {
    
    typealias portListSelection = (PortList, AddListOriginListController) -> ()
    
    var selection: portListSelection?
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    let searchController = CustomSearchController(searchResultsController: nil)
    
    var dataSource : [PortList] = [] {
        didSet{
            tableView.reloadData()
        }
    }
    
    var filteredDataSource: [PortList] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        self.view.backgroundColor = UIColor.white
        if let data = PortList.getportList(){
            self.dataSource = data
        }
        setupViews()
        setupSearchController()
        title = "Port List"
        tableView.register(PortListCell.self)
        
    }
    
    private func setupViews(){
        setupCancelButton()
        view.addSubview(tableView)
        tableView.anchor(leading: view.safeLeading, trailing: view.safeTrailing, top: view.safeTop, bottom: view.safeBottom)
    }
    
    
    func setupSearchController(){
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.showsCancelButton = false
        searchController.hidesNavigationBarDuringPresentation = false
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
    
    private func setupCancelButton(){
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelPressed))
        self.navigationItem.rightBarButtonItem = cancelButton
    }
    
}


//MARK:- ACTIONS
extension AddListOriginListController{
    @objc
    func cancelPressed(){
        searchController.isActive = false
        self.dismiss(animated: true, completion: nil)
    }
}


extension AddListOriginListController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var item : PortList
        
        if isFiltering(){
            item = filteredDataSource[indexPath.row]
        } else {
            item = dataSource[indexPath.row]
        }
//        cancelPressed()
        selection?(item, self)
        
        
    }
    
}

extension AddListOriginListController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering(){
            return filteredDataSource.count
        }
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : PortListCell = tableView.dequeReusableCell(forIndexPath: indexPath)
        var item : PortList
        if isFiltering(){
            item = filteredDataSource[indexPath.row]
        } else {
            item = dataSource[indexPath.row]
        }
        cell.item = item
        return cell
    }
}


extension AddListOriginListController: UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate{
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
        filteredDataSource = dataSource.filter({( port : PortList) -> Bool in
            return port.country.lowercased().hasPrefix(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    func presentSearchController(_ searchController: UISearchController) {
        self.searchController.searchBar.becomeFirstResponder()
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        searchController.searchBar.showsCancelButton = false
    }
}

class PortListCell: UITableViewCell{
    
    var item: PortList! {
        didSet{
            imageView?.image = UIImage(named: item.flagcode) ?? nil
            textLabel?.text = item.country
            if textLabel?.text == "Uae" {
                textLabel?.text = item.country.uppercased()
            } else {
                textLabel?.text = item.country
            }
            
            
        }
    }
    
    
}


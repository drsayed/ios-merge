

import UIKit

class ISRISearchController : UIViewController {
    
    typealias IsriSelection = (ISRI) -> ()
    
    var selection: IsriSelection?
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    lazy var searchController: CustomSearchController = { [unowned self] in
        let sc = CustomSearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.placeholder = "Search"
        sc.searchBar.showsCancelButton = false
        sc.hidesNavigationBarDuringPresentation = false
        sc.searchBar.tintColor = UIColor.white
        sc.searchBar.subviews[0].subviews.flatMap { $0 as? UITextField }.first?.tintColor = UIColor.GREEN_PRIMARY
        return sc
        }()
    
    var dataSource : [ISRI] = [] {
        didSet{
            tableView.reloadData()
        }
    }
    
    var filteredDataSource: [ISRI] = []
    
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
        if let data = ISRI.loadJson(){
            dataSource = data
        }
        setupViews()
        setupSearchController()
        title = "ISRI"
    }
    
    private func setupViews(){
        setupCancelButton()
        view.addSubview(tableView)
        tableView.anchor(leading: view.safeLeading, trailing: view.safeTrailing, top: view.safeTop, bottom: view.safeBottom)
    }
    
    
    func setupSearchController(){
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            // Fallback on earlier versions
            navigationItem.titleView = searchController.searchBar
        }
        definesPresentationContext = true
        
        self.extendedLayoutIncludesOpaqueBars = true
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    private func setupCancelButton(){
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelPressed))
        self.navigationItem.rightBarButtonItem = cancelButton
    }
    
}


//MARK:- ACTIONS
extension ISRISearchController{
    @objc
    func cancelPressed(){
        searchController.isActive = false
        self.dismiss(animated: true, completion: nil)
    }
}


extension ISRISearchController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFiltering(){
            selection?(filteredDataSource[indexPath.item])
        } else {
            selection?(dataSource[indexPath.item])
        }
        cancelPressed()
    }
    
}

extension ISRISearchController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering(){
            return filteredDataSource.count
        }
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if isFiltering(){
            cell.textLabel?.text = filteredDataSource[indexPath.item].name
        } else {
            cell.textLabel?.text = dataSource[indexPath.item].name
        }
        return cell
    }
}


extension ISRISearchController: UISearchResultsUpdating, UISearchControllerDelegate, UISearchBarDelegate{
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
        filteredDataSource = dataSource.filter({( isri : ISRI) -> Bool in
            return isri.name.lowercased().hasPrefix(searchText.lowercased())
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






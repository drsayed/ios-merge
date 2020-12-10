//
//  GuestListVC.swift
//  myscrap
//
//  Created by MS1 on 1/22/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit

class GuestListVC: BaseVC, UIScrollViewDelegate , MenuBarDelegate  {
    
    var eventId: String = ""
    
    fileprivate var goingVC: GoingVc?
    fileprivate var intrestedVC: InterestedVC?
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    private lazy var menuBar : TopMenuBar = {
        let topBar = TopMenuBar(frame: .zero)
        topBar.translatesAutoresizingMaskIntoConstraints = false
        topBar.titleArray = ["GOING", "INTERESTED" ]
        topBar.menuBarDelegate = self
        topBar.collectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: [])
        return topBar
    }()
    
    var isInterested = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        self.navigationController?.delegate = self
        setupViews()
        
        
        print(eventId)
        
        
        guard let gvc = children.first as? GoingVc else {
            fatalError("Missing Going VC")
        }
        guard let interest = children.last as? InterestedVC else {
            fatalError("Missing Going VC")
        }
        
        goingVC = gvc
        goingVC?.eventId = eventId
        goingVC?.getMembers(id: eventId)
        
        intrestedVC = interest
        intrestedVC?.eventId = eventId
        intrestedVC?.getMembers(id: eventId)
    }
    
    
    
    private func setupViews(){
        view.backgroundColor = UIColor.white
        scrollView.delegate = self
        title = "Events"
        setupTopBar()
    }
    
    private func setupTopBar(){
        
        view.addSubview(menuBar)
        if #available(iOS 11.0, *) {
            let layout = view.safeAreaLayoutGuide
            menuBar.topAnchor.constraint(equalTo: layout.topAnchor).isActive = true
            menuBar.leftAnchor.constraint(equalTo: layout.leftAnchor).isActive = true
            menuBar.rightAnchor.constraint(equalTo: layout.rightAnchor).isActive = true
        } else {
            // Fallback on earlier versions
            menuBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
            menuBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            menuBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        }
        menuBar.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    static func storyBoardInstance() -> GuestListVC? {
        let st = UIStoryboard.calendar
        return st.instantiateViewController(withIdentifier: self.id) as? GuestListVC
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == self.scrollView else { return }
        menuBar.widthSpacing = scrollView.contentOffset.x / 2
    }
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard scrollView == self.scrollView else { return }
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
    }
    
    func scrollToIndex(_ index: Int) {
        let point = CGPoint(x: CGFloat(index) * scrollView.frame.size.width, y: 0)
        self.scrollView.setContentOffset(point, animated: true)
    }
}

extension GuestListVC: UINavigationControllerDelegate{
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if isInterested{
            isInterested = false
            scrollToIndex(1)
            menuBar.collectionView.selectItem(at: IndexPath(row: 1, section: 0), animated: true, scrollPosition: [])
        }
    }
}



class GoingVc: BaseVC{
    
    var eventId: String = ""
    
    fileprivate var dataSource = [MemberItem]()
    fileprivate var service = MemmberModel()
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControl.Event.valueChanged)
        return refreshControl
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView()
        ai.style = .gray
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.hidesWhenStopped = true
        return ai
    }()
    
    lazy var tableView: UITableView = { [unowned self] in
        let tv = UITableView(frame: .zero, style: .plain)
        tv.delegate = self
        tv.dataSource = self
        tv.separatorStyle = .none
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.refreshControl = refreshControl
        tv.register(MembersCell.nib, forCellReuseIdentifier: MembersCell.identifier)
        return tv
    }()
    
    func setupViews(){
        
        view.addSubview(tableView)
        
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 20).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        setupViews()
        activityIndicator.startAnimating()
        view.backgroundColor = UIColor.white
        
    }
    
    @objc private func handleRefresh(_ sender: UIRefreshControl){
        if activityIndicator.isAnimating{
            activityIndicator.stopAnimating()
        }
        getMembers(id: eventId)
    }
    
    func getMembers(id: String){
        service.getEventGoing(eventId: id) {data in
            DispatchQueue.main.async {
                if self.refreshControl.isRefreshing{
                    self.refreshControl.endRefreshing()
                }
                if self.activityIndicator.isAnimating {
                    self.activityIndicator.stopAnimating()
                }
                if let source = data {
                    self.dataSource = source
                }
                self.tableView.reloadData()
            }
        }
    }
    
}

extension GoingVc: UITableViewDelegate, UITableViewDataSource, FriendControllerDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MembersCell.identifier, for: indexPath) as? MembersCell else { return UITableViewCell() }
        let item = dataSource[indexPath.row]
        cell.configCell(item: item)
        cell.starBtn.isHidden = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 114
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = dataSource[indexPath.item]
        performFriendView(friendId: item.userId)
    }
    
}



class InterestedVC: GoingVc{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        view.backgroundColor = UIColor.white
    }
    
    override func getMembers(id: String) {
        service.getEventInterested(eventId: id) { data in
            DispatchQueue.main.async {
                if self.refreshControl.isRefreshing{
                    self.refreshControl.endRefreshing()
                }
                if self.activityIndicator.isAnimating {
                    self.activityIndicator.stopAnimating()
                }
                if let source = data {
                    self.dataSource = source
                }
                self.tableView.reloadData()
            }
        }
    }
    
}

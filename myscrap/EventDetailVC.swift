//
//  EventDetailVC.swift
//  myscrap
//
//  Created by MS1 on 1/8/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import Foundation

class EventDetailVC: BaseVC, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    let sectionHeight:CGFloat = 120
    
    var eventId: String?
    
    fileprivate var eventItem: EventItem?

    fileprivate var menuView: CalendarMenuView!
    
    enum CellType: Int{
        case about = 0
        case discussion = 1
    }
    
    var cellType: CellType = .about {
        didSet{
            collectionView.reloadData()
        }
    }
    
    fileprivate var dataSource = [FeedItem]()
    
    
    fileprivate let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView()
        ai.style = .gray
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.hidesWhenStopped = true
        return ai
    }()
    
    lazy var refreshControl: UIRefreshControl = {
        let rf = UIRefreshControl(frame: .zero)
        rf.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return rf
    }()
    
    lazy var collectionView: UICollectionView = { [unowned self] in
        let layout = UICollectionViewFlowLayout()
        layout.sectionHeadersPinToVisibleBounds = true
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.cvColor
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        view.addSubview(collectionView)
        
        collectionView.addSubview(refreshControl)
        
        view.backgroundColor = UIColor.white
        title = "Event"
        
        
        if #available(iOS 11.0, *) {
            let  insets = view.safeAreaLayoutGuide
            NSLayoutConstraint.activate([
                collectionView.leftAnchor.constraint(equalTo: insets.leftAnchor),
                collectionView.rightAnchor.constraint(equalTo: insets.rightAnchor),
                collectionView.topAnchor.constraint(equalTo: insets.topAnchor),
                collectionView.bottomAnchor.constraint(equalTo: insets.bottomAnchor)
                ])
        } else {
            // Fallback on earlier versions
            NSLayoutConstraint.activate([
                collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
                collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
                collectionView.topAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor),
                collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
                ])
        }
        collectionView.register(TestCell.self, forCellWithReuseIdentifier: TestCell.identifier)
        collectionView.register(EventHeaderCell.Nib, forCellWithReuseIdentifier: EventHeaderCell.identifier)
        collectionView.register(GuestListCell.Nib, forCellWithReuseIdentifier: GuestListCell.identifier)
        collectionView.register(CalendarMenuView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "menuView")
        
        view.addSubview(activityIndicator)
        
        activityIndicator.widthAnchor.constraint(equalToConstant: 20).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 20).isActive = true
        activityIndicator.topAnchor.constraint(equalTo: view.topAnchor, constant: 8).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        getEvents()
        activityIndicator.startAnimating()
    }
    
    
    @objc
    func handleRefresh(){
        if activityIndicator.isAnimating{
            activityIndicator.stopAnimating()
        }
        getEvents()
    }
    
    fileprivate func getEvents(){
        guard let id = eventId  else { return }
        EventItem.getSingleEvent(id: id) { (success, error, data) in
            DispatchQueue.main.async {
                if self.activityIndicator.isAnimating{
                    self.activityIndicator.stopAnimating()
                }
                if self.refreshControl.isRefreshing{
                    self.refreshControl.endRefreshing()
                }
                
                if success{
                    if let event = data?.last{
                        // activity stop
                        self.eventItem = event
                        self.collectionView.reloadData()
                    }
                } else {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let _ = eventItem else { return 0}
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            if cellType == .about{
                return 1
            } else {
                return dataSource.count
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EventHeaderCell.identifier, for: indexPath) as! EventHeaderCell
            cell.event = eventItem
            cell.delegate = self
            return cell
        } else {
            if cellType == .about{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GuestListCell.identifier, for: indexPath) as! GuestListCell
                cell.delegate = self
                cell.event = eventItem
                return cell
            }
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TestCell.identifier, for: indexPath) as! TestCell
            cell.backgroundColor = UIColor.green
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        menuView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "menuView", for: indexPath) as! CalendarMenuView
        menuView.menuBar.menuBarDelegate = self
        menuView.delegate = self
        return menuView
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 1{
            return CGSize(width: collectionView.frame.width, height: sectionHeight)
        } else {
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0{
            
            guard let item = eventItem else { return CGSize.zero}
            let height = heightForHeaderCell(item: item)
            return CGSize(width: collectionView.frame.width, height: height)
        } else {
            if cellType == .about {
                return CGSize(width: collectionView.frame.width, height: 60)
            }
            
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height - sectionHeight)
        }
        
    }
}

extension EventDetailVC: GuestListDelegate{
    func didTapGoing() {
        if let vc = GuestListVC.storyBoardInstance(), let id = eventId{
            vc.eventId = id
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func didTapInterested() {
        if let vc = GuestListVC.storyBoardInstance(),let id = eventId{
            vc.isInterested = true
            vc.eventId = id
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


extension EventDetailVC: MenuBarDelegate, CalendarMenuViewDelegate{
    func didTappedSaySomething() {
        if let vc = EditPostVC.storyBoardReference(), let item = eventItem ,let id = item.eventId, let name = item.eventName{
            vc.postType = .event
            vc.eventId = id
            vc.title = "On \(name)"
            vc.placehoder =   "Write something to \(name)"
            let nav = UINavigationController(rootViewController: vc)
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    func didTappedImageBtn() {
        let croppingParameters = CroppingParameters(isEnabled: true, allowResizing: true, allowMoving: true, minimumSize: CGSize(width: 200, height: 200))
        let cameraVC = CameraViewController.imagePickerViewController(croppingParameters: croppingParameters) { [weak self] (image, asset) in
            self?.dismiss(animated: true, completion: {
                if let vc = EditPostVC.storyBoardReference(), let item = self?.eventItem ,let id = item.eventId , let img = image{
                    vc.postType = .event
                    vc.eventId = id
                    vc.postImage = img
                    let nav = UINavigationController(rootViewController: vc)
                    self?.present(nav, animated: true, completion: nil)
                }
            })
        }
        present(cameraVC, animated: true, completion: nil)
    }
    
    func scrollToIndex(_ index: Int) {
        if index == 0 {
            menuView.menuBar.widthSpacing = 0
        } else {
            menuView.menuBar.widthSpacing = self.collectionView.frame.width / 2
        }
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.menuView.layoutIfNeeded()
        }, completion: nil)
        
        if index == 0 {
            cellType = .about
        } else {
            cellType = .discussion
        }
    }
}

extension EventDetailVC: EventHeaderCellDelegate{
    func didTapInterestedBtn(cell: EventHeaderCell) {
        guard let item = eventItem, let _ = item.interestedCount else { return }
        if eventItem!.isInterested{
            eventItem!.interestedCount! = eventItem!.interestedCount! - 1
        } else {
            eventItem!.interestedCount! = eventItem!.interestedCount! + 1
        }
        eventItem!.isInterested = !eventItem!.isInterested
        collectionView.reloadData()
        
        let service = APIService()
        service.endPoint = Endpoints.BASE_URL + "msInterested"
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&eventId=\(eventId!)"
        service.getDataWith { result in
            
        }
    }
    
    func didTapGoingBtn(cell: EventHeaderCell) {
        guard let item = eventItem , let _ =  item.goingCount else { return }
        
        if eventItem!.isGoing{
            eventItem!.goingCount! = eventItem!.goingCount! - 1
        } else {
            eventItem!.goingCount! = eventItem!.goingCount! + 1
        }
        eventItem!.isGoing = !eventItem!.isGoing
        collectionView.reloadData()
        let service = APIService()
        service.endPoint = Endpoints.BASE_URL + "msGoing"
        service.params = "userId=\(AuthService.instance.userId)&apiKey=\(API_KEY)&eventId=\(eventId!)"
        service.getDataWith { result in
            
        }
    }
    
    func didTapShareBtn(cell: EventHeaderCell) {
        //will enable later
    }
    
    func didTapmoreBtn(cell: EventHeaderCell) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Report Event", style: .default) { action in
            // report Api
        }
        let cacnel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.view.tintColor = UIColor.GREEN_PRIMARY
        alert.addAction(okAction)
        alert.addAction(cacnel)
        present(alert, animated: true, completion: nil)
    }
}
final class TestCell: BaseCell{ }





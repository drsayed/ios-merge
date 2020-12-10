//
//  EventVC.swift
//  myscrap
//
//  Created by MS1 on 12/19/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

class EventVC: BaseVC, UIScrollViewDelegate , MenuBarDelegate  {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    private lazy var menuBar : TopMenuBar = {
        let topBar = TopMenuBar(frame: .zero)
        topBar.translatesAutoresizingMaskIntoConstraints = false
        topBar.titleArray = ["UPCOMING", "INVITATIONS" ]
        topBar.menuBarDelegate = self
        topBar.collectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: [])
        return topBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        setupViews()
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
    
    static func storyBoardInstance() -> EventVC? {
        let st = UIStoryboard.calendar
        return st.instantiateViewController(withIdentifier: self.id) as? EventVC
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





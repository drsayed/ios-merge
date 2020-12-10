//
//  InterestsVC.swift
//  myscrap
//
//  Created by MS1 on 7/4/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit

class InterestsVC: ScrollViewContainerController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    fileprivate var dataSource = [String]()
    
    fileprivate enum segments: String{
        case commodities = "COMMODITIES"
        case roles = "ROLES"
    }
    
    fileprivate var segmentType: segments = .commodities{
        didSet{
            refreshViews(type: segmentType)
        }
    }
    
    var commoditiesArray = [String]()
    var rolesArray = [String]()
    
    
    private func refreshViews(type: segments){
        switch type {
        case .commodities:
            dataSource = commoditiesArray
        case .roles:
            dataSource = rolesArray
        }
        collectionView.reloadData()
        view.layoutIfNeeded()
    }
    
    
    private lazy var segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: [segments.commodities.rawValue, segments.roles.rawValue])
        sc.addTarget(self, action: #selector(segmentSelected(_:)), for: .valueChanged)
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.selectedSegmentIndex = 0
        sc.tintColor = UIColor.GREEN_PRIMARY
        return sc
    }()
    
    private lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: DGCollectionViewLeftAlignFlowLayout())
        cv.backgroundColor = UIColor.white
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
        title = "Interests"
        NotificationCenter.default.addObserver(self, selector: #selector(self.enableScroll), name: Notification.Name("EnableScroll"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.disableScroll), name: Notification.Name("DisableScroll"), object: nil)
        containerView.backgroundColor = UIColor.white
        collectionView.register(InterestCell.self, forCellWithReuseIdentifier: InterestCell.identifier)
        collectionView.register(EmptyStateView.nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: EmptyStateView.id)
        setupViews()
        dataSource = commoditiesArray
        scrollView.isScrollEnabled = false
        scrollView.delegate = self
    }
    @objc
    func enableScroll(){
        scrollView.isScrollEnabled = true
    }
    @objc func disableScroll(){
        scrollView.isScrollEnabled = false
    }
    private func setupViews(){
        containerView.addSubview(segmentedControl)
        
      
            NSLayoutConstraint.activate([
                segmentedControl.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                segmentedControl.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20)
                ])

        
        containerView.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8),
            collectionView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8),
            collectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20)
            ])
        
    }
    
    @objc private func segmentSelected(_ sender: UISegmentedControl){
        switch sender.selectedSegmentIndex {
        case 0:
            segmentType = .commodities
        case 1:
            segmentType = .roles
        default:
            segmentType = .commodities
        }
    }
}

extension InterestsVC{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InterestCell.identifier, for: indexPath) as? InterestCell else {
            return UICollectionViewCell()
        }
        cell.label.text = dataSource[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let label = UILabel()
        label.text = dataSource[indexPath.item]
        label.font = Fonts.DESIG_FONT
        let width = label.intrinsicContentSize.width
        return CGSize(width: width + 20, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: EmptyStateView.id, for: indexPath) as! EmptyStateView
        cell.imageView.image = #imageLiteral(resourceName: "ic_notes_empty")
        cell.textLbl.text = "No Data Available"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if !dataSource.isEmpty {
            return CGSize.zero
        }
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let actualPosition = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        if (actualPosition.y > 0){
            // Dragging down
            //let screenSize = UIScreen.main.bounds
            if scrollView.contentOffset.y <= 2 {
                self.collectionView.isScrollEnabled = false
                self.scrollView.isScrollEnabled = false
            }
        else
            {
                self.collectionView.isScrollEnabled = true
                self.scrollView.isScrollEnabled = true
            }
            
        }else{
           
            // Dragging up
        }
      
    }

}

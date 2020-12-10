//
//  CompanyInterestVC.swift
//  myscrap
//
//  Created by MS1 on 1/16/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit

class CompanyInterestVC: BaseVC, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    fileprivate var dataSource = [String]()
    
    fileprivate enum segments: String{
        case commodities = "COMMODITIES"
        case industry = "INDUSTRY"
        case affiliation = "AFFILIATION"
    }
    
    fileprivate var segmentType: segments = .commodities{
        didSet{
            refreshViews(type: segmentType)
        }
    }

    var commoditiesArray = [String]()
    var industryArray = [String]()
    var affiliationArray = [String]()
    
    
    private func refreshViews(type: segments){
        switch type {
        case .commodities:
            dataSource = commoditiesArray
        case .industry:
            dataSource = industryArray
        case .affiliation:
            dataSource = affiliationArray
        }
        collectionView.reloadData()
        view.layoutIfNeeded()
    }
    
    
    private lazy var segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: [segments.commodities.rawValue, segments.industry.rawValue, segments.affiliation.rawValue])
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
        view.backgroundColor = UIColor.white
        collectionView.register(InterestCell.self, forCellWithReuseIdentifier: InterestCell.identifier)
        collectionView.register(EmptyStateView.nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: EmptyStateView.id)
        setupViews()
        dataSource = commoditiesArray
    }
    
    private func setupViews(){
        view.addSubview(segmentedControl)

        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
                ])
        } else {
            NSLayoutConstraint.activate([
                segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                segmentedControl.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 20)
                ])
        }
        
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20)
            ])
        
    }
    
    @objc private func segmentSelected(_ sender: UISegmentedControl){
        switch sender.selectedSegmentIndex {
        case 0:
            segmentType = .commodities
        case 1:
            segmentType = .industry
        case 2:
            segmentType = .affiliation
        default:
            segmentType = .commodities
        }
    }
}

extension CompanyInterestVC{
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
    
}




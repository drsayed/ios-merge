//
//  TopMenuBar.swift
//  myscrap
//
//  Created by MS1 on 1/8/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import Foundation

protocol MenuBarDelegate: class {
    func scrollToIndex(_ index: Int)
}


class TopMenuBar: UIView ,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate{
    
    private var horizontalBarLeftConstraint:NSLayoutConstraint?
    private var horizontalBarWidthConstraint: NSLayoutConstraint?
    private let cellId = "CellId"
    
    
    weak var menuBarDelegate: MenuBarDelegate?
    
    var titleArray : [String]? {
        didSet{
            refreshView()
        }
    }
    
    var widthSpacing: CGFloat? = 0 {
        didSet {
            guard let spacing = widthSpacing else { return }
            horizontalBarLeftConstraint?.constant = spacing
        }
    }
    
    private func refreshIndex(){
        
    }
    
    private func refreshView(){
        collectionView.reloadData()
        if let count = titleArray?.count{
            horizontalBarWidthConstraint = horizontalBarView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/CGFloat(count))
            horizontalBarWidthConstraint?.isActive = true
            layoutIfNeeded()
        }
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isScrollEnabled = false
        cv.backgroundColor = UIColor.white
        cv.delegate = self
        cv.dataSource = self
        cv.allowsMultipleSelection = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    } ()
    
    let horizontalBarView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.GREEN_PRIMARY
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    private func setupViews(){
        setupCollectionView()
        setUpHorizontalBar()
        setupShadow()
    }
    
    private func setupShadow(){
        layer.shadowColor = UIColor(red: UIColor.SHADOW_GRAY, green: UIColor.SHADOW_GRAY, blue: UIColor.SHADOW_GRAY, alpha: 0.6).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.cornerRadius = 2.0
    }
    private func setupCollectionView(){
        self.addSubview(collectionView)
        collectionView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        collectionView.register(NewsBarCell.self, forCellWithReuseIdentifier: cellId)
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
    }
    
    // MARK :- SETTIUP MENU SLIDER ON TOP
    private func setUpHorizontalBar(){
        self.addSubview(horizontalBarView)
        
        horizontalBarLeftConstraint = horizontalBarView.leftAnchor.constraint(equalTo: self.leftAnchor)
        horizontalBarLeftConstraint?.isActive = true
        horizontalBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        //        horizontalBarWidthConstraint = horizontalBarView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/2)
        
        
        horizontalBarView.heightAnchor.constraint(equalToConstant: 3).isActive = true
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titleArray?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! NewsBarCell
        cell.label.text = titleArray?[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let count = CGFloat(titleArray?.count ?? 4)
        return CGSize(width: self.frame.width / count, height: self.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        menuBarDelegate?.scrollToIndex(indexPath.item)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }

}

//
//  SliderView.swift
//  Slider
//
//  Created by MyScrap on 7/10/18.
//  Copyright © 2018 Test. All rights reserved.
//

import UIKit
import SDWebImage

protocol MSSliderDataSource {
    var imageURL: String? { get }
    var url: URL? { get }
}

extension MSSliderDataSource{
    var url: URL?{
        if let str = imageURL, let item = URL(string: str){
            return item
        }
        return nil
    }
}

protocol MSSliderDelegate: class{
    func didSelect(photo: Images, in photos: [Images])
}

class MSSliderView: UIView, UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {

    weak var delegate: MSSliderDelegate?
    
    var dataSource = [MSSliderDataSource]() {
        didSet{
            sliderCollectionView.reloadData()
            pageControl.numberOfPages = dataSource.count
            setNeedsLayout()
        }
    }
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.translatesAutoresizingMaskIntoConstraints = false
        pc.currentPage = 0
        pc.currentPageIndicatorTintColor = UIColor.MyScrapGreen
        pc.pageIndicatorTintColor = UIColor.white
        pc.hidesForSinglePage = false
        return pc
    }()
    
    var countView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor.GREEN_PRIMARY
        //view.layer.cornerRadius = self.height / 2
        //view.clipsToBounds = true
        return view
    }()
    
    var img_count : UILabel = {
        let lbl = UILabel()
        //lbl.adjustsFontSizeToFitWidth = true
        //lbl.numberOfLines = 2
        //lbl.frame = CGRect(x: 10, y: 10, width: 100, height: 100)
        lbl.text = ""
        lbl.textColor = UIColor.white
        lbl.font = UIFont(name: "HelveticaNeue", size: 14)
        lbl.textAlignment = .center
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var sliderCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        cv.delegate = self
        cv.dataSource = self
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.register(MSSliderCell.self)
        return cv
    }()
    
    private func setupViews(){
        backgroundColor = UIColor.white
        
        addSubview(sliderCollectionView)
        sliderCollectionView.anchor(leading: leadingAnchor, trailing: trailingAnchor, top: topAnchor, bottom: bottomAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        
        //countView.anchor(leading: leadingAnchor, trailing: self.trailingAnchor, top: self.topAnchor, bottom: bottomAnchor)
        
        
        addSubview(countView)
        
        addSubview(pageControl)
        pageControl.anchor(leading: nil, trailing: countView.trailingAnchor, top: topAnchor, bottom: countView.topAnchor)
        //pageControl.x = 100
        
        
        
        //countView.anchor(leading: nil, trailing: nil, top: pageControl.bottomAnchor, bottom: nil)
        
        countView.height = 30
        countView.width = 50
        countView.x = 310
        countView.y = 35
        
        countView.layer.cornerRadius = 10
        countView.clipsToBounds = true
        countView.backgroundColor = UIColor.MyScrapGreen
        
        addSubview(img_count)
        img_count.centerXAnchor.constraint(equalTo: countView.centerXAnchor).isActive = true
        img_count.centerYAnchor.constraint(equalTo: countView.centerYAnchor).isActive = true
        //img_count.anchor(leading: nil, trailing: countView.trailingAnchor, top: countView.topAnchor, bottom: nil)
        //pageControl.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }

    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        img_count.text = String(format: "%d / %d", pageControl.currentPage + 1 ,dataSource.count)
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MSSliderCell = collectionView.dequeReusableCell(forIndexPath: indexPath)
        cell.data = dataSource[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //delegate?.didSelect(photo: dataSource[indexPath.item] as! Images, in: dataSource as! [Images])
        scrollToNextCell()
    }

    func scrollToNextCell(){
        
        //get cell size
        let cellSize = self.frame.size
        
        //get current content Offset of the Collection view
        let contentOffset = sliderCollectionView.contentOffset
        
        //let section = sliderCollectionView.indexPathForItem(at: contentOffset)!.item
        
        //img_count.text = String(format: "%d / %d", section + 1, dataSource.count)
        //print("Image count in tap : \(String(describing: img_count.text))")
        //pageControl.currentPage = section + 1
        
        if sliderCollectionView.contentSize.width <= sliderCollectionView.contentOffset.x + cellSize.width
        {
            let r = CGRect(x: 0, y: contentOffset.y, width: cellSize.width, height: cellSize.height)
            sliderCollectionView.scrollRectToVisible(r, animated: true)
            
        } else {
            let r = CGRect(x: contentOffset.x + cellSize.width, y: contentOffset.y, width: cellSize.width, height: cellSize.height)
            sliderCollectionView.scrollRectToVisible(r, animated: true);
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let contentWidth = scrollView.contentSize.width
        print("X : \(offsetX), \n Scrollview content width :\(contentWidth),\n Frame width :\(scrollView.frame.size.width)")
        if offsetX > contentWidth - scrollView.frame.size.width {
            self.sliderCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .left, animated: true)
            self.sliderCollectionView.reloadData()
        } else if offsetX < 0 {
            self.sliderCollectionView.scrollToItem(at: IndexPath(item: dataSource.count - 1, section: 0), at: .right, animated: true)
            self.sliderCollectionView.reloadData()
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if sliderCollectionView == scrollView , let section = sliderCollectionView.indexPathForItem(at: targetContentOffset.pointee)?.item{
//            img_count.text = String(format: "%d / %d", section + 1 ,dataSource.count)
//            print("Image count : \(String(describing: img_count.text))")
//            pageControl.currentPage = section
            
        }
    }
    
    var isLoading: Bool = false
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //scrollToNextCell()
        
        print("Image count in tap : \(String(describing: img_count.text))")
        img_count.text = String(format: "%d / %d", indexPath.item + 1, dataSource.count)
        self.pageControl.currentPage = indexPath.item
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: bounds.size.width, height: bounds.size.height)
    }
    
    private func setSize(){
        if let layout = sliderCollectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            layout.itemSize =  CGSize(width: bounds.size.width, height: bounds.size.height)
        }
    }

     override func layoutSubviews() {
        super.layoutSubviews()
        setSize()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    
}

class MSSliderViewMarket: UIView, UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    weak var delegate: MSSliderDelegate?
    
    var dataSource = [MSSliderDataSource]() {
        didSet{
            sliderCollectionView.reloadData()
            pageControl.numberOfPages = dataSource.count
            setNeedsLayout()
        }
    }
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.translatesAutoresizingMaskIntoConstraints = false
        pc.currentPage = 0
        pc.currentPageIndicatorTintColor = UIColor.MyScrapGreen
        pc.pageIndicatorTintColor = UIColor.white
        pc.hidesForSinglePage = false
        return pc
    }()
    
    var countView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.GREEN_PRIMARY
        //view.layer.cornerRadius = self.height / 2
        //view.clipsToBounds = true
        return view
    }()
    
    var img_count : UILabel = {
        let lbl = UILabel()
        //lbl.adjustsFontSizeToFitWidth = true
        //lbl.numberOfLines = 2
        //lbl.frame = CGRect(x: 10, y: 10, width: 100, height: 100)
        lbl.text = ""
        lbl.textColor = UIColor.white
        lbl.font = UIFont(name: "HelveticaNeue", size: 14)
        lbl.textAlignment = .center
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var sliderCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        cv.delegate = self
        cv.dataSource = self
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.register(MSSliderCell.self)
        return cv
    }()
    
    private func setupViews(){
        backgroundColor = UIColor.white
        
        addSubview(sliderCollectionView)
        sliderCollectionView.anchor(leading: leadingAnchor, trailing: trailingAnchor, top: topAnchor, bottom: bottomAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        
        //countView.anchor(leading: leadingAnchor, trailing: self.trailingAnchor, top: self.topAnchor, bottom: bottomAnchor)
        
        
        addSubview(countView)
        
        addSubview(pageControl)
        pageControl.anchor(leading: nil, trailing: countView.trailingAnchor, top: topAnchor, bottom: countView.topAnchor)
        //pageControl.x = 100
        
        
        
        //countView.anchor(leading: nil, trailing: nil, top: pageControl.bottomAnchor, bottom: nil)
        
        countView.height = 30
        countView.width = 50
        countView.x = 310
        countView.y = 35
        
        countView.layer.cornerRadius = 10
        countView.clipsToBounds = true
        countView.backgroundColor = UIColor.MyScrapGreen
        
        addSubview(img_count)
        img_count.centerXAnchor.constraint(equalTo: countView.centerXAnchor).isActive = true
        img_count.centerYAnchor.constraint(equalTo: countView.centerYAnchor).isActive = true
        //img_count.anchor(leading: nil, trailing: countView.trailingAnchor, top: countView.topAnchor, bottom: nil)
        //pageControl.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        img_count.text = String(format: "%d / %d", pageControl.currentPage + 1 ,dataSource.count)
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MSSliderCell = collectionView.dequeReusableCell(forIndexPath: indexPath)
        cell.data = dataSource[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelect(photo: dataSource[indexPath.item] as! Images, in: dataSource as! [Images])
    }
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if sliderCollectionView == scrollView , let section = sliderCollectionView.indexPathForItem(at: targetContentOffset.pointee)?.item{
            img_count.text = String(format: "%d / %d", section + 1 ,dataSource.count)
            print("Image count : \(String(describing: img_count.text))")
            pageControl.currentPage = section
            //pageControl.transform = CGAffineTransform(scaleX: 2, y: 2)
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: bounds.size.width, height: bounds.size.height)
    }
    
    private func setSize(){
        if let layout = sliderCollectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            layout.itemSize =  CGSize(width: bounds.size.width, height: bounds.size.height)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setSize()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    
}
class MSSliderViewAd: UIView, UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    weak var delegate: MSSliderDelegate?
    
    var dataSource = [MSSliderDataSource]() {
        didSet{
            sliderCollectionView.reloadData()
            pageControl.numberOfPages = dataSource.count
            setNeedsLayout()
        }
    }
    
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.backgroundColor = .clear
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.spacing = 12
        sv.y = 200
        sv.alignment = .fill
        sv.distribution = .fillEqually
        sv.axis = .horizontal
        return sv
    }()
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.translatesAutoresizingMaskIntoConstraints = false
        pc.currentPage = 0
        //pc.currentPageIndicatorTintColor = UIColor.MyScrapGreen
        //pc.pageIndicatorTintColor = UIColor(hexString: "#80FFFFFF")
        pc.pageIndicatorTintColor = UIColor.white
        pc.hidesForSinglePage = true
        pc.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        
        return pc
    }()
    
    var countView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.GREEN_PRIMARY
        //view.layer.cornerRadius = self.height / 2
        //view.clipsToBounds = true
        return view
    }()
    
    var img_count : UILabel = {
        let lbl = UILabel()
        //lbl.adjustsFontSizeToFitWidth = true
        //lbl.numberOfLines = 2
        //lbl.frame = CGRect(x: 10, y: 10, width: 100, height: 100)
        lbl.text = ""
        lbl.textColor = UIColor.white
        lbl.font = UIFont(name: "HelveticaNeue", size: 14)
        lbl.textAlignment = .center
        
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private lazy var sliderCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        cv.delegate = self
        cv.dataSource = self
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.register(MSSliderCell.self)
        return cv
    }()
    
    private func setupViews(){
        backgroundColor = UIColor.white
        
        addSubview(sliderCollectionView)
        sliderCollectionView.anchor(leading: leadingAnchor, trailing: trailingAnchor, top: topAnchor, bottom: bottomAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        
        
        //countView.anchor(leading: leadingAnchor, trailing: self.trailingAnchor, top: self.topAnchor, bottom: bottomAnchor)
        
        
        addSubview(countView)
        sliderCollectionView.addSubview(pageControl)
        //addSubview(stackView)
        
//        stackView.height = 50
//        stackView.width = self.width
//        stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
//        stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
//        stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20 ).isActive = true
        //stackView.anchor(leading: leadingAnchor, trailing: trailingAnchor, top: nil, bottom: nil, padding: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12), size: CGSize(width: self.width, height: 50))
        //stackView.addArrangedSubview(pageControl)

        pageControl.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        pageControl.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        pageControl.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        
        
        //pageControl.anchor(leading: stackView.leadingAnchor, trailing: stackView.trailingAnchor, top: stackView.topAnchor, bottom: stackView.topAnchor)
        
        //countView.anchor(leading: nil, trailing: nil, top: pageControl.bottomAnchor, bottom: nil)
        
        
        countView.height = 30
        countView.width = 50
        countView.x = 310
        countView.y = 35
        
        countView.layer.cornerRadius = 10
        countView.clipsToBounds = true
        countView.backgroundColor = UIColor.MyScrapGreen
        
        addSubview(img_count)
        img_count.centerXAnchor.constraint(equalTo: countView.centerXAnchor).isActive = true
        img_count.centerYAnchor.constraint(equalTo: countView.centerYAnchor).isActive = true
        //img_count.anchor(leading: nil, trailing: countView.trailingAnchor, top: countView.topAnchor, bottom: nil)
        //pageControl.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        img_count.text = String(format: "%d / %d", pageControl.currentPage + 1 ,dataSource.count)
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MSSliderCell = collectionView.dequeReusableCell(forIndexPath: indexPath)
        cell.data = dataSource[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //Commenting this line because Ad image shouldn't open
        //delegate?.didSelect(photo: dataSource[indexPath.item] as! Images, in: dataSource as! [Images])
    }
    
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if sliderCollectionView == scrollView , let section = sliderCollectionView.indexPathForItem(at: targetContentOffset.pointee)?.item{
            img_count.text = String(format: "%d / %d", section + 1 ,dataSource.count)
            print("Image count : \(String(describing: img_count.text))")
            
            pageControl.currentPage = section
            
            
            
            //Commented on 19thSep/19
//            let x = targetContentOffset.pointee.x
//
//            pageControl.currentPage = Int(x / self.frame.width)
            
            
            // on each dot, call the transform of scale 1 to restore the scale of previously selected dot
            
//            pageControl.subviews.forEach {
//                $0.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
//            }
            
            for pgCount in pageControl.subviews {
                pgCount.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            }
            
            // transform the scale of the current subview dot, adjust the scale as required, but bigger the scale value, the downward the dots goes from its centre.
            // You can adjust the centre anchor of the selected dot to keep it in place approximately.
            
            //let centreBeforeScaling = self.pageControl.subviews[self.pageControl.currentPage].center
            
//            self.pageControl.subviews[self.pageControl.currentPage].transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            
            //self.pageControl.translatesAutoresizingMaskIntoConstraints = false
            
            //pageControl.subviews[self.pageControl.currentPage].topAnchor.constraint(equalTo: self.pageControl.subviews.last!.topAnchor, constant: -10).isActive = true
            
            //self.pageControl.subviews[self.pageControl.currentPage].centerYAnchor.constraint(equalTo: self.pageControl.subviews[0].centerYAnchor , constant: 0).isActive = true
            
            //self.pageControl.subviews[self.pageControl.currentPage].centerXAnchor.constraint(equalTo: self.pageControl.subviews.last!.centerXAnchor , constant: 0).isActive = true

            //self.pageControl.subviews[self.pageControl.currentPage].layer.anchorPoint = centreBeforeScaling
            self.pageControl.subviews[self.pageControl.currentPage].transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
    func pageIndicatorAnimation() {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: bounds.size.width, height: bounds.size.height)
    }
    
    private func setSize(){
        if let layout = sliderCollectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            layout.itemSize =  CGSize(width: bounds.size.width, height: bounds.size.height)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setSize()
        
        if pageControl.currentPage == 0 {
            pageControl.subviews[self.pageControl.currentPage].transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        //pageControl.subviews[self.pageControl.currentPage].transform = CGAffineTransform(scaleX: 1, y: 1)
        
        /*
        // on each dot, call the transform of scale 1 to restore the scale of previously selected dot
         pageControl.subviews.forEach {
         $0.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
         }

        
        print("page control frame : \(pageControl.frame)")
        
        //Commented on 19thSep/19
        if pageControl.currentPage == 0 {
            pageControl.subviews[self.pageControl.currentPage].transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }

        // transform the scale of the current subview dot, adjust the scale as required, but bigger the scale value, the downward the dots goes from its centre.
        // You can adjust the centre anchor of the selected dot to keep it in place approximately.

        //self.pageControl.subviews[self.pageControl.currentPage].transform = CGAffineTransform(scaleX: 1.5, y: 1.5)

        //self.pageControl.subviews[self.pageControl.currentPage].translatesAutoresizingMaskIntoConstraints = false
 
        self.pageControl.subviews[self.pageControl.currentPage].centerYAnchor.constraint(equalTo: self.pageControl.subviews[0].centerYAnchor , constant: 0).isActive = true
        
        self.pageControl.subviews[self.pageControl.currentPage].centerXAnchor.constraint(equalTo: self.pageControl.subviews[0].centerXAnchor , constant: 0).isActive = true
        */
 
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    
}
class QuadPageControl: UIPageControl {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard !subviews.isEmpty else { return }
        
        let spacing: CGFloat = 8
        
        let width: CGFloat = 8
        
        let height = spacing
        
        var total: CGFloat = 0
        
        for view in subviews {
            view.layer.cornerRadius = 0
            view.frame = CGRect(x: total, y: frame.size.height / 2 - height / 2, width: width, height: height)
            total += width + spacing
        }
        
        total -= spacing
        
        frame.origin.x = frame.origin.x + frame.size.width / 2 - total / 2
        frame.size.width = total
    }
}

class MSSliderCell: UICollectionViewCell{
    
    private var backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private var imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        //iv.contentMode = .scaleAspectFill
        iv.width = 375
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView()
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.hidesWhenStopped = true
        ai.startAnimating()
        return ai
    }()
    
    var image: UIImage? {
        didSet{
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                if let img = self.image{
                    self.imageView.image = img
                    //self.imageView.image = img.scaled(to: self.imageView.bounds.size)
                    //self.backgroundImageView.image = img
                } else {
                    self.imageView.image = #imageLiteral(resourceName: "no-image")
                    //self.backgroundImageView.image = nil
                }
            }
        }
    }
    
    
    
    var data : MSSliderDataSource?{
        didSet {
            if let item = data{
                guard let url = item.url else {
                    image = nil
                    return
                }
                
                /*SDWebImageManager.shared().cachedImageExists(for: url) { (status) in
                    if status{
                        //SDWebImageManager.shared().imageCache?.queryCacheOperation(forKey: url.absoluteString, done: { (image, _, _) in
                           //self.image = image
                        //})
                        SDWebImageManager.shared().imageDownloader?.downloadImage(with: url, options: .highPriority, progress: nil, completed: { (image, _, _, _) in
                            //SDImageCache.shared().store(image, forKey: url.absoluteString)
                            self.image = image
                        })
                    } else {
                        /*if url == URL(string: "https://myscrap.com/style/images/icons/no_image.png") {
                            self.image = UIImage(named: "no_image")
                        } else {
                            SDWebImageManager.shared().imageDownloader?.downloadImage(with: url, options: .highPriority, progress: nil, completed: { (image, _, _, _) in
                                //SDImageCache.shared().store(image, forKey: url.absoluteString)
                                self.image = image
                            })
                        }*/
                        SDWebImageManager.shared().imageDownloader?.downloadImage(with: url, options: .highPriority, progress: nil, completed: { (image, _, _, _) in
                            //SDImageCache.shared().store(image, forKey: url.absoluteString)
                            self.image = image
                        })
                    }
                
                }*/
                
                SDWebImageManager.shared().cachedImageExists(for: url) { (status) in
                    if status{
                        SDWebImageManager.shared().imageCache?.queryCacheOperation(forKey: url.absoluteString, done: { (image, data, type) in
                            self.image = image
                        })
                    } else {
                        SDWebImageManager.shared().imageDownloader?.downloadImage(with: url, options: SDWebImageDownloaderOptions.continueInBackground, progress: nil, completed: { (image, data, error, status) in
                            if let error = error {
                                print("Error while downloading : \(error), Status :\(status), url :\(String(describing: url))")
                                self.image = #imageLiteral(resourceName: "no-image")
                            } else {
                                SDImageCache.shared().store(image, forKey: url.absoluteString)
                                self.image = image
                            }
                        })
                    }
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews(){
        
        addSubview(imageView)
        imageView.anchor(leading: leadingAnchor, trailing: trailingAnchor, top: topAnchor, bottom: bottomAnchor)
        print("Image view size \(imageView.width)")
        
        /*addSubview(backgroundImageView)
        backgroundImageView.anchor(leading: leadingAnchor, trailing: trailingAnchor, top: topAnchor, bottom: bottomAnchor)
        if !UIAccessibilityIsReduceTransparencyEnabled(){
            backgroundColor = .clear
            let blurEffect = UIBlurEffect(style: .regular)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(blurEffectView)
        } else {
            backgroundColor = UIColor.white
        }*/
        
        addSubview(activityIndicator)
        activityIndicator.centertoSuperView()
        activityIndicator.setSize(size: CGSize(width: 30, height: 30))
        
        
        
    }
}



// MARK: - Image Scaling.
extension UIImage {
    
    /// Represents a scaling mode
    enum ScalingMode {
        case aspectFill
        case aspectFit
        
        /// Calculates the aspect ratio between two sizes
        ///
        /// - parameters:
        ///     - size:      the first size used to calculate the ratio
        ///     - otherSize: the second size used to calculate the ratio
        ///
        /// - return: the aspect ratio between the two sizes
        func aspectRatio(between size: CGSize, and otherSize: CGSize) -> CGFloat {
            let aspectWidth  = size.width/otherSize.width
            let aspectHeight = size.height/otherSize.height
            
            switch self {
            case .aspectFill:
                return max(aspectWidth, aspectHeight)
            case .aspectFit:
                return min(aspectWidth, aspectHeight)
            }
        }
    }
    
    /// Scales an image to fit within a bounds with a size governed by the passed size. Also keeps the aspect ratio.
    ///
    /// - parameter:
    ///     - newSize:     the size of the bounds the image must fit within.
    ///     - scalingMode: the desired scaling mode
    ///
    /// - returns: a new scaled image.
    func scaled(to newSize: CGSize, scalingMode: UIImage.ScalingMode = .aspectFit) -> UIImage {
        
        let aspectRatio = scalingMode.aspectRatio(between: newSize, and: size)
        
        /* Build the rectangle representing the area to be drawn */
        var scaledImageRect = CGRect.zero
        
        scaledImageRect.size.width  = size.width * aspectRatio
        scaledImageRect.size.height = size.height * aspectRatio
        scaledImageRect.origin.x    = (newSize.width - size.width * aspectRatio) / 2.0
        scaledImageRect.origin.y    = (newSize.height - size.height * aspectRatio) / 2.0
        
        /* Draw and retrieve the scaled image */
        UIGraphicsBeginImageContext(newSize)
        
        draw(in: scaledImageRect)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
}
extension UIPageControl {
    func customPageControl(dotWidth: CGFloat) {
        for (pageIndex, dotView) in self.subviews.enumerated() {
            dotView.frame.size = CGSize.init(width: dotWidth, height: dotWidth)
        }
    }
}



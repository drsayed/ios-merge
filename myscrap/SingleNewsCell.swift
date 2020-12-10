//
//  SingleNewsCell.swift
//  myscrap
//
//  Created by MS1 on 8/29/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit


/*
final class SingleNewsCell: UITableViewCell{
    
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var likeCountBtn: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var likeLblBtn: UIButton!
    @IBOutlet weak var subHeadingLbl: UILabel!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var companyBtn: UIButton!
    @IBOutlet weak var leftView: UIView!
    @IBOutlet weak var rightView: UIView!
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var rightImageView: UIImageView!
    
    weak var delegate: SingleNewsDelegate?
    
    fileprivate var currentPage = 0 {
        didSet{
            if pictureURL.count <= 1{
                self.leftView.isHidden = true
                self.rightView.isHidden = true
            } else {
                switch currentPage {
                case 0:
                    self.leftView.isHidden = true
                    self.rightView.isHidden = false
                case pictureURL.count - 1:
                    self.rightView.isHidden = true
                    self.leftView.isHidden = false
                default:
                    self.rightView.isHidden = false
                    self.leftView.isHidden = false
                }
                
            }
        }
    }
    let cellId = "cellId"
    var pictureURL = [PictureURL]()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        setupTaps()
        setupCollectionView()
        setupPageControl()
        setupLabels()
        setupbuttons()
        
    }
    private func setupbuttons(){
        likeCountBtn.setTitleColor(UIColor.lightGray, for: .normal)
        commentBtn.setTitleColor(UIColor.BLACK_ALPHA, for: .normal)
        likeLblBtn.setTitleColor(UIColor.BLACK_ALPHA, for: .normal)
        
    }
    
    fileprivate func setupTaps(){
        
        let lftimg = #imageLiteral(resourceName: "arrow_left").withRenderingMode(.alwaysTemplate)
        self.leftImageView.image = lftimg
        self.leftView.tintColor = UIColor.white
        let rightImg = #imageLiteral(resourceName: "arrow_right").withRenderingMode(.alwaysTemplate)
        self.rightImageView.image = rightImg
        self.rightView.tintColor = UIColor.white

        
        let leftTap = UITapGestureRecognizer(target: self, action: #selector(leftViewTapped(_:)))
        leftTap.numberOfTapsRequired = 1
        self.leftView.addGestureRecognizer(leftTap)
        
        let rightTap = UITapGestureRecognizer(target: self, action: #selector(rightViewTapped(_:)))
        rightTap.numberOfTapsRequired = 1
        self.rightView.addGestureRecognizer(rightTap)
        
    }
    @objc fileprivate func leftViewTapped(_ tap: UITapGestureRecognizer){
        let ip = IndexPath(item: currentPage - 1, section: 0)
        if collectionView.hasRowAtIndexPath(indexPath: ip){
            self.collectionView.scrollToItem(at: ip, at: .left, animated: true)
        }
    }
    @objc fileprivate func rightViewTapped(_ tap: UITapGestureRecognizer){
        let ip = IndexPath(item: currentPage + 1, section: 0)
        if collectionView.hasRowAtIndexPath(indexPath: ip){
            self.collectionView.scrollToItem(at: ip, at: .right, animated: true)
        }
    }
    
    private func setupLabels(){
        //MARK:- sub heading
        
        headingLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 22)
        headingLbl.textColor = UIColor.BLACK_ALPHA
        
        subHeadingLbl.font = UIFont(name: "HelveticaNeue", size: 18)
        subHeadingLbl.textColor = UIColor.BLACK_ALPHA
        
        descriptionLbl.font = UIFont(name: "HelveticaNeue", size: 18)
        descriptionLbl.textColor = UIColor.BLACK_ALPHA
        
        timeLbl.font = UIFont(name: "HelveticaNeue", size: 11)
        companyBtn.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 11)
        companyBtn.setTitleColor(UIColor.GREEN_PRIMARY, for: .normal)
        
        
        subHeadingLbl.numberOfLines = 0
    }
    private func setupPageControl(){
        pageControl.numberOfPages = 1
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = UIColor.GREEN_PRIMARY
    }
    private func setupCollectionView(){
        collectionView.register(SliderCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configCell(news: News){
        
        headingLbl.text = news.heading ?? ""
        subHeadingLbl.text = news.subHeading ?? ""
        descriptionLbl.text = "\(news.publishLocation ?? ""): " + "\(news.status ?? "")"
        if let timestamp = news.timeStamp{
            let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "hh:mm MMM dd, yyyy"
            timeLbl.text = dateformatter.string(from: date)
            companyBtn.setTitle(news.publisherMagazine ?? "", for: .normal)
        }
        
        self.pictureURL = news.pictureURL
        currentPage = 0
        pageControl.numberOfPages = pictureURL.count
        switch pictureURL.isEmpty {
        case true:
            collectionView.isHidden = true
        case false:
            collectionView.isHidden = false
        }
        switch news.likeCount {
        case 0:
            likeCountBtn.isHidden = true
        case 1:
            likeCountBtn.isHidden = false
            likeCountBtn.setTitle("1 Like.", for: .normal)
        default:
            likeCountBtn.isHidden = false
            likeCountBtn.setTitle("\(news.likeCount!) Likes.", for: .normal)
        }
        switch news.likeStatus {
        case true:
            let img = #imageLiteral(resourceName: "likeg").withRenderingMode(.alwaysTemplate)
            likeBtn.setImage(img, for: .normal)
            likeBtn.tintColor = UIColor.GREEN_PRIMARY
        default:
            let img = #imageLiteral(resourceName: "like").withRenderingMode(.alwaysTemplate)
            likeBtn.setImage(img, for: .normal)
            likeBtn.tintColor = UIColor.BLACK_ALPHA
        }
       
       
    }
    
    @IBAction func likeBtnPressed(_ sender: UIButton){
        if let delegate = self.delegate{
            delegate.likeButtonPressed(cell: self)
        }
    }
    @IBAction func companyBtnPressed(_ sender: UIButton){
        if let delegate = self.delegate{
            delegate.companyPressed(cell: self)
        }
    }
    @IBAction func likeCountButtonPressed(_ sender: UIButton){
        if let delegate = self.delegate{
            delegate.likeCountPressed(cell: self)
        }
    }
}

extension SingleNewsCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictureURL.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SliderCell
        cell.imageView.setImageWithIndicator(imageURL: pictureURL[indexPath.item].images)
        return cell
    }
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width - 16 , height: self.frame.width - 16)
    }
  
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            let pageWidth = scrollView.frame.width
            let currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
            self.currentPage = currentPage
            pageControl.currentPage = currentPage
        }
    }
    

}

class SliderCell: UICollectionViewCell{
    
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = UIColor.black
        sv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        sv.contentOffset = CGPoint(x: 0, y: 0)
        return sv
    }()
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = UIColor.black
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    } ()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    func setupViews(){
        self.addSubview(imageView)
        imageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
    //    self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
    }
}
*/

//
//  NewsVC.swift
//  myscrap
//
//  Created by MS1 on 8/26/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit
/*
class NewsVC: BaseRevealVC, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let wasteCellId = "wasteCellId"
    let recyclingCellId = "RecycleId"
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var newsBar: NewsBar!
    
    var newsType = NewsType.WasteRecycling
    
    
    var wasteRecyclingNews = [News]()
    var recyclingTodayNews = [News]()
    let cellId = "cellId"
    
    let wasteRecyclingId = "wasteRecycling"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.activityIndicator.startAnimating()
        setupCollectionView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    
    func goToPostNews(companyId: String){
        if let vc = PostNewsVC.storyBoardInstance(){
            vc.companyId = companyId
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    func editNews(heading: String, subHeadline:String , content: String, companyId: String){
        if let vc = PostNewsVC.storyBoardInstance(){
            vc.headlinePassed = heading
            vc.subheadlinePassed = subHeadline
            vc.contentPassed = content
            vc.companyId = companyId
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    func setupCollectionView(){
        collectionView.register(WasteRecyclingCollectionCell.self, forCellWithReuseIdentifier: wasteCellId)
        collectionView.register(RecyclingTodayCollectionCell.self, forCellWithReuseIdentifier: recyclingCellId)
        
        newsBar.newsVC = self
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout{
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
            flowLayout.minimumInteritemSpacing = 0
        }
        collectionView.isPagingEnabled = true
    }
    func dealData(news: [String:AnyObject]){
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsBar.titleArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
 
        switch indexPath.item {
        case 0:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: wasteCellId, for: indexPath) as? WasteRecyclingCollectionCell{
                cell.newsVC = self
                return cell
            }
            return UICollectionViewCell()
        case 1:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: recyclingCellId, for: indexPath) as? RecyclingTodayCollectionCell{
                cell.newsVC = self
                return cell
            }
            return UICollectionViewCell()
        default:
            return UICollectionViewCell()
        }
        
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: self.view.frame.width, height: self.view.frame.height - 50)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionView{
         newsBar.horizontalBarLeftConstraint?.constant = scrollView.contentOffset.x / 2
        }
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == collectionView{
            let index = targetContentOffset.pointee.x / view.frame.width
            let indexPath = IndexPath(item: Int(index), section: 0)
            newsBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
            }
        }
    func scrolltoNewsIndex(index: Int){
        let indexPath = IndexPath(item: index, section: 0)
        self.collectionView.scrollToItem(at: indexPath, at: .right, animated: true)
    }
    private func setupRefreshControl(tbl: UITableView){
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshOptions(sender:)), for: .valueChanged)
        tbl.refreshControl = refreshControl
    }
    func gotoSingleNews(newsId: String){
        if let vc = SingleNewsVC.storyBoardInstance(){
            vc.newsId = newsId
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @objc private func refreshOptions(sender: UIRefreshControl) {
        // Perform actions to refresh the content
        // ...
        // and then dismiss the control
        sender.endRefreshing()
    }
}




class WasteRecyclingCollectionCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource{
    
    fileprivate var news = [News]()
    var isEditor = 0
    var newsType: NewsType = .WasteRecycling
    
    fileprivate var companyId: String{ return "5040"}
    
    let cellId = "cellId"
    
    weak var newsVC:NewsVC?
    
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.separatorStyle = .none
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    let activityIndicator : UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView()
        ai.activityIndicatorViewStyle = .gray
        ai.hidesWhenStopped = true
        ai.translatesAutoresizingMaskIntoConstraints = false
        return ai
    }()
    let circleView : UIButton = {
        let cv = UIButton()
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.layer.cornerRadius = 30
        cv.layer.masksToBounds = true
        cv.backgroundColor = UIColor.GREEN_PRIMARY
        return cv
    }()

    lazy var refreshControl : UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        return rc
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.activityIndicator.startAnimating()
        setupViews()
        getNews()
  
    }
    

    
    @objc private func addNewsPressed(_ sender: UIButton){
    
        self.newsVC?.goToPostNews(companyId: companyId)
    }
  
    
    private func setupViews(){
        // MARK:- TableView
        tableView.register(SingleNewsTableCell.self, forCellReuseIdentifier: cellId)
        self.addSubview(tableView)
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        self.addSubview(circleView)
        
        //MARK:- CIRCLE VIEW
        circleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
        circleView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16).isActive = true
        circleView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        circleView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        let image = #imageLiteral(resourceName: "ic_add").withRenderingMode(.alwaysTemplate)
        circleView.setImage(image, for: .normal)
        circleView.tintColor = UIColor.white
        circleView.isHidden = true
        
        circleView.addTarget(self, action: #selector(addNewsPressed(_:)), for: .touchUpInside)
        
        //MARK :- Activity Indicator
     /*   self.addSubview(activityIndicator)
        activityIndicator.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 20).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 20).isActive = true */
        
        //MARK:- Refresh Control
        tableView.addSubview(refreshControl)
        refreshControl.beginRefreshing()
 
    }
    
    @objc private func handleRefresh(_ refresh: UIRefreshControl){
        self.getNews()
    }
    fileprivate func getNews(){
        let userid = UserDefaults.standard.value(forKey: "userid") as! String
        let api = APIService()
        api.endPoint = Endpoints.NEWS_URL
        api.params = "userId=\(userid)&apiKey=\(API_KEY)&companyId=5040"
        api.getDataWith { (result) in
            switch result{
            case .Error(let error):
                print(error)
            case .Success(let data):
                self.dealData(dict: data)
                
            }
        }
    }
    
    fileprivate func dealData(dict : [String: AnyObject]){
        
        if let error = dict["error"] as? Bool{
            
            if !error{
                
                if let isEditor = dict["isEditor"] as? Int{
                    self.isEditor = isEditor
                }
                
                if let newsData = dict["newsData"] as? [[String:AnyObject]]{
                    
                    var news2 = [News]()
                    for obj in newsData{
                        
                        let new = News(newsDict: obj)
                        news2.append(new)
                        
                    }
                    DispatchQueue.main.async {
                        self.news = news2
                        self.tableView.reloadData()
                        
                        if self.isEditor == 1{
                            self.circleView.isHidden = false
                        }
                        if self.activityIndicator.isAnimating {
                            self.activityIndicator.stopAnimating()
                        }
                        if self.refreshControl.isRefreshing{
                            self.refreshControl.endRefreshing()
                        }
                        
                    }
                }
                
            }
            
        }
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       if let cell = self.tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? SingleNewsTableCell{
        let new = news[indexPath.row]
        cell.delegate = self
        
        var bool = false
        
        if isEditor == 1 && newsType == .WasteRecycling {
            bool = true
        } else if isEditor == 2 && newsType == .RecyclingToday{
            bool = true
        } else{
            bool = false
        }
        cell.configCell(new: new, isEditor: bool)
        
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let new = news[indexPath.item]
        newsVC?.gotoSingleNews(newsId: new.newsId)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension WasteRecyclingCollectionCell: SingleTableViewCellDelegate{

    func editBtnPRessed(cell: SingleNewsTableCell) {
        let indexPath = self.tableView.indexPathForRow(at: cell.center)
        let alertView = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertView.view.tintColor = UIColor.GREEN_PRIMARY
       alertView.addAction(UIAlertAction(title: "Edit", style: .default, handler: { (action) in
            // Edit Action
            let new = self.news[(indexPath?.row)!]
        
        self.newsVC?.editNews(heading: new.heading ?? "" , subHeadline: new.subHeading  ?? "" , content: new.status ?? "", companyId: self.companyId)
        
        }))
        alertView.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (action) in
            self.deletApi(news: self.news[(indexPath?.row)!])
            self.news.remove(at: (indexPath?.row)!)
            self.tableView.deleteRows(at: [indexPath!], with: .fade)
        }))
        alertView.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        
        self.window?.rootViewController?.present(alertView, animated: true, completion: nil)
    }
    
    fileprivate func deletApi(news: News){
        let api = APIService()
        api.endPoint = Endpoints.DELETE_POST_URL
        api.params = "userId=\(UserDefaults.standard.value(forKey: "userid") as! String)&postId=\(news.newsId)&friendId=&apiKey=\(API_KEY)"
        
        print(news.newsId)
        
        api.getDataWith { (result) in
            
            switch result{
            case .Success( _):
                print("Sucess")
            case .Error(let message):
                print(message)
            }
        }
    }
  }
class RecyclingTodayCollectionCell: WasteRecyclingCollectionCell{
    
    override var companyId: String{ return "5041"}
    
    override fileprivate func getNews(){
        let userid = UserDefaults.standard.value(forKey: "userid") as! String
                let api = APIService()
                api.endPoint = Endpoints.NEWS_URL
                api.params = "userId=\(userid)&apiKey=\(API_KEY)&companyId=5041"
                api.getDataWith { (result) in
                    switch result{
                    case .Error(let error):
                        print(error)
                    case .Success(let data):
                        self.dealData(dict: data)
                    }
                }
    }
    
    fileprivate override func dealData(dict : [String: AnyObject]){
        
        if let error = dict["error"] as? Bool{
            
            if !error{
                
                if let isEditor = dict["isEditor"] as? Int{
                    self.isEditor = isEditor
                }
                
                if let newsData = dict["newsData"] as? [[String:AnyObject]]{
                    
                    var news2 = [News]()
                    for obj in newsData{
                        let new = News(newsDict: obj)
                        news2.append(new)
                    }
                    DispatchQueue.main.async {
                        self.news = news2
                        if self.isEditor == 2{
                            self.circleView.isHidden = false
                        }
                        self.newsType = .RecyclingToday
                        self.tableView.reloadData()
                        if self.activityIndicator.isAnimating{
                            self.activityIndicator.stopAnimating()
                        }
                        if self.refreshControl.isRefreshing{
                            self.refreshControl.endRefreshing()
                        }
                    }
                }
                
            }
            
        }
        
    }
}



*/



class NewsBarCell: UICollectionViewCell {
    
    let selectedFont = UIFont(name: "HelveticaNeue-Bold", size: 14)
    let font = UIFont(name: "HelveticaNeue-Bold", size: 14)!
    
    let label : UILabel = {
        let lbl = UILabel()
        lbl.text = "hello"
        lbl.font = UIFont(name: "HelveticaNeue", size: 14)!
        lbl.textColor = UIColor.BLACK_ALPHA
        lbl.textAlignment = .center
        lbl.adjustsFontSizeToFitWidth = true
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        
    }
    func setUpViews(){
        self.addSubview(label)
        label.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        label.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        label.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        //label.anchor(leading: leadingAnchor, trailing: trailingAnchor, top: topAnchor, bottom: bottomAnchor, padding: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10), size: CGSize(width: 100, height: 30))
    }
    override var isHighlighted: Bool{
        
        didSet{
            label.textColor = isHighlighted || isSelected ? UIColor.GREEN_PRIMARY: UIColor.BLACK_ALPHA
            label.font = isHighlighted || isSelected ? selectedFont: font
        }
    }
    override var isSelected: Bool{
        didSet{
            label.textColor = isHighlighted || isSelected ? UIColor.GREEN_PRIMARY: UIColor.BLACK_ALPHA
            label.font = isHighlighted || isSelected ? selectedFont: font
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//
//  ExchangeVC.swift
//  myscrap
//
//  Created by MS1 on 10/8/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//
import IQKeyboardManagerSwift
import UIKit
import XMPPFramework

class PricesVC: BaseRevealVC {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var pricesTask: URLSessionTask?
    
    fileprivate var lmeItems = [ShowLMEItem]()
    fileprivate var showlmeItems = [LMEItem]()
    fileprivate var comexItems = [ShowLMEItem]()
    fileprivate var shangaiItems = [ShowLMEItem]()
    fileprivate var comItems = [LMEItem]()
    fileprivate var shanItems = [LMEItem]()
    
    fileprivate var lmeTime = "-"
    fileprivate var comexTime = "-"
    fileprivate var shanghaiTime = "-"
    private let service = PriceService()
    
    lazy var refreshControl :UIRefreshControl = {
        let rf = UIRefreshControl()
        rf.addTarget(self, action: #selector(handleRefresh(_:)),for: .valueChanged)
        return rf
    }()
    var timer: Timer!
    
    
    //MARK:- VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        setupTableView()
        title = "Prices"
        lmeItems = ShowLMEItem.getPlaceHolderLME()
        comexItems = ShowLMEItem.getPlaceHolderComex()
        shangaiItems = ShowLMEItem.getPlacHolderShanghai()
        service.delegate = self
    }
    
    func goonline() {
        let xmppJid = XMPPJID(string: (XMPPService.instance.xmppStream?.myJID?.user!)! + "@myscrap.com/iOS")
        let priority = XMLElement(name: "priority", stringValue: "24")
        let element = DDXMLElement.element(withName: "presence") as! DDXMLElement
        let from = DDXMLNode.attribute(withName: "from", stringValue: "\((XMPPService.instance.xmppStream?.myJID?.user)!)@myscrap.com/iOS") as! DDXMLNode
        let type = DDXMLNode.attribute(withName: "type", stringValue: "available") as! DDXMLNode
        element.addAttribute(from)
        element.addAttribute(type)
        let pre = XMPPPresence(from: element)
        //        let p = XMPPPresence(type: "unavailable")
        pre?.addChild(priority)
        XMPPService.instance.xmppStream?.send(pre)
    }
    
    //MARK:- VIEW WILL APPEAR
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let reveal = self.revealViewController() {
            self.mBtn.target(forAction: #selector(reveal.revealToggle(_:)), withSender: self.revealViewController())
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        //        activityIndicator.startAnimating()
        timer = Timer.scheduledTimer(timeInterval: 60, target: self, selector: #selector(getData), userInfo: nil, repeats: true)
        getData()
    }
    
    //MARK:- VIEW WILL DISAPPEAR
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
        NotificationCenter.default.removeObserver(self, name: .userSignedIn, object: nil)
        pricesTask?.cancel()
    }
    
    
    //MARK:- SETUP TABLEVIEW
    private func setupTableView(){
        tableView.separatorStyle = .none
        let nib = UINib(nibName: "ExchangeHeaderView", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "ExchangeHeaderView")
        tableView.register(LMECell.nib, forCellReuseIdentifier: LMECell.identifier)
        tableView.register(ComexCell.nib, forCellReuseIdentifier: ComexCell.identifier)
        tableView.register(PricesFooterCell.nib, forCellReuseIdentifier: PricesFooterCell.identifier)
        tableView.register(LMESubscriptionCell.self)
        tableView.showsVerticalScrollIndicator = false
        tableView.addSubview(refreshControl)
    }
    
    //MARK:- REFRESH CONTROL
    @objc private func handleRefresh(_ rc: UIRefreshControl){
        if activityIndicator.isAnimating{
            activityIndicator.stopAnimating()
        }
        self.getData()
    }
    
    
    
    //MARK:- GET DATA
    @objc private func getData(){
        //pricesTask = service.fetchPrices()
        pricesTask = service.fetchLME()
    }
    @objc func postCoupon(coupon: String) {
        service.promoCheck(couponCode: coupon)
    }
    
    @IBAction func refreshButtonClicked(_ sender: UIBarButtonItem){
        if refreshControl.isRefreshing{
            refreshControl.endRefreshing()
        }
        activityIndicator.startAnimating()
        getData()
    }
    
    deinit {
        print("Prices Deinited")
    }
}

extension PricesVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && AuthStatus.instance.lmeStatus != .subscribed {
            return 110
        }
        return 20
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            if AuthStatus.instance.lmeStatus == .subscribed{
                return lmeItems.count
            } else {
                return 1
            }
        } else if section == 1{
            return comexItems.count
        } else{
            return shangaiItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 && AuthStatus.instance.lmeStatus != .subscribed {
            let cell : LMESubscriptionCell = tableView.dequeReusableCell(forIndexPath: indexPath)
            cell.status = AuthStatus.instance.lmeStatus
            print("LME status value : \(String(describing: cell.status))")
            cell.sendCoupon = {
                if cell.promoTextField.text == "" {
                    self.showToast(message: "Please fill the Promocode")
                } else {
                    self.activityIndicator.startAnimating()
                    self.postCoupon(coupon: cell.promoTextField.text!)
                }
            }
            cell.showAlert = {
                if !AuthStatus.instance.isGuest{
                    self.showAlert(indexPath: indexPath)
                } else {
                    self.showGuestAlert()
                }
            }
            return cell
        } else {
            var item: ShowLMEItem?
            let cell = tableView.dequeueReusableCell(withIdentifier: LMECell.identifier, for: indexPath) as! LMECell
            cell.backgroundColor = indexPath.row % 2 == 0 ? UIColor.white : UIColor(hexString: "#E1E0E2")
            if indexPath.section == 0{
                item = lmeItems[indexPath.row]
            } else if indexPath.section == 1{
                item = comexItems[indexPath.row]
            } else if indexPath.section == 2 {
                item = shangaiItems[indexPath.row]
            }
            cell.configLMECell(item: item)
            return cell
        }
        /*else {
         var item: LMEItem?
         let cell = tableView.dequeueReusableCell(withIdentifier: LMECell.identifier, for: indexPath) as! LMECell
         cell.backgroundColor = indexPath.row % 2 == 0 ? UIColor.white : UIColor(hexString: "#E1E0E2")
         if indexPath.section == 1{
         item = comexItems[indexPath.row]
         } else if indexPath.section == 2 {
         item = shangaiItems[indexPath.row]
         }
         cell.configCell(item: item)
         return cell
         }*/
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 && AuthStatus.instance.lmeStatus != .subscribed {
            return 0
        }
        return 25
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExchangeHeaderView") as! ExchangeHeaderView
        if section == 0 {
            cell.configHeader(first: " LME", second: " Contract", third: " Last", fourth: "Change")
        } else if section == 1 {
            cell.configHeader(first: " COMEX", second: " Month", third: " Last", fourth: "Change")
        } else {
            cell.configHeader(first: " SHANGHAI", second: " Month", third: " Last", fourth: "Change")
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 && AuthStatus.instance.lmeStatus != .subscribed{
            return 0
        }
        return 35
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: PricesFooterCell.identifier) as! PricesFooterCell
        if section == 0 {
            cell.label.text = "Last Updated London \(lmeTime)"
        } else if section == 1{
            cell.label.text = "Last Updated New York \(comexTime)"
        }else {
            cell.label.text = "Last Updated Shanghai \(shanghaiTime)"
        }
        return cell
        
    }
    
    private func showAlert(indexPath: IndexPath){
        print("row", indexPath.row)
        print("section", indexPath.section)
        
        if let vc = PricesAlertVC.storyBoardInstance(){
            vc.alert = { email in
                self.sendAlertStatus(with: email)
            }
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            vc.view.backgroundColor = UIColor.black.withAlphaComponent(0.31)
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    
    private func showInvalidEmailAlert(){
        let alert = UIAlertController(title: "Error", message: "Please enter a valid email address and try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        alert.view.tintColor = UIColor.GREEN_PRIMARY
        present(alert, animated: true, completion: nil)
    }
    
    private func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}


extension PricesVC: PriceServiceDelegate{
    
    func DidReceiveLMEItems(lme: [ShowLMEItem], comex: [ShowLMEItem], shanghai: [ShowLMEItem], lmeTime: String, newyorkTime: String, shanghaiTime: String) {
        DispatchQueue.main.async {
            self.lmeTime = lmeTime
            self.comexTime = newyorkTime
            self.shanghaiTime = shanghaiTime
            self.lmeItems = lme
            self.comexItems = comex
            self.shangaiItems = shanghai
            self.updateTableView()
        }
    }
    
    func DidReceiveLMEData(lme: [ShowLMEItem], lmeTime: String) {
        DispatchQueue.main.async {
            self.lmeTime = lmeTime
            self.lmeItems = lme
            self.updateTableView()
        }
    }
    
    func DidReceiveValidCoupon(status: String) {
        DispatchQueue.main.async {
            self.showToast(message: status)
            //AuthStatus.instance.setLMEStatus = 2
            self.getData()
            self.updateTableView()
        }
    }
    
    func DidReceiveError(error: String) {
        DispatchQueue.main.async {
            self.showToast(message: error)
            print("error")
            self.updateTableView()
        }
    }
    
    /*func DidReceiveItems(comex: [LMEItem], shanghai: [LMEItem], newyorkTime: String, shanghaiTime: String) {
     DispatchQueue.main.async {
     //self.lmeTime = lmeTime
     self.comexTime = newyorkTime
     self.shanghaiTime = shanghaiTime
     //self.lmeItems = lme
     self.comexItems = comex
     self.shangaiItems = shanghai
     self.updateTableView()
     }
     }*/
    
    private func updateTableView(){
        if activityIndicator.isAnimating{
            activityIndicator.stopAnimating()
        }
        if refreshControl.isRefreshing{
            refreshControl.endRefreshing()
        }
        tableView.reloadData()
    }
    
    
    func sendAlertStatus(with email: String){
        if let window = UIApplication.shared.keyWindow {
            
            let overlay = UIView(frame: CGRect(x: window.frame.origin.x, y: window.frame.origin.y, width: window.frame.width, height: window.frame.height))
            overlay.alpha = 0.5
            overlay.backgroundColor = UIColor.black
            window.addSubview(overlay)
            
            let av = UIActivityIndicatorView(style: .whiteLarge)
            av.center = overlay.center
            av.startAnimating()
            overlay.addSubview(av)
            
            service.subscribeLME(email: email) { (success, item )  in
                DispatchQueue.main.sync {
                    av.stopAnimating()
                    overlay.removeFromSuperview()
                    if let items = item{
                        self.lmeTime = items.lmeTime
                        self.comexTime = items.newyorkTime
                        self.shanghaiTime = items.shanghaiTime
                        self.showlmeItems = items.lme
                        self.comItems = items.comex
                        self.shanItems = items.shanghai
                    }
                    self.updateTableView()
                }
            }
        }
    }
    
    static func storyBoardInstance() -> PricesVC?{
        let st = UIStoryboard(name: StoryBoard.MAIN, bundle: nil)
        return st.instantiateViewController(withIdentifier: "PricesVC") as? PricesVC
    }
}

class LMESubscriptionCell: UITableViewCell{
    
    typealias Alert = () -> Void
    typealias Coupon = () -> Void
    
    var showAlert: Alert?
    var sendCoupon: Coupon?
    
    var status: LMEStatus? {
        didSet{
            if let st = status {
                if st == .requested {
                    btn.setTitle("Requested", for: .normal)
                    btn.isUserInteractionEnabled = false
                } else if st == .subscribed {
                    print("Subscribed")
                } else if st == .unsubscribed {
                    btn.setTitle("Subscribe to LME", for: .normal)
                    btn.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    let btn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Subscribe to LME", for: .normal)
        btn.titleLabel?.font = Fonts.NAVIGATION_FONT
        btn.backgroundColor = UIColor.MyScrapGreen
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let promoTextField: UITextField = {
        let tf = UITextField()
        tf.autocapitalizationType = .allCharacters
        tf.autocorrectionType = .no
        tf.returnKeyType = .done
        let color: UIColor = UIColor.MyScrapGreen
        tf.layer.borderWidth = 1
        tf.layer.borderColor = color.cgColor
        tf.borderStyle = .roundedRect
        tf.layer.cornerRadius = 2
        tf.layer.masksToBounds = true
        tf.placeholder = "Enter Promo Code"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let applyBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Apply", for: .normal)
        btn.titleLabel?.font = Fonts.NAVIGATION_FONT
        btn.backgroundColor = UIColor.MyScrapGreen
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews(){
        backgroundColor = UIColor.white
        
        addSubview(btn)
        btn.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -30).isActive = true
        
        
        btn.setHorizontantalCenter(to: self)
        btn.setSize(size: CGSize(width: frame.width * 0.80, height: 35))
        btn.addTarget(self, action: #selector(subscribeLMETapped(_:)), for: .touchUpInside)
        btn.layer.cornerRadius = 2
        btn.layer.masksToBounds = true
        
        addSubview(promoTextField)
        promoTextField.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 22).isActive = true
        promoTextField.anchor(leading: btn.leadingAnchor, trailing: nil, top: nil, bottom: nil)
        //promoTextField.setHorizontantalCenter(to: self)
        promoTextField.setSize(size: CGSize(width: frame.width * 0.60, height: 35))
        
        addSubview(applyBtn)
        applyBtn.anchor(leading: nil, trailing: btn.trailingAnchor, top: promoTextField.topAnchor, bottom: nil)
        
        
        
        applyBtn.setSize(size: CGSize(width: frame.width * 0.21, height: 35))
        applyBtn.addTarget(self, action: #selector(applyBtnTapped(_:)), for: .touchUpInside)
        applyBtn.layer.cornerRadius = 2
        //applyBtn.layer.masksToBounds = true
        if promoTextField.returnKeyType == .done {
            promoTextField.resignFirstResponder()
        }
    }
    
    @objc
    func subscribeLMETapped(_ sender: UIButton){
        if let alert = showAlert{
            alert()
        }
    }
    
    @objc
    func applyBtnTapped(_ sender: UIButton) {
        if let coupon = sendCoupon{
            coupon()
        }
    }
    
}

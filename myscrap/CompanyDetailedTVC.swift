//
//  CompanyDetailedTVC.swift
//  myscrap
//
//  Created by MyScrap on 6/18/19.
//  Copyright © 2019 MyScrap. All rights reserved.
//

import UIKit
import Cosmos

class CompanyDetailedTVC: UITableViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var companyId : String?
    @IBOutlet weak var photoCV: UICollectionView!
    @IBOutlet weak var star: CosmosView!
    @IBOutlet weak var verifiedImg: UIButton!
    @IBOutlet weak var verifiedLbl: UILabel!
    @IBOutlet weak var yearImg: UIButton!
    @IBOutlet weak var yearLbl: UILabel!
    @IBOutlet weak var designationLbl: UILabel!
    @IBOutlet weak var affliationBtn: CorneredButton!
    @IBOutlet weak var tabCV: UICollectionView!
    @IBOutlet weak var horizontalBar : UIView!
    @IBOutlet weak var horizontalBarWidthConstraint: NSLayoutConstraint?
    @IBOutlet weak var horizontalBarleftConstraint: NSLayoutConstraint?
    @IBOutlet weak var scrollView : UIScrollView!
    
    var titleArray = ["OVERVIEW", "EMPLOYEES", "REVIEWS", "PHOTOS", "INTEREST"]
    
    var service = CompanyUpdatedService()
    var dataSource = [CompanyItems]()
    weak var delegate: CompanyUpdatedServiceDelegate?
    
    let activityIndicator: UIActivityIndicatorView = {
        let av = UIActivityIndicatorView(style: .gray)
        av.hidesWhenStopped = true
        av.translatesAutoresizingMaskIntoConstraints = false
        return av
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationItem.hidesBackButton = false
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        print("Company id : \(companyId)")
    
        
        view.addSubview(activityIndicator)
        activityIndicator.setTop(to: view.safeTop, constant: 30)
        activityIndicator.setHorizontalCenter(to: view.centerXAnchor)
        activityIndicator.setSize(size: CGSize(width: 30, height: 30))
        activityIndicator.startAnimating()
        service.getCompanyDetails(companyId: companyId!)
        service.delegate = self
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func setupCollectionView() {
        photoCV.delegate = self
        photoCV.dataSource = self
        
        photoCV.register(PhotoScrollCVCell.self, forCellWithReuseIdentifier: "photoScroll")
        
        scrollView.delegate = self
        tabCV.dataSource = self
        tabCV.delegate = self
        tabCV.register(TabBarScrollCVCell.self, forCellWithReuseIdentifier: "tabScroll")
        //collectionView.register(TabBarScrollCVCell.self)
        
        if let flowLayout = tabCV.collectionViewLayout as? UICollectionViewFlowLayout{
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.scrollDirection = .horizontal
        }
        tabCV.isPagingEnabled = true
        tabCV.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: .bottom)
        
        
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if dataSource.count != 0 {
            return 3
        } else {
            return 0
        }
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /*if indexPath.row == 0 {
            let cell : ComapnyPhotoCell = tableView.dequeueReusableCell(withIdentifier: "photoCell") as! ComapnyPhotoCell
            cell.companyData = dataSource[indexPath.item]
            cell.delegate = self
            return cell
        } else if indexPath.row == 1 {
            let cell : CompanyRatingCell = tableView.dequeueReusableCell(withIdentifier: "ratingCell") as! CompanyRatingCell
            let row = indexPath.row
            print("Cell : \(cell.self.designationLbl)")
            
            cell.designationLbl?.text = dataSource[0].interest[0].industry.last
            cell.affliBtn.setTitle(dataSource[0].interest[0].affiliation.last, for: .normal)
            cell.star.text = " (" + dataSource[0].totalReview + ")"
            let verified = dataSource[0].verified
            if verified == true {
                cell.verifiedImg.isHidden = false
                cell.verifiedLbl.isHidden = false
            } else {
                cell.verifiedImg.isHidden = true
                cell.verifiedLbl.isHidden = true
            }
            let years = dataSource[0].years
            if years == "" {
                cell.yearsLbl.isHidden = true
                cell.yearsImg.isHidden = true
            } else {
                cell.yearsLbl.isHidden = false
                cell.yearsImg.isHidden = false
                cell.yearsLbl.text = years + " Years"
            }
            
            return cell
        } else {
            return UITableViewCell()
        }*/
        return UITableViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == tabCV {
            print("Count : \(titleArray.count)")
            return titleArray.count
        } else {
            return dataSource.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == tabCV {
            let cell: TabBarScrollCVCell = collectionView.dequeueReusableCell(withReuseIdentifier: "tabScroll", for: indexPath) as! TabBarScrollCVCell
            print("Arra y values : \(titleArray[indexPath.item])")
            cell.label.text = titleArray[indexPath.item]
            return cell
        } else {
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == tabCV {
            let xOffset = self.scrollView.frame.width * CGFloat(indexPath.item)
            let point = CGPoint(x: xOffset, y: 0)
            self.scrollView.setContentOffset(point, animated: true)
        } else {
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == tabCV {
            let num = CGFloat(titleArray.count)
            print("Delegate : \(num)")
            return CGSize(width: self.view.frame.width / num, height: collectionView.frame.height)
        } else {
            return CGSize(width: 258, height: 250)
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == self.scrollView else { return }
        let num = CGFloat(titleArray.count)
        horizontalBarleftConstraint?.constant = self.scrollView.contentOffset.x / num
        print(self.scrollView.contentOffset)
    }
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        guard scrollView == self.scrollView else { return }
        let index = targetContentOffset.pointee.x / self.view.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        tabCV.selectItem(at: indexPath, animated: true, scrollPosition: [])
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    static func storyBoardInstance() -> CompanyDetailedTVC? {
        let st = UIStoryboard(name: "Companies", bundle: nil)
        return st.instantiateViewController(withIdentifier: CompanyDetailedTVC.id) as? CompanyDetailedTVC
    }

}

extension CompanyDetailedTVC: CompanyUpdatedServiceDelegate {
    func DidReceivedError(error: String) {
        print("Error while receiving company data : \(error)")
    }
    
    func didReceiveCompanyValues(data: [CompanyItems]) {
        DispatchQueue.main.async {
            self.dataSource = data
            self.photoCV.reloadData()
            self.tabCV.reloadData()
            if self.activityIndicator.isAnimating{
                self.activityIndicator.stopAnimating()
            }
        }
    }
}


//
//  AboutTableViewCell.swift
//  myscrap
//
//  Created by MyScrap on 12/6/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol CellDelegate: class {
    func contentDidChange(cell: AboutTableViewCell)
}

class AboutTableViewCell: UITableViewCell, CLLocationManagerDelegate, MKMapViewDelegate{
    
    
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var centerLabel: UILabel!
    
    @IBOutlet weak var mapBtn: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    
    @IBOutlet weak var mapViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftLblWidthConstraint: NSLayoutConstraint!
    
   
    @IBOutlet weak var centerLblHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var centerLblWidthConstaint: NSLayoutConstraint!
    
    
    var actionBlock: (() -> Void)? = nil
    // Initialize an empty array of integers
    var expandedCells = [Int]()
    weak var delegate: CellDelegate?
    
    let locationManager = CLLocationManager()
    
    /*var fromLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = Fonts.DESIG_FONT
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    private let hereLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = Fonts.DESIG_FONT
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    private let interestLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = Fonts.DESIG_FONT
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    private let imLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = Fonts.DESIG_FONT
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    private let joinLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = Fonts.DESIG_FONT
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    var fromResultLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = Fonts.DESIG_FONT
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    private let hereResultLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = Fonts.DESIG_FONT
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    private let interestResultLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = Fonts.DESIG_FONT
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    private let imResultLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = Fonts.DESIG_FONT
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    private let joinResultLbl: UILabel = {
        let lbl = UILabel()
        lbl.font = Fonts.DESIG_FONT
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    var button: UIButton = {
        let btn = UIButton()
        btn.setTitle("[Show on map]", for: .normal)
        btn.tintColor = UIColor.black.withAlphaComponent(0.1)
        btn.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let mapView: MKMapView = {
        let mapView = MKMapView()
        
        mapView.mapType = MKMapType.standard
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        
        return mapView
    }()*/
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        // Initialization code
        
        
        /*self.addSubview(fromLbl)
        fromLbl.anchor(leading: leadingAnchor, trailing: nil, top: nil, bottom: nil, size: CGSize(width: 100, height: 20))
        
        
        self.addSubview(fromResultLbl)
        fromResultLbl.anchor(leading: fromLbl.trailingAnchor, trailing: nil, top: nil, bottom: nil, size: CGSize(width: 200, height: 20))
        
        self.addSubview(button)
        button.anchor(leading: fromResultLbl.trailingAnchor, trailing: nil, top: nil, bottom: nil, padding: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0))
        
        self.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        fromLbl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        fromResultLbl.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
 */
    }
    
    @IBAction func showMapTapped(_ sender: UIButton) {
        if sender.tag == 0 {
            mapViewHeightConstraint.constant = 179
            sender.tag = 1
            mapBtn.setTitle("[Hide Map]", for: .normal)
            actionBlock?()
            //delegate?.contentDidChange(cell: self)
        } else if sender.tag == 1 {
            mapViewHeightConstraint.constant = 0
            sender.tag = 0
            mapBtn.setTitle("[Show on Map]", for: .normal)
            actionBlock?()
            //delegate?.contentDidChange(cell: self)
        }
        
        
        // If the array contains the button that was pressed, then remove that button from the array
        /*if expandedCells.contains(sender.tag) {
            expandedCells = expandedCells.filter({ $0 != sender.tag})
        }
            // Otherwise, add the button to the array
        else {
            expandedCells.append(sender.tag)
        }*/
        
        
    }
    
    func configCell(item: ProfileData) {
        
        
        
        /*fromLbl.text = "I'm from :"
        hereLbl.text = "I'm here to :"
        interestLbl.text = "I'm interested in :"
        imLbl.text = "I'm :"
        joinLbl.text = "Member since :"*/
        
        /*fromResultLbl.text = item.city + " " + item.country
        hereResultLbl.text = item.userType
        interestResultLbl.text = item.memInterest.joined(separator: " / ")
        imResultLbl.text = item.memRoles.joined(separator: " / ")
        joinResultLbl.text = item.joinedDateNew*/
        
        
    }

    @objc private func buttonAction() {
        /*let leftMargin:CGFloat = 10
        let topMargin:CGFloat = 60
        let mapWidth:CGFloat = self.frame.size.width-20
        let mapHeight:CGFloat = 300
        
        mapView.frame = CGRect(x: leftMargin, y: topMargin, width: mapWidth, height: mapHeight)*/
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  MapVCPopUp.swift
//  myscrap
//
//  Created by MS1 on 8/1/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import UIKit
import MapKit

class MapVCPopUp: BaseVC {

    
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    
    
    
    
    
    var lattitude: Double = 100
    var longitude: Double = 100
    
    var maptitle: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        mapView.delegate = self
        
        
        popUpView.layer.cornerRadius = 10.0
        popUpView.layer.masksToBounds = true
        popUpView.layer.borderColor = UIColor.GREEN_PRIMARY.withAlphaComponent(0.8).cgColor
        popUpView.layer.borderWidth = 2.0
        
        animateView()
        
        addAnnotation()

        // Do any additional setup after loading the view.
        
        
        
        
        
        
    }
    
    func addAnnotation(){
        
        let coordinates = CLLocationCoordinate2DMake(lattitude, longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinates
        annotation.title = maptitle
        mapView.addAnnotation(annotation)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.0275, longitudeDelta:  0.0275)
        let region = MKCoordinateRegion(center: coordinates, span: span)
        
        self.mapView.setRegion(region, animated: true)
        
        mapView.selectAnnotation(annotation, animated: true)
        
    }
    
    func animateView(){
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 1, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func closePressed(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }

}

extension MapVCPopUp: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "Pin"
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if view == nil {
            view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            
            
            let pinImage = #imageLiteral(resourceName: "pin")
            let size = CGSize(width: 40, height: 40)
            UIGraphicsBeginImageContext(size)
            
            
            pinImage.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            
            view?.image = resizedImage
            
            let rightButton: AnyObject! = UIButton(type: UIButton.ButtonType.detailDisclosure)
            
            view?.rightCalloutAccessoryView = rightButton as? UIView
            
            view?.rightCalloutAccessoryView?.tintColor = UIColor.GREEN_PRIMARY
            
            
            //   view?.pinTintColor = color
            view?.canShowCallout = true
            
            
        } else {
            view?.annotation = annotation
        }
        
        return view

    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        
        let coordinte = CLLocationCoordinate2DMake(lattitude, longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.0275, longitudeDelta: 0.0275)
        let region = MKCoordinateRegion(center: coordinte, span: span)
        
        
        let placemark = MKPlacemark(coordinate: coordinte, addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        let options = [
            MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: region.center),
            MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: region.span)]
        mapItem.name = maptitle
        mapItem.openInMaps(launchOptions: options)
        
    }
    
    
    
    static func storyBoardInstance() -> MapVCPopUp? {
        let st = UIStoryboard(name: "Companies", bundle: nil)
        return st.instantiateViewController(withIdentifier: "MapVCPopUp") as? MapVCPopUp
    }
    
}




















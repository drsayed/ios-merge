
//
//  DiscoverVC-Helper.swift
//  myscrap
//
//  Created by MS1 on 1/15/18.
//  Copyright © 2018 MyScrap. All rights reserved.
//

import UIKit
import MapKit


extension DiscoverVC{
    
    private var location: CLLocation?{
        return LocationService.sharedInstance.location
    }
    
    private var isLocationEnabled: Bool{
        return LocationService.sharedInstance.isLocationEnabled()
    }

    func setupMapView(){
        mapView.delegate = self
        mapView.showsCompass = true
        mapView.showsUserLocation = true
        mapView.tintColor = UIColor.GREEN_PRIMARY
    
        //clusterManager.cellSize = nil
        _ = clusterManager.cellSize(for: 0.0)
        clusterManager.maxZoomLevel = 17
        clusterManager.minCountForClustering = 3
        clusterManager.shouldRemoveInvisibleAnnotations = false
        clusterManager.clusterPosition = .nearCenter
        setLocation(false)
    }
    
    func setLocation(_ animated: Bool){
        guard isLocationEnabled , let location = location else {
            mapView.setCenter(CLLocationCoordinate2D(latitude: 25.2048, longitude: 55.2708), animated: animated)
            return
        }
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        mapView.setCenter(coordinate, animated: animated)
    }
    
    func addMarkers(data: [DiscoverItems]){
      
        if !data.isEmpty {
            for item in data{
                let annotation = DiscoverAnnotaion()
                annotation.coordinate = CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude)
                annotation.style = ClusterAnnotationStyle.color(UIColor.GREEN_PRIMARY, radius: 25)
                annotation.title = item.name
                annotation.companyId = item.id
                clusterManager.add(annotation)
            }
            if let location = LocationService.sharedInstance.location{
                let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                mapView.setCenter(coordinate, animated: true)
            }
        }
    }
}

extension DiscoverVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? ClusterAnnotation {
            guard let style = annotation.style else { return nil }
            let identifier = "Cluster"
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            if let view = view as? BorderedClusterAnnotationView {
                view.annotation = annotation
                view.configure(with: style)
            } else {
                view = BorderedClusterAnnotationView(annotation: annotation, reuseIdentifier: identifier, style: style, borderColor: .white)
            }
            return view
        } else {
            
            guard let annotation = annotation as? DiscoverAnnotaion, !annotation.isEqual(mapView.userLocation) else { return nil }
            let identifier = "Pin"
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? DiscoverAnnotationView
            if let view = view {
                view.annotation = annotation
            } else {
                view = DiscoverAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            }
            return view
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        //clusterManager.reload(mapView, visibleMapRect: mapView.visibleMapRect)
        //clusterManager.reload(mapView: mapView) { finished in
            //print(finished)
        //}
        clusterManager.reload(mapView: mapView)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else { return }
        
        if let cluster = annotation as? ClusterAnnotation {
            var zoomRect = MKMapRect.null
            for annotation in cluster.annotations {
                let annotationPoint = MKMapPoint(annotation.coordinate)
                let pointRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0, height: 0)
                if zoomRect.isNull {
                    zoomRect = pointRect
                } else {
                    zoomRect = zoomRect.union(pointRect)
                }
            }
            mapView.setVisibleMapRect(zoomRect, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        views.forEach { $0.alpha = 0 }
        UIView.animate(withDuration: 0.35, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            views.forEach { $0.alpha = 1 }
        }, completion: nil)
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {

        /*
        if let annotationView = view as? DiscoverAnnotationView, let annotation = annotationView.annotation as? DiscoverAnnotaion, let id = annotation.companyId, let vc = CompanyDetailVC.storyBoardInstance() {
            vc.companyId = id
            UserDefaults.standard.set(vc.companyId, forKey: "companyId")
            self.navigationController?.pushViewController(vc, animated: true)
        }*/
        if let annotationView = view as? DiscoverAnnotationView, let annotation = annotationView.annotation as? DiscoverAnnotaion, let id = annotation.companyId, let vc = CompanyHeaderModuleVC.storyBoardInstance() {
            vc.companyId = id
            UserDefaults.standard.set(vc.companyId, forKey: "companyId")
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

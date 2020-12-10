//
//  Locataion.swift
//  myscrap
//
//  Created by MS1 on 8/17/17.
//  Copyright © 2017 MyScrap. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

final class LocationService:NSObject, CLLocationManagerDelegate  {
    
    static var sharedInstance = LocationService()
    private override init() {}

    
    var locationManager = CLLocationManager()
    
    var timer : Timer?
    
    
     var location:CLLocation?
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        NotificationCenter.default.post(name: .locationAuthorisationChanged, object: nil)
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
    }
    
    func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    
    func isLocationEnabled() -> Bool{
        if CLLocationManager.locationServicesEnabled(){
            let status = CLLocationManager.authorizationStatus()
            switch status {
            case .notDetermined , .restricted , .denied:
                return false
            case .authorizedWhenInUse, .authorizedAlways:
                return true
            }
        } else {
            return false
        }
    }
    
    
    func processLocation(){
            if let location = location {
                if AuthStatus.instance.isLoggedIn && isLocationEnabled() {
                    let api = APIService()
                    api.endPoint = Endpoints.UPDATE_LOCATION_URL
                    api.params = "userId=\(AuthService.instance.userId)&lat=\(location.coordinate.latitude)&lng=\(location.coordinate.longitude)"
                    api.getDataWith(completion: { (result) in
                        print("Location update response: \n",result)
                    })
                }
            }
        if timer == nil{
            timer = Timer.scheduledTimer(withTimeInterval: 900, repeats: true, block: { (timer) in
                self.processLocation()
            })
        } else {
            print("timer is running")
        }
        
        
    }
    
}



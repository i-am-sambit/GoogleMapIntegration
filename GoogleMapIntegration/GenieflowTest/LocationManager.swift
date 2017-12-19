//
//  LocationManager.swift
//  GoogleMapIntegration
//
//  Created by GLB-311-PC on 14/12/17.
//  Copyright © 2017 Globussoft. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

extension CLLocationManager {
    
    // MARK: - check location authorisation
    /*
     * It will check wheather user has given access to use location
     * If authorization status is notDetermined then it will request for authorization
     * If authorization status is denied then it will ask user to go to settings and set on permission
     * If authorization status is authorizedWhenInUse or authorizedAlways then it will update location
     */
    func checkLocationAuthorisation() -> Void {
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            self.requestAlwaysAuthorization()
        }
        else if CLLocationManager.authorizationStatus() == .denied {
            UIAlertView(title: "Location Not Enable", message: "GinieflowTest does not have permission to get location. Please enable location in settings panel", delegate: nil, cancelButtonTitle: "Okay").show()
        }
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways {
            updatingLocation()
        }
    }
    
    
    // MARK: - set user location
    func setUserLocation() -> Void {
        
        if CLLocationManager.locationServicesEnabled() {
            updatingLocation()
        }
        else {
            UIAlertView(title: "Location Not Enable", message: "GinieflowTest does not have permission to get location. Please enable location in settings panel", delegate: nil, cancelButtonTitle: "Okay").show()
        }
    }
    
    // MARK: - updating location
    func updatingLocation() {
        startUpdatingLocation()
    }
}

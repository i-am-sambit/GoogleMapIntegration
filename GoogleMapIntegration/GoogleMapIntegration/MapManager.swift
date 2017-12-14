//
//  MapManager.swift
//  GoogleMapIntegration
//
//  Created by GLB-311-PC on 14/12/17.
//  Copyright © 2017 Globussoft. All rights reserved.
//

import Foundation
import MapKit

extension MKMapView {
    
    func getLocationDetails(locationCoordinate: CLLocationCoordinate2D, complitionHandler: @escaping (String?) -> Void) -> Void {
        
        let location: CLLocation = CLLocation(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            
            for placemark in placemarks! {
                
                guard let address = placemark.addressDictionary else { return }
                
                print(address)
                
                guard let locality = placemark.locality else { return }
                
                guard let subLocality = placemark.subLocality else { return }
                
                guard let name = placemark.name else { return }
                
                let locationDetails = "\(locality), \(subLocality), \(name)"
                complitionHandler(locationDetails)
            }
        })
    }
}

//
//  MapManager.swift
//  GoogleMapIntegration
//
//  Created by GLB-311-PC on 14/12/17.
//  Copyright © 2017 Globussoft. All rights reserved.
//

import Foundation
import MapKit
import GoogleMaps

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

extension GMSMapView {
    
    func getLocationDetails(locationCoordinate: CLLocationCoordinate2D, complitionHandler: @escaping (String?, String?, String?) -> Void) -> Void {
        
        let location: CLLocation = CLLocation(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            
            for placemark in placemarks! {
                
                guard let address = placemark.addressDictionary else { return }
                
                print(address)
                
                guard let name = placemark.name else {
                    complitionHandler("", "", "")
                    return
                }
                
                guard let subLocality = placemark.subLocality else {
                    complitionHandler(name, "", "")
                    return
                }
                
                guard let locality = placemark.locality else {
                    complitionHandler(name, subLocality, "")
                    return
                }
                
                complitionHandler(name, subLocality, locality)
            }
        })
    }
    
    // MARK:- show marker
    /**
     * Show marker will show a location with marker
     * It will remove all the markers present on mapview
     * then it will create an instance of marker and place it on mapview
     */
    func showMarker(coordinate: CLLocationCoordinate2D, placeName: String, placeAddress: String) -> Void {
        
        self.clear()
        
        let markerImage = UIImage(named: "LocationPin")?.withRenderingMode(.alwaysTemplate)
        let markerImageView = UIImageView(image: markerImage)
        markerImageView.tintColor = .red
        
        let marker = GMSMarker(position: coordinate)
        marker.title = placeName
        marker.snippet = placeAddress
        marker.icon = markerImage
        marker.map = self
        self.animate(toLocation: coordinate)
    }
}

//
//  PlaceManager.swift
//  GoogleMapIntegration
//
//  Created by GLB-311-PC on 16/12/17.
//  Copyright © 2017 Globussoft. All rights reserved.
//

import Foundation
import GooglePlaces
import CoreLocation

extension GMSPlacesClient {
    
    func getPlaceDetailsFromPlaceId(placeID: String, complitionHandler: @escaping (NSDictionary?, Error?) -> Void) -> Void {
        
        self.lookUpPlaceID(placeID, callback: { (place, error) -> Void in
            if let error = error {
                complitionHandler(nil, NSError.placeError(errorMessage: error.localizedDescription))
                return
            }
            
            guard let place = place else {
                print("No place details for \(placeID)")
                complitionHandler(nil, NSError.noPlaceFound(placeId: placeID))
                return
            }
            
            print("Place name \(place.name)")
            print("Place address \(String(describing: place.formattedAddress))")
            print("Place placeID \(place.placeID)")
            print("Place attributions \(String(describing: place.attributions))")
            print(place.coordinate)
            
            let placeDetails: NSDictionary = ["name": place.name, "address" : place.formattedAddress ?? "", "coordinates": CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)]
            complitionHandler(placeDetails, nil)
        })
    }
}

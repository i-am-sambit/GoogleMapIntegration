//
//  ViewController.swift
//  GoogleMapIntegration
//
//  Created by GLB-311-PC on 13/12/17.
//  Copyright © 2017 Globussoft. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var placeInformationView: UIView!
    
    @IBOutlet weak var myLocationButton: UIButton!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    var locationManager: CLLocationManager = CLLocationManager()
    
    private let initialLocation = CLLocation.init(latitude: 21.282778, longitude: -157.829444)
    private let regionRadius: CLLocationDistance = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        centerMapOnLocation(location: initialLocation)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /* 
         * It will check wheather user has given access to use location 
         * If authorization status is notDetermined then it will request for authorization
         * If authorization status is denied then it will ask user to go to settings and set on permission
         * If authorization status is authorizedWhenInUse or authorizedAlways then it will update location
         */
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        }
        else if CLLocationManager.authorizationStatus() == .denied {
            
        }
        else if CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways {
            startUpdatingLocation()
        }
    }
    
    // MARK: - center map on location
    /*
     * Set region on map view
     */
    func centerMapOnLocation(location: CLLocation) -> Void {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    // MARK: - set user's current location
    /*
     * get user current location and show user's location on map
     * then it will start updating map region
     */
    @IBAction func setCurrentLocation(_ sender: UIButton) {
        
        if CLLocationManager.locationServicesEnabled() {
            
            if locationManager.responds(to: #selector(CLLocationManager.requestAlwaysAuthorization)) {
                locationManager.requestAlwaysAuthorization()
                
                UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: .beginFromCurrentState, animations: {
                    
                    self.placeInformationView.frame = CGRect(x: 0, y: self.view.frame.size.height - self.placeInformationView.frame.size.height - 20, width: self.placeInformationView.frame.size.width, height: self.placeInformationView.frame.size.height)
                    
                    self.myLocationButton.frame = CGRect(x: self.myLocationButton.frame.origin.x, y: (self.placeInformationView.frame.origin.y - self.myLocationButton.frame.size.height - 20), width: self.myLocationButton.frame.size.width, height: self.myLocationButton.frame.size.height)
                }, completion: { (completed: Bool) in
                    
                })
            }
            else {
                
            }
            startUpdatingLocation()
        }
    }
    
    
    // MARK: - start updating location
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    
    // MARK: - tap on map action
    /*
     * tap on map action
     */
    @IBAction func tapOnMapAction(_ sender: UITapGestureRecognizer) {
        
        let touchPoint = sender.location(in: self.mapView)
        let locationCoordinate: CLLocationCoordinate2D = self.mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
        getCityName(locationCoordinate: locationCoordinate)
    }
    
    func getCityName(locationCoordinate: CLLocationCoordinate2D) -> Void {
        
        let location: CLLocation = CLLocation(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            
            for placemark in placemarks! {
                
                guard let address = placemark.addressDictionary else { return }
                
                print(address)
                
                guard let locality = placemark.locality else { return }
                
                guard let subLocality = placemark.subLocality else { return }
                
                guard let name = placemark.name else { return }
                
                self.locationLabel.text = "\(locality), \(subLocality), \(name)"
            }
        })
    }
    
    
    // MARK: - CLLocationManagerDelegate
    //Updated location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        //Get last updated location(current)
        let location = locations.last! as CLLocation
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.20, longitudeDelta: 0.20))
        
        //Set region of current location in map view with zooming
        self.mapView.setRegion(region, animated: true)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

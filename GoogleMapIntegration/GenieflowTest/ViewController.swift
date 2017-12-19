//
//  ViewController.swift
//  GoogleMapIntegration
//
//  Created by GLB-311-PC on 13/12/17.
//  Copyright © 2017 Globussoft. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import GooglePlaces

class ViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var placeInformationView: UIView!
    
    @IBOutlet weak var myLocationButton: UIButton!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    
    var searchController: SearchLocationTableViewController = {
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "SearchLocationTableViewController") as! SearchLocationTableViewController
        return viewController
    }()
    
    var locationManager: CLLocationManager = CLLocationManager()
    
    var gmsFetcher: GMSAutocompleteFetcher?
    
    private let initialLocation = CLLocation.init(latitude: 21.282778, longitude: -157.829444)
    private let regionRadius: CLLocationDistance = 1000
    
    fileprivate var placeDetails: [String: Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set location manager property
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
        
        // Create an camera instance
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 10.0)
        
        // Assign camera instance to mapview and set other properties to mapview
        mapView.camera = camera
        mapView.delegate = self
//        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        
        // instantiate gmsFetcher and set delegate
        gmsFetcher = GMSAutocompleteFetcher()
        gmsFetcher?.delegate = self
        
        // add search controller here and hide the container view
        searchController.delegate = self
        containerView.add(asChildViewController: searchController, parentViewController: self)
        containerView.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.checkLocationAuthorisation()
    }
    
    // MARK: - set user's current location
    /*
     * get user current location and show user's location on map
     * then it will start updating map region
     */
    @IBAction func setCurrentLocation(_ sender: UIButton) {
        locationManager.setUserLocation()
    }
    
    
    @IBAction func setAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "pickupSegue", sender: self.placeDetails)
    }
    
    
    func showPlaceDetailsView() -> Void {
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: .beginFromCurrentState, animations: {
            
            self.placeInformationView.frame = CGRect(x: self.placeInformationView.frame.origin.x, y: self.view.frame.size.height - self.placeInformationView.frame.size.height - 30, width: self.placeInformationView.frame.size.width, height: self.placeInformationView.frame.size.height)
            
            self.myLocationButton.frame = CGRect(x: self.myLocationButton.frame.origin.x, y: (self.placeInformationView.frame.origin.y - self.myLocationButton.frame.size.height - 20), width: self.myLocationButton.frame.size.width, height: self.myLocationButton.frame.size.height)
        }, completion: { (completed: Bool) in
            
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "pickupSegue" {
            
            let pickupAddressViewcontroller = segue.destination as! PickupAddressViewController
            pickupAddressViewcontroller.pickupLocationDetails = sender as! [String : Any]!
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    // MARK: - CLLocationManagerDelegate
    //Updated location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last! as CLLocation
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        self.mapView.getLocationDetails(locationCoordinate: coordinate) { (name, subLocality, locality) in
            
            let placeDetails: NSDictionary = ["name": name!, "address" : "\(subLocality!), \(locality!)", "coordinates": CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)]
            self.placeDetails = placeDetails as? [String : Any]
            
            self.locationLabel.text = "\(name!), \(subLocality!), \(locality!)"
            self.mapView.showMarker(coordinate: coordinate, placeName: name!, placeAddress: "\(subLocality!), \(locality!)")
            self.showPlaceDetailsView()
            manager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to retrive user coordinates")
        print(error)
    }
}

extension ViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        self.mapView.getLocationDetails(locationCoordinate: coordinate) { (name, subLocality, locality) in
            
            let placeDetails: NSDictionary = ["name": name!, "address" : "\(subLocality!), \(locality!)", "coordinates": CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)]
            self.placeDetails = placeDetails as? [String : Any]
            
            self.locationLabel.text = "\(name!), \(subLocality!), \(locality!)"
            self.mapView.showMarker(coordinate: coordinate, placeName: name!, placeAddress: "\(subLocality!), \(locality!)")
            self.showPlaceDetailsView()
        }
    }
}

extension ViewController: UISearchBarDelegate, GMSAutocompleteFetcherDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        gmsFetcher?.sourceTextHasChanged(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        
        searchController.locations = predictions
        searchController.tableView.reloadData()
        containerView.isHidden = false
    }
    
    func didFailAutocompleteWithError(_ error: Error) {
        
    }
}

extension ViewController: SearchLocationDelegate {
    
    func selectedUserLocation(location: GMSAutocompletePrediction) {
        
        self.containerView.isHidden = true
        
        GMSPlacesClient().getPlaceDetailsFromPlaceId(placeID: location.placeID!) { (place, error) in
            
            guard let placeDetails = place else {
                return
            }
            
            self.placeDetails = placeDetails as? [String : Any]
            
            self.locationLabel.text = "\(placeDetails.object(forKey: "name") as! String) \(placeDetails.object(forKey: "address") as! String)"
            self.mapView.showMarker(coordinate: (placeDetails.object(forKey: "coordinates") as! CLLocation).coordinate, placeName: placeDetails.object(forKey: "name") as! String , placeAddress: placeDetails.object(forKey: "address") as! String)
            self.showPlaceDetailsView()
            self.locationManager.stopUpdatingLocation()
        }
    }
}


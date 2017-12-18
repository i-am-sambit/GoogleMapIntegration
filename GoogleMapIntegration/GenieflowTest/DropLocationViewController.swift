//
//  DropLocationViewController.swift
//  GenieflowTest
//
//  Created by Neeraj Sonaro on 17/12/17.
//  Copyright © 2017 SambitPrakash. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation

class DropLocationViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var locationInfoView: UIView!
    
    @IBOutlet weak var dropLocationLabel: UILabel!
    
    @IBOutlet weak var setUserLocationButton: UIButton!
    
    var searchController: SearchLocationTableViewController = {
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "SearchLocationTableViewController") as! SearchLocationTableViewController
        return viewController
    }()
    
    var locationManager: CLLocationManager = CLLocationManager()
    
    var gmsFetcher: GMSAutocompleteFetcher?
    
    private let initialLocation = CLLocation.init(latitude: -33.86, longitude: 151.20)
    private let regionRadius: CLLocationDistance = 1000
    
    fileprivate var placeDetails: [String: Any]?
    
    // MARK:- View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set location manager property
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
        
        // Create an camera instance
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 30.0)
        
        // Assign camera instance to mapview and set other properties to mapview
        mapView.camera = camera
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        
        // instantiate gmsFetcher and set delegate
        gmsFetcher = GMSAutocompleteFetcher()
        gmsFetcher?.delegate = self
        
        // add search controller here and hide the container view
        searchController.delegate = self
        containerView.add(asChildViewController: searchController, parentViewController: self)
        containerView.isHidden = true
    }
    
    @IBAction func setUserLocationAction(_ sender: UIButton) {
        locationManager.setUserLocation()
    }
    
    @IBAction func setDropLocationAction(_ sender: UIButton) {
        self.performSegue(withIdentifier: "dropAddressSegue", sender: self.placeDetails)
    }
    
    func showPlaceDetailsView() -> Void {
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: .beginFromCurrentState, animations: {
            
            self.locationInfoView.frame = CGRect(x: self.locationInfoView.frame.origin.x, y: self.view.frame.size.height - self.locationInfoView.frame.size.height - 30, width: self.locationInfoView.frame.size.width, height: self.locationInfoView.frame.size.height)
            
            self.setUserLocationButton.frame = CGRect(x: self.setUserLocationButton.frame.origin.x, y: (self.locationInfoView.frame.origin.y - self.setUserLocationButton.frame.size.height - 20), width: self.setUserLocationButton.frame.size.width, height: self.setUserLocationButton.frame.size.height)
        }, completion: { (completed: Bool) in
            
        })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "dropAddressSegue" {
            let dropLocationAddressVC = segue.destination as! DropLocationAddressViewController
            dropLocationAddressVC.dropLocationDetails = sender as? [String : Any]
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension DropLocationViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        
        self.mapView.getLocationDetails(locationCoordinate: coordinate) { (name, subLocality, locality) in
            
            self.dropLocationLabel.text = "\(name!), \(subLocality!), \(locality!)"
            self.mapView.showMarker(coordinate: coordinate, placeName: name!, placeAddress: "\(subLocality!), \(locality!)")
            self.showPlaceDetailsView()
        }
    }
}

extension DropLocationViewController: UISearchBarDelegate, GMSAutocompleteFetcherDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        gmsFetcher?.sourceTextHasChanged(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
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

extension DropLocationViewController: CLLocationManagerDelegate {
    
    // MARK: - CLLocationManagerDelegate
    //Updated location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last! as CLLocation
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        self.mapView.getLocationDetails(locationCoordinate: coordinate) { (name, subLocality, locality) in
            
            self.dropLocationLabel.text = "\(name!), \(subLocality!), \(locality!)"
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

extension DropLocationViewController: SearchLocationDelegate {
    
    func selectedUserLocation(location: GMSAutocompletePrediction) {
        
        self.containerView.isHidden = true
        
        GMSPlacesClient().getPlaceDetailsFromPlaceId(placeID: location.placeID!) { (place, error) in
            
            guard let placeDetails = place else {
                return
            }
            
            self.placeDetails = placeDetails as? [String : Any]
            
            self.dropLocationLabel.text = "\(placeDetails.object(forKey: "name") as! String) \(placeDetails.object(forKey: "address") as! String)"
            
            self.mapView.showMarker(coordinate: (placeDetails.object(forKey: "coordinates") as! CLLocation).coordinate, placeName: placeDetails.object(forKey: "name") as! String , placeAddress: placeDetails.object(forKey: "address") as! String)
            
            self.showPlaceDetailsView()
        }
    }
}

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
import GoogleMaps
import GooglePlaces

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
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
    
    var locationMarker: GMSMarker!
    
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
        
        gmsFetcher = GMSAutocompleteFetcher()
        gmsFetcher?.delegate = self
        
        searchController.delegate = self
        add(asChildViewController: searchController)
        containerView.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locationManager.checkLocationAuthorisation()
    }
    
    // MARK: - center map on location
    /*
     * Set region on map view
     */
    func centerMapOnLocation(location: CLLocation) -> Void {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius, regionRadius)
        setuplocationMarker(coordinate: location.coordinate)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    // MARK: - set user's current location
    /*
     * get user current location and show user's location on map
     * then it will start updating map region
     */
    @IBAction func setCurrentLocation(_ sender: UIButton) {
        
        locationManager.setUserLocation()
        showPlaceDetailsView()
    }
    
    
    // MARK: - tap on map action
    /*
     * tap on map action
     */
    @IBAction func tapOnMapAction(_ sender: UITapGestureRecognizer) {
        
        let touchPoint = sender.location(in: self.mapView)
        let locationCoordinate: CLLocationCoordinate2D = self.mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
        self.mapView.getLocationDetails(locationCoordinate: locationCoordinate) { (locationDetails) in
            self.locationLabel.text = locationDetails
        }
    }
    
    func showPlaceDetailsView() -> Void {
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: .beginFromCurrentState, animations: {
            
            self.placeInformationView.frame = CGRect(x: 0, y: self.view.frame.size.height - self.placeInformationView.frame.size.height - 20, width: self.placeInformationView.frame.size.width, height: self.placeInformationView.frame.size.height)
            
            self.myLocationButton.frame = CGRect(x: self.myLocationButton.frame.origin.x, y: (self.placeInformationView.frame.origin.y - self.myLocationButton.frame.size.height - 20), width: self.myLocationButton.frame.size.width, height: self.myLocationButton.frame.size.height)
        }, completion: { (completed: Bool) in
            
        })
    }
    
    func setuplocationMarker(coordinate: CLLocationCoordinate2D) {
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "My Location"
        mapView.addAnnotation(annotation)
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
    
    func add(asChildViewController viewController: UIViewController) {
        
        addChildViewController(viewController)
        containerView.addSubview(viewController.view)
        viewController.view.frame = containerView.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParentViewController: self)
    }
    
    func remove(asChildViewController viewController: UIViewController) {
        
        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController: MKMapViewDelegate {
    
    func mapViewDidFinishLoadingMap(_ mapView: MKMapView) {
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }
        
        let annotationIdentifier = "Identifier"
        var annotationView: MKAnnotationView?
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
        }
        else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        if let annotationView = annotationView {
            
            annotationView.canShowCallout = true
            annotationView.image = UIImage(named: "LocationPin")
        }
        return annotationView
    }
}

extension ViewController: UISearchBarDelegate, GMSAutocompleteFetcherDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        gmsFetcher?.sourceTextHasChanged(searchText)
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
        self.locationLabel.text = location.attributedFullText.string
        showPlaceDetailsView()
        
        GMSPlacesClient().getPlaceDetailsFromPlaceId(placeID: location.placeID!) { (place, error) in
            
            guard let placeDetails = place else {
                return
            }
            
            self.centerMapOnLocation(location: placeDetails.object(forKey: "coordinates") as! CLLocation)
            self.setuplocationMarker(coordinate: (placeDetails.object(forKey: "coordinates") as! CLLocation).coordinate)
        }
    }
}


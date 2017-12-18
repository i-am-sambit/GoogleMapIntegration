//
//  DropLocationAddressViewController.swift
//  GenieflowTest
//
//  Created by GLB-311-PC on 18/12/17.
//  Copyright © 2017 SambitPrakash. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class DropLocationAddressViewController: UIViewController {

    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var dropLocationAddressLabel: UILabel!
    
    @IBOutlet weak var pickupDetailsTextfield: UITextField!
    @IBOutlet weak var pickupLocationNameLabel: UITextField!
    @IBOutlet weak var pickupFlatNumbaerLabel: UITextField!
    @IBOutlet weak var pickupContactLabel: UITextField!
    
    var dropLocationDetails: [String : Any]?
    
    var locationManager: CLLocationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create an camera instance
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 20.0)
        
        // Assign camera instance to mapview
        mapView.camera = camera
        
        let coordinate: CLLocationCoordinate2D = (dropLocationDetails!["coordinates"] as! CLLocation).coordinate
        self.mapView.showMarker(coordinate: coordinate, placeName: dropLocationDetails?["name"] as! String, placeAddress: dropLocationDetails?["address"] as! String)
        dropLocationAddressLabel.text = "\(dropLocationDetails?["name"] as! String), \(dropLocationDetails?["address"] as! String)"
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWasShown), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWasHidden), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @IBAction func confirmAction(_ sender: UIButton) {
        
    }
    
    func keyBoardWasShown(notification: NSNotification) -> Void {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyBoardWasHidden(notification: NSNotification) -> Void {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension DropLocationViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}

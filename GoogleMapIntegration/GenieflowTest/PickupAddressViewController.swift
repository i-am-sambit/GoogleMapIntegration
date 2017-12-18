//
//  PickupAddressViewController.swift
//  GenieflowTest
//
//  Created by Neeraj Sonaro on 16/12/17.
//  Copyright © 2017 SambitPrakash. All rights reserved.
//

import UIKit
import GoogleMaps

class PickupAddressViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var pickUpLocationLabel: UILabel!
    
    @IBOutlet weak var pickupDetailsTextfield: UITextField!
    @IBOutlet weak var pickupLocationNameLabel: UITextField!
    @IBOutlet weak var pickupFlatNumbaerLabel: UITextField!
    @IBOutlet weak var pickupContactLabel: UITextField!
    
    var pickupLocationDetails: [String : Any]?
    
    private let regionRadius: CLLocationDistance = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create an camera instance
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 20.0)
        
        // Assign camera instance to mapview
        mapView.camera = camera
        
        let coordinate: CLLocationCoordinate2D = (pickupLocationDetails!["coordinates"] as! CLLocation).coordinate
        self.mapView.showMarker(coordinate: coordinate, placeName: pickupLocationDetails?["name"] as! String, placeAddress: pickupLocationDetails?["address"] as! String)
        pickUpLocationLabel.text = "\(pickupLocationDetails?["name"] as! String), \(pickupLocationDetails?["address"] as! String)"
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
    
    @IBAction func nextAction(_ sender: UIButton) {
        performSegue(withIdentifier: "dropLocationSegue", sender: nil)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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

extension PickupAddressViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}

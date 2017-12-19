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
    @IBOutlet weak var pickupLocationNameTextfield: UITextField!
    @IBOutlet weak var pickupFlatNumbaerTextfield: UITextField!
    @IBOutlet weak var pickupContactTextfield: UITextField!
    
    @IBOutlet weak var confirmButton: UIButton!
    
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
        
        pickupDetailsTextfield.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        pickupLocationNameTextfield.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        pickupFlatNumbaerTextfield.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        pickupContactTextfield.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        
        let product: NSDictionary = UserDefaults.standard.object(forKey: "product") as! NSDictionary
        pickupDetailsTextfield.text = product.object(forKey: "productDetails") as? String
        pickupLocationNameTextfield.text = product.object(forKey: "locationName") as? String
        pickupFlatNumbaerTextfield.text = product.object(forKey: "appartmentNumber") as? String
        pickupContactTextfield.text = product.object(forKey: "pickupContactNumber") as? String
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
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func confirmAction(_ sender: UIButton) {
        
    }
    
    func editingChanged(_ textField: UITextField) {
        if textField.text?.characters.count == 1 {
            if textField.text?.characters.first == " " {
                textField.text = ""
                return
            }
        }
        guard
            let pickupDetails = pickupDetailsTextfield.text, !pickupDetails.isEmpty,
            let pickupLocation = pickupLocationNameTextfield.text, !pickupLocation.isEmpty,
            let pickupFlatNumbaer = pickupFlatNumbaerTextfield.text, !pickupFlatNumbaer.isEmpty,
            let pickupContact = pickupContactTextfield.text, !pickupContact.isEmpty
            else {
                confirmButton.isEnabled = false
                confirmButton.backgroundColor = UIColor.gray
                return
        }
        confirmButton.isEnabled = true
        confirmButton.backgroundColor = UIColor(colorLiteralRed: (0/255), green: (128/255), blue: (64/255), alpha: 1.0)
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

//
//  SearchLocationTableViewController.swift
//  GoogleMapIntegration
//
//  Created by GLB-311-PC on 14/12/17.
//  Copyright © 2017 Globussoft. All rights reserved.
//

import UIKit
import GooglePlaces

protocol SearchLocationDelegate: class {
    
    func selectedUserLocation(location: GMSAutocompletePrediction) -> Void
}

class SearchLocationTableViewController: UITableViewController {

    weak var delegate: SearchLocationDelegate?
    
    var locations = [GMSAutocompletePrediction]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 40
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! SearchLocationTableViewCell
        
        cell.locationNameLabel.text = locations[indexPath.row].attributedPrimaryText.string
        cell.locationDetailsLabel.text = locations[indexPath.row].attributedFullText.string
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        delegate?.selectedUserLocation(location: locations[indexPath.row])
    }
}

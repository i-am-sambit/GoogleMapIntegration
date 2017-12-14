//
//  SearchLocationTableViewCell.swift
//  GoogleMapIntegration
//
//  Created by GLB-311-PC on 14/12/17.
//  Copyright © 2017 Globussoft. All rights reserved.
//

import UIKit

class SearchLocationTableViewCell: UITableViewCell {

    @IBOutlet weak var locationNameLabel: UILabel!
    @IBOutlet weak var locationDetailsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

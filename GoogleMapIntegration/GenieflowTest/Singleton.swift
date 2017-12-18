//
//  Singleton.swift
//  GenieflowTest
//
//  Created by Neeraj Sonaro on 17/12/17.
//  Copyright © 2017 SambitPrakash. All rights reserved.
//

import UIKit

class Singleton: NSObject {
    
    static let sharedSingleton = Singleton()
    
    var locationDetails: String?
    
}

//
//  ErrorManager.swift
//  GoogleMapIntegration
//
//  Created by GLB-311-PC on 16/12/17.
//  Copyright © 2017 Globussoft. All rights reserved.
//

import Foundation

extension NSError {
    
    class func placeError(errorMessage: String) -> NSError {
        return NSError.init(domain: Config.localErrorDomain, code: 404, userInfo: [NSLocalizedDescriptionKey: errorMessage])
    }
    
    class func noPlaceFound(placeId: String) -> NSError {
        return NSError.init(domain: Config.localErrorDomain, code: 400, userInfo: [NSLocalizedDescriptionKey: "No Place found for \(placeId)"])
    }
}

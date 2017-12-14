//
//  GoogleHelperAPI.swift
//  GoogleMapIntegration
//
//  Created by GLB-311-PC on 13/12/17.
//  Copyright © 2017 Globussoft. All rights reserved.
//

import UIKit

class GoogleHelperAPI: NSObject {
    
    
    //MARK: post request
    private func postRequest(with url:URL, postBody:NSString, callback: @escaping (Any?) -> Void) -> Void {
        
        let defaultConfigObject = URLSessionConfiguration.default
        defaultConfigObject.timeoutIntervalForRequest = 30.0
        defaultConfigObject.timeoutIntervalForResource = 60.0
        
        let session = URLSession.init(configuration: defaultConfigObject, delegate: nil, delegateQueue: nil)
        
        let params: NSString! = postBody
        
        var urlRequest = URLRequest(url: url as URL)
        urlRequest.httpMethod = "POST"
        
        let data = params.data(using: String.Encoding.utf8.rawValue)
        urlRequest.httpBody = data
        
        session.dataTask(with: urlRequest, completionHandler: { (data, urlResponse, error) in
            
            var response : (Any)? = nil
            
            guard error == nil else {
                print("error calling GET on /todos/1")
                print(error ?? "error")
                callback(nil)
                return
            }
            
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            do {
                guard let responseData = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: AnyObject] else {
                    print("error trying to convert data to JSON")
                    return
                }
                
                response = responseData
                callback(response)
            } catch _ as NSError {
                
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                callback(responseString)
                return
            }
        }).resume()
    }
    
    //MARK: get request
    private func getRequest(with url: URL, callback: @escaping (Any?) -> Swift.Void) -> Void {
        
        let defaultConfigObject = URLSessionConfiguration.default
        defaultConfigObject.timeoutIntervalForRequest = 30.0
        defaultConfigObject.timeoutIntervalForResource = 60.0
        
        let session = URLSession.init(configuration: defaultConfigObject, delegate: nil, delegateQueue: nil)
        
        var urlRequest = URLRequest(url: url as URL)
        urlRequest.httpMethod = "GET"
        
        session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            
            var response : (Any)? = nil
            
            guard error == nil else {
                print("error calling GET on /todos/1")
                print(error ?? "error")
                callback(response!)
                return
            }
            
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            
            do {
                let responseData = try JSONSerialization.jsonObject(with: responseData, options: [JSONSerialization.ReadingOptions.allowFragments])
                
                response = responseData
                callback(response)
            } catch _ as NSError {
                
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                callback(responseString)
                return
            }
        }).resume()
    }
}

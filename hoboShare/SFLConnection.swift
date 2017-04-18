
//
//  SFLConnection.swift
//  SFLibrary
//
//  Created by Ralf Brockhaus and Justin-Nicholas Toyama on 3/6/15.
//  Copyright (c) 2015 Smilefish. All rights reserved.
//

import Foundation
import UIKit

// We will provide this file.

class SFLConnection : NSObject, URLSessionDelegate, URLSessionDataDelegate {
    
    var sharedSession: URLSession! = URLSession.shared
    var responseDATA = NSMutableData()
    var completion : (NSDictionary) -> () = { (obj) -> () in }
    
    func ajax(url: NSString, verb: NSString, requestBody:SFLBaseModel, completionBlock:@escaping (NSDictionary) -> ()) {
        
        // Initialize container for data collected from NSURLConnection
        
        let jsonRequest = requestBody.getJSONDictionaryString()
        
        let jsonData = NSData(bytes: jsonRequest.utf8String, length: jsonRequest.lengthOfBytes(using: String.Encoding.utf8.rawValue))
        
        let requestURL = NSURL(string: url as String)
        
        let request = NSMutableURLRequest(url: requestURL! as URL)
        
        print(NSString(format: " \n\n\nSFLConnection.ajax:ver:requestbody:completionBlock() URL = %@ \nVERB = %@ \nREQUEST JSON = %@", requestURL!, verb, jsonRequest) as String)
        
        request.httpMethod = verb as String
        request.setValue("application/json; charset = utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData as Data
        
        // create task
        let task = sharedSession.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            if error != nil
            {
                
                // Pass the error from the connection to the completionBlock
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                let status = NSDictionary(objects: [NSNumber(value: 1), "The connection failed."], forKeys: ["Code" as NSCopying, "Description" as NSCopying])
                
                let jsonDict = ["Status" : status] as NSDictionary
                
                DispatchQueue.main.async()
                {
                    
                    self.completion(jsonDict)
                    
                }
                
            }
            else
            {
                
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
                let returnJSONString = NSString(data:data!, encoding:String.Encoding.utf8.rawValue)
                
                print("SFLConnection.connectionDidFinishLoading(): URL: \(request.url), VERB: \(request.httpMethod), responseJSON: \(returnJSONString)")
                
                var jsonObject: AnyObject?
                
                var jsonDict: NSDictionary!
                
                do
                {
                    
                    jsonObject = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                    
                }
                catch _
                {
                    
                    jsonObject = nil
                }
                
                if let theJSONString = jsonObject as? NSString
                {
                    
                    let status: NSDictionary = NSDictionary(objects: [NSNumber(value: 1), theJSONString], forKeys: ["Code" as NSCopying, "Description" as NSCopying])
                    
                    jsonDict = ["Status" : [status]] as NSDictionary
                    
                }
                else
                if let theJSONDict = jsonObject as? Dictionary<String, Any>
                {
                    
                    if theJSONDict["Status"]  != nil
                    {
                        
                        jsonDict = theJSONDict as NSDictionary!
                        
                    }
                    else
                    {
                        
                        if let message: AnyObject = theJSONDict["Message"] as AnyObject?
                        {
                            
                            print("error:" + (message as! String))
                            
                            let status = NSDictionary(objects: [NSNumber(value: 999), message], forKeys: ["Code" as NSCopying, "Description" as NSCopying])
                            
                            jsonDict = ["Status" : status] as NSDictionary
                            
                        }
                        else
                        {
                            let status = NSDictionary(objects: [NSNumber(value: 1), "Unable to read the response."], forKeys: ["Code" as NSCopying, "Description" as NSCopying])
                            
                            jsonDict = ["Status" : status] as NSDictionary
                        }
                        
                    }
                    
                }
                else
                {
                    
                    let status = NSDictionary(objects: [NSNumber(value: 1), "No data returned from request."], forKeys: ["Code" as NSCopying, "Description" as NSCopying])
                    
                    jsonDict = ["Status" : status] as NSDictionary
                        
                }
                
                DispatchQueue.main.async()
                {
                    
                    self.completion(jsonDict)
                    
                }
                
            }
            
        })
        
        task.resume()
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        
        self.completion = completionBlock
        
    }
    
    
    
}


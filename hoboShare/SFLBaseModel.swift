//
//  SFLBaseModel.swift
//  SFLibrary
//
//  Created by Ralf Brockhaus and Justin-Nicholas Toyama on 3/6/15.
//  Copyright (c) 2015 Smilefish. All rights reserved.
//

import Foundation

// We will provide this file

public class SFLModelStatus : NSObject
{
    public var code : Int = 999
    public var statusDescription : String? = "An error has occured."
    public var stackTrace : String? = String()

    override init()
    {
        
        super.init()
        
    }
    
}


public class SFLSecurityContext : NSObject
{
    
    public var authToken : String? //GUID
    public var longTermAuthToken : String? //GUID
    public var apiKey:String?
    public var domainShortName:String?
    
    func readFromJSONDictionary(dict:NSDictionary)
    {
        
        self.authToken = dict.object(forKey: "AuthToken") as? String

        // don't read other keys because client should specify those
        
    }
    
    func getJsonDictionary() -> NSDictionary
    {
        
        let securityContextDict = NSMutableDictionary()
        
        if self.authToken != nil && self.authToken != "00000000-0000-0000-0000-000000000000" && self.authToken != ""
        {
        
            if self.authToken != nil
            {
                
                securityContextDict["AuthToken"] = authToken
                
            }
            
        }
        else
        if self.apiKey != nil && self.apiKey != ""
            && self.domainShortName != nil && self.domainShortName != ""
        {

                securityContextDict["ApiKey"] = apiKey
            
                securityContextDict["DomainShortName"] = domainShortName

        }
        else
        {
            
            print("SFLBaseModel.getJSONDictionary() - ERROR: Could not create security context!")
            
        }
        
        return securityContextDict
        
    }
    
}

@objc protocol JSONSerializable
{
    func readFromJSONDictionary(dict: NSDictionary)
    func getJSONDictionary() -> (NSDictionary)
    
    @objc optional func getJSONDictionaryString() -> (NSString)
}

public class SFLBaseModel : NSObject
{
    
    public var status:SFLModelStatus = SFLModelStatus()
    public var securityContext: SFLSecurityContext!
    
    public var delegate:SFLBaseModel!

    convenience init(JSONDictionary:Dictionary<String, AnyObject?>)
    {
        self.init()
        
        readFromJSONDictionary(dict: JSONDictionary as NSDictionary)
    }
    
    override init()
    {
        
        super.init()
        
        self.status = SFLModelStatus()
        
        self.securityContext = SFLSecurityContext()
        
    }

    func getJSONDictionary() -> NSDictionary
    {
        
        let baseModelDict = NSMutableDictionary()
        
        let scd = securityContext.getJsonDictionary()
        
        return ["Status" : baseModelDict, "SecurityContext" : scd] as NSMutableDictionary
        
    }

    func getJSONDictionaryString() -> NSString
    {
        
        var dictionary = NSDictionary()
        
        if delegate != nil
        {
        
            dictionary = delegate!.getJSONDictionary()
            
        }
        
        var result: NSData?
        
        do {
            
            result = try JSONSerialization.data(withJSONObject: dictionary, options: JSONSerialization.WritingOptions.prettyPrinted) as NSData?
            
        } catch {
            
            print("SFLContact getJSONDictionaryString() - Could not get JSON")
            
        }
        
        var jsonString:NSString = ""
        
        if result != nil
        {
            jsonString = NSString(data:result! as Data, encoding : String.Encoding.utf8.rawValue)!
            
        }

        
        return jsonString
        
    }
    
    func getJSONObject() -> NSObject {
        return "" as NSObject
    }
    
    func readFromJSONDictionary(dict:NSDictionary)
    {
        
        if status.code != 0 && status.code != 999
        {
        
            status = SFLModelStatus()
        
        }
        
        if let statusDict = dict.object(forKey: "Status") as? NSDictionary
        {
        
            status.code = statusDict.object(forKey: "Code") as! Int
            
            status.statusDescription = statusDict.object(forKey: "Description") as? String
            
            status.stackTrace = statusDict.object(forKey: "StackTrace") as? String
        
        }
        else
        {
        
            print("SFLBaseModel.readFromJSONDictionary() WARNING: This object is not key-value coding compliant for the key 'Status'. The instance may have been locally created.")
        
        }

        securityContext = SFLSecurityContext()
        
        securityContext.readFromJSONDictionary(dict: dict)
        
    }
}

public class SFLCollectionBaseModel: NSObject
{
    
    public  func getJSONDictionaryString() -> NSString
    {
     
        return ""
        
    }
    
}

class SFLAuthorizationResponse: SFLBaseModel
{
    
}

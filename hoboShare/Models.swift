//
//  Models.swift
//  hoboShare
//
//  Created by Md Ibrahim Hassan on 14/04/17.
//  Copyright © 2017 Md Ibrahim Hassan. All rights reserved.
//

import UIKit
import MapKit

extension Array {
    var allValuesAreHobbies: Bool {
        var returnValue = true
        for value in self
        {
            if value is Hobby == false
            {
                returnValue = false
            }
        }
        return returnValue
    }
    func toString() -> String
    {
        var returnString = ""
        if allValuesAreHobbies == true {
            for i in 0...self.count - 1 {
                let value = self[i]  as! Hobby
                if i == 0
                {
                    returnString += value.hobbyName!
                }
                else
                {
                    returnString += ", " + value.hobbyName!
                }
            }
        }
        return returnString
    }
}

class User: SFLBaseModel, JSONSerializable, MKAnnotation {
    override func getJSONDictionary() -> NSDictionary
    {
        let dict = super.getJSONDictionary()
        if self.userId != nil {
            dict.setValue(self.userId, forKey: "UserId")
        }
        if (self.userName != nil){
            dict.setValue(self.userName, forKey: "UserName")
        }
        if (self.latitude != nil) {
            dict.setValue(self.latitude, forKey: "Lattitude")
        }
        if (self.longitude != nil) {
            dict.setValue(self.longitude, forKey: "Longitude")
        }
        var jsonSafeHobbiesArray = [String]()
        for Hobby in self.hobbies
        {
            jsonSafeHobbiesArray.append(Hobby.hobbyName!)
        }
        dict.setValue(jsonSafeHobbiesArray, forKey: "Hobbies")
        if (self.searchHobby != nil) {
            dict.setValue(self.searchHobby!, forKey: "HobbySearch")
        }
        return dict
    }
    override func readFromJSONDictionary(dict: NSDictionary) {
        super.readFromJSONDictionary(dict: dict)
        self.userId = dict["UserId"] as? String
        self.userName = dict["Username"] as? String
        self.latitude = dict["Latitude"] as? Double
        self.longitude = dict["Longitude"] as? Double
        let returnedHobbies = dict["Hobbies"] as? NSArray
        if let hobbies = returnedHobbies
        {
            self.hobbies = Hobby.deserializeHobbies(hobbies: hobbies)
        }
    }
    var userName : String?
    var userId : String?
    var  latitude : Double?
    var longitude : Double?
    var hobbies = [Hobby]()
    var searchHobby : String?
    override init()
    {
        super.init()
        self.delegate = self
    }
    init(userName : String?) {
        super.init()
        self.delegate = self
        self.userName = userName
    }
    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: self.latitude!, longitude: self.longitude!)
        }
    }
    var title : String?
    {
        get
        {
            return self.userName
        }
    }
    var subtitle : String? {
        get{
            var hobbiesAsString = ""
            hobbiesAsString = hobbies.toString()
            print (hobbiesAsString)
            return hobbiesAsString
        }
    }
    convenience init(userName : String?, hobbies : [Hobby]?, lat : Double? , long: Double?) {
        self.init(userName : userName)
        self.latitude = lat
        self.longitude = long
        self.hobbies = hobbies!
    }
}
class ListOfUsers: SFLBaseModel, JSONSerializable {
    var users = [User]()
    override init()
    {
        super.init()
        self.delegate=self
    }
    override func readFromJSONDictionary(dict: NSDictionary) {
        super.readFromJSONDictionary(dict: dict)
        if let returnedusers = dict["ListOfUsers"] as? NSArray {
            for dict in returnedusers
            {
                let user = User()
                user.readFromJSONDictionary(dict: dict as! NSDictionary)
                self.users.append(user)
            }
        }
    }
    override func getJSONDictionary() -> NSDictionary {
        let dict = super.getJSONDictionary()
        return dict
    }
    override func getJSONDictionaryString() -> NSString {
        return super.getJSONDictionaryString()
    }
}
class Hobby: SFLBaseModel, NSCoding {
    required init?(coder aDecoder: NSCoder)
    {
        self.hobbyName = aDecoder.decodeObject(forKey: "HobbyName") as? String
    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.hobbyName, forKey: "HobbyName")
    }
    
    var hobbyName : String?
    init(hobbyName: String?) {
        super.init()
        self.hobbyName = hobbyName
    }
    class func deserializeHobbies(hobbies: NSArray) -> Array<Hobby>
    {
        var returnedArray = Array<Hobby>()
        for hobby in hobbies {
            if let hobbyName = hobby as? String
            {
                returnedArray.append(Hobby(hobbyName: hobbyName))
            }
        }
        return returnedArray
    }
}

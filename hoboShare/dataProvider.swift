//
//  dataProvider.swift
//  hoboShare
//
//  Created by Md Ibrahim Hassan on 14/04/17.
//  Copyright © 2017 Md Ibrahim Hassan. All rights reserved.
//

import UIKit
let serverPath = "http://uci.smilefish.com/HBSRest-Dev/api/"
let endPoint = "HobbyRest"
class UserDP: NSObject {

    func getResponseForUser(user: User, completionHandler: @escaping (User) -> ())
    {
        let requestedUrlString =  serverPath + endPoint
        let HTTPMethoh = "CREATE_USER"
        let requestModel = user
        
        SFLConnection().ajax(url: requestedUrlString as NSString, verb: HTTPMethoh as NSString, requestBody: requestModel){
        (returnJSONDict) in
        let dict =  NSDictionary(dictionary: returnJSONDict)
        let returnedUser = User()
        returnedUser.readFromJSONDictionary(dict: dict)
        if (returnedUser.status.code == 0)
        {
            print ("Success")
            completionHandler(returnedUser)
        }
        }
    }
    func fetchUsersForHobby(user: User, hobby: String, completionHandler : @escaping (ListOfUsers) -> ())
    {
        let requestedUrlString =  serverPath + endPoint
        let HTTPMethod = "FETCH_USERS_WITH_HOBBY"
        let requestModel = user
        requestModel.searchHobby = hobby
        SFLConnection().ajax(url: requestedUrlString as NSString, verb: HTTPMethod as NSString, requestBody: requestModel){
            (returnJSONDict) in
            let dict =  NSDictionary(dictionary: returnJSONDict)
            let returnedListOfUsers = ListOfUsers()
            returnedListOfUsers.readFromJSONDictionary(dict: dict)
            completionHandler(returnedListOfUsers)
        }
        

    }
}
class HobbyDP: NSObject {
    func fetchHobbies() -> [String : [Hobby]]
    {
        
        // We will provide this code
        
        return ["Technology" : [Hobby(hobbyName: "Video Games") ,Hobby(hobbyName: "Computers") ,Hobby(hobbyName: "IDEs") ,Hobby(hobbyName: "Smartphones") ,Hobby(hobbyName: "Programming") ,Hobby(hobbyName: "Electronics") ,Hobby(hobbyName: "Gadgets") ,Hobby(hobbyName: "Product Reviews") ,Hobby(hobbyName: "Computer Repair") ,Hobby(hobbyName: "Software") ,Hobby(hobbyName: "Hardware") ,Hobby(hobbyName: "Apple") ,Hobby(hobbyName: "Google") ,Hobby(hobbyName: "Microsoft") ,
                               ]]
    
    }
    func saveHobbiesForUser(user: User, completion: @escaping (User) -> ())
    {
        let requestUrlString = serverPath + endPoint
        let HTTPMethod = "SAVE_HOBBIES"
        let requestModel = user
        
        SFLConnection().ajax(url: requestUrlString as NSString, verb: HTTPMethod as NSString, requestBody: requestModel)
        {
            (reurnJSONDict) in
            let returnedUser = User()
            returnedUser.readFromJSONDictionary(dict: reurnJSONDict)
            completion(returnedUser)
        }
    }
}

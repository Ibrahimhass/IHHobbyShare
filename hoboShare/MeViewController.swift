//
//  MeViewController.swift
//  hoboShare
//
//  Created by Md Ibrahim Hassan on 14/04/17.
//  Copyright © 2017 Md Ibrahim Hassan. All rights reserved.
//

import UIKit
import MapKit
class MeViewController: hobbyShareViewController, UITextFieldDelegate {

    @IBAction func submitButtonPressed(_ sender: Any) {
        if self.validate() == true
        {
            self.submit()
        }
    }
    func submit()
    {
        userNameTF.resignFirstResponder()
        let requestUser = User(userName: userNameTF.text!)
        requestUser.longitude = currentLocation?.coordinate.longitude
        requestUser.latitude = currentLocation?.coordinate.latitude
        UserDP().getResponseForUser(user: requestUser) {
            (returnedUser) in
            print (returnedUser.status.code)
            if returnedUser.status.code == 0
            {
                self.myHobbies = returnedUser.hobbies
                UserDefaults.standard.set(returnedUser.userId, forKey: "CurrentUserId")
            }
            else{
                self.showError(message: requestUser.status.statusDescription!)
            }
        }
    }

    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var latLabel: UILabel!
    @IBOutlet weak var longLabel: UILabel!
    /*View Life Cycle Functions*/
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        userNameTF.delegate = self
    }
    override func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        super.locationManager(manager, didUpdateLocations: locations)
        latLabel.text = "Lattitude: \(currentLocation!.coordinate.latitude)"
        longLabel.text = "Longitude: \(currentLocation!.coordinate.longitude)"
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       if validate() == true
       {
        submit()
        }
        return true
    }
    func validate() -> Bool
    {
        var valid = false
        if userNameTF.text != nil && (userNameTF.text?.characters.count)! > 0
        {
            valid = true
        }
        else
        {
            self.showError(message: "Please Enter a UserName")
        }
        
        return valid
    }
}

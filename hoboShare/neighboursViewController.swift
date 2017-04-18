//
//  neighboursViewController.swift
//  hoboShare
//
//  Created by Md Ibrahim Hassan on 14/04/17.
//  Copyright © 2017 Md Ibrahim Hassan. All rights reserved.
//

import UIKit
import MapKit
class neighboursViewController: hobbyShareViewController, MKMapViewDelegate {

    var users : [User]?
    @IBOutlet weak var myMapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last!
        locationManager.stopUpdatingLocation()
        self.centerOnMapCurrentLocation()
    }

    func centerOnMapCurrentLocation()
    {
    if currentLocation != nil {
        myMapView.setCenter((currentLocation?.coordinate)!, animated: true)
        let currentReigon = myMapView.regionThatFits(MKCoordinateRegionMake(CLLocationCoordinate2DMake((currentLocation!.coordinate.latitude), (currentLocation!.coordinate.longitude)), MKCoordinateSpanMake(0.5, 0.5)))
            myMapView.setRegion(currentReigon, animated: true)
        
    }
        print ("Current Location is nil")
    }
    var redItemIndex : Int?
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let users = self.users
        {
            self.myMapView.removeAnnotations(users)
        }
        self.fetchUserWithHobby(hobby: myHobbies![indexPath.row])
//        let cell = collectionView.dataSource?.collectionView(collectionView, cellForItemAt: indexPath) as! HobbyCollectionViewCell
        redItemIndex = indexPath.item
        collectionView.reloadData()
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : HobbyCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HobbyCollectionViewCell", for: indexPath) as! HobbyCollectionViewCell
        if collectionView == hobbiesCollectionView
        {
            let hobby = myHobbies?[indexPath.item]
            cell.hobbyLabel.text = hobby?.hobbyName
            cell.backgroundColor = .gray
            cell.hobbyLabel.textColor = .white
            if (redItemIndex != nil)
            {
            if (indexPath.item == redItemIndex) {
                cell.backgroundColor = .red
                }}
        }
        return cell
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        redItemIndex = nil
    }
    func fetchUserWithHobby(hobby : Hobby)
    {
        print (hobby.hobbyName!)
        if (UserDefaults.standard.value(forKey: "CurrentUserId")) == nil
        {
            let userId = UserDefaults.standard.value(forKey: "CurrentUserId") as! String
            if (userId.characters.count > 0)
            {
            let alert = UIAlertController.init(title: "hoBShare", message: "Please login before selecting a hobby", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Dismiss", style: .default, handler:{ (action) in alert.dismiss(animated: true, completion: nil)
            })
            
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        }
//        guard (UserDefaults.standard.value(forKey: "CurrentUserId") as? String)!.characters.count > 0 else
//        {
//            let alert = UIAlertController.init(title: "hoBShare", message: "Please login before selecting a hobby", preferredStyle: .alert)
//            let okAction = UIAlertAction(title: "Dismiss", style: .default, handler:{ (action) in alert.dismiss(animated: true, completion: nil)
//            })
//            
//            alert.addAction(okAction)
//            self.present(alert, animated: true, completion: nil)
//            return
//        }
        if (UserDefaults.standard.value(forKey: "CurrentUserId")) != nil
        {
            let userId = UserDefaults.standard.value(forKey: "CurrentUserId") as! String
            if (userId.characters.count > 0)
            {
        let requestUser = User()
        requestUser.userId = UserDefaults.standard.value(forKey: "CurrentUserId") as? String
        requestUser.latitude = currentLocation?.coordinate.latitude
        requestUser.longitude = currentLocation?.coordinate.longitude
        UserDP().fetchUsersForHobby(user: requestUser, hobby: hobby.hobbyName!)
        {
            (returnedListOfUsers) in
            if returnedListOfUsers.status.code == 0
            {
                self.users = returnedListOfUsers.users
                if let users = self.users {
                    self.myMapView.removeAnnotations(users)
//                   self.myMapView.removeAnnotation(users as! MKAnnotation)
                }
                if let users = self.users {
                    for user in users {
                        self.myMapView.addAnnotation(user)
                    }
                    if self.currentLocation != nil {
                        let me = User(userName: "Me", hobbies: self.myHobbies!, lat: (self.currentLocation?.coordinate.latitude)!, long: (self.currentLocation?.coordinate.longitude)!)
                        self.myMapView.addAnnotation(me)
                        let neighBoursAndMe = users + [me]
                        self.myMapView.showAnnotations(neighBoursAndMe, animated: true)
                    }
                    else {
                        self.myMapView.showAnnotations(users, animated: true)
                    }
                }
            }
            else{
                self.showError(message: returnedListOfUsers.status.statusDescription!)
            }
        }
    }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if (self.myHobbies != nil)
        {
            let me = User(userName: "Me", hobbies: self.myHobbies!, lat: (self.currentLocation?.coordinate.latitude)!, long: (self.currentLocation?.coordinate.longitude)!)
            self.myMapView.addAnnotation(me)
        }
//        let neighBoursAndMe = users + [me]
//        self.myMapView.showAnnotations(neighBoursAndMe, animated: true)
    }
}

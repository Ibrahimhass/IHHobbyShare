//
//  hobbyShareViewController.swift
//  hoboShare
//
//  Created by Md Ibrahim Hassan on 14/04/17.
//  Copyright © 2017 Md Ibrahim Hassan. All rights reserved.
//
    
import UIKit
import MapKit
class hobbyShareViewController: UIViewController, CLLocationManagerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    /*Show Error*/
   
    func showError(message: String)
    {
        let alert = UIAlertController.init(title: kAppTitle, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Dismiss", style: .default, handler:{ (action) in alert.dismiss(animated: true, completion: nil)
        })
        
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    /*View Life Cycle*/
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    var newArray : [String] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.getHobbies()
        locationManager.delegate = self
        if (CLLocationManager.authorizationStatus() == .notDetermined){
            locationManager.requestWhenInUseAuthorization()}
        else if CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways
        {
            locationManager.stopUpdatingLocation()
            locationManager.startUpdatingLocation()
        }
    }
    /*Location Manager*/
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse
        {
            manager.stopUpdatingLocation()
            manager.startUpdatingLocation()
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
        manager.stopUpdatingLocation()
    }
    /*Handle Failure*/
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        print (error.debugDescription)
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print (error.localizedDescription)
    }
    let availableHobbies: [String: [Hobby]] = HobbyDP().fetchHobbies()
    /*Collection View Code*/
    var myHobbies: [Hobby]? {
        didSet{
            if (myHobbies != nil)
            {
                if !newArray.isEmpty {
                    newArray.removeAll()
                }
                for i in (myHobbies)! {
                    newArray.append(i.hobbyName!)
                }
                self.hobbiesCollectionView.reloadData()
                self.saveToUserDefaults()
            }
//            self.hobbiesCollectionView.reloadData()
//            self.saveToUserDefaults()
        }
    }
    
    func saveToUserDefaults()
    {
      let hobbyData = NSKeyedArchiver.archivedData(withRootObject: myHobbies)
      UserDefaults.standard.set(hobbyData, forKey: "MyHobbies")
    }
    @IBOutlet weak var hobbiesCollectionView: UICollectionView!
    let locationManager = CLLocationManager()
    var currentLocation : CLLocation?
    /*CollectionViewDataSource*/
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == hobbiesCollectionView
        {
            return 1
        }
        else
        {
            return availableHobbies.keys.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == hobbiesCollectionView{
        guard myHobbies != nil else
        {
            return 0
        }
        return (myHobbies?.count)!
    }
        else
        {
            let key = Array(availableHobbies.keys)[section]
            return (availableHobbies[key]?.count)!
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell : HobbyCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HobbyCollectionViewCell", for: indexPath) as! HobbyCollectionViewCell
        if collectionView == hobbiesCollectionView
        {
            let hobby = myHobbies?[indexPath.item]
            cell.hobbyLabel.text = hobby?.hobbyName
            cell.backgroundColor = .gray
            cell.hobbyLabel.textColor = .white
//            if (cell.replaceButton != nil)
//            {
//                cell.replaceButton.tag = indexPath.item
//                cell.replaceButton.addTarget(self, action: "replaceButtonAction:" , for: .touchUpInside)
//            }
        }
        else{
            let key = Array(availableHobbies.keys)[indexPath.section]
            let hobbies = availableHobbies[key]
            let hobby = hobbies?[indexPath.item]
            cell.hobbyLabel.text = hobby?.hobbyName
            cell.backgroundColor = .gray
            if newArray.isEmpty == false{
                for i in newArray {
                    if (cell.hobbyLabel.text == i)
                    {
                        cell.backgroundColor = .red
                    }
                }
            }
        }
        return cell
    }
//    func replaceButtonAction(sender: UIButton)
//    {
//        print (sender.tag)
//    }
    /*Flow Layout Delegate*/
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var availableWidth : CGFloat!
        let cellHeight : CGFloat = 54
        var numberOfCells : Int!
        if collectionView == hobbiesCollectionView
        {
            numberOfCells = collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: indexPath.section)
            let padding = 10
            availableWidth = collectionView.frame.size.width - CGFloat(padding * (numberOfCells - 1))
        }
        else{
            numberOfCells = 2
            let padding = 10
            availableWidth = collectionView.frame.size.width - CGFloat(padding * (numberOfCells - 1))
        }
        let dynamicCellWidth = availableWidth / CGFloat(numberOfCells)
        let dynamicCellSize = CGSize.init(width: dynamicCellWidth, height: cellHeight)
        return (dynamicCellSize)
    }
    /*Get Hobbies*/
    func getHobbies()
    {
        if let data = UserDefaults.standard.object(forKey: "MyHobbies") as? NSData
        {
            let savedHobbies = NSKeyedUnarchiver.unarchiveObject(with: data as Data) as! Array<Hobby>
            myHobbies = savedHobbies
        }
    }
    @IBOutlet weak var availableHobbiesCollectionView: UICollectionView!
}

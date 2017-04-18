//
//  EditHobbiesViewController.swift
//  hoboShare
//
//  Created by Md Ibrahim Hassan on 14/04/17.
//  Copyright © 2017 Md Ibrahim Hassan. All rights reserved.
//

import UIKit

class EditHobbiesViewController: hobbyShareViewController {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
//        let reusableView = collectionView.dequeueReusableCell(withReuseIdentifier: "HobbyCategoryHeader", for: indexPath)
        let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HobbyCategoryHeader", for: indexPath)
        (reusableView as! HobbiesCollectionViewHeader).hobbyNameLabel.text = Array(availableHobbies.keys)[indexPath.section]
        return reusableView
    }
    var indexToReplace : Int?
    var sectionToReplace : Int?
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == availableHobbiesCollectionView
        {
            let key = Array(availableHobbies.keys)[indexPath.section]

            let hobbies = availableHobbies[key]
            let hobby = hobbies![indexPath.item]
            if myHobbies?.contains(where: { $0.hobbyName == hobby.hobbyName}) == false
            {
                if (myHobbies?.count)! < kMaxHobbies
                {
                    myHobbies! += [hobby]
                    self.saveHobbies()
                    self.availableHobbiesCollectionView.reloadData()
                }
                else
                {
                    let alert = UIAlertController.init(title: kAppTitle, message: "You can select only upto \(kMaxHobbies) hobbies. You can replace a hobby.", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Cancel", style: .default, handler:{ (action) in alert.dismiss(animated: true, completion: nil)
                    })
                    let replaceAction = UIAlertAction(title: "Replace", style: .default, handler:{
                        (action) in
                        self.indexToReplace = indexPath.item
                        self.sectionToReplace = indexPath.section
                        print (self.indexToReplace)
                    let alert123 = UIAlertController.init(title: kAppTitle, message:"Please select the hobby to replace", preferredStyle: .alert)
                        let button0 = UIAlertAction(title: "\(self.myHobbies![0].hobbyName!)", style: .default, handler:{ (action) in
                            self.replaceButtonAction(sender: 0)
                            
                            
                            
//                            alert.dismiss(animated: true, completion: nil)
                        })
                        let button1 = UIAlertAction(title: "\(self.myHobbies![1].hobbyName!)", style: .default, handler:{ (action) in
                            self.replaceButtonAction(sender: 1)
//                            alert.dismiss(animated: true, completion: nil)
                        })
                        let button2 = UIAlertAction(title: "\(self.myHobbies![2].hobbyName!)", style: .default, handler:{ (action) in
                            self.replaceButtonAction(sender: 2)
//                            alert.dismiss(animated: true, completion: nil)
                        })
                        let cancel = UIAlertAction(title: "Dismiss", style: .default, handler:{ (action) in alert.dismiss(animated: true, completion: nil)
                        })
                    alert123.addAction(button0)
                    alert123.addAction(button1)
                    alert123.addAction(button2)
                    alert123.addAction(cancel)
                    self.present(alert123, animated: true, completion: nil)
//
                    })

                    alert.addAction(replaceAction)
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)

                }
            }}
        else
        {
            let alert = UIAlertController.init(title: kAppTitle, message: "Would you like to delete this hobby?", preferredStyle: .alert)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler:{ (action) in
//                let hobLocal = self.myHobbies![indexPath.item]
//                let hobbyName1 = hobLocal.hobbyName
//                for (i,x) in self.newArray.enumerated()
//                {
//                    if x == hobbyName1 {
//                        self.newArray.remove(at: i)
//                        self.availableHobbiesCollectionView.reloadData()
//                    }
//                }
                self.myHobbies!.remove(at: indexPath.item)
                self.refreshAvailableList()
                self.availableHobbiesCollectionView.reloadData()
//                self.hobbiesCollectionView.reloadData()
                self.saveHobbies()
                //alert.dismiss(animated: true, completion: nil)
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler:{ (action) in alert.dismiss(animated: true, completion: nil)
            })
            alert.addAction(cancelAction)
            alert.addAction(deleteAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    func saveHobbies()
    {
        let requestUser = User()
        requestUser.userId = UserDefaults.standard.value(forKey: "CurrentUserId") as? String
        if let myHobbies = self.myHobbies
        {
            requestUser.hobbies = myHobbies
        }
        //
        HobbyDP().saveHobbiesForUser(user: requestUser) {
            (returnedUser) -> () in
            if returnedUser.status.code == 0
            {
                self.saveToUserDefaults()
                self.hobbiesCollectionView.reloadData()
            }
            else
            {
                self.showError(message: returnedUser.status.statusDescription!)
            }
        }
    }
   
  
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell : HobbyCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "HobbyCollectionViewCell", for: indexPath) as! HobbyCollectionViewCell
    if collectionView == hobbiesCollectionView
    {
    let hobby = myHobbies?[indexPath.item]
    cell.hobbyLabel.text = hobby?.hobbyName
    cell.backgroundColor = .gray
    cell.hobbyLabel.textColor = .white
//    cell.replaceButton.tag = indexPath.item
//        cell.replaceButton.addTarget(self, action:#selector(self.replaceButtonAction)  , for: .touchUpInside)
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
    
func replaceButtonAction(sender: Int)
{
    if (Array(availableHobbies.keys)[self.sectionToReplace!] != nil){
    let key = Array(availableHobbies.keys)[self.sectionToReplace!]
    let hobbies = availableHobbies[key]
    let hobby = hobbies![self.indexToReplace!]
    if myHobbies?.contains(where: { $0.hobbyName == hobby.hobbyName}) == false
    {
        myHobbies?[sender] = hobby
        self.saveHobbies()
        self.newArray.removeAll()
        self.refreshAvailableList()
        print (newArray)
        self.hobbiesCollectionView.reloadData()
        self.availableHobbiesCollectionView.reloadData()

    }
    else
    {
        self.showError(message: "Duplicate entries are not allowed")
    }
    }


//alert.dismiss(animated: true, completion: nil)
}
    func refreshAvailableList()
    {
        if (myHobbies != nil)
        {
            for i in (myHobbies)! {
                newArray.append(i.hobbyName!)
            }
        }
        self.saveToUserDefaults()
    }
    override func viewDidLoad() {
    super.viewDidLoad()
              //  self.availableHobbiesCollectionView.delegate = self
    }
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        if (myHobbies != nil)
//        {
//            for i in (myHobbies)! {
//                newArray.append(i.hobbyName!)
//            }
//            self.hobbiesCollectionView.reloadData()
//            self.availableHobbiesCollectionView.reloadData()
//        }
//    }
//    @IBOutlet weak var availableHobbiesCollectionView: UICollectionView!
    
  }

//
//  SnapsVC.swift
//  SnapchatClone
//
//  Created by Manolescu Mihai Alexandru on 04/08/2017.
//  Copyright © 2017 Manolescu Mihai Alexandru. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class SnapsVC: UIViewController, UITableViewDataSource, UITableViewDelegate
{

    
    //this variable tells us if the tableView has to be populated with
    //snaps that are 'new' only or all of them:
    var displayingNewSnapsOnly = Bool()
    
   
    @IBOutlet weak var typeOfSnapsLabel: UILabel!
    @IBOutlet weak var snapsTableView: UITableView!

    override func viewDidLoad()
    {
        super.viewDidLoad()

        //clear arrays for avoiding duplicates in tableView.
        allSnaps.removeAll()
        newSnaps.removeAll()
        
        //display 'new' by default
        displayingNewSnapsOnly = true
        chooseTypeOfSnaps.setTitle("Show all", for: .normal)
        
        
        snapsTableView.dataSource = self
        snapsTableView.delegate = self
        
        //start fetching snaps from database:
        let currentUid = Auth.auth().currentUser?.uid
        
        Database.database().reference().child("Users").child(currentUid!).child("snaps").observe(DataEventType.childAdded, with:
        {(snap) in print()
            
            let fetchedSnap = Snap()
            
            fetchedSnap.from = snap.childSnapshot(forPath: "from").value as! String
            fetchedSnap.imageURL = snap.childSnapshot(forPath: "imageURL").value as! String
            fetchedSnap.description = snap.childSnapshot(forPath: "description").value as! String
            fetchedSnap.key = snap.key
            fetchedSnap.imageID = snap.childSnapshot(forPath: "imageID").value as! String
            fetchedSnap.isSeen = snap.childSnapshot(forPath: "isSeen").value as! String
            
            allSnaps.append(fetchedSnap)
            
            if fetchedSnap.isSeen == "false"
            {
                newSnaps.append(fetchedSnap)
            }
            
            self.snapsTableView.reloadData()
        })
        
        
        
        Database.database().reference().child("Users").child(currentUid!).child("snaps").observe(DataEventType.childRemoved, with:
        { (snaphot) in print()
            
            var index = 0
            for snap in allSnaps {
                if snap.key == snaphot.key {
                    allSnaps.remove(at: index)
                }
                index += 1
            }
            
            self.snapsTableView.reloadData()
        })
        

    }
    
    //reload the tableview each time this view controllers pops out:
    override func viewWillAppear(_ animated: Bool)
    {
         self.snapsTableView.reloadData()
    }

    
    //this button switches the type of snaps that is being displayed, the new ones or all of them
    @IBOutlet weak var chooseTypeOfSnaps: UIButton!
    @IBAction func chooseTypeOfSnaps(_ sender: Any)
    {
        if(/*are we*/displayingNewSnapsOnly) //then
        {
            print("\n #Now the tableView contains all the snaps")
            
            displayingNewSnapsOnly = false
            typeOfSnapsLabel.text = "These are all of your snaps:"
            chooseTypeOfSnaps.setTitle("Show new only", for: .normal)
            
            self.snapsTableView.reloadData()
        }
        else
        {
            print("\n #Now the tableView contains the new snaps only")
            
            displayingNewSnapsOnly = true
            typeOfSnapsLabel.text = "Your new snaps recieved:"
            chooseTypeOfSnaps.setTitle("Show all", for: .normal)
            
            self.snapsTableView.reloadData()
        }
    }
    
    //log out current user and get back to the main viewController
    @IBAction func logOutButton(_ sender: Any)
    {
        dismiss(animated: true)
        {
            print("\n\n#Calling Segue and signing out.\n")
            
            do{
                try Auth.auth().signOut()
            } catch{
                
            }
        }
    }
    
    //move to the viewcontroller that allows the user to create a new snap:
    @IBAction func addSnap(_ sender: Any)
    {
        performSegue(withIdentifier: "addButtonSegue", sender: nil)
    }
    
    //this function hides the status bar upwards:
    override var prefersStatusBarHidden: Bool
    {
        return true
    }
    
    //choose the number of cells in the tableview according to the local arrays below:
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        
        if /*are we*/ displayingNewSnapsOnly
        {
            return newSnaps.count
        }
        else
        {
            return allSnaps.count
        }
        
    }
    
    //define tableview's cell:
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell()
        
        if /*we are*/ displayingNewSnapsOnly
        {
            cell.textLabel?.text = "\(newSnaps[indexPath.row].from): \(newSnaps[indexPath.row].description)"
            print(" $$$ snap isSeen:", newSnaps[indexPath.row].isSeen)

        }
        else
        {
            cell.textLabel?.text = "\(allSnaps[indexPath.row].from): \(allSnaps[indexPath.row].description)"
            print(" $$$ snap isSeen:", allSnaps[indexPath.row].isSeen)
            
        }
        
        return cell
    }
    
    //when a cell is tapped, the user goes to the viewcontroller that displays information about it, being able to see the picture as well:
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if /*we are*/ displayingNewSnapsOnly
        {
            performSegue(withIdentifier: "showSnapSegue", sender: newSnaps[indexPath.row])
            print("\n Trying to send by segue: ", newSnaps[indexPath.row].description)
        }
        else
        {
            performSegue(withIdentifier: "showSnapSegue", sender: allSnaps[indexPath.row])
            print("\n Trying to send by segue: ", allSnaps[indexPath.row].description)
        }
    }
    
    //this function allows the user to delete a cell in the table view. In the same time, it deletes that object from coredata:
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {

        if editingStyle == .delete
        {
            if /*we are*/ displayingNewSnapsOnly
            {
                removeSnapFromEverywhere(newSnaps[indexPath.row])
            }
            else
            {
                removeSnapFromEverywhere(allSnaps[indexPath.row])
            }
            
        }
    }

    //this function removes the specific snap from the dataBase, but it removes it locally as well:
    func removeSnapFromEverywhere(_ specificSnap: Snap)
    {
        print("\n#The user saw the snap. Now it is supposed to get deleted")
        
        
        let imageUIDthatWeDelete = specificSnap.imageID
        
        print("\n\n\n#$% ", specificSnap.imageID ,"\n")
        
        Storage.storage().reference().child("images").child("\(imageUIDthatWeDelete)").delete { (error) in
            print(error)
        }
        
        Database.database().reference().child("Users").child((Auth.auth().currentUser?.uid)!).child("snaps").child(specificSnap.key).removeValue()
        
    }
    
    //define segue transfer
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier=="showSnapSegue")
        {
            let nextVC = segue.destination as! ShowSnapVC
            nextVC.specificSnap = sender as! Snap
        }
    }

    //reload the 'newSnaps' array, make sure it contains only snaps that were not seen by the user:
    func filterNewSnaps()
    {
        newSnaps.removeAll()
        
        for snap in allSnaps where snap.isSeen == "false"
        {
            newSnaps.append(snap)
        }
        
        print(" #Number of new snaps right away: ", newSnaps.count)
    }
  
}



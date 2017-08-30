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
    var allSnaps = [Snap]()
    var newSnaps = [Snap]()
    
    //this variable tells us if the tableView has to be populated with
    //snaps that are 'new' only or all of them:
    var displayingNewSnapsOnly = Bool()
    
   
    @IBOutlet weak var typeOfSnapsLabel: UILabel!
    @IBOutlet weak var snapsTableView: UITableView!

    override func viewDidLoad()
    {
        super.viewDidLoad()

        displayingNewSnapsOnly = true
        
        chooseTypeOfSnaps.setTitle("Show new", for: .normal)
        
        snapsTableView.dataSource = self
        snapsTableView.delegate = self
        
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
            
            self.allSnaps.append(fetchedSnap)
            
            if fetchedSnap.isSeen == "false"
            {
                self.newSnaps.append(fetchedSnap)
            }
            
            self.snapsTableView.reloadData()
        })
        
        Database.database().reference().child("Users").child(currentUid!).child("snaps").observe(DataEventType.childRemoved, with:
        { (snaphot) in print()
            
            var index = 0
            for snap in self.allSnaps {
                if snap.key == snaphot.key {
                    self.allSnaps.remove(at: index)
                }
                index += 1
            }
            
            self.snapsTableView.reloadData()
        })
        
        //fetch the new snaps from the whole list and assign them to the 'newSnaps' array:
        filterNewSnaps()
        self.snapsTableView.reloadData()

    }
    


    
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
    
    @IBAction func addSnap(_ sender: Any)
    {
        performSegue(withIdentifier: "addButtonSegue", sender: nil)
    }
    
    //this function hides the status bar upwards:
    override var prefersStatusBarHidden: Bool
    {
        return true
    }
    
    
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
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell()
        
        if /*are we*/ displayingNewSnapsOnly
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
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        performSegue(withIdentifier: "showSnapSegue", sender: allSnaps[indexPath.row])
        print("\n Trying to send by segue: ", allSnaps[indexPath.row].description)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier=="showSnapSegue")
        {
            let nextVC = segue.destination as! ShowSnapVC
            nextVC.specificSnap = sender as! Snap
        }
    }

    func filterNewSnaps()
    {
        newSnaps.removeAll()
        
        for snap in allSnaps where snap.isSeen == "false"
        {
            newSnaps.append(snap)
        }
        
        print(" #Number of all snaps right away: ", allSnaps.count)
    }
  
}



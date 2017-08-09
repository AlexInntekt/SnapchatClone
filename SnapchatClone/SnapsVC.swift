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
    var currentSnaps = [Snap]()
   
    @IBOutlet weak var snapsTableView: UITableView!

    override func viewDidLoad()
    {
        super.viewDidLoad()

        snapsTableView.dataSource = self
        snapsTableView.delegate = self
        
        let currentUid = Auth.auth().currentUser?.uid
        
        Database.database().reference().child("Users").child(currentUid!).child("snaps").observe(DataEventType.childAdded, with: {(snap) in print()
            
            let fetchedSnap = Snap()
            
            fetchedSnap.from = snap.childSnapshot(forPath: "from").value as! String
            fetchedSnap.imageURL = snap.childSnapshot(forPath: "imageURL").value as! String
            fetchedSnap.description = snap.childSnapshot(forPath: "description").value as! String
            fetchedSnap.key = snap.key
            
            self.currentSnaps.append(fetchedSnap)
            self.snapsTableView.reloadData()
        })
        
        
        Database.database().reference().child("Users").child(currentUid!).child("snaps").observe(DataEventType.childRemoved, with: {(snaphot) in print()
            

            var index = 0
            for snap in self.currentSnaps {
                if snap.key == snaphot.key {
                    self.currentSnaps.remove(at: index)
                }
                index += 1
            }
            
            self.snapsTableView.reloadData()
        })

    }

    override func viewWillAppear(_ animated: Bool)
    {

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
        return currentSnaps.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(currentSnaps[indexPath.row].from): \(currentSnaps[indexPath.row].description)"
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        performSegue(withIdentifier: "showSnapSegue", sender: currentSnaps[indexPath.row])
        print("\n Trying to send by segue: ", currentSnaps[indexPath.row].description)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier=="showSnapSegue")
        {
            let nextVC = segue.destination as! ShowSnapVC
            nextVC.specificSnap = sender as! Snap
        }
    }

  
}

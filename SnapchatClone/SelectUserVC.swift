//
//  SelectUserVC.swift
//  SnapchatClone
//
//  Created by Manolescu Mihai Alexandru on 05/08/2017.
//  Copyright © 2017 Manolescu Mihai Alexandru. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class SelectUserVC: UIViewController, UITableViewDataSource, UITableViewDelegate
{
    
    @IBOutlet weak var usersTableView: UITableView!
    
    var users : [User] = []
    
    var specificSnap = Snap()

    override func viewDidLoad()
    {
        super.viewDidLoad()

        
        
        usersTableView.dataSource = self
        usersTableView.delegate = self
        
        
        Database.database().reference().child("Users").observe(DataEventType.childAdded, with: {(snapshot) in print(snapshot)
 

            
        let user = User()
        user.email = (snapshot.childSnapshot(forPath: "email").value) as! String
        //user.email = snapshot.value(forKey: "email") as! String    //  this line does not work anymore with these versions, in the case that a parent has more then one child.
        user.uid = snapshot.key
            
            
        print("\n\nFetching from Firebase the user with \n",user.email,"\n")
            
        self.users.append(user)
            
        self.usersTableView.reloadData()
            
        })
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = UITableViewCell()
        
        let user = users[indexPath.row]
        
        cell.textLabel?.text = "\(user.email) \(user.uid)"
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let user = users[indexPath.row]
        
        let currentUserEmail = Auth.auth().currentUser?.email
        
        let snap = ["from": currentUserEmail, "description": specificSnap.description, "imageID": specificSnap.imageID, "imageURL": specificSnap.imageURL]
        
        Database.database().reference().child("Users").child(user.uid).child("snaps").childByAutoId().setValue(snap)
    }


}







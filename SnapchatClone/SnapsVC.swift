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
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        performSegue(withIdentifier: "showSnapSegue", sender: currentSnaps[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if(segue.identifier=="showSnapSegue")
        {
            let nextVC = ShowSnapVC()
            nextVC.specificSnap = sender as! Snap
        }
    }

  
}

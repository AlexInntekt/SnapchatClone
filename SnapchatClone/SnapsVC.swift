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

class SnapsVC: UIViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

  
}

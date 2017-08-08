//
//  ShowSnapVC.swift
//  SnapchatClone
//
//  Created by Manolescu Mihai Alexandru on 08/08/2017.
//  Copyright © 2017 Manolescu Mihai Alexandru. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import SDWebImage

class ShowSnapVC: UIViewController
{
    var specificSnap = Snap()
    
    @IBOutlet weak var snapImage: UIImageView!

    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        let currentUid = Auth.auth().currentUser?.uid
        
        Database.database().reference().child("Users").child(currentUid!).child("snaps").observe(DataEventType.childAdded, with: {(snap) in print(snap)
            
            let fetchedSnap = Snap()
            
            fetchedSnap.from = snap.childSnapshot(forPath: "from").value as! String
            fetchedSnap.imageURL = snap.childSnapshot(forPath: "imageURL").value as! String
            fetchedSnap.description = snap.childSnapshot(forPath: "description").value as! String
            
            
            
            if let adressURL = URL(string: fetchedSnap.imageURL)
            {
                self.snapImage.sd_setImage(with: adressURL, completed: nil)
            }
            else
            {
                print("\n\nProblem over here")
            }
            
        })
        

    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

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

    @IBOutlet weak var snapTitle: UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        
        print("\n > ", specificSnap)
        
        if let adressURL = URL(string: specificSnap.imageURL)
        {
            self.snapImage.sd_setImage(with: adressURL, completed: nil)
        }
        else
        {
            print("\n\nProblem over here. ")
            
        }
        
        snapTitle.text = specificSnap.description


    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

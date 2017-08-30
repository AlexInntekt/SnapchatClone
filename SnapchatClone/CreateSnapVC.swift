//
//  CreateSnapVC.swift
//  SnapchatClone
//
//  Created by Manolescu Mihai Alexandru on 04/08/2017.
//  Copyright © 2017 Manolescu Mihai Alexandru. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class CreateSnapVC: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    
    @IBOutlet weak var showPicture: UIImageView!
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var labelOne: UILabel!
    
    var imagePicker = UIImagePickerController()

    override func viewDidLoad()
    {
        super.viewDidLoad()

        titleTextField.delegate = self
        
        imagePicker.delegate = self
        
        
        self.nextButton.titleLabel?.text = "Next"
        self.nextButton.setTitleColor(UIColor.lightGray, for: .normal)
        self.nextButton.isEnabled = false
        
        
        titleTextField.backgroundColor = .clear

    }
    

    @IBAction func takePictureButton(_ sender: Any)
    {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion:  nil)
    }

    

    @IBAction func goToPhotos(_ sender: Any)
    {
        print("\n\n#Choosing picture from library")
        
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }

    
    @IBOutlet weak var nextButton: UIButton!
    @IBAction func nextButton(_ sender: Any)
    {
        view.endEditing(true)
        
        let currentImageUID = "\(NSUUID().uuidString).jpg"
        
        let snap = Snap()
        snap.imageID = currentImageUID
        snap.description = titleTextField.text!
        snap.isSeen = "false"
        
        nextButton.isEnabled = false
        self.labelOne.text = "Uploading image..."
        self.nextButton.setTitleColor(UIColor.lightGray, for: .normal)
        
        let imagesFolder = Storage.storage().reference().child("images")
        
        let ImadeData = UIImageJPEGRepresentation(showPicture.image!, 0.2)!
        print("\n\n#Trying to upload image on the database Firebase \n")
        

        imagesFolder.child(currentImageUID).putData(ImadeData, metadata: nil, completion: {(metadata,error) in
            if error != nil
            {
                print("\n\n! Error code f304hg93hg9 \n\n")
                
            }
            else
            {
               print("\n\n#Succesfully uploaded the image on Firebase.\n") 
                
               self.nextButton.isEnabled = true
               self.nextButton.setTitleColor(UIColor.blue, for: .normal)
               self.nextButton.setTitle("Next", for: .normal)
               self.showPicture.image = nil
               self.showPicture.backgroundColor = UIColor.lightGray
                
                
               snap.imageURL = (metadata?.downloadURL()?.absoluteString)!
               print("\n\n#The data's URL on the server is: ",snap.imageURL)
                
               self.performSegue(withIdentifier: "SelectUserSegue", sender: snap)
               
                
            }
        })
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
         let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
         showPicture.image = image
        
         dismiss(animated: true, completion: nil)
        
         //once the picture is taken, make the background transparent:
         showPicture.backgroundColor = UIColor.clear
        
         nextButton.isEnabled = true
         nextButton.setTitleColor(UIColor.blue, for: .normal)
        
    }
    
    
    //this function hides the status bar upwards:
    override var prefersStatusBarHidden: Bool
    {
        return true
    }
    
    
    //dissmis the keyboard after tapping on 'return' from the textField:
    func textFieldShouldReturn(_ titleTextfield: UITextField) -> Bool
    {
        self.view.endEditing(true)
        return true
    }

    override func viewWillAppear(_ animated: Bool)
    {
        labelOne.text = ""
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let nextVC = segue.destination as! SelectUserVC
        nextVC.specificSnap = sender as! Snap
    }
}







//
//  AuthenticationVC.swift
//  SnapchatClone
//
//  Created by Manolescu Mihai Alexandru on 01/08/2017.
//  Copyright © 2017 Manolescu Mihai Alexandru. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

class AuthenticationVC: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        
    }
    
    
    
    @IBOutlet weak var turnOnButton: UIButton!
    @IBAction func turnOnButton(_ sender: Any)
    {
        
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
            
              print("\n\n # Trying to sign in...\n")
            if error != nil
              {
                print("\n\n! Error found while trying to sign in with Firebase. Code's Author's Error code: 3qt45yhq45 \n\n")
                
                Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: { (user, error) in
                    print("\n\n # Trying to create a new user...\n")
                    
                    if error != nil
                      {
                        print("\n\n! Error found while trying to create an user with Firebase. Author's Error code: 3463gdh \n\n")
                      }
                    else
                      {
                        //adding created user's info in the database:
                        let users = Database.database().reference().child("Users")
                        users.child(user!.uid).child("email").setValue(user!.email!)
                        
                        print("\n\n #Succesfully created an user with Firebase \n")
                        
                        print("\n#Calling segue 'signInSegue'\n")
                        
                        Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                            
                            print("\n\n # Trying to sign in with the new created account...\n")
                            
                            if error != nil
                            {
                                print("\n\n! Error found while trying to sign in with Firebase with the new created account. Code's Author's Error code: mipx25g \n\n")
                            }
                            else
                            {
                                print("\n\n #Succesfully signed in with the new user created recently \n")
                            }
                            
                        }
                        
                        self.performSegue(withIdentifier: "signInSegue", sender: nil)
                      }
                })
                
              }
            else
              {
                print("\n\n #Succesfully signed in with Firebase \n")
                
                print("\n#Calling segue 'signInSegue'\n")
                self.performSegue(withIdentifier: "signInSegue", sender: nil)
              }

    }
    
        

 

        
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
    
    //add user tot he database:
    func addToDatabase()
    {
        
    }


}


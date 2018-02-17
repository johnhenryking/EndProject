//
//  LoginViewController.swift
//  EndProject
//
//  Created by User on 2/16/18.
//  Copyright © 2018 E&D. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    var messagesController: MessagesController?
    
    override func viewDidLoad() {
        loginButton.layer.cornerRadius = 4.0
        loginButton.layer.masksToBounds = true
    }
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBAction func backtoSignUpButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logInButton(_ sender: UIButton) {
        handleLogin()
    }
    
    func handleLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Form is not valid")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                print(error ?? "")
                return
            }
            
            //successfully logged in our user
            
            self.messagesController?.fetchUserAndSetupNavBarTitle()
            
            self.dismiss(animated: true, completion: nil)
            
        })
        
    }

    
    

}

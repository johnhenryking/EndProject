//
//  ViewController.swift
//  EndProject
//
//  Created by User on 2/16/18.
//  Copyright © 2018 E&D. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {
    
    var messagesController: MessagesController?
    
    override func viewDidLoad() {
        signUpLabel.layer.cornerRadius = 4.0
        signUpLabel.layer.masksToBounds = true
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
    }

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var signUpLabel: UIButton!
    
    @IBAction func signUpButton(_ sender: UIButton) {
       handleLogin()
    }
    
    @IBAction func loginUserPage(_ sender: UIButton) {
        
    }
    
    @IBAction func chooseProfileImage(_ sender: UITapGestureRecognizer) {
        
        
    }
    func handleLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Form is not valid")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                print(error?.localizedDescription ?? "")
                return
            }
            
            //successfully logged in our user
            
//            self.messagesController?.fetchUserAndSetupNavBarTitle()
            
            self.dismiss(animated: true, completion: nil)
            
        })
        
    }
    
    @objc func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    

}


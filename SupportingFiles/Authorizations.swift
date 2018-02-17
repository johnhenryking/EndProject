//
//  Authorizations.swift
//  Login-Beta-1
//
//  Created by User on 1/14/18.
//  Copyright © 2018 Peep. All rights reserved.
//

import UIKit
import Firebase

class Authorizations {
    
    // Sign Up
    
    func signUp(view: UIViewController, username: String, email: String, password: String) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            
            if error == nil {
                
                print("User successfully signed up")
                //Goes to the Setup page which lets the user take a photo for their profile picture and also chose a username
                
                let timeline = UIStoryboard(name: "Timeline", bundle: nil).instantiateInitialViewController()
                view.present(timeline!, animated: false, completion: nil)
                
            } else {
                
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                view.present(alertController, animated: true, completion: nil)
            }
            
            guard let uid = user?.uid else { return }
            let usernameValues = ["username": username]
            let values = [uid: usernameValues]
             Database.database().reference().child("users").updateChildValues(values)
            
        }
    }
    
    // Log In
    
    func login(view: UIViewController, email: String, password: String) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            
            if error == nil {
                let timeline = UIStoryboard(name: "Timeline", bundle: nil).instantiateInitialViewController()
                view.present(timeline!, animated: false, completion: nil)
                
                print("User login Succesful")
                
            } else {
                
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                view.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    // Log Out
    
    func logout(view: UIViewController) {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            do {
                try Auth.auth().signOut()
                let loginScreen = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController()
                view.present(loginScreen!, animated: false, completion: nil)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Nevermind", style: .cancel, handler: nil))
        view.present(alertController, animated: true, completion: nil)
        
    }
    
    // Check if user is Logged in
    
    func isUserLoggedIn(view: UIViewController) {
        
        Auth.auth().addStateDidChangeListener { auth, user in
            if user == nil {
                let loginScreen = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController()
                view.present(loginScreen!, animated: false, completion: nil)
            } else {
                return
            }
        }
    }
    
    // Save Image
    
    func saveImage(image: UIImage?, caption: String?, sender: UIBarButtonItem, view: UIViewController, identifier: String) {
        
        guard let image = image else { return }
        let uploadData = UIImageJPEGRepresentation(image, 0.5)
        let filename = NSUUID().uuidString
        
        sender.isEnabled = false
        Storage.storage().reference().child("posts").child(filename).putData(uploadData!, metadata: nil) { (metadata, error) in
            
            if error == nil {
                
                guard let imageUrl = metadata?.downloadURL()?.absoluteString else { return }
                print("Successfully uploaded image to firebase", imageUrl)
                self.saveImageToDatabaseWithUrl(image: image, caption: caption ?? "", imageURL: imageUrl, sender: sender, view: view, identifer: identifier)
                
            } else {
                
                let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                view.present(alertController, animated: true, completion: nil)
                sender.isEnabled = true
            }
        }
    }
    
    // Save Image
    func saveImageToDatabaseWithUrl(image: UIImage?, caption: String?, imageURL: String, sender: UIBarButtonItem, view: UIViewController, identifer: String) {
        guard let postImage = image else { return }
        guard let userid = Auth.auth().currentUser?.uid else { return }
        
        let userPostReference = Database.database().reference().child("posts").child(userid)
        let reference = userPostReference.childByAutoId()
        
        let values = ["imageUrl" : imageURL, "caption" : caption ?? "", "imageWidth" : postImage.size.width, "imageHeight" : postImage.size.height, "creationDate" : Date().timeIntervalSince1970] as [String : Any]
        reference.updateChildValues(values) { (error, ref) in
            
            if error == nil {
                print("Successfully saved post to database")
                view.performSegue(withIdentifier: identifer, sender: view)
            } else {
                sender.isEnabled = true
                print(error?.localizedDescription ?? "")
            }
        }
    }
    
}





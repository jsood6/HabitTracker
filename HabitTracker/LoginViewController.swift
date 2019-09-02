//
//  LoginViewController.swift
//  HabitTracker
//
//  Created by Jigyasaa Sood on 9/1/19.
//  Copyright © 2019 Jigyasaa Sood. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    //var db:DatabaseReference!
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameField.layer.cornerRadius = 10.0
        passwordField.layer.cornerRadius = 10.0
        
        loginBtn.layer.cornerRadius = 10.0
        signUpBtn.layer.cornerRadius = 10.0
        db = Firestore.firestore()
       
        
        usernameField.becomeFirstResponder()
        

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        if((usernameField.text?.isEmpty)! || passwordField.text!.isEmpty){
            print("empty fields....")
        }
        else{
            Auth.auth().createUser(withEmail: usernameField.text!, password: passwordField.text!) { authResult, error in
                if(error == nil){
                    print("Successfully created user!")
                    // Add a new document in collection "users"
                    self.db.collection("users").document(self.usernameField.text!).setData([
                        "name": self.usernameField.text,
                        "habits":[
                            "Workout":[
                                "completionValue":"2",
                                "goal":"2"],
                            "CS 603 homework":[
                                "completionValue":"3",
                                "goal":"5"],
                            "Dance Practice":[
                                "completionValue":"1",
                                "goal":"2"]
                        ]
                        
                        
                    ]) { err in
                        if let err = err {
                            print("Error writing document: \(err)")
                        } else {
                            print("Document successfully written!")
                        }
                    }
                    
                    self.performSegue(withIdentifier: "LoginSegue", sender:nil)
                }
                else{
                    print(error?.localizedDescription)
                }
            }
        }
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        if((usernameField.text?.isEmpty)! || passwordField.text!.isEmpty){
            print("empty fields....")
        }
        else{
            Auth.auth().signIn(withEmail: usernameField.text!, password: passwordField.text!) { [weak self] user, error in
                if(error == nil){
                     print("Sign in successful....")
                    self?.performSegue(withIdentifier: "LoginSegue", sender: nil)
                }
                else{
                    print(error?.localizedDescription)
                }
                
            }
        }
    }
    
    @IBAction func hideKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

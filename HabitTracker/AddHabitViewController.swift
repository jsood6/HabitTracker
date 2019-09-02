//
//  AddHabitViewController.swift
//  HabitTracker
//
//  Created by Jigyasaa Sood on 9/2/19.
//  Copyright © 2019 Jigyasaa Sood. All rights reserved.
//

import UIKit
import Firebase

class AddHabitViewController: UIViewController {

    @IBOutlet weak var habitNameField: UITextField!
    
    @IBOutlet weak var goalField: UITextField!
    
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addBtnPressed(_ sender: Any) {
        if(!(habitNameField.text?.isEmpty)! && !(goalField.text?.isEmpty)!){
            db.collection("users").document((Auth.auth().currentUser?.email)!).setData(["habits": [
                habitNameField?.text:[
                    "completionValue":"0",
                    "goal":goalField?.text]
                ]], merge: true)
                
            { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated!")
                }
            }
            
            self.dismiss(animated: true, completion: nil)
        }
       
        
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

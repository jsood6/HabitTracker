//
//  HabitsDetailViewController.swift
//  HabitTracker
//
//  Created by Jigyasaa Sood on 9/1/19.
//  Copyright © 2019 Jigyasaa Sood. All rights reserved.
//

import UIKit
import Firebase

class HabitsDetailViewController: UIViewController {

    @IBOutlet weak var habitName: UILabel!
    @IBOutlet weak var currGoalTextField: UITextField!
    
    @IBOutlet weak var saveHoursBtn: UIButton!
    @IBOutlet weak var hoursSpentTextFiedl: UITextField!
    @IBOutlet weak var stopGoalBtn: UIButton!
    @IBOutlet weak var startGoalBtn: UIButton!
    @IBOutlet weak var saveGoalBtn: UIButton!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    var habitNameStr: String = ""
    var goalValStr: String = ""
    
    var timer = Timer()
    var counter = 0.0
    var isRunning = false
    
    var db:Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        habitName.text = habitNameStr
        currGoalTextField.text = goalValStr
        
        
        startGoalBtn.layer.cornerRadius = 0.5 * startGoalBtn.bounds.size.width
        startGoalBtn.clipsToBounds = true
        
        stopGoalBtn.layer.cornerRadius = 0.5 * startGoalBtn.bounds.size.width
        stopGoalBtn.clipsToBounds = true
        
        saveGoalBtn.layer.cornerRadius = 10.0
        saveHoursBtn.layer.cornerRadius = 10.0
        
        startGoalBtn.isEnabled = true
        stopGoalBtn.isEnabled = false
        
        db = Firestore.firestore()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func removeBtnPressed(_ sender: Any) {
        db.collection("users").document(Auth.auth().currentUser!.email!).updateData([
            "habits."+habitNameStr: FieldValue.delete(),
            ]) { err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                    let alert = UIAlertController(title: "Alert", message: "Habit successfully deleted", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    
                    
                    self.present(alert, animated: true)
                }
        }
    }
    
    @IBAction func stopGoalBtnPressed(_ sender: Any) {
        timer.invalidate()
        startGoalBtn.isEnabled = true
        stopGoalBtn.isEnabled = false
        isRunning = false
        stopGoalBtn.backgroundColor = UIColor.gray
        startGoalBtn.backgroundColor = UIColor(red: 198, green: 224, blue: 185)
        var currentTime = UserDefaults.standard.double(forKey: habitNameStr)
        currentTime = currentTime + counter
        currentTime = currentTime/3600 //to convert seconds to hours
        UserDefaults.standard.set(currentTime, forKey: habitNameStr)
    }
    @IBAction func startGoalBtnPressed(_ sender: Any) {
        if !isRunning{
            timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(UpdateTime), userInfo: nil, repeats: true)
            startGoalBtn.isEnabled = false
            stopGoalBtn.isEnabled = true
            isRunning = true
            startGoalBtn.backgroundColor = UIColor.gray
            stopGoalBtn.backgroundColor = UIColor(red: 198, green: 224, blue: 185)
        }
    }
    
    @objc func UpdateTime(){
        counter += 0.1
        timerLabel.text = String(format: "%.1f", counter)
    }
    
    @IBAction func saveGoalBtnPressed(_ sender: Any) {
        var currGoal = currGoalTextField.text
        // Add a new document in collection "users"
        var str = "habits." + habitNameStr + ".goal"
        self.db.collection("users").document((Auth.auth().currentUser?.email)!).updateData([
            str: currGoal])
        { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated!")
            }
        }
    }
    
    
    @IBAction func saveHoursBtnPressed(_ sender: Any) {
        var currHours = String(UserDefaults.standard.double(forKey: habitNameStr))
        if(hoursSpentTextFiedl.text != ""){
            currHours = hoursSpentTextFiedl.text!
        }
        var str = "habits." + habitNameStr + ".completionValue"
        // Add a new document in collection "users"
        self.db.collection("users").document((Auth.auth().currentUser?.email)!).updateData([
            str : String(currHours)])
        { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated!")
            }
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

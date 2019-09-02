//
//  HomePageViewController.swift
//  HabitTracker
//
//  Created by Jigyasaa Sood on 9/1/19.
//  Copyright © 2019 Jigyasaa Sood. All rights reserved.
//

import UIKit
import Firebase

class HomePageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var habitsTableView: UITableView!
    var db: Firestore!
    var habitsDict: NSDictionary = [:]
    var habitNames: NSMutableArray = []
    var habitsColorArr : [Int] = [0xFFB35B, 0xB1DCE3, 0xFF5610, 0x3C5AD8, 0xE4B15B, 0xBAAAB3, 0xE06B92]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.habitsTableView.delegate = self
        self.habitsTableView.dataSource = self
        
        db = Firestore.firestore()
        self.fetchHabits()
       
        self.habitsTableView.rowHeight = 120
        
        

        
       
              // Do any additional setup after loading the view.
    }
    
    func fetchHabits() {
        let user = Auth.auth().currentUser
        let docRef = db.collection("users").document((user?.email)!)
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.habitsDict = document.get("habits") as! NSDictionary
                print("habits dict: \(self.habitsDict)")
                for i in Array(self.habitsDict) {
                    self.habitNames.add("\(i.key)")
                }
                
                self.habitsTableView.reloadData()
                //let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                //print("Document data: \(dataDescription)")
            } else {
                print("Document does not exist")
                
            }
        }
        
        
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return habitsDict.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "habitCell", for: indexPath) as! HabitCell
        cell.habitName.text = Array(habitsDict)[indexPath.row].key as! String
        print("key is....." , Array(habitsDict)[indexPath.row].key)
        print("value is....." , Array(habitsDict)[indexPath.row].value)
        var keyVal = habitsDict.value(forKey: Array(habitsDict)[indexPath.row].key as! String) as! NSDictionary
        var goalVal = keyVal.value(forKey: "goal") as! String
        
        let cv = Float(keyVal.value(forKey: "completionValue") as! String)
        let gv = Float(goalVal)
        var completionVal = cv!/gv!
        completionVal = completionVal * 100
        cell.completionPercentLabel.text = String(completionVal)
        
        cell.backgroundColor = UIColor(rgb: habitsColorArr[indexPath.row])
        cell.layoutMargins = UIEdgeInsets(top: 20.0, left: 5.0, bottom: 20.0, right: 5.0)
       cell.layer.cornerRadius = 10.0
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func viewWillAppear(_ animated: Bool) {
        if let index = self.habitsTableView.indexPathForSelectedRow{
            self.habitsTableView.deselectRow(at: index, animated: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchHabits()
        habitsTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "HabitDetailSegue"){
        let cell = sender as! UITableViewCell
        if let indexPath = habitsTableView.indexPath(for: cell){
            //            let movie = Movie(dictionary: movies[indexPath.row] )
            
            
            let detailViewController = segue.destination as! HabitsDetailViewController
            
            print("++++++++++++++++++++", self.habitsDict[indexPath.row])
            print("====================", Array(habitsDict)[indexPath.row].key)
            detailViewController.habitNameStr = Array(habitsDict)[indexPath.row].key as! String
            
            
            var keyVal = habitsDict.value(forKey: Array(habitsDict)[indexPath.row].key as! String) as! NSDictionary
            var goalVal = keyVal.value(forKey: "goal") as! String
            
           detailViewController.goalValStr = goalVal
            
            }
            
            
        }
    }
    
    

}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}

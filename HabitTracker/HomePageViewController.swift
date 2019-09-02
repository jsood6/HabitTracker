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
        cell.completionPercentLabel.text = Array(habitsDict)[indexPath.row].value as! String
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

//
//  GraphViewController.swift
//  HabitTracker
//
//  Created by Jigyasaa Sood on 9/2/19.
//  Copyright © 2019 Jigyasaa Sood. All rights reserved.
//

import UIKit
import Charts

class GraphViewController: UIViewController {
    @IBOutlet weak var pieChart: PieChartView!
    
    var graphEntries = [PieChartDataEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pieChart.chartDescription?.text = ""
        
        var entry1 = PieChartDataEntry(value: 20)
        var entry2 = PieChartDataEntry(value: 30)
         var entry3 = PieChartDataEntry(value: 50)
        entry1.label = "workout"
        
        
        entry2.label = "dance practice"
        
         entry3.label = "CS 603 homework"
        
        graphEntries = [entry1, entry2, entry3]
        
        updateChartData()

        // Do any additional setup after loading the view.
    }
    
    func updateChartData() {
        
        let chartDataSet = PieChartDataSet(entries: graphEntries, label: nil)
        let chartData = PieChartData(dataSet: chartDataSet)
       
        let colors = [UIColor(rgb:  0xFFB35B), UIColor(rgb:0xB1DCE3 ), UIColor(rgb:0xFF5610)]
        chartDataSet.colors = colors as! [NSUIColor]
        
        pieChart.data = chartData
        
        
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


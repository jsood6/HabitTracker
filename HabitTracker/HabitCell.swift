//
//  HabitCell.swift
//  HabitTracker
//
//  Created by Jigyasaa Sood on 9/1/19.
//  Copyright © 2019 Jigyasaa Sood. All rights reserved.
//

import UIKit

class HabitCell: UITableViewCell {

    @IBOutlet weak var habitName: UILabel!
    @IBOutlet weak var completionPercentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame) {
            var frame =  newFrame
            frame.origin.y += 4
            frame.origin.x += 4
            frame.size.width -= 2 * 5
            frame.size.height -= 2 * 5
            super.frame = frame
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

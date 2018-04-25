//
//  TodayViewTableViewCell.swift
//  Places NearMe
//
//  Created by Arian Gonzalez on 3/25/18.
//  Copyright © 2018 AGlez. All rights reserved.
//

import UIKit

class TodayViewTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var rating: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

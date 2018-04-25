//
//  BusinessCell.swift
//  NearMe
//
//  Created by Arian Gonzalez on 3/19/18.
//  Copyright © 2018 AGlez. All rights reserved.
//

import UIKit
import CDYelpFusionKit

class BusinessCell: UITableViewCell {

   
    @IBOutlet weak var nameView: UILabel!
    
    @IBOutlet weak var locationView: UILabel!
    @IBOutlet weak var phoneView: UILabel!
    @IBOutlet weak var isOpenView: UILabel!
    @IBOutlet weak var ratingView: UILabel!
    
    @IBOutlet weak var distanceView: UILabel!
    
    
    var business: CDYelpBusiness!{
        didSet{
            nameView.text = business.name
            
            
            
            phoneView.text = business.phone
            let addr1 = business.location?.addressOne
            let city = business.location?.city
            let state = business.location?.state
            let address = addr1! + ", " + city! + ", " + state!
            locationView.text = address
           
            if (business.isClosed! == true ){
                 isOpenView.text = "Closed"
            }else{
                isOpenView.text = "Open"
            }
            
            let distance:Double = business.distance!/1609.34
            distanceView.text = String(format: "%.2f", distance) + " miles"
            ratingView.text = "Rating: \(business.rating ?? 0.00)"
            
           
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


//
//  EarthQuakeFeedTableViewCell.swift
//  What'sShakin
//
//  Created by Kitzmiller, Andrew L (Marketing Department) on 1/25/16.
//  Copyright © 2016 Kitzmiller, Andrew L. All rights reserved.
//

import UIKit

class EarthQuakeFeedTableViewCell: UITableViewCell {

    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var dateTimeLabel: UILabel!
    
    @IBOutlet weak var magnitudeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//
//  CustomTableViewCell.swift
//  SasquatchTravel
//
//  Created by Evan on 26/05/2015.
//  Copyright (c) 2015 Evan. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var hotelLabel: UILabel!
    @IBOutlet weak var bookingLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

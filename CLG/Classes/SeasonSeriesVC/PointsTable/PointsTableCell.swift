//
//  PointsTableCell.swift
//  CLG
//
//  Created by Anuj Naruka on 9/17/18.
//  Copyright © 2018 Anuj Naruka. All rights reserved.
//

import UIKit

class PointsTableCell: UITableViewCell {

@IBOutlet weak var LblTeamName: UILabel!
@IBOutlet weak var LblPlayed: UILabel!
@IBOutlet weak var LblPoints: UILabel!
@IBOutlet weak var LblNRR: UILabel!
@IBOutlet weak var LblWins: UILabel!
@IBOutlet weak var LblNoResult: UILabel!
@IBOutlet weak var LblLose: UILabel!

override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
}

override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
}
}

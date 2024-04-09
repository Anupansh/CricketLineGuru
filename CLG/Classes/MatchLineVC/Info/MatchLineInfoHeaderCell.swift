//
//  InfoHeaderCell.swift
//  CLG
//
//  Created by Anuj Naruka on 8/1/18.
//  Copyright © 2018 Anuj Naruka. All rights reserved.
//

import UIKit

class MatchLineInfoHeaderCell: UITableViewHeaderFooterView {
    
    //MARK:-IBOutlet
    @IBOutlet weak var lblTeam1: UILabel!
    @IBOutlet weak var lblTeam2: UILabel!
    @IBOutlet weak var imgTeam1: CircularImageV!
    @IBOutlet weak var imgTeam2: CircularImageV!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
}

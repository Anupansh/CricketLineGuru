//
//  TestMatchRateCell.swift
//  CLG
//
//  Created by Anuj Naruka on 9/3/18.
//  Copyright © 2018 Anuj Naruka. All rights reserved.
//

import UIKit

class TestMatchRateCell: UITableViewCell {

    @IBOutlet weak var lblR1: UILabel!
    @IBOutlet weak var lblR2: UILabel!
    @IBOutlet weak var lblR3: UILabel!
    @IBOutlet weak var lblR4: UILabel!
    @IBOutlet weak var lblR5: UILabel!
    @IBOutlet weak var lblR6: UILabel!
    @IBOutlet weak var lblL1: UILabel!
    @IBOutlet weak var lblL2: UILabel!
    @IBOutlet weak var lblLambi: UILabel!
    @IBOutlet weak var lblSuspended: UILabel!
    @IBOutlet weak var viewLambi: UIView!
    @IBOutlet weak var lblR1R2Title: UILabel!
    @IBOutlet weak var lbl3R4Title: UILabel!
    @IBOutlet weak var lblR5R6Title: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//
//  MatchRateCell.swift
//  CLG
//
//  Created by Anuj Naruka on 6/28/18.
//  Copyright © 2018 Anuj Naruka. All rights reserved.
//

import UIKit

class MatchRateCell: UITableViewCell {

    //MARK:-IBOutlets
    @IBOutlet weak var suspendLbl: UILabel!
    @IBOutlet weak var rateBoard: UIView!
    @IBOutlet weak var txt_marketRate1: UILabel!
    @IBOutlet weak var txt_marketRate2: UILabel!
    @IBOutlet weak var txt_favouriteTeam: UILabel!
    @IBOutlet weak var txt_sessionOver: UILabel!
    @IBOutlet weak var txt_sessionRate1: UILabel!
    @IBOutlet weak var txt_sessionRate2: UILabel!
    @IBOutlet weak var txtRunBall1: UILabel!
    @IBOutlet weak var txtRunBall2: UILabel!
    @IBOutlet weak var markeetRateLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

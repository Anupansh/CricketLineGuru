//
//  PlayersScoreCell.swift
//  CLG
//
//  Created by Anuj Naruka on 6/28/18.
//  Copyright © 2018 Anuj Naruka. All rights reserved.
//

import UIKit

class PlayersScoreCell: UITableViewCell {

    //MARK:-IBOutlets
    @IBOutlet weak var lblBatsman1Name: UILabel!
    @IBOutlet weak var lblBatsman1Run: UILabel!
    @IBOutlet weak var lblBatsman1Fours: UILabel!
    @IBOutlet weak var lblBatsman1Six: UILabel!
    @IBOutlet weak var lblBatsman1SRR: UILabel!
    @IBOutlet weak var lblBatsman1Ball: UILabel!
    
    @IBOutlet weak var lblBatsman2Name: UILabel!
    @IBOutlet weak var lblBatsman2Run: UILabel!
    @IBOutlet weak var lblBatsman2Fours: UILabel!
    @IBOutlet weak var lblBatsman2Six: UILabel!
    @IBOutlet weak var lblBatsman2SRR: UILabel!
    @IBOutlet weak var lblBatsman2Ball: UILabel!
    
    @IBOutlet weak var lblBowlerName: UILabel!
    @IBOutlet weak var lblBowlerRun: UILabel!
    @IBOutlet weak var lblBowlerOver: UILabel!
    @IBOutlet weak var lblBowlerWicket: UILabel!
    @IBOutlet weak var lblBowlerEco: UILabel!
    
    @IBOutlet weak var lblPartnership: UILabel!
    @IBOutlet weak var lastWktLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

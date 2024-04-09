//
//  CurrentRunRateCell.swift
//  CLG
//
//  Created by Anuj Naruka on 6/28/18.
//  Copyright © 2018 Anuj Naruka. All rights reserved.
//

import UIKit

class CurrentRunRateCell: UITableViewCell {

    //MARK:-IBOutlets
    @IBOutlet weak var uv_scoreBoard: UIView!
    @IBOutlet weak var lbl_target: UILabel!
    @IBOutlet weak var lbl_test_rem_ovr: UILabel!
    @IBOutlet weak var lbl_rem_ovr: UILabel!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var lbl_targetLabel: UILabel!
    @IBOutlet weak var lbl_ballR: UILabel!
    @IBOutlet weak var lbl_BallRLable: UILabel!
    @IBOutlet weak var lbl_runNLabel: UILabel!
    @IBOutlet weak var lbl_runNeeded: UILabel!
    @IBOutlet weak var lbl_RRR: UILabel!
    @IBOutlet weak var lbl_RRRLabel: UILabel!
    @IBOutlet weak var lbl_scoreSeparator: UILabel!
    @IBOutlet weak var secondInningsView: UIView!
    @IBOutlet weak var lbl_CRR: UILabel!
    @IBOutlet weak var lbl_CRRValue: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.middleView.isHidden = true
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}

//
//  ProjectedScoreCell.swift
//  CLG
//
//  Created by Sani Kumar on 15/05/19.
//  Copyright © 2019 Anuj Naruka. All rights reserved.
//

import UIKit

class ProjectedScoreCell: UITableViewCell {

    @IBOutlet weak var runRateLbl: UILabel!
    @IBOutlet weak var projectedLbl: UILabel!
    @IBOutlet weak var runRate1Lbl: UILabel!
    @IBOutlet weak var runRate2Lbl: UILabel!
    @IBOutlet weak var runRate3Lbl: UILabel!
    @IBOutlet weak var runRate4Lbl: UILabel!
    @IBOutlet weak var projected1Lbl: UILabel!
    @IBOutlet weak var projected2Lbl: UILabel!
    @IBOutlet weak var projected3Lbl: UILabel!
    @IBOutlet weak var projected4Lbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}

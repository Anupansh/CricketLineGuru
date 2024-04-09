//
//  LiveMatchAdCell.swift
//  CLG
//
//  Created by Sani Kumar on 19/08/19.
//  Copyright © 2019 Anuj Naruka. All rights reserved.
//

import UIKit

class LiveMatchAdCell: UITableViewCell {
    
    @IBOutlet weak var MainView: UIView!
    @IBOutlet weak var lblMatchInfo: UILabel!
    @IBOutlet weak var lblGroundDetails: UILabel!
    @IBOutlet weak var lblMatchStatus: UILabel!
    @IBOutlet weak var lblRateOne: UILabel!
    @IBOutlet weak var lblLandingText: UILabel!
    @IBOutlet weak var lblRateTwo: UILabel!
    @IBOutlet weak var lblFavTeam: UILabel!
    @IBOutlet weak var imgViewLeftTeam: CircularImageV!
    @IBOutlet weak var imgViewRightTeam: CircularImageV!
    @IBOutlet weak var lblLeftTeam: UILabel!
    @IBOutlet weak var lblRightTeam: UILabel!
    @IBOutlet weak var lblLeftTeamScore: UILabel!
    @IBOutlet weak var lblLeftTeamOver: UILabel!
    @IBOutlet weak var lblRightTeamScore: UILabel!
    @IBOutlet weak var lblRightTeamOver: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        MainView.layer.cornerRadius = 8.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

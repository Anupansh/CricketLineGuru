//
//  SquadTeamCell.swift
//  CLG
//
//  Created by Anuj Naruka on 8/17/18.
//  Copyright © 2018 Anuj Naruka. All rights reserved.
//

import UIKit

class SquadTeamCell: UITableViewHeaderFooterView {
    //MARK:-IBOutlet
    @IBOutlet weak var lblTeam: UILabel!
    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var imgArrow: UIImageView!
    @IBOutlet weak var bgView: Gradient!
    @IBOutlet weak var sectionBtn: UIButton!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
}

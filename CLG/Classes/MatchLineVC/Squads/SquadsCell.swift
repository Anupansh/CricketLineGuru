//
//  SquadsCell.swift
//  CLG
//
//  Created by Prachi Tiwari on 24/07/20.
//  Copyright © 2020 Anuj Naruka. All rights reserved.
//

import UIKit

class SquadsCell: UITableViewCell {
    
    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet weak var playerNameLbl: UILabel!
    @IBOutlet weak var playerRoleLbl: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

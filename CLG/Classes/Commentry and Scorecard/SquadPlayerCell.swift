//
//  SquadPlayerCell.swift
//  CLG
//
//  Created by Anuj Naruka on 8/17/18.
//  Copyright © 2018 Anuj Naruka. All rights reserved.
//

import UIKit

class SquadPlayerCell: UITableViewCell {
    
    //MARK:-IBOutlet
    @IBOutlet weak var lblPlayerType: UILabel!
    //MARK:-IBOutlet
    @IBOutlet weak var lblPlayerName: UILabel!
    //MARK:-IBOutlet
    @IBOutlet weak var imgPlayer: CircularImageV!

    override func awakeFromNib() {
        super.awakeFromNib()
        //self.selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

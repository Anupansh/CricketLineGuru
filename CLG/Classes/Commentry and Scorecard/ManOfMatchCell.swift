//
//  ManOfMatchCell.swift
//  CLG
//
//  Created by Sani Kumar on 11/10/19.
//  Copyright © 2019 Anuj Naruka. All rights reserved.
//

import UIKit

class ManOfMatchCell: UITableViewCell {

    //MARK:-IBOutlet
    @IBOutlet weak var lblPlayerTitle: UILabel!
    //MARK:-IBOutlet
    @IBOutlet weak var lblPlayerType: UILabel!
    //MARK:-IBOutlet
    @IBOutlet weak var lblPlayerName: UILabel!
    //MARK:-IBOutlet
    @IBOutlet weak var imgPlayer: CircularImageV!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

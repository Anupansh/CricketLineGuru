//
//  DropDownCell.swift
//  Legendary gamers
//
//  Created by Anuj Naruka on 3/8/18.
//  Copyright © 2018 Swatantra Singh. All rights reserved.
//

import UIKit


class DropDownCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

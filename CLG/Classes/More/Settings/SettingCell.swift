//
//  SettingCell.swift
//  CLG
//
//  Created by Anuj Naruka on 8/30/18.
//  Copyright © 2018 Anuj Naruka. All rights reserved.
//

import UIKit

class SettingCell: UITableViewCell {
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblValue: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

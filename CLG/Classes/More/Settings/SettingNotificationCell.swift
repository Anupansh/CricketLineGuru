//
//  NotificationCell.swift
//  CLG
//
//  Created by Anuj Naruka on 8/28/18.
//  Copyright © 2018 Anuj Naruka. All rights reserved.
//

import UIKit

class SettingNotificationCell: UITableViewCell {
    @IBOutlet weak var btnswitch: UISwitch!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

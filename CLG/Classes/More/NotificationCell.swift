//
//  NotificationCell.swift
//  cricrate
//
//  Created by Anuj Naruka on 12/29/17.
//  Copyright © 2017 Cricket Line Guru. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {
    
    //MARK:-IBOutlets
    
    @IBOutlet weak var iconImgView: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var switchBtn: UISwitch!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  HomeMoreNewsCell.swift
//  CLG
//
//  Created by Prachi Tiwari on 07/07/20.
//  Copyright © 2020 Anuj Naruka. All rights reserved.
//

import UIKit

class HomeMoreNewsCell: UITableViewCell {
    
    @IBOutlet weak var newsImage: UIImageView!
    @IBOutlet weak var headlineLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

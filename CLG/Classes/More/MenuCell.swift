//
//  MenuCell.swift
//  cricrate
//
//  Created by Anuj Naruka on 8/11/17.
//  Copyright © 2017 Cricket Line Guru. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {
    
//MARK:-IBOutlet
    
    @IBOutlet weak var imgViewicon: UIImageView!
    @IBOutlet weak var btnHinLang: UIButton!
    @IBOutlet weak var btnEngLang: UIButton!
    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnHinLang.layer.cornerRadius = 3.0
        btnEngLang.layer.cornerRadius = 3.0
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

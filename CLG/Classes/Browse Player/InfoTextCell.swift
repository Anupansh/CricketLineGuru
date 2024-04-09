//
//  InfoTextCell.swift
//  CLG
//
//  Created by Brainmobi on 31/07/18.
//  Copyright © 2018 Anuj Naruka. All rights reserved.
//

import UIKit

class InfoTextCell: UITableViewCell {
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var leftLbl: UILabel!
    @IBOutlet weak var RightLbl: UILabel!
    @IBOutlet weak var lblCenter:UILabel!
    
    //MARK:- View LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

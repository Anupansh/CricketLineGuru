//
//  BattingHeaderCell.swift
//  CLG
//
//  Created by Brainmobi on 31/07/18.
//  Copyright © 2018 Anuj Naruka. All rights reserved.
//

import UIKit

class BattingHeaderCell: UITableViewCell {

    //MARK:- IBOutlets
    
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl3: UILabel!
    @IBOutlet weak var lbl4: UILabel!
    
    //MARK:- View LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

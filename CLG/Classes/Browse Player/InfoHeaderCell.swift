//
//  InfoHeaderCell.swift
//  CLG
//
//  Created by Brainmobi on 31/07/18.
//  Copyright © 2018 Anuj Naruka. All rights reserved.
//

import UIKit

class InfoHeaderCell: UITableViewCell {

    //MARK:- IBOutlets
    
    @IBOutlet weak var lblHeader: UILabel!
    
    //MARK:- View LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

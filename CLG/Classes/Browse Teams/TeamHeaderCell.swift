//
//  TeamHeaderCell.swift
//  CLG
//
//  Created by Brainmobi on 30/07/18.
//  Copyright © 2018 Anuj Naruka. All rights reserved.
//

import UIKit

class TeamHeaderCell: UITableViewCell {

    //MARK:- IBOutlets
    
    @IBOutlet weak var lblHeader: UILabel!
    
    //MARK:- View LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setHeaderName(name:String){
        lblHeader.text = name
    }
    
}

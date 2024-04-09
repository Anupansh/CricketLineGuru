//
//  InfoImageCell.swift
//  CLG
//
//  Created by Brainmobi on 31/07/18.
//  Copyright © 2018 Anuj Naruka. All rights reserved.
//

import UIKit

class InfoImageCell: UITableViewCell {

    //MARK:- IBOutlets
    
    @IBOutlet weak var playerImgView: CircularImageV!
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var countryName: UILabel!

    //MARK:- View LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

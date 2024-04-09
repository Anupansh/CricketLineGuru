//
//  ChatCell.swift
//  CLG
//
//  Created by Anuj Naruka on 8/7/18.
//  Copyright © 2018 Anuj Naruka. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {
    //MARK:-IBOutlet
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var txtView: UITextView!

    //MARK:- Variables & Constants
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

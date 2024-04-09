//
//  BallByBallCell.swift
//  cricrate
//
//  Created by Anuj Naruka on 12/27/17.
//  Copyright © 2017 Cricket Line Guru. All rights reserved.
//

import UIKit

class BallByBallCell: UITableViewCell {
    //MARK:- IBOulets
    @IBOutlet weak var inningLbl: UILabel!
    @IBOutlet weak var inningHeight: NSLayoutConstraint!
    @IBOutlet weak var Over: UILabel!
    @IBOutlet weak var underlineView: UIView!
    @IBOutlet weak var Runs: UILabel!
    @IBOutlet weak var Comment: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.Runs.layer.cornerRadius = self.Runs.frame.height/2
        self.Runs.clipsToBounds = true
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//
//  PreviousBallCell.swift
//  cricrate
//
//  Created by Anuj Naruka on 9/7/17.
//  Copyright © 2017 Cricket Line Guru. All rights reserved.
//

import UIKit

class PreviousBallCell: UICollectionViewCell {

    //MARK:-IBOutlets
    @IBOutlet weak var PrevBallView: UIView!
    @IBOutlet weak var lblPreviousBall: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.PrevBallView.layer.cornerRadius = self.PrevBallView.frame.size.height / 2//3
        self.PrevBallView.clipsToBounds = true
        //self.lblPreviousBall.layer.cornerRadius = self.lblPreviousBall.frame.size.height / 2
        //self.lblPreviousBall.clipsToBounds = true
        // Initialization code
    }

}

//
//  LabelCell.swift
//  CLG
//
//  Created by Sani Kumar on 16/12/19.
//  Copyright © 2019 Anuj Naruka. All rights reserved.
//

import UIKit

class LabelCell: UICollectionViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblLine: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func prepareForReuse() {
        self.lblLine.isHidden = true
    }
}

//
//  SeasonSeriesFilterCell.swift
//  CLG
//
//  Created by Sani Kumar on 19/05/19.
//  Copyright © 2019 Anuj Naruka. All rights reserved.
//

import UIKit

class SeasonSeriesFilterCell: UITableViewCell {

    @IBOutlet weak var teamNameLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
            if selected {
                teamNameLbl.textColor = UIColor.white
                contentView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "topbg"))
            }
            else if isHighlighted{
                teamNameLbl.textColor = UIColor.black
                contentView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "topbg"))
            }
            else {
                teamNameLbl.textColor = UIColor.black
                contentView.backgroundColor = UIColor.white
            }
        
    }

}

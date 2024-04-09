//
//  CommentryScoreCell.swift
//  CLG
//
//  Created by Anuj Naruka on 8/24/18.
//  Copyright © 2018 Anuj Naruka. All rights reserved.
//

import UIKit

class CommentryScoreCell: UITableViewHeaderFooterView {

    //MARK:-IBOutlet
    @IBOutlet weak var teamOneScoreView: UIView!
    @IBOutlet weak var teamTwoScoreView: UIView!
    @IBOutlet weak var teamTwoOver: UILabel!
    @IBOutlet weak var teamTwoScore: UILabel!
    @IBOutlet weak var teamTwoTitle: UILabel!
    @IBOutlet weak var teamOneOver: UILabel!
    @IBOutlet weak var teamOneScore: UILabel!
    @IBOutlet weak var teamOneTitle: UILabel!
    @IBOutlet weak var matchResultView: UIView!
    @IBOutlet weak var matchResultLbl: UILabel!
    @IBOutlet weak var teamTwoScoreLeadingConstrain: NSLayoutConstraint!
    @IBOutlet weak var teamOneScoreLeadingConstrain: NSLayoutConstraint!
    @IBOutlet weak var teamOneImage: UIImageView!
    @IBOutlet weak var teamTwoImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}

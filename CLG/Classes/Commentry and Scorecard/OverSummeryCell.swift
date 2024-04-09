//
//  OverSummeryCell.swift
//  cricrate
//
//  Created by Anuj Naruka on 12/27/17.
//  Copyright © 2017 Cricket Line Guru. All rights reserved.
//

import UIKit

class OverSummeryCell: UITableViewCell {
    //MARK:-IBOutlet
    @IBOutlet weak var Over: UILabel!
    @IBOutlet weak var Score: UILabel!
    @IBOutlet weak var Runs: UILabel!
    @IBOutlet weak var Batsmen1Name: UILabel!
    @IBOutlet weak var Batsmen2Name: UILabel!
    @IBOutlet weak var BowlerName: UILabel!
    @IBOutlet weak var Batsmen1Score: UILabel!
    @IBOutlet weak var Batsmen2Score: UILabel!
    @IBOutlet weak var BowlerStates: UILabel!
    @IBOutlet weak var CommentryOver: UILabel!
    @IBOutlet weak var CommentryRuns: UILabel!
    @IBOutlet weak var CommentryComment: UILabel!
    @IBOutlet weak var LblTeam: UILabel!
    @IBOutlet weak var LblBallByBallScore: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.CommentryRuns.layer.cornerRadius = self.CommentryRuns.frame.height/2
        self.CommentryRuns.clipsToBounds = true
        self.selectionStyle = .none

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

//
//  BatsmanCell.swift
//  cricrate
//


import UIKit

class BatsmanCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var StrikeRateLbl: UILabel!
    @IBOutlet weak var StatusLBL: UILabel!
    @IBOutlet weak var BatsmanAndStatus: UILabel!
    @IBOutlet weak var Six: UILabel!
    @IBOutlet weak var Four: UILabel!
    @IBOutlet weak var Runs: UILabel!
    @IBOutlet weak var Bowls: UILabel!
    @IBOutlet weak var lbl_Score: UILabel!
    @IBOutlet weak var lbl_Over: UILabel!
    @IBOutlet weak var lblDidNotBat:UILabel!
    @IBOutlet weak var lblPlayers: UILabel!
    
        override func awakeFromNib() {
        super.awakeFromNib()
        //self.selectionStyle = .none
        // Initialization code
            self.lbl_Score.textAlignment = .center
            self.lbl_Over.textAlignment = .center
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.lbl_Score.isHidden = true
        self.lbl_Over.isHidden = true
        self.Bowls.isHidden = false
        self.Four.isHidden = false
        self.Runs.isHidden = false
        self.Six.isHidden = false
        self.StrikeRateLbl.isHidden = false
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

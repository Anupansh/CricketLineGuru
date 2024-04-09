//
//  TvCell.swift
//  CLG
//
//  Created by Anuj Naruka on 6/28/18.
//  Copyright © 2018 Anuj Naruka. All rights reserved.
//

import UIKit

class TvCell: UITableViewCell {

    //MARK:-IBOutlets
    @IBOutlet weak var WatchLiveBtn: UIButton!
    @IBOutlet weak var SpeakerBtnView: UIView!
    @IBOutlet weak var uv_tv: UIView!
    @IBOutlet var tv_giff: UIImageView!
    @IBOutlet var lbl_giffText: UILabel!
    @IBOutlet var lbl_runs: UILabel!
    @IBOutlet var lbl_other: UILabel!
    @IBOutlet var lbl_msg: UILabel!
    @IBOutlet weak var iv_4_6_giff: UIImageView!
    @IBOutlet weak var SpeakerBtn: UIButton!
    @IBOutlet weak var lbl_plus: UILabel!
    @IBOutlet weak var tvScreen: UIView!
    @IBOutlet weak var TeamTwoScore: UILabel!
    @IBOutlet weak var TeamOneName: UILabel!
    @IBOutlet weak var TeamOneOvers: UILabel!
    @IBOutlet weak var TeamOneScore: UILabel!
    @IBOutlet weak var TeamOneCurOver: UILabel!
    @IBOutlet weak var TeamTwoName: UILabel!
    @IBOutlet weak var TeamTwoOver: UILabel!
    @IBOutlet weak var MatchInfoBtn: UIButton!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var viewStatus: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

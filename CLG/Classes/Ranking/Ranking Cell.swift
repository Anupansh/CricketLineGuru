//
//  Ranking Cell.swift
//  cricrate
//
//  Created by Anuj Naruka on 9/22/17.
//  Copyright © 2017 Cricket Line Guru. All rights reserved.
//

import UIKit

class Ranking_Cell: UITableViewCell {

    
    @IBOutlet weak var RatingWidthConstant: NSLayoutConstraint!
    @IBOutlet weak var PlayerLeadingConstant: NSLayoutConstraint!
    @IBOutlet weak var LblPoints: UILabel!
    @IBOutlet weak var LblRating: UILabel!
    @IBOutlet weak var LblPlayer: UILabel!
    @IBOutlet weak var LblRank: UILabel!
    @IBOutlet weak var btnClaim: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(data:CLGRankingResponseModel,rankingTypeFlag:Int){
        
        self.LblPoints.text = ""
        self.LblRank.text  = ""
        self.LblRating.text = ""
        self.LblPlayer.text = ""
        
        if let points = data.points{
            self.LblPoints.text = "\(points)"
        }
        
        if let position = data.position{
            self.LblRank.text = "\(position)"
        }
        
        if rankingTypeFlag == 4{
            self.RatingWidthConstant.constant = 50.5
            self.PlayerLeadingConstant.constant = 25
            
            if let rating = data.rating{
                self.LblRating.text = "\(rating)"
            }
            
            if let team_name = data.team_name{
                self.LblPlayer.text = team_name
            }
        }else{
            self.RatingWidthConstant.constant = 0
            self.PlayerLeadingConstant.constant = 45
            
            if let player_name = data.player_name{
                self.LblPlayer.text = player_name
            }
        }
    }
}

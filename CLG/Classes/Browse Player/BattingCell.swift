//
//  BattingCell.swift
//  CLG
//
//  Created by Brainmobi on 31/07/18.
//  Copyright © 2018 Anuj Naruka. All rights reserved.
//

import UIKit

class BattingCell: UITableViewCell {

    //MARK:- IBOutlets
    
    @IBOutlet weak var lbl1: UILabel!
    @IBOutlet weak var lbl2: UILabel!
    @IBOutlet weak var lbl3: UILabel!
    @IBOutlet weak var lbl4: UILabel!
    
    //MARK:- View LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setBattingData(data:CLGPlayerDetailStatsModel){
        
        
    }
    
    func setBattingData(type:Int,lbl:UILabel,indexPath:IndexPath,data:CLGPlayerDetailStatsModel){
        
        var selectedData = CLGPlayerDetailStatsTypeModel()        
        if type == 0{
            if let test = data.test{
                selectedData = test
            }
        }else if type == 1{
            if let one_day = data.one_day{
                selectedData = one_day
            }
        }else{
            if let t20 = data.t20{
                selectedData = t20
            }
        }
        
        if let batting = selectedData.batting{
            switch indexPath.row{
            case 1:
                if let matches = batting.matches{
                    lbl.text = String(matches)
                }else{
                    lbl.text = "0"
                }
                
                break
            case 2:
                if let innings = batting.innings{
                    lbl.text = String(innings)
                }else{
                    lbl.text = "0"
                }
                
                break
            case 3:
                if let runs = batting.runs{
                    lbl.text = String(runs)
                }else{
                    lbl.text = "0"
                }
                
                break
            case 4:
                if let balls = batting.balls{
                    lbl.text = String(balls)
                }else{
                    lbl.text = "0"
                }
                
                break
            case 5:
                if let fifties = batting.fifties{
                    lbl.text = String(fifties)
                }else{
                    lbl.text = "0"
                }
                
                break
            case 6:
                if let hundreds = batting.hundreds{
                    lbl.text = String(hundreds)
                }else{
                    lbl.text = "0"
                }
                
                break
            case 7:
                if let high_score = batting.high_score{
                    lbl.text = String(high_score)
                }else{
                    lbl.text = "0"
                }
                
                break
            case 8:
                if let average = batting.average{
                    lbl.text = String(average)
                }else{
                    lbl.text = "0"
                }
               
                break
            case 9:
                if let not_outs = batting.not_outs{
                    lbl.text = String(not_outs)
                }else{
                    lbl.text = "0"
                }
             
                break
            case 10:
                if let fours = batting.fours{
                    lbl.text = String(fours)
                }else{
                    lbl.text = "0"
                }
                
                break
            case 11:
                if let sixes = batting.sixes{
                    lbl.text = String(sixes)
                }else{
                    lbl.text = "0"
                }
                break
            default:
                if let strike_rate = batting.strike_rate{
                    lbl.text = String(strike_rate)
                }else{
                    lbl.text = "0"
                }
                break
            }
        }
    }
    
    func setBowlingData(type:Int,lbl:UILabel,indexPath:IndexPath,data:CLGPlayerDetailStatsModel){
        
        var selectedData = CLGPlayerDetailStatsTypeModel()
        if type == 0{
            if let test = data.test{
                selectedData = test
            }
        }else if type == 1{
            if let one_day = data.one_day{
                selectedData = one_day
            }
        }else{
            if let t20 = data.t20{
                selectedData = t20
            }
        }
        
        if let bowling = selectedData.bowling{
            switch indexPath.row{
            case 1:
                if let matches = bowling.matches{
                    lbl.text = String(matches)
                }else{
                    lbl.text = "0"
                }
                
                break
            case 2:
                if let innings = bowling.innings{
                    lbl.text = String(innings)
                }else{
                    lbl.text = "0"
                }
                
                break
            case 3:
                if let balls = bowling.balls{
                    lbl.text = String(balls)
                }else{
                    lbl.text = "0"
                }
                
                break
            case 4:
                if let wickets = bowling.wickets{
                    lbl.text = String(wickets)
                }else{
                    lbl.text = "0"
                }
                
                break
            case 5:
                if let economy = bowling.economy{
                    lbl.text = String(economy)
                }else{
                    lbl.text = "0"
                }
                
                break
            case 6:
                if let average = bowling.average{
                    lbl.text = String(average)
                }else{
                    lbl.text = "0"
                }
                
                break
            case 7:
                if let five_wickets = bowling.five_wickets{
                    lbl.text = String(five_wickets)
                }else{
                    lbl.text = "0"
                }
                
                break
            case 8:
                if let ten_wickets = bowling.ten_wickets{
                    lbl.text = String(ten_wickets)
                }else{
                    lbl.text = "0"
                }
                
                break
            case 9:
                if let best_innings_bowling = bowling.best_innings_bowling{
                    lbl.text = best_innings_bowling
                }else{
                    lbl.text = "0"
                }
                
                break
            case 10:
                if let runs = bowling.runs{
                    lbl.text = String(runs)
                }else{
                    lbl.text = "0"
                }
                
                break
            default:
                if let strike_rate = bowling.strike_rate{
                    lbl.text = String(strike_rate)
                }else{
                    lbl.text = "0"
                }
                break
            }
        }
    }
}

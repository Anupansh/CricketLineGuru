//
//  SquadsModel.swift
//  CLG
//
//  Created by Prachi Tiwari on 24/07/20.
//  Copyright © 2020 Anuj Naruka. All rights reserved.
//

import Foundation
import SwiftyJSON

class SquadsModel {
    var logo : String = ""
    var playerName : String = ""
    var playerRole : String = ""
    var playerKey : String = ""
    
    init() {}
    
    init(json : JSON) {
        self.logo = json["logo"].stringValue
        self.playerName = json["name"].stringValue
        self.playerKey = json["key"].stringValue
//        if json["capt"].stringValue == "1" {
//            self.playerName = self.playerName + "(c)"
//        }
        if json["wk"].boolValue == true {
            self.playerName = self.playerName + " (wk)"
        }
        let roles = json["roles"]
        if roles["bowler"].boolValue == true && roles["batsman"].boolValue == false && roles["keeper"].boolValue == false {
            self.playerRole = "Bowler"
        }
        else if roles["bowler"].boolValue == false && roles["batsman"].boolValue == true && roles["keeper"].boolValue == false {
            self.playerRole = "Batsman"
        }
        else if roles["bowler"].boolValue == false && roles["batsman"].boolValue == false && roles["keeper"].boolValue == true {
            self.playerRole = "Wicket Keeper"
        }
        else if roles["bowler"].boolValue == false && roles["batsman"].boolValue == true && roles["keeper"].boolValue == true {
            self.playerRole = "WK-Batsman"
        }
        else if roles["bowler"].boolValue == true && roles["batsman"].boolValue == true && roles["keeper"].boolValue == false {
            self.playerRole = "All Rounder"
        }
        else {
            self.playerRole = ""
        }
    }
}

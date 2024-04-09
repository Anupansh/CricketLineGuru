//
//  IPLPlayersModel.swift
//  CLG
//
//  Created by Prachi Tiwari on 07/07/20.
//  Copyright © 2020 Anuj Naruka. All rights reserved.
//

import Foundation
import SwiftyJSON

class IPLPlayersModel {
    
    var img : String?
    var name : String?
    var team : String?
    var total : String?
    
    init() {}
    
    init(json : JSON) {
        self.img = json["img"].stringValue
        self.name = json["name"].stringValue
        self.team = json["team"].stringValue
        self.total = json["total"].stringValue
    }
}

class IPLExtraStatsModel {
    
    var total : String?
    var heading : String?
    
    init() {}
    
    init(json : JSON) {
        self.total = json["total"].stringValue
        self.heading = json["heading"].stringValue
    }
}

class IPLWinnerModel {
    var img : String?
    var team : String?
    var year : String?
    
    init() {}
    
    init(json : JSON) {
        self.img = json["img"].stringValue
        self.team = json["team"].stringValue
        self.year = json["year"].stringValue
    }
}

class IPLCapHolderModel {
    
    var img : String?
    var name : String?
    var team : String?
    var total : String?
    var year : String?
    
    init() {}
    
    init(json : JSON) {
        self.img = json["img"].stringValue
        self.name = json["name"].stringValue
        self.team = json["team"].stringValue
        self.total = json["total"].stringValue
        self.year = json["year"].stringValue
    }
}

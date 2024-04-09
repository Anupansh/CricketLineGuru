//
//  LGBaseModel.swift
//
//  Created by Girijesh Kumar on 18/12/17.
//  Copyright © 2017 Girijesh Kumar. All rights reserved.
//

import Foundation
import ObjectMapper

class CLGBaseModel : Mappable
{
    var statusCode:Int?
    var time:String?
    var requestParams:[String:Any]?

    required init?(map: Map)
    {
        
    }
    
    init()
    {
        
    }
    
    func mapping(map: Map)
    {
        statusCode <- map["statusCode"]
        time <- map["time"]
        requestParams <- map["requestParams"]
    }
}


//
//  FBUser.swift
//  Extras
//
//  Created by Anmol's Macbook Air on 03/07/18.
//  Copyright © 2018 Girijesh Kumar. All rights reserved.
//

import Foundation

class FBUser: NSObject {
    
    var name: String?
    var fbId: String?
    var birthday: String?
    var email: String?
    var fbToken: String?
    var profileImage: String?
    var is_verified: Bool?
    var age: Int?
    var fname:String?
    var lname:String?
    
    func getSocialHash() -> [String: AnyObject] {
        var socialHash = [String: AnyObject]()
        if let isVerified = is_verified {
            if !(isVerified) {
                return socialHash
            }
        }
        
        if let fbId = fbId {
            socialHash["FacebookId"] = fbId as AnyObject
        }
        if let name = name {
            socialHash["Name"] = name as AnyObject
        }
        if let fname = fname {
            socialHash["fname"] = fname as AnyObject
        }
        if let lname = lname {
            socialHash["lname"] = lname as AnyObject
        }
        if let email = email {
            socialHash["Email"] = email as AnyObject
        }
        if let profileImage = profileImage {
            socialHash["ProfileImage"] = profileImage as AnyObject
        }
        if let is_verified = is_verified {
            socialHash["is_verified"] = is_verified as AnyObject
        }
        return socialHash
    }
}

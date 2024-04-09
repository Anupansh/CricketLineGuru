//
//  FireBaseMatchKeyObservers.swift
//  CLG
//
//  Created by Sani Kumar on 20/01/20.
//  Copyright © 2020 Anuj Naruka. All rights reserved.
//

import Foundation
import Firebase

var refFirMatchKey: DatabaseHandle?


class FireBaseMatchKeyObservers: NSObject {
    class func setMatchKeyObservers(matchKey:String,currentMatch:Int){
        refFirMatchKey = (AppHelper.appDelegate().ref).child(matchKey).child("mk").observe(DataEventType.value, with: { (Snapshot) in
            print(Snapshot)
            if let value = Snapshot.value as? String{
                fireBaseGlobalModel[currentMatch].mk = value
                NotificationCenter.default.post(name: .refreshMatchKey, object: nil)
                NotificationCenter.default.post(name: .refreshCommentary, object: nil)
                NotificationCenter.default.post(name: .refreshScorecard, object: nil)
            }
        })
    }
    class func removeMatchKeyObserver(matchKey:String){
        if refFirMatchKey != nil
        {
            (AppHelper.appDelegate().ref).child(matchKey).child("mk").removeObserver(withHandle: refFirMatchKey!)
            NotificationCenter.default.removeObserver(self, name: .refreshMatchKey, object: nil)
            NotificationCenter.default.removeObserver(self, name: .refreshCommentary, object: nil)
            NotificationCenter.default.removeObserver(self, name: .refreshScorecard, object: nil)
        }
    }
    
}

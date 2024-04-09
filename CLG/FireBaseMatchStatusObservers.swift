//
//  FireBaseMatchStatusObservers.swift
//  CLG
//
//  Created by Sani Kumar on 21/01/20.
//  Copyright © 2020 Anuj Naruka. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase


var match1ConHandle:DatabaseHandle?
var match2ConHandle:DatabaseHandle?
var match3ConHandle:DatabaseHandle?
var match4ConHandle:DatabaseHandle?
var match5ConHandle:DatabaseHandle?
var match6ConHandle:DatabaseHandle?
var match7ConHandle:DatabaseHandle?
var match8ConHandle:DatabaseHandle?
var match9ConHandle:DatabaseHandle?
var match10ConHandle:DatabaseHandle?


class FireBaseMatchStatusObservers: NSObject {
    
    func setMatchStatusObserver(ref:DatabaseReference)
    {
        for (index,item) in fireBaseGlobalModelNew.enumerated()
        {
            switch (index)
            {
            case 0 :
                
                match1ConHandle = ref.child(item.matchKey!).child("con").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists(){
                        fireBaseGlobalModelNew[index].con = CLGUserService().GetConModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshBadgeCount, object: nil)
                        
                    }
                }
                
                
            case 1 :
                
                match2ConHandle = ref.child(item.matchKey!).child("con").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists(){
                        fireBaseGlobalModelNew[index].con = CLGUserService().GetConModel(dict:(snapshot.value as! [String:Any]))
                        
                        NotificationCenter.default.post(name: .refreshBadgeCount, object: nil)
                    }
                }
                
        
            case 2 :
                
                
                match3ConHandle = ref.child(item.matchKey!).child("con").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].con = CLGUserService().GetConModel(dict:(snapshot.value as! [String:Any]))

                        NotificationCenter.default.post(name: .refreshBadgeCount, object: nil)
                    }
                }
                
                
            case 3 :
                
                
                match4ConHandle = ref.child(item.matchKey!).child("con").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].con = CLGUserService().GetConModel(dict:(snapshot.value as! [String:Any]))

                        NotificationCenter.default.post(name: .refreshBadgeCount, object: nil)
                        
                    }
                }
                
                
            case 4 :
                
                
                match5ConHandle = ref.child(item.matchKey!).child("con").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].con = CLGUserService().GetConModel(dict:(snapshot.value as! [String:Any]))

                        NotificationCenter.default.post(name: .refreshBadgeCount, object: nil)
                        
                        
                    }
                }
                
                
            case 5 :
                
                
                match6ConHandle = ref.child(item.matchKey!).child("con").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].con = CLGUserService().GetConModel(dict:(snapshot.value as! [String:Any]))

                        NotificationCenter.default.post(name: .refreshBadgeCount, object: nil)
                        
                        
                    }
                }
                
                
            case 6 :
                
                match7ConHandle = ref.child(item.matchKey!).child("con").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].con = CLGUserService().GetConModel(dict:(snapshot.value as! [String:Any]))

                        NotificationCenter.default.post(name: .refreshBadgeCount, object: nil)
                        
                    }
                }
                
                
            case 7 :
                
                
                match8ConHandle = ref.child(item.matchKey!).child("con").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].con = CLGUserService().GetConModel(dict:(snapshot.value as! [String:Any]))

                        NotificationCenter.default.post(name: .refreshBadgeCount, object: nil)
                        
                        
                    }
                }
                
                
            case 8 :
                
                match9ConHandle = ref.child(item.matchKey!).child("con").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].con = CLGUserService().GetConModel(dict:(snapshot.value as! [String:Any]))
                        
                        NotificationCenter.default.post(name: .refreshBadgeCount, object: nil)
                    }
                }
                
                
            case 9 :
                
                
                match10ConHandle = ref.child(item.matchKey!).child("con").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].con = CLGUserService().GetConModel(dict:(snapshot.value as! [String:Any]))
                        
                        NotificationCenter.default.post(name: .refreshBadgeCount, object: nil)
                        
                    }
                }
                
                
            default:
                print("error in adding observer")
            }
            
        }
    }
    
    
    func removeMatchStatusObservers(ref:DatabaseReference)
    {
        //MARK- match 1 handle
        
        for (index,item) in fireBaseGlobalModelNew.enumerated()
        {
            switch (index)
            {
                
            case 0:
                
                if match1ConHandle != nil
                {
                    ref.child(item.matchKey!).child("con").removeObserver(withHandle: match1ConHandle!)
                }
                
            //MARK- match 2 handle
            case 1:
                
                if match2ConHandle != nil
                {
                    ref.child(item.matchKey!).child("con").removeObserver(withHandle: match2ConHandle!)
                }
                
            //MARK- match 3 handle
            case 2:
                
                if match3ConHandle != nil
                {
                    ref.child(item.matchKey!).child("con").removeObserver(withHandle: match3ConHandle!)
                }
                
            //MARK- match 4 handle
            case 3:
                
                if match4ConHandle != nil
                {
                    ref.child(item.matchKey!).child("con").removeObserver(withHandle: match4ConHandle!)
                }
                
            //MARK- match 5 handle
            case 4:
                
                if match5ConHandle != nil
                {
                    ref.child(item.matchKey!).child("con").removeObserver(withHandle: match5ConHandle!)
                }
                
            //MARK- match 6 handle
            case 5:
                
                if match6ConHandle != nil
                {
                    ref.child(item.matchKey!).child("con").removeObserver(withHandle: match6ConHandle!)
                }
                
            //MARK- match 7 handle
            case 6:
                
                if match7ConHandle != nil
                {
                    ref.child(item.matchKey!).child("con").removeObserver(withHandle: match7ConHandle!)
                }
                
            //MARK- match 8 handle
            case 7:
                
                if match8ConHandle != nil
                {
                    ref.child(item.matchKey!).child("con").removeObserver(withHandle: match8ConHandle!)
                }
                
            //MARK- match 9 handle
            case 8:
                
                if match9ConHandle != nil{
                    ref.child(item.matchKey!).child("con").removeObserver(withHandle: match9ConHandle!)
                }
                
            //MARK- match 10 handle
            case 9:
                
                if match10ConHandle != nil{
                    ref.child(item.matchKey!).child("con").removeObserver(withHandle: match10ConHandle!)
                }
                
                
            default:
                print("error in adding observer")
            }
        }
    }
    
}

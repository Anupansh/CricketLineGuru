//
//  FireBaseObservers.swift
//  CLG
//  Created by Anuj Naruka on 6/25/18.
//  Copyright © 2018 Anuj Naruka. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

var m1AOHandle:DatabaseHandle?
//var m1FtHandle:DatabaseHandle?
var m1ConHandle:DatabaseHandle?
var m1I1Handle:DatabaseHandle?
var m1I2Handle:DatabaseHandle?
var m1I3Handle:DatabaseHandle?
var m1I4Handle:DatabaseHandle?
//var m1MktHandle:DatabaseHandle?
var m1RTHandle:DatabaseHandle?
var m1T1Handle:DatabaseHandle?
var m1T2Handle:DatabaseHandle?
var m1IOVHandle:DatabaseHandle?
var m1I1BHandle:DatabaseHandle?
var m1I3BHandle:DatabaseHandle?

var m2AOHandle:DatabaseHandle?
//var m2FtHandle:DatabaseHandle?
var m2ConHandle:DatabaseHandle?
var m2I1Handle:DatabaseHandle?
var m2I2Handle:DatabaseHandle?
var m2I3Handle:DatabaseHandle?
var m2I4Handle:DatabaseHandle?
//var m2MktHandle:DatabaseHandle?
var m2RTHandle:DatabaseHandle?
var m2T1Handle:DatabaseHandle?
var m2T2Handle:DatabaseHandle?
var m2IOVHandle:DatabaseHandle?
var m2I1BHandle:DatabaseHandle?
var m2I3BHandle:DatabaseHandle?

var m3AOHandle:DatabaseHandle?
//var m3FtHandle:DatabaseHandle?
var m3ConHandle:DatabaseHandle?
var m3I1Handle:DatabaseHandle?
var m3I2Handle:DatabaseHandle?
var m3I3Handle:DatabaseHandle?
var m3I4Handle:DatabaseHandle?
//var m3MktHandle:DatabaseHandle?
var m3RTHandle:DatabaseHandle?
var m3T1Handle:DatabaseHandle?
var m3T2Handle:DatabaseHandle?
var m3IOVHandle:DatabaseHandle?
var m3I1BHandle:DatabaseHandle?
var m3I3BHandle:DatabaseHandle?

var m4AOHandle:DatabaseHandle?
//var m4FtHandle:DatabaseHandle?
var m4ConHandle:DatabaseHandle?
var m4I1Handle:DatabaseHandle?
var m4I2Handle:DatabaseHandle?
var m4I3Handle:DatabaseHandle?
var m4I4Handle:DatabaseHandle?
//var m4MktHandle:DatabaseHandle?
var m4RTHandle:DatabaseHandle?
var m4T1Handle:DatabaseHandle?
var m4T2Handle:DatabaseHandle?
var m4IOVHandle:DatabaseHandle?
var m4I1BHandle:DatabaseHandle?
var m4I3BHandle:DatabaseHandle?

var m5AOHandle:DatabaseHandle?
//var m5FtHandle:DatabaseHandle?
var m5ConHandle:DatabaseHandle?
var m5I1Handle:DatabaseHandle?
var m5I2Handle:DatabaseHandle?
var m5I3Handle:DatabaseHandle?
var m5I4Handle:DatabaseHandle?
//var m5MktHandle:DatabaseHandle?
var m5RTHandle:DatabaseHandle?
var m5T1Handle:DatabaseHandle?
var m5T2Handle:DatabaseHandle?
var m5IOVHandle:DatabaseHandle?
var m5I1BHandle:DatabaseHandle?
var m5I3BHandle:DatabaseHandle?

var m6AOHandle:DatabaseHandle?
//var m6FtHandle:DatabaseHandle?
var m6ConHandle:DatabaseHandle?
var m6I1Handle:DatabaseHandle?
var m6I2Handle:DatabaseHandle?
var m6I3Handle:DatabaseHandle?
var m6I4Handle:DatabaseHandle?
//var m6MktHandle:DatabaseHandle?
var m6RTHandle:DatabaseHandle?
var m6T1Handle:DatabaseHandle?
var m6T2Handle:DatabaseHandle?
var m6IOVHandle:DatabaseHandle?
var m6I1BHandle:DatabaseHandle?
var m6I3BHandle:DatabaseHandle?

var m7AOHandle:DatabaseHandle?
//var m7FtHandle:DatabaseHandle?
var m7ConHandle:DatabaseHandle?
var m7I1Handle:DatabaseHandle?
var m7I2Handle:DatabaseHandle?
var m7I3Handle:DatabaseHandle?
var m7I4Handle:DatabaseHandle?
//var m7MktHandle:DatabaseHandle?
var m7RTHandle:DatabaseHandle?
var m7T1Handle:DatabaseHandle?
var m7T2Handle:DatabaseHandle?
var m7IOVHandle:DatabaseHandle?
var m7I1BHandle:DatabaseHandle?
var m7I3BHandle:DatabaseHandle?

var m8AOHandle:DatabaseHandle?
//var m8FtHandle:DatabaseHandle?
var m8ConHandle:DatabaseHandle?
var m8I1Handle:DatabaseHandle?
var m8I2Handle:DatabaseHandle?
var m8I3Handle:DatabaseHandle?
var m8I4Handle:DatabaseHandle?
//var m8MktHandle:DatabaseHandle?
var m8RTHandle:DatabaseHandle?
var m8T1Handle:DatabaseHandle?
var m8T2Handle:DatabaseHandle?
var m8IOVHandle:DatabaseHandle?
var m8I1BHandle:DatabaseHandle?
var m8I3BHandle:DatabaseHandle?

var m9AOHandle:DatabaseHandle?
//var m9FtHandle:DatabaseHandle?
var m9ConHandle:DatabaseHandle?
var m9I1Handle:DatabaseHandle?
var m9I2Handle:DatabaseHandle?
var m9I3Handle:DatabaseHandle?
var m9I4Handle:DatabaseHandle?
//var m9MktHandle:DatabaseHandle?
var m9RTHandle:DatabaseHandle?
var m9T1Handle:DatabaseHandle?
var m9T2Handle:DatabaseHandle?
var m9IOVHandle:DatabaseHandle?
var m9I1BHandle:DatabaseHandle?
var m9I3BHandle:DatabaseHandle?

var m10AOHandle:DatabaseHandle?
//var m10FtHandle:DatabaseHandle?
var m10ConHandle:DatabaseHandle?
var m10I1Handle:DatabaseHandle?
var m10I2Handle:DatabaseHandle?
var m10I3Handle:DatabaseHandle?
var m10I4Handle:DatabaseHandle?
//var m10MktHandle:DatabaseHandle?
var m10RTHandle:DatabaseHandle?
var m10T1Handle:DatabaseHandle?
var m10T2Handle:DatabaseHandle?
var m10IOVHandle:DatabaseHandle?
var m10I1BHandle:DatabaseHandle?
var m10I3BHandle:DatabaseHandle?


class FireBaseHomeObservers: NSObject {
    
    func setHomeScreenObserver(ref:DatabaseReference)
    {
        for (index,item) in fireBaseGlobalModelNew.enumerated()
        {
            switch (index)
            {
            case 0 :
                
//                m1FtHandle = ref.child(item.matchKey!).child("ft").observe(DataEventType.value) { (snapshot) in
//                    if snapshot.exists(){
//                        fireBaseGlobalModelNew[index].ft = (snapshot.value as! String)
//                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
//                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
//
//                    }
//                }
        
                m1AOHandle = ref.child(item.matchKey!).child("ao").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists(){
                        fireBaseGlobalModelNew[index].ao = (snapshot.value as? String) ?? "1"
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
                    }
                }
                
                m1ConHandle = ref.child(item.matchKey!).child("con").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists(){
                        fireBaseGlobalModelNew[index].con = CLGUserService().GetConModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)


                    }
                }
                
                m1IOVHandle = ref.child(item.matchKey!).child("iov").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists(){
                        fireBaseGlobalModelNew[index].iov = (snapshot.value as! String)
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
                        
                    }
                }
                
                m1I1BHandle = ref.child(item.matchKey!).child("i1b").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists(){
                        fireBaseGlobalModelNew[index].i1b = (snapshot.value as! String)
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
                        
                    }
                }
                
                m1I3BHandle = ref.child(item.matchKey!).child("i3b").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists(){
                        fireBaseGlobalModelNew[index].i3b = (snapshot.value as! String)
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
                        
                    }
                }
                
                m1I1Handle = ref.child(item.matchKey!).child("i1").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists(){
                        fireBaseGlobalModelNew[index].i1 = CLGUserService().GetInningModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)


                    }
                }
                
                m1I2Handle = ref.child(item.matchKey!).child("i2").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists(){
                        fireBaseGlobalModelNew[index].i2 = CLGUserService().GetInningModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)


                    }
                    
                }
                
                m1I3Handle = ref.child(item.matchKey!).child("i3").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists(){
                        fireBaseGlobalModelNew[index].i3 = CLGUserService().GetInningModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)


                    }
                }
                
                m1I4Handle = ref.child(item.matchKey!).child("i4").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists(){
                        fireBaseGlobalModelNew[index].i4 = CLGUserService().GetInningModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                }
                
//                m1MktHandle = ref.child(item.matchKey!).child("mkt").observe(DataEventType.value) { (snapshot) in
//                    if snapshot.exists(){
//                        fireBaseGlobalModelNew[index].mkt = CLGUserService().GetMarketModel(dict:(snapshot.value as! [String:Any]))
//                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
//                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
//
//                    }
//                }
                
                m1RTHandle = ref.child(item.matchKey!).child("rt").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists(){
                        fireBaseGlobalModelNew[index].rt = (snapshot.value as! String)
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
                        
                    }
                }
                
                m1T1Handle = ref.child(item.matchKey!).child("t1").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists(){
                        fireBaseGlobalModelNew[index].t1 = CLGUserService().GetTeamModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                }
                
                m1T2Handle = ref.child(item.matchKey!).child("t2").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists(){
                        fireBaseGlobalModelNew[index].t2 = CLGUserService().GetTeamModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                }
            case 1 :
                
                m2AOHandle = ref.child(item.matchKey!).child("ao").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists(){
                        fireBaseGlobalModelNew[index].ao = (snapshot.value as? String) ?? "1"
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                }
                
//                m2FtHandle = ref.child(item.matchKey!).child("ft").observe(DataEventType.value) { (snapshot) in
//                    if snapshot.exists(){
//                        fireBaseGlobalModelNew[index].ft = (snapshot.value as! String)
//                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
//                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
//
//                    }
//                }
                
                m2ConHandle = ref.child(item.matchKey!).child("con").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists(){
                        fireBaseGlobalModelNew[index].con = CLGUserService().GetConModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)


                    }
                }
                
                m2IOVHandle = ref.child(item.matchKey!).child("iov").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists(){
                        fireBaseGlobalModelNew[index].iov = (snapshot.value as! String)
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
                        
                    }
                }
                
                m2I1BHandle = ref.child(item.matchKey!).child("i1b").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists(){
                        fireBaseGlobalModelNew[index].i1b = (snapshot.value as! String)
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
                        
                    }
                }
                
                m2I3BHandle = ref.child(item.matchKey!).child("i3b").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists(){
                        fireBaseGlobalModelNew[index].i3b = (snapshot.value as! String)
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
                        
                    }
                }
                
                m2I1Handle = ref.child(item.matchKey!).child("i1").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists(){
                        fireBaseGlobalModelNew[index].i1 = CLGUserService().GetInningModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                }
                
                m2I2Handle = ref.child(item.matchKey!).child("i2").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists(){
                        fireBaseGlobalModelNew[index].i2 = CLGUserService().GetInningModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                    
                }
                
                m2I3Handle = ref.child(item.matchKey!).child("i3").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists(){
                        fireBaseGlobalModelNew[index].i3 = CLGUserService().GetInningModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                }
                
                m2I4Handle = ref.child(item.matchKey!).child("i4").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].i4 = CLGUserService().GetInningModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                    
                }
                
//                m2MktHandle = ref.child(item.matchKey!).child("mkt").observe(DataEventType.value) { (snapshot) in
//                    if snapshot.exists()
//                    {
//                        fireBaseGlobalModelNew[index].mkt = CLGUserService().GetMarketModel(dict:(snapshot.value as! [String:Any]))
//                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
//                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
//
//                    }
//                }
                
                m2RTHandle = ref.child(item.matchKey!).child("rt").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists(){
                        fireBaseGlobalModelNew[index].rt = (snapshot.value as! String)
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
                        
                    }
                }
                
                m2T1Handle = ref.child(item.matchKey!).child("t1").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].t1 = CLGUserService().GetTeamModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                }
                
                m2T2Handle = ref.child(item.matchKey!).child("t2").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].t2 = CLGUserService().GetTeamModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                }
            case 2 :
                
                m3AOHandle = ref.child(item.matchKey!).child("ao").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].ao = (snapshot.value as? String) ?? "1"
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                }
                
//                m3FtHandle = ref.child(item.matchKey!).child("ft").observe(DataEventType.value) { (snapshot) in
//                    if snapshot.exists()
//                    {
//                        fireBaseGlobalModelNew[index].ft = (snapshot.value as! String)
//                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
//                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
//
//                    }
//                }
                
                m3ConHandle = ref.child(item.matchKey!).child("con").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].con = CLGUserService().GetConModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)


                    }
                }
                
                m3IOVHandle = ref.child(item.matchKey!).child("iov").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists(){
                        fireBaseGlobalModelNew[index].iov = (snapshot.value as! String)
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
                        
                    }
                }
                
                m3I1BHandle = ref.child(item.matchKey!).child("i1b").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists(){
                        fireBaseGlobalModelNew[index].i1b = (snapshot.value as! String)
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
                        
                    }
                }
                
                m3I3BHandle = ref.child(item.matchKey!).child("i3b").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists(){
                        fireBaseGlobalModelNew[index].i3b = (snapshot.value as! String)
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
                        
                    }
                }
                
                m3I1Handle = ref.child(item.matchKey!).child("i1").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].i1 = CLGUserService().GetInningModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                }
                
                m3I2Handle = ref.child(item.matchKey!).child("i2").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].i2 = CLGUserService().GetInningModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                    
                }
                
                m3I3Handle = ref.child(item.matchKey!).child("i3").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].i3 = CLGUserService().GetInningModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                }
                
                m3I4Handle = ref.child(item.matchKey!).child("i4").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].i4 = CLGUserService().GetInningModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                    
                }
                
//                m3MktHandle = ref.child(item.matchKey!).child("mkt").observe(DataEventType.value) { (snapshot) in
//                    if snapshot.exists()
//                    {
//                        fireBaseGlobalModelNew[index].mkt = CLGUserService().GetMarketModel(dict:(snapshot.value as! [String:Any]))
//                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
//                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
//
//                    }
//                }
                
                m3RTHandle = ref.child(item.matchKey!).child("rt").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists(){
                        fireBaseGlobalModelNew[index].rt = (snapshot.value as! String)
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
                        
                    }
                }
                
                m3T1Handle = ref.child(item.matchKey!).child("t1").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].t1 = CLGUserService().GetTeamModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                }
                
                m3T2Handle = ref.child(item.matchKey!).child("t2").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].t2 = CLGUserService().GetTeamModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                }
            case 3 :
                
                m4AOHandle = ref.child(item.matchKey!).child("ao").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].ao = (snapshot.value as? String) ?? "1"
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                }
                
//                m4FtHandle = ref.child(item.matchKey!).child("ft").observe(DataEventType.value) { (snapshot) in
//                    if snapshot.exists()
//                    {
//                        fireBaseGlobalModelNew[index].ft = (snapshot.value as! String)
//                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
//                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
//
//                    }
//                }
                
                m4ConHandle = ref.child(item.matchKey!).child("con").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].con = CLGUserService().GetConModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)


                    }
                }
                
                m4IOVHandle = ref.child(item.matchKey!).child("iov").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists(){
                        fireBaseGlobalModelNew[index].iov = (snapshot.value as! String)
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
                        
                    }
                }
                
                m4I1BHandle = ref.child(item.matchKey!).child("i1b").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists(){
                        fireBaseGlobalModelNew[index].i1b = (snapshot.value as! String)
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
                        
                    }
                }
                
                m4I3BHandle = ref.child(item.matchKey!).child("i3b").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists(){
                        fireBaseGlobalModelNew[index].i3b = (snapshot.value as! String)
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
                        
                    }
                }
                
                m4I1Handle = ref.child(item.matchKey!).child("i1").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].i1 = CLGUserService().GetInningModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                }
                
                m4I2Handle = ref.child(item.matchKey!).child("i2").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].i2 = CLGUserService().GetInningModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                    
                }
                
                m4I3Handle = ref.child(item.matchKey!).child("i3").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].i3 = CLGUserService().GetInningModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                }
                
                m4I4Handle = ref.child(item.matchKey!).child("i4").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].i4 = CLGUserService().GetInningModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                    
                }
                
//                m4MktHandle = ref.child(item.matchKey!).child("mkt").observe(DataEventType.value) { (snapshot) in
//                    if snapshot.exists()
//                    {
//                        fireBaseGlobalModelNew[index].mkt = CLGUserService().GetMarketModel(dict:(snapshot.value as! [String:Any]))
//                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
//                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
//
//                    }
//                }
                
                m4RTHandle = ref.child(item.matchKey!).child("rt").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists(){
                        fireBaseGlobalModelNew[index].rt = (snapshot.value as! String)
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
                        
                    }
                }
                
                m4T1Handle = ref.child(item.matchKey!).child("t1").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].t1 = CLGUserService().GetTeamModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                }
                
                m4T2Handle = ref.child(item.matchKey!).child("t2").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].t2 = CLGUserService().GetTeamModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                }
            case 4 :
                
                m5AOHandle = ref.child(item.matchKey!).child("ao").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].ao = (snapshot.value as? String) ?? "1"
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                }
                
//                m5FtHandle = ref.child(item.matchKey!).child("ft").observe(DataEventType.value) { (snapshot) in
//                    if snapshot.exists()
//                    {
//                        fireBaseGlobalModelNew[index].ft = (snapshot.value as! String)
//                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
//                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
//
//                    }
//                }
                
                m5ConHandle = ref.child(item.matchKey!).child("con").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].con = CLGUserService().GetConModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)


                    }
                }
                
                m5IOVHandle = ref.child(item.matchKey!).child("iov").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists(){
                        fireBaseGlobalModelNew[index].iov = (snapshot.value as! String)
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
                        
                    }
                }
                
                m5I1BHandle = ref.child(item.matchKey!).child("i1b").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists(){
                        fireBaseGlobalModelNew[index].i1b = (snapshot.value as! String)
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
                        
                    }
                }
                
                m5I3BHandle = ref.child(item.matchKey!).child("i3b").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists(){
                        fireBaseGlobalModelNew[index].i3b = (snapshot.value as! String)
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
                        
                    }
                }
                
                m5I1Handle = ref.child(item.matchKey!).child("i1").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].i1 = CLGUserService().GetInningModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                }
                
                m5I2Handle = ref.child(item.matchKey!).child("i2").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].i2 = CLGUserService().GetInningModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                    
                }
                
                m5I3Handle = ref.child(item.matchKey!).child("i3").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].i3 = CLGUserService().GetInningModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                }
                
                m5I4Handle = ref.child(item.matchKey!).child("i4").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].i4 = CLGUserService().GetInningModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                    
                }
                
//                m5MktHandle = ref.child(item.matchKey!).child("mkt").observe(DataEventType.value) { (snapshot) in
//                    if snapshot.exists()
//                    {
//                        fireBaseGlobalModelNew[index].mkt = CLGUserService().GetMarketModel(dict:(snapshot.value as! [String:Any]))
//                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
//                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
//
//                    }
//                }
                
                m5RTHandle = ref.child(item.matchKey!).child("rt").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists(){
                        fireBaseGlobalModelNew[index].rt = (snapshot.value as! String)
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
                        
                    }
                }
                
                m5T1Handle = ref.child(item.matchKey!).child("t1").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].t1 = CLGUserService().GetTeamModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                }
                
                m5T2Handle = ref.child(item.matchKey!).child("t2").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].t2 = CLGUserService().GetTeamModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                }
            case 5 :
                
                m6AOHandle = ref.child(item.matchKey!).child("ao").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].ao = (snapshot.value as? String) ?? "1"
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                }
                
//                m6FtHandle = ref.child(item.matchKey!).child("ft").observe(DataEventType.value) { (snapshot) in
//                    if snapshot.exists()
//                    {
//                        fireBaseGlobalModelNew[index].ft = (snapshot.value as! String)
//                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
//                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
//
//                    }
//                }
                
                m6ConHandle = ref.child(item.matchKey!).child("con").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].con = CLGUserService().GetConModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)


                    }
                }
                
                m6IOVHandle = ref.child(item.matchKey!).child("iov").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists(){
                        fireBaseGlobalModelNew[index].iov = (snapshot.value as! String)
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
                        
                    }
                }
                
                m6I1BHandle = ref.child(item.matchKey!).child("i1b").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists(){
                        fireBaseGlobalModelNew[index].i1b = (snapshot.value as! String)
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
                        
                    }
                }
                
                m6I3BHandle = ref.child(item.matchKey!).child("i3b").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists(){
                        fireBaseGlobalModelNew[index].i3b = (snapshot.value as! String)
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
                        
                    }
                }
                
                m6I1Handle = ref.child(item.matchKey!).child("i1").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].i1 = CLGUserService().GetInningModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                }
                
                m6I2Handle = ref.child(item.matchKey!).child("i2").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].i2 = CLGUserService().GetInningModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                    
                }
                
                m6I3Handle = ref.child(item.matchKey!).child("i3").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].i3 = CLGUserService().GetInningModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                }
                
                m6I4Handle = ref.child(item.matchKey!).child("i4").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].i4 = CLGUserService().GetInningModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                    
                }
                
//                m6MktHandle = ref.child(item.matchKey!).child("mkt").observe(DataEventType.value) { (snapshot) in
//                    if snapshot.exists()
//                    {
//                        fireBaseGlobalModelNew[index].mkt = CLGUserService().GetMarketModel(dict:(snapshot.value as! [String:Any]))
//                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
//                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
//
//                    }
//                }
                
                m6RTHandle = ref.child(item.matchKey!).child("rt").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists(){
                        fireBaseGlobalModelNew[index].rt = (snapshot.value as! String)
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
                        
                    }
                }
                
                m6T1Handle = ref.child(item.matchKey!).child("t1").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].t1 = CLGUserService().GetTeamModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                }
                
                m6T2Handle = ref.child(item.matchKey!).child("t2").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].t2 = CLGUserService().GetTeamModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                }
            case 6 :
                
                m7AOHandle = ref.child(item.matchKey!).child("ao").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].ao = (snapshot.value as? String) ?? "1"
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                }
                
//                m7FtHandle = ref.child(item.matchKey!).child("ft").observe(DataEventType.value) { (snapshot) in
//                    if snapshot.exists()
//                    {
//                        fireBaseGlobalModelNew[index].ft = (snapshot.value as! String)
//                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
//                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
//
//                    }
//                }
                
                m7ConHandle = ref.child(item.matchKey!).child("con").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].con = CLGUserService().GetConModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)


                    }
                }
                
                m7IOVHandle = ref.child(item.matchKey!).child("iov").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists(){
                        fireBaseGlobalModelNew[index].iov = (snapshot.value as! String)
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
                        
                    }
                }
                
                m7I1BHandle = ref.child(item.matchKey!).child("i1b").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists(){
                        fireBaseGlobalModelNew[index].i1b = (snapshot.value as! String)
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
                        
                    }
                }
                
                m7I3BHandle = ref.child(item.matchKey!).child("i3b").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists(){
                        fireBaseGlobalModelNew[index].i3b = (snapshot.value as! String)
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
                        
                    }
                }
                
                m7I1Handle = ref.child(item.matchKey!).child("i1").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].i1 = CLGUserService().GetInningModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                }
                
                m7I2Handle = ref.child(item.matchKey!).child("i2").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].i2 = CLGUserService().GetInningModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                    
                }
                
                m7I3Handle = ref.child(item.matchKey!).child("i3").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].i3 = CLGUserService().GetInningModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                }
                
                m7I4Handle = ref.child(item.matchKey!).child("i4").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].i4 = CLGUserService().GetInningModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                    
                }
                
//                m7MktHandle = ref.child(item.matchKey!).child("mkt").observe(DataEventType.value) { (snapshot) in
//                    if snapshot.exists()
//                    {
//                        fireBaseGlobalModelNew[index].mkt = CLGUserService().GetMarketModel(dict:(snapshot.value as! [String:Any]))
//                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
//                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
//
//                    }
//                }
                
                m7RTHandle = ref.child(item.matchKey!).child("rt").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists(){
                        fireBaseGlobalModelNew[index].rt = (snapshot.value as! String)
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
                        
                    }
                }
                
                m7T1Handle = ref.child(item.matchKey!).child("t1").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].t1 = CLGUserService().GetTeamModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                }
                
                m7T2Handle = ref.child(item.matchKey!).child("t2").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].t2 = CLGUserService().GetTeamModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                }
            case 7 :
                
                m8AOHandle = ref.child(item.matchKey!).child("ao").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].ao = (snapshot.value as? String) ?? "1"
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                }
                
//                m8FtHandle = ref.child(item.matchKey!).child("ft").observe(DataEventType.value) { (snapshot) in
//                    if snapshot.exists()
//                    {
//                        fireBaseGlobalModelNew[index].ft = (snapshot.value as! String)
//                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
//                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
//
//                    }
//                }
                
                m8ConHandle = ref.child(item.matchKey!).child("con").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].con = CLGUserService().GetConModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)


                    }
                }
                
                m8IOVHandle = ref.child(item.matchKey!).child("iov").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists(){
                        fireBaseGlobalModelNew[index].iov = (snapshot.value as! String)
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
                        
                    }
                }
                
                m8I1BHandle = ref.child(item.matchKey!).child("i1b").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists(){
                        fireBaseGlobalModelNew[index].i1b = (snapshot.value as! String)
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
                        
                    }
                }
                
                m8I3BHandle = ref.child(item.matchKey!).child("i3b").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists(){
                        fireBaseGlobalModelNew[index].i3b = (snapshot.value as! String)
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
                        
                    }
                }
                
                m8I1Handle = ref.child(item.matchKey!).child("i1").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].i1 = CLGUserService().GetInningModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                }
                
                m8I2Handle = ref.child(item.matchKey!).child("i2").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].i2 = CLGUserService().GetInningModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                    
                }
                
                m8I3Handle = ref.child(item.matchKey!).child("i3").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].i3 = CLGUserService().GetInningModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                }
                
                m8I4Handle = ref.child(item.matchKey!).child("i4").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].i4 = CLGUserService().GetInningModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                    
                }
                
//                m8MktHandle = ref.child(item.matchKey!).child("mkt").observe(DataEventType.value) { (snapshot) in
//                    if snapshot.exists()
//                    {
//                        fireBaseGlobalModelNew[index].mkt = CLGUserService().GetMarketModel(dict:(snapshot.value as! [String:Any]))
//                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
//                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
//
//                    }
//                }
                
                m8RTHandle = ref.child(item.matchKey!).child("rt").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists(){
                        fireBaseGlobalModelNew[index].rt = (snapshot.value as! String)
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
                        
                    }
                }
                
                m8T1Handle = ref.child(item.matchKey!).child("t1").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].t1 = CLGUserService().GetTeamModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                }
                m8T2Handle = ref.child(item.matchKey!).child("t2").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].t2 = CLGUserService().GetTeamModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                }
            case 8 :
                
                m9AOHandle = ref.child(item.matchKey!).child("ao").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].ao = (snapshot.value as? String) ?? "1"
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                }
                
//                m9FtHandle = ref.child(item.matchKey!).child("ft").observe(DataEventType.value) { (snapshot) in
//                    if snapshot.exists()
//                    {
//                        fireBaseGlobalModelNew[index].ft = snapshot.value as? String
//                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
//                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
//
//                    }
//                }
                
                m9ConHandle = ref.child(item.matchKey!).child("con").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].con = CLGUserService().GetConModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)


                    }
                }
                
                m9IOVHandle = ref.child(item.matchKey!).child("iov").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists(){
                        fireBaseGlobalModelNew[index].iov = (snapshot.value as! String)
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
                        
                    }
                }
                
                m9I1BHandle = ref.child(item.matchKey!).child("i1b").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists(){
                        fireBaseGlobalModelNew[index].i1b = (snapshot.value as! String)
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
                        
                    }
                }
                
                m9I3BHandle = ref.child(item.matchKey!).child("i3b").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists(){
                        fireBaseGlobalModelNew[index].i3b = (snapshot.value as! String)
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
                        
                    }
                }
                
                m9I1Handle = ref.child(item.matchKey!).child("i1").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].i1 = CLGUserService().GetInningModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                }
                
                m9I2Handle = ref.child(item.matchKey!).child("i2").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].i2 = CLGUserService().GetInningModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                    
                }
                
                m9I3Handle = ref.child(item.matchKey!).child("i3").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].i3 = CLGUserService().GetInningModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                }
                
                m9I4Handle = ref.child(item.matchKey!).child("i4").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].i4 = CLGUserService().GetInningModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                    
                }
                
//                m9MktHandle = ref.child(item.matchKey!).child("mkt").observe(DataEventType.value) { (snapshot) in
//                    if snapshot.exists()
//                    {
//                        fireBaseGlobalModelNew[index].mkt = CLGUserService().GetMarketModel(dict:(snapshot.value as! [String:Any]))
//                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
//                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
//
//                    }
//                }
                
                m9RTHandle = ref.child(item.matchKey!).child("rt").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists(){
                        fireBaseGlobalModelNew[index].rt = (snapshot.value as! String)
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
                        
                    }
                }
                
                m9T1Handle = ref.child(item.matchKey!).child("t1").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].t1 = CLGUserService().GetTeamModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                }
                m9T2Handle = ref.child(item.matchKey!).child("t2").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].t2 = CLGUserService().GetTeamModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                }
            case 9 :
                
                m10AOHandle = ref.child(item.matchKey!).child("ao").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].ao = (snapshot.value as? String) ?? "1"
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                }
                
//                m10FtHandle = ref.child(item.matchKey!).child("ft").observe(DataEventType.value) { (snapshot) in
//                    if snapshot.exists()
//                    {
//                        fireBaseGlobalModelNew[index].ft = (snapshot.value as! String)
//                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
//                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
//
//                    }
//                }
                
                m10ConHandle = ref.child(item.matchKey!).child("con").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].con = CLGUserService().GetConModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)


                    }
                }
                
                m10IOVHandle = ref.child(item.matchKey!).child("iov").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists(){
                        fireBaseGlobalModelNew[index].iov = (snapshot.value as! String)
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
                        
                    }
                }
                
                m10I1BHandle = ref.child(item.matchKey!).child("i1b").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists(){
                        fireBaseGlobalModelNew[index].i1b = (snapshot.value as! String)
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
                        
                    }
                }
                
                m10I3BHandle = ref.child(item.matchKey!).child("i3b").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists(){
                        fireBaseGlobalModelNew[index].i3b = (snapshot.value as! String)
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
                        
                    }
                }
                
                m10I1Handle = ref.child(item.matchKey!).child("i1").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].i1 = CLGUserService().GetInningModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                }
                
                m10I2Handle = ref.child(item.matchKey!).child("i2").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].i2 = CLGUserService().GetInningModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                    
                }
                
                m10I3Handle = ref.child(item.matchKey!).child("i3").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].i3 = CLGUserService().GetInningModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                }
                
                m10I4Handle = ref.child(item.matchKey!).child("i4").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].i4 = CLGUserService().GetInningModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                    
                }
                
//                m10MktHandle = ref.child(item.matchKey!).child("mkt").observe(DataEventType.value) { (snapshot) in
//                    if snapshot.exists()
//                    {
//                        fireBaseGlobalModelNew[index].mkt = CLGUserService().GetMarketModel(dict:(snapshot.value as! [String:Any]))
//                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
//                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
//
//                    }
//                }
                
                m10RTHandle = ref.child(item.matchKey!).child("rt").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists(){
                        fireBaseGlobalModelNew[index].rt = (snapshot.value as! String)
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
                        
                    }
                }
                
                m10T1Handle = ref.child(item.matchKey!).child("t1").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].t1 = CLGUserService().GetTeamModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                    }
                }
                m10T2Handle = ref.child(item.matchKey!).child("t2").observe(DataEventType.value) { (snapshot) in
                    if snapshot.exists()
                    {
                        fireBaseGlobalModelNew[index].t2 = CLGUserService().GetTeamModel(dict:(snapshot.value as! [String:Any]))
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
                        
                    }
                }
            default:
                print("error in adding observer")
            }
            
        }
    }
    
    func removeObservers(ref:DatabaseReference)
    {
        //MARK- match 1 handle
        
        for (index,item) in fireBaseGlobalModelNew.enumerated()
        {
            switch (index)
            {
                
            case 0:
                if m1AOHandle != nil
                {
                    ref.child(item.matchKey!).child("ao").removeObserver(withHandle: m1AOHandle!)
                }
//                if m1FtHandle != nil
//                {
//                    ref.child(item.matchKey!).child("ft").removeObserver(withHandle: m1FtHandle!)
//                }
                if m1ConHandle != nil
                {
                    ref.child(item.matchKey!).child("con").removeObserver(withHandle: m1ConHandle!)
                }
                if m1IOVHandle != nil{
                    ref.child(item.matchKey!).child("iov").removeObserver(withHandle: m1IOVHandle!)
                }
                if m1I1BHandle != nil{
                    ref.child(item.matchKey!).child("i1b").removeObserver(withHandle: m1I1BHandle!)
                }
                if m1I3BHandle != nil{
                    ref.child(item.matchKey!).child("i3b").removeObserver(withHandle: m1I3BHandle!)
                }
                if m1I1Handle != nil
                {
                    ref.child(item.matchKey!).child("i1").removeObserver(withHandle: m1I1Handle!)
                }
                if m1I2Handle != nil
                {
                    ref.child(item.matchKey!).child("i2").removeObserver(withHandle: m1I2Handle!)
                }
                if m1I3Handle != nil
                {
                    ref.child(item.matchKey!).child("i3").removeObserver(withHandle: m1I3Handle!)
                }
                if m1I4Handle != nil
                {
                    ref.child(item.matchKey!).child("i4").removeObserver(withHandle: m1I4Handle!)
                }
//                if m1MktHandle != nil
//                {
//                    ref.child(item.matchKey!).child("mkt").removeObserver(withHandle: m1MktHandle!)
//                }
                if m1RTHandle != nil
                {
                    ref.child(item.matchKey!).child("rt").removeObserver(withHandle: m1RTHandle!)
                }
                if m1T1Handle != nil
                {
                    ref.child(item.matchKey!).child("t1").removeObserver(withHandle: m1T1Handle!)
                }
                if m1T2Handle != nil
                {
                    ref.child(item.matchKey!).child("t2").removeObserver(withHandle: m1T2Handle!)
                }
            //MARK- match 2 handle
            case 1:
                if m2AOHandle != nil
                {
                    ref.child(item.matchKey!).child("ao").removeObserver(withHandle: m2AOHandle!)
                }
//                if m2FtHandle != nil
//                {
//                    ref.child(item.matchKey!).child("ft").removeObserver(withHandle: m2FtHandle!)
//                }
                if m2ConHandle != nil
                {
                    ref.child(item.matchKey!).child("con").removeObserver(withHandle: m2ConHandle!)
                }
                if m2IOVHandle != nil{
                    ref.child(item.matchKey!).child("iov").removeObserver(withHandle: m2IOVHandle!)
                }
                if m2I1BHandle != nil{
                    ref.child(item.matchKey!).child("i1b").removeObserver(withHandle: m2I1BHandle!)
                }
                if m2I3BHandle != nil{
                    ref.child(item.matchKey!).child("i3b").removeObserver(withHandle: m2I3BHandle!)
                }
                if m2I1Handle != nil
                {
                    ref.child(item.matchKey!).child("i1").removeObserver(withHandle: m2I1Handle!)
                }
                if m2I2Handle != nil
                {
                    ref.child(item.matchKey!).child("i2").removeObserver(withHandle: m2I2Handle!)
                }
                if m2I3Handle != nil
                {
                    ref.child(item.matchKey!).child("i3").removeObserver(withHandle: m2I3Handle!)
                }
                if m2I4Handle != nil
                {
                    ref.child(item.matchKey!).child("i4").removeObserver(withHandle: m2I4Handle!)
                }
//                if m2MktHandle != nil
//                {
//                    ref.child(item.matchKey!).child("mkt").removeObserver(withHandle: m2MktHandle!)
//                }
                if m2RTHandle != nil
                {
                    ref.child(item.matchKey!).child("rt").removeObserver(withHandle: m2RTHandle!)
                }
                if m2T1Handle != nil
                {
                    ref.child(item.matchKey!).child("t1").removeObserver(withHandle: m2T1Handle!)
                }
                if m2T2Handle != nil
                {
                    ref.child(item.matchKey!).child("t2").removeObserver(withHandle: m2T2Handle!)
                }
            //MARK- match 3 handle
            case 2:
                if m3AOHandle != nil
                {
                    ref.child(item.matchKey!).child("ao").removeObserver(withHandle: m3AOHandle!)
                }
//                if m3FtHandle != nil
//                {
//                    ref.child(item.matchKey!).child("ft").removeObserver(withHandle: m3FtHandle!)
//                }
                if m3ConHandle != nil
                {
                    ref.child(item.matchKey!).child("con").removeObserver(withHandle: m3ConHandle!)
                }
                if m3IOVHandle != nil{
                    ref.child(item.matchKey!).child("iov").removeObserver(withHandle: m3IOVHandle!)
                }
                if m3I1BHandle != nil{
                    ref.child(item.matchKey!).child("i1b").removeObserver(withHandle: m3I1BHandle!)
                }
                if m3I3BHandle != nil{
                    ref.child(item.matchKey!).child("i3b").removeObserver(withHandle: m3I3BHandle!)
                }
                if m3I1Handle != nil
                {
                    ref.child(item.matchKey!).child("i1").removeObserver(withHandle: m3I1Handle!)
                }
                if m3I2Handle != nil
                {
                    ref.child(item.matchKey!).child("i2").removeObserver(withHandle: m3I2Handle!)
                }
                if m3I3Handle != nil
                {
                    ref.child(item.matchKey!).child("i3").removeObserver(withHandle: m3I3Handle!)
                }
                if m3I4Handle != nil
                {
                    ref.child(item.matchKey!).child("i4").removeObserver(withHandle: m3I4Handle!)
                }
//                if m3MktHandle != nil
//                {
//                    ref.child(item.matchKey!).child("mkt").removeObserver(withHandle: m3MktHandle!)
//                }
                if m3RTHandle != nil
                {
                    ref.child(item.matchKey!).child("rt").removeObserver(withHandle: m3RTHandle!)
                }
                if m3T1Handle != nil
                {
                    ref.child(item.matchKey!).child("t1").removeObserver(withHandle: m3T1Handle!)
                }
                if m3T2Handle != nil
                {
                    ref.child(item.matchKey!).child("t2").removeObserver(withHandle: m3T2Handle!)
                }
            //MARK- match 4 handle
            case 3:
                if m4AOHandle != nil
                {
                    ref.child(item.matchKey!).child("ao").removeObserver(withHandle: m4AOHandle!)
                }
//                if m4FtHandle != nil
//                {
//                    ref.child(item.matchKey!).child("ft").removeObserver(withHandle: m4FtHandle!)
//                }
                if m4ConHandle != nil
                {
                    ref.child(item.matchKey!).child("con").removeObserver(withHandle: m4ConHandle!)
                }
                if m4IOVHandle != nil{
                    ref.child(item.matchKey!).child("iov").removeObserver(withHandle: m4IOVHandle!)
                }
                if m4I1BHandle != nil{
                    ref.child(item.matchKey!).child("i1b").removeObserver(withHandle: m4I1BHandle!)
                }
                if m4I3BHandle != nil{
                    ref.child(item.matchKey!).child("i3b").removeObserver(withHandle: m4I3BHandle!)
                }
                if m4I1Handle != nil
                {
                    ref.child(item.matchKey!).child("i1").removeObserver(withHandle: m4I1Handle!)
                }
                if m4I2Handle != nil
                {
                    ref.child(item.matchKey!).child("i2").removeObserver(withHandle: m4I2Handle!)
                }
                if m4I3Handle != nil
                {
                    ref.child(item.matchKey!).child("i3").removeObserver(withHandle: m4I3Handle!)
                }
                if m4I4Handle != nil
                {
                    ref.child(item.matchKey!).child("i4").removeObserver(withHandle: m4I4Handle!)
                }
//                if m4MktHandle != nil
//                {
//                    ref.child(item.matchKey!).child("mkt").removeObserver(withHandle: m4MktHandle!)
//                }
                if m4RTHandle != nil
                {
                    ref.child(item.matchKey!).child("rt").removeObserver(withHandle: m4RTHandle!)
                }
                if m4T1Handle != nil
                {
                    ref.child(item.matchKey!).child("t1").removeObserver(withHandle: m4T1Handle!)
                }
                if m4T2Handle != nil
                {
                    ref.child(item.matchKey!).child("t2").removeObserver(withHandle: m4T2Handle!)
                }
            //MARK- match 5 handle
            case 4:
                if m5AOHandle != nil
                {
                    ref.child(item.matchKey!).child("ao").removeObserver(withHandle: m5AOHandle!)
                }
//                if m5FtHandle != nil
//                {
//                    ref.child(item.matchKey!).child("ft").removeObserver(withHandle: m5FtHandle!)
//                }
                if m5ConHandle != nil
                {
                    ref.child(item.matchKey!).child("con").removeObserver(withHandle: m5ConHandle!)
                }
                if m5IOVHandle != nil{
                    ref.child(item.matchKey!).child("iov").removeObserver(withHandle: m5IOVHandle!)
                }
                if m5I1BHandle != nil{
                    ref.child(item.matchKey!).child("i1b").removeObserver(withHandle: m5I1BHandle!)
                }
                if m5I3BHandle != nil{
                    ref.child(item.matchKey!).child("i3b").removeObserver(withHandle: m5I3BHandle!)
                }
                if m5I1Handle != nil
                {
                    ref.child(item.matchKey!).child("i1").removeObserver(withHandle: m5I1Handle!)
                }
                if m5I2Handle != nil
                {
                    ref.child(item.matchKey!).child("i2").removeObserver(withHandle: m5I2Handle!)
                }
                if m5I3Handle != nil
                {
                    ref.child(item.matchKey!).child("i3").removeObserver(withHandle: m5I3Handle!)
                }
                if m5I4Handle != nil
                {
                    ref.child(item.matchKey!).child("i4").removeObserver(withHandle: m5I4Handle!)
                }
//                if m5MktHandle != nil
//                {
//                    ref.child(item.matchKey!).child("mkt").removeObserver(withHandle: m5MktHandle!)
//                }
                if m5RTHandle != nil
                {
                    ref.child(item.matchKey!).child("rt").removeObserver(withHandle: m5RTHandle!)
                }
                if m5T1Handle != nil
                {
                    ref.child(item.matchKey!).child("t1").removeObserver(withHandle: m5T1Handle!)
                }
                if m5T2Handle != nil
                {
                    ref.child(item.matchKey!).child("t2").removeObserver(withHandle: m5T2Handle!)
                }
            //MARK- match 6 handle
            case 5:
                if m6AOHandle != nil
                {
                    ref.child(item.matchKey!).child("ao").removeObserver(withHandle: m6AOHandle!)
                }
//                if m6FtHandle != nil
//                {
//                    ref.child(item.matchKey!).child("ft").removeObserver(withHandle: m6FtHandle!)
//                }
                if m6ConHandle != nil
                {
                    ref.child(item.matchKey!).child("con").removeObserver(withHandle: m6ConHandle!)
                }
                if m6IOVHandle != nil{
                    ref.child(item.matchKey!).child("iov").removeObserver(withHandle: m6IOVHandle!)
                }
                if m6I1BHandle != nil{
                    ref.child(item.matchKey!).child("i1b").removeObserver(withHandle: m6I1BHandle!)
                }
                if m6I3BHandle != nil{
                    ref.child(item.matchKey!).child("i3b").removeObserver(withHandle: m6I3BHandle!)
                }
                if m6I1Handle != nil
                {
                    ref.child(item.matchKey!).child("i1").removeObserver(withHandle: m6I1Handle!)
                }
                if m6I2Handle != nil
                {
                    ref.child(item.matchKey!).child("i2").removeObserver(withHandle: m6I2Handle!)
                }
                if m6I3Handle != nil
                {
                    ref.child(item.matchKey!).child("i3").removeObserver(withHandle: m6I3Handle!)
                }
                if m6I4Handle != nil
                {
                    ref.child(item.matchKey!).child("i4").removeObserver(withHandle: m6I4Handle!)
                }
//                if m6MktHandle != nil
//                {
//                    ref.child(item.matchKey!).child("mkt").removeObserver(withHandle: m6MktHandle!)
//                }
                if m6RTHandle != nil
                {
                    ref.child(item.matchKey!).child("rt").removeObserver(withHandle: m6RTHandle!)
                }
                if m6T1Handle != nil
                {
                    ref.child(item.matchKey!).child("t1").removeObserver(withHandle: m6T1Handle!)
                }
                if m6T2Handle != nil
                {
                    ref.child(item.matchKey!).child("t2").removeObserver(withHandle: m6T2Handle!)
                }
            //MARK- match 7 handle
            case 6:
                if m7AOHandle != nil
                {
                    ref.child(item.matchKey!).child("ao").removeObserver(withHandle: m7AOHandle!)
                }
//                if m7FtHandle != nil
//                {
//                    ref.child(item.matchKey!).child("ft").removeObserver(withHandle: m7FtHandle!)
//                }
                if m7ConHandle != nil
                {
                    ref.child(item.matchKey!).child("con").removeObserver(withHandle: m7ConHandle!)
                }
                if m7IOVHandle != nil{
                    ref.child(item.matchKey!).child("iov").removeObserver(withHandle: m7IOVHandle!)
                }
                if m7I1BHandle != nil{
                    ref.child(item.matchKey!).child("i1b").removeObserver(withHandle: m7I1BHandle!)
                }
                if m7I3BHandle != nil{
                    ref.child(item.matchKey!).child("i3b").removeObserver(withHandle: m7I3BHandle!)
                }
                if m7I1Handle != nil
                {
                    ref.child(item.matchKey!).child("i1").removeObserver(withHandle: m7I1Handle!)
                }
                if m7I2Handle != nil
                {
                    ref.child(item.matchKey!).child("i2").removeObserver(withHandle: m7I2Handle!)
                }
                if m7I3Handle != nil
                {
                    ref.child(item.matchKey!).child("i3").removeObserver(withHandle: m7I3Handle!)
                }
                if m7I4Handle != nil
                {
                    ref.child(item.matchKey!).child("i4").removeObserver(withHandle: m7I4Handle!)
                }
//                if m7MktHandle != nil
//                {
//                    ref.child(item.matchKey!).child("mkt").removeObserver(withHandle: m7MktHandle!)
//                }
                if m7RTHandle != nil
                {
                    ref.child(item.matchKey!).child("rt").removeObserver(withHandle: m7RTHandle!)
                }
                if m7T1Handle != nil
                {
                    ref.child(item.matchKey!).child("t1").removeObserver(withHandle: m7T1Handle!)
                }
                if m7T2Handle != nil
                {
                    ref.child(item.matchKey!).child("t2").removeObserver(withHandle: m7T2Handle!)
                }
            //MARK- match 8 handle
            case 7:
                if m8AOHandle != nil
                {
                    ref.child(item.matchKey!).child("ao").removeObserver(withHandle: m8AOHandle!)
                }
//                if m8FtHandle != nil
//                {
//                    ref.child(item.matchKey!).child("ft").removeObserver(withHandle: m8FtHandle!)
//                }
                if m8ConHandle != nil
                {
                    ref.child(item.matchKey!).child("con").removeObserver(withHandle: m8ConHandle!)
                }
                if m8IOVHandle != nil{
                    ref.child(item.matchKey!).child("iov").removeObserver(withHandle: m8IOVHandle!)
                }
                if m8I1BHandle != nil{
                    ref.child(item.matchKey!).child("i1b").removeObserver(withHandle: m8I1BHandle!)
                }
                if m8I3BHandle != nil{
                    ref.child(item.matchKey!).child("i3b").removeObserver(withHandle: m8I3BHandle!)
                }
                if m8I1Handle != nil
                {
                    ref.child(item.matchKey!).child("i1").removeObserver(withHandle: m8I1Handle!)
                }
                if m8I2Handle != nil
                {
                    ref.child(item.matchKey!).child("i2").removeObserver(withHandle: m8I2Handle!)
                }
                if m8I3Handle != nil
                {
                    ref.child(item.matchKey!).child("i3").removeObserver(withHandle: m8I3Handle!)
                }
                if m8I4Handle != nil
                {
                    ref.child(item.matchKey!).child("i4").removeObserver(withHandle: m8I4Handle!)
                }
//                if m8MktHandle != nil
//                {
//                    ref.child(item.matchKey!).child("mkt").removeObserver(withHandle: m8MktHandle!)
//                }
                if m8RTHandle != nil
                {
                    ref.child(item.matchKey!).child("rt").removeObserver(withHandle: m8RTHandle!)
                }
                if m8T1Handle != nil
                {
                    ref.child(item.matchKey!).child("t1").removeObserver(withHandle: m8T1Handle!)
                }
                if m8T2Handle != nil
                {
                    ref.child(item.matchKey!).child("t2").removeObserver(withHandle: m8T2Handle!)
                }
            //MARK- match 9 handle
            case 8:
                if m9AOHandle != nil{
                    ref.child(item.matchKey!).child("ao").removeObserver(withHandle: m9AOHandle!)
                }
//                if m9FtHandle != nil{
//                    ref.child(item.matchKey!).child("ft").removeObserver(withHandle: m9FtHandle!)
//                }
                if m9ConHandle != nil{
                    ref.child(item.matchKey!).child("con").removeObserver(withHandle: m9ConHandle!)
                }
                if m9IOVHandle != nil{
                    ref.child(item.matchKey!).child("iov").removeObserver(withHandle: m9IOVHandle!)
                }
                if m9I1BHandle != nil{
                    ref.child(item.matchKey!).child("i1b").removeObserver(withHandle: m9I1BHandle!)
                }
                if m9I3BHandle != nil{
                    ref.child(item.matchKey!).child("i3b").removeObserver(withHandle: m9I3BHandle!)
                }
                if m9I1Handle != nil{
                    ref.child(item.matchKey!).child("i1").removeObserver(withHandle: m9I1Handle!)
                }
                if m9I2Handle != nil{
                    ref.child(item.matchKey!).child("i2").removeObserver(withHandle: m9I2Handle!)
                }
                if m9I3Handle != nil{
                    ref.child(item.matchKey!).child("i3").removeObserver(withHandle: m9I3Handle!)
                }
                if m9I4Handle != nil{
                    ref.child(item.matchKey!).child("i4").removeObserver(withHandle: m9I4Handle!)
                }
//                if m9MktHandle != nil{
//                    ref.child(item.matchKey!).child("mkt").removeObserver(withHandle: m9MktHandle!)
//                }
                if m9RTHandle != nil
                {
                    ref.child(item.matchKey!).child("rt").removeObserver(withHandle: m9RTHandle!)
                }
                if m9T1Handle != nil{
                    ref.child(item.matchKey!).child("t1").removeObserver(withHandle: m9T1Handle!)
                }
                if m9T2Handle != nil{
                    ref.child(item.matchKey!).child("t2").removeObserver(withHandle: m9T2Handle!)
                }
            //MARK- match 10 handle
            case 9:
                if m10AOHandle != nil{
                    ref.child(item.matchKey!).child("ao").removeObserver(withHandle: m10AOHandle!)
                }
//                if m10FtHandle != nil{
//                    ref.child(item.matchKey!).child("ft").removeObserver(withHandle: m10FtHandle!)
//                }
                if m10ConHandle != nil{
                    ref.child(item.matchKey!).child("con").removeObserver(withHandle: m10ConHandle!)
                }
                if m10IOVHandle != nil{
                    ref.child(item.matchKey!).child("iov").removeObserver(withHandle: m10IOVHandle!)
                }
                if m10I1BHandle != nil{
                    ref.child(item.matchKey!).child("i1b").removeObserver(withHandle: m10I1BHandle!)
                }
                if m10I3BHandle != nil{
                    ref.child(item.matchKey!).child("i3b").removeObserver(withHandle: m10I3BHandle!)
                }
                if m10I1Handle != nil{
                    ref.child(item.matchKey!).child("i1").removeObserver(withHandle: m10I1Handle!)
                }
                if m10I2Handle != nil{
                    ref.child(item.matchKey!).child("i2").removeObserver(withHandle: m10I2Handle!)
                }
                if m10I3Handle != nil{
                    ref.child(item.matchKey!).child("i3").removeObserver(withHandle: m10I3Handle!)
                }
                if m10I4Handle != nil{
                    ref.child(item.matchKey!).child("i4").removeObserver(withHandle: m10I4Handle!)
                }
//                if m10MktHandle != nil{
//                    ref.child(item.matchKey!).child("mkt").removeObserver(withHandle: m10MktHandle!)
//                }
                if m10RTHandle != nil
                {
                    ref.child(item.matchKey!).child("rt").removeObserver(withHandle: m10RTHandle!)
                }
                if m10T1Handle != nil{
                    ref.child(item.matchKey!).child("t1").removeObserver(withHandle: m10T1Handle!)
                }
                if m10T2Handle != nil{
                    ref.child(item.matchKey!).child("t2").removeObserver(withHandle: m10T2Handle!)
                }
                
            default:
                print("error in adding observer")
            }
        }
    }
}

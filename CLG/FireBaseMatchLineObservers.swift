//
//  FireBaseMatchLineObservers.swift
//  CLG
//
//  Created by Anuj Naruka on 7/30/18.
//  Copyright © 2018 Anuj Naruka. All rights reserved.
//

import Foundation
import Firebase

//var refFirBowlerStatus: DatabaseHandle?
var refFirBowlerName:DatabaseHandle?
var refFirCurrentStatus: DatabaseHandle?
var refMatchday : DatabaseHandle?
//var refFirfavouriteTeam: DatabaseHandle?
var refFirCurrentInning: DatabaseHandle?
var refFirInningOver:DatabaseHandle?
var refFirI1Batting:DatabaseHandle?
var refFirI3Batting:DatabaseHandle?
var refFirInning1: DatabaseHandle?
var refFirInning2: DatabaseHandle?
var refFirInning3: DatabaseHandle?
var refFirInning4: DatabaseHandle?
var refFirLocalDescription: DatabaseHandle?
var refFirMatchInfo: DatabaseHandle?
var refFirlivematchKey: DatabaseHandle?
//var refFirMarket: DatabaseHandle?
var refFirOnStrikr: DatabaseHandle?
var refFirBatsmanOneName: DatabaseHandle?
var refFirBatsmanOneStatus: DatabaseHandle?
var refFirBatsmanTwoName: DatabaseHandle?
var refFirBatsmanTwoStatus: DatabaseHandle?
var refFirPreviousBall: DatabaseHandle?
var refFirSessionSuspend: DatabaseHandle?
//var refFirSession: DatabaseHandle?
var refFirFirstTeam: DatabaseHandle?
var refFirSecondTeam: DatabaseHandle?
var refFirPartnership: DatabaseHandle?
var refFirMstatus: DatabaseHandle?
var refFirOstatus: DatabaseHandle?
var refFirTo: DatabaseHandle?
//var refFirTestLambi: DatabaseHandle?
var refFirLastWkt: DatabaseHandle?
var refMITVaule: DatabaseHandle?
var refMarkeetRt: DatabaseHandle?
var refSessionSn: DatabaseHandle?

class FireBaseMatchLineObservers: NSObject {
    class func setMatchLineObservers(matchKey:String,currentMatch:Int){
//        refFirTestLambi = (AppHelper.appDelegate().ref).child(matchKey).child("lb").observe(DataEventType.value, with: { (Snapshot) in
//            print(Snapshot)
//            if let value = Snapshot.value as? [String:Any]{
//                    fireBaseGlobalModel[currentMatch].lb = CLGUserService().GetLambiModel(dict: value)
//                NotificationCenter.default.post(name: .refreshLambi, object: nil)
//            }
//        })
        refFirMstatus = (AppHelper.appDelegate().ref).child(matchKey).child("con").child("mstus").observe(DataEventType.value, with: { (Snapshot) in
            print(Snapshot)
            if let value = Snapshot.value as? String{
                fireBaseGlobalModel[currentMatch].con?.mstus = value
            }
        })
        refFirOstatus = (AppHelper.appDelegate().ref).child(matchKey).child("con").child("ostus").observe(DataEventType.value, with: { (Snapshot) in
            print(Snapshot)
            if let value = Snapshot.value as? String{
                fireBaseGlobalModel[currentMatch].con?.ostus = value
            }
        })
        refFirTo = (AppHelper.appDelegate().ref).child(matchKey).child("to").observe(DataEventType.value, with: { (Snapshot) in
            print(Snapshot)
            if let value = Snapshot.value as? String{
                fireBaseGlobalModel[currentMatch].to = value
                NotificationCenter.default.post(name: .refreshCurrentRunRateCell, object: nil)
            }
        })
        refFirCurrentInning = (AppHelper.appDelegate().ref).child(matchKey).child("i").observe(DataEventType.value, with: { (Snapshot) in
            print(Snapshot)
            if let value = Snapshot.value as? String{
            fireBaseGlobalModel[currentMatch].i = value
            }
        })
        refFirFirstTeam = (AppHelper.appDelegate().ref).child(matchKey).child("t1").observe(DataEventType.value, with: { (Snapshot) in
            print(Snapshot)
            if let value = Snapshot.value as? [String:Any]{
            fireBaseGlobalModel[currentMatch].t1 = CLGUserService().GetTeamModel(dict: value)
                NotificationCenter.default.post(name: .refreshIninning1, object: nil)
            }
        })
        refFirSecondTeam = (AppHelper.appDelegate().ref).child(matchKey).child("t2").observe(DataEventType.value, with: { (Snapshot) in
            print(Snapshot)
            if let value = Snapshot.value as? [String:Any]{
            fireBaseGlobalModel[currentMatch].t2 = CLGUserService().GetTeamModel(dict: value)
                NotificationCenter.default.post(name: .refreshIninning1, object: nil)
            }
        })
//        refFirBowlerStatus = (AppHelper.appDelegate().ref).child(matchKey).child("bwl").observe(DataEventType.value, with: { (Snapshot) in
//            print(Snapshot)
//            if let value = Snapshot.value as? [String:Any]{
//            fireBaseGlobalModel[currentMatch].bwl = CLGUserService().GetTeamModel(dict: value)
//            NotificationCenter.default.post(name: .refreshPlayer, object: nil)
//            }
//        })
        refFirBowlerName = (AppHelper.appDelegate().ref).child(matchKey).child("bw").observe(DataEventType.value, with: { (Snapshot) in
            print(Snapshot)
            if let value = Snapshot.value as? String{
                fireBaseGlobalModel[currentMatch].bw = value
                NotificationCenter.default.post(name: .refreshPlayer, object: nil)
            }
        })
        refFirCurrentStatus = (AppHelper.appDelegate().ref).child(matchKey).child("cs").observe(DataEventType.value, with: { (Snapshot) in
            print(Snapshot)
            if let value = Snapshot.value as? [String:Any]{
            fireBaseGlobalModel[currentMatch].cs = CLGUserService().GetCurrentStatusModel(dict: value)
            NotificationCenter.default.post(name: .refreshCurrentStatus, object: nil)

            }
        })
        refMatchday = (AppHelper.appDelegate().ref).child(matchKey).child("day").observe(DataEventType.value, with: { (Snapshot) in
            print(Snapshot)
            if let value = Snapshot.value as? String{
            fireBaseGlobalModel[currentMatch].day = value
            NotificationCenter.default.post(name: .refreshDay, object: nil)
            }
        })
//        refFirfavouriteTeam = (AppHelper.appDelegate().ref).child(matchKey).child("ft").observe(DataEventType.value, with: { (Snapshot) in
//            print(Snapshot)
//            if let value = Snapshot.value as? String{
//            fireBaseGlobalModel[currentMatch].ft = value
//            NotificationCenter.default.post(name: .refreshFavTeam, object: nil)
//            }
//        })
        refFirInningOver = (AppHelper.appDelegate().ref).child(matchKey).child("iov").observe(DataEventType.value, with: { (Snapshot) in
            print(Snapshot)
            if let value = Snapshot.value as? String{
                fireBaseGlobalModel[currentMatch].iov = value
                NotificationCenter.default.post(name: .refreshIninning1, object: nil)
                NotificationCenter.default.post(name: .refreshIninning2, object: nil)
                NotificationCenter.default.post(name: .refreshIninning3, object: nil)
                NotificationCenter.default.post(name: .refreshIninning4, object: nil)
                NotificationCenter.default.post(name: .refreshProjectedScore, object: nil)
            }
        })
        refFirI1Batting = (AppHelper.appDelegate().ref).child(matchKey).child("i1b").observe(DataEventType.value, with: { (Snapshot) in
            print(Snapshot)
            if let value = Snapshot.value as? String{
                fireBaseGlobalModel[currentMatch].i1b = value
                NotificationCenter.default.post(name: .refreshIninning1, object: nil)
                NotificationCenter.default.post(name: .refreshIninning2, object: nil)
                NotificationCenter.default.post(name: .refreshProjectedScore, object: nil)
            }
        })
        refFirI3Batting = (AppHelper.appDelegate().ref).child(matchKey).child("i3b").observe(DataEventType.value, with: { (Snapshot) in
            print(Snapshot)
            if let value = Snapshot.value as? String{
                fireBaseGlobalModel[currentMatch].i3b = value
                NotificationCenter.default.post(name: .refreshIninning3, object: nil)
                NotificationCenter.default.post(name: .refreshIninning4, object: nil)
            }
        })
        refFirInning1 = (AppHelper.appDelegate().ref).child(matchKey).child("i1").observe(DataEventType.value, with: { (Snapshot) in
            print(Snapshot)
            if let value = Snapshot.value as? [String:Any]{
            fireBaseGlobalModel[currentMatch].i1 = CLGUserService().GetInningModel(dict: value)
            NotificationCenter.default.post(name: .refreshIninning1, object: nil)
            NotificationCenter.default.post(name: .refreshProjectedScore, object: nil)

            }
        })
        refFirInning2 = (AppHelper.appDelegate().ref).child(matchKey).child("i2").observe(DataEventType.value, with: { (Snapshot) in
            print(Snapshot)
            if let value = Snapshot.value as? [String:Any]{
            fireBaseGlobalModel[currentMatch].i2 = CLGUserService().GetInningModel(dict: value)
            NotificationCenter.default.post(name: .refreshIninning2, object: nil)
            }
        })
        refFirInning3 = (AppHelper.appDelegate().ref).child(matchKey).child("i3").observe(DataEventType.value, with: { (Snapshot) in
            print(Snapshot)
            if let value = Snapshot.value as? [String:Any]{
            fireBaseGlobalModel[currentMatch].i3 = CLGUserService().GetInningModel(dict: value)
            NotificationCenter.default.post(name: .refreshIninning3, object: nil)
            }
        })
        refFirInning4 = (AppHelper.appDelegate().ref).child(matchKey).child("i4").observe(DataEventType.value, with: { (Snapshot) in
            print(Snapshot)
            if let value = Snapshot.value as? [String:Any]{
            fireBaseGlobalModel[currentMatch].i4 = CLGUserService().GetInningModel(dict: value)
            NotificationCenter.default.post(name: .refreshIninning4, object: nil)
            }
        })
        refFirLocalDescription = (AppHelper.appDelegate().ref).child(matchKey).child("md").observe(DataEventType.value, with: { (Snapshot) in
            print(Snapshot)
            if let value = Snapshot.value as? String{
            fireBaseGlobalModel[currentMatch].md = value
            NotificationCenter.default.post(name: .refreshMatchDiscription, object: nil)
            }
        })
        refFirlivematchKey = (AppHelper.appDelegate().ref).child(matchKey).child("mk").observe(DataEventType.value, with: { (Snapshot) in
            print(Snapshot)
            if let value = Snapshot.value as? String{
            fireBaseGlobalModel[currentMatch].mk = value
            NotificationCenter.default.post(name: .refreshMatchKey, object: nil)
            NotificationCenter.default.post(name: .refreshCommentary, object: nil)
            NotificationCenter.default.post(name: .refreshScorecard, object: nil)
            }
        })
//        refFirMarket = (AppHelper.appDelegate().ref).child(matchKey).child("mkt").observe(DataEventType.value, with: { (Snapshot) in
//            print(Snapshot)
//            if let value = Snapshot.value as? [String:Any]{
//            fireBaseGlobalModel[currentMatch].mkt = CLGUserService().GetMarketModel(dict: value)
//            NotificationCenter.default.post(name: .refreshMarket, object: nil)
//            }
//        })
        
        refMarkeetRt = (AppHelper.appDelegate().ref).child(matchKey).child("rt").observe(DataEventType.value, with: { (Snapshot) in
            print(Snapshot)
            if let value = Snapshot.value as? String{
                fireBaseGlobalModel[currentMatch].rt = value
                NotificationCenter.default.post(name: .refreshMarket, object: nil)
                NotificationCenter.default.post(name: .refreshFavTeam, object: nil)
            }
        })
        
        refFirOnStrikr = (AppHelper.appDelegate().ref).child(matchKey).child("os").observe(DataEventType.value, with: { (Snapshot) in
            print(Snapshot)
            if let value = Snapshot.value as? String{
            fireBaseGlobalModel[currentMatch].os = value
            NotificationCenter.default.post(name: .refreshPlayer, object: nil)
            }
        })
        refFirBatsmanOneName = (AppHelper.appDelegate().ref).child(matchKey).child("p1").observe(DataEventType.value, with: { (Snapshot) in
            print(Snapshot)
            if let value = Snapshot.value as? String{
            fireBaseGlobalModel[currentMatch].p1 = value
            NotificationCenter.default.post(name: .refreshPlayer, object: nil)
            }
        })
//        refFirPartnership = (AppHelper.appDelegate().ref).child(matchKey).child("p").observe(DataEventType.value, with: { (Snapshot) in
//            print(Snapshot)
//            if let value = Snapshot.value as? [String:Any]{
//                fireBaseGlobalModel[currentMatch].p = CLGUserService().GetPartnershipModel(dict: value)
//                NotificationCenter.default.post(name: .refreshPlayer, object: nil)
//            }
//        })
        refFirPartnership = (AppHelper.appDelegate().ref).child(matchKey).child("pt").observe(DataEventType.value, with: { (Snapshot) in
            print(Snapshot)
            if let value = Snapshot.value as? String{
                fireBaseGlobalModel[currentMatch].pt = value
                NotificationCenter.default.post(name: .refreshPlayer, object: nil)
            }
        })
        
//        refFirBatsmanOneStatus = (AppHelper.appDelegate().ref).child(matchKey).child("p1s").observe(DataEventType.value, with: { (Snapshot) in
//            print(Snapshot)
//            if let value = Snapshot.value as? [String:Any]{
//            fireBaseGlobalModel[currentMatch].p1s = CLGUserService().GetPlayerStatusModel(dict: value)
//            NotificationCenter.default.post(name: .refreshPlayer, object: nil)
//            }
//        })
        refFirBatsmanOneStatus = (AppHelper.appDelegate().ref).child(matchKey).child("b1s").observe(DataEventType.value, with: { (Snapshot) in
            print(Snapshot)
            if let value = Snapshot.value as? String{
                fireBaseGlobalModel[currentMatch].b1s = value
                NotificationCenter.default.post(name: .refreshPlayer, object: nil)
            }
        })
        
        refFirBatsmanTwoName = (AppHelper.appDelegate().ref).child(matchKey).child("p2").observe(DataEventType.value, with: { (Snapshot) in
            print(Snapshot)
            if let value = Snapshot.value as? String{
            fireBaseGlobalModel[currentMatch].p2 = value
            NotificationCenter.default.post(name: .refreshPlayer, object: nil)
            }
        })
//        refFirBatsmanTwoStatus = (AppHelper.appDelegate().ref).child(matchKey).child("p2s").observe(DataEventType.value, with: { (Snapshot) in
//            print(Snapshot)
//            if let value = Snapshot.value as? [String:Any]{
//            fireBaseGlobalModel[currentMatch].p2s = CLGUserService().GetPlayerStatusModel(dict: value)
//            NotificationCenter.default.post(name: .refreshPlayer, object: nil)
//            }
//        })
        refFirBatsmanTwoStatus = (AppHelper.appDelegate().ref).child(matchKey).child("b2s").observe(DataEventType.value, with: { (Snapshot) in
            print(Snapshot)
            if let value = Snapshot.value as? String{
                fireBaseGlobalModel[currentMatch].b2s = value
                NotificationCenter.default.post(name: .refreshPlayer, object: nil)
            }
        })
        
        refFirPreviousBall = (AppHelper.appDelegate().ref).child(matchKey).child("pb").observe(DataEventType.value, with: { (Snapshot) in
            print(Snapshot)
            if let value = Snapshot.value as? String{
            fireBaseGlobalModel[currentMatch].pb = value
            NotificationCenter.default.post(name: .refreshPreviousBall, object: nil)
            }
        })
        
        refFirSessionSuspend = (AppHelper.appDelegate().ref).child(matchKey).child("ssns").observe(DataEventType.value, with: { (Snapshot) in
            print(Snapshot)
            if let value = Snapshot.value as? String{
            fireBaseGlobalModel[currentMatch].ssns = value
            NotificationCenter.default.post(name: .refreshSessionSuspended, object: nil)
            NotificationCenter.default.post(name: .refreshLambi, object: nil)
            }
        })
//        refFirSession = (AppHelper.appDelegate().ref).child(matchKey).child("ssn").observe(DataEventType.value, with: { (Snapshot) in
//            print(Snapshot)
//            if let value = Snapshot.value as? [String:Any]{
//            fireBaseGlobalModel[currentMatch].ssn = CLGUserService().GetTeamModel(dict: value)
//            NotificationCenter.default.post(name: .refreshSession, object: nil)
//            }
//        })
        refSessionSn = (AppHelper.appDelegate().ref).child(matchKey).child("sn").observe(DataEventType.value, with: { (Snapshot) in
            print(Snapshot)
            if let value = Snapshot.value as? String{
                fireBaseGlobalModel[currentMatch].sn = value
                NotificationCenter.default.post(name: .refreshSession, object: nil)
            }
        })
        refFirLastWkt = (AppHelper.appDelegate().ref).child(matchKey).child("lw").observe(DataEventType.value, with: { (Snapshot) in
            print(Snapshot)
            if let value = Snapshot.value as? String{
                fireBaseGlobalModel[currentMatch].lw = value
                NotificationCenter.default.post(name: .refreshPlayer, object: nil)
            }
        })
        refMITVaule = (AppHelper.appDelegate().ref).child(matchKey).child("mit").observe(DataEventType.value, with: { (Snapshot) in
            print(Snapshot)
            if let value = Snapshot.value as? String{
                fireBaseGlobalModel[currentMatch].mit = value
                //NotificationCenter.default.post(name: .refreshPlayer, object: nil)
            }
        })
    }
    class func removeMatchLineObserver(matchKey:String){
//        if refFirBowlerStatus != nil
//        {
//            (AppHelper.appDelegate().ref).child(matchKey).child("bwl").removeObserver(withHandle: refFirBowlerStatus!)
//        }
        if refFirBowlerName != nil
        {
            (AppHelper.appDelegate().ref).child(matchKey).child("bw").removeObserver(withHandle: refFirBowlerName!)
        }
        if refFirCurrentStatus != nil
        {
            (AppHelper.appDelegate().ref).child(matchKey).child("cs").removeObserver(withHandle: refFirCurrentStatus!)
        }
        if refMatchday != nil
        {
            (AppHelper.appDelegate().ref).child(matchKey).child("day").removeObserver(withHandle: refMatchday!)
        }
//        if refFirfavouriteTeam != nil
//        {
//            (AppHelper.appDelegate().ref).child(matchKey).child("ft").removeObserver(withHandle: refFirfavouriteTeam!)
//        }
        if refFirTo != nil
        {
            (AppHelper.appDelegate().ref).child(matchKey).child("to").removeObserver(withHandle: refFirTo!)
        }
        if refFirMstatus != nil
        {
            (AppHelper.appDelegate().ref).child(matchKey).child("con").child("mstus").removeObserver(withHandle: refFirMstatus!)
            
        }
        if refFirOstatus != nil
        {
            (AppHelper.appDelegate().ref).child(matchKey).child("con").child("ostus").removeObserver(withHandle: refFirOstatus!)
            
        }
//        if refFirTestLambi != nil
//        {
//            (AppHelper.appDelegate().ref).child(matchKey).child("lb").removeObserver(withHandle: refFirTestLambi!)
//        }
        if refFirCurrentInning != nil
        {
            (AppHelper.appDelegate().ref).child(matchKey).child("i").removeObserver(withHandle: refFirCurrentInning!)
        }
        if refFirInningOver != nil
        {
            (AppHelper.appDelegate().ref).child(matchKey).child("iov").removeObserver(withHandle: refFirInningOver!)
        }
        if refFirI1Batting != nil
        {
            (AppHelper.appDelegate().ref).child(matchKey).child("i1b").removeObserver(withHandle: refFirI1Batting!)
        }
        if refFirI3Batting != nil
        {
            (AppHelper.appDelegate().ref).child(matchKey).child("i3b").removeObserver(withHandle: refFirI3Batting!)
        }
        if refFirInning1 != nil
        {
            (AppHelper.appDelegate().ref).child(matchKey).child("i1").removeObserver(withHandle: refFirInning1!)
        }
        if refFirInning2 != nil
        {
            (AppHelper.appDelegate().ref).child(matchKey).child("i2").removeObserver(withHandle: refFirInning2!)
        }
        if refFirInning3 != nil
        {
            (AppHelper.appDelegate().ref).child(matchKey).child("i3").removeObserver(withHandle: refFirInning3!)
        }
        if refFirInning4 != nil
        {
            (AppHelper.appDelegate().ref).child(matchKey).child("i4").removeObserver(withHandle: refFirInning4!)
        }
        if refFirLocalDescription != nil
        {
            (AppHelper.appDelegate().ref).child(matchKey).child("md").removeObserver(withHandle: refFirLocalDescription!)
        }
        if refFirlivematchKey != nil
        {
            (AppHelper.appDelegate().ref).child(matchKey).child("mk").removeObserver(withHandle: refFirlivematchKey!)
        }
//        if refFirMarket != nil
//        {
//            (AppHelper.appDelegate().ref).child(matchKey).child("mkt").removeObserver(withHandle: refFirMarket!)
//        }
        if refMarkeetRt != nil
        {
            (AppHelper.appDelegate().ref).child(matchKey).child("rt").removeObserver(withHandle: refMarkeetRt!)
        }
        if refFirOnStrikr != nil
        {
            (AppHelper.appDelegate().ref).child(matchKey).child("os").removeObserver(withHandle: refFirOnStrikr!)
        }
        if refFirBatsmanOneName != nil
        {
            (AppHelper.appDelegate().ref).child(matchKey).child("p1").removeObserver(withHandle: refFirBatsmanOneName!)
        }
//        if refFirBatsmanOneStatus != nil
//        {
//            (AppHelper.appDelegate().ref).child(matchKey).child("p1s").removeObserver(withHandle: refFirBatsmanOneStatus!)
//        }
        if refFirBatsmanOneStatus != nil
        {
            (AppHelper.appDelegate().ref).child(matchKey).child("b1s").removeObserver(withHandle: refFirBatsmanOneStatus!)
        }
        if refFirBatsmanTwoName != nil
        {
            (AppHelper.appDelegate().ref).child(matchKey).child("p2").removeObserver(withHandle: refFirBatsmanTwoName!)
        }
//        if refFirBatsmanTwoStatus != nil
//        {
//            (AppHelper.appDelegate().ref).child(matchKey).child("p2s").removeObserver(withHandle: refFirBatsmanTwoStatus!)
//        }
        if refFirBatsmanTwoStatus != nil
        {
            (AppHelper.appDelegate().ref).child(matchKey).child("b2s").removeObserver(withHandle: refFirBatsmanTwoStatus!)
        }
        
        if refFirPreviousBall != nil
        {
            (AppHelper.appDelegate().ref).child(matchKey).child("pb").removeObserver(withHandle: refFirPreviousBall!)
        }
       
        if refFirSessionSuspend != nil
        {
            (AppHelper.appDelegate().ref).child(matchKey).child("ssns").removeObserver(withHandle: refFirSessionSuspend!)
        }
//        if refFirSession != nil
//        {
//            (AppHelper.appDelegate().ref).child(matchKey).child("ssn").removeObserver(withHandle: refFirSession!)
//        }
        if refSessionSn != nil
        {
            (AppHelper.appDelegate().ref).child(matchKey).child("sn").removeObserver(withHandle: refSessionSn!)
        }
        if refFirFirstTeam != nil
        {
            (AppHelper.appDelegate().ref).child(matchKey).child("t1").removeObserver(withHandle: refFirFirstTeam!)
        }
        if refFirSecondTeam != nil
        {
            (AppHelper.appDelegate().ref).child(matchKey).child("t2").removeObserver(withHandle: refFirSecondTeam!)
        }
        if refFirPartnership != nil
        {
            (AppHelper.appDelegate().ref).child(matchKey).child("pt").removeObserver(withHandle: refFirPartnership!)
        }
        if refFirLastWkt != nil
        {
            (AppHelper.appDelegate().ref).child(matchKey).child("lw").removeObserver(withHandle: refFirLastWkt!)
        }
        if refMITVaule != nil
        {
            (AppHelper.appDelegate().ref).child(matchKey).child("mit").removeObserver(withHandle: refMITVaule!)
        }
        
    }
    class func setInfoObservers(matchKey:String,currentMatch:Int){
        refFirMatchInfo = (AppHelper.appDelegate().ref).child(matchKey).child("mi").observe(DataEventType.value, with: { (Snapshot) in
            print(Snapshot)
            if let value = Snapshot.value as? [String:Any]{
            fireBaseGlobalModel[currentMatch].mi = CLGUserService().GetMatchInfoModel(dict: value)
            }
        })
        refMITVaule = (AppHelper.appDelegate().ref).child(matchKey).child("mit").observe(DataEventType.value, with: { (Snapshot) in
            print(Snapshot)
            if let value = Snapshot.value as? String{
                fireBaseGlobalModel[currentMatch].mit = value
                NotificationCenter.default.post(name: .refreshMatchInfo, object: nil)
            }
        })
    }
    class func removeInfoObserver(matchKey:String){
        if refFirMatchInfo != nil{
            (AppHelper.appDelegate().ref).child(matchKey).child("mi").removeObserver(withHandle: refFirMatchInfo!)
        }
        if refMITVaule != nil
        {
            (AppHelper.appDelegate().ref).child(matchKey).child("mit").removeObserver(withHandle: refMITVaule!)
        }
    }
}

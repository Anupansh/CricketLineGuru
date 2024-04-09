//
//  AppConstants.swift
//  cricrate
//


import Foundation
import UIKit

//let baseUrl: String = "http://cricketdev.apphosthub.com/cric-admin"
//let baseUrl: String = "http://cricketlineguru.com/"
//let baseUrl: String = "http://cricketlineguru.com/api/"
//let SocketbaseUrl = "http://www.mobiappexpress.com:4005/lineguru/api/"
//let SocketbaseUrl = "http://18.217.105.166:4005/lineguru/api/"
//let SocketbaseUrl = "http://35.172.12.54:4000" //Dev
//let SocketbaseUrl = "http://13.233.90.81:4000" //LIVE
//let SocketbaseUrl = "http://13.232.245.76:4000" // test
let SocketbaseUrl = "http://clgphase2.cricketlineguru.in:4000" //LIVE

//let NewDevBaseUrl = "http://35.172.12.54:5001/clg/api/v2" //Dev
//let NewDevBaseUrl = "http://clg-phase2-loadbalance-142967985.ap-south-1.elb.amazonaws.com/clg/api/v2"  //LIVE

let NewDevBaseUrl = "http://clgphase2.cricketlineguru.in/clg/api/v2"  //LIVE
let NewDevBaseUrlV3 = "http://clg-phase2-loadbalance-142967985.ap-south-1.elb.amazonaws.com/clg/api/v3"  //LIVE
let NewBaseUrlV3 = "http://clgphase2.cricketlineguru.in/clg/api/v3" //LIVE "http://192.168.0.29:3000/clg/api/v4"//
let NewBaseUrlV4 = "http://clgphase2.cricketlineguru.in/clg/api/v4" //LIVE "http://192.168.0.29:3000/clg/api/v4"//
let NewBaseUrlV5 = "http://clgphase2.cricketlineguru.in/clg/api/v5"

let BaseImgUrl = "http://clgphase2.cricketlineguru.in/firebase-teams/"
let FireBaseDB1 = "https://criclive-72dee.firebaseio.com/" //"https://clg-dev-51402.firebaseio.com/" //
let FireBaseDB2 = "https://clg-dev-51402.firebaseio.com/" // "https://criclive-72dee-28c0a.firebaseio.com/"  //
let FireBaseDB3 = "https://clg-dev-51402.firebaseio.com/" // "https://criclive-72dee-2ef7e.firebaseio.com/" //
let FireBaseDB4 = "https://clg-dev-51402.firebaseio.com/" // "https://criclive-72dee-3257b.firebaseio.com/" //
let FireBaseDB5 = "https://clg-dev-51402.firebaseio.com/" // "https://criclive-72dee-32ddd.firebaseio.com/" //

let latestNewsListing: String = "v1/liveMatch/getNews"
let UpcomingMatchesList: String = "v1/liveMatch/upcomingMatches"
let Ranking : String = "v1/liveMatch/getRanking"
let RecentMatchesList: String = "v1/liveMatch/recentMatches"
let LiveMatchesList: String = "v1/liveMatch/liveMatches"
let PollListing: String = "v1/poll/listPolls"
let PollsPridiction:String = "v1/poll/givePoll"
let UserPoll:String = "v1/poll/userPoll"
let SignUp: String = "v1/user/signUp"
let Scorecard : String  = "v1/liveMatch/scorecard"
let HomeScreenMatches : String = "v1/match/get-matches"
let SeasonList: String = "v1/series/getSeason"
let SeasonMatchList : String = "v1/series/seasonMatches"
let MatchCommentry : String = "v1/liveMatch/testMatchBallSummary"

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//let firebaseNode_currentStatus: String = "match/currentStatus"
let Home = "/match/home"

//testing
var firebaseNode: String = "m1"
let firebaseNode_currentStatus: String = "\(firebaseNode)/currentStatus"


var NotiStr = String()
let accessTokenNotification = Notification.Name(rawValue:"AccessTokenRecived")
let HomeScreenMatchListfromFIR = Notification.Name(rawValue:"HomeScreenInfoFromFIR")
var Noti = Notification.Name(rawValue:NotiStr)


var header = ["Authorization":"Basic Y2xnX2FkbWluOmFkbWluQGNsZw==", "platform":"1"]

let ballImgArr = [UIImage(named: "b1")!,
                  UIImage(named: "b2")!,
                  UIImage(named: "b3")!,
                  UIImage(named: "b4")!,
                  UIImage(named: "b5")!,
                  UIImage(named: "b6")!,
                  UIImage(named: "b7")!,
                  UIImage(named: "b8")!,
                  UIImage(named: "b9")!,
                  UIImage(named: "b10")!,
                  UIImage(named: "b11")!,
                  UIImage(named: "b12")!,
                  UIImage(named: "b13")!,
                  UIImage(named: "b14")!,
                  UIImage(named: "b15")!,
                  UIImage(named: "b16")!,
                  UIImage(named: "b17")!,
                  UIImage(named: "b18")!,
                  UIImage(named: "b19")!,
                  UIImage(named: "b20")!,
                  UIImage(named: "b21")!,
                  UIImage(named: "b22")!,
                  UIImage(named: "b23")!,
                  UIImage(named: "b24")!]
let fourImgArr = [UIImage(named: "four_i")!,
                  UIImage(named: "four_ii")!]
let sixImgArr = [UIImage(named: "six_i")!,
                 UIImage(named: "six_ii")!]
let wideImgArr = [UIImage(named: "wide1")!,
                  UIImage(named: "wide2")!,
                  UIImage(named: "wide3")!,
                  UIImage(named: "wide4")!,
                  UIImage(named: "wide5")!,
                  UIImage(named: "wide6")!,
                  UIImage(named: "wide7")!]
let wicketImgArr = [UIImage(named: "w1")!,
                    UIImage(named: "w2")!,
                    UIImage(named: "w3")!,
                    UIImage(named: "w4")!,
                    UIImage(named: "w5")!]
let noBallImgArr = [UIImage(named: "nb1")!,
                    UIImage(named: "nb2")!,
                    UIImage(named: "nb3")!,
                    UIImage(named: "nb4")!,
                    UIImage(named: "nb5")!,
                    UIImage(named: "nb6")!,
                    UIImage(named: "nb7")!]
let newBatsmenImgArr = [UIImage(named: "f1")!,
                        UIImage(named: "f2")!,
                        UIImage(named: "f3")!,
                        UIImage(named: "f4")!,
                        UIImage(named: "f5")!,
                        UIImage(named: "f6")!,
                        UIImage(named: "f7")!]

extension Notification.Name {
    static let refreshBadgeCount = Notification.Name(
        rawValue: "refreshBadgeCount")
    static let refreshHomeView = Notification.Name(
        rawValue: "refreshHomeView")
    static let refreshLiveView = Notification.Name(
        rawValue: "refreshLiveView")
    static let refreshLiveViewAgain = Notification.Name(
        rawValue: "refreshLiveViewAgain")
    static let refreshBowlerStatus = Notification.Name(
        rawValue: "refreshBowlerStatus")
    static let refreshCurrentStatus = Notification.Name(
        rawValue: "refreshCurrentStatus")
    static let refreshDay = Notification.Name(
        rawValue: "refreshDay")
    static let refreshFavTeam = Notification.Name(
        rawValue: "refreshFavTeam")
    static let refreshCurrentInning = Notification.Name(
        rawValue: "refreshCurrentInning")
    static let refreshIninning1 = Notification.Name(
        rawValue: "refreshIninning1")
    static let refreshIninning2 = Notification.Name(
        rawValue: "refreshIninning2")
    static let refreshIninning3 = Notification.Name(
        rawValue: "refreshIninning3")
    static let refreshIninning4 = Notification.Name(
        rawValue: "refreshIninning4")
    static let refreshMatchDiscription = Notification.Name(
        rawValue: "refreshMatchDiscription")
    static let refreshProjectedScore = Notification.Name(rawValue: "refreshProjectedScore")
    static let refreshMatchKey = Notification.Name(
        rawValue: "refreshMatchKey")
    static let refreshMarket = Notification.Name(
        rawValue: "refreshMarket")
    static let refreshLambi = Notification.Name(
        rawValue: "refreshLambi")
    static let refreshPlayer = Notification.Name(
        rawValue: "refreshPlayer")
    static let refreshCurrentRunRateCell = Notification.Name(
        rawValue: "refreshCurrentRunRateCell")
    static let refreshPreviousBall = Notification.Name(
        rawValue: "refreshPreviousBall")
    static let refreshSessionSuspended = Notification.Name(
        rawValue: "refreshSessionSuspended")
    static let refreshSession = Notification.Name(
        rawValue: "refreshSession")
    static let refreshTeam1 = Notification.Name(
        rawValue: "refreshTeam1")
    static let refreshTeam2 = Notification.Name(
        rawValue: "refreshTeam2")
    static let refreshMatchInfo = Notification.Name(
        rawValue: "refreshMatchInfo")
    static let refreshChat = Notification.Name(
        rawValue: "refreshChat")
    static let moveToHome = Notification.Name(
        rawValue: "moveToHome")
    static let disableTimer = Notification.Name(
        rawValue: "disableTimer")
    static let refreshCommentary = Notification.Name(
        rawValue: "refreshCommentary")
    static let refreshScorecard = Notification.Name(
        rawValue: "refreshScorecard")
}

//
//  LiveLineVC.swift
//  CLG
//
//  Created by Anuj Naruka on 7/18/18.
//  Copyright © 2018 Anuj Naruka. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation
import GoogleMobileAds

class LiveLineVC: BaseViewController,UITableViewDataSource,UITableViewDelegate, FBNativeAdDelegate, FBNativeAdsManagerDelegate
{
    
    // MARK: Class Declarations
    @IBOutlet weak var tv_watchLive_LiveScore: UITableView!
    @IBOutlet weak var bannerHeight: NSLayoutConstraint!
    //    @IBOutlet weak var gadBannerView: GADBannerView!
    @IBOutlet weak var lblStaytuned: UILabel!
    @IBOutlet weak var fastLineLbl: UILabel!
    
    //MARK:- Variables & Constant
    var cvScroll = false
    var player: AVAudioPlayer?
    var CurrentMatch = 0
    var ViewIsLoadedForFirstTimeFlag = Int()
    var timer = Timer()
    var previousValueMarketR1 = String()
    var previousValueMarketR2 = String()
    var previousValuefavTeam = String()
    var previousValueRunball1 = String()
    var previousValueRunball2 = String()
    var previousValueSessionRate1 = String()
    var previousValueSessionRate2 = String()
    var previousValueLambiOne = String()
    var previousValueLambiTwo = String()
    var previousGetStatusValue = Int64()
    var firstTimeLoad = true
    let synthesizer = AVSpeechSynthesizer()
    var bannerAdView: FBAdView!
    var fbNativeAd : FBNativeAd!
    let adRowStep = 1
    var adsManager: FBNativeAdsManager!
    var adsCellProvider: FBNativeAdTableViewCellProvider!
    
    var adLoader = GADAdLoader()
    let numAdsToLoad = 5
    var nativeAds = [GADUnifiedNativeAd]()
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.fbNativeAd = AppHelper.appDelegate().fbnativeAd
        adsManager = FBNativeAdsManager(placementID: AppHelper.appDelegate().fbNativeAdId, forNumAdsRequested: 1)
        adsManager.delegate = self
        adsManager.loadAds()
        firstTimeLoad = true
        ViewIsLoadedForFirstTimeFlag = 1
//        self.loadFbBannerAd()
        self.setTableViewStructure()
        
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.isIdleTimerDisabled = true
        addObservers()
        FireBaseMatchLineObservers.setMatchLineObservers(matchKey: fireBaseGlobalModel[self.CurrentMatch].matchKey!, currentMatch: self.CurrentMatch)
        //////////////////////////////////////////////////
//        if let matchKeyy = fireBaseGlobalModel[CurrentMatch].matchKey{
//            FireBaseMatchLineObservers.setInfoObservers(matchKey: matchKeyy, currentMatch: CurrentMatch)
//        }
//        self.loadFbBannerAd()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func loadFbBannerAd() {
            bannerAdView = FBAdView(placementID: AppHelper.appDelegate().fbBannerAdId, adSize: kFBAdSizeHeight50Banner, rootViewController: self)
            let y = self.view.frame.origin.y + self.view.frame.height - 50
            if UIDevice.current.hasTopNotch {
                bannerAdView.frame = CGRect(x: 0, y: y, width: UIScreen.main.bounds.width, height: 50)
            }
            else {
                bannerAdView.frame = CGRect(x: 0, y: y, width: UIScreen.main.bounds.width, height: 50)
            }
    //        bannerAdView.delegate = self
            self.view.addSubview(bannerAdView)
            bannerAdView.loadAd()
        }
    
    func nativeAdsLoaded() {
        adsCellProvider = FBNativeAdTableViewCellProvider(manager: adsManager, for: FBNativeAdViewType.genericHeight300)
        adsCellProvider.delegate = self
        if self.tv_watchLive_LiveScore != nil {
             self.tv_watchLive_LiveScore.reloadData()
        }
    }

    
    func nativeAdsFailedToLoadWithError(_ error: Error) {
        print("Fail")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        FireBaseMatchLineObservers.removeMatchLineObserver(matchKey: fireBaseGlobalModel[CurrentMatch].matchKey!)
        ///////////////////////////////////////////////////
//        if let matchKeyy = fireBaseGlobalModel[CurrentMatch].matchKey{
//            FireBaseMatchLineObservers.removeInfoObserver(matchKey: matchKeyy)
//        }
        removeObservers()
        self.ViewIsLoadedForFirstTimeFlag = 1
        synthesizer.stopSpeaking(at: AVSpeechBoundary.word)
        AppHelper.appDelegate().loadFbNativeAd()
        player?.stop()
    }
    
     func showGoogleAds(){
        /*let options = GADMultipleAdsAdLoaderOptions()
        options.numberOfAds = numAdsToLoad
        adLoader = GADAdLoader(adUnitID: AppHelper.appDelegate().adNativeUnitID,
                               rootViewController: self,
                               adTypes: [.unifiedNative],
                               options: [options])
        self.adLoader.delegate = self
        adLoader.load(GADRequest())*/
        
        nativeAds = AppHelper.appDelegate().returnNativeAdArray()
        
    }
    //MARK:- TV
    func setTvCell(cell:TvCell)
    {
        cell.SpeakerBtn.addTarget(self, action: #selector(self.SpeakerOnOff(_:)), for: .touchUpInside)
        let isSpeech : NSString = UserDefault.userDefaultForKey(key: "isSpeech") as NSString
        if isSpeech.isEqual(to: "1")  {
            cell.SpeakerBtn.setImage(UIImage(named: "speakeron"), for: .normal)
        }
        else
        {
            cell.SpeakerBtn.setImage(UIImage(named: "speakeroff"), for: .normal)
        }
        cell.lbl_msg.text = ""
        cell.lbl_runs.text =  ""
        cell.lbl_giffText.text = ""
        cell.lbl_other.text = ""
        cell.lbl_plus.text = ""
        cell.iv_4_6_giff.image = nil
        cell.tv_giff.image = nil
        cell.lbl_other.font = cell.lbl_other.font.withSize(27)
        timer.invalidate()
        if fireBaseGlobalModel[CurrentMatch].con?.mstus == "L"{
            cell.viewStatus.isHidden = false
            cell.lblStatus.text = "Live"
        }
        else{
            cell.viewStatus.isHidden = true
        }
        if fireBaseGlobalModel[CurrentMatch].cs?.msg == "AIR"
        {
            cell.lbl_other.text = "IN AIR"
        }
        else if fireBaseGlobalModel[CurrentMatch].cs?.msg == "V"
        {
            // do nothing here
        }
        else if fireBaseGlobalModel[CurrentMatch].cs?.msg == "5"
        {
            cell.lbl_other.text = "5 runs"
        }
        else if fireBaseGlobalModel[CurrentMatch].cs?.msg == "B"
        {
            cell.tv_giff.image = ballImgArr.last
            cell.lbl_giffText.text =  "Ball"
            if UserDefault.userDefaultForAny(key: "AudioLanguage") as! String == "ENG"
            {
                cell.lbl_runs.text =  "Start"
            }
            else
            {
                cell.lbl_runs.text =  "Chalu"
            }
        }
        else if fireBaseGlobalModel[CurrentMatch].cs?.msg == "3U"
        {
            cell.lbl_other.text = "3rd Umpire"
        }
        else if fireBaseGlobalModel[CurrentMatch].cs?.msg == "BR"
        {
            cell.lbl_other.text = "Innings Break"
        }
        else if fireBaseGlobalModel[CurrentMatch].cs?.msg == "DB"
        {
            cell.lbl_other.text = "Drinks Break"
        }
        else if (fireBaseGlobalModel[CurrentMatch].cs?.msg?.contains("BAT"))!
        {
            cell.lbl_plus.text = (fireBaseGlobalModel[CurrentMatch].cs?.msg?.replacingOccurrences(of: "BAT", with: ""))!
            cell.tv_giff.image = #imageLiteral(resourceName: "f7")
        }
        else if fireBaseGlobalModel[CurrentMatch].cs?.msg == "BS"
        {
            if UserDefault.userDefaultForAny(key: "AudioLanguage") as! String == "ENG"
            {
                cell.lbl_other.text =  "Bowler Stop"
            }
            else
            {
                cell.lbl_other.text =  "Bowler Ruka"
            }
        }
        else if fireBaseGlobalModel[CurrentMatch].cs?.msg == "PP"
        {
            cell.lbl_other.text = "Power Play"
        }
        else if fireBaseGlobalModel[CurrentMatch].cs?.msg == "FH"
        {
            cell.lbl_other.text = "Free Hit"
        }
        else if fireBaseGlobalModel[CurrentMatch].cs?.msg == "FB"
        {
            cell.lbl_other.text = "Fast Bowler"
        }
        else if fireBaseGlobalModel[CurrentMatch].cs?.msg == "SB"
        {
            cell.lbl_other.text = "Spin Bowler"
        }
        /*else if fireBaseGlobalModel[CurrentMatch].cs?.msg == "BWLS"
        {
            let name = fireBaseGlobalModel[CurrentMatch].bwl?.n!
            let run = fireBaseGlobalModel[CurrentMatch].bwl?.r!
            let over = fireBaseGlobalModel[CurrentMatch].bwl?.ov!
            let wicket = fireBaseGlobalModel[CurrentMatch].bwl?.w!
            cell.lbl_other.text = "\(name!)   \(run!)-\(over!)-\(wicket!)"
        }*/
        else if fireBaseGlobalModel[CurrentMatch].cs?.msg == "OC"
        {
            cell.lbl_other.text = "Over Complete"
        }
        else if fireBaseGlobalModel[CurrentMatch].cs?.msg == "WK"
        {
            cell.tv_giff.image = #imageLiteral(resourceName: "w5")
            cell.lbl_giffText.text =  "WICKET"
        }
        else if fireBaseGlobalModel[CurrentMatch].cs?.msg == "WD"
        {
            cell.tv_giff.image =  #imageLiteral(resourceName: "wide7")
            cell.iv_4_6_giff.image = nil
            cell.lbl_giffText.text =  "Wide Ball"
        }
        else if fireBaseGlobalModel[CurrentMatch].cs?.msg == "NB"
        {
            cell.tv_giff.image = #imageLiteral(resourceName: "nb7")
            cell.lbl_giffText.text =  "No Ball"
        }
        else if ((fireBaseGlobalModel[CurrentMatch].cs?.msg)?.contains("WK+"))!
        {
            cell.tv_giff.image = #imageLiteral(resourceName: "w5")
            cell.lbl_giffText.text =  "WICKET"
            let tempStr = ((fireBaseGlobalModel[CurrentMatch].cs?.msg)!.components(separatedBy: "+"))[1]
            
            let tempStr1 = ((fireBaseGlobalModel[CurrentMatch].cs?.msg)!.components(separatedBy: "+"))[1]
            if tempStr == "NB" || tempStr1 == "NB"
            {
                cell.lbl_giffText.text = "Run Out"
                cell.lbl_runs.text = "No ball"
            }
            else if tempStr == "WD" || tempStr1 == "WD"
            {
                cell.lbl_runs.text = "Wide ball"
            }
            else
            {
                cell.lbl_runs.text = "\(tempStr) Run"
            }
            cell.lbl_plus.text = "+"
        }
        else if ((fireBaseGlobalModel[CurrentMatch].cs?.msg)?.contains("WD+"))!
        {
            cell.tv_giff.image =  #imageLiteral(resourceName: "wide7")
            cell.iv_4_6_giff.image = nil
            cell.lbl_giffText.text =  "Wide Ball"
            cell.lbl_runs.text = "\(((fireBaseGlobalModel[CurrentMatch].cs?.msg)!.components(separatedBy: "+"))[1]) Run"
            cell.lbl_plus.text = "+"
        }
        else if ((fireBaseGlobalModel[CurrentMatch].cs?.msg)?.contains("NB+"))!
        {
            cell.tv_giff.image = #imageLiteral(resourceName: "nb7")
            cell.lbl_giffText.text =  "No Ball"
            cell.lbl_runs.text = "\(((fireBaseGlobalModel[CurrentMatch].cs?.msg)!.components(separatedBy: "+"))[1]) Run"
            cell.lbl_plus.text = "+"
        }
        else if fireBaseGlobalModel[CurrentMatch].cs?.msg == "C"
        {
            cell.lbl_other.text = "Confirming"
        }
        else if fireBaseGlobalModel[CurrentMatch].cs?.msg == "1"
        {
            cell.lbl_other.text = (fireBaseGlobalModel[CurrentMatch].cs?.msg)!+" Run"
        }
        else if fireBaseGlobalModel[CurrentMatch].cs?.msg == "2"
        {
            cell.lbl_other.text = (fireBaseGlobalModel[CurrentMatch].cs?.msg)!+" Runs"
        }
        else if fireBaseGlobalModel[CurrentMatch].cs?.msg == "3"
        {
            cell.lbl_other.text = (fireBaseGlobalModel[CurrentMatch].cs?.msg)!+" Runs"
        }
        else if fireBaseGlobalModel[CurrentMatch].cs?.msg == "4"
        {
            cell.iv_4_6_giff.image = nil
            cell.iv_4_6_giff.image = #imageLiteral(resourceName: "four_i")
        }
        else if fireBaseGlobalModel[CurrentMatch].cs?.msg == "6"
        {
            cell.iv_4_6_giff.image = nil
            cell.iv_4_6_giff.image = #imageLiteral(resourceName: "six_i")
        }
        else if fireBaseGlobalModel[CurrentMatch].cs?.msg == "0"
        {
            cell.lbl_other.text =  "0"
        }
        else
        {
            cell.lbl_other.text = fireBaseGlobalModel[CurrentMatch].cs?.msg
        }
        // MARK:  Team Status - Bating Team
        if let inning1 = fireBaseGlobalModel[CurrentMatch].i1
        {
            //let key = inning1.bt
            let key = fireBaseGlobalModel[CurrentMatch].i1b
            var teamName = String()
            if key == "0"
            {
                teamName = ""
            }
            else
            {
                //if inning1.bt == "t1"
                if key == "t1"
                {
                    teamName = (fireBaseGlobalModel[CurrentMatch].t1?.n)!
                }
                else
                {
                    teamName = (fireBaseGlobalModel[CurrentMatch].t2?.n)!
                }
            }
            if let battingTeam = teamName as? String{
                
                cell.TeamOneName.text = fireBaseGlobalModel[CurrentMatch].con?.mstus != "U" ? battingTeam : ""
            }
            else{
                cell.TeamOneName.text = "N/A"
            }
            if let battingOver : String = inning1.ov{
                //let _ : String = (inning1.iov)!
                let _ : String = fireBaseGlobalModel[CurrentMatch].iov ?? ""
                if fireBaseGlobalModel[CurrentMatch].con?.mstus == "U"{
                    cell.TeamOneOvers.text = ""
                }else{
                    cell.TeamOneOvers.text = "(\(battingOver))"
                }
            }
            else{
                cell.TeamOneOvers.text = "-"
            }
            
            
            if let battingScore : String = inning1.sc{
                if let battingWickets : NSString = inning1.wk as? NSString{
                    if battingScore != "NaN"
                    {
                        if fireBaseGlobalModel[CurrentMatch].con?.mstus == "U"{
                            cell.TeamOneScore.text = ""
                        }else{
                            cell.TeamOneScore.text =   battingScore + String("-") + (battingWickets as String)
                        }
                    }
                    else
                    {
                        if fireBaseGlobalModel[CurrentMatch].con?.mstus == "U"{
                            cell.TeamOneScore.text = ""
                        }else{
                            cell.TeamOneScore.text =   String("0") + String("-") + (battingWickets as String)
                        }
                    }
                }
                    
                else{
                    if fireBaseGlobalModel[CurrentMatch].con?.mstus == "U"{
                        cell.TeamOneScore.text = ""
                    }else{
                        cell.TeamOneScore.text = battingScore
                    }
                }
            }
            else{
                cell.TeamOneScore.text = "-"
            }
            
        }
        let inning = fireBaseGlobalModel[CurrentMatch].i
        if (inning?.isEqual("i1"))!
        {
            
            cell.TeamTwoOver.isHidden = true
            cell.TeamTwoScore.isHidden = true
            cell.TeamTwoName.isHidden = true
            cell.TeamOneCurOver.text = ""
            if fireBaseGlobalModel[CurrentMatch].i1?.sc == "0" && fireBaseGlobalModel[CurrentMatch].i1?.wk == "0" && fireBaseGlobalModel[CurrentMatch].i1?.ov == "0" && fireBaseGlobalModel[CurrentMatch].con?.mstus == "U"
            {
                cell.TeamOneScore.text = ""
                 cell.TeamOneOvers.text = ""
            }
        }
        else if (inning?.isEqual("i2"))!
        {
            cell.TeamTwoOver.isHidden = false
            cell.TeamTwoScore.isHidden = false
            cell.TeamTwoName.isHidden = false
            cell.TeamOneCurOver.text = ""

            // MARK:  Team Status - Bowling Team
            
            var teamName = String()
            //if fireBaseGlobalModel[CurrentMatch].i2?.bt == "t1"
            if fireBaseGlobalModel[CurrentMatch].i1b == "t2"
            {
                teamName = fireBaseGlobalModel[CurrentMatch].t1!.n!
            }
            else
            {
                teamName = fireBaseGlobalModel[CurrentMatch].t2!.n!
            }
            if let bowlingTeam = teamName as? String{
                cell.TeamOneName.text = fireBaseGlobalModel[CurrentMatch].con?.mstus != "U" ? bowlingTeam : ""
            }
            else{
                cell.TeamOneName.text = "N/A"
            }
            
            
            if let bowlingOver : String = fireBaseGlobalModel[CurrentMatch].i2?.ov{
                cell.TeamOneOvers.text = "(\(bowlingOver))"// + bowlingTotalOver
            }
            else{
                cell.TeamOneOvers.text = "-"
            }
            
            if let bowlingScore : String = fireBaseGlobalModel[CurrentMatch].i2?.sc{
                if let bowlingWickets : NSString =  fireBaseGlobalModel[CurrentMatch].i2?.wk as! NSString{
                    cell.TeamOneScore.text =  bowlingScore  + String("/") + (bowlingWickets as String)
                }
                else
                {
                    
                    cell.TeamOneScore.text = bowlingScore
                }
            }
            else{
                cell.TeamOneScore.text = "-"
            }
            
            var teamName1 = String()
            
            /*if fireBaseGlobalModel[CurrentMatch].i2?.bwlt == "t1"
            {
                teamName1 = fireBaseGlobalModel[CurrentMatch].t1!.n!
            }
            else
            {
                teamName1 = fireBaseGlobalModel[CurrentMatch].t2!.n!
            }*/
            if fireBaseGlobalModel[CurrentMatch].i1b == "t1"
            {
                teamName1 = fireBaseGlobalModel[CurrentMatch].t1!.n!
            }
            else
            {
                teamName1 = fireBaseGlobalModel[CurrentMatch].t2!.n!
            }
            
            if let bowlingTeam1 = teamName1 as? String{
                cell.TeamTwoName.text = bowlingTeam1
                
            }
            var inning1 = fireBaseGlobalModel[CurrentMatch].i1
            if let bowlingOver : String = inning1?.ov{
                // let bowlingTotalOver : String = (self.firebaseData.value(forKey: "bowlingTotalOver") as? String)!
                cell.TeamTwoOver.text = "(\( bowlingOver))"// + bowlingTotalOver
            }
            else{
                cell.TeamTwoOver.text = "-"
            }
            if let bowlingScore1 : String = inning1?.sc{
                if let bowlingWickets : NSString =  inning1?.wk as! NSString{
                    cell.TeamTwoScore.text =  bowlingScore1  + String("/") + (bowlingWickets as String)
                }
                else
                {
                    
                    cell.TeamTwoScore.text = bowlingScore1
                }
            }
            else{
                cell.TeamTwoScore.text = "-"
            }
        }
        else
        {
            cell.TeamTwoOver.isHidden = false
            cell.TeamTwoScore.isHidden = false
            cell.TeamTwoName.isHidden = false
            if (inning?.isEqual("i3"))!
            {
                if isCellVisible(row:2)
                {
                    if let cell2 = self.tv_watchLive_LiveScore.cellForRow(at: IndexPath(row: 2, section: 0)) as? MatchRateCell
                    {
                        self.updateRunX(cell:cell2)
                    }
                }
                
                let inning2 = fireBaseGlobalModel[CurrentMatch].i2
                let inning1 = fireBaseGlobalModel[CurrentMatch].i1
                let inning3 = fireBaseGlobalModel[CurrentMatch].i3
                var FollowOn = Bool()
                let inning1score = Int((inning1?.sc)!)
                let inning2score = Int((inning2?.sc)!)
                let inning3score = Int((inning3?.sc)!)
                /*if inning2?.bt == inning3?.bt
                {
                    FollowOn = true
                }*/
                if fireBaseGlobalModel[CurrentMatch].i3b == "t2"
                {
                    FollowOn = true
                }
                else
                {
                    FollowOn = false
                }
                    
                if FollowOn == true
                {
                    var teamName = String()
                    //let key = inning2?.bt as? String
                    let key = fireBaseGlobalModel[CurrentMatch].i1b
                    if key == "t2"
                    {
                        teamName = (fireBaseGlobalModel[CurrentMatch].t1?.n)!
                    }
                    else
                    {
                        teamName = (fireBaseGlobalModel[CurrentMatch].t2?.n)!
                    }
                    if let bowlingTeam : String = teamName{
                        cell.TeamOneName.text = bowlingTeam
                    }
                    else{
                        cell.TeamOneName.text = "N/A"
                    }
                    
                    cell.TeamOneOvers.text = "& \(inning2score!)/\((inning2?.wk)!)"// + bowlingTotalOver
                    if let bowlingScore : String = inning3?.sc{
                        if let bowlingWickets =  inning3?.wk{
                            cell.TeamOneScore.text =  bowlingScore  + String("/") + (bowlingWickets)
                        }
                        else
                        {
                            
                            cell.TeamOneScore.text = bowlingScore
                        }
                    }
                    else{
                        cell.TeamOneScore.text = "-"
                    }
                    
                    if let currentOvr  = inning3?.ov{
                        cell.TeamOneCurOver.text = "(\(currentOvr))"
                    }
                    else{
                        cell.TeamOneCurOver.text = ""
                    }
                    
                    var teamName1 = String()
                    /*let key1 = inning2?.bwlt as? String
                    if key1 == "t1"
                    {
                        teamName1 = (fireBaseGlobalModel[CurrentMatch].t1?.n)!
                    }
                    else
                    {
                        teamName1 = (fireBaseGlobalModel[CurrentMatch].t2?.n)!
                    }*/
                    let key1 = fireBaseGlobalModel[CurrentMatch].i1b
                    if key1 == "t1"
                    {
                        teamName1 = (fireBaseGlobalModel[CurrentMatch].t1?.n)!
                    }
                    else
                    {
                        teamName1 = (fireBaseGlobalModel[CurrentMatch].t2?.n)!
                    }
                    
                    if let bowlingTeam1 : String = teamName1{
                        cell.TeamTwoName.text = bowlingTeam1
                    }
                    if let _ : String = inning1?.ov as? String{
                        cell.TeamTwoOver.text = ""//"(\( bowlingOver))"// + bowlingTotalOver
                    }
                    else{
                        cell.TeamTwoOver.text = "-"
                    }
                    if let bowlingScore1 : String = inning1?.sc as? String{
                        if let bowlingWickets : NSString =  inning1?.wk as? NSString{
                            cell.TeamTwoScore.text =  bowlingScore1  + String("/") + (bowlingWickets as String)
                        }
                        else
                        {
                            
                            cell.TeamTwoScore.text = bowlingScore1
                        }
                    }
                    else{
                        cell.TeamTwoScore.text = "-"
                    }
                    
                }
                else
                {
                    
                    var teamName = String()
                    /*let key = inning3?.bt as? String
                    if key == "t1"
                    {
                        teamName = (fireBaseGlobalModel[CurrentMatch].t1?.n)!
                    }
                    else
                    {
                        teamName = (fireBaseGlobalModel[CurrentMatch].t2?.n)!
                    }*/
                    let key = fireBaseGlobalModel[CurrentMatch].i3b
                    if key == "t1"
                    {
                        teamName = (fireBaseGlobalModel[CurrentMatch].t1?.n)!
                    }
                    else
                    {
                        teamName = (fireBaseGlobalModel[CurrentMatch].t2?.n)!
                    }
                    if let bowlingTeam : String = teamName{
                        cell.TeamOneName.text = bowlingTeam
                    }
                    else{
                        cell.TeamOneName.text = "N/A"
                    }
                    cell.TeamOneOvers.text = " & \(inning1score!)/\((inning1?.wk as? String)!)"// + bowlingTotalOver
                    
                    if let bowlingScore : String = inning3?.sc as? String{
                        if let bowlingWickets : NSString =  inning3?.wk as? NSString{
                            cell.TeamOneScore.text =  bowlingScore  + String("/") + (bowlingWickets as String)
                        }
                        else
                        {
                            
                            cell.TeamOneScore.text = bowlingScore
                        }
                    }
                    else{
                        cell.TeamOneScore.text = "-"
                    }
                    
                    if let currentOvr  = inning3?.ov{
                        cell.TeamOneCurOver.text = "(\(currentOvr))"
                    }
                    else{
                        cell.TeamOneCurOver.text = ""
                    }
                    
                    var teamName1 = String()
                    /*let key1 = inning3?.bwlt as? String
                    if key1 == "t1"
                    {
                        teamName1 = (fireBaseGlobalModel[CurrentMatch].t1?.n)!
                    }
                    else
                    {
                        teamName1 = (fireBaseGlobalModel[CurrentMatch].t2?.n)!
                    }*/
                    let key1 = fireBaseGlobalModel[CurrentMatch].i3b
                    if key1 == "t2"
                    {
                        teamName1 = (fireBaseGlobalModel[CurrentMatch].t1?.n)!
                    }
                    else
                    {
                        teamName1 = (fireBaseGlobalModel[CurrentMatch].t2?.n)!
                    }
                    if let bowlingTeam1 : String = teamName1{
                        cell.TeamTwoName.text = bowlingTeam1
                        
                    }
                    if let _ : String = inning1?.ov as? String{
                        cell.TeamTwoOver.text = ""//"(\( bowlingOver))"// + bowlingTotalOver
                    }
                    else{
                        cell.TeamTwoOver.text = "-"
                    }
                    if let bowlingScore1 : String = inning2?.sc as? String{
                        if let bowlingWickets : NSString =  inning2?.wk as? NSString{
                            cell.TeamTwoScore.text =  bowlingScore1  + String("/") + (bowlingWickets as String)
                        }
                        else
                        {
                            
                            cell.TeamTwoScore.text = bowlingScore1
                        }
                    }
                    else{
                        cell.TeamTwoScore.text = "-"
                    }
                    
                }
                cell.layoutIfNeeded()
                
            }
            else if (inning?.isEqual("i4"))!
            {
                    if isCellVisible(row:2)
                    {
                        if let cell2 = self.tv_watchLive_LiveScore.cellForRow(at: IndexPath(row: 2, section: 0)) as? MatchRateCell
                        {
                            self.updateRunX(cell:cell2)
                        }
                    }
                
                    let inning1 = fireBaseGlobalModel[CurrentMatch].i1
                    let inning2 = fireBaseGlobalModel[CurrentMatch].i2
                    let inning3 = fireBaseGlobalModel[CurrentMatch].i3
                    let inning4 = fireBaseGlobalModel[CurrentMatch].i4
                    var followOn = Bool()
                    
                    let inning1score = Int((inning1?.sc)!)
                    let inning2score = Int((inning2?.sc)!)
                    let inning3score = Int((inning3?.sc)!)
                    _ = Int((inning4?.sc)!)
                    
                
                    /*if inning2?.bt == inning3?.bt
                    {
                        followOn = true
                        
                    }*/
                    if fireBaseGlobalModel[CurrentMatch].i3b == "t2"
                    {
                        followOn = true
                    }
                    else
                    {
                        followOn = false
                    }
                    
                    if followOn == true
                    {
                        var teamName = String()
                        /*let key = inning4?.bt as? String
                        if key == "t1"
                        {
                            teamName = (fireBaseGlobalModel[CurrentMatch].t1?.n)!
                        }
                        else
                        {
                            teamName = (fireBaseGlobalModel[CurrentMatch].t2?.n)!
                        }*/
                        let key = fireBaseGlobalModel[CurrentMatch].i3b
                        if key == "t2"
                        {
                            teamName = (fireBaseGlobalModel[CurrentMatch].t1?.n)!
                        }
                        else
                        {
                            teamName = (fireBaseGlobalModel[CurrentMatch].t2?.n)!
                        }
                        if let bowlingTeam = teamName as? String{
                            cell.TeamOneName.text = bowlingTeam
                        }
                        else{
                            cell.TeamOneName.text = "N/A"
                        }
                        cell.TeamOneOvers.text = "& \(inning1score!)/\((inning1?.wk as? String)!)"// + bowlingTotalOver
                        if let bowlingScore : String = inning4?.sc as? String{
                            if let bowlingWickets : NSString =  inning4?.wk as? NSString{
                                cell.TeamOneScore.text =  bowlingScore  + String("/") + (bowlingWickets as String)
                            }
                            else
                            {
                                
                                cell.TeamOneScore.text = bowlingScore
                            }
                        }
                        else{
                            cell.TeamOneScore.text = "-"
                        }
                        
                        if let currentOvr  = inning4?.ov{
                            cell.TeamOneCurOver.text = "(\(currentOvr))"
                        }
                        else{
                            cell.TeamOneCurOver.text = ""
                        }
                        
                        var teamName1 = String()
                        /*let key1 = inning4?.bwlt as? String
                        if key1 == "t1"
                        {
                            teamName1 = (fireBaseGlobalModel[CurrentMatch].t1?.n)!
                        }
                        else
                        {
                            teamName1 = (fireBaseGlobalModel[CurrentMatch].t2?.n)!
                        }*/
                        let key1 = fireBaseGlobalModel[CurrentMatch].i3b
                        if key1 == "t1"
                        {
                            teamName1 = (fireBaseGlobalModel[CurrentMatch].t1?.n)!
                        }
                        else
                        {
                            teamName1 = (fireBaseGlobalModel[CurrentMatch].t2?.n)!
                        }
                        if let bowlingTeam1 = teamName1 as? String{
                            cell.TeamTwoName.text = bowlingTeam1
                            
                        }
                        if let _ : String = inning1?.ov as? String{
                            cell.TeamTwoOver.text = "&\( inning2score!)/\((inning2?.wk as? String)!)"// + bowlingTotalOver
                        }
                        else{
                            cell.TeamTwoOver.text = "-"
                        }
                        if let bowlingScore1 : String = inning3?.sc as? String{
                            if let bowlingWickets : NSString =  inning3?.wk as? NSString{
                                cell.TeamTwoScore.text =  bowlingScore1  + String("/") + (bowlingWickets as String)
                            }
                            else
                            {
                                
                                cell.TeamTwoScore.text = bowlingScore1
                            }
                        }
                        else{
                            cell.TeamTwoScore.text = "-"
                        }
                        
                    }
                    else
                    {
                        
                        var teamName = String()
                        /*let key = inning4?.bt as? String
                        if key == "t1"
                        {
                            teamName = (fireBaseGlobalModel[CurrentMatch].t1?.n)!
                        }
                        else
                        {
                            teamName = (fireBaseGlobalModel[CurrentMatch].t2?.n)!
                        }*/
                        let key = fireBaseGlobalModel[CurrentMatch].i3b
                        if key == "t2"
                        {
                            teamName = (fireBaseGlobalModel[CurrentMatch].t1?.n)!
                        }
                        else
                        {
                            teamName = (fireBaseGlobalModel[CurrentMatch].t2?.n)!
                        }
                        if let bowlingTeam = teamName as? String{
                            cell.TeamOneName.text = bowlingTeam
                        }
                        else{
                            cell.TeamOneName.text = "N/A"
                        }
                        
                        if let _ : String = inning2?.ov as? String{
                            cell.TeamOneOvers.text = "(\(inning2score!)/\((inning2?.wk as? String)!))"// + bowlingTotalOver
                        }
                        else{
                            cell.TeamOneOvers.text = "-"
                        }
                        if let bowlingScore : String = inning4?.sc as? String{
                            if let bowlingWickets : NSString =  inning4?.wk as? NSString{
                                cell.TeamOneScore.text =  bowlingScore  + String("/") + (bowlingWickets as String)
                            }
                            else{
                                cell.TeamOneScore.text = bowlingScore
                            }
                        }
                        else{
                            cell.TeamOneScore.text = "-"
                        }
                        
                        if let currentOvr  = inning4?.ov{
                            cell.TeamOneCurOver.text = "(\(currentOvr))"
                        }
                        else{
                            cell.TeamOneCurOver.text = ""
                        }
                        
                        var teamName1 = String()
                        /*let key1 = inning4?.bwlt as? String
                        if key1 == "t1"
                        {
                            teamName1 = (fireBaseGlobalModel[CurrentMatch].t1?.n)!
                        }
                        else
                        {
                            teamName1 = (fireBaseGlobalModel[CurrentMatch].t2?.n)!
                        }*/
                        let key1 = fireBaseGlobalModel[CurrentMatch].i3b
                        if key1 == "t2"
                        {
                            teamName1 = (fireBaseGlobalModel[CurrentMatch].t1?.n)!
                        }
                        else
                        {
                            teamName1 = (fireBaseGlobalModel[CurrentMatch].t2?.n)!
                        }
                        if let bowlingTeam1 = teamName1 as? String{
                            cell.TeamTwoName.text = bowlingTeam1
                            
                        }
                        if let _ : String = inning1?.ov as? String{
                            cell.TeamTwoOver.text = "(\( inning1score!)/\((inning1?.wk as? String)!))"// + bowlingTotalOver
                        }
                        else{
                            cell.TeamTwoOver.text = "-"
                        }
                        if let bowlingScore1 : String = inning3?.sc as? String{
                            if let bowlingWickets : NSString =  inning3?.wk as? NSString{
                                cell.TeamTwoScore.text =  bowlingScore1  + String("/") + (bowlingWickets as String)
                            }
                            else
                            {
                                cell.TeamTwoScore.text = bowlingScore1
                            }
                        }
                        else{
                            cell.TeamTwoScore.text = "-"
                        }
                    }
                    cell.layoutIfNeeded()
            }
        }
    }
    //MARK:- Suspend Session
    func setSessionSuspend(cell:MatchRateCell)
    {
        if let sessionSuspend : String = fireBaseGlobalModel[CurrentMatch].ssns,
            fireBaseGlobalModel[CurrentMatch].con?.mf != "Test"
        {
            if sessionSuspend == "0"
            {
                cell.suspendLbl.isHidden = true
            }
            else
            {
                cell.suspendLbl.isHidden = false
            }
        }
    }
    // MARK: Session Status And Run X BAll
    func setSessionAndRunXball(cell:MatchRateCell)
    {
        /*if fireBaseGlobalModel[CurrentMatch].con?.mf != "Test"
        {
            let session = fireBaseGlobalModel[CurrentMatch].ssn
            if let sessionOver : NSString = session?.ov as? NSString{
                cell.txt_sessionOver.text = sessionOver != "" ? (sessionOver as String) : ""
                var inning1 = CLGFirbaseInningModel()
                if fireBaseGlobalModel[CurrentMatch].i == "i1"
                {
                    inning1 = fireBaseGlobalModel[CurrentMatch].i1!
                }
                else
                {
                    inning1 = fireBaseGlobalModel[CurrentMatch].i2!
                }
                let currentBalls = balls(str: (inning1.ov!))
                let sessionOverBalls : NSInteger = NSInteger(sessionOver.longLongValue) * 6
                let currentBall : NSInteger = NSInteger(currentBalls)
                let RunBall2: NSInteger = sessionOverBalls - currentBall
                if(RunBall2 < 0)
                {
                    cell.txtRunBall2.text = "-"
                }
                else{
                    cell.txtRunBall2.text = String(format: "%d", RunBall2)
                }
            }
            else{
                cell.txt_sessionOver.text = ""
            }
            if let sessionStatusOne : String = session?.n{
                cell.txt_sessionRate1.text = sessionStatusOne != "" ? sessionStatusOne : "-"
            }
            else{
                cell.txt_sessionRate1.text = "-"
            }
            if let sessionStatusTwo : NSString = session?.y as? NSString{
                cell.txt_sessionRate2.text = sessionStatusTwo != "" ? (sessionStatusTwo as String) : "-"
                var inning = CLGFirbaseInningModel()
                if fireBaseGlobalModel[CurrentMatch].i == "i1"
                {
                    inning = fireBaseGlobalModel[CurrentMatch].i1!
                }
                else
                {
                    inning = fireBaseGlobalModel[CurrentMatch].i2!
                }
                let runs = inning.sc as! NSString
                let sessionMaxScore : NSInteger = NSInteger(sessionStatusTwo.longLongValue)
                let run : NSInteger = NSInteger(runs.longLongValue)
                let RunBall1 : NSInteger = sessionMaxScore - run
                if(RunBall1 < 0)
                {
                    cell.txtRunBall1.text = "-"
                }
                else{
                    cell.txtRunBall1.text = String(format: "%d", RunBall1)
                }
                
            }
            else{
                cell.txt_sessionRate2.text = "-"
            }
        }*/
        if fireBaseGlobalModel[CurrentMatch].con?.mf != "Test"
        {
            if let sn = fireBaseGlobalModel[CurrentMatch].sn, sn != ""{
                let snArray = sn.components(separatedBy: ",")
                //let session = fireBaseGlobalModel[CurrentMatch].ssn
                if let sessionOver : NSString = snArray[0] as? NSString{
                    cell.txt_sessionOver.text = sessionOver != "" ? (sessionOver as String) : ""
                    var inning1 = CLGFirbaseInningModel()
                    if fireBaseGlobalModel[CurrentMatch].i == "i1"
                    {
                        inning1 = fireBaseGlobalModel[CurrentMatch].i1!
                    }
                    else
                    {
                        inning1 = fireBaseGlobalModel[CurrentMatch].i2!
                    }
                    let currentBalls = balls(str: (inning1.ov!))
                    let sessionOverBalls : NSInteger = NSInteger(sessionOver.longLongValue) * 6
                    let currentBall : NSInteger = NSInteger(currentBalls)
                    let RunBall2: NSInteger = sessionOverBalls - currentBall
                    if(RunBall2 < 0)
                    {
                        cell.txtRunBall2.text = "-"
                    }
                    else{
                        cell.txtRunBall2.text = String(format: "%d", RunBall2)
                    }
                }
                else{
                    cell.txt_sessionOver.text = ""
                }
                if let sessionStatusOne : String = snArray[1]{
                    cell.txt_sessionRate1.text = sessionStatusOne != "" ? sessionStatusOne : "-"
                }
                else{
                    cell.txt_sessionRate1.text = "-"
                }
                if let sessionStatusTwo : NSString = snArray[2] as? NSString{
                    cell.txt_sessionRate2.text = sessionStatusTwo != "" ? (sessionStatusTwo as String) : "-"
                    var inning = CLGFirbaseInningModel()
                    if fireBaseGlobalModel[CurrentMatch].i == "i1"
                    {
                        inning = fireBaseGlobalModel[CurrentMatch].i1!
                    }
                    else
                    {
                        inning = fireBaseGlobalModel[CurrentMatch].i2!
                    }
                    let runs = inning.sc as! NSString
                    let sessionMaxScore : NSInteger = NSInteger(sessionStatusTwo.longLongValue)
                    let run : NSInteger = NSInteger(runs.longLongValue)
                    let RunBall1 : NSInteger = sessionMaxScore - run
                    if(RunBall1 < 0)
                    {
                        cell.txtRunBall1.text = "-"
                    }
                    else{
                        cell.txtRunBall1.text = String(format: "%d", RunBall1)
                    }
                    
                }
                else{
                    cell.txt_sessionRate2.text = "-"
                }
            }
            else{
                cell.txtRunBall1.text = "-"
                cell.txt_sessionRate1.text = "-"
                cell.txtRunBall2.text = "-"
                cell.txt_sessionRate2.text = "-"
                cell.txt_sessionOver.text = ""
            }
           
        }
    }
    @objc func updateCurrentRunRateCell()
    {
        if fireBaseGlobalModel[CurrentMatch].con?.mf == "Test"
        {
            if fireBaseGlobalModel[CurrentMatch].i == "i1"{
                self.FirInning1()
            }
            else if fireBaseGlobalModel[CurrentMatch].i == "i2"{
                self.FirInning2()
            }
            else if fireBaseGlobalModel[CurrentMatch].i == "i3"{
                self.FirInning3()
            }
            else{
                self.FirInning4()
            }
        }
    }
    // MARK: Current Run Rate Board
    func setCurrentRunRate(cell:CurrentRunRateCell)
    {
        if fireBaseGlobalModel[CurrentMatch].con?.mf == "Test"
        {
            //cell.heightConstraint.constant = 40
            if fireBaseGlobalModel[CurrentMatch].i == "i1"{
                self.FirInning1()
            }
            else if fireBaseGlobalModel[CurrentMatch].i == "i2"{
                self.FirInning2()
            }
            else if fireBaseGlobalModel[CurrentMatch].i == "i3"{
                self.FirInning3()
            }
            else{
                self.FirInning4()
            }
        }
        else
        {
            
            if let inning2 = fireBaseGlobalModel[CurrentMatch].i2{
               // cell.heightConstraint.constant = 80

                //            if var target : String = self.firebaseData.value(forKey: "target") as? String{
                var target = inning2.tr
                if target == ""
                {
                    target = "0"
                }
                
                cell.lbl_target.text = target
                
            }
            else{
                cell.lbl_target.text = "-"
            }
            let inning2 = fireBaseGlobalModel[CurrentMatch].i2
            //            var target : NSString = (self.firebaseData.value(forKey: "target") as? NSString)!
            var target:NSString = (inning2?.tr as NSString?)!
            if target == ""
            {
                target = "0"
            }
            let bowlingScore : NSString = (inning2?.sc as NSString?)!
            let tg : Double = Double(NSInteger(target.longLongValue))
            let bs : Double = Double(NSInteger(bowlingScore.longLongValue))
            let remainingRuns : Double = tg - bs
            //let remainingBalls : Double = Double(ballRemaining(ov:fireBaseGlobalModel[CurrentMatch].i2!.ov!,iov:fireBaseGlobalModel[CurrentMatch].i2!.iov!))
            var iover = (fireBaseGlobalModel[CurrentMatch].iov ?? "")
            if iover.isEmpty{
                iover = "0"
            }
            let remainingBalls : Double = Double(ballRemaining(ov:fireBaseGlobalModel[CurrentMatch].i2!.ov!,iov:iover))
            let rrr : Double = Double(remainingRuns/remainingBalls)
            if(rrr.isNaN){
            }
            else if (rrr < 0)
            {
                cell.lbl_ballR.text  = "-"
            }
            else if (rrr.isInfinite)
            {
                cell.lbl_ballR.text  = "-"
            }
            else
            {
                cell.lbl_ballR.text = String(format: "%.2f", rrr*6)
            }
            if let inning : NSString = fireBaseGlobalModel[CurrentMatch].i as NSString?
            {
                if (inning.isEqual(to: "i1"))
                {
                    //cell.heightConstraint.constant = 40

                    cell.lbl_scoreSeparator.isHidden = true
                    cell.secondInningsView.isHidden = true
                    cell.lbl_targetLabel.isHidden = true
                    cell.lbl_runNLabel.isHidden = false
                    cell.lbl_BallRLable.isHidden = true
                    cell.lbl_target.isHidden = true
                    cell.lbl_runNeeded.isHidden = false
                    cell.lbl_ballR.isHidden = true
                    
                    //if let ballR : String = "\(ballRemaining(ov:fireBaseGlobalModel[CurrentMatch].i1!.ov!,iov:fireBaseGlobalModel[CurrentMatch].i1!.iov!))"
                    var iover =  (fireBaseGlobalModel[CurrentMatch].iov ?? "")
                    if iover.isEmpty{
                        iover = "0"
                    }
                    if let ballR : String = "\(ballRemaining(ov:fireBaseGlobalModel[CurrentMatch].i1!.ov!,iov:iover))"
                    {
                        cell.lbl_RRRLabel.text =  "Balls Rem:"
                        cell.lbl_RRR.text = ballR
                    }
                    else{
                        cell.lbl_RRRLabel.text =  "Balls Rem:"
                        
                        cell.lbl_RRR.text = "-"
                    }
                    
                    
                    cell.lbl_runNLabel.text =  "Run Rate:"
                    
                    let inning1 = fireBaseGlobalModel[CurrentMatch].i1
                    //let over = inning1?.iov
                    var over = fireBaseGlobalModel[CurrentMatch].iov ?? ""
                    if over.isEmpty{
                        over = "0"
                    }
                    
                    //                let currentBalls : NSString = (self.firebaseData.value(forKey: "currentBalls") as? NSString)!
                    //let ballR : String = "\(ballRemaining(ov:fireBaseGlobalModel[CurrentMatch].i1!.ov!,iov:fireBaseGlobalModel[CurrentMatch].i1!.iov!))"
                    let ballR : String = "\(ballRemaining(ov:fireBaseGlobalModel[CurrentMatch].i1!.ov!,iov:over))"
                    var currentBalls = NSString()
                    if ballR == ""
                    {
                        currentBalls = "0"
                    }
                    else
                    {
                        currentBalls = "\(Int(over)!*6 - Int(ballR)!)" as NSString
                    }
                    
                    let battingScore : NSString = (inning1!.sc as NSString?)!
                    
                    let batScore : Double = Double(NSInteger(battingScore.longLongValue))
                    let curBalls : Double = Double(NSInteger(currentBalls.longLongValue))
                    let RunRate : Double = Double(batScore/curBalls)
                    if(RunRate.isNaN){
                        cell.lbl_runNeeded.text = "0.00"
                    }
                    else if (RunRate.isInfinite)
                    {
                        cell.lbl_runNeeded.text = "0.00"
                        
                    }
                    else{
                        cell.lbl_runNeeded.text = String(format: "%.2f", RunRate*6)
                        
                    }
                    
                }
                else if (inning.isEqual(to: "i2"))
                {
                    //cell.heightConstraint.constant = 80

//                    if let ballR : String = "\(ballRemaining(ov:fireBaseGlobalModel[CurrentMatch].i2!.ov!,iov:fireBaseGlobalModel[CurrentMatch].i2!.iov!))"
                    var iover = fireBaseGlobalModel[CurrentMatch].iov ?? ""
                    if iover.isEmpty{
                        iover = "0"
                    }
                    if let ballR : String = "\(ballRemaining(ov:fireBaseGlobalModel[CurrentMatch].i2!.ov!,iov:iover))"
                    {
                        cell.lbl_RRRLabel.text =  "Balls Rem:"
                        cell.lbl_RRR.text = ballR
                    }
                    else{
                        cell.lbl_RRRLabel.text =  "Balls Rem:"
                        
                        cell.lbl_RRR.text = "-"
                    }
                    cell.lbl_scoreSeparator.isHidden = false
                    cell.secondInningsView.isHidden = false
                    cell.lbl_targetLabel.isHidden = false
                    cell.lbl_runNLabel.isHidden = false
                    cell.lbl_RRRLabel.isHidden = false
                    cell.lbl_BallRLable.isHidden = false
                    cell.lbl_target.isHidden = false
                    cell.lbl_runNeeded.isHidden = false
                    cell.lbl_RRR.isHidden = false
                    cell.lbl_ballR.isHidden = false
                    cell.lbl_BallRLable.text = "R.R.R:"
                    let inning2 = fireBaseGlobalModel[CurrentMatch].i2
                    if let target : String = inning2?.tr{
                        
                        cell.lbl_targetLabel.text =  "Target:"
                        cell.lbl_target.text = target
                    }
                    else{
                        cell.lbl_targetLabel.text =  "Target:"
                        
                        cell.lbl_target.text = "-"
                    }
                    
                    if (inning2!.sc) != nil
                    {
                        cell.lbl_runNLabel.text =  "Run Needed:"
                        if bowlingScore != "NaN"
                        {
                            if (Int(target as String)! - Int(bowlingScore as String)!) < 0
                            {
                                cell.lbl_runNeeded.text = "- "
                                
                            }
                            else{
                                cell.lbl_runNeeded.text = String(Int(target as String)! - Int(bowlingScore as String)!)
                                
                            }
                        }
                        else
                        {
                            cell.lbl_runNeeded.text = "- "
                        }
                    }
                    else{
                        cell.lbl_runNLabel.text =  "Run Needed:"
                        
                        cell.lbl_runNeeded.text = "- "
                    }
                    
                    cell.lbl_CRR.text =  "C.R.R:"
                    
                    //let inning2 = fireBaseGlobalModel[CurrentMatch].i2
                    //let over = inning2?.iov
                    var over = fireBaseGlobalModel[CurrentMatch].iov ?? ""
                    if over.isEmpty{
                        over = "0"
                    }
                    //                let currentBalls : NSString = (self.firebaseData.value(forKey: "currentBalls") as? NSString)!
//                    let ballR : String = "\(ballRemaining(ov:fireBaseGlobalModel[CurrentMatch].i2!.ov!,iov:fireBaseGlobalModel[CurrentMatch].i2!.iov!))"
                    let ballR : String = "\(ballRemaining(ov:fireBaseGlobalModel[CurrentMatch].i2!.ov!,iov:over))"
                    var currentBalls = NSString()
                    if ballR == ""
                    {
                        currentBalls = "0"
                    }
                    else
                    {
                        currentBalls = "\(Int(over)!*6 - Int(ballR)!)" as NSString
                    }
                    
                    let battingScore : NSString = (inning2!.sc as NSString?)!
                    
                    let batScore : Double = Double(NSInteger(battingScore.longLongValue))
                    let curBalls : Double = Double(NSInteger(currentBalls.longLongValue))
                    let RunRate : Double = Double(batScore/curBalls)
                    if(RunRate.isNaN){
                        cell.lbl_CRRValue.text = "0.00"
                    }
                    else if (RunRate.isInfinite)
                    {
                        cell.lbl_CRRValue.text = "0.00"
                        
                    }
                    else{
                        cell.lbl_CRRValue.text = String(format: "%.2f", RunRate*6)
                        
                    }
                }
                
            }
            else
            {
                
                cell.lbl_scoreSeparator.isHidden = false
                cell.secondInningsView.isHidden = false
                cell.lbl_runNLabel.isHidden = false
                cell.lbl_RRRLabel.isHidden = false
                cell.lbl_BallRLable.isHidden = false
                cell.lbl_runNeeded.isHidden = false
                cell.lbl_RRR.isHidden = false
                cell.lbl_ballR.isHidden = false
                var inning = CLGFirbaseInningModel()
                if fireBaseGlobalModel[CurrentMatch].i == "i3"
                {
                    inning = fireBaseGlobalModel[CurrentMatch].i3!
                }
                else
                {
                    inning = fireBaseGlobalModel[CurrentMatch].i4!
                }
                if Int(inning.tr!)! != 0
                {
                    cell.lbl_targetLabel.text =  "Target:"
                    cell.lbl_target.text = inning.tr
                }
                else{
                    cell.lbl_targetLabel.text =  "Target:"
                    
                    cell.lbl_target.text = "-"
                }
            }
            let config = fireBaseGlobalModel[CurrentMatch].con
            
            if let matchStatus = config?.mstus
            {
                if matchStatus == "finished"
                {
                    cell.lbl_ballR.text = "-"
                }
            }
            
        }
    }
    
    // MARK: Market Rate
    func setMarketRate(cell:MatchRateCell)
    {
        /*if fireBaseGlobalModel[CurrentMatch].con?.mf != "Test"
        {
            let market = fireBaseGlobalModel[CurrentMatch].mkt
            if market?.r1 != ""
            {
                cell.txt_marketRate1.text = market?.r1
            }
            else{
                cell.txt_marketRate1.text = "-"
            }
            if market?.r2 != "" &&  market?.r2 != nil
            {
                let markerRateTwo  = market?.r2
                if previousValueMarketR2 != markerRateTwo{
                    previousValueMarketR2 = markerRateTwo!
                    if firstTimeLoad != true
                    {
                        cell.txt_marketRate2.transform = CGAffineTransform.identity
                        cell.txt_marketRate1.transform = CGAffineTransform.identity
                        UIView.animate(withDuration: 0.3, animations: {
                            cell.txt_marketRate2.transform = cell.txt_marketRate2.transform.scaledBy(x: 1.30, y: 1.30)
                            cell.txt_marketRate1.transform = cell.txt_marketRate1.transform.scaledBy(x: 1.30, y: 1.30)
                            
                        }, completion: {(true) in
                            
                            UIView.animate(withDuration: 0.3, animations: {
                                cell.txt_marketRate2.transform = CGAffineTransform.identity
                                cell.txt_marketRate1.transform = CGAffineTransform.identity
                            })
                        })
                    }
                }
                cell.txt_marketRate2.text = markerRateTwo
            }
            else{
                cell.txt_marketRate2.text = "-"
            }
        }
        else
        {
            
        }*/
        if fireBaseGlobalModel[CurrentMatch].con?.mf != "Test"
        {
            if let rt = fireBaseGlobalModel[CurrentMatch].rt, rt != ""{
                let rtArray = rt.components(separatedBy: ",")
                //let market = fireBaseGlobalModel[CurrentMatch].mkt
                if rtArray[1] != ""
                {
                    cell.txt_marketRate1.text = rtArray[1]
                }
                else{
                    cell.txt_marketRate1.text = "-"
                }
                if rtArray[2] != ""
                {
                    let markerRateTwo  = rtArray[2]
                    if previousValueMarketR2 != markerRateTwo{
                        previousValueMarketR2 = markerRateTwo
                        if firstTimeLoad != true
                        {
                            cell.txt_marketRate2.transform = CGAffineTransform.identity
                            cell.txt_marketRate1.transform = CGAffineTransform.identity
                            UIView.animate(withDuration: 0.3, animations: {
                                cell.txt_marketRate2.transform = cell.txt_marketRate2.transform.scaledBy(x: 1.30, y: 1.30)
                                cell.txt_marketRate1.transform = cell.txt_marketRate1.transform.scaledBy(x: 1.30, y: 1.30)
                                
                            }, completion: {(true) in
                                
                                UIView.animate(withDuration: 0.3, animations: {
                                    cell.txt_marketRate2.transform = CGAffineTransform.identity
                                    cell.txt_marketRate1.transform = CGAffineTransform.identity
                                })
                            })
                        }
                    }
                    cell.txt_marketRate2.text = markerRateTwo
                }
                else{
                    cell.txt_marketRate2.text = "-"
                }

            }
            else{
                cell.txt_marketRate1.text = "-"
                cell.txt_marketRate2.text = "-"
            }
        }
        else
        {
            
        }
    }
    func setTestMatchRate(cell:TestMatchRateCell)
    {
        /*cell.lblR1R2Title.text = fireBaseGlobalModel[CurrentMatch].t1?.n!
        cell.lbl3R4Title.text = fireBaseGlobalModel[CurrentMatch].t2?.n!
        cell.lblR5R6Title.text = "Draw"
        cell.lblR1.text = (fireBaseGlobalModel[CurrentMatch].mkt?.r1?.isBlank)! ? "-" : fireBaseGlobalModel[CurrentMatch].mkt?.r1!
        cell.lblR2.text = (fireBaseGlobalModel[CurrentMatch].mkt?.r2?.isBlank)! ? "-" : fireBaseGlobalModel[CurrentMatch].mkt?.r2!
        cell.lblR3.text = (fireBaseGlobalModel[CurrentMatch].mkt?.r3?.isBlank)! ? "-" : fireBaseGlobalModel[CurrentMatch].mkt?.r3!
        cell.lblR4.text = (fireBaseGlobalModel[CurrentMatch].mkt?.r4?.isBlank)! ? "-" : fireBaseGlobalModel[CurrentMatch].mkt?.r4!
        cell.lblR5.text = (fireBaseGlobalModel[CurrentMatch].mkt?.r5?.isBlank)! ? "-" : fireBaseGlobalModel[CurrentMatch].mkt?.r5!
        cell.lblR6.text = (fireBaseGlobalModel[CurrentMatch].mkt?.r6?.isBlank)! ? "-" : fireBaseGlobalModel[CurrentMatch].mkt?.r6!
        if fireBaseGlobalModel[CurrentMatch].lb != nil ,
            fireBaseGlobalModel[CurrentMatch].lb!.l1 != nil ,
            fireBaseGlobalModel[CurrentMatch].lb!.l2 != nil
        {
            cell.lblL1.text = (fireBaseGlobalModel[CurrentMatch].lb?.l1?.isBlank)! ? "-" : fireBaseGlobalModel[CurrentMatch].lb?.l1!
            cell.lblL2.text = (fireBaseGlobalModel[CurrentMatch].lb?.l2?.isBlank)! ? "-" : fireBaseGlobalModel[CurrentMatch].lb?.l2!
           /* if fireBaseGlobalModel[CurrentMatch].i != "i4"
            {

                cell.viewLambi.isHidden = true

                /*if fireBaseGlobalModel[CurrentMatch].i == "i1"
                {
                    cell.lblLambi.text = "1st Innings Score"
                }
                else if fireBaseGlobalModel[CurrentMatch].i == "i2"
                {
                    cell.lblLambi.text = "2nd Innings Score"
                }
                else
                {
                    cell.lblLambi.text = "3rd Innings Score"
                }*/
            }
            else
            {
                cell.viewLambi.isHidden = true
                tv_watchLive_LiveScore.reloadRows(at: [IndexPath(row: 2, section: 0)], with: UITableViewRowAnimation.automatic)
            }
            if let sessionSuspended = fireBaseGlobalModel[CurrentMatch].ssns,
                sessionSuspended == "0"
            {
                cell.lblSuspended.isHidden = true
            }
            else
            {
                cell.viewLambi.isHidden = false
                cell.lblSuspended.isHidden = false
            }*/
            cell.viewLambi.isHidden = true
        }
        else
        {
            cell.viewLambi.isHidden = true
        }*/
        
        cell.lblR1R2Title.text = fireBaseGlobalModel[CurrentMatch].t1?.n!
        cell.lbl3R4Title.text = fireBaseGlobalModel[CurrentMatch].t2?.n!
        cell.lblR5R6Title.text = "Draw"
        if let rt = fireBaseGlobalModel[CurrentMatch].rt, rt != ""{
            let rtArray = rt.components(separatedBy: ",")
            cell.lblR1.text = (rtArray[0].isBlank) ? "-" : rtArray[0]
            cell.lblR2.text = (rtArray[1].isBlank) ? "-" : rtArray[1]
            cell.lblR3.text = (rtArray[2].isBlank) ? "-" : rtArray[2]
            cell.lblR4.text = (rtArray[3].isBlank) ? "-" : rtArray[3]
            cell.lblR5.text = (rtArray[4].isBlank) ? "-" : rtArray[4]
            cell.lblR6.text = (rtArray[5].isBlank) ? "-" : rtArray[5]
        }
        else{
            cell.lblR1.text =  "-"
            cell.lblR2.text =  "-"
            cell.lblR3.text =  "-"
            cell.lblR4.text =  "-"
            cell.lblR5.text =  "-"
            cell.lblR6.text =  "-" 
        }
        cell.viewLambi.isHidden = true
        /*if fireBaseGlobalModel[CurrentMatch].lb != nil ,
            fireBaseGlobalModel[CurrentMatch].lb!.l1 != nil ,
            fireBaseGlobalModel[CurrentMatch].lb!.l2 != nil
        {
            cell.lblL1.text = (fireBaseGlobalModel[CurrentMatch].lb?.l1?.isBlank)! ? "-" : fireBaseGlobalModel[CurrentMatch].lb?.l1!
            cell.lblL2.text = (fireBaseGlobalModel[CurrentMatch].lb?.l2?.isBlank)! ? "-" : fireBaseGlobalModel[CurrentMatch].lb?.l2!
            /* if fireBaseGlobalModel[CurrentMatch].i != "i4"
             {
             
             cell.viewLambi.isHidden = true
             
             /*if fireBaseGlobalModel[CurrentMatch].i == "i1"
             {
             cell.lblLambi.text = "1st Innings Score"
             }
             else if fireBaseGlobalModel[CurrentMatch].i == "i2"
             {
             cell.lblLambi.text = "2nd Innings Score"
             }
             else
             {
             cell.lblLambi.text = "3rd Innings Score"
             }*/
             }
             else
             {
             cell.viewLambi.isHidden = true
             tv_watchLive_LiveScore.reloadRows(at: [IndexPath(row: 2, section: 0)], with: UITableViewRowAnimation.automatic)
             }
             if let sessionSuspended = fireBaseGlobalModel[CurrentMatch].ssns,
             sessionSuspended == "0"
             {
             cell.lblSuspended.isHidden = true
             }
             else
             {
             cell.viewLambi.isHidden = false
             cell.lblSuspended.isHidden = false
             }*/
            cell.viewLambi.isHidden = true
        }
        else
        {
            cell.viewLambi.isHidden = true
        }*/
    }
    // MARK: Favourite Team
    func setFavouriteTeam(cell:MatchRateCell)
    {
        if let rt = fireBaseGlobalModel[CurrentMatch].rt, rt != "",
            fireBaseGlobalModel[CurrentMatch].con?.mf != "Test"
        {
            let rtArray = rt.components(separatedBy: ",")
            
            if(rtArray[0] == "")
            {
                cell.txt_favouriteTeam.text = "-"
                cell.markeetRateLbl.text = "-"
            }
            else
            {
                if previousValuefavTeam != rtArray[0]{
                    previousValuefavTeam = rtArray[0]
                    if firstTimeLoad != true
                    {
                        cell.txt_favouriteTeam.transform = CGAffineTransform(rotationAngle: 0.1)
                        cell.markeetRateLbl.transform = CGAffineTransform(rotationAngle: 0.1)
                        UIView.animate(withDuration: 0.1, animations: {
                            cell.txt_favouriteTeam.transform = CGAffineTransform(rotationAngle: -0.1)
                            cell.markeetRateLbl.transform = CGAffineTransform(rotationAngle: -0.1)
                            
                        }, completion: { (true) in
                            cell.txt_favouriteTeam.transform = CGAffineTransform(rotationAngle: 0.1)
                            cell.markeetRateLbl.transform = CGAffineTransform(rotationAngle: 0.1)
                            UIView.animate(withDuration: 0.1, animations: {
                                cell.txt_favouriteTeam.transform = CGAffineTransform(rotationAngle: -0.1)
                                cell.markeetRateLbl.transform = CGAffineTransform(rotationAngle: -0.1)
                                
                            }, completion: { (true) in
                                cell.txt_favouriteTeam.transform = CGAffineTransform.identity
                                cell.markeetRateLbl.transform = CGAffineTransform.identity
                                
                            })
                        })
                        
                    }
                    else
                    {
                        firstTimeLoad = false
                    }
                }
                else
                {
                    firstTimeLoad = false
                }
                /* if favouriteTeam.count > 6{
                 let rangeOne = favouriteTeam.index(favouriteTeam.startIndex, offsetBy: (6))
                 cell.txt_favouriteTeam.text = favouriteTeam.substring(to: rangeOne)
                 cell.markeetRateLbl.text = favouriteTeam.substring(to: rangeOne) + ":"
                 }
                 else{*/
                cell.txt_favouriteTeam.text = rtArray[0]
                cell.markeetRateLbl.text = rtArray[0] + ":"
                //}
                
            }
        }
        else{
            cell.txt_favouriteTeam.text = "-"
            cell.markeetRateLbl.text = "-"
        }
        /*if let favouriteTeam = fireBaseGlobalModel[CurrentMatch].ft,
            fireBaseGlobalModel[CurrentMatch].con?.mf != "Test"
        {
            if(favouriteTeam == "")
            {
                cell.txt_favouriteTeam.text = "-"
                cell.markeetRateLbl.text = "-"
            }
            else
            {
                if previousValuefavTeam != favouriteTeam{
                    previousValuefavTeam = favouriteTeam
                    if firstTimeLoad != true
                    {
                        cell.txt_favouriteTeam.transform = CGAffineTransform(rotationAngle: 0.1)
                        cell.markeetRateLbl.transform = CGAffineTransform(rotationAngle: 0.1)
                        UIView.animate(withDuration: 0.1, animations: {
                            cell.txt_favouriteTeam.transform = CGAffineTransform(rotationAngle: -0.1)
                            cell.markeetRateLbl.transform = CGAffineTransform(rotationAngle: -0.1)
                            
                        }, completion: { (true) in
                            cell.txt_favouriteTeam.transform = CGAffineTransform(rotationAngle: 0.1)
                            cell.markeetRateLbl.transform = CGAffineTransform(rotationAngle: 0.1)
                            UIView.animate(withDuration: 0.1, animations: {
                                cell.txt_favouriteTeam.transform = CGAffineTransform(rotationAngle: -0.1)
                                cell.markeetRateLbl.transform = CGAffineTransform(rotationAngle: -0.1)
                                
                            }, completion: { (true) in
                                cell.txt_favouriteTeam.transform = CGAffineTransform.identity
                                cell.markeetRateLbl.transform = CGAffineTransform.identity
                                
                            })
                        })
                        
                    }
                    else
                    {
                        firstTimeLoad = false
                    }
                }
                else
                {
                    firstTimeLoad = false
                }
               /* if favouriteTeam.count > 6{
                    let rangeOne = favouriteTeam.index(favouriteTeam.startIndex, offsetBy: (6))
                    cell.txt_favouriteTeam.text = favouriteTeam.substring(to: rangeOne)
                    cell.markeetRateLbl.text = favouriteTeam.substring(to: rangeOne) + ":"
                }
                else{*/
                    cell.txt_favouriteTeam.text = favouriteTeam
                    cell.markeetRateLbl.text = favouriteTeam + ":"
                //}
                
            }
        }
        else{
            cell.txt_favouriteTeam.text = "-"
            cell.markeetRateLbl.text = "-"
        }*/
    }
    //MARK: players scoreboard
    /*func setPlayerScoreCell(cell:PlayersScoreCell)
     {
        if fireBaseGlobalModel[CurrentMatch].p?.r != "" &&  fireBaseGlobalModel[CurrentMatch].p?.b != ""
        {
            cell.lblPartnership.text = (fireBaseGlobalModel[CurrentMatch].p?.r)! + "(" + (fireBaseGlobalModel[CurrentMatch].p?.b)! + ")"
        }
        else
        {
            cell.lblPartnership.text = "-"
        }
        if fireBaseGlobalModel[CurrentMatch].lw != ""
        {
            cell.lastWktLabel.text = fireBaseGlobalModel[CurrentMatch].lw
        }
        else
        {
            cell.lastWktLabel.text = "-"
        }
        if fireBaseGlobalModel[CurrentMatch].p1s?.b != "0"
        {
            let ball = ((fireBaseGlobalModel[CurrentMatch].p1s!.b ?? "1") as NSString).doubleValue
            let run  = ((fireBaseGlobalModel[CurrentMatch].p1s!.r ?? "1") as NSString).doubleValue
            cell.lblBatsman1SRR.text = String(format: "%.1f", ((run/ball)*100))
        }
        else
        {
            cell.lblBatsman1SRR.text = fireBaseGlobalModel[CurrentMatch].p1s?.b
        }
        if fireBaseGlobalModel[CurrentMatch].p2s?.b != "0"
        {
            let ball = ((fireBaseGlobalModel[CurrentMatch].p2s!.b ?? "1") as NSString).doubleValue
            let run  = ((fireBaseGlobalModel[CurrentMatch].p2s!.r ?? "1") as NSString).doubleValue
            cell.lblBatsman2SRR.text = String(format: "%.1f", ((run/ball)*100))
        }
        else
        {
            cell.lblBatsman2SRR.text = fireBaseGlobalModel[CurrentMatch].p2s?.b
        }
        if fireBaseGlobalModel[CurrentMatch].bwl?.ov != "0"
        {
            let run  = ((fireBaseGlobalModel[CurrentMatch].bwl!.r ?? "1") as NSString).doubleValue
            cell.lblBowlerEco.text = String(format: "%.1f", ((run/Double(balls(str:(fireBaseGlobalModel[CurrentMatch].bwl?.ov!)!)))*6))
        }
        else
        {
            cell.lblBowlerEco.text = fireBaseGlobalModel[CurrentMatch].bwl?.ov
        }
        if let p1 = fireBaseGlobalModel[CurrentMatch].p1{
            cell.lblBatsman1Name.text = p1 != "" ? p1.trimmingCharacters(in: .whitespacesAndNewlines).firstUppercased  : "    -"
        }
        cell.lblBatsman1Run.text = fireBaseGlobalModel[CurrentMatch].p1s?.r
        cell.lblBatsman1Ball.text = fireBaseGlobalModel[CurrentMatch].p1s?.b
        cell.lblBatsman1Fours.text = fireBaseGlobalModel[CurrentMatch].p1s?.f
        cell.lblBatsman1Six.text = fireBaseGlobalModel[CurrentMatch].p1s?.s
        if let p2 = fireBaseGlobalModel[CurrentMatch].p2{
            cell.lblBatsman2Name.text = p2 != "" ? p2.trimmingCharacters(in: .whitespacesAndNewlines).firstUppercased : "    -"
        }
        
        cell.lblBatsman2Run.text = fireBaseGlobalModel[CurrentMatch].p2s?.r
        cell.lblBatsman2Ball.text = fireBaseGlobalModel[CurrentMatch].p2s?.b
        cell.lblBatsman2Fours.text = fireBaseGlobalModel[CurrentMatch].p2s?.f
        cell.lblBatsman2Six.text = fireBaseGlobalModel[CurrentMatch].p2s?.s
        cell.lblBowlerName.text = fireBaseGlobalModel[CurrentMatch].bwl?.n != "" ? fireBaseGlobalModel[CurrentMatch].bwl?.n?.capitalized : ""
        cell.lblBowlerName.text = fireBaseGlobalModel[CurrentMatch].bwl?.n != "0" ? fireBaseGlobalModel[CurrentMatch].bwl?.n?.capitalized : ""
        cell.lblBowlerRun.text = fireBaseGlobalModel[CurrentMatch].bwl?.r
        cell.lblBowlerOver.text = fireBaseGlobalModel[CurrentMatch].bwl?.ov != "0" && fireBaseGlobalModel[CurrentMatch].bwl?.ov != "" ? " ("+(fireBaseGlobalModel[CurrentMatch].bwl?.ov)!+")" : ""
        cell.lblBowlerWicket.text = fireBaseGlobalModel[CurrentMatch].bwl?.w
        if fireBaseGlobalModel[CurrentMatch].os == "p1" && fireBaseGlobalModel[CurrentMatch].p2 != "" && fireBaseGlobalModel[CurrentMatch].p1 != ""
        {
            cell.lblBatsman1Name.text = cell.lblBatsman1Name.text! + "*"
        }
        else if fireBaseGlobalModel[CurrentMatch].os == "p2" && fireBaseGlobalModel[CurrentMatch].p1 != "" && fireBaseGlobalModel[CurrentMatch].p2 != ""
        {
            cell.lblBatsman2Name.text = cell.lblBatsman2Name.text! + "*"
        }
    }*/
    
    func setPlayerScoreCell(cell:PlayersScoreCell)
    {
        if let pt = fireBaseGlobalModel[CurrentMatch].pt, pt != ""{
            let pArr = pt.components(separatedBy: ",")
            if pArr.count > 0{
                cell.lblPartnership.text = pArr[0] + "(" + pArr[1] + ")"
            }
            else{
                cell.lblPartnership.text = "-"
            }
        }
        else{
            cell.lblPartnership.text = "-"
        }
        
        if fireBaseGlobalModel[CurrentMatch].lw != ""
        {
            cell.lastWktLabel.text = fireBaseGlobalModel[CurrentMatch].lw
        }
        else
        {
            cell.lastWktLabel.text = "-"
        }
        if let b1s = fireBaseGlobalModel[CurrentMatch].b1s, b1s != ""{
            let b1sArr = b1s.components(separatedBy: ",")
            if b1sArr.count > 0{
                if b1sArr[1] != "0"{
                    let ball = (b1sArr[1] as NSString).doubleValue
                    let run  = (b1sArr[0] as NSString).doubleValue
                    cell.lblBatsman1SRR.text = String(format: "%.1f", ((run/ball)*100))
                }
                else{
                    cell.lblBatsman1SRR.text = b1sArr[1]
                }
                cell.lblBatsman1Run.text = b1sArr[0]
                cell.lblBatsman1Ball.text = b1sArr[1]
                cell.lblBatsman1Fours.text = b1sArr[2]
                cell.lblBatsman1Six.text = b1sArr[3]
            }
            else{
                cell.lblBatsman1SRR.text = "0"
                cell.lblBatsman1Run.text = "0"
                cell.lblBatsman1Ball.text = "0"
                cell.lblBatsman1Fours.text = "0"
                cell.lblBatsman1Six.text = "0"
            }
            
        }
        else{
            cell.lblBatsman1SRR.text = "0"
            cell.lblBatsman1Run.text = "0"
            cell.lblBatsman1Ball.text = "0"
            cell.lblBatsman1Fours.text = "0"
            cell.lblBatsman1Six.text = "0"
        }
        
        if let b2s = fireBaseGlobalModel[CurrentMatch].b2s, b2s != ""{
            let b2sArr = b2s.components(separatedBy: ",")
            if b2sArr.count > 0{
                if b2sArr[1] != "0"{
                    let ball = (b2sArr[1] as NSString).doubleValue
                    let run  = (b2sArr[0] as NSString).doubleValue
                    cell.lblBatsman2SRR.text = String(format: "%.1f", ((run/ball)*100))
                }
                else{
                    cell.lblBatsman2SRR.text = b2sArr[1]
                }
                cell.lblBatsman2Run.text = b2sArr[0]
                cell.lblBatsman2Ball.text = b2sArr[1]
                cell.lblBatsman2Fours.text = b2sArr[2]
                cell.lblBatsman2Six.text = b2sArr[3]
            }
            else{
                cell.lblBatsman2SRR.text = "0"
                cell.lblBatsman2Run.text = "0"
                cell.lblBatsman2Ball.text = "0"
                cell.lblBatsman2Fours.text = "0"
                cell.lblBatsman2Six.text = "0"
            }
        }
        else{
            cell.lblBatsman2SRR.text = "0"
            cell.lblBatsman2Run.text = "0"
            cell.lblBatsman2Ball.text = "0"
            cell.lblBatsman2Fours.text = "0"
            cell.lblBatsman2Six.text = "0"
        }
        
        if let p1 = fireBaseGlobalModel[CurrentMatch].p1{
            cell.lblBatsman1Name.text = p1 != "" ? p1.trimmingCharacters(in: .whitespacesAndNewlines).firstUppercased  : "    -"
        }
        if let p2 = fireBaseGlobalModel[CurrentMatch].p2{
            cell.lblBatsman2Name.text = p2 != "" ? p2.trimmingCharacters(in: .whitespacesAndNewlines).firstUppercased : "    -"
        }
        cell.lblBowlerName.text = (fireBaseGlobalModel[CurrentMatch].bw ?? "").capitalized
        if fireBaseGlobalModel[CurrentMatch].os == "p1" && fireBaseGlobalModel[CurrentMatch].p2 != "" && fireBaseGlobalModel[CurrentMatch].p1 != ""
        {
            cell.lblBatsman1Name.text = cell.lblBatsman1Name.text! + "*"
        }
        else if fireBaseGlobalModel[CurrentMatch].os == "p2" && fireBaseGlobalModel[CurrentMatch].p1 != "" && fireBaseGlobalModel[CurrentMatch].p2 != ""
        {
            cell.lblBatsman2Name.text = cell.lblBatsman2Name.text! + "*"
        }
    }
    // MARK: Preious 24 balls
    func setLastBallScore(cell:LastBallScore)
    {
        let previousBallsStr = fireBaseGlobalModel[CurrentMatch].pb
        let previousBalls = previousBallsStr?.components(separatedBy: ",")
        PreviousBallArr = previousBalls as! [String]
        cell.previousBallCv.reloadData()
        
        if !(previousBallsStr?.isBlank)!
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                cell.previousBallCv.scrollToItem(at: IndexPath(item: ((PreviousBallArr.count)-1), section: 0), at: UICollectionViewScrollPosition.right, animated: false)
                return
            })
        }
        
        /*if !(previousBallsStr?.isBlank)!
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                let currentVisibleCells = cell.previousBallCv.visibleCells
                for VisibleCell in currentVisibleCells
                {
                    if cell.previousBallCv.indexPath(for: VisibleCell) == IndexPath(item:0, section: 0)
                    {
                        cell.previousBallCv.scrollToItem(at: IndexPath(item: ((previousBalls?.count)!-1), section: 0), at: UICollectionViewScrollPosition.right, animated: false)
                        return
                    }
                }
                /*DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    let currentVisibleCells = cell.previousBallCv.visibleCells
                    for VisibleCell in currentVisibleCells
                    {
                        if cell.previousBallCv.indexPath(for: VisibleCell) == IndexPath(item: 0, section: 0)
                        {
                            cell.previousBallCv.scrollToItem(at: IndexPath(item: ((previousBalls?.count)!-1), section: 0), at: UICollectionViewScrollPosition.right, animated: false)
                            return
                        }
                    }
                })*/

            })
        }*/
    }
    /*func refereshLastBallScore(cell:LastBallScore)
    {
        if let pr = fireBaseGlobalModel[CurrentMatch].pr{
            //let previousBallsStr = fireBaseGlobalModel[CurrentMatch].pb
            //let previousBalls = previousBallsStr?.components(separatedBy: ",")
            //PreviousBallArr = previousBalls as! [String]
            var previousBalls = PreviousBallArr
            let previousBallsStr = previousBalls.joined(separator: ",")
            if PreviousBallArr.count != 0{
                previousBalls = previousBalls.remove(at: 0) as! [String]
                PreviousBallArr = previousBalls.appending(pr)
                cell.previousBallCv.reloadData()
                
                if !(previousBallsStr.isBlank)
                {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        let currentVisibleCells = cell.previousBallCv.visibleCells
                        for VisibleCell in currentVisibleCells
                        {
                            if cell.previousBallCv.indexPath(for: VisibleCell) == IndexPath(item:0, section: 0)
                            {
                                cell.previousBallCv.scrollToItem(at: IndexPath(item: ((PreviousBallArr.count)-1), section: 0), at: UICollectionViewScrollPosition.right, animated: false)
                                return
                            }
                        }
                        /*DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                         let currentVisibleCells = cell.previousBallCv.visibleCells
                         for VisibleCell in currentVisibleCells
                         {
                         if cell.previousBallCv.indexPath(for: VisibleCell) == IndexPath(item: 0, section: 0)
                         {
                         cell.previousBallCv.scrollToItem(at: IndexPath(item: ((previousBalls?.count)!-1), section: 0), at: UICollectionViewScrollPosition.right, animated: false)
                         return
                         }
                         }
                         })*/
                        
                    })
                }
            }
        }
    }*/
    // MARK: Local Description
    func setMatchRateTextCell(cell:MatchRateTextCell)
    {
        if let localDescription = fireBaseGlobalModel[CurrentMatch].md,
            !localDescription.isBlank
        {
            cell.lblDescription.text = localDescription
            cell.movingLbl.isHidden = true
            
        }
        else
        {
            cell.movingLbl.isHidden = false
            cell.movingLbl.text = "           Thank you for using cricket line guru. Please share and rate us 5 stars.                        "
            cell.movingLbl.speed = .duration(15)
            cell.movingLbl.restartLabel()
        }
    }
    
    
    // MARK: Balls from over
    func balls(str:String) -> Int
    {
        let ovr = (str as NSString).doubleValue
        let temp = (str.components(separatedBy: "."))
        if temp.count > 1
        {
            return (Int(ovr)*6) + Int(temp[1])!
        }
        else
        {
            return (Int(ovr)*6)
        }
    }
    func voice(eng:String,hin:String)
    {
        if( UserDefault.userDefaultForKey(key: "isSpeech") == "1")
        {
            if self.ViewIsLoadedForFirstTimeFlag == 3
            {
                if UserDefault.userDefaultForAny(key: "AudioLanguage") as! String == "ENG"
                {
                    self.playSound(sound: eng)
                }
                else
                {
                    self.playSound(sound:hin)
                }
            }
            else if self.ViewIsLoadedForFirstTimeFlag == 1
            {
                self.ViewIsLoadedForFirstTimeFlag = 3
            }
        }
    }
    
    func playTextToVoice()
    {
        if( UserDefault.userDefaultForKey(key: "isSpeech") == "1")
        {
            if self.ViewIsLoadedForFirstTimeFlag == 3
            {
                player?.stop()
                var str = String()
                if fireBaseGlobalModel[CurrentMatch].i == "i2" && fireBaseGlobalModel[CurrentMatch].con?.mf != "Test"
                {
                    let str1 = " को चाहिए "
                    let str2 = " गेंदों पर"
                    let str6 = " रन "
                    let str3 = " runs in "
                    let str4 = " balls"
                    let str5 = " needs "
                    //let name = ((fireBaseGlobalModel[CurrentMatch].i2?.bt)! == "t1" ?  fireBaseGlobalModel[CurrentMatch].t1?.f :  fireBaseGlobalModel[CurrentMatch].t2?.f)!
                    let name = (fireBaseGlobalModel[CurrentMatch].i1b == "t2" ?  fireBaseGlobalModel[CurrentMatch].t1?.f :  fireBaseGlobalModel[CurrentMatch].t2?.f)!
                    let run = "\(Int((fireBaseGlobalModel[CurrentMatch].i2?.tr)!)!-Int((fireBaseGlobalModel[CurrentMatch].i2?.sc)!)!)"
                    //let ball = "\(self.ballRemaining(ov: (fireBaseGlobalModel[CurrentMatch].i2?.ov)!, iov: (fireBaseGlobalModel[CurrentMatch].i2?.iov)!))"
                    var iover = fireBaseGlobalModel[CurrentMatch].iov ?? ""
                    if iover.isEmpty{
                        iover = "0"
                    }
                    let ball = "\(self.ballRemaining(ov: (fireBaseGlobalModel[CurrentMatch].i2?.ov)!, iov: iover))"
                    if UserDefault.userDefaultForAny(key: "AudioLanguage") as! String == "ENG"
                    {
                        str = name+str5+run+str3+ball+str4
                    }
                    else
                    {
                        str = name+str1+run+str6+ball+str2
                    }
                    
                }
                let utterance = AVSpeechUtterance(string: str)
                utterance.voice = UserDefault.userDefaultForAny(key: "AudioLanguage") as! String != "ENG" ? AVSpeechSynthesisVoice(language: "hi-IN") : AVSpeechSynthesisVoice(language: "en-US")
                utterance.rate = 0.5
                synthesizer.speak(utterance)
            }
            else if self.ViewIsLoadedForFirstTimeFlag == 1
            {
                self.ViewIsLoadedForFirstTimeFlag = 3
            }
        }
    }
    // MARK: BallsRemaing from over
    func ballRemaining(ov:String,iov:String) -> Int
    {
        let tempOv = balls(str:ov)
        let tempIov = balls(str:iov)
        if (tempIov-tempOv) < 0{
            return 0
        }
        else{
            return (tempIov-tempOv)
        }
    }
    func ballsToOver(balls:Int) -> String
    {
        let tempOne:Int = balls/6
        let tempTwo:Int = balls%6
        return tempTwo == 0 ? ("\(tempOne)") : ("\(tempOne).\(tempTwo)")
    }
    @objc func FirInning1()
    {
        if isCellVisible(row:0) && isCellVisible(row:1)
        {
            let cell = self.tv_watchLive_LiveScore.cellForRow(at: IndexPath(row: 0, section: 0)) as! TvCell
            let cell1 = self.tv_watchLive_LiveScore.cellForRow(at: IndexPath(row: 1, section: 0)) as! CurrentRunRateCell
            if (fireBaseGlobalModel[CurrentMatch].i == "i1")
            {
                if isCellVisible(row:2)
                {
                    if let cell2 = self.tv_watchLive_LiveScore.cellForRow(at: IndexPath(row: 2, section: 0)) as? MatchRateCell
                    {
                        self.updateRunX(cell:cell2)
                    }
                }
                cell.TeamOneCurOver.text = ""
                cell.TeamTwoOver.isHidden = true
                cell.TeamTwoScore.isHidden = true
                cell.TeamTwoName.isHidden = true
                cell1.secondInningsView.isHidden = true
                cell1.lbl_targetLabel.isHidden = true
                cell1.lbl_runNLabel.isHidden = false
                cell1.lbl_BallRLable.isHidden = true
                cell1.lbl_target.isHidden = true
                cell1.lbl_runNeeded.isHidden = false
                cell1.lbl_ballR.isHidden = true
                cell1.lbl_RRRLabel.text =  "Balls Rem:"
                cell1.middleView.isHidden = true
//                cell1.lbl_RRR.text = "\(self.ballRemaining(ov: (fireBaseGlobalModel[CurrentMatch].i1?.ov)!, iov: (fireBaseGlobalModel[CurrentMatch].i1?.iov)!))"
                var iover = fireBaseGlobalModel[CurrentMatch].iov ?? ""
                if iover.isEmpty{
                    iover = "0"
                }
                cell1.lbl_RRR.text = "\(self.ballRemaining(ov: (fireBaseGlobalModel[CurrentMatch].i1?.ov)!, iov: iover))"
                let config = fireBaseGlobalModel[CurrentMatch].con
                let matchFormat : NSString = config?.mf as! NSString
                if matchFormat == "Test"
                {
                    cell1.lbl_RRRLabel.text =  "Day:"
                    cell1.middleView.isHidden = false
                    cell1.lbl_rem_ovr.text = "Over Rem:"
                    //cell1.lbl_test_rem_ovr.text = self.ballsToOver(balls: (self.ballRemaining(ov: (fireBaseGlobalModel[CurrentMatch].to)!, iov: (fireBaseGlobalModel[CurrentMatch].i1?.iov)!)))
                    cell1.lbl_test_rem_ovr.text = self.ballsToOver(balls: (self.ballRemaining(ov: (fireBaseGlobalModel[CurrentMatch].to)!, iov: iover)))
                    cell1.lbl_RRR.text = fireBaseGlobalModel[CurrentMatch].day
                }
                cell1.lbl_runNLabel.text =  "Run Rate:"
                let inning1 = fireBaseGlobalModel[CurrentMatch].i1!
                var currentBalls = "\(self.balls(str: (fireBaseGlobalModel[CurrentMatch].i1?.ov)!))" as NSString
                let battingScore : NSString = (inning1.sc as? NSString)!
                let batScore : Double = Double(NSInteger(battingScore.longLongValue))
                let curBalls : Double = Double(NSInteger(currentBalls.longLongValue))
                let RunRate : Double = Double(batScore/curBalls)
                if(RunRate.isNaN){
                    cell1.lbl_runNeeded.text = "0.00"
                }
                else if (RunRate.isInfinite)
                {
                    cell1.lbl_runNeeded.text = "0.00"
                    
                }
                else{
                    cell1.lbl_runNeeded.text = String(format: "%.2f", RunRate*6)
                    
                }
                /*let key = inning1.bt as? String
                var teamName = String()
                if key == "t1"
                {
                    teamName = (fireBaseGlobalModel[CurrentMatch].t1?.n)!
                }
                else
                {
                    teamName = (fireBaseGlobalModel[CurrentMatch].t2?.n)!
                }*/
                let key = fireBaseGlobalModel[CurrentMatch].i1b
                var teamName = String()
                if key == "t1"
                {
                    teamName = (fireBaseGlobalModel[CurrentMatch].t1?.n)!
                }
                else
                {
                    teamName = (fireBaseGlobalModel[CurrentMatch].t2?.n)!
                }
                if let battingTeam : String = teamName{
                    
                    cell.TeamOneName.text = fireBaseGlobalModel[CurrentMatch].con?.mstus != "U" ? battingTeam : ""
                }
                else{
                    cell.TeamOneName.text = "N/A"
                }
                
                if let battingOver : String = inning1.ov as? String{
                   // let battingTotalOver : String = (inning1.iov as? String)!
                    var battingTotalOver : String = (fireBaseGlobalModel[CurrentMatch].iov ?? "")
                    if battingTotalOver.isEmpty{
                        battingTotalOver = "0"
                    }
                    if key == "0"
                    {
                        cell.TeamOneOvers.text = ""
                    }
                    else{
                        if fireBaseGlobalModel[CurrentMatch].con?.mstus == "U"{
                            cell.TeamOneOvers.text = ""
                        }
                        else{
                            cell.TeamOneOvers.text = "(\(battingOver))"
                        }
                    }
                }
                else{
                    cell.TeamOneOvers.text = "-"
                }
                if let battingScore : String = inning1.sc as? String{
                    if let battingWickets : NSString = inning1.wk as? NSString{
                        if battingScore != "NaN"
                        {
                            if key == "0"
                                
                            {
                                cell.TeamOneScore.text = ""
                            }
                            else
                            {
                                if fireBaseGlobalModel[CurrentMatch].con?.mstus == "U"{
                                    cell.TeamOneScore.text = ""
                                }else{
                                    
                                    cell.TeamOneScore.text =   battingScore + String("-") + (battingWickets as String)
                                }
                            }
                        }
                        else
                        {
                            if fireBaseGlobalModel[CurrentMatch].con?.mstus == "U"{
                                cell.TeamOneScore.text = ""
                            }else{
                                cell.TeamOneScore.text =   String("0") + String("-") + (battingWickets as String)
                            }
                        }
                    }
                    else{
                        if fireBaseGlobalModel[CurrentMatch].con?.mstus == "U"{
                            cell.TeamOneScore.text = ""
                        }else{
                            cell.TeamOneScore.text = battingScore
                        }
                    }
                }
                else{
                    cell.TeamOneScore.text = "-"
                }
            }
        }
    }
    @objc func FirInning2()
    {
        if isCellVisible(row:0) && isCellVisible(row:1)
        {
            let cell = self.tv_watchLive_LiveScore.cellForRow(at: IndexPath(row: 0, section: 0)) as! TvCell
            let cell1 = self.tv_watchLive_LiveScore.cellForRow(at: IndexPath(row: 1, section: 0)) as! CurrentRunRateCell
            let config = fireBaseGlobalModel[CurrentMatch].con
            let matchFormat = config?.mf
            if matchFormat != "Test"
            {
                if fireBaseGlobalModel[CurrentMatch].i == "i2"
                {
                    self.tv_watchLive_LiveScore.reloadRows(at:[IndexPath(row: 1, section: 0)] , with: .none)

                    cell1.lbl_RRRLabel.text =  "Balls Rem:"
                    //cell1.lbl_RRR.text = "\(self.ballRemaining(ov: (fireBaseGlobalModel[CurrentMatch].i2?.ov)!, iov: (fireBaseGlobalModel[CurrentMatch].i2?.iov)!))"
                    var iover = (fireBaseGlobalModel[CurrentMatch].iov ?? "")
                    if iover.isEmpty{
                        iover = "0"
                    }
                    cell1.lbl_RRR.text = "\(self.ballRemaining(ov: (fireBaseGlobalModel[CurrentMatch].i2?.ov)!, iov: iover))"
                    cell.TeamTwoOver.isHidden = false
                    cell.TeamTwoScore.isHidden = false
                    cell.TeamTwoName.isHidden = false
                    cell1.lbl_scoreSeparator.isHidden = false
                    cell1.secondInningsView.isHidden = false
                    cell1.lbl_targetLabel.isHidden = false
                    cell1.lbl_runNLabel.isHidden = false
                    cell1.lbl_RRRLabel.isHidden = false
                    cell1.lbl_BallRLable.isHidden = false
                    cell1.lbl_target.isHidden = false
                    cell1.lbl_runNeeded.isHidden = false
                    cell1.lbl_RRR.isHidden = false
                    cell1.lbl_ballR.isHidden = false
                    cell1.middleView.isHidden = true
                    cell1.lbl_BallRLable.text = "R.R.R:"
                    let inning2 = fireBaseGlobalModel[CurrentMatch].i2
                    if let target = inning2?.tr{
                        cell1.lbl_targetLabel.text =  "Target:"
                        cell1.lbl_target.text = target
                    }
                    else{
                        cell1.lbl_targetLabel.text =  "Target:"
                        cell1.lbl_target.text = "-"
                    }
                    var targetS:NSString = (inning2?.tr as? NSString)!
                    if targetS == ""
                    {
                        targetS = "0"
                    }
                    let bowlingScoreS : NSString = (inning2?.sc as? NSString)!
                    let tg : Double = Double(NSInteger(targetS.longLongValue))
                    let bs : Double = Double(NSInteger(bowlingScoreS.longLongValue))
                    let remainingRuns : Double = tg - bs
                    //let remainingBalls : Double = Double(ballRemaining(ov:fireBaseGlobalModel[CurrentMatch].i2!.ov!,iov:fireBaseGlobalModel[CurrentMatch].i2!.iov!))
                    let remainingBalls : Double = Double(ballRemaining(ov:fireBaseGlobalModel[CurrentMatch].i2!.ov!,iov:iover))
                    let rrr : Double = Double(remainingRuns/remainingBalls)
                    if(rrr.isNaN){
                    }
                    else if (rrr < 0)
                    {
                        cell1.lbl_ballR.text  = "-"
                    }
                    else if (rrr.isInfinite)
                    {
                        cell1.lbl_ballR.text  = "-"
                    }
                    else
                    {
                        cell1.lbl_ballR.text = String(format: "%.2f", rrr*6)
                    }
                    let target = inning2?.tr
                    let bowlingScore = inning2?.sc
                    if let runs = inning2?.sc as? NSString
                    {
                        cell1.lbl_runNLabel.text =  "Run Needed:"
                        if bowlingScore != "NaN"
                        {
                            if (Int(target!)! - Int(bowlingScore!)!) < 0
                            {
                                cell1.lbl_runNeeded.text = "- "
                                
                            }
                            else{
                                cell1.lbl_runNeeded.text = String(Int((target!))! - Int(bowlingScore!)!)
                                
                            }
                        }
                        else
                        {
                            cell1.lbl_runNeeded.text = "- "
                        }
                    }
                    else{
                        cell1.lbl_runNLabel.text =  "Run Needed:"
                        
                        cell1.lbl_runNeeded.text = "- "
                    }
                    
                    // MARK:  Team Status - Bowling Team
                    cell1.lbl_CRR.text =  "C.R.R:"
                    let currentBalls = "\(self.balls(str: (fireBaseGlobalModel[CurrentMatch].i2?.ov)!))" as NSString
                    let battingScore : NSString = (inning2?.sc as NSString?)!
                    let batScore : Double = Double(NSInteger(battingScore.longLongValue))
                    let curBalls : Double = Double(NSInteger(currentBalls.longLongValue))
                    let RunRate : Double = Double(batScore/curBalls)
                    if(RunRate.isNaN){
                        cell1.lbl_CRRValue.text = "0.00"
                    }
                    else if (RunRate.isInfinite)
                    {
                        cell1.lbl_CRRValue.text = "0.00"
                        
                    }
                    else{
                        cell1.lbl_CRRValue.text = String(format: "%.2f", RunRate*6)
                        
                    }
                    
                    if isCellVisible(row:2)
                    {
                        if let cell2 = self.tv_watchLive_LiveScore.cellForRow(at: IndexPath(row: 2, section: 0)) as? MatchRateCell
                        {
                            self.updateRunX(cell:cell2)
                        }
                    }
                    
                }
            }
            else
            {
                
                let inning : NSString = fireBaseGlobalModel[CurrentMatch].i! as NSString
                if (inning.isEqual(to: "i2"))
                {
                    //self.tv_watchLive_LiveScore.reloadRows(at:[IndexPath(row: 1, section: 0)] , with: .none)

                    if isCellVisible(row:2)
                    {
                        if let cell2 = self.tv_watchLive_LiveScore.cellForRow(at: IndexPath(row: 2, section: 0)) as? MatchRateCell
                        {
                            self.updateRunX(cell:cell2)
                        }
                    }
                    cell1.secondInningsView.isHidden = true
                    cell1.lbl_targetLabel.isHidden = true
                    cell1.lbl_BallRLable.isHidden = true
                    cell1.lbl_target.isHidden = true
                    cell1.lbl_ballR.isHidden = true
                    cell1.middleView.isHidden = false
                    cell1.lbl_rem_ovr.text = "Over Rem:"
//                    cell1.lbl_test_rem_ovr.text = self.ballsToOver(balls: self.ballRemaining(ov: (fireBaseGlobalModel[CurrentMatch].to)!, iov: (fireBaseGlobalModel[CurrentMatch].i2?.iov)!))
                    var iover = (fireBaseGlobalModel[CurrentMatch].iov ?? "")
                    if iover.isEmpty{
                        iover = "0"
                    }
                    cell1.lbl_test_rem_ovr.text = self.ballsToOver(balls: self.ballRemaining(ov: (fireBaseGlobalModel[CurrentMatch].to)!, iov: iover))
                    var inning2 = fireBaseGlobalModel[CurrentMatch].i2
                    var inning1 = fireBaseGlobalModel[CurrentMatch].i1
                    let inning1score = Int(inning1?.sc as! String)
                    let inning2score = Int(inning2?.sc as! String)
                    if inning1score! > inning2score!
                    {
                        cell1.lbl_runNLabel.text = "Trailing By:"
                        cell1.lbl_runNeeded.text = "\(abs(inning1score!-inning2score!))"
                        
                    }
                    else
                    {
                        cell1.lbl_runNLabel.text = "Leading By:"
                        cell1.lbl_runNeeded.text = "\(abs(inning2score!-inning1score!))"
                    }
                    if let day = fireBaseGlobalModel[CurrentMatch].day
                    {
                        cell1.lbl_RRR.text = fireBaseGlobalModel[CurrentMatch].day
                    }
                    else{
                        cell1.lbl_RRR.text = fireBaseGlobalModel[CurrentMatch].day
                    }
                    cell1.lbl_RRRLabel.text = "Day:"
                }
                
            }
            let inning : NSString = fireBaseGlobalModel[CurrentMatch].i! as NSString
            if (inning.isEqual(to: "i2"))
            {
                cell.TeamOneCurOver.text = ""
                cell.TeamTwoScore.isHidden = false
                cell.TeamTwoOver.isHidden = false
                cell.TeamTwoName.isHidden = false
                var inning2 = fireBaseGlobalModel[CurrentMatch].i2
                var inning1 = fireBaseGlobalModel[CurrentMatch].i1
                var teamName = String()
                /*let key = inning2?.bt as? String
                if key == "t1"
                {
                    teamName = (fireBaseGlobalModel[CurrentMatch].t1?.n)!
                }
                else
                {
                    teamName = (fireBaseGlobalModel[CurrentMatch].t2?.n)!
                }*/
                let key = fireBaseGlobalModel[CurrentMatch].i1b
                if key == "t2"
                {
                    teamName = (fireBaseGlobalModel[CurrentMatch].t1?.n)!
                }
                else
                {
                    teamName = (fireBaseGlobalModel[CurrentMatch].t2?.n)!
                }
                if let bowlingTeam : String = teamName{
                    cell.TeamOneName.text = bowlingTeam
                }
                else{
                    cell.TeamOneName.text = "N/A"
                }
                
                if let bowlingOver : String = inning2?.ov as? String{
                    cell.TeamOneOvers.text = "(\(bowlingOver))"// + bowlingTotalOver
                }
                else{
                    cell.TeamOneOvers.text = "-"
                }
                if let bowlingScore : String = inning2?.sc as? String{
                    if let bowlingWickets : NSString =  inning2?.wk as? NSString{
                        cell.TeamOneScore.text =  bowlingScore  + String("/") + (bowlingWickets as String)
                    }
                    else
                    {
                        cell.TeamOneScore.text = bowlingScore
                    }
                }
                else{
                    cell.TeamOneScore.text = "-"
                }
                
                
                /*let key1 = inning2?.bwlt as? String
                var teamName1 =  String()
                teamName1 = key1 == "t1" ? (fireBaseGlobalModel[CurrentMatch].t1?.n)! : (fireBaseGlobalModel[CurrentMatch].t2?.n)!*/
                let key1 = fireBaseGlobalModel[CurrentMatch].i1b
                var teamName1 =  String()
                teamName1 = key1 == "t1" ? (fireBaseGlobalModel[CurrentMatch].t1?.n)! : (fireBaseGlobalModel[CurrentMatch].t2?.n)!
                if let bowlingTeam1 : String = teamName1{
                    cell.TeamTwoName.text = bowlingTeam1
                    
                }
                if let bowlingOver : String = inning1?.ov as? String{
                    cell.TeamTwoOver.text = "(\( bowlingOver))"// + bowlingTotalOver
                }
                else{
                    cell.TeamTwoOver.text = "-"
                }
                if let bowlingScore1 : String = inning1?.sc as? String{
                    if let bowlingWickets : NSString =  inning1?.wk as? NSString{
                        cell.TeamTwoScore.text =  bowlingScore1  + String("/") + (bowlingWickets as String)
                    }
                    else
                    {
                        
                        cell.TeamTwoScore.text = bowlingScore1
                    }
                }
                else{
                    cell.TeamTwoScore.text = "-"
                }
            }
        }
    }
    
    @objc func FirInning3()
    {
        if isCellVisible(row:0) && isCellVisible(row:1)
        {
            let cell = self.tv_watchLive_LiveScore.cellForRow(at: IndexPath(row: 0, section: 0)) as! TvCell
            let cell1 = self.tv_watchLive_LiveScore.cellForRow(at: IndexPath(row: 1, section: 0)) as! CurrentRunRateCell
            if fireBaseGlobalModel[CurrentMatch].con?.mf == "Test" && fireBaseGlobalModel[CurrentMatch].i == "i3"
            {
                if isCellVisible(row:2)
                {
                    if let cell2 = self.tv_watchLive_LiveScore.cellForRow(at: IndexPath(row: 2, section: 0)) as? MatchRateCell
                    {
                        self.updateRunX(cell:cell2)
                    }
                }
                cell1.secondInningsView.isHidden = true
                cell1.lbl_targetLabel.isHidden = true
                cell1.lbl_BallRLable.isHidden = true
                cell1.lbl_target.isHidden = true
                cell1.lbl_ballR.isHidden = true
                cell1.middleView.isHidden = false
                cell1.lbl_rem_ovr.text = "Over Rem:"
                //cell1.lbl_test_rem_ovr.text = self.ballsToOver(balls: self.ballRemaining(ov: (fireBaseGlobalModel[CurrentMatch].to)!, iov: (fireBaseGlobalModel[CurrentMatch].i3?.iov)!))
                var iover = (fireBaseGlobalModel[CurrentMatch].iov ?? "")
                if iover.isEmpty{
                    iover = "0"
                }
                cell1.lbl_test_rem_ovr.text = self.ballsToOver(balls: self.ballRemaining(ov: (fireBaseGlobalModel[CurrentMatch].to)!, iov: iover))
                var inning2 = fireBaseGlobalModel[CurrentMatch].i2
                var inning1 = fireBaseGlobalModel[CurrentMatch].i1
                var inning3 = fireBaseGlobalModel[CurrentMatch].i3
                var FollowOn = Bool()
                let inning1score = Int((inning1?.sc)!)
                let inning2score = Int((inning2?.sc)!)
                let inning3score = Int((inning3?.sc)!)
                var combineScore1 = Int()
                var combineScore2 = Int()
                /*if inning2?.bt == inning3?.bt
                {
                    FollowOn = true
                    combineScore2 = inning2score! + inning3score!
                    combineScore1 = inning1score!
                }*/
                if fireBaseGlobalModel[CurrentMatch].i3b == "t2"
                {
                    FollowOn = true
                    combineScore2 = inning2score! + inning3score!
                    combineScore1 = inning1score!
                }
                else
                {
                    FollowOn = false
                    combineScore1 = inning1score! + inning3score!
                    combineScore2 = inning2score!
                }
                if FollowOn == true
                {
                    if combineScore1 > combineScore2
                    {
                        cell1.lbl_runNLabel.text = "Trailing By:"
                        cell1.lbl_runNeeded.text = "\(abs(combineScore1-combineScore2))"
                        
                    }
                    else
                    {
                        cell1.lbl_runNLabel.text = "Leading By:"
                        cell1.lbl_runNeeded.text = "\(abs(combineScore2-combineScore1))"
                    }
                }
                else
                {
                    if combineScore1 < combineScore2
                    {
                        cell1.lbl_runNLabel.text = "Trailing By:"
                        cell1.lbl_runNeeded.text = "\(abs(combineScore2-combineScore1))"
                    }
                    else
                    {
                        cell1.lbl_runNLabel.text = "Leading By:"
                        cell1.lbl_runNeeded.text = "\(abs(combineScore1-combineScore2))"
                    }
                }
                cell1.lbl_RRR.text = fireBaseGlobalModel[CurrentMatch].day
                cell1.lbl_RRRLabel.text = "Day:"
                if FollowOn == true
                {
                    var teamName = String()
                    /*let key = inning2?.bt as? String
                    if key == "t1"
                    {
                        teamName = (fireBaseGlobalModel[CurrentMatch].t1?.n)!
                    }
                    else
                    {
                        teamName = (fireBaseGlobalModel[CurrentMatch].t2?.n)!
                    }*/
                    let key = fireBaseGlobalModel[CurrentMatch].i1b
                    if key == "t2"
                    {
                        teamName = (fireBaseGlobalModel[CurrentMatch].t1?.n)!
                    }
                    else
                    {
                        teamName = (fireBaseGlobalModel[CurrentMatch].t2?.n)!
                    }
                    if let bowlingTeam : String = teamName{
                        cell.TeamOneName.text = bowlingTeam
                    }
                    else{
                        cell.TeamOneName.text = "N/A"
                    }
                    
                    cell.TeamOneOvers.text = "& \(inning2score!)/\((inning2?.wk)!)"// + bowlingTotalOver
                    if let bowlingScore : String = inning3?.sc{
                        if let bowlingWickets =  inning3?.wk{
                            cell.TeamOneScore.text =  bowlingScore  + String("/") + (bowlingWickets)
                        }
                        else
                        {
                            
                            cell.TeamOneScore.text = bowlingScore
                        }
                    }
                    else{
                        cell.TeamOneScore.text = "-"
                    }
                    
                    if let currentOvr  = inning3?.ov{
                        cell.TeamOneCurOver.text = "(\(currentOvr))"
                    }
                    else{
                        cell.TeamOneCurOver.text = ""
                    }
                    
                    var teamName1 = String()
                    /*let key1 = inning2?.bwlt as? String
                    if key1 == "t1"
                    {
                        teamName1 = (fireBaseGlobalModel[CurrentMatch].t1?.n)!
                    }
                    else
                    {
                        teamName1 = (fireBaseGlobalModel[CurrentMatch].t2?.n)!
                    }*/
                    let key1 = fireBaseGlobalModel[CurrentMatch].i1b
                    if key1 == "t1"
                    {
                        teamName1 = (fireBaseGlobalModel[CurrentMatch].t1?.n)!
                    }
                    else
                    {
                        teamName1 = (fireBaseGlobalModel[CurrentMatch].t2?.n)!
                    }
                    if let bowlingTeam1 : String = teamName1{
                        cell.TeamTwoName.text = bowlingTeam1
                    }
                    if let _ : String = inning1?.ov as? String{
                        cell.TeamTwoOver.text = ""//"(\( bowlingOver))"// + bowlingTotalOver
                    }
                    else{
                        cell.TeamTwoOver.text = "-"
                    }
                    if let bowlingScore1 : String = inning1?.sc as? String{
                        if let bowlingWickets : NSString =  inning1?.wk as? NSString{
                            cell.TeamTwoScore.text =  bowlingScore1  + String("/") + (bowlingWickets as String)
                        }
                        else
                        {
                            
                            cell.TeamTwoScore.text = bowlingScore1
                        }
                    }
                    else{
                        cell.TeamTwoScore.text = "-"
                    }
                    
                }
                else
                {
                    
                    var teamName = String()
                    /*let key = inning3?.bt as? String
                    if key == "t1"
                    {
                        teamName = (fireBaseGlobalModel[CurrentMatch].t1?.n)!
                    }
                    else
                    {
                        teamName = (fireBaseGlobalModel[CurrentMatch].t2?.n)!
                    }*/
                    let key = fireBaseGlobalModel[CurrentMatch].i3b
                    if key == "t1"
                    {
                        teamName = (fireBaseGlobalModel[CurrentMatch].t1?.n)!
                    }
                    else
                    {
                        teamName = (fireBaseGlobalModel[CurrentMatch].t2?.n)!
                    }
                    if let bowlingTeam : String = teamName{
                        cell.TeamOneName.text = bowlingTeam
                    }
                    else{
                        cell.TeamOneName.text = "N/A"
                    }
                    cell.TeamOneOvers.text = " & \(inning1score!)/\((inning1?.wk as? String)!)"// + bowlingTotalOver
                    
                    if let bowlingScore : String = inning3?.sc as? String{
                        if let bowlingWickets : NSString =  inning3?.wk as? NSString{
                            cell.TeamOneScore.text =  bowlingScore  + String("/") + (bowlingWickets as String)
                        }
                        else
                        {
                            
                            cell.TeamOneScore.text = bowlingScore
                        }
                    }
                    else{
                        cell.TeamOneScore.text = "-"
                    }
                    
                    if let currentOvr  = inning3?.ov{
                        cell.TeamOneCurOver.text = "(\(currentOvr))"
                    }
                    else{
                        cell.TeamOneCurOver.text = ""
                    }
                    
                    var teamName1 = String()
                    /*let key1 = inning3?.bwlt as? String
                    if key1 == "t1"
                    {
                        teamName1 = (fireBaseGlobalModel[CurrentMatch].t1?.n)!
                    }
                    else
                    {
                        teamName1 = (fireBaseGlobalModel[CurrentMatch].t2?.n)!
                    }*/
                    let key1 = fireBaseGlobalModel[CurrentMatch].i3b
                    if key1 == "t2"
                    {
                        teamName1 = (fireBaseGlobalModel[CurrentMatch].t1?.n)!
                    }
                    else
                    {
                        teamName1 = (fireBaseGlobalModel[CurrentMatch].t2?.n)!
                    }
                    if let bowlingTeam1 : String = teamName1{
                        cell.TeamTwoName.text = bowlingTeam1
                        
                    }
                    if let _ : String = inning1?.ov as? String{
                        cell.TeamTwoOver.text = ""//"(\( bowlingOver))"// + bowlingTotalOver
                    }
                    else{
                        cell.TeamTwoOver.text = "-"
                    }
                    if let bowlingScore1 : String = inning2?.sc as? String{
                        if let bowlingWickets : NSString =  inning2?.wk as? NSString{
                            cell.TeamTwoScore.text =  bowlingScore1  + String("/") + (bowlingWickets as String)
                        }
                        else
                        {
                            
                            cell.TeamTwoScore.text = bowlingScore1
                        }
                    }
                    else{
                        cell.TeamTwoScore.text = "-"
                    }
                    
                }
                cell.layoutIfNeeded()
                
            }
        }
    }
    @objc func FirInning4()
    {
        if isCellVisible(row:0) && isCellVisible(row:1)
        {
            let cell = self.tv_watchLive_LiveScore.cellForRow(at: IndexPath(row: 0, section: 0)) as! TvCell
            let cell1 = self.tv_watchLive_LiveScore.cellForRow(at: IndexPath(row: 1, section: 0)) as! CurrentRunRateCell
            if fireBaseGlobalModel[CurrentMatch].con?.mf == "Test" && fireBaseGlobalModel[CurrentMatch].i == "i4"
            {
                if isCellVisible(row:2)
                {
                    if let cell2 = self.tv_watchLive_LiveScore.cellForRow(at: IndexPath(row: 2, section: 0)) as? MatchRateCell
                    {
                        self.updateRunX(cell:cell2)
                    }
                }
                cell1.secondInningsView.isHidden = true
                cell1.lbl_targetLabel.isHidden = true
                cell1.lbl_BallRLable.isHidden = true
                cell1.lbl_target.isHidden = true
                cell1.lbl_ballR.isHidden = true
                cell1.middleView.isHidden = false
                cell1.lbl_rem_ovr.text = "Over Rem:"
                //cell1.lbl_test_rem_ovr.text = self.ballsToOver(balls: self.ballRemaining(ov: (fireBaseGlobalModel[CurrentMatch].to)!, iov: (fireBaseGlobalModel[CurrentMatch].i4?.iov)!))
                var iover = (fireBaseGlobalModel[CurrentMatch].iov ?? "")
                if iover.isEmpty{
                    iover = "0"
                }
                cell1.lbl_test_rem_ovr.text = self.ballsToOver(balls: self.ballRemaining(ov: (fireBaseGlobalModel[CurrentMatch].to)!, iov: iover))
                let inning1 = fireBaseGlobalModel[CurrentMatch].i1
                let inning2 = fireBaseGlobalModel[CurrentMatch].i2
                let inning3 = fireBaseGlobalModel[CurrentMatch].i3
                let inning4 = fireBaseGlobalModel[CurrentMatch].i4
                var followOn = Bool()
                
                let inning1score = Int((inning1?.sc)!)
                let inning2score = Int((inning2?.sc)!)
                let inning3score = Int((inning3?.sc)!)
                _ = Int((inning4?.sc)!)
                
                var combineScore1 = Int()
                var combineScore2 = Int()
                
                /*if inning2?.bt == inning3?.bt
                {
                    followOn = true
                    combineScore2 = inning2score! + inning3score!
                    combineScore1 = inning1score!
                    
                }*/
                if fireBaseGlobalModel[CurrentMatch].i3b == "t2"
                {
                    followOn = true
                    combineScore2 = inning2score! + inning3score!
                    combineScore1 = inning1score!
                    
                }
                else
                {
                    followOn = false
                    combineScore2 = inning2score!
                    combineScore1 = inning1score! + inning3score!
                }
                
                if combineScore1 > combineScore2
                {
                    cell1.lbl_runNLabel.text = "Target:"
                    cell1.lbl_runNeeded.text = "\(abs(combineScore1-combineScore2)+1)"
                    
                }
                else
                {
                    cell1.lbl_runNLabel.text = "Target:"
                    cell1.lbl_runNeeded.text = "\(abs(combineScore2-combineScore1)+1)"
                }
                cell1.lbl_RRR.text = fireBaseGlobalModel[CurrentMatch].day
                cell1.lbl_RRRLabel.text = "Day:"
                if followOn == true
                {
                    var teamName = String()
                    /*let key = inning4?.bt as? String
                    if key == "t1"
                    {
                        teamName = (fireBaseGlobalModel[CurrentMatch].t1?.n)!
                    }
                    else
                    {
                        teamName = (fireBaseGlobalModel[CurrentMatch].t2?.n)!
                    }*/
                    let key = fireBaseGlobalModel[CurrentMatch].i3b
                    if key == "t2"
                    {
                        teamName = (fireBaseGlobalModel[CurrentMatch].t1?.n)!
                    }
                    else
                    {
                        teamName = (fireBaseGlobalModel[CurrentMatch].t2?.n)!
                    }
                    if let bowlingTeam = teamName as? String{
                        cell.TeamOneName.text = bowlingTeam
                    }
                    else{
                        cell.TeamOneName.text = "N/A"
                    }
                    cell.TeamOneOvers.text = "& \(inning1score!)/\((inning1?.wk as? String)!)"// + bowlingTotalOver
                    if let bowlingScore : String = inning4?.sc as? String{
                        if let bowlingWickets : NSString =  inning4?.wk as? NSString{
                            cell.TeamOneScore.text =  bowlingScore  + String("/") + (bowlingWickets as String)
                        }
                        else
                        {
                            
                            cell.TeamOneScore.text = bowlingScore
                        }
                    }
                    else{
                        cell.TeamOneScore.text = "-"
                    }
                    if let currentOvr  = inning4?.ov{
                        cell.TeamOneCurOver.text = "(\(currentOvr))"
                    }
                    else{
                        cell.TeamOneCurOver.text = ""
                    }
                    
                    var teamName1 = String()
                    /*let key1 = inning4?.bwlt as? String
                    if key1 == "t1"
                    {
                        teamName1 = (fireBaseGlobalModel[CurrentMatch].t1?.n)!
                    }
                    else
                    {
                        teamName1 = (fireBaseGlobalModel[CurrentMatch].t2?.n)!
                    }*/
                    let key1 = fireBaseGlobalModel[CurrentMatch].i3b
                    if key1 == "t1"
                    {
                        teamName1 = (fireBaseGlobalModel[CurrentMatch].t1?.n)!
                    }
                    else
                    {
                        teamName1 = (fireBaseGlobalModel[CurrentMatch].t2?.n)!
                    }
                    if let bowlingTeam1 = teamName1 as? String{
                        cell.TeamTwoName.text = bowlingTeam1
                        
                    }
                    if let _ : String = inning1?.ov as? String{
                        cell.TeamTwoOver.text = "&\( inning2score!)/\((inning2?.wk as? String)!)"// + bowlingTotalOver
                    }
                    else{
                        cell.TeamTwoOver.text = "-"
                    }
                    if let bowlingScore1 : String = inning3?.sc as? String{
                        if let bowlingWickets : NSString =  inning3?.wk as? NSString{
                            cell.TeamTwoScore.text =  bowlingScore1  + String("/") + (bowlingWickets as String)
                        }
                        else
                        {
                            
                            cell.TeamTwoScore.text = bowlingScore1
                        }
                    }
                    else{
                        cell.TeamTwoScore.text = "-"
                    }
                    
                }
                else
                {
                    
                    var teamName = String()
                    /*let key = inning4?.bt as? String
                    if key == "t1"
                    {
                        teamName = (fireBaseGlobalModel[CurrentMatch].t1?.n)!
                    }
                    else
                    {
                        teamName = (fireBaseGlobalModel[CurrentMatch].t2?.n)!
                    }*/
                    let key = fireBaseGlobalModel[CurrentMatch].i3b
                    if key == "t2"
                    {
                        teamName = (fireBaseGlobalModel[CurrentMatch].t1?.n)!
                    }
                    else
                    {
                        teamName = (fireBaseGlobalModel[CurrentMatch].t2?.n)!
                    }
                    if let bowlingTeam = teamName as? String{
                        cell.TeamOneName.text = bowlingTeam
                    }
                    else{
                        cell.TeamOneName.text = "N/A"
                    }
                    
                    if let _ : String = inning2?.ov as? String{
                        cell.TeamOneOvers.text = "(\(inning2score!)/\((inning2?.wk as? String)!))"// + bowlingTotalOver
                    }
                    else{
                        cell.TeamOneOvers.text = "-"
                    }
                    if let bowlingScore : String = inning4?.sc as? String{
                        if let bowlingWickets : NSString =  inning4?.wk as? NSString{
                            cell.TeamOneScore.text =  bowlingScore  + String("/") + (bowlingWickets as String)
                        }
                        else
                        {
                            cell.TeamOneScore.text = bowlingScore
                        }
                    }
                    else{
                        cell.TeamOneScore.text = "-"
                    }
                    if let currentOvr  = inning4?.ov{
                        cell.TeamOneCurOver.text = "(\(currentOvr))"
                    }
                    else{
                        cell.TeamOneCurOver.text = ""
                    }
                    
                    var teamName1 = String()
                    /*let key1 = inning4?.bwlt as? String
                    if key1 == "t1"
                    {
                        teamName1 = (fireBaseGlobalModel[CurrentMatch].t1?.n)!
                    }
                    else
                    {
                        teamName1 = (fireBaseGlobalModel[CurrentMatch].t2?.n)!
                    }*/
                    let key1 = fireBaseGlobalModel[CurrentMatch].i3b
                    if key1 == "t1"
                    {
                        teamName1 = (fireBaseGlobalModel[CurrentMatch].t1?.n)!
                    }
                    else
                    {
                        teamName1 = (fireBaseGlobalModel[CurrentMatch].t2?.n)!
                    }
                    if let bowlingTeam1 = teamName1 as? String{
                        cell.TeamTwoName.text = bowlingTeam1
                        
                    }
                    if let _ : String = inning1?.ov as? String{
                        cell.TeamTwoOver.text = "(\( inning1score!)/\((inning1?.wk as? String)!))"// + bowlingTotalOver
                    }
                    else{
                        cell.TeamTwoOver.text = "-"
                    }
                    if let bowlingScore1 : String = inning3?.sc as? String{
                        if let bowlingWickets : NSString =  inning3?.wk as? NSString{
                            cell.TeamTwoScore.text =  bowlingScore1  + String("/") + (bowlingWickets as String)
                        }
                        else
                        {
                            cell.TeamTwoScore.text = bowlingScore1
                        }
                    }
                    else{
                        cell.TeamTwoScore.text = "-"
                    }
                }
                cell.layoutIfNeeded()
            }
        }
    }
    func tvGiffAnimation(image:UIImageView,arrImg:[UIImage],duration:TimeInterval,RepeatCount:Int)
    {
        image.animationImages = arrImg
        image.animationDuration = duration
        image.animationRepeatCount = RepeatCount
        image.startAnimating()
    }
    func isCellVisible(row:Int) -> Bool
    {
        let currentVisibleCells = self.tv_watchLive_LiveScore.visibleCells
        for VisibleCell in currentVisibleCells
        {
            if tv_watchLive_LiveScore.indexPath(for: VisibleCell) == IndexPath(row: row, section: 0)
            {
                return true
            }
        }
        return false
    }
    @objc func refreshPlayerScoreCell()
    {
        /*if isCellVisible(row:3)
        {
            tv_watchLive_LiveScore.reloadRows(at: [IndexPath(row: 3, section: 0)], with: .none)
        }*/
        if let cell = tv_watchLive_LiveScore.cellForRow(at: IndexPath(row: 3, section: 0)) as? PlayersScoreCell
        {
            self.setPlayerScoreCell(cell: cell)
        }
    }
    @objc func refreshLastBallScore()
    {
        /*if isCellVisible(row:4)
        {
            tv_watchLive_LiveScore.reloadRows(at: [IndexPath(row: 4, section: 0)], with: .none)
        }*/
        if let cell = tv_watchLive_LiveScore.cellForRow(at: IndexPath(row: 4, section: 0)) as? LastBallScore
        {
            self.setLastBallScore(cell: cell)
            
        }
    }
//    @objc func refreshMatchRateTextCell()
//    {
//        if isCellVisible(row:5)
//        {
//            tv_watchLive_LiveScore.reloadRows(at: [IndexPath(row: 5, section: 0)], with: UITableViewRowAnimation.none)
//        }
//    }
    @objc func refreshMatchRateTextCell()
    {
        if isCellVisible(row:7)
        {
            tv_watchLive_LiveScore.reloadRows(at: [IndexPath(row: 7, section: 0)], with: UITableViewRowAnimation.none)
        }
    }
    @objc func refreshProjectedScoreCell()
    {
        if isCellVisible(row: 6)
        {
            tv_watchLive_LiveScore.reloadRows(at: [IndexPath(row: 6, section: 0)], with: .none)
        }
        
    }
    @objc func refreshFavTeam()
    {
        if isCellVisible(row:2)
        {
            if let cell = tv_watchLive_LiveScore.cellForRow(at: IndexPath(row: 2, section: 0)) as? MatchRateCell
            {
                self.setFavouriteTeam(cell: cell)
            } 
        }
    }
    @objc func refreshMarketRate()
    {
        if isCellVisible(row:2)
        {
            if fireBaseGlobalModel[CurrentMatch].con?.mf != "Test"
            {
                if let cell = tv_watchLive_LiveScore.cellForRow(at: IndexPath(row: 2, section: 0)) as? MatchRateCell
                {
                    self.setMarketRate(cell: cell)
                }
            }
            else
            {
               if let cell = tv_watchLive_LiveScore.cellForRow(at: IndexPath(row: 2, section: 0)) as? TestMatchRateCell
               {
                    self.setTestMatchRate(cell: cell)
                }
            }
        }
    }
    @objc func refreshSessionSuspend()
    {
        if isCellVisible(row:2)
        {
            if let cell = tv_watchLive_LiveScore.cellForRow(at: IndexPath(row: 2, section: 0)) as? MatchRateCell
            {
                self.setSessionSuspend(cell: cell)
            }
        }
    }
    @objc func refreshSession()
    {
        if isCellVisible(row:2)
        {
            if let cell = tv_watchLive_LiveScore.cellForRow(at: IndexPath(row: 2, section: 0)) as? MatchRateCell
            {
                self.setSessionAndRunXball(cell: cell)
            }
        }
    }
    @objc func refreshMatchday()
    {
        if isCellVisible(row:1)
        {
            let cell = self.tv_watchLive_LiveScore.cellForRow(at: IndexPath(row: 1, section: 0)) as! CurrentRunRateCell
            let matchFormat : NSString = fireBaseGlobalModel[CurrentMatch].con!.mf! as NSString
            if matchFormat == "Test"
            {
                cell.lbl_RRR.text = fireBaseGlobalModel[CurrentMatch].day
            }
        }
    }
    @objc func refresh()
    {
        
    }
    @objc func refreshTV()
    {
        let matchFormat : NSString = fireBaseGlobalModel[CurrentMatch].con!.mf! as NSString
        if matchFormat != "Test"
        {
            self.tv_watchLive_LiveScore.reloadRows(at:[IndexPath(row: 1, section: 0)] , with: .none)
        }
        
        if isCellVisible(row:0)
        {
            let cell = self.tv_watchLive_LiveScore.cellForRow(at: IndexPath(row: 0, section: 0)) as! TvCell
            cell.lbl_msg.text = ""
            cell.lbl_runs.text =  ""
            cell.lbl_giffText.text = ""
            cell.lbl_other.text = ""
            cell.lbl_plus.text = ""
            cell.iv_4_6_giff.image = nil
            cell.tv_giff.image = nil
            cell.tv_giff.animationImages = nil
            cell.lbl_other.font = cell.lbl_other.font.withSize(27)
            cell.tv_giff.stopAnimating()
            cell.iv_4_6_giff.stopAnimating()
            timer.invalidate()
            if fireBaseGlobalModel[CurrentMatch].cs?.msg == "AIR"
            {
                cell.lbl_other.text = "IN AIR"
            }
            else if fireBaseGlobalModel[CurrentMatch].cs?.msg == "B"
            {
                self.voice(eng:"ball start",hin:"ball chalu ball")
                self.tvGiffAnimation(image: cell.tv_giff, arrImg: ballImgArr, duration: 2.0, RepeatCount: 0)
                cell.lbl_giffText.text =  "Ball"
                if UserDefault.userDefaultForAny(key: "AudioLanguage") as! String == "ENG"
                {
                    cell.lbl_runs.text =  "Start"
                }
                else
                {
                    cell.lbl_runs.text =  "Chalu"
                }
            }
            else if fireBaseGlobalModel[CurrentMatch].cs?.msg == "5"
            {
                cell.lbl_other.text = "5 runs"
            }
            else if fireBaseGlobalModel[CurrentMatch].cs?.msg == "V"
            {
                playTextToVoice()
            }
            else if fireBaseGlobalModel[CurrentMatch].cs?.msg == "3U"
            {
                cell.lbl_other.text = "3rd Umpire"
                self.voice(eng:"third empire",hin:"third umpire")
            }
            else if fireBaseGlobalModel[CurrentMatch].cs?.msg == "BR"
            {
                cell.lbl_other.text = "Innings Break"
            
            }
            else if fireBaseGlobalModel[CurrentMatch].cs?.msg == "DB"
            {
                cell.lbl_other.text = "Drinks Break"
            }
            else if fireBaseGlobalModel[CurrentMatch].cs?.msg == "FB"
            {
                cell.lbl_other.text = "Fast Bowler"
            }
            else if fireBaseGlobalModel[CurrentMatch].cs?.msg == "SB"
            {
                cell.lbl_other.text = "Spin Bowler"
            }
            else if fireBaseGlobalModel[CurrentMatch].cs?.msg == "NO"
            {
                cell.lbl_other.text = "Not Out"
            }
            else if fireBaseGlobalModel[CurrentMatch].cs?.msg == "OC"
            {
                cell.lbl_other.text = "Over Complete"
            }
            else if fireBaseGlobalModel[CurrentMatch].cs?.msg == "FH"
            {
                cell.lbl_other.text = "Free Hit"
            }
            else if fireBaseGlobalModel[CurrentMatch].cs?.msg == "PP"
            {
                cell.lbl_other.text = "Power Play"
            }
            else if (fireBaseGlobalModel[CurrentMatch].cs?.msg?.contains("BAT"))!
            {
                cell.lbl_plus.text = fireBaseGlobalModel[CurrentMatch].cs?.msg?.replacingOccurrences(of: "BAT", with: "")
                self.tvGiffAnimation(image: cell.tv_giff, arrImg: newBatsmenImgArr, duration: 2.0, RepeatCount: 0)
                timer.invalidate()
                timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(self.update(_:)), userInfo: ["image":#imageLiteral(resourceName: "f7"),"flag":"1"], repeats: false);
            }
            else if fireBaseGlobalModel[CurrentMatch].cs?.msg == "BS"
            {
                if UserDefault.userDefaultForAny(key: "AudioLanguage") as! String == "ENG"
                {
                    cell.lbl_other.text =  "Bowler Stop"
                }
                else
                {
                    cell.lbl_other.text =  "Bowler Ruka"
                }
            }
            else if fireBaseGlobalModel[CurrentMatch].cs?.msg == "PP"
            {
                cell.lbl_other.text = "Power Play"
            }
            else if fireBaseGlobalModel[CurrentMatch].cs?.msg == "FH"
            {
                cell.lbl_other.text = "Free Hit"
            }
            else if fireBaseGlobalModel[CurrentMatch].cs?.msg == "FB"
            {
                cell.lbl_other.text = "Fast Bowler"
            }
            else if fireBaseGlobalModel[CurrentMatch].cs?.msg == "SB"
            {
                cell.lbl_other.text = "Spin Bowler"
            }
            /*else if fireBaseGlobalModel[CurrentMatch].cs?.msg == "BWLS"
            {
                let name = fireBaseGlobalModel[CurrentMatch].bwl?.n!
                let run = fireBaseGlobalModel[CurrentMatch].bwl?.r!
                let over = fireBaseGlobalModel[CurrentMatch].bwl?.ov!
                let wicket = fireBaseGlobalModel[CurrentMatch].bwl?.w!
                cell.lbl_other.text = "\(name!)   \(run!)-\(over!)-\(wicket!)"
            }*/
            else if fireBaseGlobalModel[CurrentMatch].cs?.msg == "OC"
            {
                cell.lbl_other.text = "Over Complete"
            }
            else if fireBaseGlobalModel[CurrentMatch].cs?.msg == "WK"
            {
                self.voice(eng:"oh wicket",hin:"wicket")
                self.tvGiffAnimation(image: cell.tv_giff, arrImg: wicketImgArr, duration: 2.0, RepeatCount: 0)
                timer.invalidate()
                timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(self.update(_:)), userInfo: ["image":#imageLiteral(resourceName: "w5"),"flag":"1"], repeats: false);
                cell.lbl_giffText.text =  "WICKET"
            }
            else if fireBaseGlobalModel[CurrentMatch].cs?.msg == "WD"
            {
                self.voice(eng:"wide",hin:"wideHindi")
                self.tvGiffAnimation(image: cell.tv_giff, arrImg: wideImgArr, duration: 2.0, RepeatCount: 0)
                cell.iv_4_6_giff.image = nil
                
                timer.invalidate()
                timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(self.update(_:)), userInfo: ["image":#imageLiteral(resourceName: "wide7"),"flag":"1"], repeats: false);
                cell.lbl_giffText.text =  "Wide Ball"
            }
            else if fireBaseGlobalModel[CurrentMatch].cs?.msg == "NB"
            {
                self.voice(eng:"noball",hin:"noballHindi")
                self.tvGiffAnimation(image: cell.tv_giff, arrImg: noBallImgArr, duration: 2.0, RepeatCount: 0)
                cell.lbl_giffText.text =  "No Ball"
                timer.invalidate()
                timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(self.update(_:)), userInfo: ["image":#imageLiteral(resourceName: "nb7"),"flag":"1"], repeats: false);
            }
            else if ((fireBaseGlobalModel[CurrentMatch].cs?.msg)?.contains("WK+"))!
            {
                self.voice(eng:"oh wicket",hin:"wicket")
                self.tvGiffAnimation(image: cell.tv_giff, arrImg: wicketImgArr, duration: 2.0, RepeatCount: 0)
                timer.invalidate()
                timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(self.update(_:)), userInfo: ["image":#imageLiteral(resourceName: "w5"),"flag":"1"], repeats: false);
                cell.lbl_giffText.text =  "WICKET"
                let tempStr = ((fireBaseGlobalModel[CurrentMatch].cs?.msg)!.components(separatedBy: "+"))[1]
                
                let tempStr1 = ((fireBaseGlobalModel[CurrentMatch].cs?.msg)!.components(separatedBy: "+"))[1]
                if tempStr == "NB" || tempStr1 == "NB"
                {
                    cell.lbl_giffText.text = "Run Out"
                    cell.lbl_runs.text = "No ball"
                }
                else if tempStr == "WD" || tempStr1 == "WD"
                {
                    cell.lbl_runs.text = "Wide ball"
                }
                else
                {
                    cell.lbl_runs.text = "\(tempStr) Run"
                }
                cell.lbl_plus.text = "+"
            }
            else if ((fireBaseGlobalModel[CurrentMatch].cs?.msg)?.contains("WD+"))!
            {
                self.voice(eng:"wide",hin:"wideHindi")
                self.tvGiffAnimation(image: cell.tv_giff, arrImg: wideImgArr, duration: 2.0, RepeatCount: 0)
                cell.iv_4_6_giff.image = nil
                
                timer.invalidate()
                timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(self.update(_:)), userInfo: ["image":#imageLiteral(resourceName: "wide7"),"flag":"1"], repeats: false);
                cell.lbl_giffText.text =  "Wide Ball"
                cell.lbl_runs.text = "\(((fireBaseGlobalModel[CurrentMatch].cs?.msg)!.components(separatedBy: "+"))[1]) Run"
                cell.lbl_plus.text = "+"
            }
            else if ((fireBaseGlobalModel[CurrentMatch].cs?.msg)?.contains("NB+"))!
            {
                self.voice(eng:"noball",hin:"noballHindi")
                self.tvGiffAnimation(image: cell.tv_giff, arrImg: noBallImgArr, duration: 2.0, RepeatCount: 0)
                cell.lbl_giffText.text =  "No Ball"
                timer.invalidate()
                timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(self.update(_:)), userInfo: ["image":#imageLiteral(resourceName: "nb7"),"flag":"1"], repeats: false);
                cell.lbl_runs.text = "\(((fireBaseGlobalModel[CurrentMatch].cs?.msg)!.components(separatedBy: "+"))[1]) Run"
                cell.lbl_plus.text = "+"
            }
            else if fireBaseGlobalModel[CurrentMatch].cs?.msg == "C"
            {
                cell.lbl_other.text = "Confirming"
            }
            else if fireBaseGlobalModel[CurrentMatch].cs?.msg == "1"
            {
                self.voice(eng: "one run", hin: "single")
                cell.lbl_other.text = (fireBaseGlobalModel[CurrentMatch].cs?.msg)!+" Run"
            }
            else if fireBaseGlobalModel[CurrentMatch].cs?.msg == "2"
            {
                self.voice(eng: "two run", hin: "double run")
                cell.lbl_other.text = (fireBaseGlobalModel[CurrentMatch].cs?.msg)!+" Runs"
            }
            else if fireBaseGlobalModel[CurrentMatch].cs?.msg == "3"
            {
                self.voice(eng: "three run", hin: "3 runs")
                cell.lbl_other.text = (fireBaseGlobalModel[CurrentMatch].cs?.msg)!+" Runs"
            }
            else if fireBaseGlobalModel[CurrentMatch].cs?.msg == "4"
            {
                self.voice(eng: "its a four", hin: "four")
                cell.tv_giff.image = nil
                cell.iv_4_6_giff.image = nil
                self.tvGiffAnimation(image: cell.iv_4_6_giff, arrImg: fourImgArr, duration: 1.0, RepeatCount: 1)
                timer.invalidate()
                timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update(_:)), userInfo: ["image":#imageLiteral(resourceName: "four_i"),"flag":"0"], repeats: false);
            }
            else if fireBaseGlobalModel[CurrentMatch].cs?.msg == "6"
            {
                self.voice(eng: "wow six", hin:"six" )
                cell.tv_giff.image = nil
                cell.iv_4_6_giff.image = nil
                self.tvGiffAnimation(image: cell.iv_4_6_giff, arrImg: sixImgArr, duration: 1.0, RepeatCount: 1)
                timer.invalidate()
                timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.update(_:)), userInfo: ["image":#imageLiteral(resourceName: "six_i"),"flag":"0"], repeats: false);
            }
            else if fireBaseGlobalModel[CurrentMatch].cs?.msg == "0"
            {
                self.voice(eng: "dot", hin: "khali khali dot ball")
                cell.lbl_other.text =  "0"
            }
            else
            {
                cell.lbl_other.text = fireBaseGlobalModel[CurrentMatch].cs?.msg
            }
            
            cell.lbl_runs.transform = cell.lbl_runs.transform.scaledBy(x: 0.20, y: 0.20)
            cell.lbl_giffText.transform = cell.lbl_giffText.transform.scaledBy(x: 0.20, y: 0.20)
            cell.lbl_plus.transform = cell.lbl_plus.transform.scaledBy(x: 0.20, y: 0.20)
            
            
            UIView.animate(withDuration: 1.2,
                           animations: {
                            cell.lbl_runs.transform = cell.lbl_runs.transform.scaledBy(x: 5, y: 5)
                            cell.lbl_giffText.transform = cell.lbl_giffText.transform.scaledBy(x: 5, y: 5)
                            cell.lbl_plus.transform = cell.lbl_plus.transform.scaledBy(x: 5, y: 5)
                            
            },
                           completion: { _ in
                            cell.lbl_runs.transform = cell.lbl_runs.transform.scaledBy(x: 0.20, y: 0.20)
                            cell.lbl_giffText.transform = cell.lbl_giffText.transform.scaledBy(x: 0.20, y: 0.20)
                            cell.lbl_plus.transform = cell.lbl_plus.transform.scaledBy(x: 0.20, y: 0.20)
                            
                            
                            
                            UIView.animate(withDuration: 1.2,
                                           animations: {
                                            cell.lbl_runs.transform = cell.lbl_runs.transform.scaledBy(x: 5, y: 5)
                                            cell.lbl_giffText.transform = cell.lbl_giffText.transform.scaledBy(x: 5, y: 5)
                                            cell.lbl_plus.transform = cell.lbl_plus.transform.scaledBy(x: 5, y: 5)
                                            
                            },
                                           completion: { _ in
                                            cell.lbl_runs.transform = cell.lbl_runs.transform.scaledBy(x: 0.20, y: 0.20)
                                            cell.lbl_giffText.transform = cell.lbl_giffText.transform.scaledBy(x: 0.20, y: 0.20)
                                            cell.lbl_plus.transform = cell.lbl_plus.transform.scaledBy(x: 0.20, y: 0.20)
                                            
                                            
                                            
                                            UIView.animate(withDuration: 1.2,
                                                           animations: {
                                                            cell.lbl_runs.transform = cell.lbl_runs.transform.scaledBy(x: 5, y: 5)
                                                            cell.lbl_giffText.transform = cell.lbl_giffText.transform.scaledBy(x: 5, y: 5)
                                                            cell.lbl_plus.transform = cell.lbl_plus.transform.scaledBy(x: 5, y: 5)
                                                            
                                            },
                                                           completion: { _ in
                                            })
                            })
            })
        }
    }
    func addObservers()
    {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(self.updateCurrentRunRateCell),
                                       name: .refreshCurrentRunRateCell,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(self.refreshMarketRate),
                                       name: .refreshLambi,
                                       object: nil)

        notificationCenter.addObserver(self,
                                       selector: #selector(self.refreshPlayerScoreCell),
                                       name: .refreshPlayer,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(self.refreshLastBallScore),
                                       name: .refreshPreviousBall,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(self.refreshMatchRateTextCell),
                                       name: .refreshMatchDiscription,
                                       object: nil)
        notificationCenter.addObserver(self, selector: #selector(self.refreshProjectedScoreCell), name: .refreshProjectedScore, object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(self.refreshFavTeam),
                                       name: .refreshFavTeam,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(self.refreshMarketRate),
                                       name: .refreshMarket,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(self.refreshSessionSuspend),
                                       name: .refreshSessionSuspended,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(self.refreshSession),
                                       name: .refreshSession,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(self.refreshTV),
                                       name: .refreshCurrentStatus,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(self.refreshMatchday),
                                       name: .refreshDay,
                                       object: nil)        
        
        notificationCenter.addObserver(self,
                                       selector: #selector(self.FirInning1),
                                       name: .refreshIninning1,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(self.FirInning2),
                                       name: .refreshIninning2,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(self.FirInning3),
                                       name: .refreshIninning3,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(self.FirInning4),
                                       name: .refreshIninning4,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(self.removeTimer),
                                       name: .disableTimer,
                                       object: nil)
    }
    @objc func removeTimer()
    {
        self.timer.invalidate()
    }
    func removeObservers()
    {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
    }
    func setRunxBall(ininning:CLGFirbaseInningModel,cell:MatchRateCell,session2:NSString,seesionOv:NSString)
    {
        let runs = ininning.sc as! NSString
        let sessionMaxScore : NSInteger = NSInteger(session2.longLongValue)
        let run : NSInteger = NSInteger(runs.longLongValue)
        let RunBall1 : NSInteger = sessionMaxScore - run
        if(RunBall1 < 0)
        {
            cell.txtRunBall1.text = "-"
        }
        else{
            
            cell.txtRunBall1.text = String(format: "%d", RunBall1)
        }
        var currentBalls = balls(str: ininning.ov!)
        let sessionOverBalls : NSInteger = NSInteger(seesionOv.longLongValue) * 6
        let currentBall : NSInteger = NSInteger(currentBalls)
        let RunBall2: NSInteger = sessionOverBalls - currentBall
        if(RunBall2 < 0)
        {
            cell.txtRunBall2.text = "-"
        }
        else{
            
            cell.txtRunBall2.text = String(format: "%d", RunBall2)
            
        }
    }
    
    func updateRunX(cell:MatchRateCell)
    {
        /*let session = fireBaseGlobalModel[CurrentMatch].ssn
        let sessionStatusTwo : NSString = session?.y as! NSString
        let sessionOver : NSString = session?.ov as! NSString
        cell.txt_sessionOver.text = sessionOver != "" ? (sessionOver as String) : ""
        cell.txt_sessionRate2.text = sessionStatusTwo != "" ? (sessionStatusTwo as String) : "-"
        let currrentinning : NSString = (fireBaseGlobalModel[CurrentMatch].i as? NSString)!
        if currrentinning == "i1"
        {
            setRunxBall(ininning: fireBaseGlobalModel[CurrentMatch].i1!, cell: cell, session2:sessionStatusTwo, seesionOv:sessionOver)
        }
        else if currrentinning == "i2"
        {
            setRunxBall(ininning: fireBaseGlobalModel[CurrentMatch].i2!, cell: cell, session2:sessionStatusTwo, seesionOv:sessionOver)
        }
            
        else if currrentinning == "i3"
        {
            setRunxBall(ininning: fireBaseGlobalModel[CurrentMatch].i3!, cell: cell, session2:sessionStatusTwo, seesionOv:sessionOver)
        }
            
        else
        {
            setRunxBall(ininning: fireBaseGlobalModel[CurrentMatch].i4!, cell: cell, session2:sessionStatusTwo, seesionOv:sessionOver)
        }*/
        if let sn = fireBaseGlobalModel[CurrentMatch].sn, sn != ""{
            let snArray = sn.components(separatedBy: ",")
            let sessionStatusTwo : NSString = snArray[2] as NSString
            let sessionOver : NSString = snArray[0] as NSString
            cell.txt_sessionOver.text = sessionOver != "" ? (sessionOver as String) : ""
            cell.txt_sessionRate2.text = sessionStatusTwo != "" ? (sessionStatusTwo as String) : "-"
            let currrentinning : NSString = (fireBaseGlobalModel[CurrentMatch].i as NSString?)!
            if currrentinning == "i1"
            {
                setRunxBall(ininning: fireBaseGlobalModel[CurrentMatch].i1!, cell: cell, session2:sessionStatusTwo, seesionOv:sessionOver)
            }
            else if currrentinning == "i2"
            {
                setRunxBall(ininning: fireBaseGlobalModel[CurrentMatch].i2!, cell: cell, session2:sessionStatusTwo, seesionOv:sessionOver)
            }
                
            else if currrentinning == "i3"
            {
                setRunxBall(ininning: fireBaseGlobalModel[CurrentMatch].i3!, cell: cell, session2:sessionStatusTwo, seesionOv:sessionOver)
            }
                
            else
            {
                setRunxBall(ininning: fireBaseGlobalModel[CurrentMatch].i4!, cell: cell, session2:sessionStatusTwo, seesionOv:sessionOver)
            }
        }
        else{
            cell.txt_sessionOver.text =  ""
            cell.txt_sessionRate2.text = "-"
            cell.txtRunBall1.text = "-"
            cell.txtRunBall2.text = "-"
        }
       
    }
    //MARK: play Sound
    func playSound(sound:String) {
        guard let url = Bundle.main.url(forResource: sound, withExtension: "mp3") else {
            print("url not found")
            return
        }
        
        do {
            /// this codes for making this app ready to takeover the device audio
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            /// change fileTypeHint according to the type of your audio file (you can omit this)
            //            AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3)
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            // no need for prepareToPlay because prepareToPlay is happen automatically when calling play()
            synthesizer.stopSpeaking(at: AVSpeechBoundary.immediate)
            if !(player?.isPlaying)!
            {
                player!.play()
            }
        } catch let _ as NSError {
            //            print("error: \(error.localizedDescription)")
        }
        
    }
    
    // MARK: - Speaker ON OFF
    @objc func SpeakerOnOff(_ sender:UIButton)
    {
        let button = sender
        let isSpeech : NSString = UserDefault.userDefaultForKey(key: "isSpeech") as NSString
        if isSpeech.isEqual(to: "1")  {
            UserDefault.saveToUserDefault(value: "0" as AnyObject, key: "isSpeech")
            button.setImage(UIImage(named: "speakeroff"), for: .normal)
        }
        else
        {
            UserDefault.saveToUserDefault(value: "1" as AnyObject, key: "isSpeech")
            button.setImage(UIImage(named: "speakeron"), for: .normal)
        }
    }
    
    func setTableViewStructure()
    {
        tv_watchLive_LiveScore.estimatedRowHeight = 500
        self.tv_watchLive_LiveScore.separatorColor = UIColor.clear
        self.registerNib(tv: tv_watchLive_LiveScore, cellName: "matchLineAdCell")
        self.registerNib(tv: tv_watchLive_LiveScore, cellName: "MatchRateCell")
        self.registerNib(tv: tv_watchLive_LiveScore, cellName: "MatchRateTextCell")
        self.registerNib(tv: tv_watchLive_LiveScore, cellName: "PreviousBallCell")
        self.registerNib(tv: tv_watchLive_LiveScore, cellName: "LastBallScore")
        self.registerNib(tv: tv_watchLive_LiveScore, cellName: "PlayersScoreCell")
        self.registerNib(tv: tv_watchLive_LiveScore, cellName: "CurrentRunRateCell")
        self.registerNib(tv: tv_watchLive_LiveScore, cellName: "TvCell")
        self.registerNib(tv: tv_watchLive_LiveScore, cellName: "TestMatchRateCell")
        self.registerNib(tv: tv_watchLive_LiveScore, cellName: "ProjectedScoreCell")
    }
    
    @objc func update(_ timer:Timer)
    {
        if self.isCellVisible(row: 0),
            let cell = tv_watchLive_LiveScore.cellForRow(at: IndexPath(row: 0, section: 0))! as? TvCell
        {
            if timer.userInfo != nil
            {
                if let dict = timer.userInfo as? [String:AnyObject]
                {
                    if dict["flag"] as! String == "1"
                    {
                        cell.tv_giff.stopAnimating()
                        cell.tv_giff.image = dict["image"] as? UIImage
                    }
                    else
                    {
                        cell.iv_4_6_giff.stopAnimating()
                        cell.iv_4_6_giff.image = dict["image"] as? UIImage
                    }
                }
            }
        }
        self.timer.invalidate()
    }
    
    // MARK: TableView Delegate
    func numberOfSectionsInTableView(tableView: UITableView) ->Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 8
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        
        var rowHeight:CGFloat = 0.0
        
        if indexPath.row == 0
        {
            return UITableViewAutomaticDimension
        }
        else if indexPath.row == 4
        {
            return 60
        }
        else if indexPath.row == 5
        {
            if adsCellProvider != nil {
                 return 200
            } else {
                 return 0
            }
        }
        else if indexPath.row == 6
        {
            if fireBaseGlobalModel[CurrentMatch].con?.mf != "Test" && fireBaseGlobalModel[CurrentMatch].i == "i1"{
                if let currentOver = fireBaseGlobalModel[CurrentMatch].i1?.ov{
                    let currentFloatOver = Double(currentOver)!
                    if (fireBaseGlobalModel[CurrentMatch].con?.mf == "20" && (currentFloatOver > 10.0 && currentFloatOver < 19.1)) || (fireBaseGlobalModel[CurrentMatch].con?.mf == "50" && (currentFloatOver > 25.0 && currentFloatOver < 49.1)){
                        rowHeight = 80.0
                    }
                    else{
                        rowHeight = 0.0
                        
                    }
                }
                
            }
            else{
                rowHeight = 0.0
            }
           return rowHeight
        }
        else if indexPath.row == 1
        {
            if fireBaseGlobalModel[CurrentMatch].con?.mf == "Test"
            {
                return UITableViewAutomaticDimension
            }
            else
            {
                if fireBaseGlobalModel[CurrentMatch].cs?.msg == "BR"
                {
                    return 90
                }
                else
                {
                    return UITableViewAutomaticDimension
                }
            }
            
        }
        else
        {
            /*if fireBaseGlobalModel[CurrentMatch].rm != nil
            {
                if fireBaseGlobalModel[CurrentMatch].rm != ""
                {
                    return 50
                }
                return UITableViewAutomaticDimension
            }*/
            return UITableViewAutomaticDimension
        }
        //return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if indexPath.row == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TvCell") as! TvCell
            cell.selectionStyle = .none
            setTvCell(cell:cell)
            return cell
        }
        else if indexPath.row == 1
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CurrentRunRateCell") as! CurrentRunRateCell
            if fireBaseGlobalModel[CurrentMatch].con?.mf == "Test"
            {
                cell.secondInningsView.isHidden = true
                cell.lbl_targetLabel.isHidden = true
                cell.lbl_BallRLable.isHidden = true
                cell.lbl_target.isHidden = true
                cell.lbl_ballR.isHidden = true
                cell.middleView.isHidden = false
            }
            else{
                cell.middleView.isHidden = true
            }
            setCurrentRunRate(cell:cell)
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row == 2
        {
            
            if fireBaseGlobalModel[CurrentMatch].con?.mf != "Test"
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "MatchRateCell") as! MatchRateCell
                cell.selectionStyle = .none
                setFavouriteTeam(cell:cell)
                setMarketRate(cell:cell)
                setSessionAndRunXball(cell:cell)
                setSessionSuspend(cell:cell)
                return cell
            }
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TestMatchRateCell") as! TestMatchRateCell
                cell.selectionStyle = .none
                setTestMatchRate(cell:cell)
                return cell
            }
        }
        else if indexPath.row == 3
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlayersScoreCell") as! PlayersScoreCell
            setPlayerScoreCell(cell:cell)
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row == 4
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LastBallScore") as! LastBallScore
            setLastBallScore(cell:cell)
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row == 5
        {
            if adsCellProvider != nil && adsCellProvider.isAdCell(at: indexPath, forStride: UInt(adRowStep)) {
                 // Put ad code here
                let ad = adsManager.nextNativeAd
                let cell = self.tv_watchLive_LiveScore.dequeueReusableCell(withIdentifier: "matchLineAdCell", for: indexPath) as! matchLineAdCell
                
                cell.bodyViewLbl.text = ad?.bodyText
                cell.headlineLbl.text = ad?.headline
                cell.calToViewActionBtn.setTitle(ad?.callToAction, for: .normal)
                cell.calToViewActionBtn.isUserInteractionEnabled = true
                ad?.downloadMedia()
                if let pic = ad?.iconImage {
                    cell.adImage.image = pic
                }
                ad?.registerView(forInteraction: cell, mediaView: cell.fbmediaView, iconView: cell.fbmediaView, viewController: self,clickableViews: [cell.calToViewActionBtn])
                return cell
            } else {
               return UITableViewCell()
            }
            
            
//            let cell = tableView.dequeueReusableCell(withIdentifier: "matchLineAdCell") as! matchLineAdCell
//            fbNativeAd.unregisterView()
//            fbNativeAd.registerView(forInteraction: cell, mediaView: cell.fbmediaView, iconImageView: cell.adImage, viewController: self, clickableViews: [cell.calToViewActionBtn,cell.adView,cell.adImage])
//            cell.headlineLbl.text = fbNativeAd.headline
//            cell.bodyViewLbl.text = fbNativeAd.bodyText
//            cell.adImage.image = fbNativeAd.iconImage
//            cell.bodyViewLbl.isUserInteractionEnabled = false
//            cell.calToViewActionBtn.setTitle(fbNativeAd.callToAction, for: .normal)
//            cell.bannerView.isHidden = true
//            cell.bannerView.adUnitID = AppHelper.appDelegate().adBannerUnitID as String
//            cell.bannerView.rootViewController = self
//            cell.bannerView.load(GADRequest())
//            if let adView = cell.contentView.subviews[1] as? GADUnifiedNativeAdView
//            {
//                if nativeAds.count != 0{
//                    nativeAds[0].rootViewController = self
//                    adView.nativeAd = nativeAds[0]
//                    (adView.headlineView as! UILabel).text = nativeAds[0].headline
//                    (adView.bodyView as! UILabel).text = nativeAds[0].body
//                    //(adView.advertiserView as! UILabel).text = nativeAds[0].advertiser
//                    (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
//                    (adView.callToActionView as! UIButton).setTitle(
//                        nativeAds[0].callToAction, for: UIControlState.normal)
//                }
//            }
//            return cell;
        }
            
            
        else if indexPath.row == 6
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectedScoreCell") as! ProjectedScoreCell
            //setMatchRateTextCell(cell:cell)
            cell.selectionStyle = .none
            if fireBaseGlobalModel[CurrentMatch].con?.mf != "Test" && fireBaseGlobalModel[CurrentMatch].i == "i1"{
                if let currentOver = fireBaseGlobalModel[CurrentMatch].i1?.ov{
                    let currentFloatOver = Double(currentOver)!
                    if (fireBaseGlobalModel[CurrentMatch].con?.mf == "20" && (currentFloatOver > 10.0 && currentFloatOver < 19.1)) || (fireBaseGlobalModel[CurrentMatch].con?.mf == "50" && (currentFloatOver > 25.0 && currentFloatOver < 49.1)){
                        cell.isHidden = false
                        setProjectedScore(cell: cell)
                    }
                    else{
                        cell.isHidden = true
                    }
                }
            }
            else{
                cell.isHidden = true
            }
            return cell;
            
        }
        else
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MatchRateTextCell") as! MatchRateTextCell
            setMatchRateTextCell(cell:cell)
            cell.selectionStyle = .none
            return cell;
        }
    }
    private func setProjectedScore(cell:ProjectedScoreCell){
        let currentBalls = "\(self.balls(str: (fireBaseGlobalModel[CurrentMatch].i1?.ov)!))" as NSString
        let battingScore : NSString = (fireBaseGlobalModel[CurrentMatch].i1?.sc)! as NSString
        let batScore : Double = Double(NSInteger(battingScore.longLongValue))
        let curBalls : Double = Double(NSInteger(currentBalls.longLongValue))
        let RunRate1 : Double = Double(batScore/curBalls)*6
        
        //let ballsRemaining = "\(self.ballRemaining(ov: (fireBaseGlobalModel[CurrentMatch].i1?.ov)!, iov: (fireBaseGlobalModel[CurrentMatch].i1?.iov)!))" as NSString
        var iover = (fireBaseGlobalModel[CurrentMatch].iov ?? "")
        if iover.isEmpty{
            iover = "0"
        }
        let ballsRemaining = "\(self.ballRemaining(ov: (fireBaseGlobalModel[CurrentMatch].i1?.ov)!, iov: iover))" as NSString
        let ballRem : Double = Double(NSInteger(ballsRemaining.longLongValue))
        let projectedScore1 = Int(batScore + (RunRate1*ballRem)/6)
        
        if(RunRate1.isNaN){
            cell.runRate1Lbl.text = "0.00*"
            cell.runRate2Lbl.text = "0.00"
            cell.runRate3Lbl.text = "0.00"
            cell.runRate4Lbl.text = "0.00"
            
            cell.projected1Lbl.text = "0.00"
            cell.projected2Lbl.text = "0.00"
            cell.projected3Lbl.text = "0.00"
            cell.projected4Lbl.text = "0.00"

        }
        else if (RunRate1.isInfinite)
        {
            cell.runRate1Lbl.text = "0.00*"
            cell.runRate2Lbl.text = "0.00"
            cell.runRate3Lbl.text = "0.00"
            cell.runRate4Lbl.text = "0.00"
            
            cell.projected1Lbl.text = "0.00"
            cell.projected2Lbl.text = "0.00"
            cell.projected3Lbl.text = "0.00"
            cell.projected4Lbl.text = "0.00"
            
        }
        else{
            cell.runRate1Lbl.text = String(format: "%.2f", RunRate1) + "*"
            cell.projected1Lbl.text = String(format: "%d", projectedScore1)

            if RunRate1 < 7.0{
                let RunRate2 = Int(RunRate1) + 2
                let RunRate3 = Int(RunRate1) + 4
                let RunRate4 = Int(RunRate1) + 6
                cell.runRate2Lbl.text = String(format: "%d", RunRate2)
                cell.runRate3Lbl.text = String(format: "%d", RunRate3)
                cell.runRate4Lbl.text = String(format: "%d", RunRate4)
                
                let projectedScore2 = Int(batScore) + (RunRate2*Int(ballRem))/6
                let projectedScore3 = Int(batScore) + (RunRate3*Int(ballRem))/6
                let projectedScore4 = Int(batScore) + (RunRate4*Int(ballRem))/6
                cell.projected2Lbl.text = String(format: "%d", projectedScore2)
                cell.projected3Lbl.text = String(format: "%d", projectedScore3)
                cell.projected4Lbl.text = String(format: "%d", projectedScore4)

            }
            else{
                let RunRate2 = Int(RunRate1) + 1
                let RunRate3 = Int(RunRate1) + 2
                let RunRate4 = Int(RunRate1) + 3
                cell.runRate2Lbl.text = String(format: "%d", RunRate2)
                cell.runRate3Lbl.text = String(format: "%d", RunRate3)
                cell.runRate4Lbl.text = String(format: "%d", RunRate4)
                
                let projectedScore2 = Int(batScore) + (RunRate2*Int(ballRem))/6
                let projectedScore3 = Int(batScore) + (RunRate3*Int(ballRem))/6
                let projectedScore4 = Int(batScore) + (RunRate4*Int(ballRem))/6
                cell.projected2Lbl.text = String(format: "%d", projectedScore2)
                cell.projected3Lbl.text = String(format: "%d", projectedScore3)
                cell.projected4Lbl.text = String(format: "%d", projectedScore4)
            }
            
        }
        
        
    }
    
}
/*extension LiveLineVC:GADUnifiedNativeAdLoaderDelegate
{
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADUnifiedNativeAd) {
        nativeAds.append(nativeAd)
        tv_watchLive_LiveScore.reloadData()
    }
}
extension LiveLineVC:GADAdLoaderDelegate{
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
        print("\(adLoader) failed with error: \(error.localizedDescription)")
    }
}*/

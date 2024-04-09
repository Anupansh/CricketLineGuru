//
//  PlayerDetailVC.swift
//  cricrate
//
//  Created by Anuj Naruka on 9/20/17.
//  Copyright © 2017 Cricket Line Guru. All rights reserved.
//

import UIKit
import GoogleMobileAds
import CoreData
import ObjectMapper

class PlayerDetailVC: BaseViewController,UINavigationControllerDelegate,UIGestureRecognizerDelegate {
    
    //MARK:-IBOutlets
    
    @IBOutlet weak var infoBgView: UIView!
    @IBOutlet weak var battingBgView: UIView!
    @IBOutlet weak var bowlingBgView: UIView!
    @IBOutlet weak var gadBannerView: GADBannerView!
    @IBOutlet weak var tblPlayerDetail: UITableView!
    @IBOutlet weak var bannerHeight: NSLayoutConstraint!
    @IBOutlet weak var LblNoMatch: UILabel!
    @IBOutlet weak var selectedTabConstraint: NSLayoutConstraint!
    
    //MARK:-Variables And Constants
    var classType = String()
    internal var interstitialAds: GADInterstitial!
    private var navigationTitle = String()
    private var playerId = String()
    private var playerData = CLGTeamNameModel()
    private var playerKey = String()
    var bannerAdView: FBAdView!
    
    private var infoItem = ["","","Full Name","Role","Batting Style","Bowling Style","","","",""]
    //private var battingItem = ["","Average","Balls","Fifties","Fours","High Score","Hundreds","Innings","Matches","Not Outs","Runs","Sixes","Strike Rates"]
    private var battingItem = ["","Matches","Innings","Runs","Balls","Fifties","Hundreds","High Score","Average","Not Outs","Fours","Sixes","Strike Rates"]
    //private var bowlingItem = ["","Average","Balls","Innings","Runs","Career Best","Wickets","Economy","Five Wickets","Matches","Ten Wickets","Strike Rates"]
    private var bowlingItem = ["","Matches","Innings","Balls","Wickets","Economy","Average","Five Wickets","Ten Wickets","Career Best","Runs","Strike Rates"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LblNoMatch.isHidden = true
        setUp()
        tblPlayerDetail.registerMultiple(nibs: [InfoImageCell.className,InfoHeaderCell.className,InfoTextCell.className,BattingCell.className,BattingHeaderCell.className])
        let appDel = UIApplication.shared.delegate as! AppDelegate
        if (appDel.fbInterstitialAd != nil) && appDel.fbInterstitialAd.isAdValid && appDel.toShowInterstitial {
            appDel.fbInterstitialAd.show(fromRootViewController: self)
            appDel.fbInterstitialAd = nil
            appDel.fbInterstitialAd = appDel.loadInterstitialFbAd()
            appDel.toShowInterstitial = false
            appDel.runTimer()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARk:-Funcions
    
    func getTeamIdFromPrevClass(id:String,navTitle:String){
        self.playerId = id
        self.navigationTitle = navTitle
    }
    func getTeamIdFromPrevClassScoreCard(key:String,navTitle:String){
        self.playerKey = key
        self.navigationTitle = navTitle
    }
    private func setUp(){
        self.setupNavigationBarTitle(navigationTitle, navBG: "", leftBarButtonsType: [.back], rightBarButtonsType: [])
        tblPlayerDetail.estimatedRowHeight = 140
        if self.playerId != ""{
            self.getPlayerData()
        }
        if self.playerKey != ""{
            self.getPlayerDataGetMethod()
        }
        self.loadFbBannerAd()
    }

    
    func loadFbBannerAd() {
            bannerAdView = FBAdView(placementID: AppHelper.appDelegate().fbBannerAdId, adSize: kFBAdSizeHeight50Banner, rootViewController: self)
        if tabBarController!.tabBar.isHidden {
            if UIDevice.current.hasTopNotch {
                bannerAdView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 84, width: UIScreen.main.bounds.width, height: 50)
            }
            else {
                bannerAdView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 60, width: UIScreen.main.bounds.width, height: 50)
            }
        }
        else {
            if UIDevice.current.hasTopNotch {
                bannerAdView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 134, width: UIScreen.main.bounds.width, height: 50)
            }
            else {
                bannerAdView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 110, width: UIScreen.main.bounds.width, height: 50)
            }
        }
    //        bannerAdView.delegate = self
            self.view.addSubview(bannerAdView)
            bannerAdView.loadAd()
        }
    //MARK:-Func
    
    
    private func getPlayerData(){
        let paramDict = [String:Any]()
        //paramDict["playerId"] = self.playerId
        CLGUserService().playerDetailServiceee(url: NewBaseUrlV3+CLGRecentClass.player+"/\(self.playerId)", method: .get, showLoader: 2, header: header, parameters: paramDict).then(execute: { (data) -> Void in
            if data.statusCode == 1{
                if let responseData = data.responseData, let player = responseData.player{
                    self.playerData = player
                }
            }
            //self.interstitialAds = self.createAndLoadInterstitial()
            //self.ShowAd()
            self.tblPlayerDetail.reloadData()
        }).catch { (error) in
            print(error)
        }
    }
    private func getPlayerDataGetMethod(){
        let paramDict = [String:Any]()
        //paramDict["playerId"] = self.playerId
        CLGUserService().playerDetailServiceee(url: NewBaseUrlV4+"/player/"+self.playerKey+"/info", method: .get, showLoader: 2, header: header, parameters: paramDict).then(execute: { (data) -> Void in
            if data.statusCode == 1{
                if let responseData = data.responseData, let player = responseData.player{
                    self.playerData = player 
                }
            }
            //self.interstitialAds = self.createAndLoadInterstitial()
            //self.ShowAd()
            self.tblPlayerDetail.reloadData()
        }).catch { (error) in
            print(error)
        }
    }
    
    //MARK:-IBActions
    
    @IBAction func infoBtn(_ sender: Any){
        UIView.animate(withDuration: 0.5, animations: {
            self.selectedTabConstraint.constant = self.infoBgView.frame.origin.x
            self.view.layoutIfNeeded()
        })
        tblPlayerDetail.reloadData()
    }
    
    @IBAction func battingBtn(_ sender: Any){
        UIView.animate(withDuration: 0.5, animations: {
            self.selectedTabConstraint.constant = self.battingBgView.frame.origin.x
            self.view.layoutIfNeeded()
        })
        tblPlayerDetail.reloadData()
    }
    
    @IBAction func bowlingBtn(_ sender: Any){
        UIView.animate(withDuration: 0.5, animations: {
            self.selectedTabConstraint.constant = self.bowlingBgView.frame.origin.x
            self.view.layoutIfNeeded()
        })
        tblPlayerDetail.reloadData()
    }
}

extension PlayerDetailVC:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if self.selectedTabConstraint.constant == self.infoBgView.frame.origin.x{
            return infoItem.count
        }else if self.selectedTabConstraint.constant == self.battingBgView.frame.origin.x{
            return battingItem.count
        }else{
            return bowlingItem.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if self.selectedTabConstraint.constant == self.infoBgView.frame.origin.x{
            switch indexPath.row {
            case 0:
                return getInfoImageCell(indexPath, tableView: tableView)
            case 1,6,8:
                return getInfoHeaderCell(indexPath, tableView: tableView)
            default:
                return getInfoTextCell(indexPath, tableView: tableView)
            }
        }else{
            if indexPath.row == 0{
                return getBattingHeaderCell(indexPath, tableView: tableView)
            }else{
                return getBattingCell(indexPath, tableView: tableView)
            }
        }
    }
    
    private func getInfoImageCell( _ indexPath : IndexPath, tableView : UITableView) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: InfoImageCell.className, for: indexPath) as? InfoImageCell else {
            fatalError("unexpectedIndexPath")
        }
        
        if let name = self.playerData.name{
            cell.playerName.text = name
        }
        
        if let country = self.playerData.cntry{
            cell.countryName.text = country
        }
        if playerId != ""{
            if let image = self.playerData.playerImage,image != "",image.contains("http"){
                cell.playerImgView.af_setImage(withURL: URL(string: image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
            }
            else
            {
                if let name = self.playerData.name{
                    cell.playerImgView.image = AppHelper.generateImageWithText(text: name, image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:name.uppercased()), size: CGSize(width: 70, height: 70)))
                    
                }
                else{
                    cell.playerImgView.image = AppHelper.generateImageWithText(text: "", image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:""), size: CGSize(width: 70, height: 70)))
                    
                }
            }
        }
        if playerKey != ""{
            if let image = self.playerData.logo,image != "",image.contains("http"){
                cell.playerImgView.af_setImage(withURL: URL(string: image)!)
            }
            else
            {
                if let name = self.playerData.name{
                    cell.playerImgView.image = AppHelper.generateImageWithText(text: name, image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:name.uppercased()), size: CGSize(width: 70, height: 70)))
                    
                }
                else{
                    cell.playerImgView.image = AppHelper.generateImageWithText(text: "", image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:""), size: CGSize(width: 70, height: 70)))
                    
                }
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    
    private func getInfoHeaderCell( _ indexPath : IndexPath, tableView : UITableView) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: InfoHeaderCell.className, for: indexPath) as? InfoHeaderCell else {
            fatalError("unexpectedIndexPath")
        }
        cell.selectionStyle = .none
        switch indexPath.row {
        case 1:
            cell.lblHeader.text = "Personal Information"
        case 6:
            if self.playerData.teams != nil && self.playerData.teams != "" {
                cell.lblHeader.text = "Teams"
            }
            else{
                cell.lblHeader.text = ""
            }
        default:
            if self.playerData.desc != nil && self.playerData.desc != ""{
                cell.lblHeader.text = "Profile"
            }
            else{
                cell.lblHeader.text = ""
            }
        }
        return cell
    }
    
    private func getInfoTextCell( _ indexPath : IndexPath, tableView : UITableView) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: InfoTextCell.className, for: indexPath) as? InfoTextCell else {
            fatalError("unexpectedIndexPath")
        }
        
        cell.selectionStyle = .none
        if indexPath.row == 2{
            cell.lblCenter.isHidden = true
            cell.leftLbl.text = self.infoItem[indexPath.row]
            if let fname = self.playerData.f_name{
                cell.RightLbl.text = fname
            }
        }
        else if indexPath.row == 3{
            cell.lblCenter.isHidden = true
            cell.leftLbl.text = self.infoItem[indexPath.row]
            if let roles = self.playerData.roles
            {
                if roles.keeper != nil, roles.keeper!
                {
                    cell.RightLbl.text = "Wicket Keeper"
                }
                else if roles.batsman != nil && roles.bowler != nil ,roles.batsman! && roles.bowler!
                {
                    cell.RightLbl.text = "All Rounder"
                }
                else if  roles.batsman != nil, roles.batsman!
                {
                    cell.RightLbl.text = "Batsmen"
                }
                else
                {
                    cell.RightLbl.text = "Bowler"
                }
            }
        }else if indexPath.row == 4{
            cell.lblCenter.isHidden = true
            cell.leftLbl.text = self.infoItem[indexPath.row]
            if let batting_styles = self.playerData.btng{
                if batting_styles.count > 0{
                    cell.RightLbl.text = batting_styles[0]
                }
            }
        }
        else if indexPath.row == 5{
            cell.lblCenter.isHidden = true
            cell.leftLbl.text = self.infoItem[indexPath.row]
            if let batting_styles = self.playerData.bwl{
                if batting_styles.count > 0{
                    cell.RightLbl.text = batting_styles[0]
                }
            }
        }
        else if indexPath.row == 7{
            cell.lblCenter.isHidden = false
            if self.playerData.teams != nil && self.playerData.teams != ""{
                cell.lblCenter.text = self.playerData.teams
            }
            else{
                cell.lblCenter.text = ""
            }
        }
        else if indexPath.row == 9{
            cell.lblCenter.isHidden = false
            if self.playerData.desc != nil && self.playerData.desc != ""{
                cell.lblCenter.text = self.playerData.desc?.html2String
            }
            else{
                cell.lblCenter.text = ""
            }
        }
        return cell
    }
    
    private func getBattingHeaderCell( _ indexPath : IndexPath, tableView : UITableView) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BattingHeaderCell.className, for: indexPath) as? BattingHeaderCell else {
            fatalError("unexpectedIndexPath")
        }
        cell.selectionStyle = .none
        if self.selectedTabConstraint.constant == self.battingBgView.frame.origin.x{
            cell.lbl1.text = "Batting"
        }else{
            cell.lbl1.text = "Bowling"
        }
        return cell
    }
    
    private func getBattingCell( _ indexPath : IndexPath, tableView : UITableView) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BattingCell.className, for: indexPath) as? BattingCell else {
            fatalError("unexpectedIndexPath")
        }
        if self.selectedTabConstraint.constant == self.battingBgView.frame.origin.x{
            cell.lbl1.text = self.battingItem[indexPath.row]
            if let stats = playerData.stats{
                cell.setBattingData(type: 0, lbl: cell.lbl2, indexPath: indexPath, data: stats)
                cell.setBattingData(type: 1, lbl: cell.lbl3, indexPath: indexPath, data: stats)
                cell.setBattingData(type: 2, lbl: cell.lbl4, indexPath: indexPath, data: stats)
            }
        }else{
            cell.lbl1.text = self.bowlingItem[indexPath.row]
            if let stats = playerData.stats{
                cell.setBowlingData(type: 0, lbl: cell.lbl2, indexPath: indexPath, data: stats)
                cell.setBowlingData(type: 1, lbl: cell.lbl3, indexPath: indexPath, data: stats)
                cell.setBowlingData(type: 2, lbl: cell.lbl4, indexPath: indexPath, data: stats)
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.selectedTabConstraint.constant == self.infoBgView.frame.origin.x{
            switch indexPath.row {
            case 0:
                return 170.0
            case 1:
                return 35.0
            case 6:
                if self.playerData.teams != nil && self.playerData.teams != "" {
                    return 35.0
                }
                else{
                    return 0
                }
            case 7:
                if self.playerData.teams != nil && self.playerData.teams != ""{
                    return UITableViewAutomaticDimension
                }
                else{
                    return 0
                }
            case 8:
                if self.playerData.desc != nil && self.playerData.desc != ""{
                    return 35.0
                }
                else{
                    return 0
                }
            case 9:
                if self.playerData.desc != nil && self.playerData.desc != ""{
                    return UITableViewAutomaticDimension
                }
                else{
                    return 0
                }
            default:
                return 45.0
            }
        }
        return 45.0
    }
}

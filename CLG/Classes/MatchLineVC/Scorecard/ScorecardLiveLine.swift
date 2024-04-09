//
//  ScorecardLiveLine.swift
//  CLG
//
//  Created by Sani Kumar on 16/12/19.
//  Copyright © 2019 Anuj Naruka. All rights reserved.
//


import UIKit
import Firebase
import AlamofireImage
import GoogleMobileAds

class ScorecardLiveLine: BaseViewController {
    
    //MARK:- Variables & Constants
    @IBOutlet weak var noScoreLbl: UILabel!
    @IBOutlet weak var tvScoreCard: UITableView!
    
    
    //MARK:- IBOutlets
    let numAdsToLoad = 5
    var nativeAds = [GADUnifiedNativeAd]()
    
    //MARK:- IBOutlets
    var titleLbl = String()
    var selectedBtn = 1
    var teamOnei1ScoreboardSelected = false
    var teamTwoi1ScoreboardSelected = false
    var teamOnei2ScoreboardSelected = false
    var teamTwoi2ScoreboardSelected = false
    var matchKey = String()
    var scorecardData = CLGScorcardApi()
    var CurrentMatch = 0
    var isComingFromMatchLine = false
    var isCommentryAvailable = Bool()
    var totalCount = Int()
    
    var matchStatus = String()
    var bannerAdView : FBAdView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadFbBannerAd()
        setTopBar()
        self.registerHeaderFooterNib(tv: tvScoreCard, cellName: "CellBannerAdTableViewCell")
        self.registerHeaderFooterNib(tv: tvScoreCard, cellName: "TitleCell")
        self.registerNib(tv: tvScoreCard, cellName: "BatsmanCell")
        self.registerHeaderFooterNib(tv: tvScoreCard, cellName: "SquadTeamCell")
        self.tvScoreCard.tableFooterView = UIView()
        
        // Do any additional setup after loading the view.
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if matchStatus != "U"{
            //AppHelper.showHud(type:2)
            self.hitScoreboardApi()
        }
        else{
            self.noScoreLbl.isHidden = false
        }
        showNativeAd()
        loadFbBannerAd()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        removeObservers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    private func setTopBar(){
        self.setupNavigationBarTitle(titleLbl, navBG: "", leftBarButtonsType: [.back], rightBarButtonsType: [])
    }
    private func addObserver(){
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(self.refreshScorecard),
                                       name: .refreshScorecard,
                                       object: nil)
    }
    
    func loadFbBannerAd() {
            bannerAdView = FBAdView(placementID: AppHelper.appDelegate().fbBannerAdId, adSize: kFBAdSizeHeight50Banner, rootViewController: self)
        let y = self.view.frame.origin.y + self.view.frame.height
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
    func removeObservers()
    {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
    }
    @objc func refreshScorecard(){
        if matchStatus != "U"{
            self.hitScoreboardApi()
        }
        else{
            self.noScoreLbl.isHidden = false
        }
    }
    @objc func showNativeAd(){
        nativeAds = AppHelper.appDelegate().returnNativeAdArray()
    }
    @objc func scoreboardSectionBtnAct(sender:UIButton)
    {
        if sender.tag == 1
        {
            teamOnei1ScoreboardSelected = !teamOnei1ScoreboardSelected
        }
        else if sender.tag == 2
        {
            teamTwoi1ScoreboardSelected = !teamTwoi1ScoreboardSelected
        }
        else if sender.tag == 3
        {
            teamOnei2ScoreboardSelected = !teamOnei2ScoreboardSelected
        }
        else if sender.tag == 4
        {
            teamTwoi2ScoreboardSelected = !teamTwoi2ScoreboardSelected
        }
        let indices: IndexSet = [sender.tag]
        self.tvScoreCard.beginUpdates()
        self.tvScoreCard.reloadSections(indices, with: UITableViewRowAnimation.automatic)
        self.tvScoreCard.endUpdates()
    }

    private func hitScoreboardApi()
    {
        
        CLGUserService().scorecardServiceee(url: NewBaseUrlV5+CLGRecentClass.Scorecard, method: .get, showLoader: 0, header: header, parameters: ["matchKey":matchKey]).then { (data) -> Void in
            print(data)
            if data.statusCode == 1{
                self.scorecardData = data
                if let responsedata = data.responseData{
                    if let match = responsedata.match{
                        if let titleName = match.name{
                            self.titleLbl = titleName
                            //self.setTopBar()
                        }
                        else{
                            self.noScoreLbl.isHidden = false
                        }
                        self.setScoreCard()
                    }
                    else{
                        self.noScoreLbl.isHidden = false
                    }
                }
                else{
                    self.noScoreLbl.isHidden = false
                }
                
            }
            }.catch { (error) in
                print(error)
        }
    }
    
    private func setBatsmanCell(cell:BatsmanCell,indexPath:IndexPath)->BatsmanCell
    {
        if let noBat = (scorecardData.responseData?.match?.inn_order)![indexPath.section-1].no_bat, noBat != ""{
            
            if let fow = (scorecardData.responseData?.match?.inn_order)![indexPath.section-1].fow, fow.count > 0{
                if indexPath.row == 0
                {
                    cell.lbl_Score.isHidden = true
                    cell.lbl_Over.isHidden = true
                    cell.Bowls.isHidden = false
                    cell.Four.isHidden = false
                    cell.Runs.isHidden = false
                    cell.Six.isHidden = false
                    cell.StrikeRateLbl.isHidden = false
                    cell.lblDidNotBat.isHidden = true
                    cell.lblPlayers.isHidden = true
                    
                    cell.StatusLBL.text = ""
                    cell.BatsmanAndStatus.text = "BATSMAN"
                    cell.BatsmanAndStatus.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.Bowls.text = "B"
                    cell.Bowls.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.Four.text = "4s"
                    cell.Four.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.Runs.text = "R"
                    cell.Runs.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.Six.text = "6s"
                    cell.Six.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.StrikeRateLbl.text = "SR"
                    cell.StrikeRateLbl.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.StatusLBL.font = UIFont(name: "Lato-Semibold", size: 11.0)
                    
                    
                    cell.BatsmanAndStatus.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    cell.Bowls.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    cell.Four.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    cell.Runs.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    cell.Six.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    cell.StrikeRateLbl.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    cell.backView.backgroundColor = .groupTableViewBackground
                    
                    
                }
                else if indexPath.row < ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+1
                {
                    cell.lbl_Score.isHidden = true
                    cell.lbl_Over.isHidden = true
                    cell.Bowls.isHidden = false
                    cell.Four.isHidden = false
                    cell.Runs.isHidden = false
                    cell.Six.isHidden = false
                    cell.StrikeRateLbl.isHidden = false
                    cell.lblDidNotBat.isHidden = true
                    cell.lblPlayers.isHidden = true
                    
                    cell.StatusLBL.text = (scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?[indexPath.row-1].batting?.out_str
                    cell.BatsmanAndStatus.text = (scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?[indexPath.row-1].name ?? "-"
                    cell.Bowls.text = "\(((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?[indexPath.row-1].batting?.balls) ?? 0)"
                    cell.Four.text = "\(((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?[indexPath.row-1].batting?.fours) ?? 0)"
                    cell.Runs.text = "\(((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?[indexPath.row-1].batting?.runs) ?? 0)"
                    cell.Six.text = "\(((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?[indexPath.row-1].batting?.sixes) ?? 0)"
                    cell.StrikeRateLbl.text = "\(((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?[indexPath.row-1].batting?.strike_rate) ?? 0)"
                    cell.BatsmanAndStatus.textColor = UIColor.black
                    cell.Bowls.textColor = UIColor.black
                    cell.Four.textColor = UIColor.black
                    cell.Runs.textColor = UIColor.black
                    cell.Six.textColor = UIColor.black
                    cell.StrikeRateLbl.textColor = UIColor.black
                    cell.StatusLBL.textColor = AppHelper.hexStringToUIColor(hex: "D52618")
                    cell.BatsmanAndStatus.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.Bowls.font = UIFont(name: "Lato-Medium", size: 13.0)
                    cell.Four.font = UIFont(name: "Lato-Medium", size: 13.0)
                    cell.Runs.font = UIFont(name: "Lato-Medium", size: 13.0)
                    cell.Six.font = UIFont(name: "Lato-Medium", size: 13.0)
                    cell.StrikeRateLbl.font = UIFont(name: "Lato-Medium", size: 13.0)
                    cell.StatusLBL.font = UIFont(name: "Lato-Semibold", size: 11.0)
                    cell.backView.backgroundColor = .clear
                    
                }
                else if indexPath.row == ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+1
                {
                    cell.lbl_Score.isHidden = true
                    cell.lbl_Over.isHidden = true
                    cell.Bowls.isHidden = true
                    cell.Four.isHidden = true
                    cell.Runs.isHidden = true
                    cell.Six.isHidden = true
                    cell.StrikeRateLbl.isHidden = true
                    cell.lblDidNotBat.isHidden = false
                    cell.lblPlayers.isHidden = false
                    
                    cell.StatusLBL.text = ""
                    cell.BatsmanAndStatus.text = ""
                    cell.lblPlayers.text = noBat
                    
                    if scorecardData.responseData?.match?.inn_order?.count == 1
                    {
                        if scorecardData.responseData?.match?.status == "completed"{
                            cell.lblDidNotBat.text = "Did not bat"
                        }
                        else{
                            cell.lblDidNotBat.text = "Yet to bat"
                        }
                    }
                    else if scorecardData.responseData?.match?.inn_order?.count == 2
                    {
                        if scorecardData.responseData?.match?.status == "completed"{
                            cell.lblDidNotBat.text = "Did not bat"
                        }
                        else{
                            if indexPath.section == 1{
                                cell.lblDidNotBat.text = "Did not bat"
                            }
                            else{
                                cell.lblDidNotBat.text = "Yet to bat"
                            }
                        }
                    }
                    else if scorecardData.responseData?.match?.inn_order?.count == 3
                    {
                        if scorecardData.responseData?.match?.status == "completed"{
                            cell.lblDidNotBat.text = "Did not bat"
                        }
                        else{
                            if indexPath.section == 1 || indexPath.section == 2{
                                cell.lblDidNotBat.text = "Did not bat"
                            }
                            else{
                                cell.lblDidNotBat.text = "Yet to bat"
                            }
                        }
                    }
                    else if scorecardData.responseData?.match?.inn_order?.count == 4
                    {
                        if scorecardData.responseData?.match?.status == "completed"{
                            cell.lblDidNotBat.text = "Did not bat"
                        }
                        else{
                            if indexPath.section == 1 || indexPath.section == 2 || indexPath.section == 3{
                                cell.lblDidNotBat.text = "Did not bat"
                            }
                            else{
                                cell.lblDidNotBat.text = "Yet to bat"
                            }
                        }
                    }
                    
                    cell.Bowls.text = ""
                    cell.Four.text = ""
                    cell.Runs.text = ""
                    cell.Six.text = ""
                    cell.StrikeRateLbl.text = ""
                    
                    cell.BatsmanAndStatus.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.lblDidNotBat.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.StatusLBL.font = UIFont(name: "Lato-Bold", size: 12.0)
                    cell.lblPlayers.font = UIFont(name: "Lato-Bold", size: 13.0)
                    cell.Bowls.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.Four.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.Runs.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.Six.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.StrikeRateLbl.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.BatsmanAndStatus.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    cell.lblDidNotBat.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    cell.backView.backgroundColor = .clear
                    
                }
                else if indexPath.row == ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+2
                {
                    cell.lbl_Score.isHidden = true
                    cell.lbl_Over.isHidden = true
                    cell.Bowls.isHidden = false
                    cell.Four.isHidden = false
                    cell.Runs.isHidden = false
                    cell.Six.isHidden = false
                    cell.StrikeRateLbl.isHidden = false
                    cell.lblDidNotBat.isHidden = true
                    cell.lblPlayers.isHidden = true
                    
                    cell.StatusLBL.text = ""
                    cell.BatsmanAndStatus.text = ""
                    cell.Bowls.text = ""
                    cell.Four.text = ""
                    cell.Runs.text = ""
                    cell.Six.text = ""
                    cell.StrikeRateLbl.text = ""
                    
                    cell.BatsmanAndStatus.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.Bowls.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.Four.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.Runs.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.Six.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.StrikeRateLbl.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.backView.backgroundColor = .clear
                    
                }
                else if indexPath.row == ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+3
                {
                    cell.lbl_Score.isHidden = true
                    cell.lbl_Over.isHidden = true
                    cell.Bowls.isHidden = false
                    cell.Four.isHidden = false
                    cell.Runs.isHidden = false
                    cell.Six.isHidden = false
                    cell.StrikeRateLbl.isHidden = false
                    cell.lblDidNotBat.isHidden = true
                    cell.lblPlayers.isHidden = true
                    
                    cell.StatusLBL.text = ""
                    cell.BatsmanAndStatus.text = "BOWLER"
                    cell.Bowls.text = "M"
                    cell.Four.text = "R"
                    cell.Runs.text = "O"
                    cell.Six.text = "W"
                    cell.StrikeRateLbl.text = "ER"
                    cell.BatsmanAndStatus.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    cell.Bowls.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    cell.Four.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    cell.Runs.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    cell.Six.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    cell.StrikeRateLbl.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    
                    cell.BatsmanAndStatus.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.Bowls.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.Four.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.Runs.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.Six.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.StrikeRateLbl.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.backView.backgroundColor = .groupTableViewBackground
                    
                }
                else if indexPath.row > ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+3 && indexPath.row < ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].bowling?.count)!+4
                {
                    cell.lbl_Score.isHidden = true
                    cell.lbl_Over.isHidden = true
                    cell.Bowls.isHidden = false
                    cell.Four.isHidden = false
                    cell.Runs.isHidden = false
                    cell.Six.isHidden = false
                    cell.StrikeRateLbl.isHidden = false
                    cell.lblDidNotBat.isHidden = true
                    cell.lblPlayers.isHidden = true
                    
                    let count = ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)! + 4
                    
                    cell.StatusLBL.text = ""
                    cell.BatsmanAndStatus.text = (scorecardData.responseData?.match?.inn_order)![indexPath.section-1].bowling?[indexPath.row-count].name
                    cell.Bowls.text = "\(((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].bowling?[indexPath.row-count].bowling?.maiden_overs) ?? 0)"
                    cell.Four.text = "\(((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].bowling?[indexPath.row-count].bowling?.runs) ?? 0)"
                    cell.Runs.text = "\(((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].bowling?[indexPath.row-count].bowling?.overs) ?? "0")"
                    cell.Six.text = "\(((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].bowling?[indexPath.row-count].bowling?.wickets) ?? 0)"
                    cell.StrikeRateLbl.text = "\(((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].bowling?[indexPath.row-count].bowling?.economy) ?? 0)"
                    cell.BatsmanAndStatus.textColor = UIColor.black
                    cell.Bowls.textColor = UIColor.black
                    cell.Four.textColor = UIColor.black
                    cell.Runs.textColor = UIColor.black
                    cell.Six.textColor = UIColor.black
                    cell.StrikeRateLbl.textColor = UIColor.black
                    
                    cell.StatusLBL.font = UIFont(name: "Lato-Semibold", size: 11.0)
                    cell.BatsmanAndStatus.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.Bowls.font = UIFont(name: "Lato-Medium", size: 13.0)
                    cell.Four.font = UIFont(name: "Lato-Medium", size: 13.0)
                    cell.Runs.font = UIFont(name: "Lato-Medium", size: 13.0)
                    cell.Six.font = UIFont(name: "Lato-Medium", size: 13.0)
                    cell.StrikeRateLbl.font = UIFont(name: "Lato-Medium", size: 13.0)
                    cell.backView.backgroundColor = .clear
                    
                }
                else if indexPath.row == ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].bowling?.count)!+4
                {
                    cell.lbl_Score.isHidden = true
                    cell.lbl_Over.isHidden = true
                    cell.Bowls.isHidden = false
                    cell.Four.isHidden = false
                    cell.Runs.isHidden = false
                    cell.Six.isHidden = false
                    cell.StrikeRateLbl.isHidden = false
                    cell.lblDidNotBat.isHidden = true
                    cell.lblPlayers.isHidden = true
                    
                    cell.StatusLBL.text = ""
                    cell.BatsmanAndStatus.text = ""
                    cell.Bowls.text = ""
                    cell.Four.text = ""
                    cell.Runs.text = ""
                    cell.Six.text = ""
                    cell.StrikeRateLbl.text = ""
                    
                    cell.StatusLBL.font = UIFont(name: "Lato-Semibold", size: 11.0)
                    cell.BatsmanAndStatus.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.Bowls.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.Four.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.Runs.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.Six.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.StrikeRateLbl.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.backView.backgroundColor = .clear
                    
                }
                else if indexPath.row == ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].bowling?.count)!+5
                {
                    cell.lbl_Score.isHidden = false
                    cell.lbl_Over.isHidden = false
                    cell.Bowls.isHidden = true
                    cell.Four.isHidden = true
                    cell.Runs.isHidden = true
                    cell.Six.isHidden = true
                    cell.StrikeRateLbl.isHidden = true
                    cell.lblDidNotBat.isHidden = true
                    cell.lblPlayers.isHidden = true
                    
                    cell.StatusLBL.text = ""
                    cell.BatsmanAndStatus.text = "FALL OF WICKETS"
                    cell.Bowls.text = ""
                    cell.Four.text = ""
                    cell.Runs.text = ""//"SCORE"
                    cell.Six.text = ""//"OVER"
                    cell.lbl_Score.text = "SCORE"
                    cell.lbl_Over.text = "OVER"
                    cell.StrikeRateLbl.text = ""
                    cell.BatsmanAndStatus.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    cell.Bowls.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    cell.Four.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    cell.Runs.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    cell.Six.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    cell.StrikeRateLbl.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    cell.lbl_Score.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    cell.lbl_Over.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    
                    cell.StatusLBL.font = UIFont(name: "Lato-Semibold", size: 11.0)
                    cell.BatsmanAndStatus.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.Bowls.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.Four.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.Runs.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.Six.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.StrikeRateLbl.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.lbl_Score.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.lbl_Over.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.backView.backgroundColor = .groupTableViewBackground
                }
                else if indexPath.row > ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].bowling?.count)!+5
                {
                    cell.lbl_Score.isHidden = false
                    cell.lbl_Over.isHidden = false
                    cell.Bowls.isHidden = true
                    cell.Four.isHidden = true
                    cell.Runs.isHidden = true
                    cell.Six.isHidden = true
                    cell.StrikeRateLbl.isHidden = true
                    cell.lblDidNotBat.isHidden = true
                    cell.lblPlayers.isHidden = true
                    
                    
                    let count = ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].bowling?.count)! + 6
                    cell.StatusLBL.text = ""
                    cell.BatsmanAndStatus.text = fow[indexPath.row-count].n
                    cell.Bowls.text = ""
                    cell.Four.text = ""
                    cell.Runs.text = ""//"\((fow[indexPath.row-count].s) ?? "0")"
                    cell.Six.text = ""//"\((fow[indexPath.row-count].o) ?? "0")"
                    cell.lbl_Score.text = "\((fow[indexPath.row-count].s) ?? "0")" + "/" + "\(indexPath.row-count + 1)"
                    cell.lbl_Over.text = "\((fow[indexPath.row-count].o) ?? "0")"
                    cell.StrikeRateLbl.text = ""
                    cell.BatsmanAndStatus.textColor = UIColor.black
                    cell.Bowls.textColor = UIColor.black
                    cell.Four.textColor = UIColor.black
                    cell.Runs.textColor = UIColor.black
                    cell.Six.textColor = UIColor.black
                    cell.StrikeRateLbl.textColor = UIColor.black
                    cell.lbl_Score.textColor = UIColor.black
                    cell.lbl_Over.textColor = UIColor.black
                    
                    cell.StatusLBL.font = UIFont(name: "Lato-Semibold", size: 11.0)
                    cell.BatsmanAndStatus.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.Bowls.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.Four.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.Runs.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.Six.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.StrikeRateLbl.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.lbl_Score.font = UIFont(name: "Lato-Medium", size: 13.0)
                    cell.lbl_Over.font = UIFont(name: "Lato-Medium", size: 13.0)
                    
                    cell.backView.backgroundColor = .clear
                    
                }
            }
            else{
                cell.lbl_Score.isHidden = true
                cell.lbl_Over.isHidden = true
                cell.Bowls.isHidden = false
                cell.Four.isHidden = false
                cell.Runs.isHidden = false
                cell.Six.isHidden = false
                cell.StrikeRateLbl.isHidden = false
                
                if indexPath.row == 0
                {
                    cell.lblDidNotBat.isHidden = true
                    cell.lblPlayers.isHidden = true
                    
                    cell.StatusLBL.text = ""
                    cell.BatsmanAndStatus.text = "BATSMAN"
                    cell.BatsmanAndStatus.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.Bowls.text = "B"
                    cell.Bowls.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.Four.text = "4s"
                    cell.Four.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.Runs.text = "R"
                    cell.Runs.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.Six.text = "6s"
                    cell.Six.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.StrikeRateLbl.text = "SR"
                    cell.StrikeRateLbl.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.StatusLBL.font = UIFont(name: "Lato-Semibold", size: 11.0)
                    
                    cell.BatsmanAndStatus.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    cell.Bowls.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    cell.Four.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    cell.Runs.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    cell.Six.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    cell.StrikeRateLbl.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    cell.backView.backgroundColor = .groupTableViewBackground
                    
                }
                else if indexPath.row < ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+1
                {
                    cell.lblDidNotBat.isHidden = true
                    cell.lblPlayers.isHidden = true
                    
                    cell.StatusLBL.text = (scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?[indexPath.row-1].batting?.out_str
                    cell.BatsmanAndStatus.text = (scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?[indexPath.row-1].name ?? "-"
                    cell.Bowls.text = "\(((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?[indexPath.row-1].batting?.balls) ?? 0)"
                    cell.Four.text = "\(((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?[indexPath.row-1].batting?.fours) ?? 0)"
                    cell.Runs.text = "\(((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?[indexPath.row-1].batting?.runs) ?? 0)"
                    cell.Six.text = "\(((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?[indexPath.row-1].batting?.sixes) ?? 0)"
                    cell.StrikeRateLbl.text = "\(((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?[indexPath.row-1].batting?.strike_rate) ?? 0)"
                    cell.BatsmanAndStatus.textColor = UIColor.black
                    cell.Bowls.textColor = UIColor.black
                    cell.Four.textColor = UIColor.black
                    cell.Runs.textColor = UIColor.black
                    cell.Six.textColor = UIColor.black
                    cell.StrikeRateLbl.textColor = UIColor.black
                    cell.StatusLBL.textColor = AppHelper.hexStringToUIColor(hex: "D52618")
                    cell.StatusLBL.font = UIFont(name: "Lato-Semibold", size: 11.0)
                    cell.BatsmanAndStatus.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.Bowls.font = UIFont(name: "Lato-Medium", size: 13.0)
                    cell.Four.font = UIFont(name: "Lato-Medium", size: 13.0)
                    cell.Runs.font = UIFont(name: "Lato-Medium", size: 13.0)
                    cell.Six.font = UIFont(name: "Lato-Medium", size: 13.0)
                    cell.StrikeRateLbl.font = UIFont(name: "Lato-Medium", size: 13.0)
                    cell.backView.backgroundColor = .clear
                    
                }
                else if indexPath.row == ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+1
                {
                    cell.lbl_Score.isHidden = true
                    cell.lbl_Over.isHidden = true
                    cell.Bowls.isHidden = true
                    cell.Four.isHidden = true
                    cell.Runs.isHidden = true
                    cell.Six.isHidden = true
                    cell.StrikeRateLbl.isHidden = true
                    cell.lblDidNotBat.isHidden = false
                    cell.lblPlayers.isHidden = false
                    
                    cell.StatusLBL.text = ""
                    cell.BatsmanAndStatus.text = ""
                    cell.lblPlayers.text = noBat
                    //cell.lblDidNotBat.text = "Yet to bat"
                    
                    if scorecardData.responseData?.match?.inn_order?.count == 1
                    {
                        if scorecardData.responseData?.match?.status == "completed"{
                            cell.lblDidNotBat.text = "Did not bat"
                        }
                        else{
                            cell.lblDidNotBat.text = "Yet to bat"
                        }
                    }
                    else if scorecardData.responseData?.match?.inn_order?.count == 2{
                        if scorecardData.responseData?.match?.status == "completed"{
                            cell.lblDidNotBat.text = "Did not bat"
                        }
                        else{
                            if indexPath.section == 1{
                                cell.lblDidNotBat.text = "Did not bat"
                            }
                            else{
                                cell.lblDidNotBat.text = "Yet to bat"
                            }
                        }
                    }
                    else if scorecardData.responseData?.match?.inn_order?.count == 3{
                        if scorecardData.responseData?.match?.status == "completed"{
                            cell.lblDidNotBat.text = "Did not bat"
                        }
                        else{
                            if indexPath.section == 1 || indexPath.section == 2{
                                cell.lblDidNotBat.text = "Did not bat"
                            }
                            else{
                                cell.lblDidNotBat.text = "Yet to bat"
                            }
                        }
                    }
                    else if scorecardData.responseData?.match?.inn_order?.count == 4{
                        if scorecardData.responseData?.match?.status == "completed"{
                            cell.lblDidNotBat.text = "Did not bat"
                        }
                        else{
                            if indexPath.section == 1 || indexPath.section == 2 || indexPath.section == 3{
                                cell.lblDidNotBat.text = "Did not bat"
                            }
                            else{
                                cell.lblDidNotBat.text = "Yet to bat"
                            }
                        }
                    }
                    
                    cell.Bowls.text = ""
                    cell.Four.text = ""
                    cell.Runs.text = ""
                    cell.Six.text = ""
                    cell.StrikeRateLbl.text = ""
                    
                    cell.BatsmanAndStatus.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.StatusLBL.font = UIFont(name: "Lato-Bold", size: 12.0)
                    cell.lblDidNotBat.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.lblPlayers.font = UIFont(name: "Lato-Bold", size: 13.0)
                    cell.Bowls.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.Four.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.Runs.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.Six.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.StrikeRateLbl.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.BatsmanAndStatus.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    cell.lblDidNotBat.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    cell.backView.backgroundColor = .clear
                    
                }
                else if indexPath.row == ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+2
                {
                    cell.StatusLBL.text = ""
                    cell.BatsmanAndStatus.text = ""
                    cell.Bowls.text = ""
                    cell.Four.text = ""
                    cell.Runs.text = ""
                    cell.Six.text = ""
                    cell.StrikeRateLbl.text = ""
                    cell.lblDidNotBat.isHidden = true
                    cell.lblPlayers.isHidden = true
                    
                    cell.StatusLBL.font = UIFont(name: "Lato-Semibold", size: 11.0)
                    cell.BatsmanAndStatus.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.Bowls.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.Four.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.Runs.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.Six.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.StrikeRateLbl.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.backView.backgroundColor = .clear
                    
                }
                else if indexPath.row == ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+3
                {
                    cell.lblDidNotBat.isHidden = true
                    cell.lblPlayers.isHidden = true
                    cell.StatusLBL.text = ""
                    cell.BatsmanAndStatus.text = "BOWLER"
                    cell.Bowls.text = "M"
                    cell.Four.text = "R"
                    cell.Runs.text = "O"
                    cell.Six.text = "W"
                    cell.StrikeRateLbl.text = "ER"
                    cell.BatsmanAndStatus.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    cell.Bowls.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    cell.Four.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    cell.Runs.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    cell.Six.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    cell.StrikeRateLbl.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    
                    cell.StatusLBL.font = UIFont(name: "Lato-Semibold", size: 11.0)
                    cell.BatsmanAndStatus.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.Bowls.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.Four.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.Runs.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.Six.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.StrikeRateLbl.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.backView.backgroundColor = .groupTableViewBackground
                    
                }
                else if indexPath.row > ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+3
                {
                    cell.lblDidNotBat.isHidden = true
                    cell.lblPlayers.isHidden = true
                    let count = ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)! + 4
                    
                    cell.StatusLBL.text = ""
                    cell.BatsmanAndStatus.text = (scorecardData.responseData?.match?.inn_order)![indexPath.section-1].bowling?[indexPath.row-count].name
                    cell.Bowls.text = "\(((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].bowling?[indexPath.row-count].bowling?.maiden_overs) ?? 0)"
                    cell.Four.text = "\(((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].bowling?[indexPath.row-count].bowling?.runs) ?? 0)"
                    cell.Runs.text = "\(((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].bowling?[indexPath.row-count].bowling?.overs) ?? "0")"
                    cell.Six.text = "\(((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].bowling?[indexPath.row-count].bowling?.wickets) ?? 0)"
                    cell.StrikeRateLbl.text = "\(((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].bowling?[indexPath.row-count].bowling?.economy) ?? 0)"
                    cell.BatsmanAndStatus.textColor = UIColor.black
                    cell.Bowls.textColor = UIColor.black
                    cell.Four.textColor = UIColor.black
                    cell.Runs.textColor = UIColor.black
                    cell.Six.textColor = UIColor.black
                    cell.StrikeRateLbl.textColor = UIColor.black
                    
                    cell.StatusLBL.font = UIFont(name: "Lato-Semibold", size: 11.0)
                    cell.BatsmanAndStatus.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.Bowls.font = UIFont(name: "Lato-Medium", size: 13.0)
                    cell.Four.font = UIFont(name: "Lato-Medium", size: 13.0)
                    cell.Runs.font = UIFont(name: "Lato-Medium", size: 13.0)
                    cell.Six.font = UIFont(name: "Lato-Medium", size: 13.0)
                    cell.StrikeRateLbl.font = UIFont(name: "Lato-Medium", size: 13.0)
                    cell.backView.backgroundColor = .clear
                    
                }
            }
        }
        else{
            cell.lblDidNotBat.isHidden = true
            cell.lblPlayers.isHidden = true
            if let fow = (scorecardData.responseData?.match?.inn_order)![indexPath.section-1].fow, fow.count > 0{
                if indexPath.row == 0
                {
                    cell.lbl_Score.isHidden = true
                    cell.lbl_Over.isHidden = true
                    cell.Bowls.isHidden = false
                    cell.Four.isHidden = false
                    cell.Runs.isHidden = false
                    cell.Six.isHidden = false
                    cell.StrikeRateLbl.isHidden = false
                    
                    cell.StatusLBL.text = ""
                    cell.BatsmanAndStatus.text = "BATSMAN"
                    cell.BatsmanAndStatus.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.Bowls.text = "B"
                    cell.Bowls.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.Four.text = "4s"
                    cell.Four.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.Runs.text = "R"
                    cell.Runs.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.Six.text = "6s"
                    cell.Six.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.StrikeRateLbl.text = "SR"
                    cell.StrikeRateLbl.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.StatusLBL.font = UIFont(name: "Lato-Semibold", size: 11.0)
                    
                    cell.BatsmanAndStatus.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    cell.Bowls.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    cell.Four.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    cell.Runs.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    cell.Six.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    cell.StrikeRateLbl.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    cell.backView.backgroundColor = .groupTableViewBackground
                    
                    
                }
                else if indexPath.row < ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+1
                {
                    cell.lbl_Score.isHidden = true
                    cell.lbl_Over.isHidden = true
                    cell.Bowls.isHidden = false
                    cell.Four.isHidden = false
                    cell.Runs.isHidden = false
                    cell.Six.isHidden = false
                    cell.StrikeRateLbl.isHidden = false
                    
                    cell.StatusLBL.text = (scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?[indexPath.row-1].batting?.out_str
                    cell.BatsmanAndStatus.text = (scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?[indexPath.row-1].name ?? "-"
                    cell.Bowls.text = "\(((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?[indexPath.row-1].batting?.balls) ?? 0)"
                    cell.Four.text = "\(((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?[indexPath.row-1].batting?.fours) ?? 0)"
                    cell.Runs.text = "\(((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?[indexPath.row-1].batting?.runs) ?? 0)"
                    cell.Six.text = "\(((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?[indexPath.row-1].batting?.sixes) ?? 0)"
                    cell.StrikeRateLbl.text = "\(((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?[indexPath.row-1].batting?.strike_rate) ?? 0)"
                    cell.BatsmanAndStatus.textColor = UIColor.black
                    cell.Bowls.textColor = UIColor.black
                    cell.Four.textColor = UIColor.black
                    cell.Runs.textColor = UIColor.black
                    cell.Six.textColor = UIColor.black
                    cell.StrikeRateLbl.textColor = UIColor.black
                    cell.StatusLBL.textColor = AppHelper.hexStringToUIColor(hex: "D52618")
                    cell.BatsmanAndStatus.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.Bowls.font = UIFont(name: "Lato-Medium", size: 13.0)
                    cell.Four.font = UIFont(name: "Lato-Medium", size: 13.0)
                    cell.Runs.font = UIFont(name: "Lato-Medium", size: 13.0)
                    cell.Six.font = UIFont(name: "Lato-Medium", size: 13.0)
                    cell.StrikeRateLbl.font = UIFont(name: "Lato-Medium", size: 13.0)
                    cell.StatusLBL.font = UIFont(name: "Lato-Semibold", size: 11.0)
                    
                    cell.backView.backgroundColor = .clear
                    
                }
                else if indexPath.row == ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+1
                {
                    cell.lbl_Score.isHidden = true
                    cell.lbl_Over.isHidden = true
                    cell.Bowls.isHidden = false
                    cell.Four.isHidden = false
                    cell.Runs.isHidden = false
                    cell.Six.isHidden = false
                    cell.StrikeRateLbl.isHidden = false
                    
                    cell.StatusLBL.text = ""
                    cell.BatsmanAndStatus.text = ""
                    cell.Bowls.text = ""
                    cell.Four.text = ""
                    cell.Runs.text = ""
                    cell.Six.text = ""
                    cell.StrikeRateLbl.text = ""
                    
                    cell.StatusLBL.font = UIFont(name: "Lato-Semibold", size: 11.0)
                    cell.BatsmanAndStatus.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.Bowls.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.Four.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.Runs.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.Six.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.StrikeRateLbl.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.backView.backgroundColor = .clear
                    
                }
                else if indexPath.row == ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+2
                {
                    cell.lbl_Score.isHidden = true
                    cell.lbl_Over.isHidden = true
                    cell.Bowls.isHidden = false
                    cell.Four.isHidden = false
                    cell.Runs.isHidden = false
                    cell.Six.isHidden = false
                    cell.StrikeRateLbl.isHidden = false
                    
                    cell.StatusLBL.text = ""
                    cell.BatsmanAndStatus.text = "BOWLER"
                    cell.Bowls.text = "M"
                    cell.Four.text = "R"
                    cell.Runs.text = "O"
                    cell.Six.text = "W"
                    cell.StrikeRateLbl.text = "ER"
                    cell.BatsmanAndStatus.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    cell.Bowls.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    cell.Four.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    cell.Runs.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    cell.Six.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    cell.StrikeRateLbl.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    
                    cell.StatusLBL.font = UIFont(name: "Lato-Semibold", size: 11.0)
                    cell.BatsmanAndStatus.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.Bowls.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.Four.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.Runs.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.Six.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.StrikeRateLbl.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.backView.backgroundColor = .groupTableViewBackground
                    
                }
                else if indexPath.row > ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+2 && indexPath.row < ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].bowling?.count)!+3
                {
                    cell.lbl_Score.isHidden = true
                    cell.lbl_Over.isHidden = true
                    cell.Bowls.isHidden = false
                    cell.Four.isHidden = false
                    cell.Runs.isHidden = false
                    cell.Six.isHidden = false
                    cell.StrikeRateLbl.isHidden = false
                    
                    let count = ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)! + 3
                    cell.StatusLBL.text = ""
                    cell.BatsmanAndStatus.text = (scorecardData.responseData?.match?.inn_order)![indexPath.section-1].bowling?[indexPath.row-count].name
                    cell.Bowls.text = "\(((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].bowling?[indexPath.row-count].bowling?.maiden_overs) ?? 0)"
                    cell.Four.text = "\(((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].bowling?[indexPath.row-count].bowling?.runs) ?? 0)"
                    cell.Runs.text = "\(((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].bowling?[indexPath.row-count].bowling?.overs) ?? "0")"
                    cell.Six.text = "\(((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].bowling?[indexPath.row-count].bowling?.wickets) ?? 0)"
                    cell.StrikeRateLbl.text = "\(((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].bowling?[indexPath.row-count].bowling?.economy) ?? 0)"
                    cell.BatsmanAndStatus.textColor = UIColor.black
                    cell.Bowls.textColor = UIColor.black
                    cell.Four.textColor = UIColor.black
                    cell.Runs.textColor = UIColor.black
                    cell.Six.textColor = UIColor.black
                    cell.StrikeRateLbl.textColor = UIColor.black
                    
                    cell.StatusLBL.font = UIFont(name: "Lato-Semibold", size: 11.0)
                    cell.BatsmanAndStatus.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.Bowls.font = UIFont(name: "Lato-Medium", size: 13.0)
                    cell.Four.font = UIFont(name: "Lato-Medium", size: 13.0)
                    cell.Runs.font = UIFont(name: "Lato-Medium", size: 13.0)
                    cell.Six.font = UIFont(name: "Lato-Medium", size: 13.0)
                    cell.StrikeRateLbl.font = UIFont(name: "Lato-Medium", size: 13.0)
                    cell.backView.backgroundColor = .clear
                    
                }
                else if indexPath.row == ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].bowling?.count)!+3
                {
                    cell.lbl_Score.isHidden = true
                    cell.lbl_Over.isHidden = true
                    cell.Bowls.isHidden = false
                    cell.Four.isHidden = false
                    cell.Runs.isHidden = false
                    cell.Six.isHidden = false
                    cell.StrikeRateLbl.isHidden = false
                    
                    cell.StatusLBL.text = ""
                    cell.BatsmanAndStatus.text = ""
                    cell.Bowls.text = ""
                    cell.Four.text = ""
                    cell.Runs.text = ""
                    cell.Six.text = ""
                    cell.StrikeRateLbl.text = ""
                    
                    cell.StatusLBL.font = UIFont(name: "Lato-Semibold", size: 11.0)
                    cell.BatsmanAndStatus.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.Bowls.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.Four.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.Runs.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.Six.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.StrikeRateLbl.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.backView.backgroundColor = .clear
                    
                }
                else if indexPath.row == ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].bowling?.count)!+4
                {
                    cell.lbl_Score.isHidden = false
                    cell.lbl_Over.isHidden = false
                    cell.Bowls.isHidden = true
                    cell.Four.isHidden = true
                    cell.Runs.isHidden = true
                    cell.Six.isHidden = true
                    cell.StrikeRateLbl.isHidden = true
                    
                    cell.StatusLBL.text = ""
                    cell.BatsmanAndStatus.text = "FALL OF WICKETS"
                    cell.Bowls.text = ""
                    cell.Four.text = ""
                    cell.Runs.text = ""//"SCORE"
                    cell.Six.text = ""//"OVER"
                    cell.lbl_Score.text = "SCORE"
                    cell.lbl_Over.text = "OVER"
                    cell.StrikeRateLbl.text = ""
                    cell.BatsmanAndStatus.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    cell.Bowls.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    cell.Four.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    cell.Runs.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    cell.Six.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    cell.StrikeRateLbl.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    cell.lbl_Score.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    cell.lbl_Over.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    
                    cell.StatusLBL.font = UIFont(name: "Lato-Semibold", size: 11.0)
                    cell.BatsmanAndStatus.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.Bowls.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.Four.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.Runs.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.Six.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.StrikeRateLbl.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.lbl_Score.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.lbl_Over.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.backView.backgroundColor = .groupTableViewBackground
                }
                else if indexPath.row > ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].bowling?.count)!+4
                {
                    cell.lbl_Score.isHidden = false
                    cell.lbl_Over.isHidden = false
                    cell.Bowls.isHidden = true
                    cell.Four.isHidden = true
                    cell.Runs.isHidden = true
                    cell.Six.isHidden = true
                    cell.StrikeRateLbl.isHidden = true
                    
                    let count = ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].bowling?.count)! + 5
                    
                    cell.StatusLBL.text = ""
                    cell.BatsmanAndStatus.text = fow[indexPath.row-count].n
                    cell.Bowls.text = ""
                    cell.Four.text = ""
                    cell.Runs.text = ""//"\((fow[indexPath.row-count].s) ?? "0")"
                    cell.Six.text = ""//"\((fow[indexPath.row-count].o) ?? "0")"
                    cell.lbl_Score.text = "\((fow[indexPath.row-count].s) ?? "0")" + "/" + "\(indexPath.row-count + 1)"
                    cell.lbl_Over.text = "\((fow[indexPath.row-count].o) ?? "0")"
                    cell.StrikeRateLbl.text = ""
                    cell.BatsmanAndStatus.textColor = UIColor.black
                    cell.Bowls.textColor = UIColor.black
                    cell.Four.textColor = UIColor.black
                    cell.Runs.textColor = UIColor.black
                    cell.Six.textColor = UIColor.black
                    cell.StrikeRateLbl.textColor = UIColor.black
                    cell.lbl_Score.textColor = UIColor.black
                    cell.lbl_Over.textColor = UIColor.black
                    
                    cell.StatusLBL.font = UIFont(name: "Lato-Semibold", size: 11.0)
                    cell.BatsmanAndStatus.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.Bowls.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.Four.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.Runs.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.Six.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.StrikeRateLbl.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.lbl_Score.font = UIFont(name: "Lato-Medium", size: 13.0)
                    cell.lbl_Over.font = UIFont(name: "Lato-Medium", size: 13.0)
                    
                    cell.backView.backgroundColor = .clear
                    
                }
            }
            else{
                cell.lbl_Score.isHidden = true
                cell.lbl_Over.isHidden = true
                cell.Bowls.isHidden = false
                cell.Four.isHidden = false
                cell.Runs.isHidden = false
                cell.Six.isHidden = false
                cell.StrikeRateLbl.isHidden = false
                
                if indexPath.row == 0
                {
                    
                    cell.StatusLBL.text = ""
                    cell.BatsmanAndStatus.text = "BATSMAN"
                    cell.BatsmanAndStatus.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.Bowls.text = "B"
                    cell.Bowls.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.Four.text = "4s"
                    cell.Four.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.Runs.text = "R"
                    cell.Runs.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.Six.text = "6s"
                    cell.Six.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.StrikeRateLbl.text = "SR"
                    cell.StrikeRateLbl.font = UIFont(name: "Lato-Bold", size: 15.0)
                    
                    cell.StatusLBL.font = UIFont(name: "Lato-Semibold", size: 11.0)
                    cell.BatsmanAndStatus.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    cell.Bowls.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    cell.Four.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    cell.Runs.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    cell.Six.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    cell.StrikeRateLbl.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    cell.backView.backgroundColor = .groupTableViewBackground
                    
                }
                else if indexPath.row < ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+1
                {
                    cell.StatusLBL.text = (scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?[indexPath.row-1].batting?.out_str
                    cell.BatsmanAndStatus.text = (scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?[indexPath.row-1].name ?? "-"
                    cell.Bowls.text = "\(((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?[indexPath.row-1].batting?.balls) ?? 0)"
                    cell.Four.text = "\(((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?[indexPath.row-1].batting?.fours) ?? 0)"
                    cell.Runs.text = "\(((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?[indexPath.row-1].batting?.runs) ?? 0)"
                    cell.Six.text = "\(((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?[indexPath.row-1].batting?.sixes) ?? 0)"
                    cell.StrikeRateLbl.text = "\(((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?[indexPath.row-1].batting?.strike_rate) ?? 0)"
                    cell.BatsmanAndStatus.textColor = UIColor.black
                    cell.Bowls.textColor = UIColor.black
                    cell.Four.textColor = UIColor.black
                    cell.Runs.textColor = UIColor.black
                    cell.Six.textColor = UIColor.black
                    cell.StrikeRateLbl.textColor = UIColor.black
                    cell.StatusLBL.textColor = AppHelper.hexStringToUIColor(hex: "D52618")
                    cell.BatsmanAndStatus.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.Bowls.font = UIFont(name: "Lato-Medium", size: 13.0)
                    cell.Four.font = UIFont(name: "Lato-Medium", size: 13.0)
                    cell.Runs.font = UIFont(name: "Lato-Medium", size: 13.0)
                    cell.Six.font = UIFont(name: "Lato-Medium", size: 13.0)
                    cell.StrikeRateLbl.font = UIFont(name: "Lato-Medium", size: 13.0)
                    cell.StatusLBL.font = UIFont(name: "Lato-Semibold", size: 11.0)
                    cell.backView.backgroundColor = .clear
                    
                }
                else if indexPath.row == ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+1
                {
                    cell.StatusLBL.text = ""
                    cell.BatsmanAndStatus.text = ""
                    cell.Bowls.text = ""
                    cell.Four.text = ""
                    cell.Runs.text = ""
                    cell.Six.text = ""
                    cell.StrikeRateLbl.text = ""
                    
                    cell.BatsmanAndStatus.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.Bowls.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.Four.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.Runs.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.Six.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.StrikeRateLbl.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.backView.backgroundColor = .clear
                    
                }
                else if indexPath.row == ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+2
                {
                    cell.StatusLBL.text = ""
                    cell.BatsmanAndStatus.text = "BOWLER"
                    cell.Bowls.text = "M"
                    cell.Four.text = "R"
                    cell.Runs.text = "O"
                    cell.Six.text = "W"
                    cell.StrikeRateLbl.text = "ER"
                    cell.BatsmanAndStatus.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    cell.Bowls.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    cell.Four.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    cell.Runs.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    cell.Six.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    cell.StrikeRateLbl.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                    
                    cell.StatusLBL.font = UIFont(name: "Lato-Semibold", size: 11.0)
                    cell.BatsmanAndStatus.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.Bowls.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.Four.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.Runs.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.Six.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.StrikeRateLbl.font = UIFont(name: "Lato-Bold", size: 15.0)
                    cell.backView.backgroundColor = .groupTableViewBackground
                    
                }
                else if indexPath.row > ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+2
                {
                    let count = ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)! + 3
                    cell.StatusLBL.text = ""
                    cell.BatsmanAndStatus.text = (scorecardData.responseData?.match?.inn_order)![indexPath.section-1].bowling?[indexPath.row-count].name
                    cell.Bowls.text = "\(((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].bowling?[indexPath.row-count].bowling?.maiden_overs) ?? 0)"
                    cell.Four.text = "\(((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].bowling?[indexPath.row-count].bowling?.runs) ?? 0)"
                    cell.Runs.text = "\(((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].bowling?[indexPath.row-count].bowling?.overs) ?? "0")"
                    cell.Six.text = "\(((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].bowling?[indexPath.row-count].bowling?.wickets) ?? 0)"
                    cell.StrikeRateLbl.text = "\(((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].bowling?[indexPath.row-count].bowling?.economy) ?? 0)"
                    cell.BatsmanAndStatus.textColor = UIColor.black
                    cell.Bowls.textColor = UIColor.black
                    cell.Four.textColor = UIColor.black
                    cell.Runs.textColor = UIColor.black
                    cell.Six.textColor = UIColor.black
                    cell.StrikeRateLbl.textColor = UIColor.black
                    
                    cell.BatsmanAndStatus.font = UIFont(name: "Lato-Medium", size: 15.0)
                    cell.Bowls.font = UIFont(name: "Lato-Medium", size: 13.0)
                    cell.Four.font = UIFont(name: "Lato-Medium", size: 13.0)
                    cell.Runs.font = UIFont(name: "Lato-Medium", size: 13.0)
                    cell.Six.font = UIFont(name: "Lato-Medium", size: 13.0)
                    cell.StrikeRateLbl.font = UIFont(name: "Lato-Medium", size: 13.0)
                    cell.backView.backgroundColor = .clear
                    
                }
            }
        }
        
        
        return cell
    }

    
    @IBAction func scoreBtnAct(_ sender: Any){
            //showNativeAd()
        if scorecardData.responseData?.match?.inn_order?.count == 0{
            noScoreLbl.isHidden = false
        }
        else{
            tvScoreCard.reloadData()
            noScoreLbl.isHidden = true
            let indices: IndexSet = [scorecardData.responseData?.match?.inn_order?.count ?? 1]
            self.tvScoreCard.beginUpdates()
            self.tvScoreCard.reloadSections(indices, with: UITableViewRowAnimation.automatic)
            self.tvScoreCard.endUpdates()
        }
        
        if scorecardData.responseData?.match?.inn_order?.count == 1
        {
            teamOnei1ScoreboardSelected = true
        }
        else if scorecardData.responseData?.match?.inn_order?.count == 2
        {
            teamTwoi1ScoreboardSelected = true
        }
        else if scorecardData.responseData?.match?.inn_order?.count == 3
        {
            teamOnei2ScoreboardSelected = true
        }
        else if scorecardData.responseData?.match?.inn_order?.count == 4
        {
            teamTwoi2ScoreboardSelected = true
        }
    }
    func setScoreCard(){
        //showNativeAd()
        
        if scorecardData.responseData?.match?.inn_order?.count == 1
        {
            teamOnei1ScoreboardSelected = true
        }
        else if scorecardData.responseData?.match?.inn_order?.count == 2
        {
            teamTwoi1ScoreboardSelected = true
        }
        else if scorecardData.responseData?.match?.inn_order?.count == 3
        {
            teamOnei2ScoreboardSelected = true
        }
        else if scorecardData.responseData?.match?.inn_order?.count == 4
        {
            teamTwoi2ScoreboardSelected = true
        }
        
        if scorecardData.responseData?.match?.inn_order?.count == 0{
            noScoreLbl.isHidden = false
        }
        else{
            tvScoreCard.reloadData()
            noScoreLbl.isHidden = true
            let indices: IndexSet = [scorecardData.responseData?.match?.inn_order?.count ?? 1]
            self.tvScoreCard.beginUpdates()
            self.tvScoreCard.reloadSections(indices, with: UITableViewRowAnimation.automatic)
            self.tvScoreCard.endUpdates()
        }
    }
}
extension ScorecardLiveLine:UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if ((scorecardData.responseData?.match?.inn_order?.count) ?? 0) == 0{
            return 0
        }
        else{
            return ((scorecardData.responseData?.match?.inn_order?.count) ?? 0) + 2
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        if section == 0 || section == ((scorecardData.responseData?.match?.inn_order?.count) ?? 0) + 1
        {
            return 0
        }
        else if section == 1
        {
            if teamOnei1ScoreboardSelected
            {
                if let noBat = (scorecardData.responseData?.match?.inn_order)![section-1].no_bat, noBat != ""{
                    if let fow = (scorecardData.responseData?.match?.inn_order)![section-1].fow, fow.count > 0{
                        return ((scorecardData.responseData?.match?.inn_order)![section-1].batting?.count)!+((scorecardData.responseData?.match?.inn_order)![section-1].bowling?.count)!+fow.count+6
                    }
                    else{
                        return ((scorecardData.responseData?.match?.inn_order)![section-1].batting?.count)!+((scorecardData.responseData?.match?.inn_order)![section-1].bowling?.count)!+4
                    }
                }
                else{
                    if let fow = (scorecardData.responseData?.match?.inn_order)![section-1].fow, fow.count > 0{
                        return ((scorecardData.responseData?.match?.inn_order)![section-1].batting?.count)!+((scorecardData.responseData?.match?.inn_order)![section-1].bowling?.count)!+fow.count+5
                    }
                    else{
                        return ((scorecardData.responseData?.match?.inn_order)![section-1].batting?.count)!+((scorecardData.responseData?.match?.inn_order)![section-1].bowling?.count)!+3
                    }
                }
                
                
            }
            else
            {
                return 0
            }
        }
        else if section == 2
        {
            if teamTwoi1ScoreboardSelected
            {
                if let noBat = (scorecardData.responseData?.match?.inn_order)![section-1].no_bat, noBat != ""{
                    if let fow = (scorecardData.responseData?.match?.inn_order)![section-1].fow, fow.count > 0{
                        return ((scorecardData.responseData?.match?.inn_order)![section-1].batting?.count)!+((scorecardData.responseData?.match?.inn_order)![section-1].bowling?.count)!+fow.count+6
                    }
                    else{
                        return ((scorecardData.responseData?.match?.inn_order)![section-1].batting?.count)!+((scorecardData.responseData?.match?.inn_order)![section-1].bowling?.count)!+4
                    }
                }
                else{
                    if let fow = (scorecardData.responseData?.match?.inn_order)![section-1].fow, fow.count > 0{
                        return ((scorecardData.responseData?.match?.inn_order)![section-1].batting?.count)!+((scorecardData.responseData?.match?.inn_order)![section-1].bowling?.count)!+fow.count+5
                    }
                    else{
                        return ((scorecardData.responseData?.match?.inn_order)![section-1].batting?.count)!+((scorecardData.responseData?.match?.inn_order)![section-1].bowling?.count)!+3
                    }
                }
                
                
            }
            else
            {
                return 0
            }
        }
        else if section == 3
        {
            if teamOnei2ScoreboardSelected
            {
                if let noBat = (scorecardData.responseData?.match?.inn_order)![section-1].no_bat, noBat != ""{
                    if let fow = (scorecardData.responseData?.match?.inn_order)![section-1].fow, fow.count > 0{
                        return ((scorecardData.responseData?.match?.inn_order)![section-1].batting?.count)!+((scorecardData.responseData?.match?.inn_order)![section-1].bowling?.count)!+fow.count+6
                    }
                    else{
                        return ((scorecardData.responseData?.match?.inn_order)![section-1].batting?.count)!+((scorecardData.responseData?.match?.inn_order)![section-1].bowling?.count)!+4
                    }
                }
                else{
                    if let fow = (scorecardData.responseData?.match?.inn_order)![section-1].fow, fow.count > 0{
                        return ((scorecardData.responseData?.match?.inn_order)![section-1].batting?.count)!+((scorecardData.responseData?.match?.inn_order)![section-1].bowling?.count)!+fow.count+5
                    }
                    else{
                        return ((scorecardData.responseData?.match?.inn_order)![section-1].batting?.count)!+((scorecardData.responseData?.match?.inn_order)![section-1].bowling?.count)!+3
                    }
                }
            }
            else
            {
                return 0
            }
        }
        else if section == 4
        {
            if teamTwoi2ScoreboardSelected
            {
                if let noBat = (scorecardData.responseData?.match?.inn_order)![section-1].no_bat, noBat != ""{
                    if let fow = (scorecardData.responseData?.match?.inn_order)![section-1].fow, fow.count > 0{
                        return ((scorecardData.responseData?.match?.inn_order)![section-1].batting?.count)!+((scorecardData.responseData?.match?.inn_order)![section-1].bowling?.count)!+fow.count+6
                    }
                    else{
                        return ((scorecardData.responseData?.match?.inn_order)![section-1].batting?.count)!+((scorecardData.responseData?.match?.inn_order)![section-1].bowling?.count)!+4
                    }
                }
                else{
                    if let fow = (scorecardData.responseData?.match?.inn_order)![section-1].fow, fow.count > 0{
                        return ((scorecardData.responseData?.match?.inn_order)![section-1].batting?.count)!+((scorecardData.responseData?.match?.inn_order)![section-1].bowling?.count)!+fow.count+5
                    }
                    else{
                        return ((scorecardData.responseData?.match?.inn_order)![section-1].batting?.count)!+((scorecardData.responseData?.match?.inn_order)![section-1].bowling?.count)!+3
                    }
                }
                
            }
            else
            {
                return 0
            }
        }
        else{
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "BatsmanCell") as! BatsmanCell
        return setBatsmanCell(cell:cell,indexPath:indexPath)
    }
}

extension ScorecardLiveLine:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if indexPath.section == 0
        {
            return 0
        }
        /*if indexPath.row == ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+1 || indexPath.row == 0 || indexPath.row > ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+1
         {
         return 45
         }*/
        if let noBat = (scorecardData.responseData?.match?.inn_order)![indexPath.section-1].no_bat, noBat != ""{
            if let fow = (scorecardData.responseData?.match?.inn_order)![indexPath.section-1].fow, fow.count > 0{
                if indexPath.row == 0 || indexPath.row == ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].bowling?.count)!+5 || indexPath.row == ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+3{
                    
                    return 45
                }
                else if indexPath.row == ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+2 || indexPath.row == ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].bowling?.count)!+4
                {
                    
                    return 30
                }
                else if indexPath.row > ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+3 && indexPath.row < ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].bowling?.count)!+4 || indexPath.row > ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].bowling?.count)!+5
                {
                    return 45
                }
                else{
                    return 65
                }
            }
            else{
                if indexPath.row == 0 || indexPath.row == ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+3{
                    
                    return 45
                }
                else if indexPath.row == ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+2
                {
                    return 30
                }
                else if indexPath.row > ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+3
                {
                    return 45
                }
                else
                {
                    return 65
                }
            }
        }
        else{
            if let fow = (scorecardData.responseData?.match?.inn_order)![indexPath.section-1].fow, fow.count > 0{
                if indexPath.row == 0 || indexPath.row == ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].bowling?.count)!+4 || indexPath.row == ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+2{
                    
                    return 45
                }
                else if indexPath.row == ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+1
                    || indexPath.row == ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].bowling?.count)!+3
                {
                    return 30
                }
                else if indexPath.row > ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+2 && indexPath.row < ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].bowling?.count)!+3 || indexPath.row > ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].bowling?.count)!+4
                {
                    return 45
                }
                else{
                    return 65
                }
            }
            else{
                if indexPath.row == 0 || indexPath.row == ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+2{
                    return 45
                }
                else if indexPath.row == ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+1
                {
                    return 30
                }
                else if indexPath.row > ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+2
                {
                    return 45
                }
                else{
                    return 65
                }
            }
        }
        
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        
        return (((scorecardData.responseData?.match?.inn_order?.count) ?? 0) + 1) != section ? 60 : 180
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        if section == 0
        {
            let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TitleCell") as! TitleCell
            cell.lblTitle.textColor = AppHelper.hexStringToUIColor(hex: "D52618")
            cell.lblTitle.font = UIFont(name: "Lato-Medium", size: 16.0)
            if let result = scorecardData.responseData?.match?.result, result != ""{
                cell.lblTitle.text = result
            }
            else{
                if let toss = scorecardData.responseData?.match?.toss, toss != ""{
                    cell.lblTitle.text = toss
                }
                else{
                    cell.lblTitle.text = "Match Score"
                }
            }
            return cell
        }
        else if section == ((scorecardData.responseData?.match?.inn_order?.count) ?? 0) + 1
        {
            let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CellBannerAdTableViewCell") as! CellBannerAdTableViewCell
            cell.bannerView.adUnitID = AppHelper.appDelegate().adBannerUnitID as String
            cell.bannerView.rootViewController = self
            cell.bannerView.load(GADRequest())
            if nativeAds.count > 0{
                if nativeAds.count == 1{
                    if let adView = cell.contentView.subviews[1] as? GADUnifiedNativeAdView
                    {
                        nativeAds[0].rootViewController = self
                        adView.nativeAd = nativeAds[0]
                        (adView.headlineView as! UILabel).text = nativeAds[0].headline
                        (adView.bodyView as! UILabel).text = nativeAds[0].body
                        (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
                        (adView.callToActionView as! UIButton).setTitle(
                            nativeAds[0].callToAction, for: UIControlState.normal)
                    }
                }
                else if nativeAds.count == 2{
                    if let adView = cell.contentView.subviews[1] as? GADUnifiedNativeAdView
                    {
                        nativeAds[1].rootViewController = self
                        adView.nativeAd = nativeAds[1]
                        (adView.headlineView as! UILabel).text = nativeAds[1].headline
                        (adView.bodyView as! UILabel).text = nativeAds[1].body
                        (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
                        (adView.callToActionView as! UIButton).setTitle(
                            nativeAds[1].callToAction, for: UIControlState.normal)
                    }
                }
                else {
                    if let adView = cell.contentView.subviews[1] as? GADUnifiedNativeAdView
                    {
                        nativeAds[2].rootViewController = self
                        adView.nativeAd = nativeAds[2]
                        (adView.headlineView as! UILabel).text = nativeAds[2].headline
                        (adView.bodyView as! UILabel).text = nativeAds[2].body
                        (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
                        (adView.callToActionView as! UIButton).setTitle(
                            nativeAds[2].callToAction, for: UIControlState.normal)
                    }
                }
            }
            return cell
        }
        else
        {
            let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SquadTeamCell") as! SquadTeamCell
            cell.sectionBtn.tag = section
            cell.lblScore.isHidden = false
            cell.sectionBtn.addTarget(self, action: #selector(self.scoreboardSectionBtnAct(sender:)), for: UIControlEvents.touchUpInside)
            let score = scorecardData.responseData?.match?.inn_order?[section-1].team_info?.runs!
            let wicket = scorecardData.responseData?.match?.inn_order?[section-1].team_info?.wickets!
            let over = scorecardData.responseData?.match?.inn_order?[section-1].team_info?.overs!
            cell.lblScore.text = "\(score!)-\(wicket!) (\(over!))"
            cell.lblTeam.text = scorecardData.responseData?.match?.inn_order?[section-1].team_info?.key?.uppercased()//scorecardData.responseData?.match?.inn_order?[section-1].team_info?.name
            cell.lblTeam.textColor = UIColor.white
            cell.lblScore.textColor = UIColor.white
            if  (section == 1 && teamOnei1ScoreboardSelected) || (section == 2 && teamTwoi1ScoreboardSelected) || (section == 3 && teamOnei2ScoreboardSelected) || (section == 4 && teamTwoi2ScoreboardSelected)
            {
                cell.imgArrow.image = #imageLiteral(resourceName: "arrowUp")
            }
            else
            {
                cell.imgArrow.image = #imageLiteral(resourceName: "arrowDown")
            }
            return cell
        }

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if let noBat = (scorecardData.responseData?.match?.inn_order)![indexPath.section-1].no_bat, noBat != ""
        {
            if let fow = (scorecardData.responseData?.match?.inn_order)![indexPath.section-1].fow, fow.count > 0
            {
                if indexPath.row < ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+1 && indexPath.row != 0
                {
                    if let key = (scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?[indexPath.row-1].key{
                        if let name = (scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?[indexPath.row-1].name{
                            let playerDetailVC = AppStoryboard.browsePlayer.instantiateViewController(withIdentifier: PlayerDetailVC.className) as! PlayerDetailVC
                            playerDetailVC.getTeamIdFromPrevClassScoreCard(key:key , navTitle: name)
                            self.navigationController?.pushViewController(playerDetailVC, animated: true)
                            tableView.deselectRow(at: indexPath, animated: true)
                        }
                    }
                }
                else if indexPath.row > ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+3 && indexPath.row < ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].bowling?.count)!+4
                {
                    let count = ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)! + 4
                    
                    if let key = (scorecardData.responseData?.match?.inn_order)![indexPath.section-1].bowling?[indexPath.row-count].key{
                        if let name = (scorecardData.responseData?.match?.inn_order)![indexPath.section-1].bowling?[indexPath.row-count].name{
                            let playerDetailVC = AppStoryboard.browsePlayer.instantiateViewController(withIdentifier: PlayerDetailVC.className) as! PlayerDetailVC
                            playerDetailVC.getTeamIdFromPrevClassScoreCard(key:key , navTitle: name)
                            self.navigationController?.pushViewController(playerDetailVC, animated: true)
                            tableView.deselectRow(at: indexPath, animated: true)
                        }
                    }
                }
                else if indexPath.row > ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].bowling?.count)!+5
                {
                    let count = ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].bowling?.count)! + 6
                    if let key = fow[indexPath.row-count].k{
                        if let name = fow[indexPath.row-count].n{
                            let playerDetailVC = AppStoryboard.browsePlayer.instantiateViewController(withIdentifier: PlayerDetailVC.className) as! PlayerDetailVC
                            playerDetailVC.getTeamIdFromPrevClassScoreCard(key:key , navTitle: name)
                            self.navigationController?.pushViewController(playerDetailVC, animated: true)
                            tableView.deselectRow(at: indexPath, animated: true)
                        }
                    }
                }
            }
            else
            {
                if indexPath.row < ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+1 && indexPath.row != 0
                {
                    if let key = (scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?[indexPath.row-1].key{
                        if let name = (scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?[indexPath.row-1].name{
                            let playerDetailVC = AppStoryboard.browsePlayer.instantiateViewController(withIdentifier: PlayerDetailVC.className) as! PlayerDetailVC
                            playerDetailVC.getTeamIdFromPrevClassScoreCard(key:key , navTitle: name)
                            self.navigationController?.pushViewController(playerDetailVC, animated: true)
                            tableView.deselectRow(at: indexPath, animated: true)
                        }
                    }
                }
                else if indexPath.row > ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+3
                {
                    let count = ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)! + 4
                    if let key = (scorecardData.responseData?.match?.inn_order)![indexPath.section-1].bowling?[indexPath.row-count].key{
                        if let name = (scorecardData.responseData?.match?.inn_order)![indexPath.section-1].bowling?[indexPath.row-count].name{
                            let playerDetailVC = AppStoryboard.browsePlayer.instantiateViewController(withIdentifier: PlayerDetailVC.className) as! PlayerDetailVC
                            playerDetailVC.getTeamIdFromPrevClassScoreCard(key:key , navTitle: name)
                            self.navigationController?.pushViewController(playerDetailVC, animated: true)
                            tableView.deselectRow(at: indexPath, animated: true)
                        }
                    }
                }
            }
        }
        else
        {
            if let fow = (scorecardData.responseData?.match?.inn_order)![indexPath.section-1].fow, fow.count > 0
            {
                if indexPath.row < ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+1 && indexPath.row != 0
                {
                    if let key = (scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?[indexPath.row-1].key{
                        if let name = (scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?[indexPath.row-1].name{
                            let playerDetailVC = AppStoryboard.browsePlayer.instantiateViewController(withIdentifier: PlayerDetailVC.className) as! PlayerDetailVC
                            playerDetailVC.getTeamIdFromPrevClassScoreCard(key:key , navTitle: name)
                            self.navigationController?.pushViewController(playerDetailVC, animated: true)
                            tableView.deselectRow(at: indexPath, animated: true)
                        }
                    }
                }
                else if indexPath.row > ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+2 && indexPath.row < ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].bowling?.count)!+3
                {
                    let count = ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)! + 3
                    if let key = (scorecardData.responseData?.match?.inn_order)![indexPath.section-1].bowling?[indexPath.row-count].key{
                        if let name = (scorecardData.responseData?.match?.inn_order)![indexPath.section-1].bowling?[indexPath.row-count].name{
                            let playerDetailVC = AppStoryboard.browsePlayer.instantiateViewController(withIdentifier: PlayerDetailVC.className) as! PlayerDetailVC
                            playerDetailVC.getTeamIdFromPrevClassScoreCard(key:key , navTitle: name)
                            self.navigationController?.pushViewController(playerDetailVC, animated: true)
                            tableView.deselectRow(at: indexPath, animated: true)
                        }
                    }
                }
                else if indexPath.row > ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].bowling?.count)!+4
                {
                    let count = ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].bowling?.count)! + 5
                    if let key = fow[indexPath.row-count].k{
                        if let name = fow[indexPath.row-count].n{
                            let playerDetailVC = AppStoryboard.browsePlayer.instantiateViewController(withIdentifier: PlayerDetailVC.className) as! PlayerDetailVC
                            playerDetailVC.getTeamIdFromPrevClassScoreCard(key:key , navTitle: name)
                            self.navigationController?.pushViewController(playerDetailVC, animated: true)
                            tableView.deselectRow(at: indexPath, animated: true)
                        }
                    }
                }
            }
            else
            {
                if indexPath.row < ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+1 && indexPath.row != 0
                {
                    if let key = (scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?[indexPath.row-1].key{
                        if let name = (scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?[indexPath.row-1].name{
                            let playerDetailVC = AppStoryboard.browsePlayer.instantiateViewController(withIdentifier: PlayerDetailVC.className) as! PlayerDetailVC
                            playerDetailVC.getTeamIdFromPrevClassScoreCard(key:key , navTitle: name)
                            self.navigationController?.pushViewController(playerDetailVC, animated: true)
                            tableView.deselectRow(at: indexPath, animated: true)
                        }
                    }
                    
                }
                else if indexPath.row > ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)!+2
                {
                    let count = ((scorecardData.responseData?.match?.inn_order)![indexPath.section-1].batting?.count)! + 3
                    if let key = (scorecardData.responseData?.match?.inn_order)![indexPath.section-1].bowling?[indexPath.row-count].key{
                        if let name = (scorecardData.responseData?.match?.inn_order)![indexPath.section-1].bowling?[indexPath.row-count].name{
                            let playerDetailVC = AppStoryboard.browsePlayer.instantiateViewController(withIdentifier: PlayerDetailVC.className) as! PlayerDetailVC
                            playerDetailVC.getTeamIdFromPrevClassScoreCard(key:key , navTitle: name)
                            self.navigationController?.pushViewController(playerDetailVC, animated: true)
                            tableView.deselectRow(at: indexPath, animated: true)
                        }
                    }
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return CGFloat.leastNormalMagnitude
    }
}

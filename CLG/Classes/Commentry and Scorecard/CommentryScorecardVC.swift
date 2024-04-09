//
//  CommentryScorecardVC.swift
//  CLG
//
//  Created by Anuj Naruka on 8/16/18.
//  Copyright © 2018 Anuj Naruka. All rights reserved.
//

import UIKit
import GoogleMobileAds
import Firebase
import AlamofireImage

class CommentryScorecardVC: BaseViewController {

    //MARK:- Variables & Constants
    @IBOutlet weak var commentryBtn: UIButton!
    @IBOutlet weak var scoreBtn: UIButton!
    @IBOutlet weak var infoBtn: UIButton!
    @IBOutlet weak var squadBtn: UIButton!
    @IBOutlet weak var noCommentryLbl: UILabel!
    @IBOutlet weak var selectedTabConstraint: NSLayoutConstraint!
    @IBOutlet weak var selectedTabWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var tvCommentryScorecard: UITableView!
    @IBOutlet weak var gadBannerView: GADBannerView!
    @IBOutlet weak var bannerHeight: NSLayoutConstraint!


    //MARK:- IBOutlets
    var adLoader = GADAdLoader()
    let numAdsToLoad = 5
    var nativeAds = [GADUnifiedNativeAd]()
    var interstitialAds: GADInterstitial!
    var titleLbl = String()
    var selectedBtn = 1
    var teamOneSelected = false
    var teamTwoSelected = false
    var teamOnei1ScoreboardSelected = false
    var teamTwoi1ScoreboardSelected = false
    var teamOnei2ScoreboardSelected = false
    var teamTwoi2ScoreboardSelected = false
    var matchKey = String()
    var scorecardData = CLGScorcardApi()
    var commentryData = CLGCommentryResponseData()
    var refreshControl = UIRefreshControl()
    var timer = Timer()
    var isLoading = false
    var isComingFromMatchLine = false
    var isCommentryAvailable = Bool()
    var totalCount = Int()
    let arr = ["Series :","Match :","Date & Time :","Venue :","Toss :","Result :"]
    var matchStatus = String()
    var isScrolling = false
    var bannerAdView: FBAdView!

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.loadFbBannerAd()
//        self.interstitialAds = createAndLoadInterstitial()
        let appDel = UIApplication.shared.delegate as! AppDelegate
        if (appDel.fbInterstitialAd != nil) && appDel.fbInterstitialAd.isAdValid && appDel.toShowInterstitial {
            appDel.fbInterstitialAd.show(fromRootViewController: self)
            appDel.fbInterstitialAd = nil
            appDel.fbInterstitialAd = appDel.loadInterstitialFbAd()
            appDel.toShowInterstitial = false
            appDel.runTimer()
        }
//        showGoogleAds()
        setTopBar()
        self.registerHeaderFooterNib(tv: tvCommentryScorecard, cellName: "MatchLineInfoHeaderCell")
        self.registerHeaderFooterNib(tv: tvCommentryScorecard, cellName: "TitleCell")
        self.registerHeaderFooterNib(tv: tvCommentryScorecard, cellName: "SquadTeamCell")
        self.registerHeaderFooterNib(tv: tvCommentryScorecard, cellName: "CommentryScoreCell")
        self.registerHeaderFooterNib(tv: tvCommentryScorecard, cellName: "CellBannerAdTableViewCell")
        self.registerNib(tv: tvCommentryScorecard, cellName: "SquadPlayerCell")
        self.registerNib(tv: tvCommentryScorecard, cellName: "ManOfMatchCell")
        self.registerNib(tv: tvCommentryScorecard, cellName: "InfoCell")
        self.registerNib(tv: tvCommentryScorecard, cellName: "BatsmanCell")
        self.registerNib(tv: tvCommentryScorecard, cellName: "BallByBallCell")
        self.registerNib(tv: tvCommentryScorecard, cellName: "OverSummeryCell")
        self.tvCommentryScorecard.tableFooterView = UIView()
        self.selectedTabWidthConstraint.constant = commentryBtn.frame.width
        AppHelper.showHud(type:2)
        self.hitScoreboardApi()
        self.hitCommentryApi(showLoader:false)
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(sender:)), for: UIControlEvents.valueChanged)
        tvCommentryScorecard.addSubview(refreshControl) // not required when using UITableViewController
        // Do any additional setup after loading the view.
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if matchStatus == "started" || matchStatus == "L"{
            timer = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(self.CommentTimer(_:)), userInfo: nil, repeats: true)
        }
//        showNativeAd()
//        self.loadFbBannerAd()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.timer.invalidate()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    private func setTopBar(){
        self.setupNavigationBarTitle(titleLbl, navBG: "", leftBarButtonsType: [.back], rightBarButtonsType: [])
//        self.hideNavigationBar(false)
    }
    private func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial =
            GADInterstitial(adUnitID: AppHelper.appDelegate().adInterstitialUnitID)
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    @objc func CommentTimer(_ timer: Timer)
    {
        if commentryData.responseData?.balls != nil, (commentryData.responseData?.balls?.count)! > 0
        {
            if let ballCount = commentryData.responseData?.balls?.first?.ball_count{
                self.isLoading = true
                self.hitCommentryApi(MIN:ballCount+1, MAX:ballCount+31, showLoader:false)
            }
        }
    }
    @objc func squadSectionBtnAct(sender:UIButton)
    {
        if selectedBtn == 4
        {
            if sender.tag == 1
            {
                teamOneSelected = !teamOneSelected

            }
            else
            {
                teamTwoSelected = !teamTwoSelected
                
            }
            let indices: IndexSet = [sender.tag]
            self.tvCommentryScorecard.beginUpdates()
            self.tvCommentryScorecard.reloadSections(indices, with: UITableViewRowAnimation.automatic)
            self.tvCommentryScorecard.endUpdates()
        }
    }
    @objc func refresh(sender:AnyObject)
    {
       if let ballCount = self.commentryData.responseData?.balls,
        ballCount.count > 0,
        ballCount.first?.ball_count != nil
       {
//        if ballCount == totalCount
//        {
//            self.hitCommentryApi(MIN:totalCount, MAX:totalCount+30, showLoader:false)
//        }
//        else
//        {
            self.hitCommentryApi(MIN:ballCount.first!.ball_count!+1, MAX:ballCount.first!.ball_count!+31, showLoader:false)
//        }
        }
    }
    @objc func scoreboardSectionBtnAct(sender:UIButton)
    {
        if selectedBtn == 2
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
            self.tvCommentryScorecard.beginUpdates()
            self.tvCommentryScorecard.reloadSections(indices, with: UITableViewRowAnimation.automatic)
            self.tvCommentryScorecard.endUpdates()
        }
    }
    private func showGoogleAds()
    {
//        self.gadBannerView.adUnitID = AppHelper.appDelegate().adBannerUnitID as String
//        self.gadBannerView.rootViewController = self
        //self.gadBannerView.load(GADRequest())
        self.gadBannerView.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadBannerAd()
    }
    //MARK:-Func
    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to:size, with:coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.loadBannerAd()
        })
    }
    func loadBannerAd() {
        let frame = { () -> CGRect in
            if #available(iOS 11.0, *) {
                return UIEdgeInsetsInsetRect(view.bounds , view.safeAreaInsets)
            } else {
                return view.frame
            }
        }()
        let viewWidth = frame.size.width
        
//        gadBannerView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
//        gadBannerView.load(GADRequest())
    }
    
    @objc func showNativeAd(){
        nativeAds = AppHelper.appDelegate().returnNativeAdArray()
    }
    @objc func ShowAd(){
        let random = arc4random_uniform(1000) + 10
        //if (random % 2) == 0{
            if self.interstitialAds.isReady
            {
                self.interstitialAds.present(fromRootViewController: self)
            }
        //}
    }
  
    private func hitCommentryApi(MIN:Int=0,MAX:Int=0,showLoader:Bool)
    {
        var param = [String:Any]()
        param["matchKey"] = matchKey
        if MIN != 0 && MAX != 0
        {
            param["minBall"] = "\(MIN)"
            param["maxBall"] = "\(MAX)"
        }
        
        CLGUserService().commentryServiceee(url: NewBaseUrlV4+CLGRecentClass.Commentry, method: .get, showLoader: 0, header: header, parameters: param).then { (data) -> Void in
            print(data.toJSON())
            if data.statusCode == 1{
                if self.isLoading
                {
                    if let ballByBall = data.responseData?.balls//data.responseData?.result?.ballByBall
                    {
                        for item in ballByBall
                        {
                            //                        if let temp = self.commentryData.responseData?.balls,
                            //                            temp.count > 0
                            if let temp = self.commentryData.responseData?.balls,
                                temp.count > 0
                            {
                                for itm in temp
                                {
                                    if itm._id  == item._id
                                    {
                                        return
                                    }
                                }
                            }
                        }
                        /*var tempArr = (self.commentryData.responseData?.balls)!
                         tempArr.append(contentsOf: (data.responseData?.result?.ballByBall)!)
                         self.commentryData.responseData?.balls = tempArr*/
                        var tempArr = (self.commentryData.responseData?.balls)!
                        //tempArr.append(contentsOf: (data.responseData?.balls)!)
                        tempArr.insert(contentsOf: (data.responseData?.balls)!, at: 0)
                        self.commentryData.responseData?.balls = tempArr
                        self.commentryData.responseData?.score = data.responseData?.score
                        self.tvCommentryScorecard.reloadData()
                        self.isLoading = false
                        
                    }
                    
                }
                else if self.isScrolling
                {
                    
                    if let ballByBall = data.responseData?.balls//data.responseData?.result?.ballByBall
                    {
                        for item in ballByBall
                        {
                            //                        if let temp = self.commentryData.responseData?.balls,
                            //                            temp.count > 0
                            if let temp = self.commentryData.responseData?.balls,
                                temp.count > 0
                            {
                                for itm in temp
                                {
                                    if itm._id  == item._id
                                    {
                                        return
                                    }
                                }
                            }
                        }
                        /*var tempArr = (self.commentryData.responseData?.balls)!
                         tempArr.append(contentsOf: (data.responseData?.result?.ballByBall)!)
                         self.commentryData.responseData?.balls = tempArr*/
                        var tempArr = (self.commentryData.responseData?.balls)!
                        tempArr.append(contentsOf: (data.responseData?.balls)!)
                        //tempArr.insert(contentsOf: (data.responseData?.balls)!, at: 0)
                        self.commentryData.responseData?.balls = tempArr
                        self.commentryData.responseData?.score = data.responseData?.score
                        self.tvCommentryScorecard.reloadData()
                        self.isScrolling = false
                    }
                }
                else if self.refreshControl.isRefreshing  || self.commentryData.time != nil
                {
                    if let ballByBall = data.responseData?.balls//data.responseData?.result?.ballByBall
                    {
                    for item in ballByBall
                    {
//                        if let temp = self.commentryData.responseData?.balls,
//                            temp.count > 0
                        if let temp = self.commentryData.responseData?.balls,
                                                    temp.count > 0
                        {
                            for itm in temp
                            {
                                if itm._id  == item._id
                                {
                                   return
                                }
                            }
                        }
                    }
                    /*var tempArr = (self.commentryData.responseData?.balls)!
                    tempArr.insert(contentsOf: (data.responseData?.result?.ballByBall)!, at: 0)
                    self.commentryData.responseData?.balls = tempArr
                    self.commentryData.responseData?.score = data.responseData?.result?.score*/
                    var tempArr = (self.commentryData.responseData?.balls)!
                    tempArr.insert(contentsOf: (data.responseData?.balls)!, at: 0)
                    self.commentryData.responseData?.balls = tempArr
                    self.commentryData.responseData?.score = data.responseData?.score
                    self.tvCommentryScorecard.reloadData()
                    self.refreshControl.endRefreshing()
                    }
                }
                else
                {
                    self.commentryData = data
                    self.tvCommentryScorecard.reloadData()
                }
                if self.isComingFromMatchLine
                {
                    let when = DispatchTime.now() + 30 // change 2 to desired number of seconds
                    DispatchQueue.main.asyncAfter(deadline: when)
                    {
                        self.timer.fire()
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+2, execute: {
                    AppHelper.hideHud()
                    self.noCommentryLbl.isHidden = self.isCommentryAvailable
                })
                //self.totalCount = (self.commentryData.responseData?.total_ball)!
                //self.totalCount = (self.commentryData.responseData?.total)!

            }
            }.catch { (error) in
                print(error)
        }
    }
    private func hitScoreboardApi()
    {
        
        CLGUserService().scorecardServiceee(url: NewBaseUrlV5+CLGRecentClass.Scorecard, method: .get, showLoader: 0, header: header, parameters: ["matchKey":matchKey]).then { (data) -> Void in
            print(data)
            if data.statusCode == 1{
                self.scorecardData = data
                if let responsedata = data.responseData{
                    if let match = responsedata.match{
                        if let titleName = match.sh_name{
                            self.titleLbl = titleName
                            self.setTopBar()
                        }
                    }
                }
                self.tvCommentryScorecard.reloadData()
            }
            }.catch { (error) in
                print(error)
        }
    }
    private func setUnderline(btn:UIButton)
    {
        UIView.animate(withDuration: 0.5, animations: {
            self.selectedTabConstraint.constant = btn.frame.origin.x
            self.selectedTabWidthConstraint.constant = btn.frame.width
            self.view.layoutIfNeeded()
        })
    }
    private func setSquadPlayerCell(cell:SquadPlayerCell,indexPath:IndexPath)->SquadPlayerCell
    {
        if scorecardData.responseData?.match?.teams?.a?.xi?.count != 0 && scorecardData.responseData?.match?.teams?.b?.xi?.count != 0{
        cell.lblPlayerName.text = indexPath.section == 1 ?scorecardData.responseData?.match?.teams?.a?.xi?[indexPath.row].name : scorecardData.responseData?.match?.teams?.b?.xi?[indexPath.row].name
            if indexPath.section == 1{
                if scorecardData.responseData?.match?.teams?.a?.xi?[indexPath.row].key == scorecardData.responseData?.match?.teams?.a?.kpr && scorecardData.responseData?.match?.teams?.a?.xi?[indexPath.row].key == scorecardData.responseData?.match?.teams?.a?.capt{
                    
                    cell.lblPlayerName.text = "\(cell.lblPlayerName.text ?? "") (C & WK)"
                }
                else if scorecardData.responseData?.match?.teams?.a?.xi?[indexPath.row].key == scorecardData.responseData?.match?.teams?.a?.kpr && scorecardData.responseData?.match?.teams?.a?.xi?[indexPath.row].key != scorecardData.responseData?.match?.teams?.a?.capt{
                    
                    cell.lblPlayerName.text = "\(cell.lblPlayerName.text ?? "") (WK)"
                }
                else if scorecardData.responseData?.match?.teams?.a?.xi?[indexPath.row].key != scorecardData.responseData?.match?.teams?.a?.kpr && scorecardData.responseData?.match?.teams?.a?.xi?[indexPath.row].key == scorecardData.responseData?.match?.teams?.a?.capt{
                    
                    cell.lblPlayerName.text = "\(cell.lblPlayerName.text ?? "") (C)"
                }
            }
            else{
                if scorecardData.responseData?.match?.teams?.b?.xi?[indexPath.row].key == scorecardData.responseData?.match?.teams?.b?.kpr && scorecardData.responseData?.match?.teams?.b?.xi?[indexPath.row].key == scorecardData.responseData?.match?.teams?.b?.capt{
                    
                    cell.lblPlayerName.text = "\(cell.lblPlayerName.text ?? "") (C & WK)"
                }
                else if scorecardData.responseData?.match?.teams?.b?.xi?[indexPath.row].key == scorecardData.responseData?.match?.teams?.b?.kpr && scorecardData.responseData?.match?.teams?.b?.xi?[indexPath.row].key != scorecardData.responseData?.match?.teams?.b?.capt{
                    
                    cell.lblPlayerName.text = "\(cell.lblPlayerName.text ?? "") (WK)"
                }
                else if scorecardData.responseData?.match?.teams?.b?.xi?[indexPath.row].key != scorecardData.responseData?.match?.teams?.b?.kpr && scorecardData.responseData?.match?.teams?.b?.xi?[indexPath.row].key == scorecardData.responseData?.match?.teams?.b?.capt{
                    
                    cell.lblPlayerName.text = "\(cell.lblPlayerName.text ?? "") (C)"
                }
            }
        cell.lblPlayerType.text = indexPath.section == 1 ?scorecardData.responseData?.match?.teams?.a?.xi?[indexPath.row].role?.uppercased() : scorecardData.responseData?.match?.teams?.b?.xi?[indexPath.row].role?.uppercased()
        cell.imgPlayer.image = #imageLiteral(resourceName: "TeamPlaceholder")
        if indexPath.section != 1
        {
//        if let image = scorecardData.responseData?.match?.teams?.b?.xi?[indexPath.row].playerId?.playerImage, !image.isBlank
            //if let image = scorecardData.responseData?.match?.teams?.b?.xi?[indexPath.row].key, !image.isBlank
            if let image = scorecardData.responseData?.match?.teams?.b?.xi?[indexPath.row].logo, !image.isBlank
        {
//            cell.imgPlayer.af_setImage(withURL: URL(string: ((scorecardData.responseData?.imageBaseUrl)!+image).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
            //cell.imgPlayer.af_setImage(withURL: URL(string: ((scorecardData.responseData?.pP)!+image+".png").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
            cell.imgPlayer.af_setImage(withURL: URL(string: ((scorecardData.responseData?.pP)!+image))!)
        }
        else
            {
                if let name = scorecardData.responseData?.match?.teams?.b?.xi?[indexPath.row].name{
                    cell.imgPlayer.image = AppHelper.generateImageWithText(text: name, image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:name.uppercased()), size: CGSize(width: 50, height: 50)))
                    
                }
                else{
                    cell.imgPlayer.image = AppHelper.generateImageWithText(text: "N/A", image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:"N/A"), size: CGSize(width: 50, height: 50)))
                    
                }
                
            }
        }
        else
        {
//            if let image = scorecardData.responseData?.match?.teams?.a?.xi?[indexPath.row].playerId?.playerImage, !image.isBlank
            //if let image = scorecardData.responseData?.match?.teams?.a?.xi?[indexPath.row].key, !image.isBlank
            if let image = scorecardData.responseData?.match?.teams?.a?.xi?[indexPath.row].logo, !image.isBlank
            {
//                cell.imgPlayer.af_setImage(withURL: URL(string: ((scorecardData.responseData?.imageBaseUrl)!+image).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
               // cell.imgPlayer.af_setImage(withURL: URL(string: ((scorecardData.responseData?.pP)!+image+".png").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
            cell.imgPlayer.af_setImage(withURL: URL(string: ((scorecardData.responseData?.pP)!+image))!)
            }
            else{
                if let name = scorecardData.responseData?.match?.teams?.a?.xi?[indexPath.row].name{
                    cell.imgPlayer.image = AppHelper.generateImageWithText(text: name, image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:name.uppercased()), size: CGSize(width: 50, height: 50)))
                    
                }
                else{
                    cell.imgPlayer.image = AppHelper.generateImageWithText(text: "N/A", image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:"N/A"), size: CGSize(width: 50, height: 50)))
                    
                }
                
            }
        }
        }
        return cell
    }
    private func setInfoCell(cell:InfoCell,indexPath:IndexPath)->InfoCell
    {
        cell.bannerView.isHidden = true
        cell.lblTitle.isHidden = false
        cell.lblValue.isHidden = false
        cell.nativeAdView.isHidden = true
        cell.proportionalWidthConstraint.constant = 0
        if indexPath.row == 0
        {
            cell.lblTitle.text = arr[indexPath.row]
            cell.lblValue.text = scorecardData.responseData?.match?.s_name
        }
        else if indexPath.row == 1
        {
            cell.lblTitle.text = arr[indexPath.row]
            cell.lblValue.text = scorecardData.responseData?.match?.name
        }
        else if indexPath.row == 2
        {
            cell.lblTitle.text = arr[indexPath.row]
            if let iso = scorecardData.responseData?.match?.st_date{
                let createdDate = AppHelper.stringToGmtDate(strDate: iso, format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "EEE, MMMM dd - h:mm a"
                cell.lblValue.text = dateFormatter.string(from: createdDate!)
            }
        }
        else if indexPath.row == 3
        {
            cell.lblTitle.text = arr[indexPath.row]
            cell.lblValue.text = scorecardData.responseData?.match?.venue
        }
        else if indexPath.row == 4
        {
            cell.lblTitle.text = arr[indexPath.row]
            cell.lblValue.text = scorecardData.responseData?.match?.toss
        }
        else if indexPath.row == 5
        {
            cell.lblTitle.text = arr[indexPath.row]
            if let info  = scorecardData.responseData?.match?.result
            {
                cell.lblValue.text = info
            }
            else
            {
                cell.lblValue.text = ""
            }
        }
        else
        {
            cell.bannerView.isHidden = false
            cell.lblTitle.isHidden = true
            cell.lblValue.isHidden = true
            cell.bannerView.adUnitID = AppHelper.appDelegate().adBannerUnitID as String
            cell.bannerView.rootViewController = self
            cell.bannerView.load(GADRequest())
        }
        return cell
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
    
    private func setCommentryMOMCell(tableView:UITableView,indexPath:IndexPath)
        -> UITableViewCell
    {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ManOfMatchCell") as! ManOfMatchCell
            cell.lblPlayerTitle.textColor = AppHelper.hexStringToUIColor(hex: "302788")
            if let name = self.commentryData.responseData?.score?.mom?.name{
                cell.lblPlayerName.text = name.uppercased()
            }
            if let image = self.commentryData.responseData?.score?.mom?.logo, !image.isBlank
            {
                //            cell.imgPlayer.af_setImage(withURL: URL(string: ((scorecardData.responseData?.imageBaseUrl)!+image).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
                //cell.imgPlayer.af_setImage(withURL: URL(string: ((scorecardData.responseData?.pP)!+image+".png").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
                cell.imgPlayer.af_setImage(withURL: URL(string: ((self.commentryData.responseData?.pP)!+image))!)
            }
            else
            {
                if let name = self.commentryData.responseData?.score?.mom?.name{
                    cell.imgPlayer.image = AppHelper.generateImageWithText(text: name, image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:name.uppercased()), size: CGSize(width: 40, height: 40)))
                }
                else{
                    cell.imgPlayer.image = AppHelper.generateImageWithText(text: "N/A", image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:"N/A"), size: CGSize(width: 40, height: 40)))
                    
                }
                
            }
            return cell
        }
        else{
            let fourcolor = AppHelper.hexStringToUIColor(hex: "3498db")
            let sixcolor = AppHelper.hexStringToUIColor(hex: "6f59c5")
            let greencolor = AppHelper.hexStringToUIColor(hex: "3A932F")
            let extracolor = AppHelper.hexStringToUIColor(hex: "ACA46F")
            let greycolor = AppHelper.hexStringToUIColor(hex: "7f8c8d")
            let wicketcolor = AppHelper.hexStringToUIColor(hex: "D75857")
            
            //if commentryData.responseData?.balls?[indexPath.row].summary != nil, commentryData.responseData?.balls?[indexPath.row].ball_type == "normal", let overSepratedArr = "\((commentryData.responseData?.balls?[indexPath.row].over_str)!)".components(separatedBy: ".") as? [String], overSepratedArr.count == 2, overSepratedArr[1] == "6"
            if commentryData.responseData?.balls?[indexPath.row-1].summary != nil, commentryData.responseData?.balls?[indexPath.row-1].ball_type == "normal", let overSepratedArr = "\((commentryData.responseData?.balls?[indexPath.row-1].over_str)!)".components(separatedBy: ".") as? [String], overSepratedArr.count == 2, overSepratedArr[1] == "6"
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OverSummeryCell") as! OverSummeryCell
                if let summary = commentryData.responseData?.balls?[indexPath.row-1].summary
                {
                    let batsmanArr = summary.bat ?? []//summary.batsman
                    var newBatsmanArr = [BattingDetail]()//[CLGCommentrySummaryBatsman]()
                    if batsmanArr.count < 3
                    {
                        newBatsmanArr = batsmanArr
                    }
                    else
                    {
                        for item in batsmanArr
                        {
                            newBatsmanArr.append(item)
                            /*if item.batting != nil
                             {
                             if (item.batting?.dismissed) != nil,
                             (item.batting?.dismissed)!,
                             summary.match?.wicket != 10
                             {
                             
                             }
                             else
                             {
                             newBatsmanArr.append(item)
                             }
                             }*/
                        }
                    }
                    /*if newBatsmanArr.count < 2
                     {
                     for item in batsmanArr!
                     {
                     newBatsmanArr.append(item)
                     /*if item.batting != nil
                     {
                     if (item.batting?.dismissed) != nil,
                     (item.batting?.dismissed)!
                     {
                     newBatsmanArr.append(item)
                     break
                     }
                     }*/
                     }
                     }*/
                    //let batting_team = commentryData.responseData?.balls?[indexPath.row].batting_team
                    let batting_team = commentryData.responseData?.balls?[indexPath.row-1].bat_team ?? ""//commentryData.responseData?.balls?[indexPath.row].summary?.bat_team //commentryData.responseData?.balls?[indexPath.row].batting_team
                    if let teams : NSDictionary = commentryData.responseData?.score?.teams?.toJSON() as NSDictionary?{
                        
                        if let a : NSDictionary = teams.value(forKey: batting_team) as? NSDictionary{
                            if let name : String = a.value(forKey: "key") as? String{
                                cell.LblTeam.text = name.uppercased()
                            }
                        }
                    }
                    let currentOver = commentryData.responseData?.balls?[indexPath.row-1].over
                    let _id = commentryData.responseData?.balls?[indexPath.row-1]._id
                    var OverBallbyBall = String()
                    OverBallbyBall = ""
                    let innings = (commentryData.responseData?.balls?[indexPath.row-1])?.inn
                    for item in (self.commentryData.responseData?.balls)!
                    {
                        //if item.over == currentOver && item.batting_team == batting_team && item.innings == innings
                        if item.over == currentOver && item.bat_team == batting_team && item.inn == innings
                        {
                            if let isblank = (item.wicket_type)?.isBlank, let runss = item.runs, !isblank && runss != "0"
                            {
                                OverBallbyBall = "W" + runss + " " + OverBallbyBall //"W" + (item.runs)! + " " + OverBallbyBall
                                
                            }
                            else if let isblank = (item.wicket_type)?.isBlank, let runss = item.runs, !isblank && runss == "0"
                            {
                                OverBallbyBall = "W " + OverBallbyBall
                                
                            }
                            else if let isblank = (item.wicket_type)?.isBlank, let baltype = item.ball_type, !isblank && item.ball_type != "normal"
                            {
                                if let runss = item.runs, runss != "0"
                                {
                                    if baltype.contains("leg")
                                    {
                                        OverBallbyBall = "L" + runss + " " + OverBallbyBall
                                    }
                                    else if baltype.contains("bye")
                                    {
                                        OverBallbyBall = "B" + runss + " " + OverBallbyBall
                                    }
                                        
                                    else if baltype.contains("wide")
                                    {
                                        if runss == "1"
                                        {
                                            OverBallbyBall = "Wd " + OverBallbyBall
                                            
                                        }
                                        else
                                        {
                                            OverBallbyBall = "Wd" + "\((Int(runss)!-1))" + " " + OverBallbyBall
                                        }
                                    }
                                    else if baltype.contains("no")
                                    {
                                        if runss == "1"
                                        {
                                            OverBallbyBall = "Nb " + OverBallbyBall
                                            
                                        }
                                        else
                                        {
                                            OverBallbyBall = "Nb" + "\((Int(runss)!-1))" + " " + OverBallbyBall
                                        }
                                    }
                                    
                                }
                                else
                                {
                                    if baltype.contains("leg")
                                    {
                                        OverBallbyBall = "L" + OverBallbyBall
                                    }
                                    else if baltype.contains("bye")
                                    {
                                        OverBallbyBall = "B" + OverBallbyBall
                                    }
                                    else if baltype.contains("wide")
                                    {
                                        OverBallbyBall = "Wd" + OverBallbyBall
                                    }
                                    else if baltype.contains("no")
                                    {
                                        OverBallbyBall = "Nb" + OverBallbyBall
                                    }
                                }
                            }
                            
                            else
                            {
                                if let isblank = (item.wicket_type)?.isBlank, let baltype = item.ball_type, isblank && item.ball_type != "normal"
                                {
                                    if let runss = item.runs, runss != "0"
                                    {
                                        if baltype.contains("leg")
                                        {
                                            OverBallbyBall = "L" + runss + " " + OverBallbyBall
                                        }
                                        else if baltype.contains("bye")
                                        {
                                            OverBallbyBall = "B" + runss + " " + OverBallbyBall
                                        }
                                            
                                        else if baltype.contains("wide")
                                        {
                                            if runss == "1"
                                            {
                                                OverBallbyBall = "Wd " + OverBallbyBall
                                                
                                            }
                                            else
                                            {
                                                OverBallbyBall = "Wd" + "\((Int(runss)!-1))" + " " + OverBallbyBall
                                            }
                                        }
                                        else if baltype.contains("no")
                                        {
                                            if runss == "1"
                                            {
                                                OverBallbyBall = "Nb " + OverBallbyBall
                                                
                                            }
                                            else
                                            {
                                                OverBallbyBall = "Nb" + "\((Int(runss)!-1))" + " " + OverBallbyBall
                                            }
                                        }
                                        
                                    }
                                    else
                                    {
                                        if baltype.contains("leg")
                                        {
                                            OverBallbyBall = "L" + OverBallbyBall
                                        }
                                        else if baltype.contains("bye")
                                        {
                                            OverBallbyBall = "B" + OverBallbyBall
                                        }
                                        else if baltype.contains("wide")
                                        {
                                            OverBallbyBall = "Wd" + OverBallbyBall
                                        }
                                        else if baltype.contains("no")
                                        {
                                            OverBallbyBall = "Nb" + OverBallbyBall
                                        }
                                    }
                                }
                                else
                                {
                                    if let runss = item.runs{
                                        OverBallbyBall = runss + " " + OverBallbyBall
                                    }
                                }
                            }
                        }
                    }
                    let bowler = summary.bwl?[0]//summary.bowler?[0]
                    let batsmen1 = newBatsmanArr[0]
                    let batsmen2 = newBatsmanArr[1]
                    
                    let run = bowler?.runs ?? 0//bowler?.bowling?.runs!
                    let over = bowler?.overs ?? ""//bowler?.bowling?.overs!
                    let extra = bowler?.extras ?? 0//bowler?.bowling?.extras!
                    let mOvers = bowler?.m_overs ?? 0
                    let wicket = bowler?.wickets ?? 0//bowler?.bowling?.wickets!
                    
                    let match = summary.match
                    // Define attributes
                    let labelFont = UIFont(name: "Lato-Bold", size: 17)
                    let attributes :Dictionary = [NSAttributedStringKey.font : labelFont]
                    let labelFont1 = UIFont(name: "Lato-Regular", size: 17)
                    let attributes1 :Dictionary = [NSAttributedStringKey.font : labelFont1]
                    // Create attributed string
                    /*var attrString = NSAttributedString(string: String(describing: (batsmen1.batting?.runs) ?? 0), attributes:attributes)
                     var attrString1 = NSAttributedString(string: "("+String(describing: (batsmen1.batting?.balls) ?? 0)+")", attributes:attributes1)*/
                    var attrString = NSAttributedString(string: String(describing: (batsmen1.runs) ?? 0), attributes:attributes)
                    var attrString1 = NSAttributedString(string: "("+String(describing: (batsmen1.balls) ?? 0)+")", attributes:attributes1)
                    let combination = NSMutableAttributedString()
                    combination.append(attrString)
                    combination.append(attrString1)
                    /*var attrString2 = NSAttributedString(string: String(describing: (batsmen2.batting?.runs) ?? 0), attributes:attributes)
                     var attrString3 = NSAttributedString(string: "("+String(describing: (batsmen2.batting?.balls) ?? 0)+")", attributes:attributes1)*/
                    var attrString2 = NSAttributedString(string: String(describing: (batsmen2.runs) ?? 0), attributes:attributes)
                    var attrString3 = NSAttributedString(string: "("+String(describing: (batsmen2.balls) ?? 0)+")", attributes:attributes1)
                    let combination1 = NSMutableAttributedString()
                    combination1.append(attrString2)
                    combination1.append(attrString3)
                    var attrString4 = NSAttributedString(string: String(describing: (summary.runs)!), attributes:attributes)
                    var attrString5 = NSAttributedString(string: "(", attributes:attributes1)
                    var attrString6 = NSAttributedString(string: " RUNS)", attributes:attributes1)
                    
                    let combination2 = NSMutableAttributedString()
                    combination2.append(attrString5)
                    combination2.append(attrString4)
                    combination2.append(attrString6)
                    cell.Batsmen1Name.text = batsmen1.name//batsmen1.info?.fullname
                    cell.Batsmen2Name.text = batsmen2.name//batsmen2.info?.fullname
                    cell.LblBallByBallScore.text = ""
                    cell.LblBallByBallScore.text = OverBallbyBall
                    cell.Batsmen1Score.attributedText = combination
                    cell.Batsmen2Score.attributedText = combination1
                    cell.BowlerName.text = bowler?.name//bowler?.info?.fullname
                    cell.BowlerStates.text = "\(over.first!)-\(mOvers)-\(run)-\(wicket)"
                    cell.Over.text = "OVER "+String(describing: (summary.over)!)
                    cell.Runs.attributedText = combination2
                    if let matchruns = match?.runs, let matchwicket = match?.wicket{
                        cell.Score.text = String(describing: matchruns) + "-" + String(describing: matchwicket)
                    }
                }
                if let isblanck = (commentryData.responseData?.balls?[indexPath.row-1].comment)?.isBlank, !isblanck
                {
                    cell.CommentryComment.attributedText = (commentryData.responseData?.balls?[indexPath.row-1].comment)?.html2AttributedString?.attributedStringWithSameFont(17)
                }
                else
                {
                    cell.CommentryComment.text = ""//GetComment(Dic : (commentryData.responseData?.balls?[indexPath.row])! )
                    
                }
                
                cell.CommentryRuns.text = commentryData.responseData?.balls?[indexPath.row-1].runs
                if commentryData.responseData?.balls?[indexPath.row-1].runs == "4" || commentryData.responseData?.balls?[indexPath.row-1].runs == "6"
                {
                    cell.CommentryRuns.backgroundColor = (commentryData.responseData?.balls?[indexPath.row-1].runs)! == "6" ? sixcolor : fourcolor
                }
                else if let isblanck = commentryData.responseData?.balls?[indexPath.row-1].wicket_type?.isBlank, !isblanck
                {
                    cell.CommentryRuns.backgroundColor = wicketcolor
                    cell.CommentryRuns.text = "W"
                    if let runss = commentryData.responseData?.balls?[indexPath.row-1].runs, runss != "0"
                    {
                        cell.CommentryRuns.text = "W" + runss //(commentryData.responseData?.balls?[indexPath.row].runs)!
                        
                    }
                }
                else if (commentryData.responseData?.balls?[indexPath.row-1].ball_type?.contains("leg"))!
                {
                    cell.CommentryRuns.text = "L"
                    cell.CommentryRuns.backgroundColor = extracolor
                    if let runss =  commentryData.responseData?.balls?[indexPath.row-1].runs, runss != "0"
                    {
                        cell.CommentryRuns.text = "L" + runss //(commentryData.responseData?.balls?[indexPath.row].runs)!
                        
                    }
                }
                else if (commentryData.responseData?.balls?[indexPath.row-1].ball_type?.contains("bye"))!
                {
                    cell.CommentryRuns.backgroundColor = extracolor
                    cell.CommentryRuns.text = "B"
                    if let runss = commentryData.responseData?.balls?[indexPath.row-1].runs, runss != "0"
                    {
                        cell.CommentryRuns.text = "B" + runss
                        //(commentryData.responseData?.balls?[indexPath.row].runs)!
                    }
                }
                else if (commentryData.responseData?.balls?[indexPath.row-1].ball_type?.contains("wide"))!
                {
                    cell.CommentryRuns.backgroundColor = extracolor
                    cell.CommentryRuns.text = "Wd"
                    if let runss = commentryData.responseData?.balls?[indexPath.row-1].runs, runss != "0" && runss != "1"
                    {
                        let run = Int(runss)//Int((commentryData.responseData?.balls?[indexPath.row].runs)!)
                        cell.CommentryRuns.text = "Wd"+"\(run!-1)"
                        
                    }
                }
                else if !(commentryData.responseData?.balls?[indexPath.row-1].ball_type?.contains("normal"))!
                {
                    cell.CommentryRuns.backgroundColor = extracolor
                    cell.CommentryRuns.text = "Nb"
                    if let runss = commentryData.responseData?.balls?[indexPath.row-1].runs, runss != "0" && runss != "1"
                    {
                        let run = Int(runss)//Int((commentryData.responseData?.balls?[indexPath.row].runs)!)
                        cell.CommentryRuns.text = "Nb"+"\(run!-1)"
                    }
                }
                else
                {
                    if let runss = commentryData.responseData?.balls?[indexPath.row-1].runs, runss != "0"
                    {
                        cell.CommentryRuns.backgroundColor = greencolor
                    }
                    else
                    {
                        cell.CommentryRuns.backgroundColor = greycolor
                    }
                }
                if let ovrstr = commentryData.responseData?.balls?[indexPath.row-1].over_str{
                    cell.CommentryOver.text = "\(ovrstr)"
                }
                return cell
            }
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "BallByBallCell") as! BallByBallCell
                if let isblank = commentryData.responseData?.balls?[indexPath.row-1].comment?.isBlank, !isblank
                    //if !(commentryData.responseData?.balls?[indexPath.row].comment?.isBlank)!
                {
                    cell.Comment.attributedText = commentryData.responseData?.balls?[indexPath.row-1].comment?.html2AttributedString?.attributedStringWithSameFont(17)
                }
                else
                {
                    cell.Comment.text = ""//GetComment(Dic : (commentryData.responseData?.balls?[indexPath.row])! )
                    
                }
                
                cell.Runs.text = commentryData.responseData?.balls?[indexPath.row-1].runs ?? ""
                if commentryData.responseData?.balls?[indexPath.row-1].runs == "4" || commentryData.responseData?.balls?[indexPath.row-1].runs == "6"
                {
                    cell.Runs.backgroundColor = commentryData.responseData?.balls?[indexPath.row-1].runs ?? "" == "6" ? sixcolor : fourcolor
                }
                else if !(commentryData.responseData?.balls?[indexPath.row-1].wicket_type?.isBlank ?? false)
                {
                    cell.Runs.backgroundColor = wicketcolor
                    cell.Runs.text = "W"
                    if let runss = commentryData.responseData?.balls?[indexPath.row-1].runs, runss != "0"
                    {
                        cell.Runs.text = "W" + runss//(commentryData.responseData?.balls?[indexPath.row].runs)!
                        
                    }
                }
                else if (commentryData.responseData?.balls?[indexPath.row-1].ball_type?.contains("leg"))!
                {
                    cell.Runs.text = "L"
                    cell.Runs.backgroundColor = extracolor
                    if let runss = commentryData.responseData?.balls?[indexPath.row-1].runs, runss != "0"
                    {
                        cell.Runs.text = "L" + runss//commentryData.responseData?.balls?[indexPath.row].runs
                        
                    }
                }
                else if (commentryData.responseData?.balls?[indexPath.row-1].ball_type?.contains("bye"))!
                {
                    cell.Runs.backgroundColor = extracolor
                    cell.Runs.text = "B"
                    if let runss = commentryData.responseData?.balls?[indexPath.row-1].runs, runss != "0"
                    {
                        cell.Runs.text = "B"+runss//(commentryData.responseData?.balls?[indexPath.row].runs)!
                    }
                }
                else if (commentryData.responseData?.balls?[indexPath.row-1].ball_type?.contains("wide"))!
                {
                    cell.Runs.backgroundColor = extracolor
                    cell.Runs.text = "Wd"
                    if let runss = commentryData.responseData?.balls?[indexPath.row-1].runs, runss != "0" && runss != "1"//(commentryData.responseData?.balls?[indexPath.row].runs) != "1"
                    {
                        let run = Int(runss)//Int((commentryData.responseData?.balls?[indexPath.row].runs)!)
                        cell.Runs.text = "Wd"+"\(run!-1)"
                        
                    }
                }
                else if !(commentryData.responseData?.balls?[indexPath.row-1].ball_type?.contains("normal"))!
                {
                    cell.Runs.backgroundColor = extracolor
                    cell.Runs.text = "Nb"
                    if let runss = commentryData.responseData?.balls?[indexPath.row-1].runs,runss != "0" && runss != "1"//(commentryData.responseData?.balls?[indexPath.row].runs) != "1"
                    {
                        let run = Int(runss)//Int((commentryData.responseData?.balls?[indexPath.row].runs)!)
                        cell.Runs.text = "Nb"+"\(run!-1)"
                    }
                }
                else
                {
                    if let runss = commentryData.responseData?.balls?[indexPath.row-1].runs, runss != "0"
                    {
                        cell.Runs.backgroundColor = greencolor
                    }
                    else
                    {
                        cell.Runs.backgroundColor = greycolor
                    }
                }
                cell.inningHeight.constant = 0
                cell.underlineView.isHidden = true
                /*if commentryData.responseData?.balls?[indexPath.row].over_str == 0.1
                 {
                 if commentryData.responseData?.balls?[indexPath.row].ball_count == 1
                 {
                 cell.inningHeight.constant = 40
                 cell.inningLbl.text = "1st Inning"
                 cell.underlineView.isHidden = false
                 }
                 else if ((commentryData.responseData?.balls?.count)! > indexPath.row+1),
                 commentryData.responseData?.balls?[indexPath.row+1].over_str != 0.1
                 {
                 cell.inningHeight.constant = 40
                 if commentryData.responseData?.balls?[indexPath.row].innings == "1"
                 {
                 cell.inningLbl.text = "2nd Inning"
                 cell.underlineView.isHidden = false
                 }
                 else if commentryData.responseData?.balls?[indexPath.row].innings == "2",
                 let order = commentryData.responseData?.score?.batting_order,
                 order.count > 0
                 {
                 if commentryData.responseData?.score?.batting_order![3][0] == commentryData.responseData?.balls?[indexPath.row].batting_team
                 {
                 cell.inningLbl.text = "3rd Inning"
                 cell.underlineView.isHidden = false
                 }
                 else
                 {
                 cell.inningLbl.text = "4th Inning"
                 cell.underlineView.isHidden = false
                 }
                 }
                 }
                 }*/
                if let overstr = commentryData.responseData?.balls?[indexPath.row-1].over_str{
                    cell.Over.text = "\(overstr)"
                }
                return cell
            }
        }
        
    }
    private func setCommentryCell(tableView:UITableView,indexPath:IndexPath)
        -> UITableViewCell
    {
        let fourcolor = AppHelper.hexStringToUIColor(hex: "3498db")
        let sixcolor = AppHelper.hexStringToUIColor(hex: "6f59c5")
        let greencolor = AppHelper.hexStringToUIColor(hex: "3A932F")
        let extracolor = AppHelper.hexStringToUIColor(hex: "ACA46F")
        let greycolor = AppHelper.hexStringToUIColor(hex: "7f8c8d")
        let wicketcolor = AppHelper.hexStringToUIColor(hex: "D75857")

            //if commentryData.responseData?.balls?[indexPath.row].summary != nil, commentryData.responseData?.balls?[indexPath.row].ball_type == "normal", let overSepratedArr = "\((commentryData.responseData?.balls?[indexPath.row].over_str)!)".components(separatedBy: ".") as? [String], overSepratedArr.count == 2, overSepratedArr[1] == "6"
            if commentryData.responseData?.balls?[indexPath.row].summary != nil, commentryData.responseData?.balls?[indexPath.row].ball_type == "normal", let overSepratedArr = "\((commentryData.responseData?.balls?[indexPath.row].over_str)!)".components(separatedBy: ".") as? [String], overSepratedArr.count == 2, overSepratedArr[1] == "6"
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "OverSummeryCell") as! OverSummeryCell
                    if let summary = commentryData.responseData?.balls?[indexPath.row].summary
                    {
                        let batsmanArr = summary.bat ?? []//summary.batsman
                        var newBatsmanArr = [BattingDetail]()//[CLGCommentrySummaryBatsman]()
                        if batsmanArr.count < 3
                        {
                            newBatsmanArr = batsmanArr
                        }
                        else
                        {
                            for item in batsmanArr
                            {
                                newBatsmanArr.append(item)
                                /*if item.batting != nil
                                {
                                    if (item.batting?.dismissed) != nil,
                                        (item.batting?.dismissed)!,
                                        summary.match?.wicket != 10
                                    {
                                      
                                    }
                                    else
                                    {
                                        newBatsmanArr.append(item)
                                    }
                                }*/
                            }
                        }
                        /*if newBatsmanArr.count < 2
                        {
                            for item in batsmanArr!
                            {
                                newBatsmanArr.append(item)
                                /*if item.batting != nil
                                {
                                    if (item.batting?.dismissed) != nil,
                                        (item.batting?.dismissed)!
                                    {
                                        newBatsmanArr.append(item)
                                        break
                                    }
                                }*/
                            }
                        }*/
                        //let batting_team = commentryData.responseData?.balls?[indexPath.row].batting_team
                        let batting_team = commentryData.responseData?.balls?[indexPath.row].bat_team ?? ""//commentryData.responseData?.balls?[indexPath.row].summary?.bat_team //commentryData.responseData?.balls?[indexPath.row].batting_team
                        if let teams : NSDictionary = commentryData.responseData?.score?.teams?.toJSON() as NSDictionary?{
                            
                            if let a : NSDictionary = teams.value(forKey: batting_team) as? NSDictionary{
                                if let name : String = a.value(forKey: "key") as? String{
                                    cell.LblTeam.text = name.uppercased()
                                }
                            }
                        }
                        let currentOver = commentryData.responseData?.balls?[indexPath.row].over
                        let _id = commentryData.responseData?.balls?[indexPath.row]._id
                        var OverBallbyBall = String()
                        OverBallbyBall = ""
                        let innings = (commentryData.responseData?.balls?[indexPath.row])?.inn
                        for item in (self.commentryData.responseData?.balls)!
                        {
                            //if item.over == currentOver && item.batting_team == batting_team && item.innings == innings
                            if item.over == currentOver && item.bat_team == batting_team && item.inn == innings
                            {
                                if let isblank = (item.wicket_type)?.isBlank, let runss = item.runs, !isblank && runss != "0"
                                {
                                    OverBallbyBall = "W" + runss + " " + OverBallbyBall //"W" + (item.runs)! + " " + OverBallbyBall
                                    
                                }
                                else if let isblank = (item.wicket_type)?.isBlank, let runss = item.runs, !isblank && runss == "0"
                                {
                                    OverBallbyBall = "W " + OverBallbyBall
                                    
                                }
                                    else if let isblank = (item.wicket_type)?.isBlank, let baltype = item.ball_type, !isblank && item.ball_type != "normal"
                                {
                                    if let runss = item.runs, runss != "0"
                                    {
                                        if baltype.contains("leg")
                                        {
                                            OverBallbyBall = "L" + runss + " " + OverBallbyBall
                                        }
                                        else if baltype.contains("bye")
                                        {
                                            OverBallbyBall = "B" + runss + " " + OverBallbyBall
                                        }
                                        
                                        else if baltype.contains("wide")
                                        {
                                            if runss == "1"
                                            {
                                                OverBallbyBall = "Wd " + OverBallbyBall
                                                
                                            }
                                            else
                                            {
                                                OverBallbyBall = "Wd" + "\((Int(runss)!-1))" + " " + OverBallbyBall
                                            }
                                        }
                                        else if baltype.contains("no")
                                        {
                                            if runss == "1"
                                            {
                                                OverBallbyBall = "Nb " + OverBallbyBall
                                                
                                            }
                                            else
                                            {
                                                OverBallbyBall = "Nb" + "\((Int(runss)!-1))" + " " + OverBallbyBall
                                            }
                                        }
                                        
                                    }
                                    else
                                    {
                                        if baltype.contains("leg")
                                        {
                                            OverBallbyBall = "L" + OverBallbyBall
                                        }
                                        else if baltype.contains("bye")
                                        {
                                            OverBallbyBall = "B" + OverBallbyBall
                                        }
                                        else if baltype.contains("wide")
                                        {
                                            OverBallbyBall = "Wd" + OverBallbyBall
                                        }
                                        else if baltype.contains("no")
                                        {
                                            OverBallbyBall = "Nb" + OverBallbyBall
                                        }
                                    }
                                }
                                else
                                {
                                    if let isblank = (item.wicket_type)?.isBlank, let baltype = item.ball_type, isblank && item.ball_type != "normal"
                                    {
                                        if let runss = item.runs, runss != "0"
                                        {
                                            if baltype.contains("leg")
                                            {
                                                OverBallbyBall = "L" + runss + " " + OverBallbyBall
                                            }
                                            else if baltype.contains("bye")
                                            {
                                                OverBallbyBall = "B" + runss + " " + OverBallbyBall
                                            }
                                                
                                            else if baltype.contains("wide")
                                            {
                                                if runss == "1"
                                                {
                                                    OverBallbyBall = "Wd " + OverBallbyBall
                                                    
                                                }
                                                else
                                                {
                                                    OverBallbyBall = "Wd" + "\((Int(runss)!-1))" + " " + OverBallbyBall
                                                }
                                            }
                                            else if baltype.contains("no")
                                            {
                                                if runss == "1"
                                                {
                                                    OverBallbyBall = "Nb " + OverBallbyBall
                                                    
                                                }
                                                else
                                                {
                                                    OverBallbyBall = "Nb" + "\((Int(runss)!-1))" + " " + OverBallbyBall
                                                }
                                            }
                                            
                                        }
                                        else
                                        {
                                            if baltype.contains("leg")
                                            {
                                                OverBallbyBall = "L" + OverBallbyBall
                                            }
                                            else if baltype.contains("bye")
                                            {
                                                OverBallbyBall = "B" + OverBallbyBall
                                            }
                                            else if baltype.contains("wide")
                                            {
                                                OverBallbyBall = "Wd" + OverBallbyBall
                                            }
                                            else if baltype.contains("no")
                                            {
                                                OverBallbyBall = "Nb" + OverBallbyBall
                                            }
                                        }
                                    }
                                    else
                                    {
                                        if let runss = item.runs{
                                            OverBallbyBall = runss + " " + OverBallbyBall
                                        }
                                    }
                                }
                            }
                        }
                        let bowler = summary.bwl?[0]//summary.bowler?[0]
                        let batsmen1 = newBatsmanArr[0]
                        let batsmen2 = newBatsmanArr[1]
                       
                        let run = bowler?.runs ?? 0//bowler?.bowling?.runs!
                        let over = bowler?.overs ?? ""//bowler?.bowling?.overs!
                        let extra = bowler?.extras ?? 0//bowler?.bowling?.extras!
                        let mOvers = bowler?.m_overs ?? 0
                        let wicket = bowler?.wickets ?? 0//bowler?.bowling?.wickets!
                        
                        let match = summary.match
                        // Define attributes
                        let labelFont = UIFont(name: "Lato-Bold", size: 17)
                        let attributes :Dictionary = [NSAttributedStringKey.font : labelFont]
                        let labelFont1 = UIFont(name: "Lato-Regular", size: 17)
                        let attributes1 :Dictionary = [NSAttributedStringKey.font : labelFont1]
                        // Create attributed string
                        /*var attrString = NSAttributedString(string: String(describing: (batsmen1.batting?.runs) ?? 0), attributes:attributes)
                        var attrString1 = NSAttributedString(string: "("+String(describing: (batsmen1.batting?.balls) ?? 0)+")", attributes:attributes1)*/
                        var attrString = NSAttributedString(string: String(describing: (batsmen1.runs) ?? 0), attributes:attributes)
                        var attrString1 = NSAttributedString(string: "("+String(describing: (batsmen1.balls) ?? 0)+")", attributes:attributes1)
                        let combination = NSMutableAttributedString()
                        combination.append(attrString)
                        combination.append(attrString1)
                        /*var attrString2 = NSAttributedString(string: String(describing: (batsmen2.batting?.runs) ?? 0), attributes:attributes)
                        var attrString3 = NSAttributedString(string: "("+String(describing: (batsmen2.batting?.balls) ?? 0)+")", attributes:attributes1)*/
                        var attrString2 = NSAttributedString(string: String(describing: (batsmen2.runs) ?? 0), attributes:attributes)
                        var attrString3 = NSAttributedString(string: "("+String(describing: (batsmen2.balls) ?? 0)+")", attributes:attributes1)
                        let combination1 = NSMutableAttributedString()
                        combination1.append(attrString2)
                        combination1.append(attrString3)
                        var attrString4 = NSAttributedString(string: String(describing: (summary.runs)!), attributes:attributes)
                        var attrString5 = NSAttributedString(string: "(", attributes:attributes1)
                        var attrString6 = NSAttributedString(string: " RUNS)", attributes:attributes1)
                        
                        let combination2 = NSMutableAttributedString()
                        combination2.append(attrString5)
                        combination2.append(attrString4)
                        combination2.append(attrString6)
                        cell.Batsmen1Name.text = batsmen1.name//batsmen1.info?.fullname
                        cell.Batsmen2Name.text = batsmen2.name//batsmen2.info?.fullname
                        cell.LblBallByBallScore.text = ""
                        cell.LblBallByBallScore.text = OverBallbyBall
                        cell.Batsmen1Score.attributedText = combination
                        cell.Batsmen2Score.attributedText = combination1
                        cell.BowlerName.text = bowler?.name//bowler?.info?.fullname
                        cell.BowlerStates.text = "\(over.first!)-\(mOvers)-\(run)-\(wicket)"
                        cell.Over.text = "OVER "+String(describing: (summary.over)!)
                        cell.Runs.attributedText = combination2
                        if let matchruns = match?.runs, let matchwicket = match?.wicket{
                            cell.Score.text = String(describing: matchruns) + "-" + String(describing: matchwicket)
                        }
                }
                if let isblanck = (commentryData.responseData?.balls?[indexPath.row].comment)?.isBlank, !isblanck
                {
                    cell.CommentryComment.attributedText = (commentryData.responseData?.balls?[indexPath.row].comment)?.html2AttributedString?.attributedStringWithSameFont(17)
                }
                else
                {
                    cell.CommentryComment.text = ""//GetComment(Dic : (commentryData.responseData?.balls?[indexPath.row])! )
                    
                }
                
                cell.CommentryRuns.text = commentryData.responseData?.balls?[indexPath.row].runs
                if commentryData.responseData?.balls?[indexPath.row].runs == "4" || commentryData.responseData?.balls?[indexPath.row].runs == "6"
                {
                        cell.CommentryRuns.backgroundColor = (commentryData.responseData?.balls?[indexPath.row].runs)! == "6" ? sixcolor : fourcolor
                }
                else if let isblanck = commentryData.responseData?.balls?[indexPath.row].wicket_type?.isBlank, !isblanck
                {
                    cell.CommentryRuns.backgroundColor = wicketcolor
                    cell.CommentryRuns.text = "W"
                    if let runss = commentryData.responseData?.balls?[indexPath.row].runs, runss != "0"
                    {
                        cell.CommentryRuns.text = "W" + runss //(commentryData.responseData?.balls?[indexPath.row].runs)!
                        
                    }
                }
                else if (commentryData.responseData?.balls?[indexPath.row].ball_type?.contains("leg"))!
                {
                    cell.CommentryRuns.text = "L"
                    cell.CommentryRuns.backgroundColor = extracolor
                    if let runss =  commentryData.responseData?.balls?[indexPath.row].runs, runss != "0"
                    {
                        cell.CommentryRuns.text = "L" + runss //(commentryData.responseData?.balls?[indexPath.row].runs)!
                        
                    }
                }
                else if (commentryData.responseData?.balls?[indexPath.row].ball_type?.contains("bye"))!
                {
                    cell.CommentryRuns.backgroundColor = extracolor
                    cell.CommentryRuns.text = "B"
                    if let runss = commentryData.responseData?.balls?[indexPath.row].runs, runss != "0"
                    {
                        cell.CommentryRuns.text = "B" + runss
                        //(commentryData.responseData?.balls?[indexPath.row].runs)!
                    }
                }
                else if (commentryData.responseData?.balls?[indexPath.row].ball_type?.contains("wide"))!
                {
                    cell.CommentryRuns.backgroundColor = extracolor
                    cell.CommentryRuns.text = "Wd"
                    if let runss = commentryData.responseData?.balls?[indexPath.row].runs, runss != "0" && runss != "1"
                    {
                        let run = Int(runss)//Int((commentryData.responseData?.balls?[indexPath.row].runs)!)
                        cell.CommentryRuns.text = "Wd"+"\(run!-1)"
                        
                    }
                }
                else if !(commentryData.responseData?.balls?[indexPath.row].ball_type?.contains("normal"))!
                {
                    cell.CommentryRuns.backgroundColor = extracolor
                    cell.CommentryRuns.text = "Nb"
                    if let runss = commentryData.responseData?.balls?[indexPath.row].runs, runss != "0" && runss != "1"
                    {
                        let run = Int(runss)//Int((commentryData.responseData?.balls?[indexPath.row].runs)!)
                        cell.CommentryRuns.text = "Nb"+"\(run!-1)"
                    }
                }
                else
                {
                    if let runss = commentryData.responseData?.balls?[indexPath.row].runs, runss != "0"
                    {
                        cell.CommentryRuns.backgroundColor = greencolor
                    }
                    else
                    {
                        cell.CommentryRuns.backgroundColor = greycolor
                    }
                }
                if let ovrstr = commentryData.responseData?.balls?[indexPath.row].over_str{
                    cell.CommentryOver.text = "\(ovrstr)"
                }
                return cell
            }
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "BallByBallCell") as! BallByBallCell
                if let isblank = commentryData.responseData?.balls?[indexPath.row].comment?.isBlank, !isblank
                //if !(commentryData.responseData?.balls?[indexPath.row].comment?.isBlank)!
                {
                    cell.Comment.attributedText = commentryData.responseData?.balls?[indexPath.row].comment?.html2AttributedString?.attributedStringWithSameFont(17)
                }
                else
                {
                    cell.Comment.text = ""//GetComment(Dic : (commentryData.responseData?.balls?[indexPath.row])! )
                    
                }
            
                cell.Runs.text = commentryData.responseData?.balls?[indexPath.row].runs ?? ""
                if commentryData.responseData?.balls?[indexPath.row].runs == "4" || commentryData.responseData?.balls?[indexPath.row].runs == "6"
                {
                        cell.Runs.backgroundColor = commentryData.responseData?.balls?[indexPath.row].runs ?? "" == "6" ? sixcolor : fourcolor
                }
                else if !(commentryData.responseData?.balls?[indexPath.row].wicket_type?.isBlank ?? false)
                {
                        cell.Runs.backgroundColor = wicketcolor
                        cell.Runs.text = "W"
                        if let runss = commentryData.responseData?.balls?[indexPath.row].runs, runss != "0"
                        {
                            cell.Runs.text = "W" + runss//(commentryData.responseData?.balls?[indexPath.row].runs)!
                            
                        }
                }
                else if (commentryData.responseData?.balls?[indexPath.row].ball_type?.contains("leg"))!
                {
                    cell.Runs.text = "L"
                    cell.Runs.backgroundColor = extracolor
                    if let runss = commentryData.responseData?.balls?[indexPath.row].runs, runss != "0"
                    {
                        cell.Runs.text = "L" + runss//commentryData.responseData?.balls?[indexPath.row].runs
                        
                    }
                }
                else if (commentryData.responseData?.balls?[indexPath.row].ball_type?.contains("bye"))!
                {
                    cell.Runs.backgroundColor = extracolor
                    cell.Runs.text = "B"
                    if let runss = commentryData.responseData?.balls?[indexPath.row].runs, runss != "0"
                    {
                        cell.Runs.text = "B"+runss//(commentryData.responseData?.balls?[indexPath.row].runs)!
                    }
                }
                else if (commentryData.responseData?.balls?[indexPath.row].ball_type?.contains("wide"))!
                {
                    cell.Runs.backgroundColor = extracolor
                    cell.Runs.text = "Wd"
                    if let runss = commentryData.responseData?.balls?[indexPath.row].runs, runss != "0" && runss != "1"//(commentryData.responseData?.balls?[indexPath.row].runs) != "1"
                    {
                        let run = Int(runss)//Int((commentryData.responseData?.balls?[indexPath.row].runs)!)
                        cell.Runs.text = "Wd"+"\(run!-1)"
                        
                    }
                }
                else if !(commentryData.responseData?.balls?[indexPath.row].ball_type?.contains("normal"))!
                {
                    cell.Runs.backgroundColor = extracolor
                    cell.Runs.text = "Nb"
                    if let runss = commentryData.responseData?.balls?[indexPath.row].runs,runss != "0" && runss != "1"//(commentryData.responseData?.balls?[indexPath.row].runs) != "1"
                    {
                        let run = Int(runss)//Int((commentryData.responseData?.balls?[indexPath.row].runs)!)
                        cell.Runs.text = "Nb"+"\(run!-1)"
                    }
                }
                else
                {
                    if let runss = commentryData.responseData?.balls?[indexPath.row].runs, runss != "0"
                    {
                        cell.Runs.backgroundColor = greencolor
                    }
                    else
                    {
                        cell.Runs.backgroundColor = greycolor
                    }
                }
                cell.inningHeight.constant = 0
                cell.underlineView.isHidden = true
                /*if commentryData.responseData?.balls?[indexPath.row].over_str == 0.1
                {
                    if commentryData.responseData?.balls?[indexPath.row].ball_count == 1
                    {
                        cell.inningHeight.constant = 40
                        cell.inningLbl.text = "1st Inning"
                        cell.underlineView.isHidden = false
                    }
                    else if ((commentryData.responseData?.balls?.count)! > indexPath.row+1),
                    commentryData.responseData?.balls?[indexPath.row+1].over_str != 0.1
                    {
                        cell.inningHeight.constant = 40
                        if commentryData.responseData?.balls?[indexPath.row].innings == "1"
                        {
                            cell.inningLbl.text = "2nd Inning"
                            cell.underlineView.isHidden = false
                        }
                        else if commentryData.responseData?.balls?[indexPath.row].innings == "2",
                            let order = commentryData.responseData?.score?.batting_order,
                            order.count > 0
                        {
                            if commentryData.responseData?.score?.batting_order![3][0] == commentryData.responseData?.balls?[indexPath.row].batting_team
                            {
                                cell.inningLbl.text = "3rd Inning"
                                cell.underlineView.isHidden = false
                            }
                            else
                            {
                                cell.inningLbl.text = "4th Inning"
                                cell.underlineView.isHidden = false
                            }
                        }
                    }
                }*/
                if let overstr = commentryData.responseData?.balls?[indexPath.row].over_str{
                    cell.Over.text = "\(overstr)"
                }
                return cell
            }
    }
    //MARK: make comment
    func GetComment(Dic : CLGCommentryBallByBall) -> String
    {
        var comment = String()
        let batsmenName = Dic.striker?.full_name
        let BowlerName = (Dic.bowler)?.key
        let wicket  = Dic.wicket_type
        let ballType = Dic.ball_type
        let runs = Dic.runs
        if !(wicket?.isBlank)!
        {
            comment = BowlerName! + " to " + batsmenName! + ": WICKET"
        }
        else if ballType != "normal"
        {
            if runs != "0"
            {
                comment = BowlerName! + " to " + batsmenName! + ": \(ballType!.capitalized) , \(runs!)Runs"
            }
            else
            {
                comment = BowlerName! + " to " + batsmenName! + ": \(ballType!)"
            }
        }
        else
        {
            if runs == "4"
            {
                comment = BowlerName! + " to " + batsmenName! + ": SIX."
            }
            else if runs == "6"
            {
                comment = BowlerName! + " to " + batsmenName! + ": FOUR."
            }
            else if runs == "0"
            {
                comment = BowlerName! + " to " + batsmenName! + ": No runs."
            }
            else
            {
                comment = BowlerName! + " to " + batsmenName! + ": \(runs!) run."
            }
        }
        return comment
    }
    @IBAction func commentryBtnAct(_ sender: Any){
        setUnderline(btn:self.commentryBtn)
        //self.hitCommentryApi(showLoader:false)
        if selectedBtn != 1
        {
            self.tvCommentryScorecard.addSubview(refreshControl)
        }
        selectedBtn = 1
        tvCommentryScorecard.reloadData()
        noCommentryLbl.isHidden = isCommentryAvailable
    }
    
    @IBAction func scoreBtnAct(_ sender: Any){
        setUnderline(btn:self.scoreBtn)
        if selectedBtn == 1
        {
            refreshControl.removeFromSuperview()
        }
        selectedBtn = 2
        //showNativeAd()
        tvCommentryScorecard.reloadData()
        noCommentryLbl.isHidden = true
        
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
        let indices: IndexSet = [scorecardData.responseData?.match?.inn_order?.count ?? 1]
        self.tvCommentryScorecard.beginUpdates()
        self.tvCommentryScorecard.reloadSections(indices, with: UITableViewRowAnimation.automatic)
        self.tvCommentryScorecard.endUpdates()
        
    }
    
    @IBAction func infoBtnAct(_ sender: Any){
        setUnderline(btn:self.infoBtn)
        if selectedBtn == 1
        {
            refreshControl.removeFromSuperview()
        }
        selectedBtn = 3
        //showNativeAd()
        tvCommentryScorecard.reloadData()
        noCommentryLbl.isHidden = true
    }
    
    @IBAction func squadBtnAct(_ sender: Any){
        setUnderline(btn:self.squadBtn)
        if selectedBtn == 1
        {
            refreshControl.removeFromSuperview()
        }
        selectedBtn = 4
        //showNativeAd()
        tvCommentryScorecard.reloadData()
        noCommentryLbl.isHidden = true
        
        
        teamTwoSelected = true
        let indices: IndexSet = [2]
        self.tvCommentryScorecard.beginUpdates()
        self.tvCommentryScorecard.reloadSections(indices, with: UITableViewRowAnimation.automatic)
        self.tvCommentryScorecard.endUpdates()
        
    }
}
extension CommentryScorecardVC:UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if selectedBtn == 4
        {
            return 4
        }
        else if selectedBtn == 3
        {
            return 2
        }
        else if selectedBtn == 2
        {
            return ((scorecardData.responseData?.match?.inn_order?.count) ?? 0) + 2
        }
        
        return isCommentryAvailable ? 1 : 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if selectedBtn == 4
        {
            if section == 0
            {
                return 0
            }
            else if section == 1
            {
                if teamOneSelected
                {
                    if scorecardData.responseData?.match?.teams?.a?.xi?.count ?? 0 > 0{
                        return 11
                    }
                    else{
                        return 0
                    }
                }
                else
                {
                    return 0
                }
            }
            else if section == 2
            {
                if teamTwoSelected
                {
                    if scorecardData.responseData?.match?.teams?.b?.xi?.count ?? 0 > 0{
                        return 11
                    }
                    else{
                        return 0
                    }
                }
                else
                {
                    return 0
                }
            }
            return 0
        }
        else if selectedBtn == 3
        {
            if section == 0{
                return arr.count//return arr.count+1
            }else{
                return 0
            }
        }
        else if selectedBtn == 2
        {
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
        }
        else if selectedBtn == 1{
            if let name = self.commentryData.responseData?.score?.mom?.name, name != ""{
                return commentryData.responseData?.balls != nil ? (commentryData.responseData?.balls?.count)! + 1 : 1
            }
            else{
                return commentryData.responseData?.balls != nil ? (commentryData.responseData?.balls?.count)! : 0
            }
        }
        return commentryData.responseData?.balls != nil ? (commentryData.responseData?.balls?.count)! : 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if selectedBtn == 4
        {
            if (indexPath.section == 1 && teamOneSelected) || (indexPath.section == 2 && teamTwoSelected)
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SquadPlayerCell") as! SquadPlayerCell
                return setSquadPlayerCell(cell:cell,indexPath:indexPath)
            }
        }
        else if selectedBtn == 3
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell") as! InfoCell
            return setInfoCell(cell:cell,indexPath:indexPath)
        }
        else if selectedBtn == 2
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BatsmanCell") as! BatsmanCell
            return setBatsmanCell(cell:cell,indexPath:indexPath)
        }
        else if selectedBtn == 1
        {
            if let name = self.commentryData.responseData?.score?.mom?.name, name != ""{
                return setCommentryMOMCell(tableView:tableView,indexPath:indexPath)
            }
            else{
                return setCommentryCell(tableView:tableView,indexPath:indexPath)
            }
        }
        return UITableViewCell()
    }
}

extension CommentryScorecardVC:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if selectedBtn == 2
        {
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
            
            //return 55
        }
        else if selectedBtn == 4
        {
            return 55
        }
        else if selectedBtn == 3
        {
            if indexPath.section == 0{
                return indexPath.row == arr.count ? 100 : 55
            }
            else{
                return 0
            }
        }
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        if selectedBtn == 3
        {
            return section == 0 ? 70 : 0
        }
        else if selectedBtn == 2
        {
            return (((scorecardData.responseData?.match?.inn_order?.count) ?? 0) + 1) != section ? 60 : 0
        }
        else if selectedBtn == 4
        {
            return section != 3 ? 60 : 0
        }
        else if selectedBtn == 1
        {
            if let isc = (self.commentryData.responseData?.score?.inn_order), isc.count > 0
            {
                if isc.count == 1
                {
                    return 80
                }
                else
                {
                    if let message = commentryData.responseData?.score?.result, message != ""{
                        return 155
                    }
                    else{
                        return 110
                    }
                }
            }
            //return 160
        }
        var height:CGFloat = 0
        if let isc = (self.commentryData.responseData?.score?.inn_order), isc.count > 0
        {
            if isc.count == 1
            {
                height = 45
            }
            else
            {
                height = 90
            }
        }
        if let message = commentryData.responseData?.score?.msgs?.result
        {
            height = 110
        }
        return height
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
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        if selectedBtn == 4
        {
            if section == 0
            {
                let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TitleCell") as! TitleCell
                cell.lblTitle.textColor = .darkText
                cell.lblTitle.text = "Playing XI"
                return cell
            }
            else if section == 3
            {
                let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CellBannerAdTableViewCell") as! CellBannerAdTableViewCell
                cell.bannerView.adUnitID = AppHelper.appDelegate().adBannerUnitID as String
                cell.bannerView.rootViewController = self
                cell.bannerView.load(GADRequest())
                if nativeAds.count > 0{
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
                return cell
            }
            else
            {
                let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SquadTeamCell") as! SquadTeamCell
                cell.sectionBtn.tag = section
                cell.lblScore.isHidden = true
                cell.lblTeam.textColor = UIColor.white
                //cell.lblTeam.text = section == 2 ? scorecardData.responseData?.match?.teams?.b?.name : scorecardData.responseData?.match?.teams?.a?.name
                cell.lblTeam.text = section == 2 ? scorecardData.responseData?.match?.teams?.b?.key?.uppercased() : scorecardData.responseData?.match?.teams?.a?.key?.uppercased()
                cell.sectionBtn.addTarget(self, action: #selector(self.squadSectionBtnAct(sender:)), for: UIControlEvents.touchUpInside)
                if  (section == 1 && teamOneSelected) || (section == 2 && teamTwoSelected)
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
        else if selectedBtn == 3
        {
            if section == 0{
                let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "MatchLineInfoHeaderCell") as! MatchLineInfoHeaderCell
                cell.imgTeam1.image = #imageLiteral(resourceName: "TeamPlaceholder")
                cell.imgTeam2.image = #imageLiteral(resourceName: "TeamPlaceholder")
                cell.lblTeam1.text = scorecardData.responseData?.match?.teams?.a?.key?.uppercased()//scorecardData.responseData?.match?.teams?.a?.name
                cell.lblTeam2.text = scorecardData.responseData?.match?.teams?.b?.key?.uppercased()//scorecardData.responseData?.match?.teams?.b?.name
                cell.lblTeam1.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                cell.lblTeam2.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
                if let teamspath = scorecardData.responseData?.tP{
                    if let logo = scorecardData.responseData?.match?.teams?.a?.logo, logo != ""{
                        if let url = URL(string: (teamspath+logo).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
                        {
                            cell.imgTeam1.af_setImage(withURL: url)
                        }
                        else{
                            if let key = scorecardData.responseData?.match?.teams?.a?.key, key != ""{
                                if let name = scorecardData.responseData?.match?.teams?.a?.name{
                                    cell.imgTeam1.image = AppHelper.loadImage(named: key.lowercased(),teamName:name)
                                }
                                else{
                                    cell.imgTeam1.image = AppHelper.loadImage(named: key.lowercased(),teamName:"N/A")
                                }
                                
                            }
                            else{
                                if let name = scorecardData.responseData?.match?.teams?.a?.name{
                                    
                                    cell.imgTeam1.image = AppHelper.generateImageWithText(text: name, image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:name.uppercased()), size: CGSize(width: 50, height: 50)))
                                    
                                }
                                else{
                                    
                                    cell.imgTeam1.image = AppHelper.generateImageWithText(text: "N/A", image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:"N/A"), size: CGSize(width: 50, height: 50)))
                                    
                                }
                                
                            }
                            //self.ImgViewLeftTeam.image = #imageLiteral(resourceName: "TeamPlaceholder")
                        }
                    }
                    else{
                        if let key = scorecardData.responseData?.match?.teams?.a?.key, key != ""{
                            if let name = scorecardData.responseData?.match?.teams?.a?.name{
                                cell.imgTeam1.image = AppHelper.loadImage(named: key.lowercased(),teamName:name)
                            }
                            else{
                                cell.imgTeam1.image = AppHelper.loadImage(named: key.lowercased(),teamName:"N/A")
                            }
                            
                        }
                        else{
                            if let name = scorecardData.responseData?.match?.teams?.a?.name{
                                
                                cell.imgTeam1.image = AppHelper.generateImageWithText(text: name, image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:name.uppercased()), size: CGSize(width: 50, height: 50)))
                                
                            }
                            else{
                                
                                cell.imgTeam1.image = AppHelper.generateImageWithText(text: "N/A", image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:"N/A"), size: CGSize(width: 50, height: 50)))
                                
                            }
                            
                        }
                        //self.ImgViewLeftTeam.image = #imageLiteral(resourceName: "TeamPlaceholder")
                    }
                    if let logo = scorecardData.responseData?.match?.teams?.b?.logo, logo != ""{
                        if let url = URL(string: (teamspath+logo).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
                        {
                            cell.imgTeam2.af_setImage(withURL: url)
                        }
                        else{
                            if let key = scorecardData.responseData?.match?.teams?.b?.key, key != ""{
                                if let name = scorecardData.responseData?.match?.teams?.b?.name{
                                    cell.imgTeam2.image = AppHelper.loadImage(named: key.lowercased(),teamName:name)
                                }
                                else{
                                    cell.imgTeam2.image = AppHelper.loadImage(named: key.lowercased(),teamName:"N/A")
                                }
                                
                            }
                            else{
                                if let name = scorecardData.responseData?.match?.teams?.b?.name{
                                    
                                    cell.imgTeam2.image = AppHelper.generateImageWithText(text: name, image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:name.uppercased()), size: CGSize(width: 50, height: 50)))
                                    
                                }
                                else{
                                    
                                    cell.imgTeam2.image = AppHelper.generateImageWithText(text: "N/A", image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:"N/A"), size: CGSize(width: 50, height: 50)))
                                    
                                }
                                
                            }
                            //self.ImgViewLeftTeam.image = #imageLiteral(resourceName: "TeamPlaceholder")
                        }
                    }
                    else{
                        if let key = scorecardData.responseData?.match?.teams?.b?.key, key != ""{
                            if let name = scorecardData.responseData?.match?.teams?.b?.name{
                                cell.imgTeam2.image = AppHelper.loadImage(named: key.lowercased(),teamName:name)
                            }
                            else{
                                cell.imgTeam2.image = AppHelper.loadImage(named: key.lowercased(),teamName:"N/A")
                            }
                            
                        }
                        else{
                            if let name = scorecardData.responseData?.match?.teams?.b?.name{
                                
                                cell.imgTeam2.image = AppHelper.generateImageWithText(text: name, image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:name.uppercased()), size: CGSize(width: 50, height: 50)))
                                
                            }
                            else{
                                
                                cell.imgTeam2.image = AppHelper.generateImageWithText(text: "N/A", image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:"N/A"), size: CGSize(width: 50, height: 50)))
                                
                            }
                            
                        }
                        //self.ImgViewLeftTeam.image = #imageLiteral(resourceName: "TeamPlaceholder")
                    }
            }
            return cell
            }
            else{
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
                    else {
                        if let adView = cell.contentView.subviews[1] as? GADUnifiedNativeAdView
                        {
                            nativeAds[1].rootViewController = self
                            adView.nativeAd = nativeAds[1]
                            (adView.headlineView as! UILabel).text = nativeAds[1].headline
                            (adView.bodyView as! UILabel).text = nativeAds[0].body
                            (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
                            (adView.callToActionView as! UIButton).setTitle(
                                nativeAds[1].callToAction, for: UIControlState.normal)
                        }
                    }
                }
                return cell
            }
        }
        else if selectedBtn == 2
        {
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
        else if selectedBtn == 1
        {
            let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CommentryScoreCell") as! CommentryScoreCell
            cell.teamOneOver.font = cell.teamOneOver.font.withSize(16)
            cell.teamOneScore.font = cell.teamOneScore.font.withSize(17)
            cell.teamTwoOver.font = cell.teamTwoOver.font.withSize(16)
            cell.teamTwoScore.font = cell.teamTwoScore.font.withSize(17)
            cell.teamOneScoreLeadingConstrain.constant = 170
            cell.teamTwoScoreLeadingConstrain.constant = 170
            
            if let isc = (self.commentryData.responseData?.score?.inn_order), isc.count > 1
                {
                    if let tp = self.commentryData.responseData?.tP{
                        let score = commentryData.responseData?.score?.inn_order
                        if score?[0] != nil
                        {
                            if let score1 = score?[0]{
                                if let innings = score1.innings{
                                    if innings.contains("a"){
                                        if let aLogo = self.commentryData.responseData?.score?.teams?.a?.logo, aLogo != ""{
                                            if let imgUrl = URL(string: tp+aLogo){
                                                cell.teamOneImage.af_setImage(withURL: imgUrl)
                                            }
                                            else{
                                                if let key = self.commentryData.responseData?.score?.teams?.a?.key, key != ""{
                                                    if let name = self.commentryData.responseData?.score?.teams?.a?.name{
                                                        cell.teamOneImage.image = AppHelper.loadImage(named: key.lowercased(),teamName:name)
                                                    }
                                                    else{
                                                        cell.teamOneImage.image = AppHelper.loadImage(named: key.lowercased(),teamName:"N/A")
                                                    }
                                                    
                                                }
                                                else{
                                                    if let name = self.commentryData.responseData?.score?.teams?.a?.name{
                                                        cell.teamOneImage.image = AppHelper.generateImageWithText(text: name, image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:name.uppercased()), size: CGSize(width: 50, height: 50)))
                                                        
                                                    }
                                                    else{
                                                        cell.teamOneImage.image = AppHelper.generateImageWithText(text: "N/A", image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:"N/A"), size: CGSize(width: 50, height: 50)))
                                                        
                                                    }
                                                    
                                                }
                                                //self.ImgViewLeftTeam.image = #imageLiteral(resourceName: "TeamPlaceholder")
                                            }
                                        }
                                        else{
                                            if let key = self.commentryData.responseData?.score?.teams?.a?.key, key != ""{
                                                if let name = self.commentryData.responseData?.score?.teams?.a?.name{
                                                    cell.teamOneImage.image = AppHelper.loadImage(named: key.lowercased(),teamName:name)
                                                }
                                                else{
                                                    cell.teamOneImage.image = AppHelper.loadImage(named: key.lowercased(),teamName:"N/A")
                                                }
                                                
                                            }
                                            else{
                                                if let name = self.commentryData.responseData?.score?.teams?.a?.name{
                                                    cell.teamOneImage.image = AppHelper.generateImageWithText(text: name, image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:name.uppercased()), size: CGSize(width: 50, height: 50)))
                                                    
                                                }
                                                else{
                                                    cell.teamOneImage.image = AppHelper.generateImageWithText(text: "N/A", image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:"N/A"), size: CGSize(width: 50, height: 50)))
                                                    
                                                }
                                                
                                            }
                                            //self.ImgViewLeftTeam.image = #imageLiteral(resourceName: "TeamPlaceholder")
                                        }
                                        if let bLogo = self.commentryData.responseData?.score?.teams?.b?.logo, bLogo != ""{
                                            if let imgUrl = URL(string: tp+bLogo){
                                                cell.teamTwoImage.af_setImage(withURL: imgUrl)
                                            }
                                            else{
                                                if let key = self.commentryData.responseData?.score?.teams?.b?.key, key != ""{
                                                    if let name = self.commentryData.responseData?.score?.teams?.b?.name{
                                                        cell.teamTwoImage.image = AppHelper.loadImage(named: key.lowercased(),teamName:name)
                                                    }
                                                    else{
                                                        cell.teamTwoImage.image = AppHelper.loadImage(named: key.lowercased(),teamName:"N/A")
                                                    }
                                                    
                                                }
                                                else{
                                                    if let name = self.commentryData.responseData?.score?.teams?.b?.name{
                                                        cell.teamTwoImage.image = AppHelper.generateImageWithText(text: name, image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:name.uppercased()), size: CGSize(width: 50, height: 50)))
                                                        
                                                    }
                                                    else{
                                                        cell.teamTwoImage.image = AppHelper.generateImageWithText(text: "N/A", image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:"N/A"), size: CGSize(width: 50, height: 50)))
                                                        
                                                    }
                                                    
                                                }
                                                //self.ImgViewLeftTeam.image = #imageLiteral(resourceName: "TeamPlaceholder")
                                            }
                                        }
                                        else{
                                            if let key = self.commentryData.responseData?.score?.teams?.b?.key, key != ""{
                                                if let name = self.commentryData.responseData?.score?.teams?.b?.name{
                                                    cell.teamTwoImage.image = AppHelper.loadImage(named: key.lowercased(),teamName:name)
                                                }
                                                else{
                                                    cell.teamTwoImage.image = AppHelper.loadImage(named: key.lowercased(),teamName:"N/A")
                                                }
                                                
                                            }
                                            else{
                                                if let name = self.commentryData.responseData?.score?.teams?.b?.name{
                                                    cell.teamTwoImage.image = AppHelper.generateImageWithText(text: name, image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:name.uppercased()), size: CGSize(width: 50, height: 50)))
                                                    
                                                }
                                                else{
                                                    cell.teamTwoImage.image = AppHelper.generateImageWithText(text: "N/A", image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:"N/A"), size: CGSize(width: 50, height: 50)))
                                                    
                                                }
                                                
                                            }
                                            //self.ImgViewLeftTeam.image = #imageLiteral(resourceName: "TeamPlaceholder")
                                        }
                                    }
                                    else{
                                        if let aLogo = self.commentryData.responseData?.score?.teams?.a?.logo, aLogo != ""{
                                            if let imgUrl = URL(string: tp+aLogo){
                                                cell.teamTwoImage.af_setImage(withURL: imgUrl)
                                            }
                                            else{
                                                if let key = self.commentryData.responseData?.score?.teams?.a?.key, key != ""{
                                                    if let name = self.commentryData.responseData?.score?.teams?.a?.name{
                                                        cell.teamTwoImage.image = AppHelper.loadImage(named: key.lowercased(),teamName:name)
                                                    }
                                                    else{
                                                        cell.teamTwoImage.image = AppHelper.loadImage(named: key.lowercased(),teamName:"N/A")
                                                    }
                                                    
                                                }
                                                else{
                                                    if let name = self.commentryData.responseData?.score?.teams?.a?.name{
                                                        cell.teamTwoImage.image = AppHelper.generateImageWithText(text: name, image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:name.uppercased()), size: CGSize(width: 50, height: 50)))
                                                        
                                                    }
                                                    else{
                                                        cell.teamTwoImage.image = AppHelper.generateImageWithText(text: "N/A", image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:"N/A"), size: CGSize(width: 50, height: 50)))
                                                        
                                                    }
                                                    
                                                }
                                                //self.ImgViewLeftTeam.image = #imageLiteral(resourceName: "TeamPlaceholder")
                                            }
                                        }
                                        else{
                                            if let key = self.commentryData.responseData?.score?.teams?.a?.key, key != ""{
                                                if let name = self.commentryData.responseData?.score?.teams?.a?.name{
                                                    cell.teamTwoImage.image = AppHelper.loadImage(named: key.lowercased(),teamName:name)
                                                }
                                                else{
                                                    cell.teamTwoImage.image = AppHelper.loadImage(named: key.lowercased(),teamName:"N/A")
                                                }
                                                
                                            }
                                            else{
                                                if let name = self.commentryData.responseData?.score?.teams?.a?.name{
                                                    cell.teamTwoImage.image = AppHelper.generateImageWithText(text: name, image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:name.uppercased()), size: CGSize(width: 50, height: 50)))
                                                    
                                                }
                                                else{
                                                    cell.teamTwoImage.image = AppHelper.generateImageWithText(text: "N/A", image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:"N/A"), size: CGSize(width: 50, height: 50)))
                                                    
                                                }
                                            }
                                            //self.ImgViewLeftTeam.image = #imageLiteral(resourceName: "TeamPlaceholder")
                                        }
                                        if let bLogo = self.commentryData.responseData?.score?.teams?.b?.logo, bLogo != ""{
                                            if let imgUrl = URL(string: tp+bLogo){
                                                cell.teamOneImage.af_setImage(withURL: imgUrl)
                                            }
                                            else{
                                                if let key = self.commentryData.responseData?.score?.teams?.b?.key, key != ""{
                                                    if let name = self.commentryData.responseData?.score?.teams?.b?.name{
                                                        cell.teamOneImage.image = AppHelper.loadImage(named: key.lowercased(),teamName:name)
                                                    }
                                                    else{
                                                        cell.teamOneImage.image = AppHelper.loadImage(named: key.lowercased(),teamName:"N/A")
                                                    }
                                                    
                                                }
                                                else{
                                                    if let name = self.commentryData.responseData?.score?.teams?.b?.name{
                                                        cell.teamOneImage.image = AppHelper.generateImageWithText(text: name, image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:name.uppercased()), size: CGSize(width: 50, height: 50)))
                                                        
                                                    }
                                                    else{
                                                        cell.teamOneImage.image = AppHelper.generateImageWithText(text: "N/A", image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:"N/A"), size: CGSize(width: 50, height: 50)))
                                                        
                                                    }
                                                }
                                                //self.ImgViewLeftTeam.image = #imageLiteral(resourceName: "TeamPlaceholder")
                                            }
                                        }
                                        else{
                                            if let key = self.commentryData.responseData?.score?.teams?.b?.key, key != ""{
                                                if let name = self.commentryData.responseData?.score?.teams?.b?.name{
                                                    cell.teamOneImage.image = AppHelper.loadImage(named: key.lowercased(),teamName:name)
                                                }
                                                else{
                                                    cell.teamOneImage.image = AppHelper.loadImage(named: key.lowercased(),teamName:"N/A")
                                                }
                                                
                                            }
                                            else{
                                                if let name = self.commentryData.responseData?.score?.teams?.b?.name{
                                                    cell.teamOneImage.image = AppHelper.generateImageWithText(text: name, image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:name.uppercased()), size: CGSize(width: 50, height: 50)))
                                                    
                                                }
                                                else{
                                                    cell.teamOneImage.image = AppHelper.generateImageWithText(text: "N/A", image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:"N/A"), size: CGSize(width: 50, height: 50)))
                                                    
                                                }
                                                
                                            }
                                            //self.ImgViewLeftTeam.image = #imageLiteral(resourceName: "TeamPlaceholder")
                                        }
                                    }
                                }
                            }
                        }
                    }
                    cell.teamOneScoreView.isHidden = false
                    cell.teamTwoScoreView.isHidden = false
                    cell.matchResultView.isHidden = true
                        if let message = commentryData.responseData?.score?.result//commentryData.responseData?.score?.msgs?.result
                        {
                            if message == ""{
                                cell.matchResultView.isHidden = true
                            }
                            else{
                                cell.matchResultLbl.text = message
                                cell.matchResultView.isHidden = false
                            }
                        }
                        else
                        {
                            cell.matchResultView.isHidden = true
                        }
                   
                    //let score = commentryData.responseData?.score?.innings_score_order
                    let score = commentryData.responseData?.score?.inn_order
                    if score?[0] != nil
                    {
                        if let score1 = score?[0]{
                            if let scoreOver = score1.overs{
                                cell.teamOneOver.text = "("+scoreOver+")"
                            }
                            if let scoreRuns = score1.runs, let scoreWicket = score1.wickets{
                                cell.teamOneScore.text = "\(scoreRuns)/\(scoreWicket)"
                            }
                            /*if let innings = score1.innings{
                                if innings.contains("a"){
                                    cell.teamOneTitle.text = score1.key?.uppercased()
                                }
                                else{
                                    cell.teamTwoTitle.text = score1.key?.uppercased()
                                }
                            }*/
                        }
                        /*cell.teamOneOver.text = "("+(score?[0].overs)!+")"
                        cell.teamOneScore.text = "\((score?[0].runs)!)/\((score?[0].wickets)!)"*/
                        cell.teamOneTitle.text = score?[0].key?.uppercased()
                        
                    }
                    if score?[1] != nil
                    {
                        if let score1 = score?[1]{
                            if let scoreOver = score1.overs{
                                cell.teamTwoOver.text = "("+scoreOver+")"
                            }
                            if let scoreRuns = score1.runs, let scoreWicket = score1.wickets{
                                cell.teamTwoScore.text = "\(scoreRuns)/\(scoreWicket)"
                            }
                            /*if let innings = score1.innings{
                                if innings.contains("a"){
                                    cell.teamOneTitle.text = score1.key?.uppercased()
                                }
                                else{
                                    cell.teamTwoTitle.text = score1.key?.uppercased()
                                }
                            }*/
                        }
                        /*cell.teamTwoOver.text = "("+(score?[1].overs)!+")"
                        cell.teamTwoScore.text = "\((score?[1].runs)!)/\((score?[1].wickets)!)"*/
                        cell.teamTwoTitle.text = score?[1].key?.uppercased()
                        
                    }
                    if score?.count == 3
                    {
                        cell.teamOneScoreLeadingConstrain.constant = 140
                        cell.teamTwoScoreLeadingConstrain.constant = 140
                        
                        if score?[0].key == score?[2].key
                        {
                            let str = String(cell.teamOneOver.text!.dropLast())
                            if let score1 = score?[2]{
                                if let scoreOver = score1.overs{
                                    cell.teamOneOver.text = str+" & "+scoreOver+")"
                                }
                                if let scoreRuns = score1.runs, let scoreWicket = score1.wickets{
                                    cell.teamOneScore.text = cell.teamOneScore.text!+" & "+"\(scoreRuns)/\(scoreWicket)"
                                }
                            }
                            /*cell.teamOneOver.text = str+" & "+(score![2].overs)!+")"
                            cell.teamOneScore.text = cell.teamOneScore.text!+" & "+"\((score![2].runs)!)/\((score![2].wickets)!)"*/
                            cell.teamOneOver.font = cell.teamOneOver.font.withSize(15)
                            cell.teamOneScore.font = cell.teamOneScore.font.withSize(15)
                        }
                        else
                        {
                            let str = String(cell.teamTwoOver.text!.dropLast())
                            if let score1 = score?[2]{
                                if let scoreOver = score1.overs{
                                    cell.teamTwoOver.text = str+" & "+scoreOver+")"
                                }
                                if let scoreRuns = score1.runs, let scoreWicket = score1.wickets{
                                    cell.teamTwoScore.text = cell.teamTwoScore.text!+" & "+"\(scoreRuns)/\(scoreWicket)"
                                }
                            }
                            /*cell.teamTwoOver.text = str+" & "+(score![2].overs)!+")"
                            cell.teamTwoScore.text = cell.teamTwoScore.text!+" & "+"\((score![2].runs)!)/\((score![2].wickets)!)"*/
                            cell.teamTwoOver.font = cell.teamTwoOver.font.withSize(15)
                            cell.teamTwoScore.font = cell.teamTwoScore.font.withSize(15)
                            
                        }
                    }
                    if score?.count == 4
                    {
                        cell.teamOneOver.font = cell.teamOneOver.font.withSize(15)
                        cell.teamOneScore.font = cell.teamOneScore.font.withSize(15)
                        cell.teamTwoOver.font = cell.teamTwoOver.font.withSize(15)
                        cell.teamTwoScore.font = cell.teamTwoScore.font.withSize(15)
                        cell.teamOneScoreLeadingConstrain.constant = 140
                        cell.teamTwoScoreLeadingConstrain.constant = 140
                        
                        if score?[0].key == score?[2].key
                        {
                            let str = String(cell.teamOneOver.text!.dropLast())
                            let str1 = String(cell.teamTwoOver.text!.dropLast())
                            /*cell.teamOneOver.text = str+" & "+(score![2].overs)!+")"
                            cell.teamOneScore.text = cell.teamOneScore.text!+" & "+"\((score![2].runs)!)/\((score![2].wickets)!)"
                            cell.teamTwoOver.text = str1+" & "+(score![3].overs)!+")"
                            cell.teamTwoScore.text = cell.teamTwoScore.text!+" & "+"\((score![3].runs)!)/\((score![3].wickets)!)"*/
                            if let score1 = score?[2]{
                                if let scoreOver = score1.overs{
                                    cell.teamOneOver.text = str+" & "+scoreOver+")"
                                }
                                if let scoreRuns = score1.runs, let scoreWicket = score1.wickets{
                                    cell.teamOneScore.text = cell.teamOneScore.text!+" & "+"\(scoreRuns)/\(scoreWicket)"
                                }
                            }
                            if let score2 = score?[3]{
                                if let scoreOver = score2.overs{
                                    cell.teamTwoOver.text = str1+" & "+scoreOver+")"
                                }
                                if let scoreRuns = score2.runs, let scoreWicket = score2.wickets{
                                    cell.teamTwoScore.text = cell.teamTwoScore.text!+" & "+"\(scoreRuns)/\(scoreWicket)"
                                }
                            }
                        }
                        else
                        {
                            let str = String(cell.teamOneOver.text!.dropLast())
                            let str1 = String(cell.teamTwoOver.text!.dropLast())
                            if let score1 = score?[2]{
                                if let scoreOver = score1.overs{
                                    cell.teamOneOver.text = str+" & "+scoreOver+")"
                                }
                                if let scoreRuns = score1.runs, let scoreWicket = score1.wickets{
                                    cell.teamOneScore.text = cell.teamOneScore.text!+" & "+"\(scoreRuns)/\(scoreWicket)"
                                }
                            }
                            if let score2 = score?[3]{
                                if let scoreOver = score2.overs{
                                    cell.teamTwoOver.text = str1+" & "+scoreOver+")"
                                }
                                if let scoreRuns = score2.runs, let scoreWicket = score2.wickets{
                                    cell.teamTwoScore.text = cell.teamTwoScore.text!+" & "+"\(scoreRuns)/\(scoreWicket)"
                                }
                            }
                            /*cell.teamOneOver.text = str+" & "+(score![2].overs)!+")"
                            cell.teamOneScore.text = cell.teamOneScore.text!+" & "+"\((score![2].runs)!)/\((score![2].wickets)!)"
                            cell.teamTwoOver.text = str1+" & "+(score![3].overs)!+")"
                            cell.teamTwoScore.text = cell.teamTwoScore.text!+" & "+"\((score![3].runs)!)/\((score![3].wickets)!)"*/
                        }
                    }
                }
            else if let isc = (self.commentryData.responseData?.score?.inn_order), isc.count == 1
                {
                    cell.teamOneScoreView.isHidden = false
                    cell.teamTwoScoreView.isHidden = true
                    cell.matchResultView.isHidden = true
                    if let score = self.commentryData.responseData?.score?.inn_order{
                        if let scoreOvers = score[0].overs, let scoreRuns = score[0].runs, let scoreWickets = score[0].wickets{
                            cell.teamOneOver.text = "("+scoreOvers+")"
                            cell.teamOneScore.text = "\(scoreRuns)/\(scoreWickets)"
                        }
                        cell.teamOneTitle.text = score[0].key?.uppercased()
                    }
                    if let tp = self.commentryData.responseData?.tP{
                        let score = commentryData.responseData?.score?.inn_order
                        if score?[0] != nil
                        {
                            if let score1 = score?[0]{
                                if let innings = score1.innings{
                                    if innings.contains("a"){
                                        if let aLogo = self.commentryData.responseData?.score?.teams?.a?.logo, aLogo != ""{
                                            if let imgUrl = URL(string: tp+aLogo){
                                                cell.teamOneImage.af_setImage(withURL: imgUrl)
                                            }
                                            else{
                                                if let key = self.commentryData.responseData?.score?.teams?.a?.key, key != ""{
                                                    if let name = self.commentryData.responseData?.score?.teams?.a?.name{
                                                        cell.teamOneImage.image = AppHelper.loadImage(named: key.lowercased(),teamName:name)
                                                    }
                                                    else{
                                                        cell.teamOneImage.image = AppHelper.loadImage(named: key.lowercased(),teamName:"N/A")
                                                    }
                                                    
                                                }
                                                else{
                                                    if let name = self.commentryData.responseData?.score?.teams?.a?.name{
                                                        cell.teamOneImage.image = AppHelper.generateImageWithText(text: name, image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:name.uppercased()), size: CGSize(width: 50, height: 50)))
                                                        
                                                    }
                                                    else{
                                                        cell.teamOneImage.image = AppHelper.generateImageWithText(text: "N/A", image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:"N/A"), size: CGSize(width: 50, height: 50)))
                                                        
                                                    }
                                                    
                                                }
                                                //self.ImgViewLeftTeam.image = #imageLiteral(resourceName: "TeamPlaceholder")
                                            }
                                        }
                                        else{
                                            if let key = self.commentryData.responseData?.score?.teams?.a?.key, key != ""{
                                                if let name = self.commentryData.responseData?.score?.teams?.a?.name{
                                                    cell.teamOneImage.image = AppHelper.loadImage(named: key.lowercased(),teamName:name)
                                                }
                                                else{
                                                    cell.teamOneImage.image = AppHelper.loadImage(named: key.lowercased(),teamName:"N/A")
                                                }
                                                
                                            }
                                            else{
                                                if let name = self.commentryData.responseData?.score?.teams?.a?.name{
                                                    cell.teamOneImage.image = AppHelper.generateImageWithText(text: name, image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:name.uppercased()), size: CGSize(width: 50, height: 50)))
                                                    
                                                }
                                                else{
                                                    cell.teamOneImage.image = AppHelper.generateImageWithText(text: "N/A", image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:"N/A"), size: CGSize(width: 50, height: 50)))
                                                    
                                                }
                                                
                                            }
                                            //self.ImgViewLeftTeam.image = #imageLiteral(resourceName: "TeamPlaceholder")
                                        }
                                        
                                    }
                                    else{
                                        if let bLogo = self.commentryData.responseData?.score?.teams?.b?.logo, bLogo != ""{
                                            if let imgUrl = URL(string: tp+bLogo){
                                                cell.teamOneImage.af_setImage(withURL: imgUrl)
                                            }
                                            else{
                                                if let key = self.commentryData.responseData?.score?.teams?.b?.key, key != ""{
                                                    if let name = self.commentryData.responseData?.score?.teams?.b?.name{
                                                        cell.teamOneImage.image = AppHelper.loadImage(named: key.lowercased(),teamName:name)
                                                    }
                                                    else{
                                                        cell.teamOneImage.image = AppHelper.loadImage(named: key.lowercased(),teamName:"N/A")
                                                    }
                                                    
                                                }
                                                else{
                                                    if let name = self.commentryData.responseData?.score?.teams?.b?.name{
                                                        cell.teamOneImage.image = AppHelper.generateImageWithText(text: name, image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:name.uppercased()), size: CGSize(width: 50, height: 50)))
                                                        
                                                    }
                                                    else{
                                                        cell.teamOneImage.image = AppHelper.generateImageWithText(text: "N/A", image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:"N/A"), size: CGSize(width: 50, height: 50)))
                                                        
                                                    }
                                                }
                                                //self.ImgViewLeftTeam.image = #imageLiteral(resourceName: "TeamPlaceholder")
                                            }
                                        }
                                        else{
                                            if let key = self.commentryData.responseData?.score?.teams?.b?.key, key != ""{
                                                if let name = self.commentryData.responseData?.score?.teams?.b?.name{
                                                    cell.teamOneImage.image = AppHelper.loadImage(named: key.lowercased(),teamName:name)
                                                }
                                                else{
                                                    cell.teamOneImage.image = AppHelper.loadImage(named: key.lowercased(),teamName:"N/A")
                                                }
                                                
                                            }
                                            else{
                                                if let name = self.commentryData.responseData?.score?.teams?.b?.name{
                                                    cell.teamOneImage.image = AppHelper.generateImageWithText(text: name, image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:name.uppercased()), size: CGSize(width: 50, height: 50)))
                                                    
                                                }
                                                else{
                                                    cell.teamOneImage.image = AppHelper.generateImageWithText(text: "N/A", image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:"N/A"), size: CGSize(width: 50, height: 50)))
                                                    
                                                }
                                                
                                            }
                                            //self.ImgViewLeftTeam.image = #imageLiteral(resourceName: "TeamPlaceholder")
                                        }
                                    }
                                    
                                }
                            }
                        }
                    }
                }
                else
                {
                    cell.teamOneScoreView.isHidden = true
                    cell.teamTwoScoreView.isHidden = true
                    cell.matchResultView.isHidden = true
                }
            return cell
        }
        return UITableViewHeaderFooterView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if selectedBtn == 4
        {
                if (indexPath.section == 1 && teamOneSelected){
                    if let key = scorecardData.responseData?.match?.teams?.a?.xi?[indexPath.row].key{
                        if let name = scorecardData.responseData?.match?.teams?.a?.xi?[indexPath.row].name{
                            let playerDetailVC = AppStoryboard.browsePlayer.instantiateViewController(withIdentifier: PlayerDetailVC.className) as! PlayerDetailVC
                            playerDetailVC.getTeamIdFromPrevClassScoreCard(key:key , navTitle: name)
                            self.navigationController?.pushViewController(playerDetailVC, animated: true)
                            tableView.deselectRow(at: indexPath, animated: true)
                        }
                    }
                }
                else{
                    if let key = scorecardData.responseData?.match?.teams?.b?.xi?[indexPath.row].key{
                        if let name = scorecardData.responseData?.match?.teams?.b?.xi?[indexPath.row].name{
                            let playerDetailVC = AppStoryboard.browsePlayer.instantiateViewController(withIdentifier: PlayerDetailVC.className) as! PlayerDetailVC
                            playerDetailVC.getTeamIdFromPrevClassScoreCard(key:key , navTitle: name)
                            self.navigationController?.pushViewController(playerDetailVC, animated: true)
                            tableView.deselectRow(at: indexPath, animated: true)
                        }
                    }
                }
            
        }
        else if selectedBtn == 2
        {
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
        else if selectedBtn == 1
        {
            if let name = self.commentryData.responseData?.score?.mom?.name, name != ""{
                if indexPath.row == 0{
                    if let key = self.commentryData.responseData?.score?.mom?.key{
                        let playerDetailVC = AppStoryboard.browsePlayer.instantiateViewController(withIdentifier: PlayerDetailVC.className) as! PlayerDetailVC
                        playerDetailVC.getTeamIdFromPrevClassScoreCard(key:key , navTitle: name)
                        self.navigationController?.pushViewController(playerDetailVC, animated: true)
                        tableView.deselectRow(at: indexPath, animated: true)
                    }
                }
            }
        }
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return 0
    }
}
extension CommentryScorecardVC:UIScrollViewDelegate
{
func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ) && (!isScrolling || !isLoading) && selectedBtn == 1 && (self.commentryData.responseData?.balls?.count)! > 0)
        {
            //isLoading = true
            isScrolling = true
            var ballCount = self.commentryData.responseData?.balls?.last?.ball_count
            if ballCount == 1
            {
                
            }
            else
            {
                ballCount = ballCount! - 1
                self.hitCommentryApi(MIN:ballCount!-31,MAX:ballCount!,showLoader:false)
            }
        }
    }
    }
extension CommentryScorecardVC:GADBannerViewDelegate
{
    // AdMob banner available
    func adViewDidReceiveAd(_ view: GADBannerView) {
        //bannerHeight.constant = 50.0
    }
    
    // NO AdMob banner available
    func adView(_ view: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        //bannerHeight.constant = 0.0
        loadBannerAd()
    }
}
extension CommentryScorecardVC:GADInterstitialDelegate
{
    func interstitialDidReceiveAd(_ ad: GADInterstitial)
    {
        //self.perform(#selector(self.ShowAd), with: nil, afterDelay: 10.0)
    }
}

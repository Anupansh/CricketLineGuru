//
//  CommentayLiveLineVC.swift
//  CLG
//
//  Created by Sani Kumar on 16/12/19.
//  Copyright © 2019 Anuj Naruka. All rights reserved.
//

import UIKit
import Firebase
import AlamofireImage

class CommentayLiveLineVC: BaseViewController {
    
    //MARK:- Variables & Constants
    @IBOutlet weak var noCommentryLbl: UILabel!
    @IBOutlet weak var tvCommentryScorecard: UITableView!
    
    //MARK:- IBOutlets
    var titleLbl = String()
    var matchKey = String()
    var scorecardData = CLGScorcardApi()
    var commentryData = CLGCommentryResponseData()
    var refreshControl = UIRefreshControl()
    var timer = Timer()
    var isLoading = false
    var isComingFromMatchLine = false
    var isCommentryAvailable = Bool()
    var totalCount = Int()
    var matchStatus = String()
    var isScrolling = false
    var CurrentMatch = 0
    var bannerAdView : FBAdView!

    override func viewDidLoad() {
        super.viewDidLoad()
//        self.loadFbBannerAd()
        setTopBar()
        self.registerHeaderFooterNib(tv: tvCommentryScorecard, cellName: "CommentryScoreCell")
        self.registerNib(tv: tvCommentryScorecard, cellName: "ManOfMatchCell")
        self.registerNib(tv: tvCommentryScorecard, cellName: "BallByBallCell")
        self.registerNib(tv: tvCommentryScorecard, cellName: "OverSummeryCell")
        self.tvCommentryScorecard.tableFooterView = UIView()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(sender:)), for: UIControlEvents.valueChanged)
        tvCommentryScorecard.addSubview(refreshControl) // not required when using UITableViewController
        // Do any additional setup after loading the view.
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObserver()
//        self.loadFbBannerAd()
        if matchStatus != "U"{
            //AppHelper.showHud(type:2)
            self.hitCommentryApi(showLoader:false)
            if matchStatus == "L"{
                timer = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(self.CommentTimer(_:)), userInfo: nil, repeats: true)
            }
        }
        else{
            self.noCommentryLbl.isHidden = false
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.timer.invalidate()
        removeObservers()
    }
    
    func loadFbBannerAd() {
            bannerAdView = FBAdView(placementID: AppHelper.appDelegate().fbBannerAdId, adSize: kFBAdSizeHeight50Banner, rootViewController: self)
            if UIDevice.current.hasTopNotch {
                bannerAdView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 84, width: UIScreen.main.bounds.width, height: 50)
            }
            else {
                bannerAdView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 60, width: UIScreen.main.bounds.width, height: 50)
            }
    //        bannerAdView.delegate = self
            self.view.addSubview(bannerAdView)
            bannerAdView.loadAd()
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
                                       selector: #selector(self.refreshCommentary),
                                       name: .refreshCommentary,
                                       object: nil)
    }
    func removeObservers()
    {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
    }
    @objc func refreshCommentary(){
        if matchStatus != "U"{
            //AppHelper.showHud(type:2)
            self.hitCommentryApi(showLoader:false)
            if matchStatus == "L"{
                timer = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(self.CommentTimer(_:)), userInfo: nil, repeats: true)
            }
        }
        else{
            self.noCommentryLbl.isHidden = false
        }
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
                        //tempArr.append(contentsOf: (data.responseData?.balls)!)
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
                /*if self.isComingFromMatchLine
                {
                    let when = DispatchTime.now() + 30 // change 2 to desired number of seconds
                    DispatchQueue.main.asyncAfter(deadline: when)
                    {
                        //self.timer.fire()
                    }
                }*/
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1, execute: {
                    AppHelper.hideHud()
                    if (self.commentryData.responseData?.balls)?.count == 0{
                        self.noCommentryLbl.isHidden =  false
                    }else{
                        self.noCommentryLbl.isHidden = true
                    }
                })
                //self.totalCount = (self.commentryData.responseData?.total_ball)!
                //self.totalCount = (self.commentryData.responseData?.total)!
                
            }
            }.catch { (error) in
                AppHelper.hideHud()
                self.noCommentryLbl.isHidden =  false
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
                        if let titleName = match.name{
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
    
}
extension CommentayLiveLineVC:UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return isCommentryAvailable ? 1 : 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let name = self.commentryData.responseData?.score?.mom?.name, name != ""{
            return commentryData.responseData?.balls != nil ? (commentryData.responseData?.balls?.count)! + 1 : 1
        }
        else{
            return commentryData.responseData?.balls != nil ? (commentryData.responseData?.balls?.count)! : 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if let name = self.commentryData.responseData?.score?.mom?.name, name != ""{
            return setCommentryMOMCell(tableView:tableView,indexPath:indexPath)
        }
        else{
            return setCommentryCell(tableView:tableView,indexPath:indexPath)
        }
    }
}

extension CommentayLiveLineVC:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        
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
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
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
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return CGFloat.leastNormalMagnitude
    }
}
extension CommentayLiveLineVC:UIScrollViewDelegate
{
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.commentryData.responseData != nil{
            if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ) && (!isScrolling || !isLoading)  && (self.commentryData.responseData?.balls?.count)! > 0)
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
}

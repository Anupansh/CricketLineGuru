//
//  RankingVC.swift
//  cricrate
//
//  Created by Anuj Naruka on 9/22/17.
//  Copyright © 2017 Cricket Line Guru. All rights reserved.
//

import UIKit
import GoogleMobileAds
import CoreData
import ObjectMapper
import FBAudienceNetwork

class RankingVC: BaseViewController,UINavigationControllerDelegate,UIGestureRecognizerDelegate, FBAdViewDelegate {
    
    //MARK:-IBOutlets
    @IBOutlet weak var reloadBtn: UIButton!
    @IBOutlet weak var BatsmenBtnOutlet: UIButton!
    @IBOutlet weak var TeamsBtnOutlet: UIButton!
    @IBOutlet weak var AllRounderBtnOutlet: UIButton!
    @IBOutlet weak var BowlerBtnOutlet: UIButton!
    @IBOutlet weak var t20BgView: UIView!
    @IBOutlet weak var testBgView: UIView!
    @IBOutlet weak var odiBgView: UIView!
    @IBOutlet weak var gadBannerView: GADBannerView!
    @IBOutlet weak var tvRankingMatches: UITableView!
    @IBOutlet weak var bannerHeight: NSLayoutConstraint!
    @IBOutlet weak var RatingWidthConstant: NSLayoutConstraint!
    @IBOutlet weak var PlayerLeadingConstant: NSLayoutConstraint!
    @IBOutlet weak var PlayerLbl: UILabel!
    
    @IBOutlet weak var selectedTabConstraint: NSLayoutConstraint!
    
    //MARK:-Variables And Constants
    
    var interstitialAds: GADInterstitial!
    var MatchFormatFlag = 1 //1-ODI,2-Test,3-T20
    var RankingTypeFlag = 1 //1-Batsmen,2-Bowler,3-AllRounder,4-teams
    let selectedColour = UIColor(red: 62.0/255.0, green: 65.0/255.0, blue: 116.0/255.0, alpha: 1.0)
        
    var fullScreenAd: FBInterstitialAd!
    private var allRankingData = CLGHomeResponseResultData()
    private var currentTypeData = [CLGRankingResponseModel]()
    var bannerAdView: FBAdView!
    
    override func viewDidLoad(){
        super.viewDidLoad()
        setUp()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARk:-Funcions
    
    private func setUp(){
        self.setupNavigationBarTitle("RANKING", navBG: "", leftBarButtonsType: [.back], rightBarButtonsType: [])
        tvRankingMatches.tableFooterView = UIView()
        tvRankingMatches.estimatedRowHeight = 140
        BatsmenBtnOutlet.layer.cornerRadius = 6
        TeamsBtnOutlet.layer.cornerRadius = 6
        AllRounderBtnOutlet.layer.cornerRadius = 6
        BowlerBtnOutlet.layer.cornerRadius = 6
        BatsmenBtnOutlet.clipsToBounds = true
        TeamsBtnOutlet.clipsToBounds = true
        AllRounderBtnOutlet.clipsToBounds = true
        BowlerBtnOutlet.clipsToBounds = true
        BatsmenBtnOutlet.isSelected = true
        BatsmenBtnOutlet.backgroundColor = selectedColour
        let appDel = UIApplication.shared.delegate as! AppDelegate
        hitApi()
        self.loadFbBannerAd()
        if (appDel.fbInterstitialAd != nil) && appDel.fbInterstitialAd.isAdValid && appDel.toShowInterstitial {
            appDel.fbInterstitialAd.show(fromRootViewController: self)
            appDel.fbInterstitialAd = nil
            appDel.fbInterstitialAd = appDel.loadInterstitialFbAd()
            appDel.toShowInterstitial = false
            appDel.runTimer()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
        
    func loadFbBannerAd() {
        bannerAdView = FBAdView(placementID: AppHelper.appDelegate().fbBannerAdId, adSize: kFBAdSizeHeight50Banner, rootViewController: self)
        if UIDevice.current.hasTopNotch {
            bannerAdView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 134, width: UIScreen.main.bounds.width, height: 50)
        }
        else {
            bannerAdView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 110, width: UIScreen.main.bounds.width, height: 50)
        }
//        bannerAdView.delegate = self
        self.view.addSubview(bannerAdView)
        bannerAdView.loadAd()
    }

    
    private func getRankingData(){
        CLGUserService().HomeService(url:NewDevBaseUrl+CLGRecentClass.ranking , method: .get, showLoader: 2, header: header, parameters: [String : Any]()).then(execute: { (data) -> Void in
            if data.statusCode == 1{
                let currentDate = Date().toMillis()
                let UpcomingData =  try! JSONSerialization.data(withJSONObject: data.toJSON() as Any, options: [])
                let jsonData = String(data:UpcomingData, encoding:.utf8)!
                var context:NSManagedObjectContext!
                if #available(iOS 10.0, *) {
                    context =  AppHelper.appDelegate().persistentContainer.viewContext
                } else {
                    context =  AppHelper.appDelegate().managedObjectContext
                }
                let fetchRequest: NSFetchRequest<ApiData>
                if #available(iOS 10.0, OSX 10.12, *) {
                    fetchRequest = ApiData.fetchRequest()
                } else {
                    fetchRequest = NSFetchRequest(entityName: "ApiData")
                }
                do {
                    let items = try context.fetch(fetchRequest)
                    if items.count == 0
                    {
                        let entity =
                            NSEntityDescription.entity(forEntityName: "ApiData",
                                                       in: context)!
                        let apiDataObj = NSManagedObject(entity: entity,
                                                         insertInto: context) as! ApiData
                        apiDataObj.rankingApiData = jsonData
                    }
                    else
                    {
                        for item in items
                        {
                            item.rankingApiData = jsonData
                        }
                    }
                    try context.save()
                }
                catch
                {
                    
                }
                self.reloadBtn.isHidden = true
                UserDefault.saveToUserDefault(value: currentDate as AnyObject, key: "RankingDate")
                if let responseData = data.responseData, let result = responseData.result{
                    self.allRankingData = result
                    if let odiBatsman = result.odiBatsman{
                        self.currentTypeData = odiBatsman
                    }
                }
            }
            //self.interstitialAds = self.createAndLoadInterstitial()
            //self.ShowAd()
            self.tvRankingMatches.reloadData()
        }).catch { (error) in
            print(error)
            if self.currentTypeData.count == 0
                {
            self.reloadBtn.isHidden = false
            }

        }
    }
        
    private func hitApi(){
        var rankingDate = Double()
        if let newRankingDate  = UserDefault.userDefaultForAny(key: "RankingDate") as? Double
        {
            rankingDate = newRankingDate
        }
        
        if let ranking = AppHelper.appDelegate().apiInfo.ranking{
            if let matchDate = AppHelper.stringToGmtDate(strDate: ranking, format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
            {
                if Double(rankingDate) > matchDate.timeIntervalSince1970*1000
                {
                    var rankingData = [String:AnyObject]()
                    var string = ""
                    var context : NSManagedObjectContext!
                    if #available(iOS 10.0, *) {
                        context =  AppHelper.appDelegate().persistentContainer.viewContext
                    } else {
                        context =  AppHelper.appDelegate().managedObjectContext
                    }
                    
                    let fetchRequest: NSFetchRequest<ApiData>
                    if #available(iOS 10.0, OSX 10.12, *) {
                        fetchRequest = ApiData.fetchRequest()
                    } else {
                        fetchRequest = NSFetchRequest(entityName: "ApiData")
                    }
                    fetchRequest.includesPropertyValues = false
                    do {
                        let items = try context.fetch(fetchRequest) as [NSManagedObject]
                        for item in items {
                            string = (item.value(forKey: "rankingApiData") as? String)!
                        }
                        
                    } catch
                    {
                        print(error.localizedDescription)
                    }
                    if let data = string.data(using: .utf8)
                    {
                        do
                        {
                            rankingData = try (JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject])!
                        }
                        catch
                        {
                            print(error.localizedDescription)
                        }
                    }
                    
                    let rankingModel = Mapper<HomeApiResponse>().map(JSON: rankingData)
                    
                    if let responseData = rankingModel?.responseData, let result = responseData.result{
                        self.allRankingData = result
                        if let odiBatsman = result.odiBatsman{
                            self.currentTypeData = odiBatsman
                        }
                        self.tvRankingMatches.reloadData()
                    }
                    //self.interstitialAds = createAndLoadInterstitial()
                    //self.ShowAd()
                    return
                }
            }
        }
        self.getRankingData()
    }
    
    //MARK:-IBActions
    @IBAction func reloadBtnAction(_ sender: Any) {
        self.odiBtn(0)
        hitApi()
    }
    @IBAction func BatsmenBtn(_ sender: Any){
        PlayerLbl.text = "PLAYER"
        self.setBtnColor(sender: BatsmenBtnOutlet)
        RankingTypeFlag = 1
        RatingWidthConstant.constant = 0
        PlayerLeadingConstant.constant = 45
        if !self.reloadBtn.isHidden || allRankingData.toJSON().count == 0
        {
            return
        }
        tvRankingMatches.scrollToTop(animation: true)
        if MatchFormatFlag == 1{
            if let odiBatsman = self.allRankingData.odiBatsman{
                self.currentTypeData = odiBatsman
            }
        }
        else if MatchFormatFlag == 2{
            if let testBatsman = self.allRankingData.testBatsman{
                self.currentTypeData = testBatsman
            }
        }
        else{
            if let t20Batsman = self.allRankingData.t20Batsman{
                self.currentTypeData = t20Batsman
            }
        }
        tvRankingMatches.reloadData()
    }
    
    @IBAction func TeamsBtn(_ sender: Any){
        PlayerLbl.text = "TEAM"
        self.setBtnColor(sender: TeamsBtnOutlet)
        RankingTypeFlag = 4
        RatingWidthConstant.constant = 50.5
        PlayerLeadingConstant.constant = 25
        if !self.reloadBtn.isHidden || allRankingData.toJSON().count == 0
        {
            return
        }
        tvRankingMatches.scrollToTop(animation: true)
        if MatchFormatFlag == 1{
            if let odiTeams = self.allRankingData.odiTeams{
                self.currentTypeData = odiTeams
            }
        }
        else if MatchFormatFlag == 2{
            if let testTeams = self.allRankingData.testTeams{
                self.currentTypeData = testTeams
            }
        }
        else{
            if let t20Teams = self.allRankingData.t20Teams{
                self.currentTypeData = t20Teams
            }
        }
        tvRankingMatches.reloadData()
    }
    
    @IBAction func AllRounderBtn(_ sender: Any){
        PlayerLbl.text = "PLAYER"
        self.setBtnColor(sender: AllRounderBtnOutlet)
        RankingTypeFlag = 3
        RatingWidthConstant.constant = 0
        PlayerLeadingConstant.constant = 45
        if !self.reloadBtn.isHidden || allRankingData.toJSON().count == 0
        {
            return
        }
        tvRankingMatches.scrollToTop(animation: true)
        if MatchFormatFlag == 1{
            if let odiAllRounder = self.allRankingData.odiAllRounder{
                self.currentTypeData = odiAllRounder
            }
        }
        else if MatchFormatFlag == 2{
            if let testAllRounder = self.allRankingData.testAllRounder{
                self.currentTypeData = testAllRounder
            }
        }
        else{
            if let t20AllRounder = self.allRankingData.t20AllRounder{
                self.currentTypeData = t20AllRounder
            }
        }
        tvRankingMatches.reloadData()
    }
    
    @IBAction func BowlerBtn(_ sender: Any){
        PlayerLbl.text = "PLAYER"
        self.setBtnColor(sender: BowlerBtnOutlet)
        RankingTypeFlag = 2
        RatingWidthConstant.constant = 0
        PlayerLeadingConstant.constant = 45
        if !self.reloadBtn.isHidden || allRankingData.toJSON().count == 0
        {
            return
        }
        tvRankingMatches.scrollToTop(animation: true)

        if MatchFormatFlag == 1{
            if let odiBowler = self.allRankingData.odiBowler{
                self.currentTypeData = odiBowler
            }
        }
        else if MatchFormatFlag == 2{
            if let testBowler = self.allRankingData.testBowler{
                self.currentTypeData = testBowler
            }
        }
        else{
            if let t20Bowler = self.allRankingData.t20Bowler{
                self.currentTypeData = t20Bowler
            }
        }
        tvRankingMatches.reloadData()
    }
    
    @IBAction func odiBtn(_ sender: Any){
        UIView.animate(withDuration: 0.5, animations: {
            self.selectedTabConstraint.constant = self.odiBgView.frame.origin.x
            self.view.layoutIfNeeded()
        })
        self.setBtnColor(sender: BatsmenBtnOutlet)
        RatingWidthConstant.constant = 0
        PlayerLeadingConstant.constant = 45
        if !self.reloadBtn.isHidden || allRankingData.toJSON().count == 0
        {
            return
        }
        tvRankingMatches.scrollToTop(animation: true)
        MatchFormatFlag = 1
        RankingTypeFlag = 1
        if let odiBatsman = self.allRankingData.odiBatsman{
            self.currentTypeData = odiBatsman
            tvRankingMatches.reloadData()
        }
    }
    
    @IBAction func TestBtn(_ sender: Any){
        UIView.animate(withDuration: 0.5, animations: {
            self.selectedTabConstraint.constant = self.testBgView.frame.origin.x
            self.view.layoutIfNeeded()
        })
        self.setBtnColor(sender: BatsmenBtnOutlet)
        RatingWidthConstant.constant = 0
        PlayerLeadingConstant.constant = 45
        if !self.reloadBtn.isHidden || allRankingData.toJSON().count == 0
        {
            return
        }
        tvRankingMatches.scrollToTop(animation: true)
        MatchFormatFlag = 2
        RankingTypeFlag = 1
        if let testBatsman = self.allRankingData.testBatsman{
            self.currentTypeData = testBatsman
            tvRankingMatches.reloadData()
        }
    }
    
    @IBAction func t20Btn(_ sender: Any){
        UIView.animate(withDuration: 0.5, animations: {
            self.selectedTabConstraint.constant = self.t20BgView.frame.origin.x
            self.view.layoutIfNeeded()
        })
        self.setBtnColor(sender: BatsmenBtnOutlet)
        RatingWidthConstant.constant = 0
        PlayerLeadingConstant.constant = 45
        MatchFormatFlag = 3
        RankingTypeFlag = 1
        if !self.reloadBtn.isHidden || allRankingData.toJSON().count == 0
        {
            return
        }
        tvRankingMatches.scrollToTop(animation: true)
        if let t20Batsman = self.allRankingData.t20Batsman{
            self.currentTypeData = t20Batsman
            tvRankingMatches.reloadData()
        }
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    private func setBtnColor(sender:UIButton){
        BatsmenBtnOutlet.backgroundColor = UIColor.clear
        BowlerBtnOutlet.backgroundColor = UIColor.clear
        AllRounderBtnOutlet.backgroundColor = UIColor.clear
        TeamsBtnOutlet.backgroundColor = UIColor.clear
        BatsmenBtnOutlet.setTitleColor(UIColor.black, for: .normal)
        BowlerBtnOutlet.setTitleColor(UIColor.black, for: .normal)
        AllRounderBtnOutlet.setTitleColor(UIColor.black, for: .normal)
        TeamsBtnOutlet.setTitleColor(UIColor.black, for: .normal)
        BatsmenBtnOutlet.setTitleColor(UIColor.black, for: .selected)
        BowlerBtnOutlet.setTitleColor(UIColor.black, for: .selected)
        AllRounderBtnOutlet.setTitleColor(UIColor.black, for: .selected)
        TeamsBtnOutlet.setTitleColor(UIColor.black, for: .selected)
        sender.backgroundColor = selectedColour
        sender.setTitleColor(UIColor.white, for: .normal)
        sender.setTitleColor(UIColor.white, for: .selected)
    }
}

extension RankingVC: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 40
    }
}

extension RankingVC: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.currentTypeData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Ranking_Cell", for: indexPath) as! Ranking_Cell
        cell.backgroundColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1.0)
        cell.setData(data: self.currentTypeData[indexPath.row], rankingTypeFlag: RankingTypeFlag)        
        return cell
    }
        
}

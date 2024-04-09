//
//  TeamMatchVC.swift
//  CLG
//
//  Created by Brainmobi on 30/07/18.
//  Copyright © 2018 Anuj Naruka. All rights reserved.
//

import UIKit
import GoogleMobileAds
import Firebase

class TeamMatchVC: BaseViewController {

    //MARK:- Properties
    
    private var interstitialAds: GADInterstitial!
    private var navigationTitle = String()
    private var teamId = String()
    private var upcomingMatchData = [CLGRecentMatchModel]()
    private var recentMatchData = [CLGRecentMatchModel]()
    private var currentData = [CLGRecentMatchModel]()
    var interval = 5
    var path = ""
    var adLoader = GADAdLoader()
    let numAdsToLoad = 5
    var nativeAds = [GADUnifiedNativeAd]()
    var bannerAdView: FBAdView!
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var recentBgView: UIView!
    @IBOutlet weak var upcomingBgView: UIView!
    @IBOutlet weak var gadBannerView: GADBannerView!
    @IBOutlet weak var tblTeamMatch: UITableView!
    @IBOutlet weak var bannerHeight: NSLayoutConstraint!
    @IBOutlet weak var lblNoMatch: UILabel!
    @IBOutlet weak var selectedTabConstraint: NSLayoutConstraint!
    
    //MARK:- View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblNoMatch.isHidden = true
        setUp()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setUp(){
        self.setupNavigationBarTitle(navigationTitle, navBG: "", leftBarButtonsType: [.back], rightBarButtonsType: [])
        tblTeamMatch.estimatedRowHeight = 140
        self.loadFbBannerAd()
        if teamId != ""{
            
            getTeamMatchData(matchTap: "recent")
        }
        let appDel = UIApplication.shared.delegate as! AppDelegate
        if (appDel.fbInterstitialAd != nil) && appDel.fbInterstitialAd.isAdValid && appDel.toShowInterstitial {
            appDel.fbInterstitialAd.show(fromRootViewController: self)
            appDel.fbInterstitialAd = nil
            appDel.fbInterstitialAd = appDel.loadInterstitialFbAd()
            appDel.toShowInterstitial = false
            appDel.runTimer()
        }
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
    
    @objc func showNativeAd(){
        nativeAds = AppHelper.appDelegate().returnNativeAdArray()
    }
    
    func getTeamIdFromPrevClass(id:String,navTitle:String){
        self.teamId = id
        self.navigationTitle = navTitle
    }
    
    private func getTeamMatchData(matchTap:String){
        var paramDict = [String:Any]()
        paramDict["teamKey"] = self.teamId
        //paramDict["pageNo"] = "1"
        paramDict["matchTab"] = matchTap
        //paramDict["limit"] = "1000"
        CLGUserService().newsServiceeeV3(url: NewBaseUrlV3+CLGRecentClass.teamMatch, method: .get, showLoader: 1, header: header, parameters: paramDict).then(execute: { (data) -> Void in
            if data.statusCode == 1{
                if let responseData = data.responseData{//, let result = responseData.result{
//                    if let matchUpcomming = result.matchUpcomming{
//                        self.upcomingMatchData = matchUpcomming
//                    }
//                    if let matchRecent = result.matchRecent{
//                        self.recentMatchData = matchRecent
//                    }
                    if let matchdata = responseData.matches{
                        self.currentData = matchdata
                    }
                    if let teamspath = responseData.teamsPath{
                        self.path = teamspath
                    }
                }
            }
            
            //self.currentData = self.recentMatchData
            self.setLabelHidden()
            self.tblTeamMatch.reloadData()
            //self.interstitialAds = self.createAndLoadInterstitial()
            //self.ShowAd()
            self.showNativeAd()
        }).catch { (error) in
            print(error)
        }
    }
    
    private func setLabelHidden(){
        if self.currentData.count == 0{
            self.lblNoMatch.isHidden = false
        }else{
            self.lblNoMatch.isHidden = true
        }
    }
    
    //MARK:- User Actions
    
    @IBAction func recentMatchBtn(_ sender: Any){
        UIView.animate(withDuration: 0.5, animations: {
            self.selectedTabConstraint.constant = self.recentBgView.frame.origin.x + 20.0
            self.view.layoutIfNeeded()
        })
        getTeamMatchData(matchTap: "recent")
        //self.currentData = self.recentMatchData
        setLabelHidden()
        //tblTeamMatch.reloadData()
    }
    
    @IBAction func upcomingMatchBtn(_ sender: Any){
        UIView.animate(withDuration: 0.5, animations: {
            self.selectedTabConstraint.constant = self.upcomingBgView.frame.origin.x + 20.0
            self.view.layoutIfNeeded()
        })
        getTeamMatchData(matchTap: "upcomming")
        //self.currentData = self.upcomingMatchData
        setLabelHidden()
        //tblTeamMatch.reloadData()
    }
}

extension TeamMatchVC:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.currentData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if self.selectedTabConstraint.constant == self.upcomingBgView.frame.origin.x + 20.0{
            return getUpcomingCell(indexPath, tableView: tableView)
        }else{
            return getRecentCell(indexPath, tableView: tableView)
        }
    }
    
    private func getUpcomingCell( _ indexPath : IndexPath, tableView : UITableView) -> UITableViewCell{
        /*guard let cell = tableView.dequeueReusableCell(withIdentifier: UpcomingMatchCell.className, for: indexPath) as? UpcomingMatchCell else {
         fatalError("unexpectedIndexPath")
         }
         cell.configureCellTeam(upcomingData: self.currentData[indexPath.row])
         cell.selectionStyle = .none
         return cell*/
        if indexPath.row % interval != 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UpcomingMatchCell", for: indexPath) as! UpcomingMatchCell
            cell.selectionStyle = .none
            cell.configureCellTeam(upcomingData: self.currentData[indexPath.row], path: self.path)
            return cell
        }
        else
        {
            if nativeAds.count == 5{
                let cell = tableView.dequeueReusableCell(withIdentifier: "UcomingMatchAdCell", for: indexPath) as! UcomingMatchAdCell
                cell.selectionStyle = .none
                cell.gadBannerView.isHidden = true
                if let adView = cell.contentView.subviews[2] as? GADUnifiedNativeAdView
                {
                    if currentData.count < 6{
                        if indexPath.row == 0{
                            nativeAds[0].rootViewController = self
                            adView.nativeAd = nativeAds[0]
                            (adView.headlineView as! UILabel).text = nativeAds[0].headline
                            (adView.bodyView as! UILabel).text = nativeAds[0].body
                            (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
                            (adView.callToActionView as! UIButton).setTitle(
                                nativeAds[0].callToAction, for: UIControlState.normal)
                        }
                        else{
                            nativeAds[1].rootViewController = self
                            adView.nativeAd = nativeAds[1]
                            (adView.headlineView as! UILabel).text = nativeAds[1].headline
                            (adView.bodyView as! UILabel).text = nativeAds[1].body
                            (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
                            (adView.callToActionView as! UIButton).setTitle(
                                nativeAds[1].callToAction, for: UIControlState.normal)
                        }
                    }
                    else if currentData.count > 5 && currentData.count < 11{
                        if indexPath.row == 0{
                            nativeAds[0].rootViewController = self
                            adView.nativeAd = nativeAds[0]
                            (adView.headlineView as! UILabel).text = nativeAds[0].headline
                            (adView.bodyView as! UILabel).text = nativeAds[0].body
                            (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
                            (adView.callToActionView as! UIButton).setTitle(
                                nativeAds[0].callToAction, for: UIControlState.normal)
                        }
                        else if indexPath.row == 5{
                            nativeAds[1].rootViewController = self
                            adView.nativeAd = nativeAds[1]
                            (adView.headlineView as! UILabel).text = nativeAds[1].headline
                            (adView.bodyView as! UILabel).text = nativeAds[1].body
                            (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
                            (adView.callToActionView as! UIButton).setTitle(
                                nativeAds[1].callToAction, for: UIControlState.normal)
                        }
                        else {
                            nativeAds[2].rootViewController = self
                            adView.nativeAd = nativeAds[2]
                            (adView.headlineView as! UILabel).text = nativeAds[2].headline
                            (adView.bodyView as! UILabel).text = nativeAds[2].body
                            (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
                            (adView.callToActionView as! UIButton).setTitle(
                                nativeAds[2].callToAction, for: UIControlState.normal)
                        }
                    }
                    else if currentData.count > 10 && currentData.count < 16{
                        if indexPath.row == 0{
                            nativeAds[0].rootViewController = self
                            adView.nativeAd = nativeAds[0]
                            (adView.headlineView as! UILabel).text = nativeAds[0].headline
                            (adView.bodyView as! UILabel).text = nativeAds[0].body
                            (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
                            (adView.callToActionView as! UIButton).setTitle(
                                nativeAds[0].callToAction, for: UIControlState.normal)
                        }
                        else if indexPath.row == 5{
                            nativeAds[1].rootViewController = self
                            adView.nativeAd = nativeAds[1]
                            (adView.headlineView as! UILabel).text = nativeAds[1].headline
                            (adView.bodyView as! UILabel).text = nativeAds[1].body
                            (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
                            (adView.callToActionView as! UIButton).setTitle(
                                nativeAds[1].callToAction, for: UIControlState.normal)
                        }
                        else if indexPath.row == 10{
                            nativeAds[2].rootViewController = self
                            adView.nativeAd = nativeAds[2]
                            (adView.headlineView as! UILabel).text = nativeAds[2].headline
                            (adView.bodyView as! UILabel).text = nativeAds[2].body
                            (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
                            (adView.callToActionView as! UIButton).setTitle(
                                nativeAds[2].callToAction, for: UIControlState.normal)
                        }
                        else {
                            nativeAds[3].rootViewController = self
                            adView.nativeAd = nativeAds[3]
                            (adView.headlineView as! UILabel).text = nativeAds[3].headline
                            (adView.bodyView as! UILabel).text = nativeAds[3].body
                            (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
                            (adView.callToActionView as! UIButton).setTitle(
                                nativeAds[3].callToAction, for: UIControlState.normal)
                        }
                    }
                        
                        
                    else  {
                        if indexPath.row == 0{
                            nativeAds[0].rootViewController = self
                            adView.nativeAd = nativeAds[0]
                            (adView.headlineView as! UILabel).text = nativeAds[0].headline
                            (adView.bodyView as! UILabel).text = nativeAds[0].body
                            (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
                            (adView.callToActionView as! UIButton).setTitle(
                                nativeAds[0].callToAction, for: UIControlState.normal)
                        }
                        else if indexPath.row == 5{
                            nativeAds[1].rootViewController = self
                            adView.nativeAd = nativeAds[1]
                            (adView.headlineView as! UILabel).text = nativeAds[1].headline
                            (adView.bodyView as! UILabel).text = nativeAds[1].body
                            (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
                            (adView.callToActionView as! UIButton).setTitle(
                                nativeAds[1].callToAction, for: UIControlState.normal)
                        }
                        else if indexPath.row == 10{
                            nativeAds[2].rootViewController = self
                            adView.nativeAd = nativeAds[2]
                            (adView.headlineView as! UILabel).text = nativeAds[2].headline
                            (adView.bodyView as! UILabel).text = nativeAds[2].body
                            (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
                            (adView.callToActionView as! UIButton).setTitle(
                                nativeAds[2].callToAction, for: UIControlState.normal)
                        }
                        else if indexPath.row == 15{
                            nativeAds[3].rootViewController = self
                            adView.nativeAd = nativeAds[3]
                            (adView.headlineView as! UILabel).text = nativeAds[3].headline
                            (adView.bodyView as! UILabel).text = nativeAds[3].body
                            (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
                            (adView.callToActionView as! UIButton).setTitle(
                                nativeAds[3].callToAction, for: UIControlState.normal)
                        }
                        else{
                            nativeAds[4].rootViewController = self
                            adView.nativeAd = nativeAds[4]
                            (adView.headlineView as! UILabel).text = nativeAds[4].headline
                            (adView.bodyView as! UILabel).text = nativeAds[4].body
                            (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
                            (adView.callToActionView as! UIButton).setTitle(
                                nativeAds[4].callToAction, for: UIControlState.normal)
                        }
                    }
                }
                cell.configureCellTeam(upcomingData: self.currentData[indexPath.row],vc: self, path: self.path)
                return cell
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "UpcomingMatchCell", for: indexPath) as! UpcomingMatchCell
            cell.selectionStyle = .none
            cell.configureCellTeam(upcomingData: self.currentData[indexPath.row], path:self.path)
            return cell
        }
    }
    
    
    private func getRecentCell( _ indexPath : IndexPath, tableView : UITableView) -> UITableViewCell{
        /*guard let cell = tableView.dequeueReusableCell(withIdentifier: RecentMatchCell.className, for: indexPath) as? RecentMatchCell else {
         fatalError("unexpectedIndexPath")
         }
         cell.configureCellTeam(recentData: self.currentData[indexPath.row])
         return cell*/
        if indexPath.row % interval != 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecentMatchCell", for: indexPath) as! RecentMatchCell
            cell.selectionStyle = .none
            cell.configureCellTeam(recentData: self.currentData[indexPath.row], path:self.path)
            return cell
        }
        else
        {
            
            if nativeAds.count == 5{
                let cell = tableView.dequeueReusableCell(withIdentifier: "RecentMatchAdCell", for: indexPath) as! RecentMatchAdCell
                cell.selectionStyle = .none
                cell.gadBannerView.isHidden = true
                if let adView = cell.contentView.subviews[2] as? GADUnifiedNativeAdView
                {
                    if currentData.count < 6{
                        if indexPath.row == 0{
                            nativeAds[0].rootViewController = self
                            adView.nativeAd = nativeAds[0]
                            (adView.headlineView as! UILabel).text = nativeAds[0].headline
                            (adView.bodyView as! UILabel).text = nativeAds[0].body
                            (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
                            (adView.callToActionView as! UIButton).setTitle(
                                nativeAds[0].callToAction, for: UIControlState.normal)
                        }
                        else{
                            nativeAds[1].rootViewController = self
                            adView.nativeAd = nativeAds[1]
                            (adView.headlineView as! UILabel).text = nativeAds[1].headline
                            (adView.bodyView as! UILabel).text = nativeAds[1].body
                            (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
                            (adView.callToActionView as! UIButton).setTitle(
                                nativeAds[1].callToAction, for: UIControlState.normal)
                        }
                    }
                    else if currentData.count > 5 && currentData.count < 11{
                        if indexPath.row == 0{
                            nativeAds[0].rootViewController = self
                            adView.nativeAd = nativeAds[0]
                            (adView.headlineView as! UILabel).text = nativeAds[0].headline
                            (adView.bodyView as! UILabel).text = nativeAds[0].body
                            (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
                            (adView.callToActionView as! UIButton).setTitle(
                                nativeAds[0].callToAction, for: UIControlState.normal)
                        }
                        else if indexPath.row == 5{
                            nativeAds[1].rootViewController = self
                            adView.nativeAd = nativeAds[1]
                            (adView.headlineView as! UILabel).text = nativeAds[1].headline
                            (adView.bodyView as! UILabel).text = nativeAds[1].body
                            (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
                            (adView.callToActionView as! UIButton).setTitle(
                                nativeAds[1].callToAction, for: UIControlState.normal)
                        }
                        else {
                            nativeAds[2].rootViewController = self
                            adView.nativeAd = nativeAds[2]
                            (adView.headlineView as! UILabel).text = nativeAds[2].headline
                            (adView.bodyView as! UILabel).text = nativeAds[2].body
                            (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
                            (adView.callToActionView as! UIButton).setTitle(
                                nativeAds[2].callToAction, for: UIControlState.normal)
                        }
                    }
                    else if currentData.count > 10 && currentData.count < 16{
                        if indexPath.row == 0{
                            nativeAds[0].rootViewController = self
                            adView.nativeAd = nativeAds[0]
                            (adView.headlineView as! UILabel).text = nativeAds[0].headline
                            (adView.bodyView as! UILabel).text = nativeAds[0].body
                            (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
                            (adView.callToActionView as! UIButton).setTitle(
                                nativeAds[0].callToAction, for: UIControlState.normal)
                        }
                        else if indexPath.row == 5{
                            nativeAds[1].rootViewController = self
                            adView.nativeAd = nativeAds[1]
                            (adView.headlineView as! UILabel).text = nativeAds[1].headline
                            (adView.bodyView as! UILabel).text = nativeAds[1].body
                            (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
                            (adView.callToActionView as! UIButton).setTitle(
                                nativeAds[1].callToAction, for: UIControlState.normal)
                        }
                        else if indexPath.row == 10{
                            nativeAds[2].rootViewController = self
                            adView.nativeAd = nativeAds[2]
                            (adView.headlineView as! UILabel).text = nativeAds[2].headline
                            (adView.bodyView as! UILabel).text = nativeAds[2].body
                            (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
                            (adView.callToActionView as! UIButton).setTitle(
                                nativeAds[2].callToAction, for: UIControlState.normal)
                        }
                        else {
                            nativeAds[3].rootViewController = self
                            adView.nativeAd = nativeAds[3]
                            (adView.headlineView as! UILabel).text = nativeAds[3].headline
                            (adView.bodyView as! UILabel).text = nativeAds[3].body
                            (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
                            (adView.callToActionView as! UIButton).setTitle(
                                nativeAds[3].callToAction, for: UIControlState.normal)
                        }
                    }
                        
                        
                    else  {
                        if indexPath.row == 0{
                            nativeAds[0].rootViewController = self
                            adView.nativeAd = nativeAds[0]
                            (adView.headlineView as! UILabel).text = nativeAds[0].headline
                            (adView.bodyView as! UILabel).text = nativeAds[0].body
                            (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
                            (adView.callToActionView as! UIButton).setTitle(
                                nativeAds[0].callToAction, for: UIControlState.normal)
                        }
                        else if indexPath.row == 5{
                            nativeAds[1].rootViewController = self
                            adView.nativeAd = nativeAds[1]
                            (adView.headlineView as! UILabel).text = nativeAds[1].headline
                            (adView.bodyView as! UILabel).text = nativeAds[1].body
                            (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
                            (adView.callToActionView as! UIButton).setTitle(
                                nativeAds[1].callToAction, for: UIControlState.normal)
                        }
                        else if indexPath.row == 10{
                            nativeAds[2].rootViewController = self
                            adView.nativeAd = nativeAds[2]
                            (adView.headlineView as! UILabel).text = nativeAds[2].headline
                            (adView.bodyView as! UILabel).text = nativeAds[2].body
                            (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
                            (adView.callToActionView as! UIButton).setTitle(
                                nativeAds[2].callToAction, for: UIControlState.normal)
                        }
                        else if indexPath.row == 15{
                            nativeAds[3].rootViewController = self
                            adView.nativeAd = nativeAds[3]
                            (adView.headlineView as! UILabel).text = nativeAds[3].headline
                            (adView.bodyView as! UILabel).text = nativeAds[3].body
                            (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
                            (adView.callToActionView as! UIButton).setTitle(
                                nativeAds[3].callToAction, for: UIControlState.normal)
                        }
                        else{
                            nativeAds[4].rootViewController = self
                            adView.nativeAd = nativeAds[4]
                            (adView.headlineView as! UILabel).text = nativeAds[4].headline
                            (adView.bodyView as! UILabel).text = nativeAds[4].body
                            (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
                            (adView.callToActionView as! UIButton).setTitle(
                                nativeAds[4].callToAction, for: UIControlState.normal)
                        }
                    }
                    
                }
                cell.configureCellTeam(recentData: self.currentData[indexPath.row],vc: self,path:self.path)
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecentMatchCell", for: indexPath) as! RecentMatchCell
            cell.selectionStyle = .none
            cell.configureCellTeam(recentData: self.currentData[indexPath.row],path:self.path)
            return cell
        }
    }
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
     {
        if self.selectedTabConstraint.constant == self.upcomingBgView.frame.origin.x + 20.0{
        }else{
            tableView.deselectRow(at: indexPath, animated: true)
            if let key = currentData[indexPath.row].score_card_available as? Int, key == 1
            {
                let vc = AppStoryboard.main.instantiateViewController(withIdentifier: "CommentryScorecardVC") as! CommentryScorecardVC
                vc.titleLbl = currentData[indexPath.row].sh_name!
                vc.matchKey = currentData[indexPath.row].key!
                vc.matchStatus = currentData[indexPath.row].status ?? ""
                vc.isCommentryAvailable = currentData[indexPath.row].commentary_available == 1 ? true : false
                let newNav = UINavigationController(rootViewController: vc)
                self.present(newNav, animated: true, completion: nil)
            }
            else
            {
                Drop.down("Scorecard not available")
            }
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

extension TeamMatchVC:UIScrollViewDelegate
{
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ) && (self.currentData.count) > 0)
        {
            if self.selectedTabConstraint.constant == self.recentBgView.frame.origin.x + 20.0,
                (self.currentData.count%10) == 0
            {
                self.getTeamMatchDataWithPaging(matchTap: "recent", page: ((self.currentData.count/10)+1))
            }
            else if self.selectedTabConstraint.constant == self.upcomingBgView.frame.origin.x + 20.0,
                (self.currentData.count%10) == 0
            {
                self.getTeamMatchDataWithPaging(matchTap: "upcomming", page: ((self.currentData.count/10)+1))
            }
        }
    }
    
    private func getTeamMatchDataWithPaging(matchTap:String,page:Int){
        var paramDict = [String:Any]()
        paramDict["teamKey"] = self.teamId
        paramDict["pageNo"] = page
        paramDict["matchTab"] = matchTap
        //paramDict["limit"] = "1000"
        CLGUserService().newsServiceeeV3(url: NewBaseUrlV3+CLGRecentClass.teamMatch, method: .get, showLoader: 1, header: header, parameters: paramDict).then(execute: { (data) -> Void in
            if data.statusCode == 1{
                if let responseData = data.responseData{
                    if let matchdata = responseData.matches{
                        self.currentData.append(contentsOf: matchdata)
                    } 
                    if let teamspath = responseData.teamsPath{
                        self.path = teamspath
                    }
                }
            }
            
            self.setLabelHidden()
            self.tblTeamMatch.reloadData()
            
            self.showNativeAd()
        }).catch { (error) in
            print(error)
        }
    }
}

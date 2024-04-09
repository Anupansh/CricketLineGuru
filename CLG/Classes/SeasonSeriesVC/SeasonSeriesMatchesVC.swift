//
//  SeasonSeriesVC.swift
//  cricrate
//
//  Created by Anuj Naruka on 10/7/17.
//  Copyright © 2017 Cricket Line Guru. All rights reserved.
//

import UIKit
import GoogleMobileAds
import CoreData

class SeasonSeriesMatchesVC: BaseViewController,GADBannerViewDelegate,GADInterstitialDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate
{
    //MARK:-IBOutlet
    
    @IBOutlet weak var tvSeasonMatchesList: UITableView!
    @IBOutlet weak var gadBannerView: GADBannerView!
    @IBOutlet weak var bannerHeight: NSLayoutConstraint!
    @IBOutlet weak var LblNoSeasonMatches: UILabel!
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var stackHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var fixturesBtn: UIButton!
    @IBOutlet weak var pointsTblBtn: UIButton!
    @IBOutlet weak var selectedTabConstraint: NSLayoutConstraint!
    @IBOutlet weak var pointsTableVw: UITableView!
    @IBOutlet weak var pointView: UIView!
    
    @IBOutlet weak var blurrBtn: UIButton!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var filterTableVw: UITableView!
    @IBOutlet weak var filterViewHeightConstraint: NSLayoutConstraint!
    //MARK:-Variables And Constants
    
    var bannerAdView: FBAdView!
    var nativeAds = [GADUnifiedNativeAd]()
    var interstitialAds: GADInterstitial!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var shortName = String()
    private var seriesId = String()
    private var navigationLblString = String()
    private var seriesMatchData = [CLGHomeResponseResultSeriesMatchesData]()
    private var seriesMatchFilterData = [CLGHomeResponseResultSeriesMatchesData]()
    private var pointsInfo = CLGPointsInfo()
    private var teamspath = String()
    var teamNameArray = [String]()
    var filterSelect = Bool()
    var interval = 5

    override func viewDidLoad() {
        super.viewDidLoad()
        LblNoSeasonMatches.isHidden = true
        self.stackHeightConstraints.constant = 0
        self.lineView.isHidden = true
        self.stackView.isHidden = true
        self.pointView.isHidden = true
        self.pointsTableVw.isHidden = true
        self.blurrBtn.isHidden = true
        self.filterView.isHidden = true
        self.filterSelect = false

        setUp()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FireBaseHomeObservers().removeObservers(ref:AppHelper.appDelegate().ref)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func threeDotTaped() {
        let vc = AppStoryboard.module2.instantiateViewController(withIdentifier: "PointsTableVC") as! PointsTableVC
        vc.pointsTblArr = pointsInfo
        self.navigationController?.pushViewController(vc, animated: true)
    }
    override func filterTaped(){
        if self.filterView.isHidden{
            self.blurrBtn.isHidden = false
            self.filterView.isHidden = false
        }
        else{
            self.blurrBtn.isHidden = true
            self.filterView.isHidden = true
        }
        //self.filterTableVw.reloadData()
    }
    
    @objc func showNativeAd(){
        nativeAds = AppHelper.appDelegate().returnNativeAdArray()
    }
    private func setUp(){
        self.setupNavigationBarTitle(self.navigationLblString, navBG: "", leftBarButtonsType: [.back], rightBarButtonsType: [])
        self.tvSeasonMatchesList.tableFooterView = UIView()
        tvSeasonMatchesList.estimatedRowHeight = 300
        pointsTableVw.estimatedRowHeight = 200
        pointsTableVw.tableFooterView = UIView()
        if self.seriesId != "" {
            getSeriesMatchData()
        }
        let appDel = UIApplication.shared.delegate as! AppDelegate
        if (appDel.fbInterstitialAd != nil) && appDel.fbInterstitialAd.isAdValid && appDel.toShowInterstitial {
            appDel.fbInterstitialAd.show(fromRootViewController: self)
            appDel.fbInterstitialAd = nil
            appDel.fbInterstitialAd = appDel.loadInterstitialFbAd()
            appDel.toShowInterstitial = false
            appDel.runTimer()
        }
        self.loadFbBannerAd()
        self.setTableViewStructure()
    }
    
    func setTableViewStructure(){
        self.tvSeasonMatchesList?.register(UINib(nibName: "SeasonSeriesMatchCell", bundle: nil), forCellReuseIdentifier: "SeasonSeriesMatchCell")
        self.tvSeasonMatchesList?.register(UINib(nibName: "SeasonSeriesMatchesAdCell", bundle: nil), forCellReuseIdentifier: "SeasonSeriesMatchesAdCell")
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
    
    func getSeriesIdFromPrevClass(id:String,navTitle:String){
        self.seriesId = id
        self.navigationLblString = navTitle
    }
    
    private func getSeriesMatchData(){
        let paramDict = [String:Any]()
        //paramDict["seriesId"] = self.seriesId
        let urlstr = NewBaseUrlV3+CLGRecentClass.seriesback+self.seriesId+CLGRecentClass.match
        print("Series match= ",urlstr)
        CLGUserService().newsServiceeeV3(url: urlstr, method: .get, showLoader: 1, header: header, parameters: paramDict).then(execute: { (data) -> Void in
            if data.statusCode == 1{
                if let responseData = data.responseData, let seriesInfo = responseData.series, let teamspath = responseData.teamsPath{
                    self.teamspath = teamspath
                    if let matches = seriesInfo.matches{
                        self.seriesMatchData = matches
                        self.teamNameArray.removeAll()
                        self.teamNameArray.append("ALL")
                        for match in matches{
                            if let teams = match.teams{
                                if let teamA = teams.a{
                                    if let teamAName = teamA.name{
                                        if !self.teamNameArray.contains(teamAName) && teamAName != "TBC"{
                                            self.teamNameArray.append(teamAName)
                                        }
                                    }
                                }
                                if let teamB = teams.b{
                                    if let teamBName = teamB.name{
                                        if !self.teamNameArray.contains(teamBName) && teamBName != "TBC"{
                                            self.teamNameArray.append(teamBName)
                                        }
                                    }
                                }
                            }
                            
                        }
                        if self.teamNameArray.count > 3 && matches.count > 4{
                            self.setupNavigationBarTitle(self.navigationLblString, navBG: "", leftBarButtonsType: [.back], rightBarButtonsType: [.filter])
                        }
                    }
                    if let shortName = seriesInfo.name{
                        self.shortName = shortName
                    }
                }
                if let responseData = data.responseData, let pointInfo = responseData.points{
                    if let teams = pointInfo.teams{
                        self.pointsInfo = pointInfo
                        if teams.count != 0{
                            self.stackHeightConstraints.constant = 50
                            self.stackView.isHidden = false
                            self.lineView.isHidden = false
                        }
                        else{
                            self.stackHeightConstraints.constant = 0
                            self.stackView.isHidden = true
                            self.lineView.isHidden = true
                        }
                    }
                }
                
            }
            if self.seriesMatchData.count > 0{
                self.LblNoSeasonMatches.isHidden = true
            }else{
                self.LblNoSeasonMatches.isHidden = false
            }
            //self.interstitialAds = self.createAndLoadInterstitial()
            //self.ShowAd()
            self.filterTableVw.reloadData()
            let indexpatth = IndexPath(row: 0, section: 0)
            self.filterTableVw.selectRow(at: indexpatth, animated: false, scrollPosition: .none)
            let blurbtnHeight = self.blurrBtn.bounds.size.height
            if CGFloat(self.teamNameArray.count*70) >= blurbtnHeight{
                self.filterViewHeightConstraint.constant = blurbtnHeight
            }
            else{
                self.filterViewHeightConstraint.constant = CGFloat(self.teamNameArray.count*50)
            }
            self.showNativeAd()
            self.tvSeasonMatchesList.reloadData()
        }).catch { (error) in
            print(error)
        }
    }
    
    //MARK:-IBActions
    
    @IBAction func btnBackAction(_ sender: Any){
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
}

extension SeasonSeriesMatchesVC: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool{
        if tableView == tvSeasonMatchesList || tableView == filterTableVw{
            return true
        }
        else{
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath){
        if tableView == tvSeasonMatchesList {
            if let cell = tableView.cellForRow(at: indexPath) as? SeasonSeriesMatchCell{
                cell.MainView.backgroundColor = UIColor.gray
            }
        }
        else if tableView == filterTableVw{
            if let cell = tableView.cellForRow(at: indexPath) as? SeasonSeriesFilterCell{
                cell.contentView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "topbg"))
            }
        }
        else{
            
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if tableView == tvSeasonMatchesList{
            if let cell = tableView.cellForRow(at: indexPath) as? SeasonSeriesMatchCell{
                UIView.animate(withDuration: 1, animations: {
                    cell.MainView.backgroundColor = UIColor.white
                }) { (true) in
                }
            }
        }
        else{
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
    
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        if tableView == tvSeasonMatchesList{
            tableView.deselectRow(at: indexPath, animated: true)
            if !self.filterSelect{
                if let key = seriesMatchData[indexPath.row].is_score, key == 1
                    //if let key = seriesMatchData[indexPath.row].score_card_available as? Int, key == 1
                {
                    let vc = AppStoryboard.main.instantiateViewController(withIdentifier: "CommentryScorecardVC") as! CommentryScorecardVC
                    vc.titleLbl = shortName
                    vc.matchKey = seriesMatchData[indexPath.row].key!
                    //vc.isCommentryAvailable = seriesMatchData[indexPath.row].commentary_available == 1 ? true : false
                    vc.isCommentryAvailable = seriesMatchData[indexPath.row].is_comm == 1 ? true : false
                    vc.matchStatus = seriesMatchData[indexPath.row].status ?? ""
                    let newNav = UINavigationController(rootViewController: vc)
                    self.present(newNav, animated: true, completion: nil)
                }
                else
                {
                    Drop.down("Scorecard not available")
                }
            }
            else{
                if let key = seriesMatchFilterData[indexPath.row].is_score, key == 1
                    //if let key = seriesMatchData[indexPath.row].score_card_available as? Int, key == 1
                {
                    let vc = AppStoryboard.main.instantiateViewController(withIdentifier: "CommentryScorecardVC") as! CommentryScorecardVC
                    vc.titleLbl = shortName
                    vc.matchKey = seriesMatchFilterData[indexPath.row].key!
                    //vc.isCommentryAvailable = seriesMatchData[indexPath.row].commentary_available == 1 ? true : false
                    vc.isCommentryAvailable = seriesMatchFilterData[indexPath.row].is_comm == 1 ? true : false
                    vc.matchStatus = seriesMatchFilterData[indexPath.row].status ?? ""
                    let newNav = UINavigationController(rootViewController: vc)
                    self.present(newNav, animated: true, completion: nil)
                }
                else
                {
                    Drop.down("Scorecard not available")
                }
            }
        }
        else if tableView == filterTableVw{
            self.seriesMatchFilterData.removeAll()
            if indexPath.row == 0{
                self.filterSelect = false
                self.seriesMatchFilterData = self.seriesMatchData
            }
            else{
                for seariesmatch in seriesMatchData{
                    if let teams = seariesmatch.teams{
                        if let teamA = teams.a{
                            if let teamAName = teamA.name{
                                if self.teamNameArray[indexPath.row] == teamAName {
                                    self.filterSelect = true
                                    self.seriesMatchFilterData.append(seariesmatch)
                                }
                            }
                        }
                        if let teamB = teams.b{
                            if let teamBName = teamB.name{
                                if self.teamNameArray[indexPath.row] == teamBName {
                                    self.filterSelect = true
                                    self.seriesMatchFilterData.append(seariesmatch)

                                    }
                                }
                            }
                        }
                    }
                
                }
                self.blurrBtn.isHidden = true
                self.filterView.isHidden = true
                self.tvSeasonMatchesList.reloadData()
            }
        
        }
    }


extension SeasonSeriesMatchesVC: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if tableView == tvSeasonMatchesList{
            if self.filterSelect{
                return seriesMatchFilterData.count
            }
            else{
                return seriesMatchData.count
            }
        }
        else if tableView == pointsTableVw{
            return self.pointsInfo.teams?.count ?? 0
        }
        else{
            return self.teamNameArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if tableView == tvSeasonMatchesList{
            if indexPath.row % interval != 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "SeasonSeriesMatchCell", for: indexPath) as! SeasonSeriesMatchCell
                cell.selectionStyle = .none
                cell.teamsPath = self.teamspath
                if self.filterSelect{
                    cell.setData(data:seriesMatchFilterData[indexPath.row])
                    return cell
                }
                else{
                    cell.setData(data:seriesMatchData[indexPath.row])
                    return cell
                }
            }
            else{
                
                if nativeAds.count == 5{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "SeasonSeriesMatchesAdCell", for: indexPath) as! SeasonSeriesMatchesAdCell
                    cell.selectionStyle = .none
                    cell.teamsPath = self.teamspath
                    if self.filterSelect{
                        if let adView = cell.nativeAdView
                        {
                            
                            if seriesMatchFilterData.count < 6{
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
                            else if seriesMatchFilterData.count > 5 && seriesMatchFilterData.count < 11{
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
                            else if seriesMatchFilterData.count > 10 && seriesMatchFilterData.count < 16{
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
                        cell.setData(data:seriesMatchFilterData[indexPath.row])
                        return cell
                    }
                    else{
                        if let adView = cell.nativeAdView
                        {
                            
                            if seriesMatchData.count < 6{
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
                            else if seriesMatchData.count > 5 && seriesMatchData.count < 11{
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
                            else if seriesMatchData.count > 10 && seriesMatchData.count < 16{
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
                        cell.setData(data:seriesMatchData[indexPath.row])
                        return cell
                    }
                    
                }
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "SeasonSeriesMatchCell", for: indexPath) as! SeasonSeriesMatchCell
                cell.selectionStyle = .none
                cell.teamsPath = self.teamspath
                if self.filterSelect{
                    cell.setData(data:seriesMatchFilterData[indexPath.row])
                    return cell
                }
                else{
                    cell.setData(data:seriesMatchData[indexPath.row])
                    return cell
                }
            }
        }
        else if tableView == pointsTableVw{
            let cell = tableView.dequeueReusableCell(withIdentifier: "PointsTableCell", for: indexPath) as! PointsTableCell
            cell.LblLose.text = "\((self.pointsInfo.teams!)[indexPath.row].lost ?? 0)"
            cell.LblNRR.text = String(format:"%.2f", (self.pointsInfo.teams![indexPath.row].net_run_rate) ?? 0.0)
            cell.LblWins.text = "\(self.pointsInfo.teams![indexPath.row].won ?? 0)"
            cell.LblPlayed.text = "\(self.pointsInfo.teams![indexPath.row].played ?? 0)"
            cell.LblPoints.text = "\(self.pointsInfo.teams![indexPath.row].points ?? 0)"
            cell.LblNoResult.text = "\(self.pointsInfo.teams![indexPath.row].tied ?? 0)"
            cell.LblTeamName.text = self.pointsInfo.teams![indexPath.row].name ?? ""
            cell.selectionStyle = .none
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "SeasonSeriesFilterCell", for: indexPath) as! SeasonSeriesFilterCell
            cell.teamNameLbl.text = self.teamNameArray[indexPath.row].uppercased()
            //cell.selectionStyle = .none
            return cell
        }
    }
}

extension SeasonSeriesMatchesVC{
    @IBAction func fixtureBtnAction(_ sender: Any){
        UIView.animate(withDuration: 0.5, animations: {
            self.selectedTabConstraint.constant = self.fixturesBtn.frame.origin.x
            self.view.layoutIfNeeded()
        })
        self.pointView.isHidden = true
        self.pointsTableVw.isHidden = true
        self.tvSeasonMatchesList.reloadData()
        self.setupNavigationBarTitle(self.navigationLblString, navBG: "", leftBarButtonsType: [.back], rightBarButtonsType: [.filter])
    }
    @IBAction func pointsBtnAction(_ sender: Any){
        UIView.animate(withDuration: 0.5, animations: {
            self.selectedTabConstraint.constant = self.pointsTblBtn.frame.origin.x
            self.view.layoutIfNeeded()
        })
        self.pointView.isHidden = false
        self.pointsTableVw.isHidden = false
        self.pointsTableVw.reloadData()
        self.setupNavigationBarTitle(self.navigationLblString, navBG: "", leftBarButtonsType: [.back], rightBarButtonsType: [])
    }
    @IBAction func blurrBtnAction(_ sender: Any){
        self.blurrBtn.isHidden = true
        self.filterView.isHidden = true
    }
}

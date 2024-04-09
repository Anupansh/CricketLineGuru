//
//  HomeVC.swift
//  cricrate
//  Created by Anuj Naruka on 6/18/18.
//  Copyright © 2018 Cricket Line Guru. All rights reserved.
//

import UIKit
import GoogleMobileAds
import AlamofireImage
import Firebase
import CoreData
import ObjectMapper
import AVFoundation
import SDWebImage
import Alamofire
import SwiftyJSON
import FBAudienceNetwork

class HomeVC: BaseViewController,GADInterstitialDelegate {
    
    //MARK:-IBOutlet
    
    @IBOutlet weak var tvHome: UITableView!
    @IBOutlet weak var cvHome: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var noMatchLbl: UILabel!
    @IBOutlet weak var topBgHeight: NSLayoutConstraint!
    @IBOutlet weak var gadBannerView: GADBannerView!
    @IBOutlet weak var bannerHeight: NSLayoutConstraint!
    @IBOutlet weak var reloadBtn: UIButton!
    //MARK:-Variables & Constants
    
    var newArr = [CLGHomeResponseDataNewsV3]()
    var seriesArr = [CLGHomeResponseDataSeriesV3]()
    var tempFirebaseArr = [CLGFirbaseArrModel]()
    var newsPath = String()
    var fbPath = String()
    var currentIndex:Int = 0
    var adLoader = GADAdLoader()
    var adLoader1 = GADAdLoader()
    var nativeAdView = [GADUnifiedNativeAd]()
    let numAdsToLoad = 5
    var nativeAds = [GADUnifiedNativeAd]()
    var imageSet = false
    var playerBaseUrl = String()
    var teamBaseUrl = String()
    var firebaseBaseUrl = String()
    var mostRunsModel = [IPLPlayersModel]()
    var mostWicketsModel = [IPLPlayersModel]()
    var extraStatsModel = [IPLExtraStatsModel]()
    var winnerModel = [IPLWinnerModel]()
    var orangeCapModel = [IPLCapHolderModel]()
    var purpleCapModel = [IPLCapHolderModel]()
    var recordsApiCalled = false
    var bannerAdView: FBAdView!
    var iplHasData = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        self.loadFbBannerAd()
        AppHelper.saveToUserDefaults(value: "0" as AnyObject, withKey: "LiveLine")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        if let dburlstring = UserDefault.userDefaultForAny(key: "DbUrlString") as? String{
            //Drop.down(dburlstring)
            print("DB Url1= ", dburlstring)
        }
        hitApi()
        if ScreenSize.SCREEN_HEIGHT == 812
        {
            topBgHeight.constant = 30
        }
        else{
            topBgHeight.constant = 0
        }
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(self.refreshCv),
                                       name: .refreshHomeView,
                                       object: nil)
        if AppHelper.appDelegate().ref != nil{
            FireBaseHomeObservers().removeObservers(ref:AppHelper.appDelegate().ref)
            FireBaseHomeObservers().setHomeScreenObserver(ref:AppHelper.appDelegate().ref)
        }
        if !AppHelper.appDelegate().fbInterstitialAd.isAdValid || AppHelper.appDelegate().fbInterstitialAd == nil {
            AppHelper.appDelegate().fbInterstitialAd = AppHelper.appDelegate().loadInterstitialFbAd()
        }
    }
   
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //FireBaseHomeObservers().removeObservers(ref:AppHelper.appDelegate().ref)
        print("HomeTabbar index = ", self.tabBarController?.selectedIndex ?? 6)

    }
    
//    override func shareTapped() {
//        let textToShare = """
//        Hi,
//
//        Install Cricket Line Guru to get in touch with Live Cricket Updates-
//
//        Android App- http://play.google.com/store/apps/details?id=com.app.cricketapp
//
//        IPhone App- https://itunes.apple.com/in/app/cricket-line-guru/id1247859253?mt=8
//        """
//            let objectsToShare = [textToShare] as [Any]
//            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
//
//            activityVC.completionHandler = {(activityType, completed:Bool) in
//                if !completed {
//                    //cancelled
//                    return
//                }
//
//                //shared successfully
//
//                //below is how you would detect for different sharing services
//                var activity:String = "other"
//                if activityType == UIActivityType.postToTwitter {
//                    activity = "twitter"
//                }
//                if activityType == UIActivityType.mail {
//                    activity = "mail"
//                }
//                //more code here if you like
//            }
//
//            activityVC.excludedActivityTypes = [UIActivityType.postToWeibo,
//                                                UIActivityType.message,
//                                                UIActivityType.mail,
//                                                UIActivityType.print,
//                                                UIActivityType.copyToPasteboard,
//                                                UIActivityType.assignToContact,
//                                                UIActivityType.saveToCameraRoll,
//                                                UIActivityType.addToReadingList,
//                                                UIActivityType.postToFlickr,
//                                                UIActivityType.postToVimeo,
//                                                UIActivityType.postToFacebook,
//                                                UIActivityType.postToTencentWeibo,
//                                                UIActivityType.airDrop]
//        activityVC.popoverPresentationController?.sourceView = self.navigationController?.visibleViewController?.view
//            self.present(activityVC, animated: true, completion: nil)
//    }
    
    
    @objc public func refreshCv()
    {
             cvHome.reloadData()
            if fireBaseGlobalModelNew.count == 0
            {
                self.noMatchLbl.text = "No live matches available"
                self.noMatchLbl.isHidden = false
            }
            else
            {
                self.noMatchLbl.isHidden = true
            }
        
        var livematchesarray = [CLGFirbaseArrModel]()
        livematchesarray.removeAll()
        for dict in fireBaseGlobalModelNew{
            if let ostus = dict.con?.ostus{
                if ostus.isEmpty{
                    if (dict.con?.mstus == "L") && (!(dict.t1?.f?.contains("Testing") ?? true) && !(dict.t2?.f?.contains("Testing") ?? true)){
                        livematchesarray.append(dict)
                    }
                }
            }
            else{
                if (dict.con?.mstus == "L") && (!(dict.t1?.f?.contains("Testing") ?? true) && !(dict.t2?.f?.contains("Testing") ?? true)){
                    livematchesarray.append(dict)
                }
            }
            
        }
        if let tabItems = self.tabBarController?.tabBar.items {
            // In this case we want to modify the badge number of the third tab:
            let tabItem = tabItems[1]
            if livematchesarray.count > 0{
                tabItem.badgeValue = "\(livematchesarray.count)"
            }
            else{
                tabItem.badgeValue = nil
            }
        }
        AppHelper.hideHud()
    }
    
    private func setUp()
    {
        AppHelper.showHud(type:2)
        tvHome.register(UINib(nibName: "HomeNewsAdCell", bundle: nil), forCellReuseIdentifier: "HomeNewsAdCell")
        cvHome.register(UINib(nibName: "HomeMatchAdCell", bundle: nil), forCellWithReuseIdentifier: "HomeMatchAdCell")
        self.setupNavigationBarTitle("CRICKET LINE GURU", navBG: "", leftBarButtonsType: [], rightBarButtonsType: [])
        self.hideNavigationBar(false)
        activityIndicator.isHidden = true
        pageControl.numberOfPages = fireBaseGlobalModelNew.count
        pageControl.addTarget(self, action: #selector(self.pageControlTapHandler(sender:)), for: .valueChanged)
        tvHome.estimatedRowHeight = 300
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.3, execute: {
            self.setHomeApiData()
        })
        hitRecordsApi()
        tvHome.contentInset=UIEdgeInsets.init(top:-35, left: 0, bottom: -40, right: 0)
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
    
    private func setHomeApiData()
    {
        if let _  = UserDefault.userDefaultForAny(key: "HomeDate") as? Double
        {
            self.updateUI(data:getHomeApiData())
        }
    }
    private func getHomeApiData()->HomeApiResponseV3
    {
        var homeData = [String:AnyObject]()
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
                string = (item.value(forKey: "homeApiData") as? String)!
            }
            
        } catch
        {
            print(error.localizedDescription)
        }
        if let data = string.data(using: .utf8)
        {
            do
            {
                homeData = try (JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject])!
            }
            catch
            {
                print(error.localizedDescription)
            }
        }
        return Mapper<HomeApiResponseV3>().map(JSON: homeData) ?? HomeApiResponseV3()
    }
    
    private func setHomeMatchCell(cell:HomeMatchCell,index:Int){
        cell.imgViewLeftTeam.image = #imageLiteral(resourceName: "TeamPlaceholder")
        cell.imgViewRightTeam.image = #imageLiteral(resourceName: "TeamPlaceholder")
        cell.lblLeftTeamScore.font = ScreenSize.SCREEN_WIDTH == 320 ? UIFont(name: "Lato-Bold", size: 16) : UIFont(name: "Lato-Bold", size: 18)
        cell.lblRightTeamScore.font = ScreenSize.SCREEN_WIDTH == 320 ? UIFont(name: "Lato-Bold", size: 16) : UIFont(name: "Lato-Bold", size: 18)
        
        
        if let nkey = tempFirebaseArr[index].t1?.n, nkey != ""{
            if let confirmedImage = UIImage(named: nkey.lowercased()) {
                cell.imgViewLeftTeam.image = confirmedImage
            }
            else{
                if let t1icStr = tempFirebaseArr[index].t1?.ic, t1icStr != ""
                {
                    let fullurlstr = (self.fbPath + t1icStr).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//                    cell.imgViewLeftTeam.af_setImage(withURL: URL(string: fullurlstr!+".png")!, placeholderImage: #imageLiteral(resourceName: "TeamPlaceholder"))
//
                    let fullUrl = fullurlstr!+".png"
                    print(fullUrl)
                        cell.imgViewLeftTeam.sd_setImage(with: URL(string: fullUrl)!, placeholderImage: #imageLiteral(resourceName: "TeamPlaceholder"))
                     
                
                }
                else{
                    if let fname = tempFirebaseArr[index].t1?.f{
                        
                        cell.imgViewLeftTeam.image = AppHelper.generateImageWithText(text: fname, image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:fname.uppercased()), size: CGSize(width: 50, height: 50)))
                        
                    }
                    else{
                        
                        cell.imgViewLeftTeam.image = AppHelper.generateImageWithText(text: "N/A", image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:"N/A"), size: CGSize(width: 50, height: 50)))
                        
                    }
                }
            }
        }
        else{
            if let t1icStr = tempFirebaseArr[index].t1?.ic, t1icStr != ""
            {
                let fullurlstr = (self.fbPath + t1icStr).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//                cell.imgViewLeftTeam.af_setImage(withURL: URL(string: fullurlstr!+".png")!, placeholderImage: #imageLiteral(resourceName: "TeamPlaceholder"))
                let fullUrl = fullurlstr!+".png"
                cell.imgViewLeftTeam.sd_setImage(with: URL(string: fullUrl)!, placeholderImage: #imageLiteral(resourceName: "TeamPlaceholder"))
            }
            else{
                if let fname = tempFirebaseArr[index].t1?.f{
                    
                    cell.imgViewLeftTeam.image = AppHelper.generateImageWithText(text: fname, image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:fname.uppercased()), size: CGSize(width: 50, height: 50)))
                    
                }
                else{
                    
                    cell.imgViewLeftTeam.image = AppHelper.generateImageWithText(text: "N/A", image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:"N/A"), size: CGSize(width: 50, height: 50)))
                    
                }
            }
        }
        if let nkey = tempFirebaseArr[index].t2?.n, nkey != ""{
            if let confirmedImage = UIImage(named: nkey.lowercased()) {
                cell.imgViewRightTeam.image = confirmedImage
            }
            else{
                if let t2icStr = tempFirebaseArr[index].t2?.ic, t2icStr != ""
                {
                    let fullurlstr = (self.fbPath + t2icStr).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//                    cell.imgViewRightTeam.af_setImage(withURL: URL(string: fullurlstr!+".png")!, placeholderImage: #imageLiteral(resourceName: "TeamPlaceholder"))
                    let fullUrl = fullurlstr!+".png"
                    cell.imgViewRightTeam.sd_setImage(with: URL(string: fullUrl)!, placeholderImage: #imageLiteral(resourceName: "TeamPlaceholder"))
                }
                else{
                    if let fname = tempFirebaseArr[index].t2?.f{
                        
                        cell.imgViewRightTeam.image = AppHelper.generateImageWithText(text: fname, image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:fname.uppercased()), size: CGSize(width: 50, height: 50)))
                        
                    }
                    else{
                        
                        cell.imgViewRightTeam.image = AppHelper.generateImageWithText(text: "N/A", image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:"N/A"), size: CGSize(width: 50, height: 50)))
                        
                    }
                }
            }
        }
        else{
            if let t2icStr = tempFirebaseArr[index].t2?.ic, t2icStr != ""
            {
                let fullurlstr = (self.fbPath + t2icStr).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//                cell.imgViewRightTeam.af_setImage(withURL: URL(string: fullurlstr!+".png")!, placeholderImage: #imageLiteral(resourceName: "TeamPlaceholder"))
                let fullUrl = fullurlstr!+".png"
                cell.imgViewRightTeam.sd_setImage(with: URL(string: fullUrl)!, placeholderImage: #imageLiteral(resourceName: "TeamPlaceholder"))
            }
            else{
                if let fname = tempFirebaseArr[index].t2?.f{
                    
                    cell.imgViewRightTeam.image = AppHelper.generateImageWithText(text: fname, image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:fname.uppercased()), size: CGSize(width: 50, height: 50)))
                    
                }
                else{
                    
                    cell.imgViewRightTeam.image = AppHelper.generateImageWithText(text: "N/A", image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:"N/A"), size: CGSize(width: 50, height: 50)))
                    
                }
                
            }
        }
        /*if tempFirebaseArr[index].t1?.ic != "" && tempFirebaseArr[index].t1?.ic != nil
        {
            if let t1icStr = tempFirebaseArr[index].t1?.ic{
                let fullurlstr = (self.fbPath + t1icStr).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                cell.imgViewLeftTeam.af_setImage(withURL: URL(string: fullurlstr!+".png")!, placeholderImage: #imageLiteral(resourceName: "TeamPlaceholder"))
            }
            
        }
        else
        {
            if let nkey = tempFirebaseArr[index].t1?.n, nkey != ""{
                if let fname = tempFirebaseArr[index].t1?.f{
                    cell.imgViewLeftTeam.image = AppHelper.loadImage(named: nkey.lowercased(),teamName:fname)
                }
                else{
                    cell.imgViewLeftTeam.image = AppHelper.loadImage(named: nkey.lowercased(),teamName:"N/A")
                }
                
            }
            else{
                if let fname = tempFirebaseArr[index].t1?.f{
                    
                    cell.imgViewLeftTeam.image = AppHelper.generateImageWithText(text: fname, image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:fname.uppercased()), size: CGSize(width: 50, height: 50)))
                    
                }
                else{
                    
                    cell.imgViewLeftTeam.image = AppHelper.generateImageWithText(text: "N/A", image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:"N/A"), size: CGSize(width: 50, height: 50)))
                    
                }
                
            }
            //self.ImgViewLeftTeam.image = #imageLiteral(resourceName: "TeamPlaceholder")
        }
        
        if tempFirebaseArr[index].t2?.ic != "" && tempFirebaseArr[index].t2?.ic != nil
        {
            if let t2icStr = tempFirebaseArr[index].t2?.ic{
                let fullUrlStr = (self.fbPath+t2icStr).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                cell.imgViewRightTeam.af_setImage(withURL: URL(string: fullUrlStr!+".png")!, placeholderImage: #imageLiteral(resourceName: "TeamPlaceholder"))
            }
            
        }
        else
        {
            if let nkey = tempFirebaseArr[index].t2?.n, nkey != ""{
                if let fname = tempFirebaseArr[index].t2?.f{
                    cell.imgViewRightTeam.image = AppHelper.loadImage(named: nkey.lowercased(),teamName:fname)
                }
                else{
                    cell.imgViewRightTeam.image = AppHelper.loadImage(named: nkey.lowercased(),teamName:"N/A")
                }
                
            }
            else{
                if let fname = tempFirebaseArr[index].t2?.f{
                    
                    cell.imgViewRightTeam.image = AppHelper.generateImageWithText(text: fname, image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:fname.uppercased()), size: CGSize(width: 50, height: 50)))
                    
                }
                else{
                    
                    cell.imgViewRightTeam.image = AppHelper.generateImageWithText(text: "N/A", image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:"N/A"), size: CGSize(width: 50, height: 50)))
                    
                }
                
            }
            //self.ImgViewLeftTeam.image = #imageLiteral(resourceName: "TeamPlaceholder")
        }*/
        let dateStr = AppHelper.getMatchDateAndTime(type:1,date:tempFirebaseArr[index].con?.mtm ?? "01/10/2018 11:52")
        cell.lblGroundDetails.text = dateStr
        cell.lblMatchInfo.text = (tempFirebaseArr[index].con?.sr)!+", "+((tempFirebaseArr[index].con?.mn) ?? "")
        
        //cell.lblFavTeam.text = "Fav - " + tempFirebaseArr[index].ft!
        /*if tempFirebaseArr[index].con?.mf == "Test"
        {
            //cell.lblRateOne.text = "-"
            //cell.lblRateTwo.text = "-"
            
            if tempFirebaseArr[index].mkt?.r1 != "" && tempFirebaseArr[index].mkt?.r3 != "" && tempFirebaseArr[index].mkt?.r5 != ""
            {
                if (Float(tempFirebaseArr[index].mkt?.r1 ?? "") ?? 0 < Float(tempFirebaseArr[index].mkt?.r3 ?? "") ?? 0) && (Float(tempFirebaseArr[index].mkt?.r1 ?? "") ?? 0 < Float(tempFirebaseArr[index].mkt?.r5 ?? "") ?? 0){
                    cell.lblRateOne.text = tempFirebaseArr[index].mkt?.r1
                    cell.lblRateTwo.text = tempFirebaseArr[index].mkt?.r2
                    if let team1 = tempFirebaseArr[index].t1{
                        cell.lblFavTeam.text = "Fav - " + (team1.n?.firstUppercased ?? "")
                    }
                    else{
                        cell.lblFavTeam.text = "Fav - "
                    }
                }
                else if (Float(tempFirebaseArr[index].mkt?.r3 ?? "") ?? 0 < Float(tempFirebaseArr[index].mkt?.r1 ?? "") ?? 0) && (Float(tempFirebaseArr[index].mkt?.r3 ?? "") ?? 0 < Float(tempFirebaseArr[index].mkt?.r5 ?? "") ?? 0){
                    cell.lblRateOne.text = tempFirebaseArr[index].mkt?.r3
                    cell.lblRateTwo.text = tempFirebaseArr[index].mkt?.r4
                    if let team2 = tempFirebaseArr[index].t2{
                        cell.lblFavTeam.text = "Fav - " + (team2.n?.firstUppercased ?? "")
                    }
                    else{
                        cell.lblFavTeam.text = "Fav - "
                    }
                }
                else if (Float(tempFirebaseArr[index].mkt?.r3 ?? "") ?? 0 == Float(tempFirebaseArr[index].mkt?.r1 ?? "") ?? 0) && (Float(tempFirebaseArr[index].mkt?.r3 ?? "") ?? 0 < Float(tempFirebaseArr[index].mkt?.r5 ?? "") ?? 0){
                    cell.lblRateOne.text = tempFirebaseArr[index].mkt?.r1
                    cell.lblRateTwo.text = tempFirebaseArr[index].mkt?.r2
                    if let team1 = tempFirebaseArr[index].t1{
                        cell.lblFavTeam.text = "Fav - " + (team1.n?.firstUppercased ?? "")
                    }
                    else{
                        cell.lblFavTeam.text = "Fav - "
                    }
                }
                else if (Float(tempFirebaseArr[index].mkt?.r3 ?? "") ?? 0 == Float(tempFirebaseArr[index].mkt?.r5 ?? "") ?? 0) && (Float(tempFirebaseArr[index].mkt?.r3 ?? "") ?? 0 < Float(tempFirebaseArr[index].mkt?.r1 ?? "") ?? 0){
                    cell.lblRateOne.text = tempFirebaseArr[index].mkt?.r3
                    cell.lblRateTwo.text = tempFirebaseArr[index].mkt?.r4
                    if let team2 = tempFirebaseArr[index].t2{
                        cell.lblFavTeam.text = "Fav - " + (team2.n?.firstUppercased ?? "")
                    }
                    else{
                        cell.lblFavTeam.text = "Fav - "
                    }
                }
                else if (Float(tempFirebaseArr[index].mkt?.r1 ?? "") ?? 0 == Float(tempFirebaseArr[index].mkt?.r5 ?? "") ?? 0) && (Float(tempFirebaseArr[index].mkt?.r1 ?? "") ?? 0 < Float(tempFirebaseArr[index].mkt?.r3 ?? "") ?? 0){
                    cell.lblRateOne.text = tempFirebaseArr[index].mkt?.r1
                    cell.lblRateTwo.text = tempFirebaseArr[index].mkt?.r2
                    if let team1 = tempFirebaseArr[index].t1{
                        cell.lblFavTeam.text = "Fav - " + (team1.n?.firstUppercased ?? "")
                    }
                    else{
                        cell.lblFavTeam.text = "Fav - "
                    }
                }
                else if (Float(tempFirebaseArr[index].mkt?.r1 ?? "") ?? 0 == Float(tempFirebaseArr[index].mkt?.r3 ?? "") ?? 0) && (Float(tempFirebaseArr[index].mkt?.r1 ?? "") ?? 0 == Float(tempFirebaseArr[index].mkt?.r5 ?? "") ?? 0){
                    cell.lblRateOne.text = tempFirebaseArr[index].mkt?.r1
                    cell.lblRateTwo.text = tempFirebaseArr[index].mkt?.r2
                    if let team1 = tempFirebaseArr[index].t1{
                        cell.lblFavTeam.text = "Fav - " + (team1.n?.firstUppercased ?? "")
                    }
                    else{
                        cell.lblFavTeam.text = "Fav - "
                    }
                }
                else{
                    cell.lblRateOne.text = tempFirebaseArr[index].mkt?.r5
                    cell.lblRateTwo.text = tempFirebaseArr[index].mkt?.r6
                    cell.lblFavTeam.text = "Fav - " + "Draw"
                }
            }
            else{
                cell.lblRateOne.text = "-"
                cell.lblRateTwo.text = "-"
                if let favTeam = tempFirebaseArr[index].ft{
                    cell.lblFavTeam.text = "Fav - " + favTeam.firstUppercased
                }
                else{
                    cell.lblFavTeam.text = "Fav - "
                }
            }
            
        }
        else
        {
            if let favTeam = tempFirebaseArr[index].ft{
                cell.lblFavTeam.text = "Fav - " + favTeam.firstUppercased
            }
            else{
                cell.lblFavTeam.text = "Fav - "
            }
            cell.lblRateOne.text = tempFirebaseArr[index].mkt?.r1 == "" ? "-" : tempFirebaseArr[index].mkt?.r1
            cell.lblRateTwo.text = tempFirebaseArr[index].mkt?.r2 == "" ? "-" : tempFirebaseArr[index].mkt?.r2
        }*/
        //cell.lblLeftTeam.text = tempFirebaseArr[index].t1?.n?.firstUppercased
        //cell.lblRightTeam.text = tempFirebaseArr[index].t2?.n?.firstUppercased
        if tempFirebaseArr[index].con?.mf == "Test"
        {
            //cell.lblRateOne.text = "-"
            //cell.lblRateTwo.text = "-"
            if let rt = tempFirebaseArr[index].rt, rt != ""{
                let rtArray = rt.components(separatedBy: ",")
                
                if rtArray[0] != "" && rtArray[2] != "" && rtArray[4] != ""
                {
                    if (Float(rtArray[0] ) ?? 0 < Float(rtArray[2]) ?? 0) && (Float(rtArray[0] ) ?? 0 < Float(rtArray[4] ) ?? 0){
                        cell.lblRateOne.text = rtArray[0]
                        cell.lblRateTwo.text = rtArray[1]
                        if let team1 = tempFirebaseArr[index].t1{
                            cell.lblFavTeam.text = "Fav - " + (team1.n?.firstUppercased ?? "")
                        }
                        else{
                            cell.lblFavTeam.text = "Fav - "
                        }
                    }
                    else if (Float(rtArray[2]) ?? 0 < Float(rtArray[0]) ?? 0) && (Float(rtArray[2]) ?? 0 < Float(rtArray[4]) ?? 0){
                        cell.lblRateOne.text = rtArray[2]
                        cell.lblRateTwo.text = rtArray[3]
                        if let team2 = tempFirebaseArr[index].t2{
                            cell.lblFavTeam.text = "Fav - " + (team2.n?.firstUppercased ?? "")
                        }
                        else{
                            cell.lblFavTeam.text = "Fav - "
                        }
                    }
                    else if (Float(rtArray[2]) ?? 0 == Float(rtArray[0]) ?? 0) && (Float(rtArray[2]) ?? 0 < Float(rtArray[4]) ?? 0){
                        cell.lblRateOne.text = rtArray[0]
                        cell.lblRateTwo.text = rtArray[1]
                        if let team1 = tempFirebaseArr[index].t1{
                            cell.lblFavTeam.text = "Fav - " + (team1.n?.firstUppercased ?? "")
                        }
                        else{
                            cell.lblFavTeam.text = "Fav - "
                        }
                    }
                    else if (Float(rtArray[2]) ?? 0 == Float(rtArray[4]) ?? 0) && (Float(rtArray[2]) ?? 0 < Float(rtArray[0]) ?? 0){
                        cell.lblRateOne.text = rtArray[2]
                        cell.lblRateTwo.text = rtArray[3]
                        if let team2 = tempFirebaseArr[index].t2{
                            cell.lblFavTeam.text = "Fav - " + (team2.n?.firstUppercased ?? "")
                        }
                        else{
                            cell.lblFavTeam.text = "Fav - "
                        }
                    }
                    else if (Float(rtArray[0]) ?? 0 == Float(rtArray[4]) ?? 0) && (Float(rtArray[0]) ?? 0 < Float(rtArray[2]) ?? 0){
                        cell.lblRateOne.text = rtArray[0]
                        cell.lblRateTwo.text = rtArray[1]
                        if let team1 = tempFirebaseArr[index].t1{
                            cell.lblFavTeam.text = "Fav - " + (team1.n?.firstUppercased ?? "")
                        }
                        else{
                            cell.lblFavTeam.text = "Fav - "
                        }
                    }
                    else if (Float(rtArray[0]) ?? 0 == Float(rtArray[2]) ?? 0) && (Float(rtArray[0]) ?? 0 == Float(rtArray[4]) ?? 0){
                        cell.lblRateOne.text = rtArray[0]
                        cell.lblRateTwo.text = rtArray[1]
                        if let team1 = tempFirebaseArr[index].t1{
                            cell.lblFavTeam.text = "Fav - " + (team1.n?.firstUppercased ?? "")
                        }
                        else{
                            cell.lblFavTeam.text = "Fav - "
                        }
                    }
                    else{
                        cell.lblRateOne.text = rtArray[4]
                        cell.lblRateTwo.text = rtArray[5]
                        cell.lblFavTeam.text = "Fav - " + "Draw"
                    }
                }
                else{
                    cell.lblRateOne.text = "-"
                    cell.lblRateTwo.text = "-"
                    cell.lblFavTeam.text = "Fav - "
                }
            }
            else{
                cell.lblRateOne.text = "-"
                cell.lblRateTwo.text = "-"
                cell.lblFavTeam.text = "Fav - "
            }
            
        }
        else
        {
            if let rt = tempFirebaseArr[index].rt, rt != ""{
                let rtArray = rt.components(separatedBy: ",")
                cell.lblFavTeam.text = "Fav - " + rtArray[0].firstUppercased
                cell.lblRateOne.text = rtArray[1] == "" ? "-" : rtArray[1]
                cell.lblRateTwo.text = rtArray[2] == "" ? "-" : rtArray[2]
            }
            else{
                cell.lblRateOne.text = "-"
                cell.lblRateTwo.text = "-"
                cell.lblFavTeam.text = "Fav - "
            }
            
        }
        if tempFirebaseArr[index].con?.mstus == "U"
        {
            cell.lblLeftTeamScore.text = ""
            cell.lblLeftTeamOver.text = ""
            cell.lblRightTeamScore.text = ""
            cell.lblRightTeamOver.text = ""
        }
        else
        {
            if tempFirebaseArr[index].con?.mf == "Test" {
            cell.lblLeftTeamScore.text = (tempFirebaseArr[index].i1?.sc)!+"/"+(tempFirebaseArr[index].i1?.wk)!
            cell.lblLeftTeamOver.text = (tempFirebaseArr[index].i1?.ov)! + " Over"
            if tempFirebaseArr[index].i2?.ov != "0" || tempFirebaseArr[index].i2?.sc != "0" || tempFirebaseArr[index].i2?.wk != "0"
            {
                cell.lblRightTeamScore.text = (tempFirebaseArr[index].i2?.sc)!+"/"+(tempFirebaseArr[index].i2?.wk)!
                cell.lblRightTeamOver.text = (tempFirebaseArr[index].i2?.ov)! + " Over"
            }
            else
            {
                cell.lblRightTeamScore.text = ""
                cell.lblRightTeamOver.text = ""
            }
            if tempFirebaseArr[index].i3?.ov != "0" || tempFirebaseArr[index].i3?.sc != "0" || tempFirebaseArr[index].i3?.wk != "0"
            {
//                if tempFirebaseArr[index].i3?.bt == tempFirebaseArr[index].i2?.bt
//                {
//                    cell.lblRightTeamScore.text = (tempFirebaseArr[index].i2?.sc)!+"/"+(tempFirebaseArr[index].i2?.wk)!+",\n"+(tempFirebaseArr[index].i3?.sc)!+"/"+(tempFirebaseArr[index].i3?.wk)!
//                    cell.lblRightTeamOver.text = (tempFirebaseArr[index].i3?.ov)!+" Over"
//                }
                if tempFirebaseArr[index].i3b == "t2"
                {
                    cell.lblRightTeamScore.text = (tempFirebaseArr[index].i2?.sc)!+"/"+(tempFirebaseArr[index].i2?.wk)!+",\n"+(tempFirebaseArr[index].i3?.sc)!+"/"+(tempFirebaseArr[index].i3?.wk)!
                    cell.lblRightTeamOver.text = (tempFirebaseArr[index].i3?.ov)!+" Over"
                }
                else
                {
                    cell.lblLeftTeamScore.text = (tempFirebaseArr[index].i1?.sc)!+"/"+(tempFirebaseArr[index].i1?.wk)!+",\n"+(tempFirebaseArr[index].i3?.sc)!+"/"+(tempFirebaseArr[index].i3?.wk)!
                    cell.lblLeftTeamOver.text = (tempFirebaseArr[index].i3?.ov)!+" Over"
                }
            }
            if tempFirebaseArr[index].i4?.ov != "0" || tempFirebaseArr[index].i4?.sc != "0" || tempFirebaseArr[index].i4?.wk != "0"
            {
//                if tempFirebaseArr[index].i3?.bt == tempFirebaseArr[index].i2?.bt
//                {
//                    cell.lblRightTeamScore.text = (tempFirebaseArr[index].i2?.sc)!+"/"+(tempFirebaseArr[index].i2?.wk)!+",\n"+(tempFirebaseArr[index].i3?.sc)!+"/"+(tempFirebaseArr[index].i3?.wk)!
//                    cell.lblRightTeamOver.text = (tempFirebaseArr[index].i3?.ov)!+" Over"
//                    cell.lblLeftTeamScore.text = (tempFirebaseArr[index].i1?.sc)!+"/"+(tempFirebaseArr[index].i1?.wk)!+",\n"+(tempFirebaseArr[index].i4?.sc)!+"/"+(tempFirebaseArr[index].i4?.wk)!
//                    cell.lblLeftTeamOver.text = (tempFirebaseArr[index].i4?.ov)!+" Over"
//
//                }
                if tempFirebaseArr[index].i3b == "t2"
                {
                    cell.lblRightTeamScore.text = (tempFirebaseArr[index].i2?.sc)!+"/"+(tempFirebaseArr[index].i2?.wk)!+",\n"+(tempFirebaseArr[index].i3?.sc)!+"/"+(tempFirebaseArr[index].i3?.wk)!
                    cell.lblRightTeamOver.text = (tempFirebaseArr[index].i3?.ov)!+" Over"
                    cell.lblLeftTeamScore.text = (tempFirebaseArr[index].i1?.sc)!+"/"+(tempFirebaseArr[index].i1?.wk)!+",\n"+(tempFirebaseArr[index].i4?.sc)!+"/"+(tempFirebaseArr[index].i4?.wk)!
                    cell.lblLeftTeamOver.text = (tempFirebaseArr[index].i4?.ov)!+" Over"
                    
                }
                else
                {
                    cell.lblLeftTeamScore.text = (tempFirebaseArr[index].i1?.sc)!+"/"+(tempFirebaseArr[index].i1?.wk)!+",\n"+(tempFirebaseArr[index].i3?.sc)!+"/"+(tempFirebaseArr[index].i3?.wk)!
                    cell.lblLeftTeamOver.text = (tempFirebaseArr[index].i3?.ov)!+" Over"
                    cell.lblRightTeamScore.text = (tempFirebaseArr[index].i2?.sc)!+"/"+(tempFirebaseArr[index].i2?.wk)!+",\n"+(tempFirebaseArr[index].i4?.sc)!+"/"+(tempFirebaseArr[index].i4?.wk)!
                    cell.lblRightTeamOver.text = (tempFirebaseArr[index].i4?.ov)!+" Over"
                }
            }
        }
            else{
                cell.lblLeftTeamScore.text = (tempFirebaseArr[index].i1?.sc)!+"/"+(tempFirebaseArr[index].i1?.wk)!
                cell.lblLeftTeamOver.text = (tempFirebaseArr[index].i1?.ov)! + " Over"
                if tempFirebaseArr[index].i2?.ov != "0" || tempFirebaseArr[index].i2?.sc != "0" || tempFirebaseArr[index].i2?.wk != "0"
                {
                    cell.lblRightTeamScore.text = (tempFirebaseArr[index].i2?.sc)!+"/"+(tempFirebaseArr[index].i2?.wk)!
                    cell.lblRightTeamOver.text = (tempFirebaseArr[index].i2?.ov)! + " Over"
                }
                else
                {
                    cell.lblRightTeamScore.text = ""
                    cell.lblRightTeamOver.text = ""
                }
            }
        }
        cell.lblLandingText.text = tempFirebaseArr[index].con?.lt != "" ? tempFirebaseArr[index].con?.lt : landingText(index:index)
        if let ostus = tempFirebaseArr[index].con?.ostus{
            if !ostus.isEmpty{
                cell.lblMatchStatus.text = ostus
            }
            else{
                if tempFirebaseArr[index].con?.mstus == "U"
                {
                    cell.lblMatchStatus.text = "Upcoming"
                }
                else if tempFirebaseArr[index].con?.mstus == "L"
                {
                    cell.lblMatchStatus.text = "Live"
                }
                else if tempFirebaseArr[index].con?.mstus == "F"
                {
                    cell.lblMatchStatus.text = "Finished"
                    //            cell.lblLandingText.text = tempFirebaseArr[index].con?.lt != "" ? tempFirebaseArr[index].con?.lt : landingText(index:index)
                }
            }
        }
        else{
            if tempFirebaseArr[index].con?.mstus == "U"
            {
                cell.lblMatchStatus.text = "Upcoming"
            }
            else if tempFirebaseArr[index].con?.mstus == "L"
            {
                cell.lblMatchStatus.text = "Live"
            }
            else if tempFirebaseArr[index].con?.mstus == "F"
            {
                cell.lblMatchStatus.text = "Finished"
                //            cell.lblLandingText.text = tempFirebaseArr[index].con?.lt != "" ? tempFirebaseArr[index].con?.lt : landingText(index:index)
            }
        }
        if tempFirebaseArr[index].con?.mstus == "U"{
            if tempFirebaseArr[index].t1?.f?.count ?? 0 > 15 || tempFirebaseArr[index].t2?.f?.count ?? 0 > 15{
                cell.lblLeftTeam.text = tempFirebaseArr[index].t1?.n?.firstUppercased
                cell.lblRightTeam.text = tempFirebaseArr[index].t2?.n?.firstUppercased
            }
            else{
                cell.lblLeftTeam.text = tempFirebaseArr[index].t1?.f?.firstUppercased
                cell.lblRightTeam.text = tempFirebaseArr[index].t2?.f?.firstUppercased
            }
        }
        else{
            cell.lblLeftTeam.text = tempFirebaseArr[index].t1?.n?.firstUppercased
            cell.lblRightTeam.text = tempFirebaseArr[index].t2?.n?.firstUppercased
        }
    }
    func openAppStore()
    {
        let url  = NSURL(string: "https://itunes.apple.com/in/app/cricket-line-guru/id1247859253?mt=8")
            if UIApplication.shared.canOpenURL(url! as URL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url! as URL)
            } else {
                // Fallback on earlier versions
                UIApplication.shared.openURL(url! as URL)
            }
        }
        else
        {
            Drop.down("Unable to open Appstore")
        }
    }
    
    /*private func landingText(index:Int) -> String
    {
        if tempFirebaseArr[index].con?.mf == "Test"{
        if tempFirebaseArr[index].i4?.ov != "0" || tempFirebaseArr[index].i4?.sc != "0" || tempFirebaseArr[index].i4?.wk != "0"
        {
            if tempFirebaseArr[index].i2?.bt == tempFirebaseArr[index].i3?.bt
            {
                let txt = "\((tempFirebaseArr[index].i4?.bt)! == "t1" ? tempFirebaseArr[index].t1!.f! : tempFirebaseArr[index].t2!.f!) needs \(((Int((tempFirebaseArr[index].i2?.sc)!)!+Int((tempFirebaseArr[index].i3?.sc)!)!)+1)-(Int((tempFirebaseArr[index].i1?.sc)!)!+Int((tempFirebaseArr[index].i4?.sc)!)!)) runs to win"
                
                if ((Int((tempFirebaseArr[index].i2?.sc)!)!+Int((tempFirebaseArr[index].i3?.sc)!)!)+1)-(Int((tempFirebaseArr[index].i1?.sc)!)!+Int((tempFirebaseArr[index].i4?.sc)!)!) <= 0
                {
                    return "\((tempFirebaseArr[index].i4?.bt)! == "t1" ? tempFirebaseArr[index].t1!.f! : tempFirebaseArr[index].t2!.f!) won the match"
                }
                return txt
            }
            else
            {
                let txt = "\((tempFirebaseArr[index].i4?.bt)! == "t1" ? tempFirebaseArr[index].t1!.f! : tempFirebaseArr[index].t2!.f!) needs \(((Int((tempFirebaseArr[index].i1?.sc)!)!+Int((tempFirebaseArr[index].i3?.sc)!)!)+1)-(Int((tempFirebaseArr[index].i2?.sc)!)!+Int((tempFirebaseArr[index].i4?.sc)!)!)) runs to win"
                
                if ((Int((tempFirebaseArr[index].i1?.sc)!)!+Int((tempFirebaseArr[index].i3?.sc)!)!)+1)-(Int((tempFirebaseArr[index].i2?.sc)!)!+Int((tempFirebaseArr[index].i4?.sc)!)!) <= 0
                {
                    return "\((tempFirebaseArr[index].i4?.bt)! == "t1" ? tempFirebaseArr[index].t1!.f! : tempFirebaseArr[index].t2!.f!) won the match"
                }
                return txt
            }
        }
        else if tempFirebaseArr[index].i3?.ov != "0" || tempFirebaseArr[index].i3?.sc != "0" || tempFirebaseArr[index].i3?.wk != "0"
        {
            if tempFirebaseArr[index].i2?.bt == tempFirebaseArr[index].i3?.bt
            {
                if Int((tempFirebaseArr[index].i1?.sc)!)! < (Int((tempFirebaseArr[index].i2?.sc)!)!+Int((tempFirebaseArr[index].i3?.sc)!)!)
                {
                    let txt = "\((tempFirebaseArr[index].i3?.bt)! == "t1" ? tempFirebaseArr[index].t1!.f! : tempFirebaseArr[index].t2!.f!) is leading by \((Int((tempFirebaseArr[index].i2?.sc)!)!+Int((tempFirebaseArr[index].i3?.sc)!)!)-Int((tempFirebaseArr[index].i1?.sc)!)!)"
                    return txt
                }
                else
                {
                    let txt = "\((tempFirebaseArr[index].i3?.bt)! == "t1" ? tempFirebaseArr[index].t1!.f! : tempFirebaseArr[index].t2!.f!) is trailing by \(Int((tempFirebaseArr[index].i1?.sc)!)!-(Int((tempFirebaseArr[index].i2?.sc)!)!+Int((tempFirebaseArr[index].i3?.sc)!)!))"
                    return txt
                }
            }
            else
            {
                if Int((tempFirebaseArr[index].i2?.sc)!)! < (Int((tempFirebaseArr[index].i1?.sc)!)!+Int((tempFirebaseArr[index].i3?.sc)!)!)
                {
                    let txt = "\((tempFirebaseArr[index].i3?.bt)! == "t1" ? tempFirebaseArr[index].t1!.f! : tempFirebaseArr[index].t2!.f!) is leading by \((Int((tempFirebaseArr[index].i1?.sc)!)!+Int((tempFirebaseArr[index].i3?.sc)!)!)-Int((tempFirebaseArr[index].i2?.sc)!)!)"
                    return txt
                }
                else
                {
                    let txt = "\((tempFirebaseArr[index].i3?.bt)! == "t1" ? tempFirebaseArr[index].t1!.f! : tempFirebaseArr[index].t2!.f!) is trailing by \(Int((tempFirebaseArr[index].i2?.sc)!)!-(Int((tempFirebaseArr[index].i1?.sc)!)!+Int((tempFirebaseArr[index].i3?.sc)!)!))"
                    return txt
                }
            }
        }
        else if (tempFirebaseArr[index].i2?.ov != "" || tempFirebaseArr[index].i2?.sc != "" || tempFirebaseArr[index].i2?.wk != "") && tempFirebaseArr[index].i2?.iov != "0"
        {
            if tempFirebaseArr[index].con?.mf == "Test"
            {
                if Int((tempFirebaseArr[index].i1?.sc)!)! < Int((tempFirebaseArr[index].i2?.sc)!)!
                {
                    let txt = "\((tempFirebaseArr[index].i2?.bt)! == "t1" ? tempFirebaseArr[index].t1!.f! : tempFirebaseArr[index].t2!.f!) is leading by \(Int((tempFirebaseArr[index].i2?.sc)!)!-Int((tempFirebaseArr[index].i1?.sc)!)!)"
                    return txt
                }
                else
                {
                    let txt = "\((tempFirebaseArr[index].i2?.bt)! == "t1" ? tempFirebaseArr[index].t1!.f! : tempFirebaseArr[index].t2!.f!) is trailing by \(Int((tempFirebaseArr[index].i1?.sc)!)!-Int((tempFirebaseArr[index].i2?.sc)!)!)"
                    return txt
                }
            }
            else
            {
                //let txt = "\((tempFirebaseArr[index].i2?.bt)! == "t1" ? tempFirebaseArr[index].t1!.n! : tempFirebaseArr[index].t2!.n!) needs \((Int((tempFirebaseArr[index].i1?.sc)!)!+1)-Int((tempFirebaseArr[index].i2?.sc)!)!) runs in \(ballRemaining(ov: (tempFirebaseArr[index].i2?.ov)!, iov: (tempFirebaseArr[index].i2?.iov)!)) balls to win"
                
                let txt = "\((tempFirebaseArr[index].i2?.bt)! == "t1" ? tempFirebaseArr[index].t1!.n! : tempFirebaseArr[index].t2!.n!) needs \((Int((tempFirebaseArr[index].i2?.tr)!)!)-Int((tempFirebaseArr[index].i2?.sc)!)!) runs in \(ballRemaining(ov: (tempFirebaseArr[index].i2?.ov)!, iov: (tempFirebaseArr[index].i2?.iov)!)) balls to win"
                
                
//                if ((Int((tempFirebaseArr[index].i1?.sc)!)!+1)-Int((tempFirebaseArr[index].i2?.sc)!)!) <= 0
//                {
//                    return "\((tempFirebaseArr[index].i2?.bt)! == "t1" ? tempFirebaseArr[index].t1!.n! : tempFirebaseArr[index].t2!.n!) won the match"
//                }
//                return txt
                
                if ((Int((tempFirebaseArr[index].i2?.tr)!)!)-Int((tempFirebaseArr[index].i2?.sc)!)!) <= 0
                {
                    return "\((tempFirebaseArr[index].i2?.bt)! == "t1" ? tempFirebaseArr[index].t1!.n! : tempFirebaseArr[index].t2!.n!) won the match"
                }
                return txt
            }
        }
    }
        else{
            if (tempFirebaseArr[index].i2?.ov != "" || tempFirebaseArr[index].i2?.sc != "" || tempFirebaseArr[index].i2?.wk != "") && tempFirebaseArr[index].i2?.iov != "0"
            {
                if tempFirebaseArr[index].con?.mf == "Test"
                {
                    if Int((tempFirebaseArr[index].i1?.sc)!)! < Int((tempFirebaseArr[index].i2?.sc)!)!
                    {
                        let txt = "\((tempFirebaseArr[index].i2?.bt)! == "t1" ? tempFirebaseArr[index].t1!.f! : tempFirebaseArr[index].t2!.f!) is leading by \(Int((tempFirebaseArr[index].i2?.sc)!)!-Int((tempFirebaseArr[index].i1?.sc)!)!)"
                        return txt
                    }
                    else
                    {
                        let txt = "\((tempFirebaseArr[index].i2?.bt)! == "t1" ? tempFirebaseArr[index].t1!.f! : tempFirebaseArr[index].t2!.f!) is trailing by \(Int((tempFirebaseArr[index].i1?.sc)!)!-Int((tempFirebaseArr[index].i2?.sc)!)!)"
                        return txt
                    }
                }
                else
                {
                    //let txt = "\((tempFirebaseArr[index].i2?.bt)! == "t1" ? tempFirebaseArr[index].t1!.f! : tempFirebaseArr[index].t2!.f!) needs \((Int((tempFirebaseArr[index].i1?.sc)!)!+1)-Int((tempFirebaseArr[index].i2?.sc)!)!) runs in \(ballRemaining(ov: (tempFirebaseArr[index].i2?.ov)!, iov: (tempFirebaseArr[index].i2?.iov)!)) balls to win"
                    let txt = "\((tempFirebaseArr[index].i2?.bt)! == "t1" ? tempFirebaseArr[index].t1!.n! : tempFirebaseArr[index].t2!.n!) needs \((Int((tempFirebaseArr[index].i2?.tr)!)!)-Int((tempFirebaseArr[index].i2?.sc)!)!) runs in \(ballRemaining(ov: (tempFirebaseArr[index].i2?.ov)!, iov: (tempFirebaseArr[index].i2?.iov)!)) balls to win"
                    
//                    if ((Int((tempFirebaseArr[index].i1?.sc)!)!+1)-Int((tempFirebaseArr[index].i2?.sc)!)!) <= 0
//                    {
//                        return "\((tempFirebaseArr[index].i2?.bt)! == "t1" ? tempFirebaseArr[index].t1!.f! : tempFirebaseArr[index].t2!.f!) won the match"
//                    }
                    if ((Int((tempFirebaseArr[index].i2?.tr)!)!)-Int((tempFirebaseArr[index].i2?.sc)!)!) <= 0
                    {
                        return "\((tempFirebaseArr[index].i2?.bt)! == "t1" ? tempFirebaseArr[index].t1!.n! : tempFirebaseArr[index].t2!.n!) won the match"
                    }
                    return txt
                }
            }
        }
        return ""
    }*/
    private func landingText(index:Int) -> String
    {
        if tempFirebaseArr[index].con?.mf == "Test"{
            if tempFirebaseArr[index].i4?.ov != "0" || tempFirebaseArr[index].i4?.sc != "0" || tempFirebaseArr[index].i4?.wk != "0"
            {
                if tempFirebaseArr[index].i3b == "t2"
                {
                    let txt = "\(tempFirebaseArr[index].i3b == "t2" ? tempFirebaseArr[index].t1!.f! : tempFirebaseArr[index].t2!.f!) needs \(((Int((tempFirebaseArr[index].i2?.sc)!)!+Int((tempFirebaseArr[index].i3?.sc)!)!)+1)-(Int((tempFirebaseArr[index].i1?.sc)!)!+Int((tempFirebaseArr[index].i4?.sc)!)!)) runs to win"
                    
                    if ((Int((tempFirebaseArr[index].i2?.sc)!)!+Int((tempFirebaseArr[index].i3?.sc)!)!)+1)-(Int((tempFirebaseArr[index].i1?.sc)!)!+Int((tempFirebaseArr[index].i4?.sc)!)!) <= 0
                    {
                        return "\(tempFirebaseArr[index].i3b == "t2" ? tempFirebaseArr[index].t1!.f! : tempFirebaseArr[index].t2!.f!) won the match"
                    }
                    return txt
                }
                else
                {
                    let txt = "\(tempFirebaseArr[index].i3b == "t2" ? tempFirebaseArr[index].t1!.f! : tempFirebaseArr[index].t2!.f!) needs \(((Int((tempFirebaseArr[index].i1?.sc)!)!+Int((tempFirebaseArr[index].i3?.sc)!)!)+1)-(Int((tempFirebaseArr[index].i2?.sc)!)!+Int((tempFirebaseArr[index].i4?.sc)!)!)) runs to win"
                    
                    if ((Int((tempFirebaseArr[index].i1?.sc)!)!+Int((tempFirebaseArr[index].i3?.sc)!)!)+1)-(Int((tempFirebaseArr[index].i2?.sc)!)!+Int((tempFirebaseArr[index].i4?.sc)!)!) <= 0
                    {
                        return "\(tempFirebaseArr[index].i3b == "t2" ? tempFirebaseArr[index].t1!.f! : tempFirebaseArr[index].t2!.f!) won the match"
                    }
                    return txt
                }
            }
            else if tempFirebaseArr[index].i3?.ov != "0" || tempFirebaseArr[index].i3?.sc != "0" || tempFirebaseArr[index].i3?.wk != "0"
            {
                if tempFirebaseArr[index].i3b == "t2"
                {
                    if Int((tempFirebaseArr[index].i1?.sc)!)! < (Int((tempFirebaseArr[index].i2?.sc)!)!+Int((tempFirebaseArr[index].i3?.sc)!)!)
                    {
                        let txt = "\(tempFirebaseArr[index].i3b == "t1" ? tempFirebaseArr[index].t1!.f! : tempFirebaseArr[index].t2!.f!) is leading by \((Int((tempFirebaseArr[index].i2?.sc)!)!+Int((tempFirebaseArr[index].i3?.sc)!)!)-Int((tempFirebaseArr[index].i1?.sc)!)!)"
                        return txt
                    }
                    else
                    {
                        let txt = "\(tempFirebaseArr[index].i3b == "t1" ? tempFirebaseArr[index].t1!.f! : tempFirebaseArr[index].t2!.f!) is trailing by \(Int((tempFirebaseArr[index].i1?.sc)!)!-(Int((tempFirebaseArr[index].i2?.sc)!)!+Int((tempFirebaseArr[index].i3?.sc)!)!))"
                        return txt
                    }
                }
                else
                {
                    if Int((tempFirebaseArr[index].i2?.sc)!)! < (Int((tempFirebaseArr[index].i1?.sc)!)!+Int((tempFirebaseArr[index].i3?.sc)!)!)
                    {
                        let txt = "\(tempFirebaseArr[index].i3b == "t1" ? tempFirebaseArr[index].t1!.f! : tempFirebaseArr[index].t2!.f!) is leading by \((Int((tempFirebaseArr[index].i1?.sc)!)!+Int((tempFirebaseArr[index].i3?.sc)!)!)-Int((tempFirebaseArr[index].i2?.sc)!)!)"
                        return txt
                    }
                    else
                    {
                        let txt = "\(tempFirebaseArr[index].i3b == "t1" ? tempFirebaseArr[index].t1!.f! : tempFirebaseArr[index].t2!.f!) is trailing by \(Int((tempFirebaseArr[index].i2?.sc)!)!-(Int((tempFirebaseArr[index].i1?.sc)!)!+Int((tempFirebaseArr[index].i3?.sc)!)!))"
                        return txt
                    }
                }
            }
            else if (tempFirebaseArr[index].i2?.ov != "0" || tempFirebaseArr[index].i2?.sc != "0" || tempFirebaseArr[index].i2?.wk != "0") 
            {
                if tempFirebaseArr[index].con?.mf == "Test"
                {
                    if Int((tempFirebaseArr[index].i1?.sc)!)! < Int((tempFirebaseArr[index].i2?.sc)!)!
                    {
                        let txt = "\(tempFirebaseArr[index].i1b == "t2" ? tempFirebaseArr[index].t1!.f! : tempFirebaseArr[index].t2!.f!) is leading by \(Int((tempFirebaseArr[index].i2?.sc)!)!-Int((tempFirebaseArr[index].i1?.sc)!)!)"
                        return txt
                    }
                    else
                    {
                        let txt = "\(tempFirebaseArr[index].i1b == "t2" ? tempFirebaseArr[index].t1!.f! : tempFirebaseArr[index].t2!.f!) is trailing by \(Int((tempFirebaseArr[index].i1?.sc)!)!-Int((tempFirebaseArr[index].i2?.sc)!)!)"
                        return txt
                    }
                }
                else
                {
                    
                    let txt = "\(tempFirebaseArr[index].i1b == "t2" ? tempFirebaseArr[index].t1!.n! : tempFirebaseArr[index].t2!.n!) needs \((Int((tempFirebaseArr[index].i2?.tr)!)!)-Int((tempFirebaseArr[index].i2?.sc)!)!) runs in \(ballRemaining(ov: (tempFirebaseArr[index].i2?.ov)!, iov: (tempFirebaseArr[index].iov! == "" ? "0":tempFirebaseArr[index].iov!))) balls to win"
                    
                    
                    if ((Int((tempFirebaseArr[index].i2?.tr)!)!)-Int((tempFirebaseArr[index].i2?.sc)!)!) <= 0
                    {
                        return "\(tempFirebaseArr[index].i1b == "t2" ? tempFirebaseArr[index].t1!.n! : tempFirebaseArr[index].t2!.n!) won the match"
                    }
                    return txt
                }
            }
        }
        else{
            if (tempFirebaseArr[index].i2?.ov != "0" || tempFirebaseArr[index].i2?.sc != "0" || tempFirebaseArr[index].i2?.wk != "0")
            {
                if tempFirebaseArr[index].con?.mf == "Test"
                {
                    if Int((tempFirebaseArr[index].i1?.sc)!)! < Int((tempFirebaseArr[index].i2?.sc)!)!
                    {
                        let txt = "\(tempFirebaseArr[index].i1b == "t2" ? tempFirebaseArr[index].t1!.f! : tempFirebaseArr[index].t2!.f!) is leading by \(Int((tempFirebaseArr[index].i2?.sc)!)!-Int((tempFirebaseArr[index].i1?.sc)!)!)"
                        return txt
                    }
                    else
                    {
                        let txt = "\(tempFirebaseArr[index].i1b == "t2" ? tempFirebaseArr[index].t1!.f! : tempFirebaseArr[index].t2!.f!) is trailing by \(Int((tempFirebaseArr[index].i1?.sc)!)!-Int((tempFirebaseArr[index].i2?.sc)!)!)"
                        return txt
                    }
                }
                else
                {
                    let txt = "\(tempFirebaseArr[index].i1b == "t2" ? tempFirebaseArr[index].t1!.n! : tempFirebaseArr[index].t2!.n!) needs \((Int((tempFirebaseArr[index].i2?.tr)!)!)-Int((tempFirebaseArr[index].i2?.sc)!)!) runs in \(ballRemaining(ov: (tempFirebaseArr[index].i2?.ov)!, iov: (tempFirebaseArr[index].iov! == "" ? "0":tempFirebaseArr[index].iov!))) balls to win"
                    
                    if ((Int((tempFirebaseArr[index].i2?.tr)!)!)-Int((tempFirebaseArr[index].i2?.sc)!)!) <= 0
                    {
                        return "\(tempFirebaseArr[index].i1b == "t2" ? tempFirebaseArr[index].t1!.n! : tempFirebaseArr[index].t2!.n!) won the match"
                    }
                    return txt
                }
            }
        }
        return ""
    }
    func ballRemaining(ov:String,iov:String) -> Int
    {
        let tempOv = balls(str:ov)
        let tempIov = balls(str:iov)
        return (tempIov-tempOv)
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
    private func updateUI(data:HomeApiResponseV3)
    {
        if let seriesarr = (data.responseData?.series){
            self.seriesArr = seriesarr
        }
        //self.seriesArr = (data.responseData?.series)!
        if let apiinfo = (data.responseData?.api){
            AppHelper.appDelegate().apiInfo = apiinfo
        }
        //AppHelper.appDelegate().apiInfo = (data.responseData?.series)!
        if let newss = (data.responseData?.news){
            self.newArr = newss
            for (index, dict) in self.newArr.enumerated(){
                if dict.type == 2{
                    if let iosUrl = dict.ios_url, iosUrl != ""{
                        
                    }
                    else{
                        self.newArr.remove(at: index)
                    }
                }
            }
        }
        //self.newArr = (data.responseData?.news)!
        if let newspath = (data.responseData?.newsPath){
            self.newsPath = newspath
        }
        //self.newsPath = (data.responseData?.newsPath)!
        if let fbpath = (data.responseData?.fbPath){
            self.fbPath = fbpath
        }
        //self.fbPath = (data.responseData?.fbPath)!
        UserDefault.saveToUserDefault(value: self.fbPath as AnyObject, key: "FbBasePath")

        if let minVersion = data.responseData?.vers?.iMV,
        let appVersion = (Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String)
        {
            if minVersion > Double(appVersion)!
            {
            UserDefault.saveToUserDefault(value: "1" as AnyObject, key: "ForceUpdate")
            let alert = UIAlertController(title: "Cricket Line Guru", message:"Please update to our latest version", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (data) in
            self.openAppStore()
            }))
            self.present(alert, animated: true, completion: nil)
            AppHelper.hideHud()
            }
            else
            {
            UserDefault.saveToUserDefault(value: "0" as AnyObject, key: "ForceUpdate")
            if let latestVersion = data.responseData?.vers?.iLV,
            let appVersion = (Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String)
                {
                    if latestVersion > Double(appVersion)!
                    {
                        UserDefault.saveToUserDefault(value: "1" as AnyObject, key: "ShowUpdateBtn")
                        let DisplayUpdatePopup : NSString = UserDefault.userDefaultForKey(key: "DisplayUpdatePopup") as NSString
                        if DisplayUpdatePopup.isEqual(to: "") || DisplayUpdatePopup.isEqual(NSNull())
                        {
                            UserDefault.saveToUserDefault(value: latestVersion as AnyObject, key: "DisplayUpdatePopup")
                            let alert = UIAlertController(title: "Cricket Line Guru", message:"New version aviailable. Please update to our latest version", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (data) in
                            self.openAppStore()
                            }))
                            alert.addAction(UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.default, handler: { (data) in
                            }))
    
                            self.present(alert, animated: true, completion: nil)
                            AppHelper.hideHud()
                        }
                        else
                        {
                            if UserDefault.userDefaultForAny(key: "DisplayUpdatePopup") as! Double != latestVersion
                            {
                                UserDefault.saveToUserDefault(value: latestVersion as AnyObject, key: "DisplayUpdatePopup")
                                let alert = UIAlertController(title: "Cricket Line Guru", message:"New version aviailable. Please update to our latest version", preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (data) in
                                self.openAppStore()
                                }))
                                alert.addAction(UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.default, handler: { (data) in
                                }))
    
                                self.present(alert, animated: true, completion: nil)
                                AppHelper.hideHud()
                            }
    
                        }
                    }
                    else
                    {
                        UserDefault.saveToUserDefault(value: "0" as AnyObject, key: "ShowUpdateBtn")
                    }
                }
            }
        }
        self.tvHome.reloadData()

    }
    private func hitApi()
    {
        var isNews = 1;
        var isSeries = 1;
        if let isNewsTemp = UserDefaults.standard.value(forKey: "isNews") as? Int64
        {
            isNews = ((Date().toMillis()) > isNewsTemp) ? 1 : 0
        }
        if let isSeriesTemp = UserDefaults.standard.value(forKey: "isSeries") as? Int64
        {
            isSeries = Date().toMillis() > isSeriesTemp ? 1 : 0
        }
        let param = ["isNews":isNews, "isSeries":isSeries,"IsRec":1]
        CLGUserService().HomeService(url:NewBaseUrlV4+Home, method: .get, showLoader: 0, header: header, parameters: param).then(execute: { (data) -> Void in
           
            if data.statusCode == 1
            {
                let homeApiData = self.getHomeApiData()
                    if isNews == 0
                    {
                        data.responseData?.news = homeApiData.responseData?.news
                        data.responseData?.newsPath = homeApiData.responseData?.newsPath
                        
                    }
                    if isSeries == 0
                    {
                        data.responseData?.series = homeApiData.responseData?.series
                    }
                    let currentDate = Date().toMillis()
                    let homeData =  try! JSONSerialization.data(withJSONObject: data.toJSON() as Any, options: [])
                    let jsonData = String(data:homeData, encoding:.utf8)!
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
                            apiDataObj.homeApiData = jsonData
                        }
                        else
                        {
                            for item in items
                            {
                                item.homeApiData = jsonData
                            }
                        }
                        try context.save()
                    }
                    catch
                    {
                        
                    }
                UserDefault.saveToUserDefault(value: currentDate as AnyObject, key: "HomeDate")
//                UserDefault.saveToUserDefault(value: (currentDate!+86400000) as AnyObject, key: "isNews")
//                UserDefault.saveToUserDefault(value: (currentDate!+21600000) as AnyObject, key: "isSeries")
                UserDefault.saveToUserDefault(value: (currentDate!+900000) as AnyObject, key: "isNews")
                UserDefault.saveToUserDefault(value: (currentDate!+900000) as AnyObject, key: "isSeries")
                self.reloadBtn.isHidden = true
                self.updateUI(data:data)
            }
        }).catch { (error) in
            print(error)
            if self.seriesArr.count == 0 && self.newArr.count == 0
            {
                self.reloadBtn.isHidden = false
            }
            if self.currentReachabilityStatus == .notReachable
            {
                self.noMatchLbl.text = "No internet connection"
                self.noMatchLbl.isHidden = false
            }
        }
    }
    
    //MARK:-IBAction
    
    func hitRecordsApi() {
        let serviceName = "https://clgphase2.cricketlineguru.in/clg/api/v4/match/home?isNews=0&isSeries=0&isRec=1"
        Alamofire.request(serviceName, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            if response.result.isSuccess {
                guard let response = response.result.value else {return}
                let json = JSON(response)
                if json["statusCode"].stringValue == "1" {
                    self.recordsApiCalled = true
                    self.playerBaseUrl = json["responseData"]["pP"].stringValue
                    self.teamBaseUrl = json["responseData"]["tp"].stringValue
                    self.firebaseBaseUrl = json["responseData"]["fbPath"].stringValue
                    let records = json["responseData"]["records"]["rec"]
                    if records.isEmpty {
                        self.iplHasData = false
                    }
                    else {
                        self.iplHasData = true
                    }
                    for i in 0..<records.count {
                        if records[i]["name"].stringValue == "Most Runs" {
                            let dataJson = records[i]["data"]
                            for i in 0..<dataJson.count {
                                let singleObject = IPLPlayersModel.init(json: dataJson[i])
                                self.mostRunsModel.append(singleObject)
                            }
                        }
                        else if records[i]["name"].stringValue == "Most Wickets" {
                            let dataJson = records[i]["data"]
                            for i in 0..<dataJson.count {
                                let singleObject = IPLPlayersModel.init(json: dataJson[i])
                                self.mostWicketsModel.append(singleObject)
                            }
                        }
                        else if records[i]["name"].stringValue == "Orange Cap" {
                            let dataJson = records[i]["data"]
                            for i in 0..<dataJson.count {
                                let singleObject = IPLCapHolderModel.init(json: dataJson[i])
                                self.orangeCapModel.append(singleObject)
                            }
                        }
                        else if records[i]["name"].stringValue == "Purple Cap" {
                            let dataJson = records[i]["data"]
                            for i in 0..<dataJson.count {
                                let singleObject = IPLCapHolderModel.init(json: dataJson[i])
                                self.purpleCapModel.append(singleObject)
                            }
                        }
                        else {
                            let smallJson = records[i]["small"]
                            for i in 0..<smallJson.count {
                                let singleRecord = IPLExtraStatsModel.init(json: smallJson[i])
                                self.extraStatsModel.append(singleRecord)
                            }
                            let largeJson = records[i]["large"]["winner"]
                            for i in 0..<largeJson.count {
                                let singleRecord = IPLWinnerModel.init(json: largeJson[i])
                                self.winnerModel.append(singleRecord)
                            }
                        }
                    }
                    self.tvHome.reloadData()
                }
                else {
                    print("IPL records not available")
                }
            }
            else {
                if let kError = response.error?.localizedDescription {
                    Drop.down(kError)
                }
            }
        }
    }
    
  
    @IBAction func reloadBtnAction(_ sender: Any) {
        hitApi()
    }
    //MARK:-Page Controller Action
    @objc func pageControlTapHandler(sender:UIPageControl) {
        //  print("currentPage:", sender.currentPage) //currentPage: 1
        
        if currentIndex < 15 && (sender as AnyObject).currentPage > currentIndex {
            currentIndex = (sender as AnyObject).currentPage
            self.cvHome.scrollToItem(at:IndexPath(item: currentIndex, section: 0), at: .right, animated: true)
            
            // Move to Left
        } else if currentIndex > 0 {
            currentIndex = (sender as AnyObject).currentPage
            self.cvHome.scrollToItem(at:IndexPath(item: currentIndex, section: 0), at: .left, animated: true)
            
        }
        
    }

}

extension HomeVC:UICollectionViewDelegate
{
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        if nativeAds.count > 0
        {
            if indexPath.item == 3 || indexPath.item == 7 || indexPath.item == 11 || (indexPath.item) == 15 || (indexPath.item) == 19
            {
                return
            }
            else
            {
                var a = 0
                /*if (indexPath.item) > 11
                {
                    a = 3
                }
                else if (indexPath.item) > 7
                {
                    a = 2
                }
                else if (indexPath.item) > 3
                {
                    a = 1
                }*/
                if (indexPath.item) == 23 || (indexPath.item) > 23{
                    if nativeAds.count > 0{
                        a = 6
                    }
                    else{
                        a = 0
                    }
                }
                else if (indexPath.item) == 19 || (indexPath.item) > 19 && (indexPath.item) < 23{
                    if nativeAds.count > 0{
                        a = 5
                    }
                    else{
                        a = 0
                    }
                }
                else if (indexPath.item) == 15 || (indexPath.item) > 15 && (indexPath.item) < 19{
                    if nativeAds.count > 0{
                        a = 4
                    }
                    else{
                        a = 0
                    }
                }
                else if (indexPath.item) == 11 || (indexPath.item) > 11 && (indexPath.item) < 15
                {
                    if nativeAds.count > 0{
                        a = 3
                    }
                    else{
                        a = 0
                    }
                }
                else if (indexPath.item) == 7 || (indexPath.item) > 7 && (indexPath.item) < 11
                {
                    if nativeAds.count > 0{
                        a = 2
                    }
                    else{
                        a = 0
                    }
                }
                else if (indexPath.item) == 3 || (indexPath.item) > 3 && (indexPath.item) < 7
                {
                    if nativeAds.count > 0{
                        a = 1
                    }
                    else{
                        a = 0
                    }
                    
                }
                let vc  = AppHelper.intialiseViewController(fromMainStoryboard: "Main", withName: "MatchLineVC") as! MatchLineVC
                FireBaseHomeObservers().removeObservers(ref:AppHelper.appDelegate().ref)
                fireBaseGlobalModel = tempFirebaseArr
                FireBaseHomeObservers().setHomeScreenObserver(ref:AppHelper.appDelegate().ref)
                vc.index = (indexPath.item-a)
                vc.fbPath = self.fbPath
                vc.vcType = "Home"
                self.navigationController?.pushViewController(vc, animated: true)
//                let newNav = UINavigationController(rootViewController: vc)
//                self.present(newNav, animated: true, completion: nil)
                
            }
        }
        else
        {
            let vc  = AppHelper.intialiseViewController(fromMainStoryboard: "Main", withName: "MatchLineVC") as! MatchLineVC
            FireBaseHomeObservers().removeObservers(ref:AppHelper.appDelegate().ref)
            fireBaseGlobalModel = tempFirebaseArr
            FireBaseHomeObservers().setHomeScreenObserver(ref:AppHelper.appDelegate().ref)
            vc.index = indexPath.row
            vc.fbPath = self.fbPath
            vc.vcType = "Home"
            self.navigationController?.pushViewController(vc, animated: true)
//            let newNav = UINavigationController(rootViewController: vc)
//            self.present(newNav, animated: true, completion:nil)
            
        }
    }
}

extension HomeVC:UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if fireBaseGlobalModelNew.count != 0 && fireBaseGlobalModelNew.count != nil
        {
            tempFirebaseArr = fireBaseGlobalModelNew.sorted(by: {Int($0.ao!)! < Int($1.ao!)!})
        }
        if nativeAds.count>0
        {
            let a = fireBaseGlobalModelNew.count != 0 ? fireBaseGlobalModelNew.count/3 : 0
            pageControl.numberOfPages = fireBaseGlobalModelNew.count + a
            return fireBaseGlobalModelNew.count + a
        }
        else
        {
            pageControl.numberOfPages = fireBaseGlobalModelNew.count
            return fireBaseGlobalModelNew.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        print("IndexPath Item = ", indexPath.item)
//        if nativeAds.count>0
//        {
//
//        if (indexPath.item) == 3 || (indexPath.item) == 7 || (indexPath.item) == 11 || (indexPath.item) == 15 || (indexPath.item) == 19
//        {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeMatchAdCell", for: indexPath) as! HomeMatchAdCell
//            if let adView = cell.contentView.subviews.first as? GADUnifiedNativeAdView
//            {
//                if nativeAds.count == 1{
//                    nativeAds[0].rootViewController = self
//                    adView.nativeAd = nativeAds[0]
//                    (adView.headlineView as! UILabel).text = nativeAds[0].headline
//                    (adView.bodyView as! UILabel).text = nativeAds[0].body
//                    //(adView.advertiserView as! UILabel).text = nativeAds[0].advertiser
//                    (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
//                    (adView.callToActionView as! UIButton).setTitle(
//                        nativeAds[0].callToAction, for: UIControlState.normal)
//                }
//                else if nativeAds.count == 2{
//                    if indexPath.item == 3{
//                        nativeAds[0].rootViewController = self
//                        adView.nativeAd = nativeAds[0]
//                        (adView.headlineView as! UILabel).text = nativeAds[0].headline
//                        (adView.bodyView as! UILabel).text = nativeAds[0].body
//                        //(adView.advertiserView as! UILabel).text = nativeAds[0].advertiser
//                        (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
//                        (adView.callToActionView as! UIButton).setTitle(
//                            nativeAds[0].callToAction, for: UIControlState.normal)
//                    }
//                    else if indexPath.item == 7{
//                        nativeAds[1].rootViewController = self
//                        adView.nativeAd = nativeAds[1]
//                        (adView.headlineView as! UILabel).text = nativeAds[1].headline
//                        (adView.bodyView as! UILabel).text = nativeAds[1].body
//                        //(adView.advertiserView as! UILabel).text = nativeAds[0].advertiser
//                        (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
//                        (adView.callToActionView as! UIButton).setTitle(
//                            nativeAds[1].callToAction, for: UIControlState.normal)
//                    }
//                    else{
//                        nativeAds[1].rootViewController = self
//                        adView.nativeAd = nativeAds[1]
//                        (adView.headlineView as! UILabel).text = nativeAds[1].headline
//                        (adView.bodyView as! UILabel).text = nativeAds[1].body
//                        //(adView.advertiserView as! UILabel).text = nativeAds[0].advertiser
//                        (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
//                        (adView.callToActionView as! UIButton).setTitle(
//                            nativeAds[1].callToAction, for: UIControlState.normal)
//                    }
//                }
//                else if nativeAds.count == 3{
//                    if indexPath.item == 3{
//                        nativeAds[0].rootViewController = self
//                        adView.nativeAd = nativeAds[0]
//                        (adView.headlineView as! UILabel).text = nativeAds[0].headline
//                        (adView.bodyView as! UILabel).text = nativeAds[0].body
//                        //(adView.advertiserView as! UILabel).text = nativeAds[0].advertiser
//                        (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
//                        (adView.callToActionView as! UIButton).setTitle(
//                            nativeAds[0].callToAction, for: UIControlState.normal)
//                    }
//                    else if indexPath.item == 7{
//                        nativeAds[1].rootViewController = self
//                        adView.nativeAd = nativeAds[1]
//                        (adView.headlineView as! UILabel).text = nativeAds[1].headline
//                        (adView.bodyView as! UILabel).text = nativeAds[1].body
//                        //(adView.advertiserView as! UILabel).text = nativeAds[0].advertiser
//                        (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
//                        (adView.callToActionView as! UIButton).setTitle(
//                            nativeAds[1].callToAction, for: UIControlState.normal)
//                    }
//                    else{
//                        nativeAds[2].rootViewController = self
//                        adView.nativeAd = nativeAds[2]
//                        (adView.headlineView as! UILabel).text = nativeAds[2].headline
//                        (adView.bodyView as! UILabel).text = nativeAds[2].body
//                        //(adView.advertiserView as! UILabel).text = nativeAds[0].advertiser
//                        (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
//                        (adView.callToActionView as! UIButton).setTitle(
//                            nativeAds[2].callToAction, for: UIControlState.normal)
//                    }
//                }
//                else if nativeAds.count == 4{
//                    if indexPath.item == 3{
//                        nativeAds[0].rootViewController = self
//                        adView.nativeAd = nativeAds[0]
//                        (adView.headlineView as! UILabel).text = nativeAds[0].headline
//                        (adView.bodyView as! UILabel).text = nativeAds[0].body
//                        //(adView.advertiserView as! UILabel).text = nativeAds[0].advertiser
//                        (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
//                        (adView.callToActionView as! UIButton).setTitle(
//                            nativeAds[0].callToAction, for: UIControlState.normal)
//                    }
//                    else if indexPath.item == 7{
//                        nativeAds[1].rootViewController = self
//                        adView.nativeAd = nativeAds[1]
//                        (adView.headlineView as! UILabel).text = nativeAds[1].headline
//                        (adView.bodyView as! UILabel).text = nativeAds[1].body
//                        //(adView.advertiserView as! UILabel).text = nativeAds[0].advertiser
//                        (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
//                        (adView.callToActionView as! UIButton).setTitle(
//                            nativeAds[1].callToAction, for: UIControlState.normal)
//                    }
//                    else if indexPath.item == 11{
//                        nativeAds[2].rootViewController = self
//                        adView.nativeAd = nativeAds[2]
//                        (adView.headlineView as! UILabel).text = nativeAds[2].headline
//                        (adView.bodyView as! UILabel).text = nativeAds[2].body
//                        //(adView.advertiserView as! UILabel).text = nativeAds[0].advertiser
//                        (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
//                        (adView.callToActionView as! UIButton).setTitle(
//                            nativeAds[2].callToAction, for: UIControlState.normal)
//                    }
//                    else{
//                        nativeAds[3].rootViewController = self
//                        adView.nativeAd = nativeAds[3]
//                        (adView.headlineView as! UILabel).text = nativeAds[3].headline
//                        (adView.bodyView as! UILabel).text = nativeAds[3].body
//                        //(adView.advertiserView as! UILabel).text = nativeAds[0].advertiser
//                        (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
//                        (adView.callToActionView as! UIButton).setTitle(
//                            nativeAds[3].callToAction, for: UIControlState.normal)
//                    }
//                }
//                else{
//                    if indexPath.item == 3{
//                        nativeAds[0].rootViewController = self
//                        adView.nativeAd = nativeAds[0]
//                        (adView.headlineView as! UILabel).text = nativeAds[0].headline
//                        (adView.bodyView as! UILabel).text = nativeAds[0].body
//                        //(adView.advertiserView as! UILabel).text = nativeAds[0].advertiser
//                        (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
//                        (adView.callToActionView as! UIButton).setTitle(
//                            nativeAds[0].callToAction, for: UIControlState.normal)
//                    }
//                    else if indexPath.item == 7{
//                        nativeAds[1].rootViewController = self
//                        adView.nativeAd = nativeAds[1]
//                        (adView.headlineView as! UILabel).text = nativeAds[1].headline
//                        (adView.bodyView as! UILabel).text = nativeAds[1].body
//                        //(adView.advertiserView as! UILabel).text = nativeAds[0].advertiser
//                        (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
//                        (adView.callToActionView as! UIButton).setTitle(
//                            nativeAds[1].callToAction, for: UIControlState.normal)
//                    }
//                    else if indexPath.item == 11{
//                        nativeAds[2].rootViewController = self
//                        adView.nativeAd = nativeAds[2]
//                        (adView.headlineView as! UILabel).text = nativeAds[2].headline
//                        (adView.bodyView as! UILabel).text = nativeAds[2].body
//                        //(adView.advertiserView as! UILabel).text = nativeAds[0].advertiser
//                        (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
//                        (adView.callToActionView as! UIButton).setTitle(
//                            nativeAds[2].callToAction, for: UIControlState.normal)
//                    }
//                    else if indexPath.item == 15{
//                        nativeAds[3].rootViewController = self
//                        adView.nativeAd = nativeAds[3]
//                        (adView.headlineView as! UILabel).text = nativeAds[3].headline
//                        (adView.bodyView as! UILabel).text = nativeAds[3].body
//                        //(adView.advertiserView as! UILabel).text = nativeAds[0].advertiser
//                        (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
//                        (adView.callToActionView as! UIButton).setTitle(
//                            nativeAds[3].callToAction, for: UIControlState.normal)
//                    }
//                    else{
//                        nativeAds[4].rootViewController = self
//                        adView.nativeAd = nativeAds[4]
//                        (adView.headlineView as! UILabel).text = nativeAds[4].headline
//                        (adView.bodyView as! UILabel).text = nativeAds[4].body
//                        //(adView.advertiserView as! UILabel).text = nativeAds[0].advertiser
//                        (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
//                        (adView.callToActionView as! UIButton).setTitle(
//                            nativeAds[4].callToAction, for: UIControlState.normal)
//                    }
//                }
//            }
//            return cell
//        }
//        else{
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeMatchCell", for: indexPath) as! HomeMatchCell
//            var a = 0
//            if (indexPath.item) == 23 || (indexPath.item) > 23{
//                if nativeAds.count > 0{
//                    a = 6
//                }
//                else{
//                    a = 0
//                }
//            }
//            else if (indexPath.item) == 19 || (indexPath.item) > 19 && (indexPath.item) < 23{
//                if nativeAds.count > 0{
//                    a = 5
//                }
//                else{
//                    a = 0
//                }
//            }
//            else if (indexPath.item) == 15 || (indexPath.item) > 15 && (indexPath.item) < 19{
//                if nativeAds.count > 0{
//                    a = 4
//                }
//                else{
//                    a = 0
//                }
//            }
//            else if (indexPath.item) == 11 || (indexPath.item) > 11 && (indexPath.item) < 15
//            {
//                if nativeAds.count > 0{
//                    a = 3
//                }
//                else{
//                    a = 0
//                }
//            }
//            else if (indexPath.item) == 7 || (indexPath.item) > 7 && (indexPath.item) < 11
//            {
//                if nativeAds.count > 0{
//                    a = 2
//                }
//                else{
//                    a = 0
//                }
//            }
//            else if (indexPath.item) == 3 || (indexPath.item) > 3 && (indexPath.item) < 7
//            {
//                if nativeAds.count > 0{
//                    a = 1
//                }
//                else{
//                    a = 0
//                }
//
//            }
//            setHomeMatchCell(cell:cell,index:(indexPath.item-a))
//            return cell
//            }
//        }
//        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeMatchCell", for: indexPath) as! HomeMatchCell
            setHomeMatchCell(cell:cell,index:(indexPath.item))
            return cell
//        }

    }
}

extension HomeVC:UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: self.cvHome.frame.width, height: self.cvHome.frame.height)
    }
}

extension HomeVC:UITableViewDelegate
{
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        if section == 1
        {
            if newArr.count != 0
            {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeHeaderCell")
            return cell
            }
            return UIView()
        }
        return UIView()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        if section == 1
        {
            return 20
        }
        return  0
    }
     func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
     {
        return  0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0{
            return UITableViewAutomaticDimension
        }
        else {
                if indexPath.row < 4 {
                    return 300
                }
                else if indexPath.row == 4 {
                    if self.iplHasData {
                        return 660
                    }
                    else {
                        return 0
                    }
                }
                else {
                    return 150
                }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.section == 0
        {
            if let _id = self.seriesArr[indexPath.row]._id{
                if let short_name = self.seriesArr[indexPath.row].name{
                    let vc = AppStoryboard.module2.instantiateViewController(withIdentifier: "SeasonSeriesMatchesVC") as! SeasonSeriesMatchesVC
                    vc.getSeriesIdFromPrevClass(id:_id,navTitle:short_name)
                    self.navigationController?.pushViewController(vc, animated: true)
//                    let newNav = UINavigationController(rootViewController: vc)
//                    self.present(newNav, animated: true, completion: nil)
                    tableView.deselectRow(at: indexPath, animated: true)
                }
            }
        }
        else
        {
            if nativeAds.count == 0 {
                if indexPath.row < 4 {
                    let selectedVC = AppStoryboard.main.instantiateViewController(withIdentifier: "LatestNewsSelectionVC") as! LatestNewsSelectionVC
                    selectedVC.getDataFromPrevClass(data: self.newArr[indexPath.row])
                    selectedVC.baseUrl = self.newsPath
    //                self.navigationController?.pushViewController(selectedVC, animated: true)
                    let newNav = UINavigationController(rootViewController: selectedVC)
                    self.present(newNav, animated: true, completion: nil)
                }
                else if indexPath.row == 4 {
                    
                }
                else {
                    let selectedVC = AppStoryboard.main.instantiateViewController(withIdentifier: "LatestNewsSelectionVC") as! LatestNewsSelectionVC
                    selectedVC.getDataFromPrevClass(data: self.newArr[indexPath.row - 1])
                    selectedVC.baseUrl = self.newsPath
    //                self.navigationController?.pushViewController(selectedVC, animated: true)
                    let newNav = UINavigationController(rootViewController: selectedVC)
                    self.present(newNav, animated: true, completion: nil)
                }
            }
            else {
                if indexPath.row < 4 {
                    if indexPath.row == 0 {
                        let selectedVC = AppStoryboard.main.instantiateViewController(withIdentifier: "LatestNewsSelectionVC") as! LatestNewsSelectionVC
                        selectedVC.getDataFromPrevClass(data: self.newArr[indexPath.row])
                        selectedVC.baseUrl = self.newsPath
        //                self.navigationController?.pushViewController(selectedVC, animated: true)
                        let newNav = UINavigationController(rootViewController: selectedVC)
                        self.present(newNav, animated: true, completion: nil)
                    }
                    else if indexPath.row == 1 {
                        
                    }
                    else {
                        let selectedVC = AppStoryboard.main.instantiateViewController(withIdentifier: "LatestNewsSelectionVC") as! LatestNewsSelectionVC
                        selectedVC.getDataFromPrevClass(data: self.newArr[indexPath.row - 1])
                        selectedVC.baseUrl = self.newsPath
        //                self.navigationController?.pushViewController(selectedVC, animated: true)
                        let newNav = UINavigationController(rootViewController: selectedVC)
                        self.present(newNav, animated: true, completion: nil)
                    }
                }
                else if indexPath.row == 4 {
                                
                }
                else {
                    let selectedVC = AppStoryboard.main.instantiateViewController(withIdentifier: "LatestNewsSelectionVC") as! LatestNewsSelectionVC
                    selectedVC.getDataFromPrevClass(data: self.newArr[indexPath.row - 2])
                    selectedVC.baseUrl = self.newsPath
    //                self.navigationController?.pushViewController(selectedVC, animated: true)
                    let newNav = UINavigationController(rootViewController: selectedVC)
                    self.present(newNav, animated: true, completion: nil)
                }
            }
//            if(newArr[indexPath.row].type == 1)
//            {
//                if let youtubeUrl = newArr[indexPath.row].url_link{
//                    if let urlStr = URL(string: youtubeUrl){
//                        if #available(iOS 10.0, *){
//                            UIApplication.shared.open(urlStr)
//                        }
//                        else{
//                            UIApplication.shared.openURL(urlStr)
//                        }
//                    }
//
//                }
//            }
//            else if(newArr[indexPath.row].type == 2)
//            {
//                if let iosUrl = newArr[indexPath.row].ios_url, iosUrl != ""{
//                    if let urlStr = URL(string: iosUrl){
//                        if #available(iOS 10.0, *){
//                            UIApplication.shared.open(urlStr)
//                        }
//                        else{
//                            UIApplication.shared.openURL(urlStr)
//                        }
//                    }
//
//                }
//            }
//            else
//            {
//                let selectedVC = AppStoryboard.main.instantiateViewController(withIdentifier: "LatestNewsSelectionVC") as! LatestNewsSelectionVC
//                selectedVC.getDataFromPrevClass(data: self.newArr[indexPath.row])
//                selectedVC.baseUrl = self.newsPath
//                let newNav = UINavigationController(rootViewController: selectedVC)
//                self.present(newNav, animated: true, completion: nil)
//            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension HomeVC:UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if section == 0
        {
            return seriesArr.count
        }
        else {
            if recordsApiCalled {
                if nativeAds.count == 0 {
                    return newArr.count + 1
                }
                else {
                    return newArr.count + 2
                }
            }
            else {
                return 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.section == 0
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeSeriesCell") as! HomeSeriesCell
            cell.accessoryView = UIImageView(image: #imageLiteral(resourceName: "arrow"))
            cell.lblSeriesTitle.text = seriesArr[indexPath.row].name
            return cell
        }
        else
        {
            
//            if nativeAds.count != 0 {
            if nativeAds.count == 0 {
                if indexPath.row < 4 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "HomeNewsCell") as! HomeNewsCell
                     cell.lblNewsTime.text = AppHelper.timeAgoSinceDate(AppHelper.stringToGmtDate(strDate: newArr[indexPath.row].created!, format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")! , currentDate: Date(), numericDates: true)
                    cell.lblNewTitle.text = newArr[indexPath.row].title
                    if let str = newArr[indexPath.row].description {
                        cell.lblNewsDiscription.text = str.html2String
                    }
                    cell.youtubeImgVw.isHidden = true
                    if let image = newArr[indexPath.row].image{
                        if let url = URL(string: (self.newsPath+image)) {
                            cell.imgViewNews.af_setImage(withURL: url)
                        }
                    }
                    return cell
                }
                else if indexPath.row == 4 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: IPLRecordsTableViewCell.className) as! IPLRecordsTableViewCell
                    cell.playerBaseUrl = self.playerBaseUrl
                    cell.teamBaseUrl = self.teamBaseUrl
                    cell.firebaseBaseUrl = self.firebaseBaseUrl
                    cell.mostRunsModel = self.mostRunsModel
                    cell.mostWicketsModel = self.mostWicketsModel
                    cell.extraStatsModel = self.extraStatsModel
                    cell.winnerModel = self.winnerModel
                    cell.orangeCapModel = self.orangeCapModel
                    cell.purpleCapModel = self.purpleCapModel
                    cell.mostRunsCv.reloadData()
                    cell.mostWicketsCv.reloadData()
                    cell.hundredsCv.reloadData()
                    cell.winnerCv.reloadData()
                    cell.orangeCapCv.reloadData()
                    cell.purpleCapCv.reloadData()
                    return cell
                }
                else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: HomeMoreNewsCell.className) as! HomeMoreNewsCell
                        if let image = newArr[indexPath.row - 1].image{
                            if let url = URL(string: (self.newsPath+image)) {
                                cell.newsImage.af_setImage(withURL: url)
                            }
                        }
                        if let str = newArr[indexPath.row - 1].description {
                            cell.headlineLbl.text = newArr[indexPath.row - 1].title! + ". " + str.html2String
                        }
                        else {
                            cell.headlineLbl.text = newArr[indexPath.row - 1].title!
                        }
                        cell.timeLbl.text = AppHelper.timeAgoSinceDate(AppHelper.stringToGmtDate(strDate: newArr[indexPath.row - 1].created!, format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")! , currentDate: Date(), numericDates: true)
                    return cell
                }
            }
            else {
                if indexPath.row < 4 {
                    if indexPath.row == 0 {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeNewsCell") as! HomeNewsCell
                         cell.lblNewsTime.text = AppHelper.timeAgoSinceDate(AppHelper.stringToGmtDate(strDate: newArr[indexPath.row].created!, format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")! , currentDate: Date(), numericDates: true)
                        cell.lblNewTitle.text = newArr[indexPath.row].title
                        if let str = newArr[indexPath.row].description {
                            cell.lblNewsDiscription.text = str.html2String
                        }
                        cell.youtubeImgVw.isHidden = true
                        if let image = newArr[indexPath.row].image{
                            if let url = URL(string: (self.newsPath+image)) {
                                cell.imgViewNews.af_setImage(withURL: url)
                            }
                        }
                        return cell
                    }
                    else if indexPath.row == 1 {
                        if nativeAds.count == 0 {
                            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeNewsAdCell") as! HomeNewsAdCell
                            return cell
                        }
                        else {
                            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeNewsAdCell") as! HomeNewsAdCell
                            if let adView = cell.contentView.subviews[1] as? GADUnifiedNativeAdView {
                                nativeAds[0].rootViewController = self
                                adView.nativeAd = nativeAds[0]
                                (adView.headlineView as! UILabel).text = nativeAds[0].headline
                                (adView.bodyView as! UILabel).text = nativeAds[0].body
                                (adView.advertiserView as! UILabel).text = nativeAds[0].advertiser
                                (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
                                (adView.callToActionView as! UIButton).setTitle(
                                nativeAds[0].callToAction, for: UIControlState.normal)
                            }
                            return cell
                        }
                    }
                    else {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeNewsCell") as! HomeNewsCell
                         cell.lblNewsTime.text = AppHelper.timeAgoSinceDate(AppHelper.stringToGmtDate(strDate: newArr[indexPath.row - 1].created!, format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")! , currentDate: Date(), numericDates: true)
                        cell.lblNewTitle.text = newArr[indexPath.row - 1].title
                        if let str = newArr[indexPath.row - 1].description {
                            cell.lblNewsDiscription.text = str.html2String
                        }
                        cell.youtubeImgVw.isHidden = true
                        if let image = newArr[indexPath.row - 1].image{
                            if let url = URL(string: (self.newsPath+image)) {
                                cell.imgViewNews.af_setImage(withURL: url)
                            }
                        }
                        return cell
                    }
                }
                else if indexPath.row == 4 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: IPLRecordsTableViewCell.className) as! IPLRecordsTableViewCell
                    cell.playerBaseUrl = self.playerBaseUrl
                    cell.teamBaseUrl = self.teamBaseUrl
                    cell.firebaseBaseUrl = self.firebaseBaseUrl
                    cell.mostRunsModel = self.mostRunsModel
                    cell.mostWicketsModel = self.mostWicketsModel
                    cell.extraStatsModel = self.extraStatsModel
                    cell.winnerModel = self.winnerModel
                    cell.orangeCapModel = self.orangeCapModel
                    cell.purpleCapModel = self.purpleCapModel
                    cell.mostRunsCv.reloadData()
                    cell.mostWicketsCv.reloadData()
                    cell.hundredsCv.reloadData()
                    cell.winnerCv.reloadData()
                    cell.orangeCapCv.reloadData()
                    cell.purpleCapCv.reloadData()
                    return cell
                }
                else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: HomeMoreNewsCell.className) as! HomeMoreNewsCell
                        if let image = newArr[indexPath.row - 2].image{
                            if let url = URL(string: (self.newsPath+image)) {
                                cell.newsImage.af_setImage(withURL: url)
                            }
                        }
                        if let str = newArr[indexPath.row - 2].description {
                            cell.headlineLbl.text = newArr[indexPath.row - 2].title! + ". " + str.html2String
                        }
                        else {
                            cell.headlineLbl.text = newArr[indexPath.row - 2].title!
                        }
                        cell.timeLbl.text = AppHelper.timeAgoSinceDate(AppHelper.stringToGmtDate(strDate: newArr[indexPath.row - 2].created!, format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")! , currentDate: Date(), numericDates: true)
                    return cell
                }
            }
                
//            }
//            else {
//                if indexPath.row < 3 {
//                    let cell = tableView.dequeueReusableCell(withIdentifier: "HomeNewsCell") as! HomeNewsCell
//                     cell.lblNewsTime.text = AppHelper.timeAgoSinceDate(AppHelper.stringToGmtDate(strDate: newArr[indexPath.row].created!, format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")! , currentDate: Date(), numericDates: true)
//                    cell.lblNewTitle.text = newArr[indexPath.row].title
//                    if let str = newArr[indexPath.row].description {
//                        cell.lblNewsDiscription.text = str.html2String
//                    }
//                    cell.youtubeImgVw.isHidden = true
//                    if let image = newArr[indexPath.row].image{
//                        if let url = URL(string: (self.newsPath+image)) {
//                            cell.imgViewNews.af_setImage(withURL: url)
//                        }
//                    }
//                    return cell
//                }
//                else if indexPath.row == 3 {
//                    let cell = tableView.dequeueReusableCell(withIdentifier: "HomeNewsAdCell") as! HomeNewsAdCell
//                    if let adView = cell.contentView.subviews[1] as? GADUnifiedNativeAdView {
//                        nativeAds[0].rootViewController = self
//                        adView.nativeAd = nativeAds[0]
//                        (adView.headlineView as! UILabel).text = nativeAds[0].headline
//                        (adView.bodyView as! UILabel).text = nativeAds[0].body
//                        (adView.advertiserView as! UILabel).text = nativeAds[0].advertiser
//                        (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
//                        (adView.callToActionView as! UIButton).setTitle(
//                        nativeAds[0].callToAction, for: UIControlState.normal)
//                    }
//                    return cell
//                }
//                else if indexPath.row == 4 {
//                    let cell = tableView.dequeueReusableCell(withIdentifier: IPLRecordsTableViewCell.className) as! IPLRecordsTableViewCell
//                    cell.playerBaseUrl = self.playerBaseUrl
//                    cell.teamBaseUrl = self.teamBaseUrl
//                    cell.firebaseBaseUrl = self.firebaseBaseUrl
//                    cell.mostRunsModel = self.mostRunsModel
//                    cell.mostWicketsModel = self.mostWicketsModel
//                    cell.extraStatsModel = self.extraStatsModel
//                    cell.winnerModel = self.winnerModel
//                    cell.orangeCapModel = self.orangeCapModel
//                    cell.purpleCapModel = self.purpleCapModel
//                    cell.mostRunsCv.reloadData()
//                    cell.mostWicketsCv.reloadData()
//                    cell.hundredsCv.reloadData()
//                    cell.winnerCv.reloadData()
//                    cell.orangeCapCv.reloadData()
//                    cell.purpleCapCv.reloadData()
//                    return cell
//                }
//                else {
//                    let cell = tableView.dequeueReusableCell(withIdentifier: HomeMoreNewsCell.className) as! HomeMoreNewsCell
//                    if let image = newArr[indexPath.row - 2].image{
//                        if let url = URL(string: (self.newsPath+image)) {
//                            cell.newsImage.af_setImage(withURL: url)
//                        }
//                    }
//                    if let str = newArr[indexPath.row - 2].description {
//                        cell.headlineLbl.text = newArr[indexPath.row - 2].title! + " " + str.html2String
//                    }
//                    else {
//                        cell.headlineLbl.text = newArr[indexPath.row - 2].title!
//                    }
//                    cell.timeLbl.text = AppHelper.timeAgoSinceDate(AppHelper.stringToGmtDate(strDate: newArr[indexPath.row - 1].created!, format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")! , currentDate: Date(), numericDates: true)
//                    return cell
//                }
//            }
//            if newArr[0].type == 2{
//                if indexPath.row == 0{
//                    let cell = tableView.dequeueReusableCell(withIdentifier: "HomeNewsCell") as! HomeNewsCell
//                    //let formatter = DateFormatter()
//                    cell.imgViewNews.image = nil
//
//                    if(newArr[indexPath.row].type == 2)
//                    {
//                        cell.lblNewsTime.text = ""
//                        cell.lblNewTitle.text = ""
//                        cell.lblNewsDiscription.text = ""
//                    }
//                    else{
//
//                        cell.lblNewsTime.text = AppHelper.timeAgoSinceDate(AppHelper.stringToGmtDate(strDate: newArr[indexPath.row].created!, format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")! , currentDate: Date(), numericDates: true)
//                        cell.lblNewTitle.text = newArr[indexPath.row].title
//                        if let str = newArr[indexPath.row].description
//                        {
//                            cell.lblNewsDiscription.text = str.html2String
//                        }
//                    }
//                    if(newArr[indexPath.row].type == 1)
//                    {
//                        cell.youtubeImgVw.isHidden = false
//                        if let imageLink = newArr[indexPath.row].img_lnk, imageLink != ""{
//                            if let url = URL(string: imageLink)
//                            {
//                                cell.imgViewNews.af_setImage(withURL: url)
//
//                            }
//                        }
//                        else{
//                            if let image = newArr[indexPath.row].image, image != ""{
//                                if let url = URL(string: (self.newsPath+image))
//                                {
//                                    cell.imgViewNews.af_setImage(withURL: url)
//                                }
//                            }
//                        }
//                    }
//                    else{
//                        cell.youtubeImgVw.isHidden = true
//                        if let image = newArr[indexPath.row].image{
//                            if let url = URL(string: (self.newsPath+image))
//                            {
//                                cell.imgViewNews.af_setImage(withURL: url)
//                            }
//                        }
//
//                    }
//                    /*if let image = newArr[indexPath.row].image
//                     {
//                     if let url = URL(string: (self.newsPath+image).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
//                     {
//                     cell.imgViewNews.af_setImage(withURL: url)
//                     }
//                     }
//                     if(newArr[indexPath.row].is_link == true)
//                     {
//                     cell.youtubeImgVw.isHidden = false
//                     }
//                     else{
//                     cell.youtubeImgVw.isHidden = true
//                     }*/
//
//                    return cell
//                }
//                else {
//
//                    if indexPath.row%3 == 0 && nativeAds.count == 5{
//                        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeNewsAdCell") as! HomeNewsAdCell
//                        if let adView = cell.contentView.subviews[1] as? GADUnifiedNativeAdView
//                        {
//
//                            if newArr.count < 5{
//                                if indexPath.row == 3{
//                                    nativeAds[0].rootViewController = self
//                                    adView.nativeAd = nativeAds[0]
//                                    (adView.headlineView as! UILabel).text = nativeAds[0].headline
//                                    (adView.bodyView as! UILabel).text = nativeAds[0].body
//                                    (adView.advertiserView as! UILabel).text = nativeAds[0].advertiser
//                                    (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
//                                    (adView.callToActionView as! UIButton).setTitle(
//                                        nativeAds[0].callToAction, for: UIControlState.normal)
//                                }
//                            }
//                            else if newArr.count > 4 && newArr.count < 8{
//                                 if indexPath.row == 3{
//                                    nativeAds[0].rootViewController = self
//                                    adView.nativeAd = nativeAds[0]
//                                    (adView.headlineView as! UILabel).text = nativeAds[0].headline
//                                    (adView.bodyView as! UILabel).text = nativeAds[0].body
//                                    (adView.advertiserView as! UILabel).text = nativeAds[0].advertiser
//                                    (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
//                                    (adView.callToActionView as! UIButton).setTitle(
//                                        nativeAds[0].callToAction, for: UIControlState.normal)
//
//                                }
//                                else{
//                                    nativeAds[1].rootViewController = self
//                                    adView.nativeAd = nativeAds[1]
//                                    (adView.headlineView as! UILabel).text = nativeAds[1].headline
//                                    (adView.bodyView as! UILabel).text = nativeAds[1].body
//                                    (adView.advertiserView as! UILabel).text = nativeAds[1].advertiser
//                                    (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
//                                    (adView.callToActionView as! UIButton).setTitle(
//                                        nativeAds[1].callToAction, for: UIControlState.normal)
//
//                                }
//                            }
//
//                            else if newArr.count > 7  && newArr.count < 11{
//                                 if indexPath.row == 3{
//                                    nativeAds[0].rootViewController = self
//                                    adView.nativeAd = nativeAds[0]
//                                    (adView.headlineView as! UILabel).text = nativeAds[0].headline
//                                    (adView.bodyView as! UILabel).text = nativeAds[0].body
//                                    (adView.advertiserView as! UILabel).text = nativeAds[0].advertiser
//                                    (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
//                                    (adView.callToActionView as! UIButton).setTitle(
//                                        nativeAds[0].callToAction, for: UIControlState.normal)
//
//                                }
//                                else if indexPath.row == 6{
//                                    nativeAds[1].rootViewController = self
//                                    adView.nativeAd = nativeAds[1]
//                                    (adView.headlineView as! UILabel).text = nativeAds[1].headline
//                                    (adView.bodyView as! UILabel).text = nativeAds[1].body
//                                    (adView.advertiserView as! UILabel).text = nativeAds[1].advertiser
//                                    (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
//                                    (adView.callToActionView as! UIButton).setTitle(
//                                        nativeAds[1].callToAction, for: UIControlState.normal)
//
//                                }
//                                else{
//                                    nativeAds[2].rootViewController = self
//                                    adView.nativeAd = nativeAds[2]
//                                    (adView.headlineView as! UILabel).text = nativeAds[2].headline
//                                    (adView.bodyView as! UILabel).text = nativeAds[2].body
//                                    (adView.advertiserView as! UILabel).text = nativeAds[2].advertiser
//                                    (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
//                                    (adView.callToActionView as! UIButton).setTitle(
//                                        nativeAds[2].callToAction, for: UIControlState.normal)
//
//                                }
//                            }
//                            else if newArr.count > 10  && newArr.count < 14{
//                                if indexPath.row == 3{
//                                    nativeAds[0].rootViewController = self
//                                    adView.nativeAd = nativeAds[0]
//                                    (adView.headlineView as! UILabel).text = nativeAds[0].headline
//                                    (adView.bodyView as! UILabel).text = nativeAds[0].body
//                                    (adView.advertiserView as! UILabel).text = nativeAds[0].advertiser
//                                    (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
//                                    (adView.callToActionView as! UIButton).setTitle(
//                                        nativeAds[0].callToAction, for: UIControlState.normal)
//                                }
//
//                                else if indexPath.row == 6{
//                                    nativeAds[1].rootViewController = self
//                                    adView.nativeAd = nativeAds[1]
//                                    (adView.headlineView as! UILabel).text = nativeAds[1].headline
//                                    (adView.bodyView as! UILabel).text = nativeAds[1].body
//                                    (adView.advertiserView as! UILabel).text = nativeAds[1].advertiser
//                                    (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
//                                    (adView.callToActionView as! UIButton).setTitle(
//                                        nativeAds[1].callToAction, for: UIControlState.normal)
//                                }
//                                else if indexPath.row == 9{
//                                    nativeAds[2].rootViewController = self
//                                    adView.nativeAd = nativeAds[2]
//                                    (adView.headlineView as! UILabel).text = nativeAds[2].headline
//                                    (adView.bodyView as! UILabel).text = nativeAds[2].body
//                                    (adView.advertiserView as! UILabel).text = nativeAds[2].advertiser
//                                    (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
//                                    (adView.callToActionView as! UIButton).setTitle(
//                                        nativeAds[2].callToAction, for: UIControlState.normal)
//                                }
//                                else {
//                                    nativeAds[3].rootViewController = self
//                                    adView.nativeAd = nativeAds[3]
//                                    (adView.headlineView as! UILabel).text = nativeAds[3].headline
//                                    (adView.bodyView as! UILabel).text = nativeAds[3].body
//                                    (adView.advertiserView as! UILabel).text = nativeAds[3].advertiser
//                                    (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
//                                    (adView.callToActionView as! UIButton).setTitle(
//                                        nativeAds[3].callToAction, for: UIControlState.normal)
//                                }
//
//                            }
//                            else{
//                                if indexPath.row == 3{
//                                    nativeAds[0].rootViewController = self
//                                    adView.nativeAd = nativeAds[0]
//                                    (adView.headlineView as! UILabel).text = nativeAds[0].headline
//                                    (adView.bodyView as! UILabel).text = nativeAds[0].body
//                                    (adView.advertiserView as! UILabel).text = nativeAds[0].advertiser
//                                    (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
//                                    (adView.callToActionView as! UIButton).setTitle(
//                                        nativeAds[0].callToAction, for: UIControlState.normal)
//                                }
//
//                                else if indexPath.row == 6{
//                                    nativeAds[1].rootViewController = self
//                                    adView.nativeAd = nativeAds[1]
//                                    (adView.headlineView as! UILabel).text = nativeAds[1].headline
//                                    (adView.bodyView as! UILabel).text = nativeAds[1].body
//                                    (adView.advertiserView as! UILabel).text = nativeAds[1].advertiser
//                                    (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
//                                    (adView.callToActionView as! UIButton).setTitle(
//                                        nativeAds[1].callToAction, for: UIControlState.normal)
//                                }
//                                else if indexPath.row == 9{
//                                    nativeAds[2].rootViewController = self
//                                    adView.nativeAd = nativeAds[2]
//                                    (adView.headlineView as! UILabel).text = nativeAds[2].headline
//                                    (adView.bodyView as! UILabel).text = nativeAds[2].body
//                                    (adView.advertiserView as! UILabel).text = nativeAds[2].advertiser
//                                    (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
//                                    (adView.callToActionView as! UIButton).setTitle(
//                                        nativeAds[2].callToAction, for: UIControlState.normal)
//                                }
//                                else if indexPath.row == 12 {
//                                    nativeAds[3].rootViewController = self
//                                    adView.nativeAd = nativeAds[3]
//                                    (adView.headlineView as! UILabel).text = nativeAds[3].headline
//                                    (adView.bodyView as! UILabel).text = nativeAds[3].body
//                                    (adView.advertiserView as! UILabel).text = nativeAds[3].advertiser
//                                    (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
//                                    (adView.callToActionView as! UIButton).setTitle(
//                                        nativeAds[3].callToAction, for: UIControlState.normal)
//                                }
//                                else{
//                                    nativeAds[4].rootViewController = self
//                                    adView.nativeAd = nativeAds[4]
//                                    (adView.headlineView as! UILabel).text = nativeAds[4].headline
//                                    (adView.bodyView as! UILabel).text = nativeAds[4].body
//                                    (adView.advertiserView as! UILabel).text = nativeAds[4].advertiser
//                                    (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
//                                    (adView.callToActionView as! UIButton).setTitle(
//                                        nativeAds[4].callToAction, for: UIControlState.normal)
//                                }
//                            }
//
//                        }
//                        //let formatter = DateFormatter()
//                        cell.imgViewNews.image = nil
//                        if(newArr[indexPath.row].type == 2)
//                        {
//                            cell.lblNewsTime.text = ""
//                            cell.lblNewTitle.text = ""
//                            cell.lblNewsDiscription.text = ""
//                        }
//                        else{
//
//                            cell.lblNewsTime.text = AppHelper.timeAgoSinceDate(AppHelper.stringToGmtDate(strDate: newArr[indexPath.row].created!, format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")! , currentDate: Date(), numericDates: true)
//                            cell.lblNewTitle.text = newArr[indexPath.row].title
//                            if let str = newArr[indexPath.row].description
//                            {
//                                cell.lblNewsDiscription.text = str.html2String
//                            }
//                        }
//
//                        if(newArr[indexPath.row].type == 1)
//                        {
//                            cell.youtubeImgVw.isHidden = false
//                            if let imageLink = newArr[indexPath.row].img_lnk, imageLink != ""{
//                                if let url = URL(string: imageLink)
//                                {
//                                    cell.imgViewNews.af_setImage(withURL: url)
//                                }
//                            }
//                            else{
//                                if let image = newArr[indexPath.row].image, image != ""{
//                                    if let url = URL(string: (self.newsPath+image))
//                                    {
//                                        cell.imgViewNews.af_setImage(withURL: url)
//                                    }
//                                }
//                            }
//                        }
//                        else{
//
//                            cell.youtubeImgVw.isHidden = true
//                            if let image = newArr[indexPath.row].image{
//                                if let url = URL(string: (self.newsPath+image))
//                                {
//                                    cell.imgViewNews.af_setImage(withURL: url)
//                                }
//                            }
//
//
//                        }
//
//                        /*if let image = newArr[indexPath.row].image
//                         {
//                         if let url = URL(string: (self.newsPath+image).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!){
//                         cell.imgViewNews.af_setImage(withURL: url)
//                         }
//                         }
//                         if(newArr[indexPath.row].is_link == true)
//                         {
//                         cell.youtubeImgVw.isHidden = false
//                         }
//                         else{
//                         cell.youtubeImgVw.isHidden = true
//                         }*/
//                        return cell
//                    }
//                    else{
//                        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeNewsCell") as! HomeNewsCell
//                        //let formatter = DateFormatter()
//                        cell.imgViewNews.image = nil
//
//                        if(newArr[indexPath.row].type == 2)
//                        {
//                            cell.lblNewsTime.text = ""
//                            cell.lblNewTitle.text = ""
//                            cell.lblNewsDiscription.text = ""
//                        }
//                        else{
//
//                            cell.lblNewsTime.text = AppHelper.timeAgoSinceDate(AppHelper.stringToGmtDate(strDate: newArr[indexPath.row].created!, format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")! , currentDate: Date(), numericDates: true)
//                            cell.lblNewTitle.text = newArr[indexPath.row].title
//                            if let str = newArr[indexPath.row].description
//                            {
//                                cell.lblNewsDiscription.text = str.html2String
//                            }
//                        }
//                        if(newArr[indexPath.row].type == 1)
//                        {
//                            cell.youtubeImgVw.isHidden = false
//                            if let imageLink = newArr[indexPath.row].img_lnk, imageLink != ""{
//                                if let url = URL(string: imageLink)
//                                {
//                                    cell.imgViewNews.af_setImage(withURL: url)
//                                }
//                            }
//                            else{
//                                if let image = newArr[indexPath.row].image, image != ""{
//                                    if let url = URL(string: (self.newsPath+image))
//                                    {
//                                        cell.imgViewNews.af_setImage(withURL: url)
//                                    }
//                                }
//                            }
//                        }
//                        else{
//                            cell.youtubeImgVw.isHidden = true
//                            if let image = newArr[indexPath.row].image{
//                                if let url = URL(string: (self.newsPath+image))
//                                {
//                                    cell.imgViewNews.af_setImage(withURL: url)
//                                }
//                            }
//
//                        }
//                        /*if let image = newArr[indexPath.row].image
//                         {
//                         if let url = URL(string: (self.newsPath+image).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
//                         {
//                         cell.imgViewNews.af_setImage(withURL: url)
//                         }
//                         }
//                         if(newArr[indexPath.row].is_link == true)
//                         {
//                         cell.youtubeImgVw.isHidden = false
//                         }
//                         else{
//                         cell.youtubeImgVw.isHidden = true
//                         }*/
//
//                        return cell
//                    }
//                }
//            }
//            else{
//                if indexPath.row%3 == 0 && nativeAds.count == 5
//                {
//                    let cell = tableView.dequeueReusableCell(withIdentifier: "HomeNewsAdCell") as! HomeNewsAdCell
//                    if let adView = cell.contentView.subviews[1] as? GADUnifiedNativeAdView
//                    {
//
//                        if newArr.count < 4{
//                            if indexPath.row == 0{
//                                nativeAds[0].rootViewController = self
//                                adView.nativeAd = nativeAds[0]
//                                (adView.headlineView as! UILabel).text = nativeAds[0].headline
//                                (adView.bodyView as! UILabel).text = nativeAds[0].body
//                                (adView.advertiserView as! UILabel).text = nativeAds[0].advertiser
//                                (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
//                                (adView.callToActionView as! UIButton).setTitle(
//                                    nativeAds[0].callToAction, for: UIControlState.normal)
//                            }
//                            else if indexPath.row == 3{
//                                nativeAds[1].rootViewController = self
//                                adView.nativeAd = nativeAds[1]
//                                (adView.headlineView as! UILabel).text = nativeAds[1].headline
//                                (adView.bodyView as! UILabel).text = nativeAds[1].body
//                                (adView.advertiserView as! UILabel).text = nativeAds[1].advertiser
//                                (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
//                                (adView.callToActionView as! UIButton).setTitle(
//                                    nativeAds[1].callToAction, for: UIControlState.normal)
//                            }
//                        }
//                        else if newArr.count > 3 && newArr.count < 7{
//                            if indexPath.row == 0{
//                                nativeAds[0].rootViewController = self
//                                adView.nativeAd = nativeAds[0]
//                                (adView.headlineView as! UILabel).text = nativeAds[0].headline
//                                (adView.bodyView as! UILabel).text = nativeAds[0].body
//                                (adView.advertiserView as! UILabel).text = nativeAds[0].advertiser
//                                (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
//                                (adView.callToActionView as! UIButton).setTitle(
//                                    nativeAds[0].callToAction, for: UIControlState.normal)
//                            }
//
//                            else if indexPath.row == 3{
//                                nativeAds[1].rootViewController = self
//                                adView.nativeAd = nativeAds[1]
//                                (adView.headlineView as! UILabel).text = nativeAds[1].headline
//                                (adView.bodyView as! UILabel).text = nativeAds[1].body
//                                (adView.advertiserView as! UILabel).text = nativeAds[1].advertiser
//                                (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
//                                (adView.callToActionView as! UIButton).setTitle(
//                                    nativeAds[1].callToAction, for: UIControlState.normal)
//                            }
//                            else{
//                                nativeAds[2].rootViewController = self
//                                adView.nativeAd = nativeAds[2]
//                                (adView.headlineView as! UILabel).text = nativeAds[2].headline
//                                (adView.bodyView as! UILabel).text = nativeAds[2].body
//                                (adView.advertiserView as! UILabel).text = nativeAds[2].advertiser
//                                (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
//                                (adView.callToActionView as! UIButton).setTitle(
//                                    nativeAds[2].callToAction, for: UIControlState.normal)
//                            }
//                        }
//
//                        else if newArr.count > 6  && newArr.count < 10{
//                            if indexPath.row == 0{
//                                nativeAds[0].rootViewController = self
//                                adView.nativeAd = nativeAds[0]
//                                (adView.headlineView as! UILabel).text = nativeAds[0].headline
//                                (adView.bodyView as! UILabel).text = nativeAds[0].body
//                                (adView.advertiserView as! UILabel).text = nativeAds[0].advertiser
//                                (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
//                                (adView.callToActionView as! UIButton).setTitle(
//                                    nativeAds[0].callToAction, for: UIControlState.normal)
//                            }
//
//                            else if indexPath.row == 3{
//                                nativeAds[1].rootViewController = self
//                                adView.nativeAd = nativeAds[1]
//                                (adView.headlineView as! UILabel).text = nativeAds[1].headline
//                                (adView.bodyView as! UILabel).text = nativeAds[1].body
//                                (adView.advertiserView as! UILabel).text = nativeAds[1].advertiser
//                                (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
//                                (adView.callToActionView as! UIButton).setTitle(
//                                    nativeAds[1].callToAction, for: UIControlState.normal)
//                            }
//                            else if indexPath.row == 6{
//                                nativeAds[2].rootViewController = self
//                                adView.nativeAd = nativeAds[2]
//                                (adView.headlineView as! UILabel).text = nativeAds[2].headline
//                                (adView.bodyView as! UILabel).text = nativeAds[2].body
//                                (adView.advertiserView as! UILabel).text = nativeAds[2].advertiser
//                                (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
//                                (adView.callToActionView as! UIButton).setTitle(
//                                    nativeAds[2].callToAction, for: UIControlState.normal)
//                            }
//                            else{
//                                nativeAds[3].rootViewController = self
//                                adView.nativeAd = nativeAds[3]
//                                (adView.headlineView as! UILabel).text = nativeAds[3].headline
//                                (adView.bodyView as! UILabel).text = nativeAds[3].body
//                                (adView.advertiserView as! UILabel).text = nativeAds[3].advertiser
//                                (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
//                                (adView.callToActionView as! UIButton).setTitle(
//                                    nativeAds[3].callToAction, for: UIControlState.normal)
//                            }
//                        }
//                        else{
//                            if indexPath.row == 0{
//                                nativeAds[0].rootViewController = self
//                                adView.nativeAd = nativeAds[0]
//                                (adView.headlineView as! UILabel).text = nativeAds[0].headline
//                                (adView.bodyView as! UILabel).text = nativeAds[0].body
//                                (adView.advertiserView as! UILabel).text = nativeAds[0].advertiser
//                                (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
//                                (adView.callToActionView as! UIButton).setTitle(
//                                    nativeAds[0].callToAction, for: UIControlState.normal)
//                            }
//
//                            else if indexPath.row == 3{
//                                nativeAds[1].rootViewController = self
//                                adView.nativeAd = nativeAds[1]
//                                (adView.headlineView as! UILabel).text = nativeAds[1].headline
//                                (adView.bodyView as! UILabel).text = nativeAds[1].body
//                                (adView.advertiserView as! UILabel).text = nativeAds[1].advertiser
//                                (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
//                                (adView.callToActionView as! UIButton).setTitle(
//                                    nativeAds[1].callToAction, for: UIControlState.normal)
//                            }
//                            else if indexPath.row == 6{
//                                nativeAds[2].rootViewController = self
//                                adView.nativeAd = nativeAds[2]
//                                (adView.headlineView as! UILabel).text = nativeAds[2].headline
//                                (adView.bodyView as! UILabel).text = nativeAds[2].body
//                                (adView.advertiserView as! UILabel).text = nativeAds[2].advertiser
//                                (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
//                                (adView.callToActionView as! UIButton).setTitle(
//                                    nativeAds[2].callToAction, for: UIControlState.normal)
//                            }
//                            else if indexPath.row == 9{
//                                nativeAds[3].rootViewController = self
//                                adView.nativeAd = nativeAds[3]
//                                (adView.headlineView as! UILabel).text = nativeAds[3].headline
//                                (adView.bodyView as! UILabel).text = nativeAds[3].body
//                                (adView.advertiserView as! UILabel).text = nativeAds[3].advertiser
//                                (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
//                                (adView.callToActionView as! UIButton).setTitle(
//                                    nativeAds[3].callToAction, for: UIControlState.normal)
//                            }
//                            else{
//                                nativeAds[4].rootViewController = self
//                                adView.nativeAd = nativeAds[4]
//                                (adView.headlineView as! UILabel).text = nativeAds[4].headline
//                                (adView.bodyView as! UILabel).text = nativeAds[4].body
//                                (adView.advertiserView as! UILabel).text = nativeAds[4].advertiser
//                                (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
//                                (adView.callToActionView as! UIButton).setTitle(
//                                    nativeAds[4].callToAction, for: UIControlState.normal)
//                            }
//                        }
//
//                    }
//                    //let formatter = DateFormatter()
//                    cell.imgViewNews.image = nil
//                    if(newArr[indexPath.row].type == 2)
//                    {
//                        cell.lblNewsTime.text = ""
//                        cell.lblNewTitle.text = ""
//                        cell.lblNewsDiscription.text = ""
//
//                    }
//                    else{
//
//                        cell.lblNewsTime.text = AppHelper.timeAgoSinceDate(AppHelper.stringToGmtDate(strDate: newArr[indexPath.row].created!, format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")! , currentDate: Date(), numericDates: true)
//                        cell.lblNewTitle.text = newArr[indexPath.row].title
//                        if let str = newArr[indexPath.row].description
//                        {
//                            cell.lblNewsDiscription.text = str.html2String
//                        }
//                    }
//
//                    if(newArr[indexPath.row].type == 1)
//                    {
//                        cell.youtubeImgVw.isHidden = false
//                        if let imageLink = newArr[indexPath.row].img_lnk, imageLink != ""{
//                            if let url = URL(string: imageLink)
//                            {
//                                cell.imgViewNews.af_setImage(withURL: url)
//                            }
//                        }
//                        else{
//                            if let image = newArr[indexPath.row].image, image != ""{
//                                if let url = URL(string: (self.newsPath+image))
//                                {
//                                    cell.imgViewNews.af_setImage(withURL: url)
//                                }
//                            }
//                        }
//                    }
//                    else{
//
//                        cell.youtubeImgVw.isHidden = true
//                        if let image = newArr[indexPath.row].image{
//                            if let url = URL(string: (self.newsPath+image))
//                            {
//                                cell.imgViewNews.af_setImage(withURL: url)
//                            }
//                        }
//
//
//                    }
//
//                    /*if let image = newArr[indexPath.row].image
//                     {
//                     if let url = URL(string: (self.newsPath+image).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!){
//                     cell.imgViewNews.af_setImage(withURL: url)
//                     }
//                     }
//                     if(newArr[indexPath.row].is_link == true)
//                     {
//                     cell.youtubeImgVw.isHidden = false
//                     }
//                     else{
//                     cell.youtubeImgVw.isHidden = true
//                     }*/
//                    return cell
//                }
//                else{
//                    let cell = tableView.dequeueReusableCell(withIdentifier: "HomeNewsCell") as! HomeNewsCell
//                    //let formatter = DateFormatter()
//                    cell.imgViewNews.image = nil
//
//                    if(newArr[indexPath.row].type == 2)
//                    {
//                        cell.lblNewsTime.text = ""
//                        cell.lblNewTitle.text = ""
//                        cell.lblNewsDiscription.text = ""
//                    }
//                    else{
//
//                        cell.lblNewsTime.text = AppHelper.timeAgoSinceDate(AppHelper.stringToGmtDate(strDate: newArr[indexPath.row].created!, format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")! , currentDate: Date(), numericDates: true)
//                        cell.lblNewTitle.text = newArr[indexPath.row].title
//                        if let str = newArr[indexPath.row].description
//                        {
//                            cell.lblNewsDiscription.text = str.html2String
//                        }
//                    }
//                    if(newArr[indexPath.row].type == 1)
//                    {
//                        cell.youtubeImgVw.isHidden = false
//                        if let imageLink = newArr[indexPath.row].img_lnk, imageLink != ""{
//                            if let url = URL(string: imageLink)
//                            {
//                                cell.imgViewNews.af_setImage(withURL: url)
//                            }
//                        }
//                        else{
//                            if let image = newArr[indexPath.row].image, image != ""{
//                                if let url = URL(string: (self.newsPath+image))
//                                {
//                                    cell.imgViewNews.af_setImage(withURL: url)
//                                }
//                            }
//                        }
//                    }
//                    else{
//                        cell.youtubeImgVw.isHidden = true
//                        if let image = newArr[indexPath.row].image{
//                            if let url = URL(string: (self.newsPath+image))
//                            {
//                                cell.imgViewNews.af_setImage(withURL: url)
//                            }
//                        }
//
//                    }
//                    /*if let image = newArr[indexPath.row].image
//                     {
//                     if let url = URL(string: (self.newsPath+image).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
//                     {
//                     cell.imgViewNews.af_setImage(withURL: url)
//                     }
//                     }
//                     if(newArr[indexPath.row].is_link == true)
//                     {
//                     cell.youtubeImgVw.isHidden = false
//                     }
//                     else{
//                     cell.youtubeImgVw.isHidden = true
//                     }*/
//
//                    return cell
//                }
//            }
            
            
            
            /*let cell = tableView.dequeueReusableCell(withIdentifier: "HomeNewsCell") as! HomeNewsCell
            //let formatter = DateFormatter()
            cell.imgViewNews.image = nil
            
            if(newArr[indexPath.row].type == 2)
            {
                cell.lblNewsTime.text = ""
                cell.lblNewTitle.text = ""
                cell.lblNewsDiscription.text = ""
            }
            else{
                
                cell.lblNewsTime.text = AppHelper.timeAgoSinceDate(AppHelper.stringToGmtDate(strDate: newArr[indexPath.row].created!, format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")! , currentDate: Date(), numericDates: true)
                cell.lblNewTitle.text = newArr[indexPath.row].title
                if let str = newArr[indexPath.row].description
                {
                    cell.lblNewsDiscription.text = str.html2String
                }
            }
            if(newArr[indexPath.row].type == 1)
            {
                cell.youtubeImgVw.isHidden = false
                if let imageLink = newArr[indexPath.row].img_lnk, imageLink != ""{
                    if let url = URL(string: imageLink.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
                    {
                        cell.imgViewNews.af_setImage(withURL: url)
                    }
                }
                else{
                    if let image = newArr[indexPath.row].image, image != ""{
                        if let url = URL(string: (self.newsPath+image).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
                        {
                            cell.imgViewNews.af_setImage(withURL: url)
                        }
                    }
                }
            }
            else{
                cell.youtubeImgVw.isHidden = true
                if let image = newArr[indexPath.row].image{
                    if let url = URL(string: (self.newsPath+image).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
                    {
                        cell.imgViewNews.af_setImage(withURL: url)
                    }
                }
                
            }
            /*if let image = newArr[indexPath.row].image
            {
                if let url = URL(string: (self.newsPath+image).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
                {
                    cell.imgViewNews.af_setImage(withURL: url)
                }
            }
            if(newArr[indexPath.row].is_link == true)
            {
                cell.youtubeImgVw.isHidden = false
            }
            else{
                cell.youtubeImgVw.isHidden = true
            }*/
            
            return cell*/
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 2
    }
}

extension HomeVC:UIScrollViewDelegate
{
    //MARK:-Scroll view delegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        if scrollView == cvHome
        {
            let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
            pageControl.currentPage = Int(pageNumber)
            currentIndex = Int(pageNumber)
        }
    }
}


extension HomeVC:GADUnifiedNativeAdLoaderDelegate
{
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADUnifiedNativeAd) {
        //nativeAdView.append(nativeAd)
        cvHome.reloadData()
        nativeAds.append(nativeAd)
        tvHome.reloadData()
    }
}
extension HomeVC:GADAdLoaderDelegate{
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
        print("\(adLoader) failed with error: \(error.localizedDescription)")
    }
}
extension HomeVC{
    func getThumbnailImage(forUrl url: URL) -> UIImage? {
        let asset: AVAsset = AVAsset(url: url)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTimeMake(1, 60) , actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch let error {
            print(error)
        }
        
        return nil
    }
    
    func thumbnailURLString(videoID:String, quailty: ThumbnailQuailty = .Default) -> String {
        //return "http://img.youtube.com/vi/\(videoID)/\(quailty.rawValue)"
        return "http://i1.ytimg.com/vi/\(videoID)/\(quailty.rawValue)"
    }
    
}

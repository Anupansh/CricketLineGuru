//
//  UpcomingMatchesVC.swift
//  cricrate
//
//  Created by Anuj Naruka on 9/20/17.
//  Copyright © 2017 Cricket Line Guru. All rights reserved.
//

import UIKit
import GoogleMobileAds
import CoreData
import ObjectMapper
import Firebase


class UpcomingMatchesVC: BaseViewController,UINavigationControllerDelegate,UIGestureRecognizerDelegate {
    
    //MARK:-IBOutlets
    @IBOutlet weak var reloadBtn: UIButton!
    @IBOutlet weak var t20BgView: UIView!
    @IBOutlet weak var testBgView: UIView!
    @IBOutlet weak var odiBgView: UIView!
    @IBOutlet weak var gadBannerView: GADBannerView!
    @IBOutlet weak var tvUpcomingMatches: UITableView!
    @IBOutlet weak var bannerHeight: NSLayoutConstraint!
    @IBOutlet weak var LblNoMatch: UILabel!
    @IBOutlet weak var selectedTabConstraint: NSLayoutConstraint!
    
    //MARK:-Variables And Constants
    var CurrentMatch = 0
    var interstitialAds: GADInterstitial!
    var interval = 5
    var path = ""
    var isLoading = false
    var bannerAdView: FBAdView!
    
    var adLoader = GADAdLoader()
    let numAdsToLoad = 5
    var nativeAds = [GADUnifiedNativeAd]()
    
    private var currentUpcomingMatchData = [CLGRecentMatchModelV3]()
    private var odiUpcomingMatchData = [CLGRecentMatchModelV3]()
    private var testUpcomingMatchData = [CLGRecentMatchModelV3]()
    private var t20UpcomingMatchData = [CLGRecentMatchModelV3]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LblNoMatch.isHidden = true
        setUp()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARk:-Funcions
    
    private func setUp(){
        self.setupNavigationBarTitle("UPCOMING MATCHES", navBG: "", leftBarButtonsType: [], rightBarButtonsType: [])
        tvUpcomingMatches.estimatedRowHeight = 140
        
        hitApi()
        self.loadFbBannerAd()
    }
    @objc func showNativeAd(){
        nativeAds = AppHelper.appDelegate().returnNativeAdArray()
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
    
    private func getUpcomingMatchData(type:String,page:Int){
        CLGUserService().HomeService(url:NewBaseUrlV4+CLGRecentClass.upcomingMatch , method: .get, showLoader: 1, header: header, parameters:["format":type,"pageNo":page]).then(execute: { (data) -> Void in
            if data.statusCode == 1,
                let match = (data.responseData?.match){
                let currentDate = Date().toMillis()
                for item in match
                {
                    item.format = type
                }
                if self.odiUpcomingMatchData.count != 0 && type != "one-day"
                {
                    if self.odiUpcomingMatchData.count < 20
                    {
                        data.responseData?.match?.append(contentsOf: self.odiUpcomingMatchData)
                    }
                    else
                    {
                        data.responseData?.match?.append(contentsOf: (Array(self.odiUpcomingMatchData[0..<20])))
                    }
                }
                if self.t20UpcomingMatchData.count != 0 && type != "t20"
                {
                    if self.t20UpcomingMatchData.count < 20
                    {
                        data.responseData?.match?.append(contentsOf: self.t20UpcomingMatchData)
                    }
                    else
                    {
                        data.responseData?.match?.append(contentsOf: (Array(self.t20UpcomingMatchData[0..<20])))
                    }
                }
                if self.testUpcomingMatchData.count != 0 && type != "test"
                {
                    if self.testUpcomingMatchData.count < 20
                    {
                        data.responseData?.match?.append(contentsOf: self.testUpcomingMatchData)
                    }
                    else
                    {
                        data.responseData?.match?.append(contentsOf: (Array(self.testUpcomingMatchData[0..<20])))
                    }
                }
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
                        apiDataObj.upcomingApiData = jsonData
                    }
                    else
                    {
                        for item in items
                        {
                            item.upcomingApiData = jsonData
                        }
                    }
                    try context.save()
                }
                catch
                {
                    
                }
                self.reloadBtn.isHidden = true
                UserDefault.saveToUserDefault(value: currentDate as AnyObject, key: "UpcomingDate")
                if let responseData = data.responseData, let match = responseData.match{
                    self.differentiateData(allData: match,type: type)
                    self.path = responseData.teamsPath ?? ""
                }
            }
            //self.interstitialAds = self.createAndLoadInterstitial()
            //self.ShowAd()
            self.showNativeAd()
            self.tvUpcomingMatches.reloadData()
        }).catch { (error) in
            print(error)
            if self.t20UpcomingMatchData.count == 0 && self.testUpcomingMatchData.count == 0  && self.odiUpcomingMatchData.count == 0
            {
                self.reloadBtn.isHidden = false
            }
        }
    }
    
    private func differentiateData(allData:[CLGRecentMatchModelV3],type: String){
        self.t20UpcomingMatchData =  allData.filter({ (data) -> Bool in
            if data.format == "t20"{
                return true
            }
            return false
        })
        self.odiUpcomingMatchData =  allData.filter({ (data) -> Bool in
            if data.format == "one-day"{
                return true
            }
            return false
        })
        self.testUpcomingMatchData =  allData.filter({ (data) -> Bool in
            if data.format == "test"{
                return true
            }
            return false
        })
        if type == "t20"
        {
            self.currentUpcomingMatchData = self.t20UpcomingMatchData
        }
        else if type == "test"
        {
            self.currentUpcomingMatchData = self.testUpcomingMatchData
        }
        else
        {
            self.currentUpcomingMatchData = self.odiUpcomingMatchData
        }
        setLabelHidden()
        self.tvUpcomingMatches.reloadData()
    }
    
    private func setLabelHidden(){
        if currentUpcomingMatchData.count > 0{
            self.LblNoMatch.isHidden = true
        }else{
            self.LblNoMatch.isHidden = false
        }
    }
    
    private func hitApi()
    {
        var recentDate = Double()
        if let newRecentDate  = UserDefault.userDefaultForAny(key: "UpcomingDate") as? Double
        {
            recentDate = newRecentDate
        }
        
        if let match = AppHelper.appDelegate().apiInfo.match{
            if let matchDate = AppHelper.stringToGmtDate(strDate: match, format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
            {
                if Double(recentDate) > matchDate.timeIntervalSince1970*1000
                {
                    var UpcomingData = [String:AnyObject]()
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
                            string = (item.value(forKey: "upcomingApiData") as? String)!
                        }
                        
                    } catch
                    {
                        print(error.localizedDescription)
                    }
                    if let data = string.data(using: .utf8)
                    {
                        do
                        {
                            UpcomingData = try (JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject])!
                        }
                        catch
                        {
                            print(error.localizedDescription)
                        }
                    }
                    
                    let recentMatchModel = Mapper<HomeApiResponseV3>().map(JSON: UpcomingData)
                    
                    if let responseData = recentMatchModel?.responseData, let match = responseData.match{
                        self.differentiateData(allData: match, type: "t20")
                        path = responseData.teamsPath ?? ""

                    }
                    //self.interstitialAds = createAndLoadInterstitial()
                    //self.ShowAd()
                    self.showNativeAd()
                    return
                }
            }
        }
        self.getUpcomingMatchData(type: "t20", page: 1)
    }

  //MARK:-IBActions
    @IBAction func reloadBtnAction(_ sender: Any) {
        hitApi()
    }
    @IBAction func odiBtn(_ sender: Any)
    {
        UIView.animate(withDuration: 0.5, animations: {
            self.selectedTabConstraint.constant = self.odiBgView.frame.origin.x
            self.view.layoutIfNeeded()
        })
        if odiUpcomingMatchData.count == 0
        {
            self.getUpcomingMatchData(type: "one-day", page: 1)
        }
        else
        {
            currentUpcomingMatchData = odiUpcomingMatchData
        }
        setLabelHidden()
        tvUpcomingMatches.reloadData()
    }
    @IBAction func TestBtn(_ sender: Any)
    {
        UIView.animate(withDuration: 0.5, animations: {
            self.selectedTabConstraint.constant = self.testBgView.frame.origin.x
            self.view.layoutIfNeeded()
        })
        if testUpcomingMatchData.count == 0
        {
            self.getUpcomingMatchData(type: "test", page: 1)
        }
        else
        {
            currentUpcomingMatchData = testUpcomingMatchData
        }
        setLabelHidden()
        tvUpcomingMatches.reloadData()
    }
    @IBAction func t20Btn(_ sender: Any)
    {
        UIView.animate(withDuration: 0.5, animations: {
            self.selectedTabConstraint.constant = self.t20BgView.frame.origin.x
            self.view.layoutIfNeeded()
        })
//        if t20UpcomingMatchData.count == 0
//        {
//            self.getUpcomingMatchData(type: "t20", page: 1)
//        }
//        else
//        {
            currentUpcomingMatchData = t20UpcomingMatchData
       // }
        setLabelHidden()
        tvUpcomingMatches.reloadData()
    }
}
extension UpcomingMatchesVC: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath)
    {
        if indexPath.row % interval != 0
        {
            if let cell = tableView.cellForRow(at: indexPath) as? UpcomingMatchCell
            {
                cell.MainView.backgroundColor = UIColor.gray
            }
        }
        else
        {
            if let cell = tableView.cellForRow(at: indexPath) as? UcomingMatchAdCell
            {
                cell.MainView.backgroundColor = UIColor.gray
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        
        if indexPath.row % interval != 0
        {
            if let cell = tableView.cellForRow(at: indexPath) as? UpcomingMatchCell{
                UIView.animate(withDuration: 0.3, animations: {
                    cell.MainView.backgroundColor = UIColor.white
                }) { (true) in
                }
            }
        }
        else
        {
            if let cell = tableView.cellForRow(at: indexPath) as? UcomingMatchAdCell{
                UIView.animate(withDuration: 0.3, animations: {
                    cell.MainView.backgroundColor = UIColor.white
                }) { (true) in
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
}
extension UpcomingMatchesVC: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return currentUpcomingMatchData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row % interval != 0
        {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpcomingMatchCell", for: indexPath) as! UpcomingMatchCell
        cell.selectionStyle = .none
            cell.configureCell(upcomingData: self.currentUpcomingMatchData[indexPath.row], path: self.path)
        return cell
        }
        else
            {
                if nativeAds.count == 5{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "UcomingMatchAdCell", for: indexPath) as! UcomingMatchAdCell
                    cell.selectionStyle = .none
                    if let adView = cell.contentView.subviews[2] as? GADUnifiedNativeAdView
                    {
                        if currentUpcomingMatchData.count < 6{
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
                        else if currentUpcomingMatchData.count > 5 && currentUpcomingMatchData.count < 11{
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
                        else if currentUpcomingMatchData.count > 10 && currentUpcomingMatchData.count < 16{
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
                    cell.configureCell(upcomingData: self.currentUpcomingMatchData[indexPath.row],vc: self, path: self.path)
                    return cell
                }
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "UpcomingMatchCell", for: indexPath) as! UpcomingMatchCell
                cell.selectionStyle = .none
                cell.configureCell(upcomingData: self.currentUpcomingMatchData[indexPath.row], path: self.path)
                return cell
        }
    }
}
extension UpcomingMatchesVC:UIScrollViewDelegate
{
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ) && !isLoading && (self.currentUpcomingMatchData.count) > 0)
        {
            if self.selectedTabConstraint.constant == self.odiBgView.frame.origin.x,
                (self.odiUpcomingMatchData.count%20) == 0
            {
                
                self.getUpcomingMatchDataPaging(type: "one-day", page: ((self.odiUpcomingMatchData.count/20)+1))
                isLoading = true
            }
            else if self.selectedTabConstraint.constant == self.testBgView.frame.origin.x,
                (self.testUpcomingMatchData.count%20) == 0
            {
                self.getUpcomingMatchDataPaging(type: "test", page: ((self.testUpcomingMatchData.count/20)+1))
                isLoading = true
            }
            else if self.selectedTabConstraint.constant == self.t20BgView.frame.origin.x
            {
                if (self.t20UpcomingMatchData.count%20) == 0
                {
                    self.getUpcomingMatchDataPaging(type: "t20", page: ((self.t20UpcomingMatchData.count/20)+1))
                    isLoading = true
                }
            }
        }
    }
    
    private func getUpcomingMatchDataPaging(type:String,page:Int){
        CLGUserService().HomeService(url:NewBaseUrlV4+CLGRecentClass.upcomingMatch , method: .get, showLoader: 2, header: header, parameters: ["format":type,"pageNo":page]).then(execute: { (data) -> Void in
            self.isLoading = false
            if data.statusCode == 1,
                let match = (data.responseData?.match){
                for item in match
                {
                    item.format = type
                }
                if type == "one-day"
                {
                    self.odiUpcomingMatchData.append(contentsOf: match)
                    self.currentUpcomingMatchData = self.odiUpcomingMatchData
                }
                else if type == "t20"
                {
                    self.t20UpcomingMatchData.append(contentsOf: match)
                    self.currentUpcomingMatchData = self.t20UpcomingMatchData
                }
                else
                {
                    self.testUpcomingMatchData.append(contentsOf: match)
                    self.currentUpcomingMatchData = self.testUpcomingMatchData
                }
                self.reloadBtn.isHidden = true
            }
            self.tvUpcomingMatches.reloadData()
        }).catch { (error) in
            print(error)
            self.isLoading = false
            if self.t20UpcomingMatchData.count == 0 && self.testUpcomingMatchData.count == 0  && self.odiUpcomingMatchData.count == 0
            {
                self.reloadBtn.isHidden = false
            }
        }
    }
}
/*extension UpcomingMatchesVC:GADBannerViewDelegate
{
    // AdMob banner available
    func adViewDidReceiveAd(_ view: GADBannerView) {
        bannerHeight.constant = 50.0
    }
    
    // NO AdMob banner available
    func adView(_ view: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        bannerHeight.constant = 0.0
    }
}*/

/*extension UpcomingMatchesVC:GADUnifiedNativeAdLoaderDelegate
{
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADUnifiedNativeAd) {
        nativeAds.append(nativeAd)
        tvUpcomingMatches.reloadData()
    }
}
extension UpcomingMatchesVC:GADAdLoaderDelegate{
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
        print("\(adLoader) failed with error: \(error.localizedDescription)")
    }
}*/


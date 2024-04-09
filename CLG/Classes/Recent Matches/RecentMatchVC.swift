//
//  RecentMatchVC.swift
//  cricrate
//
//  Created by Anuj Naruka on 9/21/17.
//  Copyright © 2017 Cricket Line Guru. All rights reserved.
//

import UIKit
import GoogleMobileAds
import CoreData
import ObjectMapper
import Firebase

class RecentMatchVC: BaseViewController,UINavigationControllerDelegate,UIGestureRecognizerDelegate {
    
    //MARK:-IBOutlets
    @IBOutlet weak var reloadBtn: UIButton!
    @IBOutlet weak var t20BgView: UIView!
    @IBOutlet weak var testBgView: UIView!
    @IBOutlet weak var odiBgView: UIView!
    @IBOutlet weak var gadBannerView: GADBannerView!
    @IBOutlet weak var tvRecentMatches: UITableView!
    @IBOutlet weak var bannerHeight: NSLayoutConstraint!
    @IBOutlet weak var LblNoMatch: UILabel!
    @IBOutlet weak var selectedTabConstraint: NSLayoutConstraint!
    var CurrentMatch = 0

    //MARK:-Variables And Constants
    var isFullScreen : Bool? = false
    var interstitialAds: GADInterstitial!
    var interval = 5
    var path = ""
    var isLoading = false
    var adLoader = GADAdLoader()
    let numAdsToLoad = 5
    var nativeAds = [GADUnifiedNativeAd]()
    var bannerAdView: FBAdView!
        
    private var currentRecentMatchData = [CLGRecentMatchModelV3]()
    private var odiRecentMatchData = [CLGRecentMatchModelV3]()
    private var testRecentMatchData = [CLGRecentMatchModelV3]()
    private var t20RecentMatchData = [CLGRecentMatchModelV3]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LblNoMatch.isHidden = true
        setUp()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    //MARk:-Funcions
    private func setUp(){
        self.setupNavigationBarTitle("RECENT MATCHES", navBG: "", leftBarButtonsType: [], rightBarButtonsType: [])
        tvRecentMatches.estimatedRowHeight = 200
        hitApi()
        self.loadFbBannerAd()
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
    
    //MARK:-Gesture Delegates
    @objc func showNativeAd(){
        nativeAds = AppHelper.appDelegate().returnNativeAdArray()
    }
    
    private func getRecentMatchData(type:String,page:Int){
        CLGUserService().HomeService(url:NewBaseUrlV4+CLGRecentClass.recentMatch , method: .get, showLoader: 1, header: header, parameters: ["format":type,"pageNo":page]).then(execute: { (data) -> Void in
            if data.statusCode == 1,
                let match = (data.responseData?.match){
                let currentDate = Date().toMillis()
                for item in match
                {
                    item.format = type
                }
                if self.odiRecentMatchData.count != 0 && type != "one-day"
                {
                    if self.odiRecentMatchData.count < 20
                    {
                        data.responseData?.match?.append(contentsOf: self.odiRecentMatchData)
                    }
                    else
                    {
                        data.responseData?.match?.append(contentsOf: (Array(self.odiRecentMatchData[0..<20])))
                    }
                }
                if self.t20RecentMatchData.count != 0 && type != "t20"
                {
                    if self.t20RecentMatchData.count < 20
                    {
                        data.responseData?.match?.append(contentsOf: self.t20RecentMatchData)
                    }
                    else
                    {
                        data.responseData?.match?.append(contentsOf: (Array(self.t20RecentMatchData[0..<20])))
                    }
                }
                if self.testRecentMatchData.count != 0 && type != "test"
                {
                    if self.testRecentMatchData.count < 20
                    {
                        data.responseData?.match?.append(contentsOf: self.testRecentMatchData)
                    }
                    else
                    {
                        data.responseData?.match?.append(contentsOf: (Array(self.testRecentMatchData[0..<20])))
                    }
                }
                let recentData =  try! JSONSerialization.data(withJSONObject: data.toJSON() as Any, options: [])
                let jsonData = String(data:recentData, encoding:.utf8)!
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
                        apiDataObj.recentApiData = jsonData
                    }
                    else
                    {
                        for item in items
                        {
                            item.recentApiData = jsonData
                        }
                    }
                    try context.save()
                }
                catch
                {
                    
                }
                self.reloadBtn.isHidden = true
                UserDefault.saveToUserDefault(value: currentDate as AnyObject, key: "RecentDate")
                if let responseData = data.responseData, let match = responseData.match{
                    self.differentiateData(allData: match,type: type)
                    self.path = responseData.teamsPath ?? ""
                }
            }
            //self.interstitialAds = self.createAndLoadInterstitial()
            //self.ShowAd()
            self.showNativeAd()
            self.tvRecentMatches.reloadData()
        }).catch { (error) in
            print(error)
            if self.t20RecentMatchData.count == 0 && self.testRecentMatchData.count == 0  && self.odiRecentMatchData.count == 0
            {
                self.reloadBtn.isHidden = false
            }
        }
    }
    
    private func differentiateData(allData:[CLGRecentMatchModelV3],type: String){
        self.t20RecentMatchData =  allData.filter({ (data) -> Bool in
            if data.format == "t20"{
                return true
            }
            return false
        })
        self.odiRecentMatchData =  allData.filter({ (data) -> Bool in
            if data.format == "one-day"{
                return true
            }
            return false
        })
        self.testRecentMatchData =  allData.filter({ (data) -> Bool in
            if data.format == "test"{
                return true
            }
            return false
        })
        if type == "t20"
        {
            self.currentRecentMatchData = self.t20RecentMatchData
        }
        else if type == "test"
        {
            self.currentRecentMatchData = self.testRecentMatchData
        }
        else
        {
            self.currentRecentMatchData = self.odiRecentMatchData
        }
        setLabelHidden()
        self.tvRecentMatches.reloadData()
    }
    
    private func setLabelHidden(){
        if currentRecentMatchData.count > 0{
            self.LblNoMatch.isHidden = true
        }else{
            self.LblNoMatch.isHidden = false
        }
    }
   
    private func hitApi()
    {
        var recentDate = Double()
        if let newRecentDate  = UserDefault.userDefaultForAny(key: "RecentDate") as? Double
        {
            recentDate = newRecentDate
        }
        
        if let match = AppHelper.appDelegate().apiInfo.match{
            if let matchDate = AppHelper.stringToGmtDate(strDate: match, format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
            {
                if Double(recentDate) > matchDate.timeIntervalSince1970*1000
                {
                    var RecentData = [String:AnyObject]()
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
                            string = (item.value(forKey: "recentApiData") as? String)!
                        }
                        
                    } catch
                    {
                        print(error.localizedDescription)
                    }
                    if let data = string.data(using: .utf8)
                    {
                        do
                        {
                            RecentData = try (JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject])!
                        }
                        catch
                        {
                            print(error.localizedDescription)
                        }
                    }
                    
                    let recentMatchModel = Mapper<HomeApiResponseV3>().map(JSON: RecentData)
                    
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
        self.getRecentMatchData(type: "t20", page: 1)
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
        if odiRecentMatchData.count == 0
        {
            self.getRecentMatchData(type: "one-day", page: 1)
        }
        else
        {
            currentRecentMatchData = odiRecentMatchData
        }
        currentRecentMatchData = odiRecentMatchData
        setLabelHidden()
        tvRecentMatches.reloadData()
    }
    @IBAction func TestBtn(_ sender: Any)
    {
        UIView.animate(withDuration: 0.5, animations: {
            self.selectedTabConstraint.constant = self.testBgView.frame.origin.x
            self.view.layoutIfNeeded()
        })
        if testRecentMatchData.count == 0
        {
            self.getRecentMatchData(type: "test", page: 1)
        }
        else
        {
            currentRecentMatchData = testRecentMatchData
        }
        setLabelHidden()
        tvRecentMatches.reloadData()
    }
    @IBAction func t20Btn(_ sender: Any)
    {
        UIView.animate(withDuration: 0.5, animations: {
            self.selectedTabConstraint.constant = self.t20BgView.frame.origin.x
            self.view.layoutIfNeeded()
        })
//        if t20RecentMatchData.count == 0
//        {
//            self.getRecentMatchData(type: "t20", page: 1)
//        }
//        else
//        {
            currentRecentMatchData = t20RecentMatchData
       // }
        setLabelHidden()
        tvRecentMatches.reloadData()
    }
    
    @IBAction func btnBackAction(_ sender: Any) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
}
extension RecentMatchVC: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool
    {
       return true
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath)
    {
        if indexPath.row % interval != 0
        {
        if let cell = tableView.cellForRow(at: indexPath) as? RecentMatchCell
            {
                cell.MainView.backgroundColor = UIColor.gray
            }
        }
        else
        {
            if let cell = tableView.cellForRow(at: indexPath) as? RecentMatchAdCell
            {
                    cell.MainView.backgroundColor = UIColor.gray
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath)
    {
        if indexPath.row % interval != 0
        {
            if let cell = tableView.cellForRow(at: indexPath) as? RecentMatchCell{
                UIView.animate(withDuration: 1, animations: {
                    cell.MainView.backgroundColor = UIColor.white
                }) { (true) in
                }}
        }
        else
        {
            if let cell = tableView.cellForRow(at: indexPath) as? RecentMatchAdCell{
                UIView.animate(withDuration: 0.05, animations: {
                    cell.MainView.backgroundColor = UIColor.white
                }) { (true) in
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        if let key = currentRecentMatchData[indexPath.row].is_score, key == 1
        {
            let vc = AppStoryboard.main.instantiateViewController(withIdentifier: "CommentryScorecardVC") as! CommentryScorecardVC
            vc.titleLbl = currentRecentMatchData[indexPath.row].s_name!
            vc.matchKey = currentRecentMatchData[indexPath.row].key!
            vc.matchStatus = currentRecentMatchData[indexPath.row].status ?? ""
            vc.isCommentryAvailable = currentRecentMatchData[indexPath.row].is_comm == 1 ? true : false
//            self.navigationController?.pushViewController(vc, animated: true)
            let newNav = UINavigationController(rootViewController: vc)
            self.present(newNav, animated: true, completion: nil)
        }
        else
        {
            Drop.down("Scorecard not available")
        }
    }
}

extension RecentMatchVC: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return currentRecentMatchData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if indexPath.row % interval != 0
        {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentMatchCell", for: indexPath) as! RecentMatchCell
        cell.selectionStyle = .none
            cell.configureCell(recentData: self.currentRecentMatchData[indexPath.row],path:self.path)
        return cell
        }
        else
        {
            if nativeAds.count == 5{
                let cell = tableView.dequeueReusableCell(withIdentifier: "RecentMatchAdCell", for: indexPath) as! RecentMatchAdCell
                cell.selectionStyle = .none
            if let adView = cell.contentView.subviews[2] as? GADUnifiedNativeAdView
            {
                if currentRecentMatchData.count < 6{
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
                else if currentRecentMatchData.count > 5 && currentRecentMatchData.count < 11{
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
                else if currentRecentMatchData.count > 10 && currentRecentMatchData.count < 16{
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
                cell.configureCell(recentData: self.currentRecentMatchData[indexPath.row],vc: self,path:self.path)
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecentMatchCell", for: indexPath) as! RecentMatchCell
            cell.selectionStyle = .none
            cell.configureCell(recentData: self.currentRecentMatchData[indexPath.row],path:self.path)
            return cell
        }
    }
}

extension RecentMatchVC:UIScrollViewDelegate
{
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if (((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ) && !isLoading && (self.currentRecentMatchData.count) > 0)
        {
            if self.selectedTabConstraint.constant == self.odiBgView.frame.origin.x,
                (self.odiRecentMatchData.count%20) == 0
            {
                self.getRecentMatchDataPaging(type: "one-day", page: ((self.odiRecentMatchData.count/20)+1))
                isLoading = true
            }
            else if self.selectedTabConstraint.constant == self.testBgView.frame.origin.x,
            (self.testRecentMatchData.count%20) == 0
            {
                self.getRecentMatchDataPaging(type: "test", page: ((self.testRecentMatchData.count/20)+1))
                isLoading = true
            }
            else if self.selectedTabConstraint.constant == self.t20BgView.frame.origin.x
            {
                if (self.t20RecentMatchData.count%20) == 0
                {
                self.getRecentMatchDataPaging(type: "t20", page: ((self.t20RecentMatchData.count/20)+1))
                    isLoading = true
                }
            }
        }
    }
    
    private func getRecentMatchDataPaging(type:String,page:Int){
        CLGUserService().HomeService(url:NewBaseUrlV4+CLGRecentClass.recentMatch , method: .get, showLoader: 2, header: header, parameters: ["format":type,"pageNo":page]).then(execute: { (data) -> Void in
            self.isLoading = false
            if data.statusCode == 1,
                let match = (data.responseData?.match){
                for item in match
                {
                    item.format = type
                }
                if type == "one-day"
                {
                    self.odiRecentMatchData.append(contentsOf: match)
                    self.currentRecentMatchData = self.odiRecentMatchData
                }
                else if type == "t20"
                {
                    self.t20RecentMatchData.append(contentsOf: match)
                    self.currentRecentMatchData = self.t20RecentMatchData
                }
                else
                {
                    self.testRecentMatchData.append(contentsOf: match)
                    self.currentRecentMatchData = self.testRecentMatchData
                }
                self.reloadBtn.isHidden = true
            }
            self.tvRecentMatches.reloadData()
        }).catch { (error) in
            print(error)
            self.isLoading = false
            if self.t20RecentMatchData.count == 0 && self.testRecentMatchData.count == 0  && self.odiRecentMatchData.count == 0
            {
                self.reloadBtn.isHidden = false
            }
        }
    }
}

/*extension RecentMatchVC:GADBannerViewDelegate{
    
    func adViewDidReceiveAd(_ view: GADBannerView) {
        bannerHeight.constant = 50.0
    }
    
    func adView(_ view: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        bannerHeight.constant = 0.0
    }
}*/
/*extension RecentMatchVC:GADUnifiedNativeAdLoaderDelegate
{
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADUnifiedNativeAd) {
        nativeAds.append(nativeAd)
        tvRecentMatches.reloadData()
    }
}
extension RecentMatchVC:GADAdLoaderDelegate{
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
        print("\(adLoader) failed with error: \(error.localizedDescription)")
    }
}*/


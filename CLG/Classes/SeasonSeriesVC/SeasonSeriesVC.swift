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
import ObjectMapper

class SeasonSeriesVC: BaseViewController,GADBannerViewDelegate,GADInterstitialDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate
{
    //MARK:-IBOutlet
    @IBOutlet weak var reloadBtn: UIButton!
    @IBOutlet weak var tvSeasonList: UITableView!
    @IBOutlet weak var gadBannerView: GADBannerView!
    @IBOutlet weak var bannerHeight: NSLayoutConstraint!
    @IBOutlet weak var LblNoSeason: UILabel!

    //MARK:-Variables And Constants
    
    var bannerAdView: FBAdView!
    
    var interstitialAds: GADInterstitial!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var seasonSeriesData = [CLGHomeResponseResultSeriesArrData]()
    private var currentPage =  1

    override func viewDidLoad() {
        super.viewDidLoad()
        LblNoSeason.isHidden = true
        setUp()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setUp(){
        self.registerHeaderFooterNib(tv: tvSeasonList, cellName: "SeasonSeriesHeaderCell")
        self.setupNavigationBarTitle("SEASONS/SERIES", navBG: "", leftBarButtonsType: [.back], rightBarButtonsType: [])
        self.tvSeasonList.tableFooterView = UIView()
        tvSeasonList.estimatedRowHeight = 60
        let appDel = UIApplication.shared.delegate as! AppDelegate
        if (appDel.fbInterstitialAd != nil) && appDel.fbInterstitialAd.isAdValid && appDel.toShowInterstitial {
            appDel.fbInterstitialAd.show(fromRootViewController: self)
            appDel.fbInterstitialAd = nil
            appDel.fbInterstitialAd = appDel.loadInterstitialFbAd()
            appDel.toShowInterstitial = false
            appDel.runTimer()
        }
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
    
    private func getSeriesData(){
        var paramDict = [String:Any]()
        CLGUserService().seriesServiceee(url: NewBaseUrlV3+CLGRecentClass.series, method: .get, showLoader: 2, header: header, parameters: paramDict).then(execute: { (data) -> Void in
            if data.statusCode == 1{
                let currentDate = Date().toMillis()
                let SeriesData =  try! JSONSerialization.data(withJSONObject: data.toJSON() as Any, options: [])
                let jsonData = String(data:SeriesData, encoding:.utf8)!
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
                        apiDataObj.seriesApiData = jsonData
                    }
                    else
                    {
                        for item in items
                        {
                            item.seriesApiData = jsonData
                        }
                    }
                    try context.save()
                }
                catch
                {
                    
                }
                UserDefault.saveToUserDefault(value: currentDate as AnyObject, key: "SeriesDate")
//                if let responseData = data.responseData, let result = responseData.result{
//                    if let series = result.series{
//                        self.seasonSeriesData.append(contentsOf:series)
//                    }
//
//                }
                if let responseData = data.responseData{
                    if let series = responseData.series{
                        self.seasonSeriesData.append(contentsOf:series)
                    }
                    
                }

            }
            self.reloadBtn.isHidden = true
            if self.seasonSeriesData.count == 0{
                self.LblNoSeason.isHidden = false
            }else{
                self.LblNoSeason.isHidden = true
            }
            //self.interstitialAds = self.createAndLoadInterstitial()
            //self.ShowAd()
            self.tvSeasonList.reloadData()
        }).catch { (error) in
            print(error)
            if self.seasonSeriesData.count == 0
            {
                self.reloadBtn.isHidden = false
            }
        }
    }
    
    private func hitApi()
    {
        var seriesDate = Double()
        if let newSeriesDate  = UserDefault.userDefaultForAny(key: "SeriesDate") as? Double
        {
            seriesDate = newSeriesDate
        }
        
        if let series = AppHelper.appDelegate().apiInfo.series{
            if let matchDate = AppHelper.stringToGmtDate(strDate: series, format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
            {
                if Double(seriesDate) > matchDate.timeIntervalSince1970*1000
                {
                    var SeriesData = [String:AnyObject]()
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
                            string = (item.value(forKey: "seriesApiData") as? String)!
                        }
                        
                    } catch
                    {
                        print(error.localizedDescription)
                    }
                    if let data = string.data(using: .utf8)
                    {
                        do
                        {
                            SeriesData = try (JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject])!
                        }
                        catch
                        {
                            print(error.localizedDescription)
                        }
                    }
                    
                    let seriesModel = Mapper<CLGSeriesApiResponse>().map(JSON: SeriesData)
                    
                    if let responseData = seriesModel?.responseData{//, let result = responseData.result{
                        if let series = responseData.series{//result.series{
                            self.seasonSeriesData.append(contentsOf:series)
                        }
                        
                        if self.seasonSeriesData.count == 0{
                            self.LblNoSeason.isHidden = false
                        }else{
                            self.LblNoSeason.isHidden = true
                        }
                        self.tvSeasonList.reloadData()
                    }
                    //self.interstitialAds = createAndLoadInterstitial()
                    //ShowAd()
                    return
                }
            }
        }
        self.getSeriesData()
    }
    
    //MARK:-IBActions
    @IBAction func reloadBtnAction(_ sender: Any) {
        hitApi()
    }
    @IBAction func btnBackAction(_ sender: Any){
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
}

extension SeasonSeriesVC: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 30
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        if let _id = self.seasonSeriesData[indexPath.section].data![indexPath.row]._id{
            if let name = self.seasonSeriesData[indexPath.section].data![indexPath.row].name{
                let seasonSeriesMatchesVC = AppHelper.intialiseViewController(fromMainStoryboard: "Module2", withName: "SeasonSeriesMatchesVC") as! SeasonSeriesMatchesVC
                seasonSeriesMatchesVC.getSeriesIdFromPrevClass(id:_id,navTitle:name)
                self.navigationController?.pushViewController(seasonSeriesMatchesVC, animated: true)
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
}
extension SeasonSeriesVC: UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return self.seasonSeriesData.count
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "SeasonSeriesHeaderCell") as! SeasonSeriesHeaderCell
        let loaclFormatter = DateFormatter()
        loaclFormatter.dateFormat = "yyyy-MM"//EEE, MMM d, yyyy -
        let StartDate = loaclFormatter.date(from: self.seasonSeriesData[section].year ?? "2011-08")
        loaclFormatter.dateFormat = "MMMM yyyy"//EEE, MMM d, yyyy -
        cell.lblDate.text = loaclFormatter.string(from: StartDate!).uppercased()
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return (self.seasonSeriesData[section].data?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "SeasonSeriesListCell", for: indexPath) as! SeasonSeriesListCell
        cell.setData(data:self.seasonSeriesData[indexPath.section].data![indexPath.row])
        return cell
    }
}


//extension SeasonSeriesVC:UIScrollViewDelegate{
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView){
//        if ((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ){
//            if (totalCount/20) >= currentPage{
//                currentPage+=1
//                getSeriesData()
//            }
//        }
//    }
//}


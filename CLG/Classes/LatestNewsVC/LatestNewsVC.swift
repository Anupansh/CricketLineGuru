//
//  LatestNewsVC.swift
//  cricrate
//


import UIKit
import GoogleMobileAds
import CoreData
import ObjectMapper
import Firebase

class LatestNewsVC: BaseViewController,UITableViewDelegate,UITableViewDataSource,GADBannerViewDelegate,GADInterstitialDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate
{
    
    //MARK:- Variables and Constants
    
    var interstitialAds: GADInterstitial!
    
    private var latestNewsArray = [CLGHomeResponseDataNewsV3]()
    private var currentPage =  1
    var newsPath = String()
    var nativeAds = [GADUnifiedNativeAd]()
    var bannerAdView: FBAdView!
    
    
    //MARK:- IBOutlets
    @IBOutlet weak var reloadBtn: UIButton!
    @IBOutlet weak var bannerHeight: NSLayoutConstraint!
    @IBOutlet weak var latestNewsTable: UITableView!
    @IBOutlet weak var gadBannerView: GADBannerView!
    
    //MARK:- View LifeCycle
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.setupNavigationBarTitle("NEWS", navBG: "", leftBarButtonsType: [.back], rightBarButtonsType: [])
        self.latestNewsTable.tableFooterView = UIView()
        self.latestNewsTable.estimatedRowHeight = 300
        self.latestNewsTable.register(nib: HomeNewsAdCell.className)
        hitAPI()
        let appDel = UIApplication.shared.delegate as! AppDelegate
        if (appDel.fbInterstitialAd != nil) && appDel.fbInterstitialAd.isAdValid && appDel.toShowInterstitial {
            appDel.fbInterstitialAd.show(fromRootViewController: self)
            appDel.fbInterstitialAd = nil
            appDel.fbInterstitialAd = appDel.loadInterstitialFbAd()
            appDel.toShowInterstitial = false
            appDel.runTimer()
        }
        self.loadFbBannerAd()
    }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
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
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: Noti, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK:- Back Button Action
    @IBAction func reloadBtnAction(_ sender: Any) {
        hitAPI()
    }
    @IBAction func bckBtnAction(_ sender: Any){
        _ = navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Table View Delegate and DataSources
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.latestNewsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        if indexPath.row%3 == 0 && nativeAds.count == 5
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeNewsAdCell") as! HomeNewsAdCell
            cell.selectionStyle = .none
            if let adView = cell.contentView.subviews[1] as? GADUnifiedNativeAdView
            {
                
                if latestNewsArray.count < 4{
                    if indexPath.row == 0{
                        nativeAds[0].rootViewController = self
                        adView.nativeAd = nativeAds[0]
                        (adView.headlineView as! UILabel).text = nativeAds[0].headline
                        (adView.bodyView as! UILabel).text = nativeAds[0].body
                        (adView.advertiserView as! UILabel).text = nativeAds[0].advertiser
                        (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
                        (adView.callToActionView as! UIButton).setTitle(
                            nativeAds[0].callToAction, for: UIControlState.normal)
                    }
                    else if indexPath.row == 3{
                        nativeAds[1].rootViewController = self
                        adView.nativeAd = nativeAds[1]
                        (adView.headlineView as! UILabel).text = nativeAds[1].headline
                        (adView.bodyView as! UILabel).text = nativeAds[1].body
                        (adView.advertiserView as! UILabel).text = nativeAds[1].advertiser
                        (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
                        (adView.callToActionView as! UIButton).setTitle(
                            nativeAds[1].callToAction, for: UIControlState.normal)
                    }
                }
                else if latestNewsArray.count > 3 && latestNewsArray.count < 7{
                    if indexPath.row == 0{
                        nativeAds[0].rootViewController = self
                        adView.nativeAd = nativeAds[0]
                        (adView.headlineView as! UILabel).text = nativeAds[0].headline
                        (adView.bodyView as! UILabel).text = nativeAds[0].body
                        (adView.advertiserView as! UILabel).text = nativeAds[0].advertiser
                        (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
                        (adView.callToActionView as! UIButton).setTitle(
                            nativeAds[0].callToAction, for: UIControlState.normal)
                    }
                    
                    else if indexPath.row == 3{
                        nativeAds[1].rootViewController = self
                        adView.nativeAd = nativeAds[1]
                        (adView.headlineView as! UILabel).text = nativeAds[1].headline
                        (adView.bodyView as! UILabel).text = nativeAds[1].body
                        (adView.advertiserView as! UILabel).text = nativeAds[1].advertiser
                        (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
                        (adView.callToActionView as! UIButton).setTitle(
                            nativeAds[1].callToAction, for: UIControlState.normal)
                    }
                    else{
                        nativeAds[2].rootViewController = self
                        adView.nativeAd = nativeAds[2]
                        (adView.headlineView as! UILabel).text = nativeAds[2].headline
                        (adView.bodyView as! UILabel).text = nativeAds[2].body
                        (adView.advertiserView as! UILabel).text = nativeAds[2].advertiser
                        (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
                        (adView.callToActionView as! UIButton).setTitle(
                            nativeAds[2].callToAction, for: UIControlState.normal)
                    }
                }
                
                else if latestNewsArray.count > 6  && latestNewsArray.count < 10{
                    if indexPath.row == 0{
                        nativeAds[0].rootViewController = self
                        adView.nativeAd = nativeAds[0]
                        (adView.headlineView as! UILabel).text = nativeAds[0].headline
                        (adView.bodyView as! UILabel).text = nativeAds[0].body
                        (adView.advertiserView as! UILabel).text = nativeAds[0].advertiser
                        (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
                        (adView.callToActionView as! UIButton).setTitle(
                            nativeAds[0].callToAction, for: UIControlState.normal)
                    }
                        
                    else if indexPath.row == 3{
                        nativeAds[1].rootViewController = self
                        adView.nativeAd = nativeAds[1]
                        (adView.headlineView as! UILabel).text = nativeAds[1].headline
                        (adView.bodyView as! UILabel).text = nativeAds[1].body
                        (adView.advertiserView as! UILabel).text = nativeAds[1].advertiser
                        (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
                        (adView.callToActionView as! UIButton).setTitle(
                            nativeAds[1].callToAction, for: UIControlState.normal)
                    }
                    else if indexPath.row == 6{
                        nativeAds[2].rootViewController = self
                        adView.nativeAd = nativeAds[2]
                        (adView.headlineView as! UILabel).text = nativeAds[2].headline
                        (adView.bodyView as! UILabel).text = nativeAds[2].body
                        (adView.advertiserView as! UILabel).text = nativeAds[2].advertiser
                        (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
                        (adView.callToActionView as! UIButton).setTitle(
                            nativeAds[2].callToAction, for: UIControlState.normal)
                    }
                    else{
                        nativeAds[3].rootViewController = self
                        adView.nativeAd = nativeAds[3]
                        (adView.headlineView as! UILabel).text = nativeAds[3].headline
                        (adView.bodyView as! UILabel).text = nativeAds[3].body
                        (adView.advertiserView as! UILabel).text = nativeAds[3].advertiser
                        (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
                        (adView.callToActionView as! UIButton).setTitle(
                            nativeAds[3].callToAction, for: UIControlState.normal)
                    }
                }
                else{
                    if indexPath.row == 0{
                        nativeAds[0].rootViewController = self
                        adView.nativeAd = nativeAds[0]
                        (adView.headlineView as! UILabel).text = nativeAds[0].headline
                        (adView.bodyView as! UILabel).text = nativeAds[0].body
                        (adView.advertiserView as! UILabel).text = nativeAds[0].advertiser
                        (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
                        (adView.callToActionView as! UIButton).setTitle(
                            nativeAds[0].callToAction, for: UIControlState.normal)
                    }
                        
                    else if indexPath.row == 3{
                        nativeAds[1].rootViewController = self
                        adView.nativeAd = nativeAds[1]
                        (adView.headlineView as! UILabel).text = nativeAds[1].headline
                        (adView.bodyView as! UILabel).text = nativeAds[1].body
                        (adView.advertiserView as! UILabel).text = nativeAds[1].advertiser
                        (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
                        (adView.callToActionView as! UIButton).setTitle(
                            nativeAds[1].callToAction, for: UIControlState.normal)
                    }
                    else if indexPath.row == 6{
                        nativeAds[2].rootViewController = self
                        adView.nativeAd = nativeAds[2]
                        (adView.headlineView as! UILabel).text = nativeAds[2].headline
                        (adView.bodyView as! UILabel).text = nativeAds[2].body
                        (adView.advertiserView as! UILabel).text = nativeAds[2].advertiser
                        (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
                        (adView.callToActionView as! UIButton).setTitle(
                            nativeAds[2].callToAction, for: UIControlState.normal)
                    }
                    else if indexPath.row == 9{
                        nativeAds[3].rootViewController = self
                        adView.nativeAd = nativeAds[3]
                        (adView.headlineView as! UILabel).text = nativeAds[3].headline
                        (adView.bodyView as! UILabel).text = nativeAds[3].body
                        (adView.advertiserView as! UILabel).text = nativeAds[3].advertiser
                        (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
                        (adView.callToActionView as! UIButton).setTitle(
                            nativeAds[3].callToAction, for: UIControlState.normal)
                    }
                    else{
                        nativeAds[4].rootViewController = self
                        adView.nativeAd = nativeAds[4]
                        (adView.headlineView as! UILabel).text = nativeAds[4].headline
                        (adView.bodyView as! UILabel).text = nativeAds[4].body
                        (adView.advertiserView as! UILabel).text = nativeAds[4].advertiser
                        (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
                        (adView.callToActionView as! UIButton).setTitle(
                            nativeAds[4].callToAction, for: UIControlState.normal)
                    }
                }
                
            }
            let formatter = DateFormatter()
            cell.imgViewNews.image = nil
            cell.lblNewsTime.text = AppHelper.timeAgoSinceDate(AppHelper.stringToGmtDate(strDate: latestNewsArray[indexPath.row].created!, format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")! , currentDate: Date(), numericDates: true)
            cell.lblNewTitle.text = latestNewsArray[indexPath.row].title
            if let str = latestNewsArray[indexPath.row].description
            {
                cell.lblNewsDiscription.text = str.html2String
            }
            if let url = URL(string: (self.newsPath+latestNewsArray[indexPath.row].image!))
            {
                cell.imgViewNews.af_setImage(withURL: url)
            }
            if(latestNewsArray[indexPath.row].is_link == true)
            {
                cell.youtubeImgVw.isHidden = false
            }
            else{
                cell.youtubeImgVw.isHidden = true
            }
            return cell
        }
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! LatestNewsCell
        cell.selectionStyle = .none
        cell.configureCell(newsData:self.latestNewsArray[indexPath.row],newsPath:newsPath)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if(self.latestNewsArray[indexPath.row].is_link == true)
        {
            if let youtubeUrl = latestNewsArray[indexPath.row].url_link{
                if let urlStr = URL(string: youtubeUrl){
                    if #available(iOS 10.0, *){
                        UIApplication.shared.open(urlStr)
                    }
                    else{
                        UIApplication.shared.openURL(urlStr)
                    }
                }
                
            }
        }
        else
        {
            let selectedVC = self.storyboard?.instantiateViewController(withIdentifier: "LatestNewsSelectionVC") as! LatestNewsSelectionVC
            selectedVC.getDataFromPrevClass(data: self.latestNewsArray[indexPath.row])
            selectedVC.baseUrl = newsPath
            self.navigationController?.pushViewController(selectedVC, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        //        let newsData = self.latestNewsArray[indexPath.row]
        //        var totalHeight = 200.0
        //        if let title = newsData.title{
        //            let heightOfLbl = title.height(withConstrainedWidth: tableView.frame.size.width - 16, font: UIFont(name: "Lato-Medium", size: 16.0)!)
        //            totalHeight = totalHeight + Double(heightOfLbl)
        //        }
        //        return CGFloat(totalHeight)
        return 300
    }
    
    
    @objc func showNativeAd(){
        nativeAds = AppHelper.appDelegate().returnNativeAdArray()
    }
    
    
    
    private func getLatestNewsData(){
        var paramDict = [String:Any]()
        paramDict["pageNo"] = "\(self.currentPage)"
        CLGUserService().newsServiceV3(url: NewBaseUrlV3+CLGRecentClass.latestNewsAll, method: .get, showLoader: 1, header: header, parameters: paramDict).then(execute: { (data) -> Void in
            if data.statusCode == 1{
                let currentDate = Date().toMillis()
                let newsData =  try! JSONSerialization.data(withJSONObject: data.toJSON(), options: [])
                let jsonData = String(data:newsData, encoding:.utf8)!
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
                        apiDataObj.newsApiData = jsonData
                    }
                    else
                    {
                        for item in items
                        {
                            item.newsApiData = jsonData
                        }
                    }
                    try context.save()
                    
                } catch {
                }
                self.reloadBtn.isHidden = true
                UserDefault.saveToUserDefault(value: currentDate as AnyObject, key: "NewsDate")
                
                if let responseData = data.responseData{
                    if let news = responseData.news{
                        self.latestNewsArray.append(contentsOf: news)
                        self.newsPath = responseData.newsPath ?? ""
                    }
                    
                }
            }
            //self.interstitialAds = self.createAndLoadInterstitial()
            //self.ShowAd()
            self.showNativeAd()
            self.latestNewsTable.reloadData()
        }).catch { (error) in
            print(error)
            if self.latestNewsArray.count == 0
            {
                self.reloadBtn.isHidden = false
            }
        }
    }
    
    //MARK:- Hit API
    
    func hitAPI()
    {
        var newsDate = Double()
        if let newNewsDate  = UserDefault.userDefaultForAny(key: "NewsDate") as? Double
        {
            newsDate = newNewsDate
        }
        
        if let news = AppHelper.appDelegate().apiInfo.news{
            if let matchDate = AppHelper.stringToGmtDate(strDate: news, format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
            {
                if Double(newsDate) > matchDate.timeIntervalSince1970*1000
                {
                    var NewsData = [String:AnyObject]()
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
                            string = (item.value(forKey: "newsApiData") as? String)!
                        }
                    } catch
                    {
                        print(error.localizedDescription)
                    }
                    if let data = string.data(using: .utf8)
                    {
                        do
                        {
                            NewsData = try (JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject])!
                        }
                        catch
                        {
                            print(error.localizedDescription)
                        }
                    }
                    let newsModel = Mapper<HomeApiResponseV3>().map(JSON: NewsData)
                    if let responseData = newsModel?.responseData{
                        if let news = responseData.news{
                            self.latestNewsArray.append(contentsOf: news)
                            self.newsPath = responseData.newsPath ?? ""
                        }
                        
                    }
                    self.latestNewsTable.reloadData()
                   // self.interstitialAds = createAndLoadInterstitial()
                   // self.ShowAd()
                    self.showNativeAd()
                    return
                }
            }
        }
        getLatestNewsData()
    }
}


extension LatestNewsVC:UIScrollViewDelegate{
    
    //    func scrollViewDidScroll(_ scrollView: UIScrollView){
    //        if ((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ){
    //            if (totalCount/3) >= currentPage{
    //                currentPage+=1
    //                getLatestNewsData()
    //            }
    //        }
    //    }
}

//
//  LatestNewsVC.swift
//  cricrate
//


import UIKit
import GoogleMobileAds
import SVProgressHUD
import CoreData
import ObjectMapper

class LatestNewsVC: BaseViewController,UITableViewDelegate,UITableViewDataSource,GADBannerViewDelegate,GADInterstitialDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate
{
    
    //MARK:- Variables and Constants
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var interstitialAds: GADInterstitial!
    
    private var latestNewsArray = [CLGHomeResponseResultNewsData]()
    private var currentPage =  1
    private var totalCount = Int()
    
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var bannerHeight: NSLayoutConstraint!
    @IBOutlet weak var latestNewsTable: UITableView!
    @IBOutlet weak var gadBannerView: GADBannerView!
    
    //MARK:- View LifeCycle
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.interstitialAds = createAndLoadInterstitial()
        self.setupNavigationBarTitle("NEWS", navBG: "", leftBarButtonsType: [.back], rightBarButtonsType: [])
        self.latestNewsTable.tableFooterView = UIView()
        hitAPI()
        self.showGoogleAds()
    }
    
    override func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: Noti, object: nil)
        SVProgressHUD.dismiss()
    }
    
    //MARK:- Back Button Action
    
    @IBAction func bckBtnAction(_ sender: Any){
        _ = navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Table View Delegate and DataSources
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.latestNewsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! LatestNewsCell
        cell.selectionStyle = .none
        cell.configureCell(newsData:self.latestNewsArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let selectedVC = self.storyboard?.instantiateViewController(withIdentifier: "LatestNewsSelectionVC") as! LatestNewsSelectionVC
        selectedVC.getDataFromPrevClass(data: self.latestNewsArray[indexPath.row])
        self.navigationController?.pushViewController(selectedVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        let newsData = self.latestNewsArray[indexPath.row]
        var totalHeight = 200.0
        if let title = newsData.title{
            let heightOfLbl = title.height(withConstrainedWidth: tableView.frame.size.width - 16, font: UIFont(name: "Lato-Medium", size: 16.0)!)
            totalHeight = totalHeight + Double(heightOfLbl)
        }
        return CGFloat(totalHeight)
    }
    
    // AdMob banner available
    func adViewDidReceiveAd(_ view: GADBannerView) {
        bannerHeight.constant = 50.0
    }
    
    // NO AdMob banner available
    func adView(_ view: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        bannerHeight.constant = 0.0
    }
    
    func showGoogleAds(){
        self.gadBannerView.adUnitID = appDelegate.adBannerUnitID as String
        self.gadBannerView.rootViewController = self
        self.gadBannerView.load(GADRequest())
        self.gadBannerView.delegate = self
    }
    
    @objc func ShowAd(){
        let random = arc4random_uniform(1000) + 10
        if (random % 2) == 0{
            if self.interstitialAds.isReady{
                self.interstitialAds.present(fromRootViewController: self)
            }
        }
    }
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        self.perform(#selector(self.ShowAd), with: nil, afterDelay: 3.0)
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial =
            GADInterstitial(adUnitID: appDelegate.adInterstitialUnitID)
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    @objc func showAds(notification: NSNotification){
        self.gadBannerView.load(GADRequest())
    }
    
    private func getLatestNewsData(){
        var paramDict = [String:Any]()
        paramDict["pageNo"] = "\(self.currentPage)"
        paramDict["limit"] = "20"
        CLGUserService().newsService(url: NewDevBaseUrl+CLGRecentClass.latestNews, method: .post, showLoader: false, header: header, parameters: paramDict).then(execute: { (data) -> Void in
            if data.statusCode == 1{
                let currentDate = Date().toMillis()
                let newsData =  try! JSONSerialization.data(withJSONObject: data.toJSON(), options: [])
                let jsonData = String(data:newsData, encoding:.utf8)!
                var context:NSManagedObjectContext!
                if #available(iOS 10.0, *) {
                    context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                } else {
                    context =  (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
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
                UserDefault.saveToUserDefault(value: currentDate as AnyObject, key: "NewsDate")
                
                if let responseData = data.responseData, let result = responseData.result{
                    if let news = result.news{
                        self.latestNewsArray.append(contentsOf: news)
                    }
                    if let totalCount = result.totalCount{
                        self.totalCount = totalCount
                    }
                }
            }
            self.latestNewsTable.reloadData()
        }).catch { (error) in
            print(error)
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
            if let matchDate = AppHelper.stringToDate(strDate: news, format: "yyyy-MM-dd'T'HH:mm:ss")
            {
                if Double(newsDate) > matchDate.timeIntervalSince1970
                {
                    var NewsData = [String:AnyObject]()
                    var string = ""
                    var context : NSManagedObjectContext!
                    if #available(iOS 10.0, *) {
                        context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                    } else {
                        context =  (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
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
                    let newsModel = Mapper<HomeApiResponse>().map(JSON: NewsData)
                    if let responseData = newsModel?.responseData, let result = responseData.result{
                        if let news = result.news{
                            self.latestNewsArray.append(contentsOf: news)
                        }
                        if let totalCount = result.totalCount{
                            self.totalCount = totalCount
                        }
                    }
                    self.latestNewsTable.reloadData()
                    return
                }
            }
        }
        getLatestNewsData()
    }
}


extension LatestNewsVC:UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView){
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ){
            if (totalCount/20) >= currentPage{
                currentPage+=1
                getLatestNewsData()
            }
        }
    }
}

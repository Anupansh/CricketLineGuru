//
//  SquadVC.swift
//  CLG
//
//  Created by Anuj Naruka on 7/18/18.
//  Copyright © 2018 Anuj Naruka. All rights reserved.
//

import UIKit
import GoogleMobileAds
import CoreData
import ObjectMapper
import Firebase

class InfoVC: BaseViewController {

    //MARK:-IBOutlet
    @IBOutlet weak var tvInfo: UITableView!
    @IBOutlet weak var firstTeamBtn: UIButton!
    @IBOutlet weak var secondTeamBtn: UIButton!
    @IBOutlet weak var headerView: UIView!
    
    
    
    var matchInfoDict = CLGMatchInfo()
    //MARK:-Variables & Constants
    //let arr = ["Series :","Match :","Date & Time :","Venue :","Toss :","Avg 1st inn score :","Avg 2nd inn score :","Highest Total :","Lowest Total :","Highest Chased :","Lowest Defended :","",""]
//    let arr = ["Series :","Match :","Date & Time :","Venue :","Toss :","","","Avg 1st inn score :","Avg 2nd inn score :","Highest Total :","Lowest Total :","Highest Chased :","Lowest Defended :"]
    let arr = ["Series :","Match :","Date & Time :","Venue :","Toss :","Avg 1st inn score :","Avg 2nd inn score :","Highest Total :","Lowest Total :","Highest Chased :","Lowest Defended :"]
    var CurrentMatch = 0
    var currentMatchKey = String()
    lazy var fbPath: String = {
        let fbPath = String()
        return fbPath
    }()
    var bannerAdView : FBAdView!

    //MARk:-Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addObserver()
        if let matchKeyy = fireBaseGlobalModel[CurrentMatch].matchKey{
            self.currentMatchKey = matchKeyy
            FireBaseMatchLineObservers.setInfoObservers(matchKey: matchKeyy, currentMatch: CurrentMatch)
        }
//        self.loadFbBannerAd()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeObserver()
    }
    
    func loadFbBannerAd() {
            bannerAdView = FBAdView(placementID: AppHelper.appDelegate().fbBannerAdId, adSize: kFBAdSizeHeight50Banner, rootViewController: self)
            let y = self.view.frame.origin.y + self.view.frame.height - 50
            if UIDevice.current.hasTopNotch {
                bannerAdView.frame = CGRect(x: 0, y: y, width: UIScreen.main.bounds.width, height: 50)
            }
            else {
                bannerAdView.frame = CGRect(x: 0, y: y, width: UIScreen.main.bounds.width, height: 50)
            }
    //        bannerAdView.delegate = self
            self.view.addSubview(bannerAdView)
            bannerAdView.loadAd()
        }
    //MARK:-Functions
    @objc func refreshInfo()
    {
        self.tvInfo.reloadData()
        self.setUp()
    }
//    @objc func showNativeAd(){
//        self.nativeAds = AppHelper.appDelegate().returnNativeAdArray()
//    }
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    private func setUp()
    {
//        self.loadFbBannerAd()
        firstTeamBtn.setTitle(fireBaseGlobalModel[CurrentMatch].t1?.n, for: .normal)
        secondTeamBtn.setTitle(fireBaseGlobalModel[CurrentMatch].t2?.n, for: .normal)
        tvInfo.estimatedRowHeight = 120
        self.registerNib(tv: tvInfo, cellName: "InfoCell")
        self.registerHeaderFooterNib(tv: tvInfo, cellName: "MatchLineInfoHeaderCell")

        let ispresent = isKeyPresentInUserDefaults(key: "MITValue")
        if ispresent{
            if getInfoFromLocal().isEmpty{
                getInfoApiHit()
            }else{
                let mitValue = UserDefaults.standard.value(forKey: "MITValue") as! Int64
                if let firebaseMitValue = fireBaseGlobalModel[CurrentMatch].mit, let mitVlue = Int64(firebaseMitValue) {
                    if mitVlue > mitValue{
                        getInfoApiHit()
                    }
                    else{
                        var arrayOfDict = [[String:AnyObject]]()
                        var infoLocalData = HomeApiResponseV3()
                        var matchInfoJson = [String:AnyObject]()
                        let matchinfostring = self.getInfoFromLocal()
                        var tempbool = Bool()
                        tempbool = false
                        if let data = matchinfostring.data(using: .utf8)
                        {
                            do
                            {
                                arrayOfDict = try (JSONSerialization.jsonObject(with: data, options: []) as? [[String: AnyObject]])!
                            }
                            catch
                            {
                                print(error.localizedDescription)
                            }
                        }
                        for arrayItemInDict in arrayOfDict{
                            if self.currentMatchKey  == arrayItemInDict["infoKey"] as? String{
                                let matchInfoString = arrayItemInDict["infoData"] as? String
                                if let matchInfoData = matchInfoString?.data(using: .utf8){
                                    do
                                    {
                                        matchInfoJson = try(JSONSerialization.jsonObject(with: matchInfoData, options: []) as? [String:AnyObject])!
                                    }
                                    catch
                                    {
                                        print(error.localizedDescription)
                                    }
                                    infoLocalData = Mapper<HomeApiResponseV3>().map(JSON: matchInfoJson) ?? HomeApiResponseV3()
                                    if let matchinfodict = infoLocalData.responseData?.info{
                                        self.matchInfoDict = matchinfodict
                                    }
                                    tempbool = true
                                    self.tvInfo.reloadData()
                                    break
                                }
                            }
                        }
                        if tempbool == false{
                            self.getInfoApiHit()
                        }
                    }
                }
            }
        }
        else{
            getInfoApiHit()
        }
        
    }
    
    private func addObserver()
    {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(self.refreshInfo),
                                       name: .refreshMatchInfo,
                                       object: nil)
    }
    
    private func removeObserver()
    {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
        FireBaseMatchLineObservers.removeInfoObserver(matchKey: self.currentMatchKey)
    }
    
    private func getInfoApiHit(){
        
        let param = [String:Any]()
        let urlstr = NewBaseUrlV3+CLGRecentClass.matchInfo+self.currentMatchKey+CLGRecentClass.infoLiveLine
        print("info match url = ",urlstr)
        
        CLGUserService().HomeService(url:urlstr , method: .get, showLoader: 2, header: header, parameters: param).then(execute: { (data) -> Void in
            
            if data.statusCode == 1
            {
                var arrayOfInfoDict = [[String:AnyObject]]()
                let infoData =  try! JSONSerialization.data(withJSONObject: data.toJSON() as Any, options: [])
                let jsonData = String(data:infoData, encoding:.utf8)!
                arrayOfInfoDict.append(["infoKey":self.currentMatchKey as AnyObject,"infoData":jsonData as AnyObject])
                let arrayOfInfoJson = try(JSONSerialization.data(withJSONObject: arrayOfInfoDict, options: []))
                let arrayOfInfoString = String(data: arrayOfInfoJson, encoding: .utf8)
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
                        
                        apiDataObj.matchInfoData = arrayOfInfoString
                    }
                    else
                    {
                        for item in items
                        {
                            item.matchInfoData = arrayOfInfoString
                        }
                    }
                    try context.save()
                }
                catch
                {
                    
                }
                if let matchinfodict = data.responseData?.info{
                    self.matchInfoDict = matchinfodict
                }
                if let mitvalue = fireBaseGlobalModel[self.CurrentMatch].mit, let mitValueInt64 = Int64(mitvalue){
                    UserDefaults.standard.set(mitValueInt64, forKey: "MITValue")
                    if !(self.isKeyPresentInUserDefaults(key: "DeleteTime")){
                        let timeinterval = Date().timeIntervalSince1970
                        let timeinsecond = Int(timeinterval * 1000.0)
                        UserDefaults.standard.set(Int64(timeinsecond), forKey: "DeleteTime")
                    }
                    UserDefaults.standard.synchronize()
                }
                self.tvInfo.reloadData()
            }
        }).catch { (error) in
            print(error)
        }
    }
    private func getInfoFromLocal() ->String   {
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
                string = (item.value(forKey: "matchInfoData") as? String)!
            }
            
        } catch
        {
            print(error.localizedDescription)
        }
        
        return string
    }
    
    @IBAction func teamBtnPressed(_ sender: UIButton) {
        let vc = AppStoryboard.main.instantiateViewController(withIdentifier: "SquadsVC") as! SquadsVC
        vc.firstTeam = fireBaseGlobalModel[CurrentMatch].t1?.n
        vc.secondTeam = fireBaseGlobalModel[CurrentMatch].t2?.n
        vc.mit = fireBaseGlobalModel[CurrentMatch].mit!
        vc.matchKey = self.currentMatchKey
        vc.selectedIndex = sender.tag
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
extension InfoVC:UITableViewDelegate
{
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
//        return headerView
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "MatchLineInfoHeaderCell") as! MatchLineInfoHeaderCell

        if let nkey = fireBaseGlobalModel[CurrentMatch].t1?.n, nkey != ""{
            if let confirmedImage = UIImage(named: nkey.lowercased()) {
                cell.imgTeam1.image = confirmedImage
            }
            else{
                if let t1icStr = fireBaseGlobalModel[CurrentMatch].t1?.ic, t1icStr != ""
                {
                    let fullurlstr = (self.fbPath + t1icStr).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                    cell.imgTeam1.af_setImage(withURL: URL(string: fullurlstr!+".png")!, placeholderImage: #imageLiteral(resourceName: "TeamPlaceholder"))

                }
                else{
                    if let fname = fireBaseGlobalModel[CurrentMatch].t1?.f{

                        cell.imgTeam1.image = AppHelper.generateImageWithText(text: fname, image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:fname.uppercased()), size: CGSize(width: 50, height: 50)))

                    }
                    else{

                        cell.imgTeam1.image = AppHelper.generateImageWithText(text: "N/A", image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:"N/A"), size: CGSize(width: 50, height: 50)))

                    }
                }
            }
        }
        else{
            if let t1icStr = fireBaseGlobalModel[CurrentMatch].t1?.ic, t1icStr != ""
            {
                let fullurlstr = (self.fbPath + t1icStr).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                cell.imgTeam1.af_setImage(withURL: URL(string: fullurlstr!+".png")!, placeholderImage: #imageLiteral(resourceName: "TeamPlaceholder"))

            }
            else{
                if let fname = fireBaseGlobalModel[CurrentMatch].t1?.f{

                    cell.imgTeam1.image = AppHelper.generateImageWithText(text: fname, image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:fname.uppercased()), size: CGSize(width: 50, height: 50)))

                }
                else{

                    cell.imgTeam1.image = AppHelper.generateImageWithText(text: "N/A", image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:"N/A"), size: CGSize(width: 50, height: 50)))

                }
            }
        }
        if let nkey = fireBaseGlobalModel[CurrentMatch].t2?.n, nkey != ""{
            if let confirmedImage = UIImage(named: nkey.lowercased()) {
                cell.imgTeam2.image = confirmedImage
            }
            else{
                if let t2icStr = fireBaseGlobalModel[CurrentMatch].t2?.ic, t2icStr != ""
                {
                    let fullurlstr = (self.fbPath + t2icStr).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                    cell.imgTeam2.af_setImage(withURL: URL(string: fullurlstr!+".png")!, placeholderImage: #imageLiteral(resourceName: "TeamPlaceholder"))

                }
                else{
                    if let fname = fireBaseGlobalModel[CurrentMatch].t2?.f{

                        cell.imgTeam2.image = AppHelper.generateImageWithText(text: fname, image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:fname.uppercased()), size: CGSize(width: 50, height: 50)))

                    }
                    else{

                        cell.imgTeam2.image = AppHelper.generateImageWithText(text: "N/A", image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:"N/A"), size: CGSize(width: 50, height: 50)))

                    }
                }
            }
        }
        else{
            if let t2icStr = fireBaseGlobalModel[CurrentMatch].t2?.ic, t2icStr != ""
            {
                let fullurlstr = (self.fbPath + t2icStr).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                cell.imgTeam2.af_setImage(withURL: URL(string: fullurlstr!+".png")!, placeholderImage: #imageLiteral(resourceName: "TeamPlaceholder"))

            }
            else{
                if let fname = fireBaseGlobalModel[CurrentMatch].t2?.f{

                    cell.imgTeam2.image = AppHelper.generateImageWithText(text: fname, image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:fname.uppercased()), size: CGSize(width: 50, height: 50)))

                }
                else{

                    cell.imgTeam2.image = AppHelper.generateImageWithText(text: "N/A", image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:"N/A"), size: CGSize(width: 50, height: 50)))

                }

            }
        }
        /*if fireBaseGlobalModel[CurrentMatch].t1?.ic != "" && fireBaseGlobalModel[CurrentMatch].t1?.ic != nil
        {
            cell.imgTeam1.af_setImage(withURL: URL(string: (self.fbPath+(fireBaseGlobalModel[CurrentMatch].t1?.ic)!+".png"))!, placeholderImage: #imageLiteral(resourceName: "TeamPlaceholder"))
        }
        else
        {
            if let nkey = fireBaseGlobalModel[CurrentMatch].t1?.n, nkey != ""{
                if let fname = fireBaseGlobalModel[CurrentMatch].t1?.f{
                    cell.imgTeam1.image = AppHelper.loadImage(named: nkey.lowercased(),teamName:fname)
                }
                else{
                    cell.imgTeam1.image = AppHelper.loadImage(named: nkey.lowercased(),teamName:"N/A")
                }

            }
            else{
                if let fname = fireBaseGlobalModel[CurrentMatch].t1?.f{

                    cell.imgTeam1.image = AppHelper.generateImageWithText(text: fname, image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:fname.uppercased()), size: CGSize(width: 50, height: 50)))

                }
                else{

                    cell.imgTeam1.image = AppHelper.generateImageWithText(text: "N/A", image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:"N/A"), size: CGSize(width: 50, height: 50)))

                }

            }
        }
        if fireBaseGlobalModel[CurrentMatch].t2?.ic != "" && fireBaseGlobalModel[CurrentMatch].t2?.ic != nil
        {
            cell.imgTeam2.af_setImage(withURL: URL(string: (self.fbPath+(fireBaseGlobalModel[CurrentMatch].t2?.ic)!+".png"))!, placeholderImage: #imageLiteral(resourceName: "TeamPlaceholder"))
        }
        else
        {
            if let nkey = fireBaseGlobalModel[CurrentMatch].t2?.n, nkey != ""{
                if let fname = fireBaseGlobalModel[CurrentMatch].t2?.f{
                    cell.imgTeam2.image = AppHelper.loadImage(named: nkey.lowercased(),teamName:fname)
                }
                else{
                    cell.imgTeam2.image = AppHelper.loadImage(named: nkey.lowercased(),teamName:"N/A")
                }

            }
            else{
                if let fname = fireBaseGlobalModel[CurrentMatch].t2?.f{

                    cell.imgTeam2.image = AppHelper.generateImageWithText(text: fname, image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:fname.uppercased()), size: CGSize(width: 50, height: 50)))

                }
                else{

                    cell.imgTeam2.image = AppHelper.generateImageWithText(text: "N/A", image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:"N/A"), size: CGSize(width: 50, height: 50)))

                }
            }
            //self.ImgViewLeftTeam.image = #imageLiteral(resourceName: "TeamPlaceholder")
        }*/
        cell.lblTeam1.text = fireBaseGlobalModel[CurrentMatch].t1?.n
        cell.lblTeam2.text = fireBaseGlobalModel[CurrentMatch].t2?.n
        cell.lblTeam1.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
        cell.lblTeam2.textColor = UIColor(red: 61/255, green: 67/255, blue: 117/255, alpha: 1.0)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
            return 0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat
    {
        return  0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
//        if nativeAds.count > 1{
//            if indexPath.row == arr.count{
//                return 170
//            }
////            else if indexPath.row == 5
////            {
////                return (self.matchInfoDict.t1p != "" && self.matchInfoDict.t1p != nil) ? UITableViewAutomaticDimension : 55
////            }
////            else if indexPath.row == 6
////            {
////                return (self.matchInfoDict.t2p != "" && self.matchInfoDict.t2p != nil) ? UITableViewAutomaticDimension : 55
////            }
//            else{
//                return 55
//            }
//        }
//        else{
//            if indexPath.row == 5
//            {
//                return (self.matchInfoDict.t1p != "" && self.matchInfoDict.t1p != nil) ? UITableViewAutomaticDimension : 55
//            }
//            else if indexPath.row == 6
//            {
//                return (self.matchInfoDict.t2p != "" && self.matchInfoDict.t2p != nil) ? UITableViewAutomaticDimension : 55
//            }
//            else
//            {
                return 55
//            }
            
//        }
        /*if indexPath.row == 11 || indexPath.row == 12
        {
            return UITableViewAutomaticDimension
        }
        else if indexPath.row == arr.count
        {
            return 170
        }
        return 55*/
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
    }
}
extension InfoVC:UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
//        if nativeAds.count > 1{
////            return arr.count+1
//            return arr.count - 1
//        }
//        else{
//            return arr.count
            return arr.count - 2
//        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell") as! InfoCell
        cell.bannerView.isHidden = true
        cell.lblTitle.isHidden = false
        cell.lblValue.isHidden = false
        cell.nativeAdView.isHidden = true
        cell.proportionalWidthConstraint.constant = -55
        
        cell.selectionStyle = .none
        if indexPath.row == 0
        {
            cell.lblTitle.text = arr[indexPath.row]
            cell.lblValue.text = fireBaseGlobalModel[CurrentMatch].con?.sr
        }
        else if indexPath.row == 1
        {
            cell.lblTitle.text = arr[indexPath.row]
            cell.lblValue.text = self.matchInfoDict.m//fireBaseGlobalModel[CurrentMatch].con?.mn
        }
        else if indexPath.row == 2
        {
            cell.lblTitle.text = arr[indexPath.row]
            cell.lblValue.text = AppHelper.getMatchDateAndTime(type: 2, date: (fireBaseGlobalModel[CurrentMatch].con?.mtm)!)
        }
        else if indexPath.row == 3
        {
            cell.lblTitle.text = arr[indexPath.row]
            cell.lblValue.text = fireBaseGlobalModel[CurrentMatch].con?.g
        }
        else if indexPath.row == 4
        {
            cell.lblTitle.text = arr[indexPath.row]
            cell.lblValue.text = self.matchInfoDict.tw
        }
        else if indexPath.row == 5
        {
//            cell.lblTitle.text = (fireBaseGlobalModel[CurrentMatch].t1?.n)! + " Players :"
//            cell.lblValue.text = self.matchInfoDict.t1p != "" ? self.matchInfoDict.t1p : " \n "
            cell.lblTitle.text = arr[indexPath.row]
            cell.lblValue.text = self.matchInfoDict.a1s
            
        }
        else if indexPath.row == 6
        {
//            cell.lblTitle.text = (fireBaseGlobalModel[CurrentMatch].t2?.n)! + " Players :"
//            cell.lblValue.text = self.matchInfoDict.t2p != "" ? self.matchInfoDict.t2p : " \n "
            cell.lblTitle.text = arr[indexPath.row]
            cell.lblValue.text = self.matchInfoDict.a2s
            
        }
        else if indexPath.row == 7
        {
//            cell.lblTitle.text = arr[indexPath.row]
//            cell.lblValue.text = self.matchInfoDict.a1s
            cell.lblTitle.text = arr[indexPath.row]
            cell.lblValue.text = self.matchInfoDict.mx
            
        }
        else if indexPath.row == 8
        {
//            cell.lblTitle.text = arr[indexPath.row]
//            cell.lblValue.text = self.matchInfoDict.a2s
            cell.lblTitle.text = arr[indexPath.row]
            cell.lblValue.text = self.matchInfoDict.mn
            
        }
        else if indexPath.row == 9
        {
//            cell.lblTitle.text = arr[indexPath.row]
//            cell.lblValue.text = self.matchInfoDict.mx
            cell.lblTitle.text = arr[indexPath.row]
            cell.lblValue.text = self.matchInfoDict.mxc
            
        }
        else if indexPath.row == 10
        {
//            cell.lblTitle.text = arr[indexPath.row]
//            cell.lblValue.text = self.matchInfoDict.mn
            cell.lblTitle.text = arr[indexPath.row]
            cell.lblValue.text = self.matchInfoDict.mnd
            
        }
//        else if indexPath.row == 11
//        {
////            cell.lblTitle.text = arr[indexPath.row]
////            cell.lblValue.text = self.matchInfoDict.mxc
//
//        }
//        else if indexPath.row == 12
//        {
////            cell.lblTitle.text = arr[indexPath.row]
////            cell.lblValue.text = self.matchInfoDict.mnd
//
//        }
        else
        {
            cell.bannerView.isHidden = true
            cell.lblTitle.isHidden = true
            cell.lblValue.isHidden = true
//            if nativeAds.count > 1{
//                cell.nativeAdView.isHidden = false
//                cell.bannerView.adUnitID = AppHelper.appDelegate().adBannerUnitID as String
//                cell.bannerView.rootViewController = self
//                cell.bannerView.load(GADRequest())
//                if let adView = cell.nativeAdView
//                {
//                    nativeAds[1].rootViewController = self
//                    adView.nativeAd = nativeAds[1]
//                    (adView.headlineView as! UILabel).text = nativeAds[1].headline
//                    (adView.bodyView as! UILabel).text = nativeAds[1].body
//                    //(adView.advertiserView as! UILabel).text = nativeAds[0].advertiser
//                    (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
//                    (adView.callToActionView as! UIButton).setTitle(
//                        nativeAds[1].callToAction, for: UIControlState.normal)
//
//                }
//            }
        }
        return cell
    }
}

extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem!, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}

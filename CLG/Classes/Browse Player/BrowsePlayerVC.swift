//
//  BrowsePlayerVC.swift
//  CLG
//
//  Created by Brainmobi on 30/07/18.
//  Copyright © 2018 Anuj Naruka. All rights reserved.
//

import UIKit
import GoogleMobileAds
import CoreData
import ObjectMapper

class BrowsePlayerVC: BaseViewController,GADBannerViewDelegate,GADInterstitialDelegate {
    
    //MARK:- Properties
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var interstitialAds: GADInterstitial!
    private var playerData = [CLGTeamNameModel]()
    internal var nameDictionary = [String: [CLGTeamNameModel]]()
    internal var nameSectionTitles = [String]()
    var playerPath =  String()
    var bannerAdView: FBAdView!

    //MARK:- IBOutlets
    @IBOutlet weak var reloadBtn: UIButton!
    @IBOutlet weak var lblNoResultFound: UILabel!
    @IBOutlet weak var playerSearchBar: UISearchBar!
    @IBOutlet weak var tblPlayer: UITableView!
    @IBOutlet weak var gadBannerView: GADBannerView!
    @IBOutlet weak var bannerHeight: NSLayoutConstraint!
    @IBOutlet weak var searchBarHeightConstraint: NSLayoutConstraint!
    
    //MARK:- View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadFbBannerAd()
        playerSearchBar.textColor = UIColor.white
        playerSearchBar.placeholder = "Search Player"
        searchBarHeightConstraint.constant = 0.0
        self.setupNavigationBarTitle("BROWSE PLAYER", navBG: "", leftBarButtonsType: [.back], rightBarButtonsType: [.search])
        self.tblPlayer.tableFooterView = UIView()
        let appDel = UIApplication.shared.delegate as! AppDelegate
        if (appDel.fbInterstitialAd != nil) && appDel.fbInterstitialAd.isAdValid && appDel.toShowInterstitial {
            appDel.fbInterstitialAd.show(fromRootViewController: self)
            appDel.fbInterstitialAd = nil
            appDel.fbInterstitialAd = appDel.loadInterstitialFbAd()
            appDel.toShowInterstitial = false
            appDel.runTimer()
        }
        hitAPI()
        tblPlayer.registerMultiple(nibs: [TeamHeaderCell.className,TeamCell.className])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    override func searchTapped(){
        UIView.animate(withDuration: 0.5, animations: {
            if self.searchBarHeightConstraint.constant == 0.0{
                self.searchBarHeightConstraint.constant = 56.0
            }else{
                self.searchBarHeightConstraint.constant = 0.0
            }
            self.view.layoutIfNeeded()
        })
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
    
    private func getPlayerData(searchKey:String){
        var paramDict = [String:Any]()
        //paramDict["pageNo"] = "1"
        //paramDict["limit"] = "9999"
        paramDict["search"] = searchKey
        CLGUserService().newsServiceV3(url: NewBaseUrlV3+CLGRecentClass.trendingPlayer, method: .get, showLoader: 2, header: header, parameters: paramDict).then(execute: { (data) -> Void in
            if data.statusCode == 1{
                let currentDate = Date().toMillis()
                let playerData =  try! JSONSerialization.data(withJSONObject: data.toJSON(), options: [])
                let jsonData = String(data:playerData, encoding:.utf8)!
                var context:NSManagedObjectContext!
                if searchKey == ""{
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
                        apiDataObj.playerApiData = jsonData
                    }
                    else
                    {
                        for item in items
                        {
                            item.playerApiData = jsonData
                        }
                    }
                    try context.save()
                    
                } catch {
                }
            }
                self.reloadBtn.isHidden = true
                UserDefault.saveToUserDefault(value: currentDate as AnyObject, key: "PlayerDate")
//                if let responseData = data.responseData, let result = responseData.result,let player = result.player{
//                    self.findSectionTitle(data:player)
//                    self.playerData.append(contentsOf: player)
//                }
                 self.nameSectionTitles.removeAll()
                self.nameDictionary.removeAll()
                if let responseData = data.responseData{
                    if let players = responseData.plrs{
                        
                        self.findSectionTitle(data:players)
                        self.playerData.append(contentsOf: players)
                        self.playerPath = responseData.pP ?? ""
                    }
                }
            }
            //self.interstitialAds = self.createAndLoadInterstitial()
            //self.ShowAd()
            self.lblNoResultFound.isHidden = self.playerData.count == 0 ? false : true
            self.tblPlayer.reloadData()
        }).catch { (error) in
            print(error)
            if self.playerData.count == 0
            {
                self.reloadBtn.isHidden = false
            }
        }
    }
    @IBAction func reloadBtnAction(_ sender: Any) {
        hitAPI()
    }
    //MARK:- Hit API
    
    private func hitAPI()
    {
        var playerDate = Double()
        if let newPlayerDate  = UserDefault.userDefaultForAny(key: "PlayerDate") as? Double
        {
            playerDate = newPlayerDate
        }
        
        if let player = AppHelper.appDelegate().apiInfo.trend_plr{
            if let matchDate = AppHelper.stringToGmtDate(strDate: player, format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
            {
                if Double(playerDate) > matchDate.timeIntervalSince1970*1000
                {
                    var PlayerData = [String:AnyObject]()
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
                            string = (item.value(forKey: "playerApiData") as? String)!
                        }
                    } catch
                    {
                        print(error.localizedDescription)
                    }
                    if let data = string.data(using: .utf8)
                    {
                        do
                        {
                            PlayerData = try (JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject])!
                        }
                        catch
                        {
                            print(error.localizedDescription)
                        }
                    }
                    let playerModel = Mapper<HomeApiResponseV3>().map(JSON: PlayerData)
//                    if let responseData = playerModel?.responseData, let result = responseData.result,let player = result.player{
//                        self.findSectionTitle(data:player)
//                        self.playerData.append(contentsOf: player)
//                    }
                     self.nameSectionTitles.removeAll()
                    self.nameDictionary.removeAll()
                    if let responseData = playerModel?.responseData{
                        if let players = responseData.plrs{
                            self.findSectionTitle(data:players)
                            self.playerData.append(contentsOf: players)
                            self.playerPath = responseData.pP ?? ""
                        }
                    }
                    //self.interstitialAds = createAndLoadInterstitial()
                    //self.ShowAd()
                    self.lblNoResultFound.isHidden = self.playerData.count == 0 ? false : true

                    self.tblPlayer.reloadData()
                    return
                }
            }
        }
        getPlayerData(searchKey: "")
    }
    
    internal func findSectionTitle(data:[CLGTeamNameModel]){
        for item in data{
            let nameKey = String(item.name!.prefix(1)).uppercased()
            if var nameValues = self.nameDictionary[nameKey]{
                nameValues.append(item)
                self.nameDictionary[nameKey] = nameValues
            }else{
                self.nameDictionary[nameKey] = [item]
            }
        }
        
        ////self.nameSectionTitles = [String](self.nameDictionary.keys)
       // self.nameSectionTitles = self.nameSectionTitles.sorted(by: { $0 < $1 })
        //self.lblNoResultFound.isHidden = self.nameSectionTitles.count == 0 ? false : true
        self.lblNoResultFound.isHidden = self.playerData.count == 0 ? false : true
        self.tblPlayer.reloadData()
    }
}

extension BrowsePlayerVC:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int{
        
        return 1//self.nameSectionTitles.count
    }
    
    /*func sectionIndexTitles(for tableView: UITableView) -> [String]?{
        return self.nameSectionTitles
    }*/
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return getHeaderCell(tableView: tableView,section:section)
    }
    
    private func getHeaderCell(tableView : UITableView, section:Int) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TeamHeaderCell.className) as? TeamHeaderCell else {
            fatalError("unexpectedIndexPath")
        }
        cell.setHeaderName(name: "Trending Players")
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        /*let nameKey = self.nameSectionTitles[section]
        if let nameValues = self.nameDictionary[nameKey]{
            return nameValues.count
        }
        return 0*/
        return self.playerData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        return getTeamCell(indexPath, tableView: tableView)
    }
    
    private func getTeamCell( _ indexPath : IndexPath, tableView : UITableView) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TeamCell.className, for: indexPath) as? TeamCell else {
            fatalError("unexpectedIndexPath")
        }
        /*let nameKey = self.nameSectionTitles[indexPath.section]
        if let nameValues = self.nameDictionary[nameKey]{
            cell.setCellData(data: nameValues[indexPath.row], teamspath: self.playerPath, classType: "Player")
        }*/
        cell.setCellData(data: self.playerData[indexPath.row], teamspath: self.playerPath, classType: "Player")
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 35.0
        }
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.playerSearchBar.resignFirstResponder()
        /*let nameKey = self.nameSectionTitles[indexPath.section]
        if let nameValues = self.nameDictionary[nameKey]{
            if let name = nameValues[indexPath.row].name{
                if let key = nameValues[indexPath.row].key{
                    let playerDetailVC = self.storyboard?.instantiateViewController(withIdentifier: PlayerDetailVC.className) as! PlayerDetailVC
                    playerDetailVC.getTeamIdFromPrevClassScoreCard(key:key , navTitle: name)
                    self.navigationController?.pushViewController(playerDetailVC, animated: true)
                    tableView.deselectRow(at: indexPath, animated: true)
                }
            }
        }*/
            if let name = self.playerData[indexPath.row].name{
                if let key = self.playerData[indexPath.row].key{
                    let playerDetailVC = self.storyboard?.instantiateViewController(withIdentifier: PlayerDetailVC.className) as! PlayerDetailVC
                    playerDetailVC.getTeamIdFromPrevClassScoreCard(key:key , navTitle: name)
                    self.navigationController?.pushViewController(playerDetailVC, animated: true)
                    tableView.deselectRow(at: indexPath, animated: true)
                }
            }
        
    }
}

extension BrowsePlayerVC : UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        //self.nameSectionTitles.removeAll()
        //self.nameDictionary.removeAll()
        if searchText == ""{
            self.hitAPI()
            self.playerSearchBar.resignFirstResponder()
            //self.findSectionTitle(data: playerData)
        }
        else{
            /*let array = playerData.filter{
                let dictionary = $0
                if let name = dictionary.name?.lowercased(){
                    return name.contains(searchText.lowercased())
                }
                return false
            }
            self.findSectionTitle(data: array)*/
            self.getPlayerData(searchKey: searchText)
            self.playerSearchBar.becomeFirstResponder()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        self.playerSearchBar.resignFirstResponder()
    }
}

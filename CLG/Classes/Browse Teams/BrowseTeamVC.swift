//
//  BrowseTeamVC.swift
//  CLG
//
//  Created by Brainmobi on 30/07/18.
//  Copyright © 2018 Anuj Naruka. All rights reserved.
//

import UIKit
import GoogleMobileAds
import CoreData
import ObjectMapper

class BrowseTeamVC: BaseViewController,GADBannerViewDelegate,GADInterstitialDelegate {

    //MARK:- Properties
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var interstitialAds: GADInterstitial!
    private var teamData = [CLGTeamNameModel]()
    private var filterData = [CLGTeamNameModel]()
    var teamsPath =  String()
    var bannerAdView: FBAdView!
    //MARK:- IBOutlets
    @IBOutlet weak var reloadBtn: UIButton!
    @IBOutlet weak var teamSearchBar: UISearchBar!
    @IBOutlet weak var lblNoResultFound: UILabel!
    @IBOutlet weak var tblTeam: UITableView!
    @IBOutlet weak var gadBannerView: GADBannerView!
    @IBOutlet weak var bannerHeight: NSLayoutConstraint!
    @IBOutlet weak var searchBarHeightConstraint: NSLayoutConstraint!
    
    //MARK:- View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadFbBannerAd()
        teamSearchBar.textColor = UIColor.white
        searchBarHeightConstraint.constant = 0.0
        self.setupNavigationBarTitle("BROWSE TEAM", navBG: "", leftBarButtonsType: [.back], rightBarButtonsType: [.search])
        self.tblTeam.tableFooterView = UIView()
        let appDel = UIApplication.shared.delegate as! AppDelegate
        if (appDel.fbInterstitialAd != nil) && appDel.fbInterstitialAd.isAdValid && appDel.toShowInterstitial {
            appDel.fbInterstitialAd.show(fromRootViewController: self)
            appDel.fbInterstitialAd = nil
            appDel.fbInterstitialAd = appDel.loadInterstitialFbAd()
            appDel.toShowInterstitial = false
            appDel.runTimer()
        }
        hitAPI()
        tblTeam.registerMultiple(nibs: [TeamHeaderCell.className,TeamCell.className])
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
    
    private func getTeamData(searchKey:String){
        var paramDict = [String:Any]()
        //paramDict["pageNo"] = "1"
        //paramDict["limit"] = "1000"
        paramDict["search"] = searchKey
        CLGUserService().newsServiceV3(url: NewBaseUrlV3+CLGRecentClass.teamTrendingApp, method: .get, showLoader: 2, header: header, parameters: paramDict).then(execute: { (data) -> Void in
            if data.statusCode == 1{
                let currentDate = Date().toMillis()
                let teamData =  try! JSONSerialization.data(withJSONObject: data.toJSON(), options: [])
                let jsonData = String(data:teamData, encoding:.utf8)!
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
                        apiDataObj.teamApiData = jsonData
                    }
                    else
                    {
                        for item in items
                        {
                            item.teamApiData = jsonData
                        }
                    }
                    try context.save()
                    
                } catch {
                }
            }
                self.reloadBtn.isHidden = true
                UserDefault.saveToUserDefault(value: currentDate as AnyObject, key: "TeamDate")
//                if let responseData = data.responseData, let result = responseData.result,let team = result.team{
//                        self.teamData.append(contentsOf: team)
//                        self.filterData = self.teamData
//                    }
                if let responseData = data.responseData{
                    if let team = responseData.team{
                        self.teamData.removeAll()
                        self.teamData.append(contentsOf: team)
                        self.filterData = self.teamData
                        self.teamsPath = responseData.teamsPath ?? ""
                    }
                }
            }
            //self.interstitialAds = self.createAndLoadInterstitial()
            //self.ShowAd()
            self.lblNoResultFound.isHidden = self.filterData.count == 0 ? false : true
            self.tblTeam.reloadData()
        }).catch { (error) in
            print(error)
            if self.teamData.count == 0
            {
            self.reloadBtn.isHidden = false
            }
        }
    }
    
    //MARK:- Hit API
    @IBAction func reloadBtnAction(_ sender: Any) {
        hitAPI()
    }
    private func hitAPI()
    {
        var teamDate = Double()
        if let newTeamDate  = UserDefault.userDefaultForAny(key: "TeamDate") as? Double
        {
            teamDate = newTeamDate
        }
        
        if let team = AppHelper.appDelegate().apiInfo.trend_team{
            if let matchDate = AppHelper.stringToGmtDate(strDate: team, format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
            {
                if Double(teamDate) > matchDate.timeIntervalSince1970*1000
                {
                    var TeamData = [String:AnyObject]()
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
                            string = (item.value(forKey: "teamApiData") as? String)!
                        }
                    } catch
                    {
                        print(error.localizedDescription)
                    }
                    if let data = string.data(using: .utf8)
                    {
                        do
                        {
                            TeamData = try (JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject])!
                        }
                        catch
                        {
                            print(error.localizedDescription)
                        }
                    }
                    let teamModel = Mapper<HomeApiResponseV3>().map(JSON: TeamData)
//                    if let responseData = teamModel?.responseData, let result = responseData.result,let team = result.team{
//                        self.teamData.append(contentsOf: team)
//                        self.filterData = self.teamData
//                    }
                    if let responseData = teamModel?.responseData{
                        if let team = responseData.team{
                            self.teamData.removeAll()
                            self.teamData.append(contentsOf: team)
                            self.filterData = self.teamData
                            self.teamsPath = responseData.teamsPath ?? ""
                        }
                    }
                    
                    self.lblNoResultFound.isHidden = self.filterData.count == 0 ? false : true
                    self.tblTeam.reloadData()
                    //self.interstitialAds = createAndLoadInterstitial()
                    //self.ShowAd()
                    return
                }
            }
        }
        getTeamData(searchKey: "")
    }
}

extension BrowseTeamVC:UITableViewDataSource,UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.filterData.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return getHeaderCell(tableView: tableView,section:section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        return getTeamCell(indexPath, tableView: tableView)
    }
    
    private func getHeaderCell(tableView : UITableView, section:Int) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TeamHeaderCell.className) as? TeamHeaderCell else {
            fatalError("unexpectedIndexPath")
        }
        cell.setHeaderName(name: "Team Listing")
        cell.selectionStyle = .none
        return cell
    }
    
    private func getTeamCell( _ indexPath : IndexPath, tableView : UITableView) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TeamCell.className, for: indexPath) as? TeamCell else {
            fatalError("unexpectedIndexPath")
        }
        cell.setCellData(data: self.filterData[indexPath.row],teamspath:self.teamsPath, classType: "Team")
        cell.selectionStyle = .none
        return cell
    }    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.teamSearchBar.resignFirstResponder()
        if let board_team_key = self.filterData[indexPath.row].key{
            if let name = self.filterData[indexPath.row].name{
                let teamMatchVC = self.storyboard?.instantiateViewController(withIdentifier: TeamMatchVC.className) as! TeamMatchVC
                teamMatchVC.getTeamIdFromPrevClass(id:board_team_key,navTitle:name)
                self.navigationController?.pushViewController(teamMatchVC, animated: true)
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }
}

extension BrowseTeamVC : UISearchBarDelegate
{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String)
    {
        if searchText == ""{
           // filterData = teamData
            hitAPI()
            self.teamSearchBar.resignFirstResponder()
        }else{
            /*filterData = teamData.filter({ (data) -> Bool in
                if let name = data.name?.lowercased(){
                    return name.contains(searchText.lowercased())
                }
                return false
            })*/
            self.getTeamData(searchKey: searchText)
            self.teamSearchBar.becomeFirstResponder()
        }
        //self.lblNoResultFound.isHidden = self.filterData.count == 0 ? false : true
        /*if self.filterData.count == 0{
            self.lblNoResultFound.isHidden = false
            self.getTeamData(searchKey: searchText)
        }
        else{
            self.lblNoResultFound.isHidden = true
        }*/
        //tblTeam.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
    {
        self.teamSearchBar.resignFirstResponder()
        
    }
    
}

//
//  LiveMatchesVC.swift
//  CLG
//
//  Created by Sani Kumar on 19/08/19.
//  Copyright © 2019 Anuj Naruka. All rights reserved.
//

import UIKit
import GoogleMobileAds


class LiveMatchesVC: BaseViewController {
    
    //MARK: IBOutlets
    @IBOutlet weak var reloadBtn: UIButton!
    @IBOutlet weak var tableLive:UITableView!
    @IBOutlet weak var LblNoMatch: UILabel!
    @IBOutlet weak var gadBannerView: GADBannerView!
    @IBOutlet weak var bannerHeight: NSLayoutConstraint!
    @IBOutlet weak var viewNoMatch: UIView!
    
    
    //MARK: Variables and Constants
    var nativeAds = [GADUnifiedNativeAd]()
    var tempFirebaseArray = [CLGFirbaseArrModel]()
    var interval = 5
    var fbPath = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefault.userDefaultForKey(key: "FbBasePath") != nil{
            self.fbPath = UserDefault.userDefaultForKey(key: "FbBasePath")
        }
        else{
            self.fbPath = ""
        }
        refreshTableViewAgain()
//        showGoogleAds()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupNavigationBarTitle("LIVE MATCHES", navBG: "", leftBarButtonsType: [], rightBarButtonsType: [])
        self.navigationController?.navigationBar.isHidden = false
 
        AppHelper.appDelegate().childRemovedConfigure()
        /*let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(self.refreshTableView),
                                       name: .refreshLiveView,
                                       object: nil)*/
        
        /*let notificationCenterr = NotificationCenter.default
        notificationCenterr.addObserver(self,
                                       selector: #selector(self.refreshTableViewAgain),
                                       name: .refreshLiveViewAgain,
                                       object: nil)*/
        let notificationCenterr = NotificationCenter.default
        notificationCenterr.addObserver(self,
                                        selector: #selector(self.refreshTableViewAgain),
                                        name: .refreshLiveViewAgain,
                                        object: nil)
//        FireBaseHomeObservers().removeLiveObservers(ref:AppHelper.appDelegate().ref)
//        FireBaseHomeObservers().setLiveScreenObserver(ref:AppHelper.appDelegate().ref)
        if AppHelper.appDelegate().ref != nil{
            FireBaseHomeObservers().removeObservers(ref:AppHelper.appDelegate().ref)
            FireBaseHomeObservers().setHomeScreenObserver(ref:AppHelper.appDelegate().ref)
        }
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //FireBaseHomeObservers().removeLiveObservers(ref:AppHelper.appDelegate().ref)
        //FireBaseHomeObservers().removeObservers(ref:AppHelper.appDelegate().ref)
        print("LiveTabbar index = ", self.tabBarController?.selectedIndex ?? 6)

    }
    
    //MARK:-Functions
    private func showGoogleAds()
    {
//        self.gadBannerView.adUnitID = AppHelper.appDelegate().adBannerUnitID as String
//        self.gadBannerView.rootViewController = self
        //self.gadBannerView.load(GADRequest())
        self.gadBannerView.delegate = self
    
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadBannerAd()
    }
    //MARK:-Func
    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to:size, with:coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.loadBannerAd()
        })
    }
    func loadBannerAd() {
        let frame = { () -> CGRect in
            if #available(iOS 11.0, *) {
                return UIEdgeInsetsInsetRect(view.bounds , view.safeAreaInsets)
            } else {
                return view.frame
            }
        }()
        let viewWidth = frame.size.width
        
//        gadBannerView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
//        gadBannerView.load(GADRequest())
    }
    @objc public func refreshTableViewAgain(){
//        if let liveline = AppHelper.userDefaultsForKey(key: "LiveLine") as? String, liveline != nil{
//            if liveline == "1"{
//                AppHelper.saveToUserDefaults(value: "0" as AnyObject, withKey: "LiveLine")
//                AppHelper.appDelegate().firebaseConfigMethod()
//            }
            //else{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
                    self.refreshLiveTable()
                })
            //}
        //}
        
    }
    
    /*@objc public func refreshTableView()
    {
        /*tempFirebaseArray.removeAll()
        if fireBaseGlobalModel.count == 0
        {
            self.LblNoMatch.text = "No Live Matches Available"
            self.viewNoMatch.isHidden = false
            //self.LblNoMatch.isHidden = false
        }
        else
        {
            for dict in fireBaseGlobalModel{
                if dict.con?.mstus == "L"{
                    tempFirebaseArray.append(dict)
                }
            }
            if tempFirebaseArray.count > 0{
                tempFirebaseArray = tempFirebaseArray.sorted(by: {Int($0.ao!)! < Int($1.ao!)!})
            }
            self.viewNoMatch.isHidden = true
            //self.LblNoMatch.isHidden = true
            
            if tempFirebaseArray.count == 0
            {
                self.LblNoMatch.text = "No Live Matches Available"
                self.viewNoMatch.isHidden = false
                //self.LblNoMatch.isHidden = false
            }
            else
            {
                self.viewNoMatch.isHidden = true
            }

        }
        tableLive.reloadData()
        AppHelper.hideHud()*/
        tableLive.reloadData()
        if fireBaseGlobalModelLive.count == 0
        {
            self.LblNoMatch.text = "No Live Matches Available"
            self.viewNoMatch.isHidden = false
        }
        else
        {
            self.viewNoMatch.isHidden = true
        }
        AppHelper.hideHud()
    }*/
    
    @objc func refreshLiveTable(){
        tempFirebaseArray.removeAll()
        if fireBaseGlobalModelNew.count == 0
        {
            self.LblNoMatch.text = "No Live Matches Available"
            self.viewNoMatch.isHidden = false
            //self.LblNoMatch.isHidden = false
        }
        else
        {
            for dict in fireBaseGlobalModelNew{
                if let ostus = dict.con?.ostus {
                    if ostus.isEmpty{
                        if (dict.con?.mstus == "L") && (!(dict.t1?.f?.contains("Testing") ?? true) && !(dict.t2?.f?.contains("Testing") ?? true)){
                            self.tempFirebaseArray.append(dict)
                        }
                    }
                    else{
                        
                    }
                }
                else{
                    if (dict.con?.mstus == "L") && (!(dict.t1?.f?.contains("Testing") ?? true) && !(dict.t2?.f?.contains("Testing") ?? true)){
                        self.tempFirebaseArray.append(dict)
                    }
                }
            }
            if tempFirebaseArray.count > 0{
                tempFirebaseArray = tempFirebaseArray.sorted(by: {Int($0.ao!)! < Int($1.ao!)!})
                self.viewNoMatch.isHidden = true
            }
            else{
                self.LblNoMatch.text = "No Live Matches Available"
                self.viewNoMatch.isHidden = false
            }
            /*self.viewNoMatch.isHidden = true
            //self.LblNoMatch.isHidden = true
            
            if tempFirebaseArray.count == 0
            {
                self.LblNoMatch.text = "No Live Matches Available"
                self.viewNoMatch.isHidden = false
                //self.LblNoMatch.isHidden = false
            }
            else
            {
                self.viewNoMatch.isHidden = true
            }*/
        }
        
        if let tabItems = self.tabBarController?.tabBar.items {
            // In this case we want to modify the badge number of the third tab:
            let tabItem = tabItems[1]
            if tempFirebaseArray.count > 0{
                tabItem.badgeValue = "\(tempFirebaseArray.count)"
            }
            else{
                tabItem.badgeValue = nil
            }
        }
        tableLive.reloadData()
        AppHelper.hideHud()
        /*tempFirebaseArray.removeAll()
        fireBaseGlobalModelLive.removeAll()
        if fireBaseGlobalModel.count == 0
        {
            self.LblNoMatch.text = "No Live Matches Available"
            self.viewNoMatch.isHidden = false
            //self.LblNoMatch.isHidden = false
        }
        else
        {
            for dict in fireBaseGlobalModel{
                if dict.con?.mstus == "L"{
                    tempFirebaseArray.append(dict)
                    fireBaseGlobalModelLive.append(dict)
                }
            }
            if tempFirebaseArray.count > 0{
                tempFirebaseArray = tempFirebaseArray.sorted(by: {Int($0.ao!)! < Int($1.ao!)!})
            }
            self.viewNoMatch.isHidden = true
            //self.LblNoMatch.isHidden = true
            
            if tempFirebaseArray.count == 0
            {
                self.LblNoMatch.text = "No Live Matches Available"
                self.viewNoMatch.isHidden = false
                //self.LblNoMatch.isHidden = false
            }
            else
            {
                self.viewNoMatch.isHidden = true
            }
            
        }
        tableLive.reloadData()
        AppHelper.hideHud()*/
    }
//    func reload(tableView: UITableView) {
//
//        let contentOffset = tableView.contentOffset
//        tableView.reloadData()
//        tableView.layoutIfNeeded()
//        tableView.setContentOffset(contentOffset, animated: false)
//
//    }
    @objc func showNativeAd(){
        nativeAds = AppHelper.appDelegate().returnNativeAdArray()
    }

    //MARK: IBActions
    @IBAction func reloadBtnAction(_ sender: Any){
        
    }
}

//MARK: TableView Delegates and Datasource
extension LiveMatchesVC:UITableViewDelegate{
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath)
    {
        if indexPath.row % interval != 0
        {
            if let cell = tableView.cellForRow(at: indexPath) as? LiveMatchCell
            {
                cell.MainView.backgroundColor = UIColor.gray
            }
        }
        else
        {
            if let cell = tableView.cellForRow(at: indexPath) as? LiveMatchAdCell
            {
                cell.MainView.backgroundColor = UIColor.gray
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        
        if indexPath.row % interval != 0
        {
            if let cell = tableView.cellForRow(at: indexPath) as? LiveMatchCell{
                UIView.animate(withDuration: 0.3, animations: {
                    cell.MainView.backgroundColor = UIColor.white
                }) { (true) in
                }
            }
        }
        else
        {
            if let cell = tableView.cellForRow(at: indexPath) as? LiveMatchAdCell{
                UIView.animate(withDuration: 0.3, animations: {
                    cell.MainView.backgroundColor = UIColor.white
                }) { (true) in
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let vc  = AppHelper.intialiseViewController(fromMainStoryboard: "Main", withName: "MatchLineVC") as! MatchLineVC
        //FireBaseHomeObservers().removeObservers(ref:AppHelper.appDelegate().ref)
        fireBaseGlobalModel = tempFirebaseArray
        //FireBaseHomeObservers().setHomeScreenObserver(ref:AppHelper.appDelegate().ref)
        vc.index = indexPath.row
        vc.fbPath = self.fbPath
        vc.vcType = "Live"
        self.navigationController?.pushViewController(vc, animated: true)
//        let newNav = UINavigationController(rootViewController: vc)
//        self.present(newNav, animated: true, completion:nil)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        /*if indexPath.row % interval != 0{
            return 175
        }
        else{
            if nativeAds.count == 5{
                return 350
            }
            else{
                return 175
            }
        }*/
        return UITableViewAutomaticDimension
    }
}
extension LiveMatchesVC:UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*if fireBaseGlobalModel.count != 0 && fireBaseGlobalModel.count != nil
        {
            tempFirebaseArray = fireBaseGlobalModelLive.sorted(by: {Int($0.ao!)! < Int($1.ao!)!})
            return tempFirebaseArray.count
        }
        else{
            return tempFirebaseArray.count
        }*/
        //else
        //{
            //return fireBaseGlobalModel.count
        //}
        return tempFirebaseArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //if indexPath.row % interval != 0
        //{
            let cell = tableView.dequeueReusableCell(withIdentifier: "LiveMatchCell", for: indexPath) as! LiveMatchCell
            cell.selectionStyle = .none
            setLiveMatchCell(cell: cell, index: indexPath.row)
            return cell
       // }
        /*else{
            if nativeAds.count == 5{
                let cell = tableView.dequeueReusableCell(withIdentifier: "LiveMatchAdCell", for: indexPath) as! LiveMatchAdCell
                cell.selectionStyle = .none
                if let adView = cell.contentView.subviews[1] as? GADUnifiedNativeAdView
                {
                    if tempFirebaseArray.count < 6{
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
                    else if tempFirebaseArray.count > 5 && tempFirebaseArray.count < 11{
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
                    else if tempFirebaseArray.count > 10 && tempFirebaseArray.count < 16{
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
                setLiveMatchAdCell(cell: cell, index: indexPath.row)
                return cell
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "LiveMatchCell", for: indexPath) as! LiveMatchCell
            cell.selectionStyle = .none
            setLiveMatchCell(cell: cell, index: indexPath.row)
            return cell
        }*/
    }

    private func setLiveMatchCell(cell:LiveMatchCell,index:Int){
        cell.imgViewLeftTeam.image = #imageLiteral(resourceName: "TeamPlaceholder")
        cell.imgViewRightTeam.image = #imageLiteral(resourceName: "TeamPlaceholder")
        cell.lblLeftTeamScore.font = ScreenSize.SCREEN_WIDTH == 320 ? UIFont(name: "Lato-Bold", size: 16) : UIFont(name: "Lato-Bold", size: 18)
        cell.lblRightTeamScore.font = ScreenSize.SCREEN_WIDTH == 320 ? UIFont(name: "Lato-Bold", size: 16) : UIFont(name: "Lato-Bold", size: 18)
        
        if let nkey = tempFirebaseArray[index].t1?.n, nkey != ""{
            if let confirmedImage = UIImage(named: nkey.lowercased()) {
                cell.imgViewLeftTeam.image = confirmedImage
            }
            else{
                if let t1icStr = tempFirebaseArray[index].t1?.ic, t1icStr != ""
                {
                    let fullurlstr = (self.fbPath + t1icStr).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                    cell.imgViewLeftTeam.af_setImage(withURL: URL(string: fullurlstr!+".png")!, placeholderImage: #imageLiteral(resourceName: "TeamPlaceholder"))
                    
                }
                else{
                    if let fname = tempFirebaseArray[index].t1?.f{
                        
                        cell.imgViewLeftTeam.image = AppHelper.generateImageWithText(text: fname, image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:fname.uppercased()), size: CGSize(width: 50, height: 50)))
                        
                    }
                    else{
                        
                        cell.imgViewLeftTeam.image = AppHelper.generateImageWithText(text: "N/A", image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:"N/A"), size: CGSize(width: 50, height: 50)))
                        
                    }
                }
            }
        }
        else{
            if let t1icStr = tempFirebaseArray[index].t1?.ic, t1icStr != ""
            {
                let fullurlstr = (self.fbPath + t1icStr).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                cell.imgViewLeftTeam.af_setImage(withURL: URL(string: fullurlstr!+".png")!, placeholderImage: #imageLiteral(resourceName: "TeamPlaceholder"))
                
            }
            else{
                if let fname = tempFirebaseArray[index].t1?.f{
                    
                    cell.imgViewLeftTeam.image = AppHelper.generateImageWithText(text: fname, image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:fname.uppercased()), size: CGSize(width: 50, height: 50)))
                    
                }
                else{
                    
                    cell.imgViewLeftTeam.image = AppHelper.generateImageWithText(text: "N/A", image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:"N/A"), size: CGSize(width: 50, height: 50)))
                    
                }
            }
        }
        if let nkey = tempFirebaseArray[index].t2?.n, nkey != ""{
            if let confirmedImage = UIImage(named: nkey.lowercased()) {
                cell.imgViewRightTeam.image = confirmedImage
            }
            else{
                if let t2icStr = tempFirebaseArray[index].t2?.ic, t2icStr != ""
                {
                    let fullurlstr = (self.fbPath + t2icStr).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                    cell.imgViewRightTeam.af_setImage(withURL: URL(string: fullurlstr!+".png")!, placeholderImage: #imageLiteral(resourceName: "TeamPlaceholder"))
                    
                }
                else{
                    if let fname = tempFirebaseArray[index].t2?.f{
                        
                        cell.imgViewRightTeam.image = AppHelper.generateImageWithText(text: fname, image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:fname.uppercased()), size: CGSize(width: 50, height: 50)))
                        
                    }
                    else{
                        
                        cell.imgViewRightTeam.image = AppHelper.generateImageWithText(text: "N/A", image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:"N/A"), size: CGSize(width: 50, height: 50)))
                        
                    }
                }
            }
        }
        else{
            if let t2icStr = tempFirebaseArray[index].t2?.ic, t2icStr != ""
            {
                let fullurlstr = (self.fbPath + t2icStr).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                cell.imgViewRightTeam.af_setImage(withURL: URL(string: fullurlstr!+".png")!, placeholderImage: #imageLiteral(resourceName: "TeamPlaceholder"))
                
            }
            else{
                if let fname = tempFirebaseArray[index].t2?.f{
                    
                    cell.imgViewRightTeam.image = AppHelper.generateImageWithText(text: fname, image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:fname.uppercased()), size: CGSize(width: 50, height: 50)))
                    
                }
                else{
                    
                    cell.imgViewRightTeam.image = AppHelper.generateImageWithText(text: "N/A", image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:"N/A"), size: CGSize(width: 50, height: 50)))
                    
                }
                
            }
        }
        /*if tempFirebaseArray[index].t1?.ic != "" && tempFirebaseArray[index].t1?.ic != nil
        {
            if let t1icStr = tempFirebaseArray[index].t1?.ic{
                let fullurlstr = (self.fbPath + t1icStr).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                cell.imgViewLeftTeam.af_setImage(withURL: URL(string: fullurlstr!+".png")!, placeholderImage: #imageLiteral(resourceName: "TeamPlaceholder"))
            }
            
        }
        else
        {
            if let nkey = tempFirebaseArray[index].t1?.n, nkey != ""{
                if let fname = tempFirebaseArray[index].t1?.f{
                    cell.imgViewLeftTeam.image = AppHelper.loadImage(named: nkey.lowercased(),teamName:fname)
                }
                else{
                    cell.imgViewLeftTeam.image = AppHelper.loadImage(named: nkey.lowercased(),teamName:"N/A")
                }
                
            }
            else{
                if let fname = tempFirebaseArray[index].t1?.f{
                    
                    cell.imgViewLeftTeam.image = AppHelper.generateImageWithText(text: fname, image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:fname.uppercased()), size: CGSize(width: 50, height: 50)))
                    
                }
                else{
                    
                    cell.imgViewLeftTeam.image = AppHelper.generateImageWithText(text: "N/A", image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:"N/A"), size: CGSize(width: 50, height: 50)))
                    
                }
                
            }
            //self.ImgViewLeftTeam.image = #imageLiteral(resourceName: "TeamPlaceholder")
        }
        if tempFirebaseArray[index].t2?.ic != "" && tempFirebaseArray[index].t2?.ic != nil
        {
            if let t2icStr = tempFirebaseArray[index].t2?.ic{
                let fullUrlStr = (self.fbPath+t2icStr).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                cell.imgViewRightTeam.af_setImage(withURL: URL(string: fullUrlStr!+".png")!, placeholderImage: #imageLiteral(resourceName: "TeamPlaceholder"))
            }
            
        }
        else
        {
            if let nkey = tempFirebaseArray[index].t2?.n, nkey != ""{
                if let fname = tempFirebaseArray[index].t2?.f{
                    cell.imgViewRightTeam.image = AppHelper.loadImage(named: nkey.lowercased(),teamName:fname)
                }
                else{
                    cell.imgViewRightTeam.image = AppHelper.loadImage(named: nkey.lowercased(),teamName:"N/A")
                }
                
            }
            else{
                if let fname = tempFirebaseArray[index].t2?.f{
                    
                    cell.imgViewRightTeam.image = AppHelper.generateImageWithText(text: fname, image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:fname.uppercased()), size: CGSize(width: 50, height: 50)))
                    
                }
                else{
                    
                    cell.imgViewRightTeam.image = AppHelper.generateImageWithText(text: "N/A", image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:"N/A"), size: CGSize(width: 50, height: 50)))
                    
                }
                
            }
            //self.ImgViewLeftTeam.image = #imageLiteral(resourceName: "TeamPlaceholder")
        }*/
        let dateStr = AppHelper.getMatchDateAndTime(type:1,date:tempFirebaseArray[index].con?.mtm ?? "01/10/2018 11:52")
        cell.lblGroundDetails.text = dateStr
        cell.lblMatchInfo.text = (tempFirebaseArray[index].con?.sr)!+", "+((tempFirebaseArray[index].con?.mn) ?? "")
        
        //cell.lblFavTeam.text = "Fav - " + tempFirebaseArray[index].ft!
        /*if tempFirebaseArray[index].con?.mf == "Test"
        {
            //cell.lblRateOne.text = "-"
            //cell.lblRateTwo.text = "-"
            if tempFirebaseArray[index].mkt?.r1 != "" && tempFirebaseArray[index].mkt?.r3 != "" && tempFirebaseArray[index].mkt?.r5 != ""
            {
                if (Float(tempFirebaseArray[index].mkt?.r1 ?? "") ?? 0 < Float(tempFirebaseArray[index].mkt?.r3 ?? "") ?? 0) && (Float(tempFirebaseArray[index].mkt?.r1 ?? "") ?? 0 < Float(tempFirebaseArray[index].mkt?.r5 ?? "") ?? 0){
                    cell.lblRateOne.text = tempFirebaseArray[index].mkt?.r1
                    cell.lblRateTwo.text = tempFirebaseArray[index].mkt?.r2
                    if let team1 = tempFirebaseArray[index].t1{
                        cell.lblFavTeam.text = "Fav - " + (team1.n?.firstUppercased ?? "")
                    }
                    else{
                        cell.lblFavTeam.text = "Fav - "
                    }
                }
                else if (Float(tempFirebaseArray[index].mkt?.r3 ?? "") ?? 0 < Float(tempFirebaseArray[index].mkt?.r1 ?? "") ?? 0) && (Float(tempFirebaseArray[index].mkt?.r3 ?? "") ?? 0 < Float(tempFirebaseArray[index].mkt?.r5 ?? "") ?? 0){
                    cell.lblRateOne.text = tempFirebaseArray[index].mkt?.r3
                    cell.lblRateTwo.text = tempFirebaseArray[index].mkt?.r4
                    if let team2 = tempFirebaseArray[index].t2{
                        cell.lblFavTeam.text = "Fav - " + (team2.n?.firstUppercased ?? "")
                    }
                    else{
                        cell.lblFavTeam.text = "Fav - "
                    }
                }
                else if (Float(tempFirebaseArray[index].mkt?.r3 ?? "") ?? 0 == Float(tempFirebaseArray[index].mkt?.r1 ?? "") ?? 0) && (Float(tempFirebaseArray[index].mkt?.r3 ?? "") ?? 0 < Float(tempFirebaseArray[index].mkt?.r5 ?? "") ?? 0){
                    cell.lblRateOne.text = tempFirebaseArray[index].mkt?.r1
                    cell.lblRateTwo.text = tempFirebaseArray[index].mkt?.r2
                    if let team1 = tempFirebaseArray[index].t1{
                        cell.lblFavTeam.text = "Fav - " + (team1.n?.firstUppercased ?? "")
                    }
                    else{
                        cell.lblFavTeam.text = "Fav - "
                    }
                }
                else if (Float(tempFirebaseArray[index].mkt?.r3 ?? "") ?? 0 == Float(tempFirebaseArray[index].mkt?.r5 ?? "") ?? 0) && (Float(tempFirebaseArray[index].mkt?.r3 ?? "") ?? 0 < Float(tempFirebaseArray[index].mkt?.r1 ?? "") ?? 0){
                    cell.lblRateOne.text = tempFirebaseArray[index].mkt?.r3
                    cell.lblRateTwo.text = tempFirebaseArray[index].mkt?.r4
                    if let team2 = tempFirebaseArray[index].t2{
                        cell.lblFavTeam.text = "Fav - " + (team2.n?.firstUppercased ?? "")
                    }
                    else{
                        cell.lblFavTeam.text = "Fav - "
                    }
                }
                else if (Float(tempFirebaseArray[index].mkt?.r1 ?? "") ?? 0 == Float(tempFirebaseArray[index].mkt?.r5 ?? "") ?? 0) && (Float(tempFirebaseArray[index].mkt?.r1 ?? "") ?? 0 < Float(tempFirebaseArray[index].mkt?.r3 ?? "") ?? 0){
                    cell.lblRateOne.text = tempFirebaseArray[index].mkt?.r1
                    cell.lblRateTwo.text = tempFirebaseArray[index].mkt?.r2
                    if let team1 = tempFirebaseArray[index].t1{
                        cell.lblFavTeam.text = "Fav - " + (team1.n?.firstUppercased ?? "")
                    }
                    else{
                        cell.lblFavTeam.text = "Fav - "
                    }
                }
                else if (Float(tempFirebaseArray[index].mkt?.r1 ?? "") ?? 0 == Float(tempFirebaseArray[index].mkt?.r3 ?? "") ?? 0) && (Float(tempFirebaseArray[index].mkt?.r1 ?? "") ?? 0 == Float(tempFirebaseArray[index].mkt?.r5 ?? "") ?? 0){
                    cell.lblRateOne.text = tempFirebaseArray[index].mkt?.r1
                    cell.lblRateTwo.text = tempFirebaseArray[index].mkt?.r2
                    if let team1 = tempFirebaseArray[index].t1{
                        cell.lblFavTeam.text = "Fav - " + (team1.n?.firstUppercased ?? "")
                    }
                    else{
                        cell.lblFavTeam.text = "Fav - "
                    }
                }
                else{
                    cell.lblRateOne.text = tempFirebaseArray[index].mkt?.r5
                    cell.lblRateTwo.text = tempFirebaseArray[index].mkt?.r6
                    cell.lblFavTeam.text = "Fav - " + "Draw"
                }
            }
            else{
                cell.lblRateOne.text = "-"
                cell.lblRateTwo.text = "-"
                if let favTeam = tempFirebaseArray[index].ft{
                    cell.lblFavTeam.text = "Fav - " + favTeam.firstUppercased
                }
                else{
                    cell.lblFavTeam.text = "Fav - "
                }
            }

        }
        else
        {
            if let favTeam = tempFirebaseArray[index].ft{
                cell.lblFavTeam.text = "Fav - " + favTeam.firstUppercased
            }
            else{
                cell.lblFavTeam.text = "Fav - "
            }
            cell.lblRateOne.text = tempFirebaseArray[index].mkt?.r1 == "" ? "-" : tempFirebaseArray[index].mkt?.r1
            cell.lblRateTwo.text = tempFirebaseArray[index].mkt?.r2 == "" ? "-" : tempFirebaseArray[index].mkt?.r2
        }*/
        if tempFirebaseArray[index].con?.mf == "Test"
        {
            //cell.lblRateOne.text = "-"
            //cell.lblRateTwo.text = "-"
            if let rt = tempFirebaseArray[index].rt, rt != ""{
                let rtArray = rt.components(separatedBy: ",")
                
                if rtArray[0] != "" && rtArray[2] != "" && rtArray[4] != ""
                {
                    if (Float(rtArray[0] ) ?? 0 < Float(rtArray[2]) ?? 0) && (Float(rtArray[0] ) ?? 0 < Float(rtArray[4] ) ?? 0){
                        cell.lblRateOne.text = rtArray[0]
                        cell.lblRateTwo.text = rtArray[1]
                        if let team1 = tempFirebaseArray[index].t1{
                            cell.lblFavTeam.text = "Fav - " + (team1.n?.firstUppercased ?? "")
                        }
                        else{
                            cell.lblFavTeam.text = "Fav - "
                        }
                    }
                    else if (Float(rtArray[2]) ?? 0 < Float(rtArray[0]) ?? 0) && (Float(rtArray[2]) ?? 0 < Float(rtArray[4]) ?? 0){
                        cell.lblRateOne.text = rtArray[2]
                        cell.lblRateTwo.text = rtArray[3]
                        if let team2 = tempFirebaseArray[index].t2{
                            cell.lblFavTeam.text = "Fav - " + (team2.n?.firstUppercased ?? "")
                        }
                        else{
                            cell.lblFavTeam.text = "Fav - "
                        }
                    }
                    else if (Float(rtArray[2]) ?? 0 == Float(rtArray[0]) ?? 0) && (Float(rtArray[2]) ?? 0 < Float(rtArray[4]) ?? 0){
                        cell.lblRateOne.text = rtArray[0]
                        cell.lblRateTwo.text = rtArray[1]
                        if let team1 = tempFirebaseArray[index].t1{
                            cell.lblFavTeam.text = "Fav - " + (team1.n?.firstUppercased ?? "")
                        }
                        else{
                            cell.lblFavTeam.text = "Fav - "
                        }
                    }
                    else if (Float(rtArray[2]) ?? 0 == Float(rtArray[4]) ?? 0) && (Float(rtArray[2]) ?? 0 < Float(rtArray[0]) ?? 0){
                        cell.lblRateOne.text = rtArray[2]
                        cell.lblRateTwo.text = rtArray[3]
                        if let team2 = tempFirebaseArray[index].t2{
                            cell.lblFavTeam.text = "Fav - " + (team2.n?.firstUppercased ?? "")
                        }
                        else{
                            cell.lblFavTeam.text = "Fav - "
                        }
                    }
                    else if (Float(rtArray[0]) ?? 0 == Float(rtArray[4]) ?? 0) && (Float(rtArray[0]) ?? 0 < Float(rtArray[2]) ?? 0){
                        cell.lblRateOne.text = rtArray[0]
                        cell.lblRateTwo.text = rtArray[1]
                        if let team1 = tempFirebaseArray[index].t1{
                            cell.lblFavTeam.text = "Fav - " + (team1.n?.firstUppercased ?? "")
                        }
                        else{
                            cell.lblFavTeam.text = "Fav - "
                        }
                    }
                    else if (Float(rtArray[0]) ?? 0 == Float(rtArray[2]) ?? 0) && (Float(rtArray[0]) ?? 0 == Float(rtArray[4]) ?? 0){
                        cell.lblRateOne.text = rtArray[0]
                        cell.lblRateTwo.text = rtArray[1]
                        if let team1 = tempFirebaseArray[index].t1{
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
            if let rt = tempFirebaseArray[index].rt, rt != ""{
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
        cell.lblLeftTeam.text = tempFirebaseArray[index].t1?.n?.firstUppercased
        cell.lblRightTeam.text = tempFirebaseArray[index].t2?.n?.firstUppercased
        if tempFirebaseArray[index].con?.mstus == "U"
        {
            cell.lblLeftTeamScore.text = ""
            cell.lblLeftTeamOver.text = ""
            cell.lblRightTeamScore.text = ""
            cell.lblRightTeamOver.text = ""
        }
        else
        {
            if tempFirebaseArray[index].con?.mf == "Test" {
                cell.lblLeftTeamScore.text = (tempFirebaseArray[index].i1?.sc)!+"/"+(tempFirebaseArray[index].i1?.wk)!
                cell.lblLeftTeamOver.text = (tempFirebaseArray[index].i1?.ov)! + " Over"
                if tempFirebaseArray[index].i2?.ov != "0" || tempFirebaseArray[index].i2?.sc != "0" || tempFirebaseArray[index].i2?.wk != "0"
                {
                    cell.lblRightTeamScore.text = (tempFirebaseArray[index].i2?.sc)!+"/"+(tempFirebaseArray[index].i2?.wk)!
                    cell.lblRightTeamOver.text = (tempFirebaseArray[index].i2?.ov)! + " Over"
                }
                else
                {
                    cell.lblRightTeamScore.text = ""
                    cell.lblRightTeamOver.text = ""
                }
                if tempFirebaseArray[index].i3?.ov != "0" || tempFirebaseArray[index].i3?.sc != "0" || tempFirebaseArray[index].i3?.wk != "0"
                {
//                    if tempFirebaseArray[index].i3?.bt == tempFirebaseArray[index].i2?.bt
//                    {
//                        cell.lblRightTeamScore.text = (tempFirebaseArray[index].i2?.sc)!+"/"+(tempFirebaseArray[index].i2?.wk)!+",\n"+(tempFirebaseArray[index].i3?.sc)!+"/"+(tempFirebaseArray[index].i3?.wk)!
//                        cell.lblRightTeamOver.text = (tempFirebaseArray[index].i3?.ov)!+" Over"
//                    }
                    if tempFirebaseArray[index].i3b == "t2"
                    {
                        cell.lblRightTeamScore.text = (tempFirebaseArray[index].i2?.sc)!+"/"+(tempFirebaseArray[index].i2?.wk)!+",\n"+(tempFirebaseArray[index].i3?.sc)!+"/"+(tempFirebaseArray[index].i3?.wk)!
                        cell.lblRightTeamOver.text = (tempFirebaseArray[index].i3?.ov)!+" Over"
                    }
                    else
                    {
                        cell.lblLeftTeamScore.text = (tempFirebaseArray[index].i1?.sc)!+"/"+(tempFirebaseArray[index].i1?.wk)!+",\n"+(tempFirebaseArray[index].i3?.sc)!+"/"+(tempFirebaseArray[index].i3?.wk)!
                        cell.lblLeftTeamOver.text = (tempFirebaseArray[index].i3?.ov)!+" Over"
                    }
                }
                if tempFirebaseArray[index].i4?.ov != "0" || tempFirebaseArray[index].i4?.sc != "0" || tempFirebaseArray[index].i4?.wk != "0"
                {
//                    if tempFirebaseArray[index].i3?.bt == tempFirebaseArray[index].i2?.bt
//                    {
//                        cell.lblRightTeamScore.text = (tempFirebaseArray[index].i2?.sc)!+"/"+(tempFirebaseArray[index].i2?.wk)!+",\n"+(tempFirebaseArray[index].i3?.sc)!+"/"+(tempFirebaseArray[index].i3?.wk)!
//                        cell.lblRightTeamOver.text = (tempFirebaseArray[index].i3?.ov)!+" Over"
//                        cell.lblLeftTeamScore.text = (tempFirebaseArray[index].i1?.sc)!+"/"+(tempFirebaseArray[index].i1?.wk)!+",\n"+(tempFirebaseArray[index].i4?.sc)!+"/"+(tempFirebaseArray[index].i4?.wk)!
//                        cell.lblLeftTeamOver.text = (tempFirebaseArray[index].i4?.ov)!+" Over"
//
//                    }
                    if tempFirebaseArray[index].i3b == "t2"
                    {
                        cell.lblRightTeamScore.text = (tempFirebaseArray[index].i2?.sc)!+"/"+(tempFirebaseArray[index].i2?.wk)!+",\n"+(tempFirebaseArray[index].i3?.sc)!+"/"+(tempFirebaseArray[index].i3?.wk)!
                        cell.lblRightTeamOver.text = (tempFirebaseArray[index].i3?.ov)!+" Over"
                        cell.lblLeftTeamScore.text = (tempFirebaseArray[index].i1?.sc)!+"/"+(tempFirebaseArray[index].i1?.wk)!+",\n"+(tempFirebaseArray[index].i4?.sc)!+"/"+(tempFirebaseArray[index].i4?.wk)!
                        cell.lblLeftTeamOver.text = (tempFirebaseArray[index].i4?.ov)!+" Over"
                        
                    }
                    else
                    {
                        cell.lblLeftTeamScore.text = (tempFirebaseArray[index].i1?.sc)!+"/"+(tempFirebaseArray[index].i1?.wk)!+",\n"+(tempFirebaseArray[index].i3?.sc)!+"/"+(tempFirebaseArray[index].i3?.wk)!
                        cell.lblLeftTeamOver.text = (tempFirebaseArray[index].i3?.ov)!+" Over"
                        cell.lblRightTeamScore.text = (tempFirebaseArray[index].i2?.sc)!+"/"+(tempFirebaseArray[index].i2?.wk)!+",\n"+(tempFirebaseArray[index].i4?.sc)!+"/"+(tempFirebaseArray[index].i4?.wk)!
                        cell.lblRightTeamOver.text = (tempFirebaseArray[index].i4?.ov)!+" Over"
                    }
                }
            }
            else{
                cell.lblLeftTeamScore.text = (tempFirebaseArray[index].i1?.sc)!+"/"+(tempFirebaseArray[index].i1?.wk)!
                cell.lblLeftTeamOver.text = (tempFirebaseArray[index].i1?.ov)! + " Over"
                if tempFirebaseArray[index].i2?.ov != "0" || tempFirebaseArray[index].i2?.sc != "0" || tempFirebaseArray[index].i2?.wk != "0"
                {
                    cell.lblRightTeamScore.text = (tempFirebaseArray[index].i2?.sc)!+"/"+(tempFirebaseArray[index].i2?.wk)!
                    cell.lblRightTeamOver.text = (tempFirebaseArray[index].i2?.ov)! + " Over"
                }
                else
                {
                    cell.lblRightTeamScore.text = ""
                    cell.lblRightTeamOver.text = ""
                }
            }
        }
        cell.lblLandingText.text = tempFirebaseArray[index].con?.lt != "" ? tempFirebaseArray[index].con?.lt : landingText(index:index)
        if tempFirebaseArray[index].con?.mstus == "U"
        {
            cell.lblMatchStatus.text = "Upcoming"
        }
        else if tempFirebaseArray[index].con?.mstus == "L"
        {
            cell.lblMatchStatus.text = "Live"
        }
        else if tempFirebaseArray[index].con?.mstus == "F"
        {
            cell.lblMatchStatus.text = "Finished"
            //            cell.lblLandingText.text = tempFirebaseArray[index].con?.lt != "" ? tempFirebaseArray[index].con?.lt : landingText(index:index)
        }
    }
    
    private func setLiveMatchAdCell(cell:LiveMatchAdCell,index:Int){
        cell.imgViewLeftTeam.image = #imageLiteral(resourceName: "TeamPlaceholder")
        cell.imgViewRightTeam.image = #imageLiteral(resourceName: "TeamPlaceholder")
        cell.lblLeftTeamScore.font = ScreenSize.SCREEN_WIDTH == 320 ? UIFont(name: "Lato-Bold", size: 16) : UIFont(name: "Lato-Bold", size: 18)
        cell.lblRightTeamScore.font = ScreenSize.SCREEN_WIDTH == 320 ? UIFont(name: "Lato-Bold", size: 16) : UIFont(name: "Lato-Bold", size: 18)
        
        if let nkey = tempFirebaseArray[index].t1?.n, nkey != ""{
            if let confirmedImage = UIImage(named: nkey.lowercased()) {
                cell.imgViewLeftTeam.image = confirmedImage
            }
            else{
                if let t1icStr = tempFirebaseArray[index].t1?.ic, t1icStr != ""
                {
                    let fullurlstr = (self.fbPath + t1icStr).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                    cell.imgViewLeftTeam.af_setImage(withURL: URL(string: fullurlstr!+".png")!, placeholderImage: #imageLiteral(resourceName: "TeamPlaceholder"))
                    
                }
                else{
                    if let fname = tempFirebaseArray[index].t1?.f{
                        
                        cell.imgViewLeftTeam.image = AppHelper.generateImageWithText(text: fname, image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:fname.uppercased()), size: CGSize(width: 50, height: 50)))
                        
                    }
                    else{
                        
                        cell.imgViewLeftTeam.image = AppHelper.generateImageWithText(text: "N/A", image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:"N/A"), size: CGSize(width: 50, height: 50)))
                        
                    }
                }
            }
        }
        else{
            if let t1icStr = tempFirebaseArray[index].t1?.ic, t1icStr != ""
            {
                let fullurlstr = (self.fbPath + t1icStr).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                cell.imgViewLeftTeam.af_setImage(withURL: URL(string: fullurlstr!+".png")!, placeholderImage: #imageLiteral(resourceName: "TeamPlaceholder"))
                
            }
            else{
                if let fname = tempFirebaseArray[index].t1?.f{
                    
                    cell.imgViewLeftTeam.image = AppHelper.generateImageWithText(text: fname, image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:fname.uppercased()), size: CGSize(width: 50, height: 50)))
                    
                }
                else{
                    
                    cell.imgViewLeftTeam.image = AppHelper.generateImageWithText(text: "N/A", image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:"N/A"), size: CGSize(width: 50, height: 50)))
                    
                }
            }
        }
        if let nkey = tempFirebaseArray[index].t2?.n, nkey != ""{
            if let confirmedImage = UIImage(named: nkey.lowercased()) {
                cell.imgViewRightTeam.image = confirmedImage
            }
            else{
                if let t2icStr = tempFirebaseArray[index].t2?.ic, t2icStr != ""
                {
                    let fullurlstr = (self.fbPath + t2icStr).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                    cell.imgViewRightTeam.af_setImage(withURL: URL(string: fullurlstr!+".png")!, placeholderImage: #imageLiteral(resourceName: "TeamPlaceholder"))
                    
                }
                else{
                    if let fname = tempFirebaseArray[index].t2?.f{
                        
                        cell.imgViewRightTeam.image = AppHelper.generateImageWithText(text: fname, image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:fname.uppercased()), size: CGSize(width: 50, height: 50)))
                        
                    }
                    else{
                        
                        cell.imgViewRightTeam.image = AppHelper.generateImageWithText(text: "N/A", image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:"N/A"), size: CGSize(width: 50, height: 50)))
                        
                    }
                }
            }
        }
        else{
            if let t2icStr = tempFirebaseArray[index].t2?.ic, t2icStr != ""
            {
                let fullurlstr = (self.fbPath + t2icStr).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                cell.imgViewRightTeam.af_setImage(withURL: URL(string: fullurlstr!+".png")!, placeholderImage: #imageLiteral(resourceName: "TeamPlaceholder"))
                
            }
            else{
                if let fname = tempFirebaseArray[index].t2?.f{
                    
                    cell.imgViewRightTeam.image = AppHelper.generateImageWithText(text: fname, image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:fname.uppercased()), size: CGSize(width: 50, height: 50)))
                    
                }
                else{
                    
                    cell.imgViewRightTeam.image = AppHelper.generateImageWithText(text: "N/A", image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:"N/A"), size: CGSize(width: 50, height: 50)))
                    
                }
                
            }
        }
        /*if tempFirebaseArray[index].t1?.ic != "" && tempFirebaseArray[index].t1?.ic != nil
        {
            if let t1icStr = tempFirebaseArray[index].t1?.ic{
                let fullurlstr = (self.fbPath + t1icStr).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                cell.imgViewLeftTeam.af_setImage(withURL: URL(string: fullurlstr!+".png")!, placeholderImage: #imageLiteral(resourceName: "TeamPlaceholder"))
            }
            
        }
        else
        {
            if let nkey = tempFirebaseArray[index].t1?.n, nkey != ""{
                if let fname = tempFirebaseArray[index].t1?.f{
                    cell.imgViewLeftTeam.image = AppHelper.loadImage(named: nkey.lowercased(),teamName:fname)
                }
                else{
                    cell.imgViewLeftTeam.image = AppHelper.loadImage(named: nkey.lowercased(),teamName:"N/A")
                }
                
            }
            else{
                if let fname = tempFirebaseArray[index].t1?.f{
                    
                    cell.imgViewLeftTeam.image = AppHelper.generateImageWithText(text: fname, image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:fname.uppercased()), size: CGSize(width: 50, height: 50)))
                    
                }
                else{
                    
                    cell.imgViewLeftTeam.image = AppHelper.generateImageWithText(text: "N/A", image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:"N/A"), size: CGSize(width: 50, height: 50)))
                    
                }
                
            }
            //self.ImgViewLeftTeam.image = #imageLiteral(resourceName: "TeamPlaceholder")
        }
        if tempFirebaseArray[index].t2?.ic != "" && tempFirebaseArray[index].t2?.ic != nil
        {
            if let t2icStr = tempFirebaseArray[index].t2?.ic{
                let fullUrlStr = (self.fbPath+t2icStr).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                cell.imgViewRightTeam.af_setImage(withURL: URL(string: fullUrlStr!+".png")!, placeholderImage: #imageLiteral(resourceName: "TeamPlaceholder"))
            }
            
        }
        else
        {
            if let nkey = tempFirebaseArray[index].t2?.n, nkey != ""{
                if let fname = tempFirebaseArray[index].t2?.f{
                    cell.imgViewRightTeam.image = AppHelper.loadImage(named: nkey.lowercased(),teamName:fname)
                }
                else{
                    cell.imgViewRightTeam.image = AppHelper.loadImage(named: nkey.lowercased(),teamName:"N/A")
                }
                
            }
            else{
                if let fname = tempFirebaseArray[index].t2?.f{
                    
                    cell.imgViewRightTeam.image = AppHelper.generateImageWithText(text: fname, image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:fname.uppercased()), size: CGSize(width: 50, height: 50)))
                    
                }
                else{
                    
                    cell.imgViewRightTeam.image = AppHelper.generateImageWithText(text: "N/A", image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:"N/A"), size: CGSize(width: 50, height: 50)))
                    
                }
                
            }
            //self.ImgViewLeftTeam.image = #imageLiteral(resourceName: "TeamPlaceholder")
        }*/
        let dateStr = AppHelper.getMatchDateAndTime(type:1,date:tempFirebaseArray[index].con?.mtm ?? "01/10/2018 11:52")
        cell.lblGroundDetails.text = dateStr
        cell.lblMatchInfo.text = (tempFirebaseArray[index].con?.sr)!+", "+((tempFirebaseArray[index].con?.mn) ?? "")
        
        //cell.lblFavTeam.text = "Fav - " + tempFirebaseArray[index].ft!
        /*if tempFirebaseArray[index].con?.mf == "Test"
        {
            //cell.lblRateOne.text = "-"
            //cell.lblRateTwo.text = "-"
            if tempFirebaseArray[index].mkt?.r1 != "" && tempFirebaseArray[index].mkt?.r3 != "" && tempFirebaseArray[index].mkt?.r5 != ""
            {
                if (Float(tempFirebaseArray[index].mkt?.r1 ?? "") ?? 0 < Float(tempFirebaseArray[index].mkt?.r3 ?? "") ?? 0) && (Float(tempFirebaseArray[index].mkt?.r1 ?? "") ?? 0 < Float(tempFirebaseArray[index].mkt?.r5 ?? "") ?? 0){
                    cell.lblRateOne.text = tempFirebaseArray[index].mkt?.r1
                    cell.lblRateTwo.text = tempFirebaseArray[index].mkt?.r2
                    if let team1 = tempFirebaseArray[index].t1{
                        cell.lblFavTeam.text = "Fav - " + (team1.n ?? "")
                    }
                    else{
                        cell.lblFavTeam.text = "Fav - "
                    }
                }
                else if (Float(tempFirebaseArray[index].mkt?.r3 ?? "") ?? 0 < Float(tempFirebaseArray[index].mkt?.r1 ?? "") ?? 0) && (Float(tempFirebaseArray[index].mkt?.r3 ?? "") ?? 0 < Float(tempFirebaseArray[index].mkt?.r5 ?? "") ?? 0){
                    cell.lblRateOne.text = tempFirebaseArray[index].mkt?.r3
                    cell.lblRateTwo.text = tempFirebaseArray[index].mkt?.r4
                    if let team2 = tempFirebaseArray[index].t2{
                        cell.lblFavTeam.text = "Fav - " + (team2.n ?? "")
                    }
                    else{
                        cell.lblFavTeam.text = "Fav - "
                    }
                }
                else{
                    cell.lblRateOne.text = tempFirebaseArray[index].mkt?.r5
                    cell.lblRateTwo.text = tempFirebaseArray[index].mkt?.r6
                    cell.lblFavTeam.text = "Fav - " + "Draw"
                }
            }
            else{
                cell.lblRateOne.text = "-"
                cell.lblRateTwo.text = "-"
                if let favTeam = tempFirebaseArray[index].ft{
                    cell.lblFavTeam.text = "Fav - " + favTeam
                }
                else{
                    cell.lblFavTeam.text = "Fav - "
                }
            }
        }
        else
        {
            cell.lblFavTeam.text = "Fav - " + tempFirebaseArray[index].ft!
            cell.lblRateOne.text = tempFirebaseArray[index].mkt?.r1 == "" ? "-" : tempFirebaseArray[index].mkt?.r1
            cell.lblRateTwo.text = tempFirebaseArray[index].mkt?.r2 == "" ? "-" : tempFirebaseArray[index].mkt?.r2
        }*/
        if tempFirebaseArray[index].con?.mf == "Test"
        {
            //cell.lblRateOne.text = "-"
            //cell.lblRateTwo.text = "-"
            if let rt = tempFirebaseArray[index].rt, rt != ""{
                let rtArray = rt.components(separatedBy: ",")
                
                if rtArray[0] != "" && rtArray[2] != "" && rtArray[4] != ""
                {
                    if (Float(rtArray[0] ) ?? 0 < Float(rtArray[2]) ?? 0) && (Float(rtArray[0] ) ?? 0 < Float(rtArray[4] ) ?? 0){
                        cell.lblRateOne.text = rtArray[0]
                        cell.lblRateTwo.text = rtArray[1]
                        if let team1 = tempFirebaseArray[index].t1{
                            cell.lblFavTeam.text = "Fav - " + (team1.n?.firstUppercased ?? "")
                        }
                        else{
                            cell.lblFavTeam.text = "Fav - "
                        }
                    }
                    else if (Float(rtArray[2]) ?? 0 < Float(rtArray[0]) ?? 0) && (Float(rtArray[2]) ?? 0 < Float(rtArray[4]) ?? 0){
                        cell.lblRateOne.text = rtArray[2]
                        cell.lblRateTwo.text = rtArray[3]
                        if let team2 = tempFirebaseArray[index].t2{
                            cell.lblFavTeam.text = "Fav - " + (team2.n?.firstUppercased ?? "")
                        }
                        else{
                            cell.lblFavTeam.text = "Fav - "
                        }
                    }
                    else if (Float(rtArray[2]) ?? 0 == Float(rtArray[0]) ?? 0) && (Float(rtArray[2]) ?? 0 < Float(rtArray[4]) ?? 0){
                        cell.lblRateOne.text = rtArray[0]
                        cell.lblRateTwo.text = rtArray[1]
                        if let team1 = tempFirebaseArray[index].t1{
                            cell.lblFavTeam.text = "Fav - " + (team1.n?.firstUppercased ?? "")
                        }
                        else{
                            cell.lblFavTeam.text = "Fav - "
                        }
                    }
                    else if (Float(rtArray[2]) ?? 0 == Float(rtArray[4]) ?? 0) && (Float(rtArray[2]) ?? 0 < Float(rtArray[0]) ?? 0){
                        cell.lblRateOne.text = rtArray[2]
                        cell.lblRateTwo.text = rtArray[3]
                        if let team2 = tempFirebaseArray[index].t2{
                            cell.lblFavTeam.text = "Fav - " + (team2.n?.firstUppercased ?? "")
                        }
                        else{
                            cell.lblFavTeam.text = "Fav - "
                        }
                    }
                    else if (Float(rtArray[0]) ?? 0 == Float(rtArray[4]) ?? 0) && (Float(rtArray[0]) ?? 0 < Float(rtArray[2]) ?? 0){
                        cell.lblRateOne.text = rtArray[0]
                        cell.lblRateTwo.text = rtArray[1]
                        if let team1 = tempFirebaseArray[index].t1{
                            cell.lblFavTeam.text = "Fav - " + (team1.n?.firstUppercased ?? "")
                        }
                        else{
                            cell.lblFavTeam.text = "Fav - "
                        }
                    }
                    else if (Float(rtArray[0]) ?? 0 == Float(rtArray[2]) ?? 0) && (Float(rtArray[0]) ?? 0 == Float(rtArray[4]) ?? 0){
                        cell.lblRateOne.text = rtArray[0]
                        cell.lblRateTwo.text = rtArray[1]
                        if let team1 = tempFirebaseArray[index].t1{
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
            if let rt = tempFirebaseArray[index].rt, rt != ""{
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
        cell.lblLeftTeam.text = tempFirebaseArray[index].t1?.n?.firstUppercased
        cell.lblRightTeam.text = tempFirebaseArray[index].t2?.n?.firstUppercased
        if tempFirebaseArray[index].con?.mstus == "U"
        {
            cell.lblLeftTeamScore.text = ""
            cell.lblLeftTeamOver.text = ""
            cell.lblRightTeamScore.text = ""
            cell.lblRightTeamOver.text = ""
        }
        else
        {
            if tempFirebaseArray[index].con?.mf == "Test" {
                cell.lblLeftTeamScore.text = (tempFirebaseArray[index].i1?.sc)!+"/"+(tempFirebaseArray[index].i1?.wk)!
                cell.lblLeftTeamOver.text = (tempFirebaseArray[index].i1?.ov)! + " Over"
                if tempFirebaseArray[index].i2?.ov != "0" || tempFirebaseArray[index].i2?.sc != "0" || tempFirebaseArray[index].i2?.wk != "0"
                {
                    cell.lblRightTeamScore.text = (tempFirebaseArray[index].i2?.sc)!+"/"+(tempFirebaseArray[index].i2?.wk)!
                    cell.lblRightTeamOver.text = (tempFirebaseArray[index].i2?.ov)! + " Over"
                }
                else
                {
                    cell.lblRightTeamScore.text = ""
                    cell.lblRightTeamOver.text = ""
                }
                if tempFirebaseArray[index].i3?.ov != "0" || tempFirebaseArray[index].i3?.sc != "0" || tempFirebaseArray[index].i3?.wk != "0"
                {
//                    if tempFirebaseArray[index].i3?.bt == tempFirebaseArray[index].i2?.bt
//                    {
//                        cell.lblRightTeamScore.text = (tempFirebaseArray[index].i2?.sc)!+"/"+(tempFirebaseArray[index].i2?.wk)!+",\n"+(tempFirebaseArray[index].i3?.sc)!+"/"+(tempFirebaseArray[index].i3?.wk)!
//                        cell.lblRightTeamOver.text = (tempFirebaseArray[index].i3?.ov)!+" Over"
//                    }
                    if tempFirebaseArray[index].i3b == "t2"
                    {
                        cell.lblRightTeamScore.text = (tempFirebaseArray[index].i2?.sc)!+"/"+(tempFirebaseArray[index].i2?.wk)!+",\n"+(tempFirebaseArray[index].i3?.sc)!+"/"+(tempFirebaseArray[index].i3?.wk)!
                        cell.lblRightTeamOver.text = (tempFirebaseArray[index].i3?.ov)!+" Over"
                    }
                    else
                    {
                        cell.lblLeftTeamScore.text = (tempFirebaseArray[index].i1?.sc)!+"/"+(tempFirebaseArray[index].i1?.wk)!+",\n"+(tempFirebaseArray[index].i3?.sc)!+"/"+(tempFirebaseArray[index].i3?.wk)!
                        cell.lblLeftTeamOver.text = (tempFirebaseArray[index].i3?.ov)!+" Over"
                    }
                }
                if tempFirebaseArray[index].i4?.ov != "0" || tempFirebaseArray[index].i4?.sc != "0" || tempFirebaseArray[index].i4?.wk != "0"
                {
//                    if tempFirebaseArray[index].i3?.bt == tempFirebaseArray[index].i2?.bt
//                    {
//                        cell.lblRightTeamScore.text = (tempFirebaseArray[index].i2?.sc)!+"/"+(tempFirebaseArray[index].i2?.wk)!+",\n"+(tempFirebaseArray[index].i3?.sc)!+"/"+(tempFirebaseArray[index].i3?.wk)!
//                        cell.lblRightTeamOver.text = (tempFirebaseArray[index].i3?.ov)!+" Over"
//                        cell.lblLeftTeamScore.text = (tempFirebaseArray[index].i1?.sc)!+"/"+(tempFirebaseArray[index].i1?.wk)!+",\n"+(tempFirebaseArray[index].i4?.sc)!+"/"+(tempFirebaseArray[index].i4?.wk)!
//                        cell.lblLeftTeamOver.text = (tempFirebaseArray[index].i4?.ov)!+" Over"
//
//                    }
                    if tempFirebaseArray[index].i3b == "t2"
                    {
                        cell.lblRightTeamScore.text = (tempFirebaseArray[index].i2?.sc)!+"/"+(tempFirebaseArray[index].i2?.wk)!+",\n"+(tempFirebaseArray[index].i3?.sc)!+"/"+(tempFirebaseArray[index].i3?.wk)!
                        cell.lblRightTeamOver.text = (tempFirebaseArray[index].i3?.ov)!+" Over"
                        cell.lblLeftTeamScore.text = (tempFirebaseArray[index].i1?.sc)!+"/"+(tempFirebaseArray[index].i1?.wk)!+",\n"+(tempFirebaseArray[index].i4?.sc)!+"/"+(tempFirebaseArray[index].i4?.wk)!
                        cell.lblLeftTeamOver.text = (tempFirebaseArray[index].i4?.ov)!+" Over"
                        
                    }
                    else
                    {
                        cell.lblLeftTeamScore.text = (tempFirebaseArray[index].i1?.sc)!+"/"+(tempFirebaseArray[index].i1?.wk)!+",\n"+(tempFirebaseArray[index].i3?.sc)!+"/"+(tempFirebaseArray[index].i3?.wk)!
                        cell.lblLeftTeamOver.text = (tempFirebaseArray[index].i3?.ov)!+" Over"
                        cell.lblRightTeamScore.text = (tempFirebaseArray[index].i2?.sc)!+"/"+(tempFirebaseArray[index].i2?.wk)!+",\n"+(tempFirebaseArray[index].i4?.sc)!+"/"+(tempFirebaseArray[index].i4?.wk)!
                        cell.lblRightTeamOver.text = (tempFirebaseArray[index].i4?.ov)!+" Over"
                    }
                }
            }
            else{
                cell.lblLeftTeamScore.text = (tempFirebaseArray[index].i1?.sc)!+"/"+(tempFirebaseArray[index].i1?.wk)!
                cell.lblLeftTeamOver.text = (tempFirebaseArray[index].i1?.ov)! + " Over"
                if tempFirebaseArray[index].i2?.ov != "0" || tempFirebaseArray[index].i2?.sc != "0" || tempFirebaseArray[index].i2?.wk != "0"
                {
                    cell.lblRightTeamScore.text = (tempFirebaseArray[index].i2?.sc)!+"/"+(tempFirebaseArray[index].i2?.wk)!
                    cell.lblRightTeamOver.text = (tempFirebaseArray[index].i2?.ov)! + " Over"
                }
                else
                {
                    cell.lblRightTeamScore.text = ""
                    cell.lblRightTeamOver.text = ""
                }
            }
        }
        cell.lblLandingText.text = tempFirebaseArray[index].con?.lt != "" ? tempFirebaseArray[index].con?.lt : landingText(index:index)
        if tempFirebaseArray[index].con?.mstus == "U"
        {
            cell.lblMatchStatus.text = "Upcoming"
        }
        else if tempFirebaseArray[index].con?.mstus == "L"
        {
            cell.lblMatchStatus.text = "Live"
        }
        else if tempFirebaseArray[index].con?.mstus == "F"
        {
            cell.lblMatchStatus.text = "Finished"
            //            cell.lblLandingText.text = tempFirebaseArray[index].con?.lt != "" ? tempFirebaseArray[index].con?.lt : landingText(index:index)
        }
    }
    
    /*private func landingText(index:Int) -> String
    {
        if tempFirebaseArray[index].con?.mf == "Test"{
            if tempFirebaseArray[index].i4?.ov != "0" || tempFirebaseArray[index].i4?.sc != "0" || tempFirebaseArray[index].i4?.wk != "0"
            {
                if tempFirebaseArray[index].i2?.bt == tempFirebaseArray[index].i3?.bt
                {
                    let txt = "\((tempFirebaseArray[index].i4?.bt)! == "t1" ? tempFirebaseArray[index].t1!.f! : tempFirebaseArray[index].t2!.f!) needs \(((Int((tempFirebaseArray[index].i2?.sc)!)!+Int((tempFirebaseArray[index].i3?.sc)!)!)+1)-(Int((tempFirebaseArray[index].i1?.sc)!)!+Int((tempFirebaseArray[index].i4?.sc)!)!)) runs to win"
                    
                    if ((Int((tempFirebaseArray[index].i2?.sc)!)!+Int((tempFirebaseArray[index].i3?.sc)!)!)+1)-(Int((tempFirebaseArray[index].i1?.sc)!)!+Int((tempFirebaseArray[index].i4?.sc)!)!) <= 0
                    {
                        return "\((tempFirebaseArray[index].i4?.bt)! == "t1" ? tempFirebaseArray[index].t1!.f! : tempFirebaseArray[index].t2!.f!) won the match"
                    }
                    return txt
                }
                else
                {
                    let txt = "\((tempFirebaseArray[index].i4?.bt)! == "t1" ? tempFirebaseArray[index].t1!.f! : tempFirebaseArray[index].t2!.f!) needs \(((Int((tempFirebaseArray[index].i1?.sc)!)!+Int((tempFirebaseArray[index].i3?.sc)!)!)+1)-(Int((tempFirebaseArray[index].i2?.sc)!)!+Int((tempFirebaseArray[index].i4?.sc)!)!)) runs to win"
                    
                    if ((Int((tempFirebaseArray[index].i1?.sc)!)!+Int((tempFirebaseArray[index].i3?.sc)!)!)+1)-(Int((tempFirebaseArray[index].i2?.sc)!)!+Int((tempFirebaseArray[index].i4?.sc)!)!) <= 0
                    {
                        return "\((tempFirebaseArray[index].i4?.bt)! == "t1" ? tempFirebaseArray[index].t1!.f! : tempFirebaseArray[index].t2!.f!) won the match"
                    }
                    return txt
                }
            }
            else if tempFirebaseArray[index].i3?.ov != "0" || tempFirebaseArray[index].i3?.sc != "0" || tempFirebaseArray[index].i3?.wk != "0"
            {
                if tempFirebaseArray[index].i2?.bt == tempFirebaseArray[index].i3?.bt
                {
                    if Int((tempFirebaseArray[index].i1?.sc)!)! < (Int((tempFirebaseArray[index].i2?.sc)!)!+Int((tempFirebaseArray[index].i3?.sc)!)!)
                    {
                        let txt = "\((tempFirebaseArray[index].i3?.bt)! == "t1" ? tempFirebaseArray[index].t1!.f! : tempFirebaseArray[index].t2!.f!) is leading by \((Int((tempFirebaseArray[index].i2?.sc)!)!+Int((tempFirebaseArray[index].i3?.sc)!)!)-Int((tempFirebaseArray[index].i1?.sc)!)!)"
                        return txt
                    }
                    else
                    {
                        let txt = "\((tempFirebaseArray[index].i3?.bt)! == "t1" ? tempFirebaseArray[index].t1!.f! : tempFirebaseArray[index].t2!.f!) is trailing by \(Int((tempFirebaseArray[index].i1?.sc)!)!-(Int((tempFirebaseArray[index].i2?.sc)!)!+Int((tempFirebaseArray[index].i3?.sc)!)!))"
                        return txt
                    }
                }
                else
                {
                    if Int((tempFirebaseArray[index].i2?.sc)!)! < (Int((tempFirebaseArray[index].i1?.sc)!)!+Int((tempFirebaseArray[index].i3?.sc)!)!)
                    {
                        let txt = "\((tempFirebaseArray[index].i3?.bt)! == "t1" ? tempFirebaseArray[index].t1!.f! : tempFirebaseArray[index].t2!.f!) is leading by \((Int((tempFirebaseArray[index].i1?.sc)!)!+Int((tempFirebaseArray[index].i3?.sc)!)!)-Int((tempFirebaseArray[index].i2?.sc)!)!)"
                        return txt
                    }
                    else
                    {
                        let txt = "\((tempFirebaseArray[index].i3?.bt)! == "t1" ? tempFirebaseArray[index].t1!.f! : tempFirebaseArray[index].t2!.f!) is trailing by \(Int((tempFirebaseArray[index].i2?.sc)!)!-(Int((tempFirebaseArray[index].i1?.sc)!)!+Int((tempFirebaseArray[index].i3?.sc)!)!))"
                        return txt
                    }
                }
            }
            else if (tempFirebaseArray[index].i2?.ov != "" || tempFirebaseArray[index].i2?.sc != "" || tempFirebaseArray[index].i2?.wk != "") && tempFirebaseArray[index].i2?.iov != "0"
            {
                if tempFirebaseArray[index].con?.mf == "Test"
                {
                    if Int((tempFirebaseArray[index].i1?.sc)!)! < Int((tempFirebaseArray[index].i2?.sc)!)!
                    {
                        let txt = "\((tempFirebaseArray[index].i2?.bt)! == "t1" ? tempFirebaseArray[index].t1!.f! : tempFirebaseArray[index].t2!.f!) is leading by \(Int((tempFirebaseArray[index].i2?.sc)!)!-Int((tempFirebaseArray[index].i1?.sc)!)!)"
                        return txt
                    }
                    else
                    {
                        let txt = "\((tempFirebaseArray[index].i2?.bt)! == "t1" ? tempFirebaseArray[index].t1!.f! : tempFirebaseArray[index].t2!.f!) is trailing by \(Int((tempFirebaseArray[index].i1?.sc)!)!-Int((tempFirebaseArray[index].i2?.sc)!)!)"
                        return txt
                    }
                }
                else
                {
//                    let txt = "\((tempFirebaseArray[index].i2?.bt)! == "t1" ? tempFirebaseArray[index].t1!.f! : tempFirebaseArray[index].t2!.f!) needs \((Int((tempFirebaseArray[index].i1?.sc)!)!+1)-Int((tempFirebaseArray[index].i2?.sc)!)!) runs in \(ballRemaining(ov: (tempFirebaseArray[index].i2?.ov)!, iov: (tempFirebaseArray[index].i2?.iov)!)) balls to win"
                    let txt = "\((tempFirebaseArray[index].i2?.bt)! == "t1" ? tempFirebaseArray[index].t1!.n! : tempFirebaseArray[index].t2!.n!) needs \((Int((tempFirebaseArray[index].i2?.tr)!)!)-Int((tempFirebaseArray[index].i2?.sc)!)!) runs in \(ballRemaining(ov: (tempFirebaseArray[index].i2?.ov)!, iov: (tempFirebaseArray[index].i2?.iov)!)) balls to win"
                    
//                    if ((Int((tempFirebaseArray[index].i1?.sc)!)!+1)-Int((tempFirebaseArray[index].i2?.sc)!)!) <= 0
//                    {
//                        return "\((tempFirebaseArray[index].i2?.bt)! == "t1" ? tempFirebaseArray[index].t1!.f! : tempFirebaseArray[index].t2!.f!) won the match"
//                    }
                    if ((Int((tempFirebaseArray[index].i2?.tr)!)!)-Int((tempFirebaseArray[index].i2?.sc)!)!) <= 0
                    {
                        return "\((tempFirebaseArray[index].i2?.bt)! == "t1" ? tempFirebaseArray[index].t1!.n! : tempFirebaseArray[index].t2!.n!) won the match"
                    }
                    return txt
                }
            }
        }
        else{
            if (tempFirebaseArray[index].i2?.ov != "" || tempFirebaseArray[index].i2?.sc != "" || tempFirebaseArray[index].i2?.wk != "") && tempFirebaseArray[index].i2?.iov != "0"
            {
                if tempFirebaseArray[index].con?.mf == "Test"
                {
                    if Int((tempFirebaseArray[index].i1?.sc)!)! < Int((tempFirebaseArray[index].i2?.sc)!)!
                    {
                        let txt = "\((tempFirebaseArray[index].i2?.bt)! == "t1" ? tempFirebaseArray[index].t1!.f! : tempFirebaseArray[index].t2!.f!) is leading by \(Int((tempFirebaseArray[index].i2?.sc)!)!-Int((tempFirebaseArray[index].i1?.sc)!)!)"
                        return txt
                    }
                    else
                    {
                        let txt = "\((tempFirebaseArray[index].i2?.bt)! == "t1" ? tempFirebaseArray[index].t1!.f! : tempFirebaseArray[index].t2!.f!) is trailing by \(Int((tempFirebaseArray[index].i1?.sc)!)!-Int((tempFirebaseArray[index].i2?.sc)!)!)"
                        return txt
                    }
                }
                else
                {
//                    let txt = "\((tempFirebaseArray[index].i2?.bt)! == "t1" ? tempFirebaseArray[index].t1!.f! : tempFirebaseArray[index].t2!.f!) needs \((Int((tempFirebaseArray[index].i1?.sc)!)!+1)-Int((tempFirebaseArray[index].i2?.sc)!)!) runs in \(ballRemaining(ov: (tempFirebaseArray[index].i2?.ov)!, iov: (tempFirebaseArray[index].i2?.iov)!)) balls to win"
//
//                    if ((Int((tempFirebaseArray[index].i1?.sc)!)!+1)-Int((tempFirebaseArray[index].i2?.sc)!)!) <= 0
//                    {
//                        return "\((tempFirebaseArray[index].i2?.bt)! == "t1" ? tempFirebaseArray[index].t1!.f! : tempFirebaseArray[index].t2!.f!) won the match"
//                    }
                    let txt = "\((tempFirebaseArray[index].i2?.bt)! == "t1" ? tempFirebaseArray[index].t1!.n! : tempFirebaseArray[index].t2!.n!) needs \((Int((tempFirebaseArray[index].i2?.tr)!)!)-Int((tempFirebaseArray[index].i2?.sc)!)!) runs in \(ballRemaining(ov: (tempFirebaseArray[index].i2?.ov)!, iov: (tempFirebaseArray[index].i2?.iov)!)) balls to win"
                    
                    if ((Int((tempFirebaseArray[index].i2?.tr)!)!)-Int((tempFirebaseArray[index].i2?.sc)!)!) <= 0
                    {
                        return "\((tempFirebaseArray[index].i2?.bt)! == "t1" ? tempFirebaseArray[index].t1!.n! : tempFirebaseArray[index].t2!.n!) won the match"
                    }
                    return txt
                }
            }
        }
        return ""
    }*/
    private func landingText(index:Int) -> String
    {
        if tempFirebaseArray[index].con?.mf == "Test"{
            if tempFirebaseArray[index].i4?.ov != "0" || tempFirebaseArray[index].i4?.sc != "0" || tempFirebaseArray[index].i4?.wk != "0"
            {
                if tempFirebaseArray[index].i3b == "t2"
                {
                    let txt = "\(tempFirebaseArray[index].i3b == "t2" ? tempFirebaseArray[index].t1!.f! : tempFirebaseArray[index].t2!.f!) needs \(((Int((tempFirebaseArray[index].i2?.sc)!)!+Int((tempFirebaseArray[index].i3?.sc)!)!)+1)-(Int((tempFirebaseArray[index].i1?.sc)!)!+Int((tempFirebaseArray[index].i4?.sc)!)!)) runs to win"
                    
                    if ((Int((tempFirebaseArray[index].i2?.sc)!)!+Int((tempFirebaseArray[index].i3?.sc)!)!)+1)-(Int((tempFirebaseArray[index].i1?.sc)!)!+Int((tempFirebaseArray[index].i4?.sc)!)!) <= 0
                    {
                        return "\(tempFirebaseArray[index].i3b == "t2" ? tempFirebaseArray[index].t1!.f! : tempFirebaseArray[index].t2!.f!) won the match"
                    }
                    return txt
                }
                else
                {
                    let txt = "\(tempFirebaseArray[index].i3b == "t2" ? tempFirebaseArray[index].t1!.f! : tempFirebaseArray[index].t2!.f!) needs \(((Int((tempFirebaseArray[index].i1?.sc)!)!+Int((tempFirebaseArray[index].i3?.sc)!)!)+1)-(Int((tempFirebaseArray[index].i2?.sc)!)!+Int((tempFirebaseArray[index].i4?.sc)!)!)) runs to win"
                    
                    if ((Int((tempFirebaseArray[index].i1?.sc)!)!+Int((tempFirebaseArray[index].i3?.sc)!)!)+1)-(Int((tempFirebaseArray[index].i2?.sc)!)!+Int((tempFirebaseArray[index].i4?.sc)!)!) <= 0
                    {
                        return "\(tempFirebaseArray[index].i3b == "t2" ? tempFirebaseArray[index].t1!.f! : tempFirebaseArray[index].t2!.f!) won the match"
                    }
                    return txt
                }
            }
            else if tempFirebaseArray[index].i3?.ov != "0" || tempFirebaseArray[index].i3?.sc != "0" || tempFirebaseArray[index].i3?.wk != "0"
            {
                if tempFirebaseArray[index].i3b == "t2"
                {
                    if Int((tempFirebaseArray[index].i1?.sc)!)! < (Int((tempFirebaseArray[index].i2?.sc)!)!+Int((tempFirebaseArray[index].i3?.sc)!)!)
                    {
                        let txt = "\(tempFirebaseArray[index].i3b == "t1" ? tempFirebaseArray[index].t1!.f! : tempFirebaseArray[index].t2!.f!) is leading by \((Int((tempFirebaseArray[index].i2?.sc)!)!+Int((tempFirebaseArray[index].i3?.sc)!)!)-Int((tempFirebaseArray[index].i1?.sc)!)!)"
                        return txt
                    }
                    else
                    {
                        let txt = "\(tempFirebaseArray[index].i3b == "t1" ? tempFirebaseArray[index].t1!.f! : tempFirebaseArray[index].t2!.f!) is trailing by \(Int((tempFirebaseArray[index].i1?.sc)!)!-(Int((tempFirebaseArray[index].i2?.sc)!)!+Int((tempFirebaseArray[index].i3?.sc)!)!))"
                        return txt
                    }
                }
                else
                {
                    if Int((tempFirebaseArray[index].i2?.sc)!)! < (Int((tempFirebaseArray[index].i1?.sc)!)!+Int((tempFirebaseArray[index].i3?.sc)!)!)
                    {
                        let txt = "\(tempFirebaseArray[index].i3b == "t1" ? tempFirebaseArray[index].t1!.f! : tempFirebaseArray[index].t2!.f!) is leading by \((Int((tempFirebaseArray[index].i1?.sc)!)!+Int((tempFirebaseArray[index].i3?.sc)!)!)-Int((tempFirebaseArray[index].i2?.sc)!)!)"
                        return txt
                    }
                    else
                    {
                        let txt = "\(tempFirebaseArray[index].i3b == "t1" ? tempFirebaseArray[index].t1!.f! : tempFirebaseArray[index].t2!.f!) is trailing by \(Int((tempFirebaseArray[index].i2?.sc)!)!-(Int((tempFirebaseArray[index].i1?.sc)!)!+Int((tempFirebaseArray[index].i3?.sc)!)!))"
                        return txt
                    }
                }
            }
            else if (tempFirebaseArray[index].i2?.ov != "0" || tempFirebaseArray[index].i2?.sc != "0" || tempFirebaseArray[index].i2?.wk != "0")
            {
                if tempFirebaseArray[index].con?.mf == "Test"
                {
                    if Int((tempFirebaseArray[index].i1?.sc)!)! < Int((tempFirebaseArray[index].i2?.sc)!)!
                    {
                        let txt = "\(tempFirebaseArray[index].i1b == "t2" ? tempFirebaseArray[index].t1!.f! : tempFirebaseArray[index].t2!.f!) is leading by \(Int((tempFirebaseArray[index].i2?.sc)!)!-Int((tempFirebaseArray[index].i1?.sc)!)!)"
                        return txt
                    }
                    else
                    {
                        let txt = "\(tempFirebaseArray[index].i1b == "t2" ? tempFirebaseArray[index].t1!.f! : tempFirebaseArray[index].t2!.f!) is trailing by \(Int((tempFirebaseArray[index].i1?.sc)!)!-Int((tempFirebaseArray[index].i2?.sc)!)!)"
                        return txt
                    }
                }
                else
                {
                    
                    let txt = "\(tempFirebaseArray[index].i1b == "t2" ? tempFirebaseArray[index].t1!.n! : tempFirebaseArray[index].t2!.n!) needs \((Int((tempFirebaseArray[index].i2?.tr)!)!)-Int((tempFirebaseArray[index].i2?.sc)!)!) runs in \(ballRemaining(ov: (tempFirebaseArray[index].i2?.ov)!, iov: (tempFirebaseArray[index].iov! == "" ? "0":tempFirebaseArray[index].iov!))) balls to win"
                    
                    
                    if ((Int((tempFirebaseArray[index].i2?.tr)!)!)-Int((tempFirebaseArray[index].i2?.sc)!)!) <= 0
                    {
                        return "\(tempFirebaseArray[index].i1b == "t2" ? tempFirebaseArray[index].t1!.n! : tempFirebaseArray[index].t2!.n!) won the match"
                    }
                    return txt
                }
            }
        }
        else{
            if (tempFirebaseArray[index].i2?.ov != "0" || tempFirebaseArray[index].i2?.sc != "0" || tempFirebaseArray[index].i2?.wk != "0")
            {
                if tempFirebaseArray[index].con?.mf == "Test"
                {
                    if Int((tempFirebaseArray[index].i1?.sc)!)! < Int((tempFirebaseArray[index].i2?.sc)!)!
                    {
                        let txt = "\(tempFirebaseArray[index].i1b == "t2" ? tempFirebaseArray[index].t1!.f! : tempFirebaseArray[index].t2!.f!) is leading by \(Int((tempFirebaseArray[index].i2?.sc)!)!-Int((tempFirebaseArray[index].i1?.sc)!)!)"
                        return txt
                    }
                    else
                    {
                        let txt = "\(tempFirebaseArray[index].i1b == "t2" ? tempFirebaseArray[index].t1!.f! : tempFirebaseArray[index].t2!.f!) is trailing by \(Int((tempFirebaseArray[index].i1?.sc)!)!-Int((tempFirebaseArray[index].i2?.sc)!)!)"
                        return txt
                    }
                }
                else
                {
                    let txt = "\(tempFirebaseArray[index].i1b == "t2" ? tempFirebaseArray[index].t1!.n! : tempFirebaseArray[index].t2!.n!) needs \((Int((tempFirebaseArray[index].i2?.tr)!)!)-Int((tempFirebaseArray[index].i2?.sc)!)!) runs in \(ballRemaining(ov: (tempFirebaseArray[index].i2?.ov)!, iov: (tempFirebaseArray[index].iov! == "" ? "0":tempFirebaseArray[index].iov!))) balls to win"
                    
                    if ((Int((tempFirebaseArray[index].i2?.tr)!)!)-Int((tempFirebaseArray[index].i2?.sc)!)!) <= 0
                    {
                        return "\(tempFirebaseArray[index].i1b == "t2" ? tempFirebaseArray[index].t1!.n! : tempFirebaseArray[index].t2!.n!) won the match"
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
}
//MARK: Banner Ad Delegates
extension LiveMatchesVC:GADBannerViewDelegate
{
    // AdMob banner available
    func adViewDidReceiveAd(_ view: GADBannerView) {
        //showNativeAd()
        //tableLive.reloadData()
        //bannerHeight.constant = 50.0
    }
    
    // NO AdMob banner available
    func adView(_ view: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        //showNativeAd()
        //tableLive.reloadData()
        //bannerHeight.constant = 0.0
        loadBannerAd()
    }
}


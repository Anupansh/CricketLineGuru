//
//  MatchLineVC.swift
//  CLG
//
//  Created by Anuj Naruka on 6/27/18.
//  Copyright © 2018 Anuj Naruka. All rights reserved.
//

import UIKit
import GoogleMobileAds
import CoreData

var didAdShow = String()

class MatchLineVC: BaseViewController,GADInterstitialDelegate {
    
    //MARK:- Variables & Constants
    
    var currentViewC: UIViewController!
    var fbNode: String?
    var index: Int?
    lazy var fbPath: String = {
        let fbPath = String()
        return fbPath
    }()
    lazy var vcType: String = {
        let vcType = String()
        return vcType
    }()
    //MARK:- IBOutlets
    
    @IBOutlet weak var tabView1: UIView!
    @IBOutlet weak var btnLiveLine: UIButton!
    @IBOutlet weak var btnInfo: UIButton!
    @IBOutlet weak var btnChat: UIButton! 
    @IBOutlet weak var viewSelected: UIView!
    @IBOutlet weak var viewSelectedLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var gadBannerView: GADBannerView!
    @IBOutlet weak var bannerHeight: NSLayoutConstraint!
    @IBOutlet weak var tabView2: UIView!
    @IBOutlet weak var btnLiveLine1: UIButton!
    @IBOutlet weak var btnInfo1: UIButton!
    @IBOutlet weak var btnChat1: UIButton!
    @IBOutlet weak var btnScore: UIButton!
    @IBOutlet weak var viewSelected1: UIView!
    @IBOutlet weak var viewSelectedLeadingConstraint1: NSLayoutConstraint!
    @IBOutlet weak var collectionVw: UICollectionView!
    
    var interstitialAds: GADInterstitial!
//    var collectionArray = ["Live Line", "Info", "Chat", "Commentary", "Scorecard"]
    var collectionArray = ["Live Line", "Info", "Commentary", "Scorecard"]
    var bannerAdView: FBAdView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //FireBaseMatchLineObservers.setMatchLineObservers(matchKey: fireBaseGlobalModel[index!].matchKey!, currentMatch: index!)
        //FireBaseMatchKeyObservers.setMatchKeyObservers(matchKey: fireBaseGlobalModel[index!].matchKey!, currentMatch: index!)
        self.tabView2.isHidden = true
        self.tabView1.isHidden = true
        setUp()
        didAdShow = "0"
        // Do any additional setup after loading the view.
        addFbBAnner()
        self.collectionVw.register(UINib(nibName: "LabelCell", bundle: nil), forCellWithReuseIdentifier: "LabelCell")
    }
    
    func addFbBAnner() {
        bannerAdView = FBAdView(placementID: AppHelper.appDelegate().fbBannerAdId, adSize: kFBAdSizeHeight50Banner, rootViewController: self)
                if UIDevice.current.hasTopNotch {
                    bannerAdView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 84, width: UIScreen.main.bounds.width, height: 50)
                }
                else {
                    bannerAdView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 60, width: UIScreen.main.bounds.width, height: 50)
        }
        //        bannerAdView.delegate = self
                self.view.addSubview(bannerAdView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       FireBaseMatchKeyObservers.setMatchKeyObservers(matchKey: fireBaseGlobalModel[index!].matchKey!, currentMatch: index!)
//        if let tabbar = self.tabBarController as? HomeTabbarVC
//        {
//            tabbar.hideLine1()
//        }
//        self.tabBarController?.tabBar.isHidden = true
        
        if let viewC = self.childViewControllers[0] as? LiveLineVC
        {
            viewC.CurrentMatch = index!
        }
        AppHelper.saveToUserDefaults(value: "1" as AnyObject, withKey: "LiveLine")
        
        let notificationCenterr = NotificationCenter.default
        notificationCenterr.addObserver(self,
                                        selector: #selector(self.refreshBadgeCount),
                                        name: .refreshBadgeCount,
                                        object: nil)

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //FireBaseMatchLineObservers.removeMatchLineObserver(matchKey: fireBaseGlobalModel[index!].matchKey!)
        FireBaseMatchKeyObservers.removeMatchKeyObserver(matchKey: fireBaseGlobalModel[index!].matchKey!)
       // NotificationCenter.default.post(name: .refreshLiveView, object: nil)
        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
        //FireBaseHomeObservers().removeObservers(ref:AppHelper.appDelegate().ref)
        //AppHelper.appDelegate().firebaseConfigMethod()
//        removeObserver()
//        if UserDefaults.standard.value(forKey: "accessToken") != nil
//        {
//            chatGlobalArr.removeAll()
//            SocketIOManager.removeFromGroup(groupId: groupId)
//        }
        
    }
    
    func loadFbBannerAd() {
            bannerAdView.loadAd()
    }
    @objc func refreshBadgeCount(){
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
    }
    //MARK:-Functions
    private func showGoogleAds()
    {
//        self.gadBannerView.adUnitID = AppHelper.appDelegate().adBannerUnitID as String
//        self.gadBannerView.rootViewController = self
//        //self.gadBannerView.load(GADRequest())
//        self.gadBannerView.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loadFbBannerAd()
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
    private func addObserver()
    {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(self.moveToHome),
                                       name: .moveToHome,
                                       object: nil)
        notificationCenter.addObserver(self, selector: #selector(self.refreshNavigation),
                                       name: .refreshMatchKey,
                                       object: nil)
    }
    private func removeObserver()
    {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self)
    }
    @objc func moveToHome()
    {
            self.dismiss(animated: true, completion: nil)
    }
    @objc func refreshNavigation()
    {
        /*let title = (fireBaseGlobalModel[index!].t1?.n)! + "  vs  " + (fireBaseGlobalModel[index!].t2?.n)!
        if fireBaseGlobalModel[index!].mk != nil, fireBaseGlobalModel[index!].mk != "0" && fireBaseGlobalModel[index!].mk != ""
        {
           // self.setupNavigationBarTitle(title, navBG: "", leftBarButtonsType: [.backWhite], rightBarButtonsType: [.threeDot])
            self.setupNavigationBarTitle(title, navBG: "", leftBarButtonsType: [.backWhite], rightBarButtonsType: [])
            self.tabView1.isHidden = true
            self.tabView2.isHidden = false
            self.hideNavigationBar(false)
        }
        else
        {
            self.setupNavigationBarTitle(title, navBG: "", leftBarButtonsType: [.backWhite], rightBarButtonsType: [])
            self.tabView1.isHidden = false
            self.tabView2.isHidden = true
            self.hideNavigationBar(false)
        }*/
        self.tabView1.isHidden = true

    }
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        NotificationCenter.default.post(name: .disableTimer, object: nil)
        didAdShow = "1"
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial =
            GADInterstitial(adUnitID: AppHelper.appDelegate().adInterstitialUnitID)
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    func interstitialDidDismissScreen(_ ad: GADInterstitial){
        if didAdShow != "0" && didAdShow != "1"
        {
            //if vcType == "Home"{
                if didAdShow == fireBaseGlobalModel[index!].matchKey
                {
                    self.dismiss(animated: true, completion: nil)
                }
                DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
                    for (index,item) in fireBaseGlobalModel.enumerated()
                    {
                        if item.matchKey == didAdShow
                        {
                            FireBaseHomeObservers().removeObservers(ref: AppHelper.appDelegate().ref)
                            fireBaseGlobalModel.remove(at: index)
                            FireBaseHomeObservers().setHomeScreenObserver(ref:AppHelper.appDelegate().ref)
                            NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                            //NotificationCenter.default.post(name: .refreshLiveView, object: nil)
                            NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)

                            didAdShow = "0"
                        }
                    }
                })
            //}
            /*else{
                if didAdShow == fireBaseGlobalModel[index!].matchKey
                {
                    self.dismiss(animated: true, completion: nil)
                }
                DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
                    for (index,item) in fireBaseGlobalModel.enumerated()
                    {
                        if item.matchKey == didAdShow
                        {
                            FireBaseHomeObservers().removeLiveObservers(ref: AppHelper.appDelegate().ref)
                            fireBaseGlobalModel.remove(at: index)
                            for (indexx,itemm) in fireBaseGlobalModel.enumerated(){
                                if item.matchKey == itemm.matchKey{
                                    fireBaseGlobalModelLive.remove(at: indexx)
                                }
                            }
                            FireBaseHomeObservers().setLiveScreenObserver(ref:AppHelper.appDelegate().ref)
                            //NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                            NotificationCenter.default.post(name: .refreshLiveView, object: nil)
                            
                            didAdShow = "0"
                        }
                    }
                })
            }*/
        }
    }
    func interstitialWillDismissScreen(_ ad: GADInterstitial){
        
    }    
    private func setUp()
    {
//        self.interstitialAds = createAndLoadInterstitial()
        let appDel = UIApplication.shared.delegate as! AppDelegate
//        if appDel.interstitialAds.isReady {
//            appDel.interstitialAds.present(fromRootViewController: self)
//            appDel.interstitialAds = nil
//            appDel.interstitialAds = appDel.createAndLoadInterstitial()
//        }
        if (appDel.fbInterstitialAd != nil) && appDel.fbInterstitialAd.isAdValid && appDel.toShowInterstitial {
            appDel.fbInterstitialAd.show(fromRootViewController: self)
            appDel.fbInterstitialAd = nil
            appDel.fbInterstitialAd = appDel.loadInterstitialFbAd()
            appDel.toShowInterstitial = false
            appDel.runTimer()
        }
        if UserDefault.userDefaultForAny(key: "LastFullPageAdShowTimestamp") != nil
        {
            if (UserDefault.userDefaultForAny(key: "LastFullPageAdShowTimestamp") as! TimeInterval) < Date().timeIntervalSince1970
            {
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
                   // self.ShowAd()
                })
            }
        }
        else
        {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
               // self.ShowAd()
            })
            
        }
        addObserver()
//        showGoogleAds()
                if let _ = UserDefaults.standard.value(forKey: "accessToken") as? String{
//                    SocketIOManager.connectSocket()
                }
        let title = (fireBaseGlobalModel[index!].t1?.n)! + " vs " + (fireBaseGlobalModel[index!].t2?.n)!
        self.setupNavigationBarTitle(title, navBG: "", leftBarButtonsType: [.backWhite], rightBarButtonsType: [])
        self.hideNavigationBar(false)
        setUpContainer()
        if (self.isKeyPresentInUserDefaults(key: "DeleteTime")){
            if let deleteTime = AppHelper.userDefaultsForKey(key: "DeleteTime") as? Int64{
                let timeinterval = Date().timeIntervalSince1970
                let timeinsecond = Int(timeinterval * 1000.0)
                if (Int64(timeinsecond) - deleteTime) > 86400000{ // 86400000
                    self.deleteMatchInfo() // save empty string to matchInfoData
                }
            }
        }
    }
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        self.ShowAd()
        //self.perform(#selector(self.ShowAd), with: nil, afterDelay: 3.0)
    }
        @objc func ShowAd()
        {
            if self.interstitialAds.isReady{
                self.interstitialAds.present(fromRootViewController: self)
                UserDefault.saveToUserDefault(value: (Date().timeIntervalSince1970+900) as AnyObject, key: "LastFullPageAdShowTimestamp")
            }
            
        }
    //MARK:- Swap Controller
    
    private func moveToNewController(newController: UIViewController)
    {
        self.currentViewC.willMove(toParentViewController: nil)
        self.transition(from: self.currentViewC, to: newController, duration: 0, options: .curveLinear, animations: nil)
        { (finished) in
            newController.view.frame = self.containerView.bounds
            self.currentViewC.removeFromParentViewController()
            newController.didMove(toParentViewController: self)
            self.currentViewC = newController
        }
    }
    
    private func setUpContainer(){
        currentViewC = self.childViewControllers[0]
    }
    
    private func setUpContainer(animatedBtn:UIButton, destinationClass:String){
        if !self.currentViewC.classNameString.contains(destinationClass){
            let viewC = self.storyboard?.instantiateViewController(withIdentifier: destinationClass)
            if LiveLineVC.className == destinationClass
            {
                (viewC as! LiveLineVC).CurrentMatch = index!
//                (viewC as! LiveLineVC).showGoogleAds()
//                (viewC as! LiveLineVC).loadFbBannerAd()
            }
            else if InfoVC.className == destinationClass
            {
                (viewC as! InfoVC).CurrentMatch = index!
                (viewC as! InfoVC).fbPath = self.fbPath
                (viewC as! InfoVC).currentMatchKey = fireBaseGlobalModel[index!].matchKey!
//                (viewC as! InfoVC).showNativeAd()
            }
            else if CommentryScorecardVC.className == destinationClass
            {
                (viewC as! CommentryScorecardVC).titleLbl = (fireBaseGlobalModel[index!].t1?.n)! + " vs " + (fireBaseGlobalModel[index!].t2?.n)!
                (viewC as! CommentryScorecardVC).matchKey = fireBaseGlobalModel[index!].mk!
                if let con = fireBaseGlobalModel[index!].con{
                    (viewC as! CommentryScorecardVC).matchStatus = con.mstus ?? ""
                }
                (viewC as! CommentryScorecardVC).isComingFromMatchLine = true
                (viewC as! CommentryScorecardVC).isCommentryAvailable = true
                
                
            }
            else
            {
//                (viewC as! GroupChatVC).CurrentMatch = index!
            }
            self.swapController(viewC: viewC!,setLblConstant:animatedBtn.frame.origin.x)
        }
    }
    private func setUpContainerr(destinationClass:String){
        //if !self.currentViewC.classNameString.contains(destinationClass){
            let viewC = self.storyboard?.instantiateViewController(withIdentifier: destinationClass)
            if LiveLineVC.className == destinationClass
            {
                (viewC as! LiveLineVC).CurrentMatch = index!
//                (viewC as! LiveLineVC).showGoogleAds()
//                (viewC as! LiveLineVC).loadFbBannerAd()
            }
            else if InfoVC.className == destinationClass
            {
                (viewC as! InfoVC).CurrentMatch = index!
                (viewC as! InfoVC).fbPath = self.fbPath
                (viewC as! InfoVC).currentMatchKey = fireBaseGlobalModel[index!].matchKey!
//                (viewC as! InfoVC).showNativeAd()
            }
            else if CommentryScorecardVC.className == destinationClass
            {
                (viewC as! CommentryScorecardVC).titleLbl = (fireBaseGlobalModel[index!].t1?.n)! + " vs " + (fireBaseGlobalModel[index!].t2?.n)!
                (viewC as! CommentryScorecardVC).matchKey = fireBaseGlobalModel[index!].mk!
                if let con = fireBaseGlobalModel[index!].con{
                    (viewC as! CommentryScorecardVC).matchStatus = con.mstus ?? ""
                }
                (viewC as! CommentryScorecardVC).isComingFromMatchLine = true
                (viewC as! CommentryScorecardVC).isCommentryAvailable = true
                
            }
            else if CommentayLiveLineVC.className == destinationClass
            {
                (viewC as! CommentayLiveLineVC).titleLbl = (fireBaseGlobalModel[index!].t1?.n)! + " vs " + (fireBaseGlobalModel[index!].t2?.n)!
                (viewC as! CommentayLiveLineVC).matchKey = fireBaseGlobalModel[index!].mk!
                if let con = fireBaseGlobalModel[index!].con{
                    (viewC as! CommentayLiveLineVC).matchStatus = con.mstus ?? ""
                }
                (viewC as! CommentayLiveLineVC).isComingFromMatchLine = true
                if let mk = fireBaseGlobalModel[index!].mk, mk != "0", mk != ""{
                    (viewC as! CommentayLiveLineVC).isCommentryAvailable = false
                }
                (viewC as! CommentayLiveLineVC).isCommentryAvailable = true
                (viewC as! CommentayLiveLineVC).CurrentMatch = index!
            }
            else if ScorecardLiveLine.className == destinationClass
            {
                (viewC as! ScorecardLiveLine).titleLbl = (fireBaseGlobalModel[index!].t1?.n)! + " vs " + (fireBaseGlobalModel[index!].t2?.n)!
                (viewC as! ScorecardLiveLine).matchKey = fireBaseGlobalModel[index!].mk!
                if let con = fireBaseGlobalModel[index!].con{
                    (viewC as! ScorecardLiveLine).matchStatus = con.mstus ?? ""
                }
                (viewC as! ScorecardLiveLine).isComingFromMatchLine = true
                if let mk = fireBaseGlobalModel[index!].mk, mk != "0", mk != ""{
                    (viewC as! ScorecardLiveLine).isCommentryAvailable = false
                }
                (viewC as! ScorecardLiveLine).isCommentryAvailable = true
                (viewC as! ScorecardLiveLine).CurrentMatch = index!

            }
            else
            {
//                (viewC as! GroupChatVC).CurrentMatch = index!
            }
            self.addChildViewController(viewC!)
            self.moveToNewController(newController: viewC!)
        //}
    }
    private func swapController(viewC:UIViewController,setLblConstant:CGFloat){
        UIView.animate(withDuration: 0.5, animations: {
            if self.tabView1.isHidden == false{
                self.viewSelectedLeadingConstraint.constant = setLblConstant
            }
            else{
                self.viewSelectedLeadingConstraint1.constant = setLblConstant
            }
            self.view.layoutIfNeeded()
        })
        self.addChildViewController(viewC)
        self.moveToNewController(newController: viewC)
    }
    //MARK:- IBAction
    //MARK:- TODO move to commentry
    override func backButtonTapped() {
        super.backButtonTapped()
        print("backButtonTapped")
        removeObserver()
        if UserDefaults.standard.value(forKey: "accessToken") != nil
        {
            chatGlobalArr.removeAll()
        }

    }
    override func threeDotTaped() {
        let vc = AppStoryboard.main.instantiateViewController(withIdentifier: "CommentryScorecardVC") as! CommentryScorecardVC
        vc.titleLbl = (fireBaseGlobalModel[index!].t1?.n)! + " vs " + (fireBaseGlobalModel[index!].t2?.n)!
        vc.matchKey = fireBaseGlobalModel[index!].mk!
        
        vc.isComingFromMatchLine = true
        vc.isCommentryAvailable = true
        if let con = fireBaseGlobalModel[index!].con{
            vc.matchStatus = con.mstus ?? ""
        }
        let newNav = UINavigationController(rootViewController: vc)
        self.present(newNav, animated: true, completion: nil)
        
    }
    @IBAction func liveLineBtnAction(_ sender: UIButton) {
        self.setUpContainer(animatedBtn: sender, destinationClass: LiveLineVC.className)
    }
    
    @IBAction func InfoBtnAction(_ sender: UIButton) {
        self.setUpContainer(animatedBtn: sender, destinationClass: InfoVC.className)
    }
    
//    @IBAction func chatBtnAction(_ sender: UIButton) {
//        self.setUpContainer(animatedBtn: sender, destinationClass: GroupChatVC.className)
//    }
    
    @IBAction func liveLine1BtnAction(_ sender: UIButton){
        self.setUpContainer(animatedBtn: sender, destinationClass: LiveLineVC.className)
    }
    
    @IBAction func Info1BtnAction(_ sender: UIButton){
        self.setUpContainer(animatedBtn: sender, destinationClass: InfoVC.className)
    }
    
//    @IBAction func chat1BtnAction(_ sender: UIButton){
//        self.setUpContainer(animatedBtn: sender, destinationClass: GroupChatVC.className)
//    }
    
    @IBAction func scoreBtnAction(_ sender: UIButton){
        //self.setUpContainer(animatedBtn: sender, destinationClass: CommentryScorecardVC.className)
        let vc = AppStoryboard.main.instantiateViewController(withIdentifier: "CommentryScorecardVC") as! CommentryScorecardVC
        vc.titleLbl = (fireBaseGlobalModel[index!].t1?.n)! + " vs " + (fireBaseGlobalModel[index!].t2?.n)!
        vc.matchKey = fireBaseGlobalModel[index!].mk!
        vc.isComingFromMatchLine = true
        vc.isCommentryAvailable = true
        if let con = fireBaseGlobalModel[index!].con{
            vc.matchStatus = con.mstus ?? ""
        }
        let newNav = UINavigationController(rootViewController: vc)
        self.present(newNav, animated: true, completion: nil)
//        SocketIOManager.disconnectSocket()
    }
}
extension MatchLineVC:GADBannerViewDelegate
{
    // AdMob banner available
    func adViewDidReceiveAd(_ view: GADBannerView) {
        //bannerHeight.constant = 50.0
    }
    
    // NO AdMob banner available
    func adView(_ view: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        //bannerHeight.constant = 0.0
        //showGoogleAds()
        loadBannerAd()
    }
}
//MARK: CollectionView DataSource
extension MatchLineVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return collectionArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LabelCell", for: indexPath) as! LabelCell
        cell.lblTitle.text = collectionArray[indexPath.row]
        if indexPath.item == 0{
            cell.lblLine.isHidden = false
            self.setUpContainerr(destinationClass: LiveLineVC.className)
//            SocketIOManager.disconnectSocket()
        }else{
            cell.lblLine.isHidden = true
        }
        return cell
    }
}
//MARK: CollectionView Flowlayout Delegate
extension MatchLineVC:UICollectionViewDelegateFlowLayout   {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (self.collectionArray[indexPath.row] as String).size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16.0)])
        return CGSize(width: size.width + 28.0, height: size.height + 34.0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            
            self.setUpContainerr(destinationClass: LiveLineVC.className)
        case 1:
            self.setUpContainerr(destinationClass: InfoVC.className)
        case 23:
//            self.setUpContainerr(destinationClass: GroupChatVC.className)
            print("ASDASDASDASDASDA")
        case 2:
            self.setUpContainerr(destinationClass: CommentayLiveLineVC.className)
        default:
            self.setUpContainerr(destinationClass: ScorecardLiveLine.className)
        }
        underlineSet(itemindex: indexPath.item)
    }
}
//MARK: - Extension for Underline function

extension MatchLineVC{
    func underlineSet(itemindex:Int){
        let indexpathh0 = IndexPath(row: 0, section: 0)
        guard let cell0 = self.collectionVw.cellForItem(at: indexpathh0) as? LabelCell else{ fatalError("unexpectedIndexPath")
            
        }
        let indexpathh1 = IndexPath(row: 1, section: 0)
        guard let cell1 = self.collectionVw.cellForItem(at: indexpathh1) as? LabelCell else{ fatalError("unexpectedIndexPath")
            
        }
        let indexpathh2 = IndexPath(row: 2, section: 0)
        guard let cell2 = self.collectionVw.cellForItem(at: indexpathh2) as? LabelCell else{ fatalError("unexpectedIndexPath")
            
        }
        let indexpathh3 = IndexPath(row: 3, section: 0)
        guard let cell3 = self.collectionVw.cellForItem(at: indexpathh3) as? LabelCell else{ fatalError("unexpectedIndexPath")
            
        }
//        let indexpathh4 = IndexPath(row: 4, section: 0)
//        guard let cell4 = self.collectionVw.cellForItem(at: indexpathh4) as? LabelCell else{ fatalError("unexpectedIndexPath")
//
//        }
        
        if itemindex == 0{
            cell0.lblLine.isHidden = false
            self.collectionVw.scrollToItem(at: indexpathh0, at: .left, animated: true)
            cell1.lblLine.isHidden = true
            cell2.lblLine.isHidden = true
            cell3.lblLine.isHidden = true
//            cell4.lblLine.isHidden = true

        }
        else if itemindex == 1{
            cell1.lblLine.isHidden = false
            self.collectionVw.scrollToItem(at: indexpathh1, at: .left, animated: true)
            cell0.lblLine.isHidden = true
            cell2.lblLine.isHidden = true
            cell3.lblLine.isHidden = true
//            cell4.lblLine.isHidden = true

        }
        else if itemindex == 2{
            cell2.lblLine.isHidden = false
            self.collectionVw.scrollToItem(at: indexpathh2, at: .left, animated: true)
            cell0.lblLine.isHidden = true
            cell1.lblLine.isHidden = true
            cell3.lblLine.isHidden = true
//            cell4.lblLine.isHidden = true
        }
        else if itemindex == 3{
            cell3.lblLine.isHidden = false
            self.collectionVw.scrollToItem(at: indexpathh3, at: .left, animated: true)
            cell0.lblLine.isHidden = true
            cell2.lblLine.isHidden = true
            cell1.lblLine.isHidden = true
//            cell4.lblLine.isHidden = true

        }
//        else{
//            cell4.lblLine.isHidden = false
//            self.collectionVw.scrollToItem(at: indexpathh4, at: .left, animated: true)
//            cell0.lblLine.isHidden = true
//            cell2.lblLine.isHidden = true
//            cell1.lblLine.isHidden = true
//            cell3.lblLine.isHidden = true
//        }
    }
}

extension MatchLineVC{
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    private func deleteMatchInfo(){
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
                
                apiDataObj.matchInfoData = ""
            }
            else
            {
                for item in items
                {
                    item.matchInfoData = ""
                }
            }
            try context.save()
        }
        catch
        {
            
        }
    }
}

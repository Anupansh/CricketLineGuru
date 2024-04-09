//
//  RUMatchVC.swift
//  CLG
//
//  Created by Sani Kumar on 16/08/19.
//  Copyright © 2019 Anuj Naruka. All rights reserved.
//

import UIKit
import GoogleMobileAds


class RUMatchVC: BaseViewController,GADInterstitialDelegate {

    //MARK:- Variables & Constants
    var currentViewC: UIViewController!
    var fbNode: String?
    var index: Int?
    lazy var fbPath: String = {
        let fbPath = String()
        return fbPath
    }()
    
    //MARK:- IBOutlets
    @IBOutlet weak var tabView: UIView!
    @IBOutlet weak var btnRecent: UIButton!
    @IBOutlet weak var btnUpcoming: UIButton!
    @IBOutlet weak var lblSelected: UILabel!
    @IBOutlet weak var lblSelectedLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var gadBannerView: GADBannerView!
    @IBOutlet weak var bannerHeight: NSLayoutConstraint!
    var interstitialAds: GADInterstitial!
    var bannerAdView: FBAdView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let viewC = self.childViewControllers[0] as? RecentMatchVC
        {
            
        }
        self.loadFbBannerAd()
        self.btnRecent.setTitleColor(.white, for: .normal)
        self.btnUpcoming.setTitleColor(.gray, for: .normal)
        self.setUpContainer(animatedBtn: self.btnRecent, destinationClass: RecentMatchVC.className)
        self.navigationController?.navigationBar.isHidden = true
        FireBaseHomeObservers().removeObservers(ref:AppHelper.appDelegate().ref)
        let notificationCenterr = NotificationCenter.default
        notificationCenterr.addObserver(self,
                                        selector: #selector(self.refreshBadgeCount),
                                        name: .refreshBadgeCount,
                                        object: nil)
        if AppHelper.appDelegate().ref != nil{
            FireBaseMatchStatusObservers().setMatchStatusObserver(ref: AppHelper.appDelegate().ref)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        FireBaseMatchStatusObservers().removeMatchStatusObservers(ref: AppHelper.appDelegate().ref)

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
                else{
                    
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
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        loadBannerAd()
    }
    //MARK:-Func
    
    //MARK:-Functions
    
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
    }
    func interstitialWillDismissScreen(_ ad: GADInterstitial){
    }
    private func setUp()
    {
        let appDel = UIApplication.shared.delegate as! AppDelegate
        if appDel.interstitialAds.isReady {
            appDel.interstitialAds.present(fromRootViewController: self)
            appDel.interstitialAds = nil
            appDel.interstitialAds = appDel.createAndLoadInterstitial()
        }
        if (appDel.fbInterstitialAd != nil) && appDel.fbInterstitialAd.isAdValid && appDel.toShowInterstitial {
            appDel.fbInterstitialAd.show(fromRootViewController: self)
            appDel.fbInterstitialAd = nil
            appDel.fbInterstitialAd = appDel.loadInterstitialFbAd()
            appDel.toShowInterstitial = false
            appDel.runTimer()
        }
//        self.interstitialAds = createAndLoadInterstitial()
        setUpContainer()
    }
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        self.ShowAd()
    }
    @objc func ShowAd()
    {
        if self.interstitialAds.isReady{
            self.interstitialAds.present(fromRootViewController: self)
            UserDefault.saveToUserDefault(value: (Date().timeIntervalSince1970+900) as AnyObject, key: "LastFullPageAdShowTimestamp")
        }
        
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
            if RecentMatchVC.className == destinationClass
            {
                
            }
            else if UpcomingMatchesVC.className == destinationClass
            {
            
            }
            self.swapController(viewC: viewC!,setLblConstant:animatedBtn.frame.origin.x)
        }
    }
    
    private func swapController(viewC:UIViewController,setLblConstant:CGFloat){
        UIView.animate(withDuration: 0.5, animations: {
            self.lblSelectedLeadingConstraint.constant = setLblConstant
            self.view.layoutIfNeeded()
        })
        self.addChildViewController(viewC)
        self.moveToNewController(newController: viewC)
    }
    
    @IBAction func recentBtnAction(_ sender: UIButton) {
        self.btnRecent.setTitleColor(.white, for: .normal)
        self.btnUpcoming.setTitleColor(.gray, for: .normal)
        self.setUpContainer(animatedBtn: sender, destinationClass: RecentMatchVC.className)
    }
    
    @IBAction func upcomingBtnAction(_ sender: UIButton) {
        self.btnRecent.setTitleColor(.gray, for: .normal)
        self.btnUpcoming.setTitleColor(.white, for: .normal)
        self.setUpContainer(animatedBtn: sender, destinationClass: UpcomingMatchesVC.className)
    }
    
}



//
//  SettingVC.swift
//  CLG
//
//  Created by Anuj Naruka on 8/28/18.
//  Copyright © 2018 Anuj Naruka. All rights reserved.
//

import GoogleMobileAds
import UIKit
import FirebaseMessaging
import FBAudienceNetwork


class SettingVC: BaseViewController {

    @IBOutlet weak var tvSettingMenu: UITableView!
    @IBOutlet weak var gadBannerView: GADBannerView!
    @IBOutlet weak var bannerHeight: NSLayoutConstraint!
    @IBOutlet weak var versionLbl: UILabel!

    var interstitialAds: GADInterstitial!
    var bannerAdView: FBAdView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadFbBannerAd()
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
//        self.interstitialAds = self.createAndLoadInterstitial()
        //self.ShowAd()
        setUp()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    private func setUp()
    {
        self.interstitialAds = createAndLoadInterstitial()
//        showGoogleAds()
        let version = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "0"
        versionLbl.text = "Version \(version)"
        self.setupNavigationBarTitle("SETTINGS", navBG: "", leftBarButtonsType: [.back], rightBarButtonsType: [])
        self.hideNavigationBar(false)
        tvSettingMenu.tableFooterView = UIView()
        tvSettingMenu.registerMultiple(nibs: [MoreHeaderCell.className])

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
    private func createAndLoadInterstitial() -> GADInterstitial{
        let interstitial =
            GADInterstitial(adUnitID: AppHelper.appDelegate().adInterstitialUnitID)
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    @objc func ShowAd(){
        let random = arc4random_uniform(1000) + 10
        //if (random % 2) == 0{
            if self.interstitialAds.isReady
            {
                self.interstitialAds.present(fromRootViewController: self)
            }
        //}
    }
    
    @objc func NotificationSwitch(_ sender:UISwitch)
    {
        if sender.isOn
        {
            UserDefault.saveToUserDefault(value: true as AnyObject, key: "isNotificationOn")
            Messaging.messaging().subscribe(toTopic: "match")
            Messaging.messaging().subscribe(toTopic: "topic_ios")
            Messaging.messaging().subscribe(toTopic: "topic_all_match_app")

        }
        else
        {
            UserDefault.saveToUserDefault(value: false as AnyObject, key: "isNotificationOn")
            Messaging.messaging().unsubscribe(fromTopic: "match")
            Messaging.messaging().unsubscribe(fromTopic: "topic_ios")
            Messaging.messaging().unsubscribe(fromTopic: "topic_all_match_app")
        }
    }
    @objc func EngLangBtn(_ sender:UIButton)
    {
        UserDefault.saveToUserDefault(value: "ENG" as AnyObject, key: "AudioLanguage")
        let indexPath = IndexPath(row: sender.tag, section: 0)
        self.tvSettingMenu.reloadRows(at: [indexPath], with: .automatic)
    }
    @objc func HinLangBtn(_ sender:UIButton)
    {
        UserDefault.saveToUserDefault(value: "HIN" as AnyObject, key: "AudioLanguage")
        let indexPath = IndexPath(row: sender.tag, section: 0)
        self.tvSettingMenu.reloadRows(at: [indexPath], with: .automatic)
    }
}

// MARK: TableView DataSource & Delegate

extension SettingVC:UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3,
            let ShowUpdateBtn = UserDefault.userDefaultForAny(key: "ShowUpdateBtn") as? String,
            ShowUpdateBtn == "1"
        {
            let url  = NSURL(string: "https://itunes.apple.com/in/app/cricket-line-guru/id1247859253?mt=8")
            if UIApplication.shared.canOpenURL(url! as URL) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url! as URL)
                } else {
                    // Fallback on earlier versions
                    UIApplication.shared.openURL(url! as URL)
                }
            }
            else
            {
                Drop.down("Unable to open Appstore")
            }
        }
        else
        {
            let updateUsernameView  = Bundle.main.loadNibNamed("DropDownMenu", owner: self, options: nil)! [2] as! UsernameChange
            updateUsernameView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            self.view.addSubview(updateUsernameView)
            updateUsernameView.customUI()
            updateUsernameView.delegate = self
            updateUsernameView.showPopup()

        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return indexPath.row == 0 ? 18 : 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var count = 3
        if let ShowUpdateBtn = UserDefault.userDefaultForAny(key: "ShowUpdateBtn") as? String
        {
            count = ShowUpdateBtn == "1" ? (count+1) : count
        }
        if AppHelper.userDefaultsForKey(key: "userName") as? String != nil
        {
            count = (count+1)
        }
        return count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if indexPath.row == 0
        {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: MoreHeaderCell.className, for: indexPath) as? MoreHeaderCell else {
                fatalError("unexpectedIndexPath")
            }
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.row == 1
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "LanguageCell") as! LanguageCell
            if UserDefault.userDefaultForAny(key: "AudioLanguage") as! String == "ENG"
            {
                cell.btnEngLang.backgroundColor = AppColors.appBlueColor
                cell.btnEngLang.setTitleColor(UIColor.white, for: .normal)
                cell.btnHinLang.backgroundColor = UIColor.white
                cell.btnHinLang.setTitleColor(AppColors.appBlueColor, for: .normal)
            }
            else
            {
                cell.btnHinLang.backgroundColor = AppColors.appBlueColor
                cell.btnHinLang.setTitleColor(UIColor.white, for: .normal)
                cell.btnEngLang.backgroundColor = UIColor.white
                cell.btnEngLang.setTitleColor(AppColors.appBlueColor, for: .normal)
            }
            cell.btnEngLang.tag = indexPath.row
            cell.btnHinLang.tag = indexPath.row
            cell.btnEngLang.addTarget(self, action: #selector(self.EngLangBtn(_:)), for: .touchUpInside)
            cell.btnHinLang.addTarget(self, action: #selector(self.HinLangBtn(_:)), for: .touchUpInside)

            return cell
        }
        else if indexPath.row == 2
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingNotificationCell") as! SettingNotificationCell
            cell.btnswitch.addTarget(self, action: #selector(self.NotificationSwitch(_:)), for: .valueChanged)
            if let flag = UserDefaults.getAnyDataFromUserDefault(key: "isNotificationOn") as? Bool
            {
                cell.btnswitch.isOn = flag
            }
            return cell
        }
        else if indexPath.row == 3,
            let ShowUpdateBtn = UserDefault.userDefaultForAny(key: "ShowUpdateBtn") as? String,
            ShowUpdateBtn == "1"
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell") as! SettingCell
            cell.lblTitle.text = "Update"
            cell.imgView.image = #imageLiteral(resourceName: "download")
            cell.lblValue.text = ""
            return cell
        }
        else 
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell") as! SettingCell
            cell.lblTitle.text = "Change username"
            cell.imgView.image = #imageLiteral(resourceName: "user")
            cell.lblValue.text = AppHelper.userDefaultsForKey(key: "userName") as? String ?? ""
            return cell
        }
        return UITableViewCell()
    }
}
extension SettingVC:GADBannerViewDelegate
{
    // AdMob banner available
    func adViewDidReceiveAd(_ view: GADBannerView) {
        //bannerHeight.constant = 50.0
    }
    
    // NO AdMob banner available
    func adView(_ view: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        //bannerHeight.constant = 0.0
        loadBannerAd()
    }
}
extension SettingVC:GADInterstitialDelegate{
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial){
        self.ShowAd()
        //self.perform(#selector(self.ShowAd), with: nil, afterDelay: 3.0)
    }
}
extension SettingVC:RefreshSettings
{
    func refresh()
    {
        self.tvSettingMenu.reloadData()
    }
}

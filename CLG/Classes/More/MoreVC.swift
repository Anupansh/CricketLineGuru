//
//  MoreVC.swift
//  cricrate
//
//  Created by Anuj Naruka on 6/18/18.
//  Copyright © 2018 Cricket Line Guru. All rights reserved.
//

import UIKit
import MessageUI
import StoreKit
import GoogleMobileAds
import FirebaseMessaging

class MoreVC: BaseViewController
{
    //MARK:- IBOutlets
    
    @IBOutlet weak var tvSideMenu: UITableView!
    @IBOutlet weak var gadBannerView: GADBannerView!
    @IBOutlet weak var bannerHeight: NSLayoutConstraint!

    var bannerAdView : FBAdView!
    
    //MARK:- Properties

    //private let nameArr = ["","Browse Series","Browse Team","Browse Player","","Ranking","News","","Rate Us","Feedback","","Settings","Terms Of Use","Privacy Policies"]
    
    private let nameArr = ["","Browse Series","Browse Team","Browse Player","","Ranking","News","","YouTube","Instagram","Facebook","","Rate Us","Feedback","","Settings","Terms Of Use","Privacy Policies"]
    
    //private let imageArr = ["","series","team","player","","ranking","news","","rateus","feedback","","setting","disclaimer","disclaimer"]
    
    private let imageArr = ["","series","team","player","","ranking","news","","youtubeNew","instagram","facebook","","rateus","feedback","","setting","disclaimer","disclaimer"]
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var interstitialAds: GADInterstitial!


    //MARK:-Override Methods
    
    override func viewDidLoad(){
        super.viewDidLoad()
        setUp()
        self.loadFbBannerAd()
        tvSideMenu.registerMultiple(nibs: [MoreNameCell.className,MoreHeaderCell.className])
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    //MARK:- Functions
    
    private func setUp(){
//        showGoogleAds()
        self.setupNavigationBarTitle("MORE", navBG: "", leftBarButtonsType: [], rightBarButtonsType: [])
        self.hideNavigationBar(false)
        tvSideMenu.estimatedRowHeight = 80
        tvSideMenu.tableFooterView = UIView()
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

    }
    private func showGoogleAds(){
//        self.gadBannerView.adUnitID = AppHelper.appDelegate().adBannerUnitID as String
//        self.gadBannerView.rootViewController = self
        //self.gadBannerView.load(GADRequest())
        self.gadBannerView.delegate = self
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        loadBannerAd()
    }
    //MARK:-Func
    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to:size, with:coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.loadBannerAd()
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
    
    private func composeMail(){
        if !MFMailComposeViewController.canSendMail() {
            Drop.down("CANNOT_SEND_MAIL")
            return
        }
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        composeVC.setToRecipients([AppHelper.appDelegate().feedbackEmail])
        composeVC.setSubject(AppHelper.appDelegate().feedbackSubject)
        var txtMessageBody : NSString = "\(AppHelper.appDelegate().feedbackMsg)\n" as NSString
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            txtMessageBody = String(format:"\n\n\n--------\n%@ - %@", "CRICKET_LINE_GURU_VERSION_TITLE".localizedString, version) as NSString
        }
        if let bundle = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            txtMessageBody = (txtMessageBody as String) + String(format: "\n%@ - %@", "BUNDLE_VERSION_TITLE".localizedString, bundle) as NSString
        }
        let Device = UIDevice.current
        if let iosVersion = NSString(string: Device.systemVersion) as? String{
            txtMessageBody = (txtMessageBody as String) + String(format: "\n%@ - %@", "IOS_VERSION_TITLE".localizedString, iosVersion) as NSString
        }
        var modelName: String {
            var systemInfo = utsname()
            uname(&systemInfo)
            let machineMirror = Mirror(reflecting: systemInfo.machine)
            let identifier = machineMirror.children.reduce("") { identifier, element in
                guard let value = element.value as? Int8, value != 0 else { return identifier }
                return identifier + String(UnicodeScalar(UInt8(value)))
            }
            switch identifier {
            case "iPod5,1":                                 return "iPod Touch 5"
            case "iPod7,1":                                 return "iPod Touch 6"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
            case "iPhone4,1":                               return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
            case "iPhone7,2":                               return "iPhone 6"
            case "iPhone7,1":                               return "iPhone 6 Plus"
            case "iPhone8,1":                               return "iPhone 6s"
            case "iPhone8,2":                               return "iPhone 6s Plus"
            case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
            case "iPhone8,4":                               return "iPhone SE"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
            case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
            case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
            case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
            case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
            case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
            case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":return "iPad Pro"
            case "AppleTV5,3":                              return "Apple TV"
            case "i386", "x86_64":                          return "Simulator"
            default:                                        return identifier
            }
        }
        txtMessageBody = (txtMessageBody as String) + String(format: "\n%@ - %@", "DEVICE_MODEL_TITLE".localizedString, modelName) as NSString
        
        composeVC.setMessageBody(txtMessageBody as String, isHTML: false)
        self.present(composeVC, animated: true, completion: nil)
    }
    
    // MARK: - IBActions
    
    @IBAction func UpdateBtnAction(_ sender: Any){
        let url  = NSURL(string: "https://itunes.apple.com/in/app/cricket-line-guru/id1247859253?mt=8")
            if UIApplication.shared.canOpenURL(url! as URL) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url! as URL)
            } else {
                UIApplication.shared.openURL(url! as URL)
            }
        }else{
            Drop.down("Unable to open Appstore")
        }
    }
}

// MARK: TableView DataSource & Delegate

extension MoreVC:UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return nameArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        switch indexPath.row {
//        case 0,4,7,10:
//            return 18.0
//        default:
//            return 50.0
//        }
        case 0,4,7,11,14:
            return 18.0
        default:
            return 50.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        switch indexPath.row {
//        case 0,4,7,10:
//            return self.getHeaderCell(indexPath, tableView: tableView)
//        default:
//            return self.getNameCell(indexPath, tableView: tableView)
//        }
        case 0,4,7,11,14:
            return self.getHeaderCell(indexPath, tableView: tableView)
        default:
            return self.getNameCell(indexPath, tableView: tableView)
        }
    }
    
    private func getHeaderCell( _ indexPath : IndexPath, tableView : UITableView) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MoreHeaderCell.className, for: indexPath) as? MoreHeaderCell else {
            fatalError("unexpectedIndexPath")
        }
        cell.selectionStyle = .none
        return cell
    }
    
    private func getNameCell( _ indexPath : IndexPath, tableView : UITableView) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MoreNameCell.className, for: indexPath) as? MoreNameCell else {
            fatalError("unexpectedIndexPath")
        }
        cell.setData(name: self.nameArr[indexPath.row], imgName: self.imageArr[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 1:
            let seasonSeriesVC = AppStoryboard.module2.instantiateViewController(withIdentifier: "SeasonSeriesVC") as! SeasonSeriesVC
            self.navigationController?.pushViewController(seasonSeriesVC, animated: true)
//            let newNav = UINavigationController(rootViewController: seasonSeriesVC)
//            self.present(newNav, animated: true, completion: nil)
        case 2:
            let browseTeamVC = AppStoryboard.browseTeam.instantiateViewController(withIdentifier: BrowseTeamVC.className)
            self.navigationController?.pushViewController(browseTeamVC, animated: true)
//            let newNav = UINavigationController(rootViewController: browseTeamVC)
//            self.present(newNav, animated: true, completion: nil)
        case 3:
            let browsePlayerVC = AppStoryboard.browsePlayer.instantiateViewController(withIdentifier: BrowsePlayerVC.className)
            self.navigationController?.pushViewController(browsePlayerVC, animated: true)
//            let newNav = UINavigationController(rootViewController: browsePlayerVC)
//            self.present(newNav, animated: true, completion: nil)
        case 5:
            let rankingVC = AppStoryboard.module2.instantiateViewController(withIdentifier: "RankingVC") as! RankingVC
            self.navigationController?.pushViewController(rankingVC, animated: true)
//            let newNav = UINavigationController(rootViewController: rankingVC)
//            self.present(newNav, animated: true, completion: nil)
        case 6:
            let latestNewsVC = AppStoryboard.main.instantiateViewController(withIdentifier: "LatestNewsVC") as! LatestNewsVC
            self.navigationController?.pushViewController(latestNewsVC, animated: true)
//            let newNav = UINavigationController(rootViewController: latestNewsVC)
//            self.present(newNav, animated: true, completion: nil)
        /*case 7:
            let addView = DisclemerView.instansiateFromNib()
            addView.frame = (appDelegate.window?.bounds)!
            addView.customUI(isTips:true)
            appDelegate.window?.addSubview(addView)*/
        case 8:
            let url  = NSURL(string: "https://www.youtube.com/channel/UC0rsX2Muv6TQHMaLwvZe3nQ")
            if UIApplication.shared.canOpenURL(url! as URL) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url! as URL)
                } else {
                    UIApplication.shared.openURL(url! as URL)
                }
            }else{
                Drop.down("Unable to open Appstore")
            }
        case 9:
            let url  = NSURL(string: "https://www.instagram.com/cricketlineguru.in/?hl=en")
            if UIApplication.shared.canOpenURL(url! as URL) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url! as URL)
                } else {
                    UIApplication.shared.openURL(url! as URL)
                }
            }else{
                Drop.down("Unable to open Appstore")
            }
        case 10:
            let url  = NSURL(string: "https://www.facebook.com/cricketlineguru.in/")
            if UIApplication.shared.canOpenURL(url! as URL) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url! as URL)
                } else {
                    UIApplication.shared.openURL(url! as URL)
                }
            }else{
                Drop.down("Unable to open Appstore")
            }
        case 12:
            let url  = NSURL(string: "https://itunes.apple.com/us/app/cricket-lineguru/id1247859253?ls=1&mt=8")
            if UIApplication.shared.canOpenURL(url! as URL) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url! as URL)
                } else {
                    UIApplication.shared.openURL(url! as URL)
                }
            }else{
                Drop.down("Unable to open Appstore")
            }
        case 13:
            self.composeMail()
        case 15:
            let seasonSeriesVC = AppStoryboard.main.instantiateViewController(withIdentifier: "SettingVC") as! SettingVC
            self.navigationController?.pushViewController(seasonSeriesVC, animated: true)
//            let newNav = UINavigationController(rootViewController: seasonSeriesVC)
//            self.present(newNav, animated: true, completion: nil)

        case 16:
//            let addView = DisclemerView.instansiateFromNib()
//            addView.frame = (appDelegate.window?.bounds)!
//            addView.customUI(isTips:false)
//            appDelegate.window?.addSubview(addView)
            let seasonSeriesVC = AppStoryboard.main.instantiateViewController(withIdentifier: "TermsOfUseVC") as! TermsOfUseVC
            self.navigationController?.pushViewController(seasonSeriesVC, animated: true)
//            let newNav = UINavigationController(rootViewController: seasonSeriesVC)
//            self.present(newNav, animated: true, completion: nil)
            
        case 17:
            let seasonSeriesVC = AppStoryboard.main.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
            self.navigationController?.pushViewController(seasonSeriesVC, animated: true)
//            let newNav = UINavigationController(rootViewController: seasonSeriesVC)
//            self.present(newNav, animated: true, completion: nil)
            default:
            print("default")
//            let seasonSeriesVC = AppStoryboard.main.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
//            let newNav = UINavigationController(rootViewController: seasonSeriesVC)
//            self.present(newNav, animated: true, completion: nil)
        }
    }
}

extension MoreVC:MFMailComposeViewControllerDelegate{
    
    func mailComposeController(_ controller: MFMailComposeViewController,
                               didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
extension MoreVC:GADBannerViewDelegate
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
extension MoreVC:GADInterstitialDelegate{
    
    func interstitialDidReceiveAd(_ ad: GADInterstitial){
        self.ShowAd()
        //self.perform(#selector(self.ShowAd), with: nil, afterDelay: 3.0)
    }
}

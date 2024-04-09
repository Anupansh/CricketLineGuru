//
//  PollScreenVC.swift
//  cricrate
//
//  Created by Anuj Naruka on 7/28/17.
//  Copyright © 2017 Cricket Line Guru. All rights reserved.
//

import UIKit
import GoogleMobileAds
import CoreData
import Firebase

class PollScreenVC: BaseViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,GADBannerViewDelegate {
    
    //MARK:- IBOutlets
    @IBOutlet weak var reloadBtn: UIButton!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var pageControllerTopSpace: NSLayoutConstraint!
    @IBOutlet weak var pollsCollectionView: UICollectionView!
    @IBOutlet weak var noPollsLbl: UILabel!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var removeAddViewBtn: UIButton!

    @IBOutlet weak var constraintAspect: NSLayoutConstraint!
    
    //MARK:- Variables & Constants
    var nativeAds = [GADUnifiedNativeAd]()
    let addView = DropDownView.instansiateFromNib()
    var dropDownFrame = CGFloat()
    var isEditSelected = Bool()
    var interstitialAds: GADInterstitial!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    internal var pollsData = [CLGPollsModel]()
    internal var selectedPollId = String()
    internal var selectedPoll = Int()
    internal var selectedTeam = 0
    internal var currentIndex:Int = 0
    var teamsPathUrl = String()
    var bannerAdView : FBAdView!
    //MARK:View life cycle
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        if (UserDefaults.standard.value(forKey: "accessToken") as? String) != nil
        {
            //self.setupNavigationBarTitle("LINEGURU POLLS", navBG: "", leftBarButtonsType: [], rightBarButtonsType: [.threeDot])
            self.setupNavigationBarTitle("LINEGURU POLLS", navBG: "", leftBarButtonsType: [], rightBarButtonsType: [])

        }
        else
        {
            self.setupNavigationBarTitle("LINEGURU POLLS", navBG: "", leftBarButtonsType: [], rightBarButtonsType: [])
        }
        self.pageController.numberOfPages = 0
        self.pageController.currentPage = 0
        self.pageController.pageIndicatorTintColor = UIColor.lightGray
        self.pageController.currentPageIndicatorTintColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        noPollsLbl.isHidden = true
        self.pollsCollectionView.register(UINib(nibName: "PollsCell", bundle: nil), forCellWithReuseIdentifier: "PollsCell")
        self.pollsCollectionView.register(UINib(nibName: "PollsAdCell", bundle: nil), forCellWithReuseIdentifier: "PollsAdCell")
        pageController.addTarget(self, action: #selector(pageControlTapHandler(sender:)), for: .valueChanged)
//        GIDSignIn.sharedInstance().uiDelegate = self
//        GIDSignIn.sharedInstance().delegate = self
//        self.interstitialAds = self.createAndLoadInterstitial()
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
//        showGoogleAds()
        self.loadFbBannerAd()
        //self.ShowAd()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if UIDevice.isPad{
            self.constraintAspect.constant = 120.0
        }
        else{
            self.constraintAspect.constant = 0.0
        }
        self.view.updateConstraints()
    }
    
    override func threeDotTaped() {
        setupChooseDropDown()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //getAllPollData()
        getTheActivePoll()
        showNativeAd()
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
        addView.removeFromSuperview()
        self.noPollsLbl.isHidden = true
        isEditSelected = true
        FireBaseMatchStatusObservers().removeMatchStatusObservers(ref: AppHelper.appDelegate().ref)

    }
    
    @objc func showNativeAd(){
        nativeAds = AppHelper.appDelegate().returnNativeAdArray()
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
    private func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial =
            GADInterstitial(adUnitID: AppHelper.appDelegate().adInterstitialUnitID)
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
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
    //MARK:- Three Dot Function
    private func setupChooseDropDown() {
            if isEditSelected == false
            {
                addView.removeFromSuperview()
                isEditSelected = true
                if ScreenSize.SCREEN_HEIGHT == 812{
                    self.addView.frame = CGRect(x: self.view.frame.width-170, y: 88, width: 165, height: 90)
                }
                else
                {
                    self.addView.frame = CGRect(x: self.view.frame.width-170, y: 64, width: 165, height: 90)
                }
                dropDownFrame = self.addView.frame.origin.y
                addView.cutomize()
                self.addView.gameMode = ["Top 20 Pollers","My Poll Accuracy"]
                addView.reloadTbView()
                self.view.layoutIfNeeded()
                self.removeAddViewBtn.isHidden = false
                (UIApplication.shared.delegate as! AppDelegate).window?.addSubview(addView)
                addView.animateView()
            }
            else
            {
                isEditSelected = false
                self.removeAddViewBtn.isHidden = true
                addView.closeAnimateView()
                self.view.layoutIfNeeded()
            }
    }
    
    //MARK:-IBActions
    @IBAction func reloadBtnAction(_ sender: Any) {
       // getAllPollData()
        getTheActivePoll()
    }
    @IBAction func removeAddViewBtnAct(_ sender: Any)
    {
        addView.closeAnimateView()
        self.removeAddViewBtn.isHidden = true
    }
    func showGoogleAds(){
        self.bannerView.adUnitID = appDelegate.adBannerUnitID as String
        self.bannerView.rootViewController = self
        //self.bannerView.load(GADRequest())
        self.bannerView.delegate = self
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
        
        bannerView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
        bannerView.load(GADRequest())
    }
    //MARK:- CollectionView DataSource and flowlayout
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if nativeAds.count > 0{
            self.pageController.numberOfPages = (self.pollsData.count + 1)
            if(self.pollsData.count == 1){
                self.pageController.isHidden = true
            }else{
                self.pageController.isHidden = false
            }
            return self.pollsData.count + 1
        }
        else{
            self.pageController.numberOfPages = (self.pollsData.count)
            if(self.pollsData.count == 1){
                self.pageController.isHidden = true
            }else{
                self.pageController.isHidden = false
            }
            return self.pollsData.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        if nativeAds.count > 0{
        if indexPath.item == self.pollsData.count{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PollsAdCell", for: indexPath) as! PollsAdCell
            if let adView = cell.nativeAdView{
                nativeAds[0].rootViewController = self
                adView.nativeAd = nativeAds[0]
                (adView.headlineView as! UILabel).text = nativeAds[0].headline
                (adView.bodyView as! UILabel).text = nativeAds[0].body
                (adView.advertiserView as! UILabel).text = nativeAds[0].advertiser
                (adView.callToActionView as! UIButton).isUserInteractionEnabled = false
                (adView.callToActionView as! UIButton).setTitle(
                    nativeAds[0].callToAction, for: UIControlState.normal)
                
            }
            return cell
            }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PollsCell", for: indexPath) as! PollsCell
            let pollSelected = returnTrueOrFalse(pollId: self.pollsData[indexPath.item]._id!)
            cell.pollselected = pollSelected
            cell.teamspath = self.teamsPathUrl
            cell.setData(data: self.pollsData[indexPath.item])
            
            if let matchDate = self.pollsData[indexPath.item].matchDate
            {
                if ((pollSelected == 0)  && matchDate > Date().toMillis()){
                    cell.SubmitBtn.addTarget(self, action: #selector(pollSubmitBtn(sender:)), for: .touchUpInside)
                    cell.SubmitBtn.tag = (indexPath.item*1000)+selectedPoll
                    cell.TeamTwoBtn.addTarget(self, action: #selector(TeamTwoBtn(sender:)), for: .touchUpInside)
                    cell.TeamTwoBtn.tag = indexPath.item
                    cell.TeamOneBtn.addTarget(self, action: #selector(TeamOneBtn(sender:)), for: .touchUpInside)
                    cell.TeamOneBtn.tag = indexPath.item
                    cell.TieBtn.addTarget(self, action: #selector(TieBtn(sender:)), for: .touchUpInside)
                    cell.TieBtn.tag = indexPath.item
                    if selectedPoll == 1{
                        selectedPoll = 0
                        cell.UIviewTieFill.isHidden = true
                        cell.UiviewTeamOneFill.isHidden = false
                        cell.UiviewTeamTwoFill.isHidden = true
                    }else if selectedPoll == 2{
                        selectedPoll = 0
                        cell.UIviewTieFill.isHidden = true
                        cell.UiviewTeamOneFill.isHidden = true
                        cell.UiviewTeamTwoFill.isHidden = false
                    }else if selectedPoll == 3{
                        selectedPoll = 0
                        cell.UIviewTieFill.isHidden = false
                        cell.UiviewTeamOneFill.isHidden = true
                        cell.UiviewTeamTwoFill.isHidden = true
                        
                    }
                }
                
            }
            return cell
            }
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PollsCell", for: indexPath) as! PollsCell
            let pollSelected = returnTrueOrFalse(pollId: self.pollsData[indexPath.item]._id!)
            cell.pollselected = pollSelected
            cell.teamspath = self.teamsPathUrl
            cell.setData(data: self.pollsData[indexPath.item])
            
            if let matchDate = self.pollsData[indexPath.item].matchDate
            {
                if ((pollSelected == 0)  && matchDate > Date().toMillis()){
                    cell.SubmitBtn.addTarget(self, action: #selector(pollSubmitBtn(sender:)), for: .touchUpInside)
                    cell.SubmitBtn.tag = (indexPath.item*1000)+selectedPoll
                    cell.TeamTwoBtn.addTarget(self, action: #selector(TeamTwoBtn(sender:)), for: .touchUpInside)
                    cell.TeamTwoBtn.tag = indexPath.item
                    cell.TeamOneBtn.addTarget(self, action: #selector(TeamOneBtn(sender:)), for: .touchUpInside)
                    cell.TeamOneBtn.tag = indexPath.item
                    cell.TieBtn.addTarget(self, action: #selector(TieBtn(sender:)), for: .touchUpInside)
                    cell.TieBtn.tag = indexPath.item
                    if selectedPoll == 1{
                        selectedPoll = 0
                        cell.UIviewTieFill.isHidden = true
                        cell.UiviewTeamOneFill.isHidden = false
                        cell.UiviewTeamTwoFill.isHidden = true
                    }else if selectedPoll == 2{
                        selectedPoll = 0
                        cell.UIviewTieFill.isHidden = true
                        cell.UiviewTeamOneFill.isHidden = true
                        cell.UiviewTeamTwoFill.isHidden = false
                    }else if selectedPoll == 3{
                        selectedPoll = 0
                        cell.UIviewTieFill.isHidden = false
                        cell.UiviewTeamOneFill.isHidden = true
                        cell.UiviewTeamTwoFill.isHidden = true
                        
                    }
                }
                
            }
            return cell
            }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize(width: collectionView.frame.width , height: collectionView.frame.height)
    }
    
    @objc func TeamTwoBtn(sender:UIButton){
        selectedPoll = 2
        pollsCollectionView.reloadData()
    }
    
    @objc func TeamOneBtn(sender:UIButton){
        selectedPoll = 1
        pollsCollectionView.reloadData()
    }
    
    @objc func TieBtn(sender:UIButton){
        selectedPoll = 3
        pollsCollectionView.reloadData()
    }
    
    @objc func pollSubmitBtn(sender:UIButton){
        
        let indexPath = AppHelper.getIndexPathFor(view: sender, collectionView: self.pollsCollectionView)
        let pollsCell = pollsCollectionView.cellForItem(at: indexPath!) as! PollsCell
        if pollsCell.UIviewTieFill.isHidden == false{
            selectedTeam = 3
            selectedPoll = 3
        }else if pollsCell.UiviewTeamTwoFill.isHidden == false{
            selectedTeam = 2
            selectedPoll = 2
        }else if pollsCell.UiviewTeamOneFill.isHidden == false{
            selectedTeam = 1
            selectedPoll = 1
        }else{
            selectedTeam = 0
            selectedPoll = 0
        }
        
        if selectedTeam == 0{
            Drop.down("Please select one option")
        }else{
            if let _id = self.pollsData[(indexPath?.item)!]._id{
                self.selectedPollId = _id
            }
            //if (UserDefaults.standard.value(forKey: "accessToken") as? String) != nil{
                //self.submitPoll()
            self.submitMyPoll()
//            self.setupNavigationBarTitle("LINEGURU POLLS", navBG: "", leftBarButtonsType: [], rightBarButtonsType: [.threeDot])
            self.setupNavigationBarTitle("LINEGURU POLLS", navBG: "", leftBarButtonsType: [], rightBarButtonsType: [])
//            }else{
//                let pollinView  = Bundle.main.loadNibNamed("PollinView", owner: self, options: nil)! [0] as! PollinView
//                pollinView.tag = 2345
//                pollinView.delegate = self
//                pollinView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
//                self.view.addSubview(pollinView)
//                pollinView.showPopup(hideCrossBtn:false)
//            }
        }
    }
   
    //MARK:-Page Controller Action
    
    @objc func pageControlTapHandler(sender:UIPageControl) {
        print("currentPage:", sender.currentPage)
        if currentIndex < 15 && (sender as AnyObject).currentPage > currentIndex {
            currentIndex = (sender as AnyObject).currentPage
            self.pollsCollectionView.scrollToItem(at:IndexPath(item: currentIndex, section: 0), at: .right, animated: false)
        } else if currentIndex > 0 {
            currentIndex = (sender as AnyObject).currentPage
            self.pollsCollectionView.scrollToItem(at:IndexPath(item: currentIndex, section: 0), at: .left, animated: false)
        }
    }
    
    //MARK:-Scroll view delegate
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageController.currentPage = Int(pageNumber)
        currentIndex = Int(pageNumber)
        selectedPoll = 0
    }
    
    //MARK:- Get Poll Data
    
    internal func getAllPollData(){
        var tempHeader = header
        if let accessToken = UserDefaults.standard.value(forKey: "accessToken") as? String{
            tempHeader["accessToken"] = UserDefaults.standard.value(forKey: "accessToken") as? String ?? ""
        }
            CLGUserService().HomeService(url:NewDevBaseUrl+CLGRecentClass.listPolls , method: .get, showLoader: 1,  header: tempHeader, parameters: [String : Any]()).then(execute: { (data) -> Void in
                if data.statusCode == 1{
                    if let responseData = data.responseData, let polls = responseData.polls{
                        self.pollsData = polls
                        self.noPollsLbl.isHidden = polls.count == 0 ? false : true
                    }
                    self.reloadBtn.isHidden = true
                }
               // self.interstitialAds = self.createAndLoadInterstitial()
                self.showNativeAd()
                self.pollsCollectionView.reloadData()
                }).catch { (error) in
                    print(error)
                    if self.pollsData.count == 0
                    {
                        self.reloadBtn.isHidden = false
                    }
            }
//        }
    }
    
    internal func submitPoll(){
        
        //if let accessToken = UserDefaults.standard.value(forKey: "accessToken") as? String{
            var tempHeader = header
            tempHeader["accessToken"] = UserDefaults.standard.value(forKey: "accessToken") as? String ?? ""
            var paramDict = [String:Any]()
            paramDict["pollId"] = "\(self.selectedPollId)"
            paramDict["predictionType"] = "\(selectedTeam)"
            CLGUserService().newsService(url: NewDevBaseUrl+CLGRecentClass.givePoll, method: .post, showLoader: 2, header: tempHeader, parameters: paramDict).then(execute: { (data) -> Void in
                if data.statusCode == 1{
                    if let responseData = data.responseData, let polls = responseData.polls{
                        self.selectedTeam = 0
                        self.pollsData = polls
                    }
                }
                self.pollsCollectionView.reloadData()
            }).catch { (error) in
                print(error)
            }
       // }
    }
    
}

extension PollScreenVC:PollingDelegate{
    func googleSignIn() {
        print("AAAAAA")
    }
    
    
    func dismissView(socialId: String, name: String, type: String, email:String) {
        if let pollinView = self.view.viewWithTag(2345) as? PollinView{
            pollinView.removeFromSuperview()
            if let secretView = self.view.viewWithTag(6789) as? SecretView{
                secretView.removeFromSuperview()
            }
            else{
                let secretView  = Bundle.main.loadNibNamed("SecretView", owner: self, options: nil)! [0] as! SecretView
                secretView.tag = 6789
                secretView.delegate = self
                secretView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                self.view.addSubview(secretView)
                secretView.customUI(sociallyId:socialId, socialUserName:name, socialType:type, email:email)
                secretView.showPopup(showBlur:false)
            }
        }
    }
    
//    func googleSignIn() {
//        GIDSignIn.sharedInstance().signOut()
//        if (GIDSignIn.sharedInstance().hasAuthInKeychain()) == false{
//            GIDSignIn.sharedInstance().signIn()
//        }
//        else{
//            GIDSignIn.sharedInstance().signInSilently()
//        }
//    }
}

extension PollScreenVC:SecretDelegate{
    
    func getPollData() {
        if let secretView = self.view.viewWithTag(6789) as? SecretView{
            secretView.removeFromSuperview()
            if (UserDefaults.standard.value(forKey: "accessToken") as? String) != nil
            {
                //self.setupNavigationBarTitle("LINEGURU POLLS", navBG: "", leftBarButtonsType: [], rightBarButtonsType: [.threeDot])
                self.setupNavigationBarTitle("LINEGURU POLLS", navBG: "", leftBarButtonsType: [], rightBarButtonsType: [])
            }
            self.submitPoll()
        }
    }
}

//extension PollScreenVC: GIDSignInUIDelegate{
//    
//    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!){
//    }
//    
//    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!){
//        self.present(viewController, animated: true, completion: nil)
//    }
//    
//    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!){
//        self.view.endEditing(false)
//        self.dismiss(animated: true, completion: nil)
//    }
//}
//
//extension PollScreenVC: GIDSignInDelegate{
//    
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!){
//        if (error == nil){
//            if let userId = user.userID{
//                if let name = user.profile.name{
//                    self.dismissView(socialId: userId, name: name, type: "2", email:user.profile.email ?? "")
//                }
//            }
//        }
//        else{
//            print("\(error.localizedDescription)")
//        }
//    }
//    
//    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!){
//        print(error.localizedDescription)
//    }
//}
extension PollScreenVC:GADInterstitialDelegate
{
    func interstitialDidReceiveAd(_ ad: GADInterstitial)
    {
        self.ShowAd()
        //self.perform(#selector(self.ShowAd), with: nil, afterDelay: 10.0)
    }
}



/////////////-=-=-=-=-=-=-=-=-=-=--=-=-=-=-=-=-=-=-===-=-=-=-=-==-=-=-=-=-==-=-/////////////////////////
extension PollScreenVC{
    
    //MARK: Get Polls Data
    func getTheActivePoll(){
        CLGUserService().HomeService(url:NewBaseUrlV4+CLGRecentClass.activePolls , method: .get, showLoader: 1,  header: header, parameters: [String : Any]()).then(execute: { (data) -> Void in
            if data.statusCode == 1{
                if let responseData = data.responseData, let polls = responseData.polls, let teamsPath = responseData.teamsPath{
                    self.teamsPathUrl = teamsPath
                    self.pollsData = polls
                    self.noPollsLbl.isHidden = polls.count == 0 ? false : true
                    if polls.count != 0{
                        self.deleteAllRecordIfTrue()
                    }
                }
                self.reloadBtn.isHidden = true
            }
            //self.interstitialAds = self.createAndLoadInterstitial()
            self.showNativeAd()
            self.pollsCollectionView.reloadData()
        }).catch { (error) in
            print(error)
            if self.pollsData.count == 0
            {
                self.reloadBtn.isHidden = false
            }
        }
    }
    
     func submitMyPoll(){
        
        //if let accessToken = UserDefaults.standard.value(forKey: "accessToken") as? String{
        var tempHeader = header
        tempHeader["accessToken"] = UserDefaults.standard.value(forKey: "accessToken") as? String ?? ""
        var paramDict = [String:Any]()
        paramDict["pollId"] = "\(self.selectedPollId)"
        paramDict["predictionType"] = "\(selectedTeam)"
        CLGUserService().newsService(url: NewBaseUrlV3+CLGRecentClass.submitPolls, method: .post, showLoader: 2, header: tempHeader, parameters: paramDict).then(execute: { (data) -> Void in
            if data.statusCode == 1{
                if let responseData = data.responseData, let message = responseData.msg{
                    self.selectedTeam = 0
                    //self.pollsData = polls
                    //Drop.down(message)
                    self.saveIDInDatabase(pollId: self.selectedPollId, pollSelected: Int16(self.selectedPoll))
                    self.selectedPoll = 0
                }
            }
            
            self.pollsCollectionView.reloadData()
        }).catch { (error) in
            print(error)
        }
        // }
    }
    
    func saveIDInDatabase(pollId:String,pollSelected:Int16){
        let PollData = DataBase(entity: "PollData")
        let fetchedData = fetchFromDatabase()
        if fetchedData.count == 0{
            PollData.insertRecord(pollId: pollId as AnyObject, pollSelected: pollSelected as AnyObject, entityType: "PollData")
        }
        else{
            for objectdata in fetchedData{
                if(pollId == objectdata.value(forKey: "pollID") as! String){
                    PollData.updateRecord(pollId: pollId as AnyObject, pollSelected: pollSelected as AnyObject)
                }
                else{
                    PollData.insertRecord(pollId: pollId as AnyObject, pollSelected: pollSelected as AnyObject, entityType: "PollData")
                }
            }
        }
        
    }
    func updateDataInDatabse(pollId:String,pollSelected:Int16){
        let PollData = DataBase(entity: "PollData")
        PollData.updateRecord(pollId: pollId as AnyObject, pollSelected: pollSelected as AnyObject)
    }
    func fetchFromDatabase() -> [NSManagedObject] {
        let PollData = DataBase(entity: "PollData")
        PollData.selectMultiple()
        let objectData = PollData.myList
        return objectData!
    }
    
    func returnTrueOrFalse(pollId:String) -> Int16
    {
        let fetchedData = fetchFromDatabase()
        var present = Bool()
        present = true
        
        for objectdata in fetchedData{
            if(pollId == objectdata.value(forKey: "pollID") as! String){
                present = true
                return objectdata.value(forKey: "pollSelected") as! Int16
                
            }
            else{
                present = false
            }
        }
        if present == false{
            return 0
        }
        else{
            return 0
        }
    }
    
    func deleteAllRecordIfTrue(){
        let fetchedData = fetchFromDatabase()
        var present = Bool()
        present = true
        for polldata in self.pollsData{
            for objectdata in fetchedData{
                if(polldata._id == objectdata.value(forKey: "pollID") as! String){
                    present = true
                    break
                }
                else{
                    present = false
                }
            }
            if present == true{
                break
            }
        }
        if present == false{
            let PollData = DataBase(entity: "PollData")
            PollData.deleteAllRecord()
        }
        else{
            
        }
    }
}


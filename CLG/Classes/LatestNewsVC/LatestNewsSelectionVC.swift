//
//  LatestNewsSelectionVC.swift
//  cricrate
//


import UIKit
import GoogleMobileAds
//import SDWebImage


class LatestNewsSelectionVC: BaseViewController,GADBannerViewDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate,GADInterstitialDelegate
{
    
    //MARK:- Variables and Constants
    
    private var selectedNewsData = CLGHomeResponseDataNewsV3()
    var baseUrl = String()
    var interstitialAds: GADInterstitial!
    var bannerAdView: FBAdView!
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var tblDesciption: UITableView!
    @IBOutlet weak var bannerHeight: NSLayoutConstraint!
    @IBOutlet weak var gadBannerView: GADBannerView!
    
    //MARK:- View LifeCycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.loadFbBannerAd()
        let appDel = UIApplication.shared.delegate as! AppDelegate
        if (appDel.fbInterstitialAd != nil) && appDel.fbInterstitialAd.isAdValid && appDel.toShowInterstitial {
            appDel.fbInterstitialAd.show(fromRootViewController: self)
            appDel.fbInterstitialAd = nil
            appDel.fbInterstitialAd = appDel.loadInterstitialFbAd()
            appDel.toShowInterstitial = false
            appDel.runTimer()
        }
        tblDesciption.delegate = self
        tblDesciption.dataSource = self
        tblDesciption.estimatedRowHeight = 70.0
        tblDesciption.register(UINib(nibName: "DescriptionCell", bundle: nil), forCellReuseIdentifier: "DescriptionCell")
        tblDesciption.register(UINib(nibName: "DescriptionImgCell", bundle: nil), forCellReuseIdentifier: "DescriptionImgCell")
        self.setupNavigationBarTitle("", navBG: "", leftBarButtonsType: [.back], rightBarButtonsType: [])
        if ScreenSize.SCREEN_HEIGHT == 812{
            self.tblDesciption.contentInset = UIEdgeInsetsMake(-88,0,0,0);
        }else{
            self.tblDesciption.contentInset = UIEdgeInsetsMake(-64,0,0,0);
        }
        self.hitApi()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FireBaseHomeObservers().removeObservers(ref:AppHelper.appDelegate().ref)
    }
    
    func loadFbBannerAd() {
            bannerAdView = FBAdView(placementID: AppHelper.appDelegate().fbBannerAdId, adSize: kFBAdSizeHeight50Banner, rootViewController: self)
            if UIDevice.current.hasTopNotch {
                bannerAdView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 84, width: UIScreen.main.bounds.width, height: 50)
            }
            else {
                bannerAdView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 60, width: UIScreen.main.bounds.width, height: 50)
            }
    //        bannerAdView.delegate = self
            self.view.addSubview(bannerAdView)
            bannerAdView.loadAd()
        }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    //MARK:-Func
    
    func getDataFromPrevClass(data:CLGHomeResponseDataNewsV3){
        self.selectedNewsData = data
    }


    func hitApi()
    {
        AlamofireServiceClass.shared.serviceJsonEncoding(url:  NewDevBaseUrlV3+CLGRecentClass.latestNewsDisc+selectedNewsData._id!, showLoader: 2, method: .get, header:header, parameters: nil, success: { (data) in
            if let dict = data as? [String:Any],
            let statusCode = dict["statusCode"] as? Int,
            statusCode == 1,
            let responseData = dict["responseData"] as? [String:Any],
            let news = responseData["news"] as? [String:Any],
            let desc = news["description"] as? String
            {
                self.selectedNewsData.description = desc
                self.tblDesciption.reloadData()
            }
        }) { (error) in
            print(error)
        }
    }
    //MARK:- Back Button Action
    
    @IBAction func backBtnAction(_ sender: Any){
        _ = navigationController?.popViewController(animated: true)
    }
}

extension LatestNewsSelectionVC:UITableViewDataSource,UITableViewDelegate{
    
    //MARK:- Table View Delegate and DataSources
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if indexPath.row == 0{
            let descriptionImgCell = tableView.dequeueReusableCell(withIdentifier: "DescriptionImgCell") as! DescriptionImgCell
            descriptionImgCell.selectionStyle = .none
            descriptionImgCell.setData(data:selectedNewsData,baseUrl:baseUrl)
            return descriptionImgCell
        }else{
            let descriptionCell = tableView.dequeueReusableCell(withIdentifier: "DescriptionCell") as! DescriptionCell
            descriptionCell.selectionStyle = .none
            descriptionCell.setData(data:selectedNewsData)
            return descriptionCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        if indexPath.row == 0{
            return 225.0
        }
        return UITableViewAutomaticDimension
    }
}

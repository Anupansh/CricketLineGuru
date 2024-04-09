//
//  LatestNewsSelectionVC.swift
//  cricrate
//


import UIKit
import GoogleMobileAds
//import SDWebImage


class LatestNewsSelectionVC: BaseViewController,GADBannerViewDelegate,UINavigationControllerDelegate,UIGestureRecognizerDelegate
{
    
    //MARK:- Variables and Constants
    
    private var selectedNewsData = CLGHomeResponseResultNewsData()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var tblDesciption: UITableView!
    @IBOutlet weak var bannerHeight: NSLayoutConstraint!
    @IBOutlet weak var gadBannerView: GADBannerView!
    
    //MARK:- View LifeCycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
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
        self.showGoogleAds()
    }
    
    override func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // AdMob banner available
    func adViewDidReceiveAd(_ view: GADBannerView) {
        bannerHeight.constant = 50.0
    }
    
    // NO AdMob banner available
    func adView(_ view: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        bannerHeight.constant = 0.0
    }
    
    func showGoogleAds(){
        self.gadBannerView.adUnitID = appDelegate.adBannerUnitID as String
        self.gadBannerView.rootViewController = self
        self.gadBannerView.load(GADRequest())
        self.gadBannerView.delegate = self
    }
    
    @objc func showAds(notification: NSNotification){
        self.gadBannerView.load(GADRequest())
    }
    
    func getDataFromPrevClass(data:CLGHomeResponseResultNewsData){
        self.selectedNewsData = data
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
            descriptionImgCell.setData(data:selectedNewsData)
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

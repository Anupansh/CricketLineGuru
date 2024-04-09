
//
//  TopPollersVC.swift
//  CLG
//
//  Created by Brainmobi on 22/08/18.
//  Copyright © 2018 Anuj Naruka. All rights reserved.
//

import UIKit
import GoogleMobileAds

class TopPollersVC: BaseViewController {
    
    //MARK:- Properties
    
    var interstitialAds: GADInterstitial!
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    internal var userPollsData = [CLGUserModel]()
    internal var pastPollsData = [CLGUserModel]()
    internal var selectedBtn = 1
    
    //MARK:- IBOutlets
    @IBOutlet weak var currntMonthBtn: UIButton!
    @IBOutlet weak var pastMonthBtn: UIButton!
    @IBOutlet weak var noRecordLbl: UILabel!
    @IBOutlet weak var pollerTable: UITableView!
    @IBOutlet weak var gadBannerView: GADBannerView!
    @IBOutlet weak var bannerHeight: NSLayoutConstraint!
    @IBOutlet weak var selectedTabConstraint: NSLayoutConstraint!
    
    var bannerAdView: FBAdView!
    
    //MARK:- View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadFbBannerAd()

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK:-Functions
    
    private func setUp(){
        pollerTable.tableFooterView = UIView()
        self.setupNavigationBarTitle("TOP 20 POLLERS", navBG: "", leftBarButtonsType: [.back], rightBarButtonsType: [])
        getUserPollData()
        let appDel = UIApplication.shared.delegate as! AppDelegate
        if (appDel.fbInterstitialAd != nil) && appDel.fbInterstitialAd.isAdValid && appDel.toShowInterstitial {
            appDel.fbInterstitialAd.show(fromRootViewController: self)
            appDel.fbInterstitialAd = nil
            appDel.fbInterstitialAd = appDel.loadInterstitialFbAd()
            appDel.toShowInterstitial = false
            appDel.runTimer()
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
    
    //MARK:- Get Poll Data
    
    internal func getUserPollData(){
        
        if let accessToken = UserDefaults.standard.value(forKey: "accessToken") as? String{
            var tempHeader = header
            tempHeader["accessToken"] = UserDefaults.standard.value(forKey: "accessToken") as? String ?? ""
            var paramDict = [String:Any]()
            CLGUserService().newsService(url:NewDevBaseUrl+CLGRecentClass.rankingPoll , method: .post, showLoader: 1, header: tempHeader, parameters: paramDict).then(execute: { (data) -> Void in
                if data.statusCode == 1{
                    if let responseData = data.responseData, let result = responseData.result
                    {if let user = result.currentRanking{
                        self.userPollsData = user
                        self.noRecordLbl.isHidden = user.count == 0 ? false : true
                        }
                        if let past = result.pastRanking
                        {
                            self.pastPollsData = past
                        }
                    }
                }
                AppHelper.hideHud()
                self.pollerTable.reloadData()
            }).catch { (error) in
                print(error)
                AppHelper.hideHud()
            }
        }
    }
    @objc func claimPrice(_ sender : UIButton)
    {
        let index = sender.tag/100000
        if (pollerTable.cellForRow(at: IndexPath(row: index, section: 0)) as? Ranking_Cell) != nil
        {
            if self.pastPollsData[index].isPaid == 1
            {
                Drop.down("Your prize money of Rs \(self.pastPollsData[index].prize ?? "0") has been credited to your paytm account.")
                return
            }
            else if !(self.pastPollsData[index].userPhone?.isBlank)!
            {
                Drop.down("Your prize money of Rs \(self.pastPollsData[index].prize ?? "0") is under process.")
                return
            }
        }
        let phoneNumberView  = Bundle.main.loadNibNamed("DropDownMenu", owner: self, options: nil)! [1] as! PhoneNumberView
        phoneNumberView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        self.view.addSubview(phoneNumberView)
        phoneNumberView.delegate = self
        phoneNumberView.priceAmount = sender.tag%100000
        phoneNumberView.rankId = self.pastPollsData[index]._id ?? ""
        phoneNumberView.showPopup(hideCrossBtn:false)
    }
    //MARK:-IBAction
    @IBAction func currntMonthBtnAct(_ sender: Any)
    {
        UIView.animate(withDuration: 0.5, animations: {
            self.selectedTabConstraint.constant = self.currntMonthBtn.frame.origin.x
            self.view.layoutIfNeeded()
        })
        selectedBtn = 1
        noRecordLbl.isHidden = userPollsData.count == 0 ? false : true
        self.pollerTable.reloadData()
    }
    @IBAction func pastMonthBtnAct(_ sender: Any)
    {
        UIView.animate(withDuration: 0.5, animations: {
            self.selectedTabConstraint.constant = self.pastMonthBtn.frame.origin.x
            self.view.layoutIfNeeded()
        })
        selectedBtn = 2
        noRecordLbl.isHidden = pastPollsData.count == 0 ? false : true
        self.pollerTable.reloadData()
    }
}

extension TopPollersVC:UITableViewDataSource,UITableViewDelegate{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if selectedBtn == 1
        {
            return (self.userPollsData.count + 1)
        }
        return (self.pastPollsData.count + 1)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
            let ranking_Cell = tableView.dequeueReusableCell(withIdentifier: Ranking_Cell.className) as! Ranking_Cell
        ranking_Cell.selectionStyle = .none
        if selectedBtn == 1
        {
            ranking_Cell.LblPoints.isHidden = false
            ranking_Cell.btnClaim.isHidden = true
            if indexPath.row == 0{
                ranking_Cell.LblRank.text = "Rank"
                ranking_Cell.LblPlayer.text = "Name"
                ranking_Cell.LblPoints.text = "Points"
                ranking_Cell.backgroundColor = UIColor.init(red: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1.0)
            }else{
                if let name = self.userPollsData[indexPath.row-1].username{
                    ranking_Cell.LblPlayer.text = name.capitalized
                }
                ranking_Cell.LblRank.text = "\(indexPath.row)"
                ranking_Cell.backgroundColor = UIColor.white
                
                if let totalPred = self.userPollsData[indexPath.row-1].totalPred{
                    if let wonPred = self.userPollsData[indexPath.row-1].wonPred{
                        ranking_Cell.LblPoints.text = "\(wonPred*10)"
                    }
                }
            }
        }
        else
        {
            
            if indexPath.row == 0{
                ranking_Cell.LblRank.text = "Rank"
                ranking_Cell.LblPlayer.text = "Name"
                ranking_Cell.LblPoints.text = "Price"
                ranking_Cell.backgroundColor = UIColor.init(red: 229.0/255.0, green: 229.0/255.0, blue: 229.0/255.0, alpha: 1.0)
            }
            else{
                ranking_Cell.btnClaim.isHidden = self.pastPollsData[indexPath.row-1].isMyRank! == 1 ? false : true
                ranking_Cell.LblPoints.isHidden = self.pastPollsData[indexPath.row-1].isMyRank! == 1 ? true : false
                ranking_Cell.btnClaim.isEnabled = true
                if self.pastPollsData[indexPath.row-1].isPaid == 1
                {
                    ranking_Cell.btnClaim.setTitle("  Transferred  ", for: UIControlState.normal)
                }
                else if !(self.pastPollsData[indexPath.row-1].userPhone?.isBlank)!
                {
                    ranking_Cell.btnClaim.setTitle("  Claimed  ", for: UIControlState.normal)
                }
                else
                {
                    ranking_Cell.btnClaim.setTitle("  Claim  ", for: UIControlState.normal)
                }
                ranking_Cell.btnClaim.tag = ((indexPath.row-1)*100000) + Int(self.pastPollsData[indexPath.row-1].prize ?? "0")!
                ranking_Cell.btnClaim.addTarget(self, action: #selector(self.claimPrice(_:)), for: UIControlEvents.touchUpInside)
                if let name = self.pastPollsData[indexPath.row-1].userInfo?.username{
                    ranking_Cell.LblPlayer.text = name.capitalized
                }
                ranking_Cell.LblRank.text = "\(indexPath.row)"
                ranking_Cell.backgroundColor = UIColor.white
                
//                if let totalPred = self.userPollsData[indexPath.row-1].totalPred{
//                    if let wonPred = self.userPollsData[indexPath.row-1].wonPred{
//                        let accuracypercentage = (Float(wonPred)*100.0)/(Float(totalPred))
//                        ranking_Cell.LblPoints.text = "\(wonPred)" + "%"
//                    }
//                }
                ranking_Cell.LblPoints.text = self.pastPollsData[indexPath.row-1].prize ?? "500"
            }
        }
            return ranking_Cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        
        return 35.0
    }
}
extension TopPollersVC:PhoneDelegate
{
    func getUserData()
    {
        AppHelper.showHud(type: 2)
        getUserPollData()
    }
    
}

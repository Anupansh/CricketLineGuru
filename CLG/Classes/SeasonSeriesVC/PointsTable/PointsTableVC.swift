//
//  PointsTableVC.swift
//  CLG
//
//  Created by Anuj Naruka on 9/17/18.
//  Copyright © 2018 Anuj Naruka. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds


class PointsTableVC: BaseViewController,UINavigationControllerDelegate,UIGestureRecognizerDelegate,GADBannerViewDelegate,GADInterstitialDelegate
{
    //MARK:-IBOutlet
    @IBOutlet weak var tvPointsTable: UITableView!
    @IBOutlet weak var gadBannerView: GADBannerView!
    @IBOutlet weak var bannerHeight: NSLayoutConstraint!
    
    
    //MARK:-Variables And Constants
    var interstitialAds: GADInterstitial!
    var pointsTblArr = CLGPointsInfo()
    var bannerAdView: FBAdView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tvPointsTable.estimatedRowHeight = 200
        tvPointsTable.tableFooterView = UIView()
        self.setupNavigationBarTitle("Points Table", navBG: "", leftBarButtonsType: [.back], rightBarButtonsType: [])
        self.loadFbBannerAd()
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidDisappear(_ animated: Bool) {
    }
    //MARk:-Funcions
  
        
    func hitApi()
    {
//        UserService.pointsTableService("", completionBlock: { (success,
//            errorMessage, data) -> Void in
//            if success
//            {
//                print(data)
//                if data?["status"] != nil
//                {
//                    if data!["status"] as? Int == 1
//                    {
//                        if let responseArr = data?["response"] as? [[String:AnyObject]]
//                        {
//                            if responseArr.count > 0
//                            {
//                                self.LblNoPointsTabel.isHidden = true
//                                self.LblPointsTabelHeading.text = "  "+(responseArr.first!["name"] as! String)
//                                self.pointsTblArr = (responseArr.first!["teams"] as? [[String:AnyObject]])!
//                                self.tvPointsTable.reloadData()
//                            }
//                            else
//                            {
//                                self.LblNoPointsTabel.isHidden = false
//                            }
//                        }
//                    }
//                }
//                Util.hideHud()
//
//            }
//            else
//            {
//                Util.hideHud()
//                Util.invokeAlertMethod("Cricket Line Guru", strBody: errorMessage! as NSString, delegate: nil)
//
//            }
//        })
//
    }
}
extension PointsTableVC: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
    }
}
extension PointsTableVC: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (pointsTblArr.teams?.count) ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PointsTableCell", for: indexPath) as! PointsTableCell
        cell.LblLose.text = "\((pointsTblArr.teams!)[indexPath.row].lost ?? 0)"
        cell.LblNRR.text = String(format:"%.2f", (pointsTblArr.teams![indexPath.row].net_run_rate) ?? 0.0)
        cell.LblWins.text = "\(pointsTblArr.teams![indexPath.row].won ?? 0)"
        cell.LblPlayed.text = "\(pointsTblArr.teams![indexPath.row].played ?? 0)"
        cell.LblPoints.text = "\(pointsTblArr.teams![indexPath.row].points ?? 0)"
        cell.LblNoResult.text = "\(pointsTblArr.teams![indexPath.row].tied ?? 0)"
        cell.LblTeamName.text = pointsTblArr.teams![indexPath.row].name ?? ""
        cell.selectionStyle = .none
        return cell
    }
}

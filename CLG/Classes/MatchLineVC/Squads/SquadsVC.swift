//
//  SquadsVC.swift
//  CLG
//
//  Created by Prachi Tiwari on 22/07/20.
//  Copyright © 2020 Anuj Naruka. All rights reserved.
//

import UIKit
import ScrollableSegmentedControl
import Alamofire
import SwiftyJSON
import GoogleMobileAds

class SquadsVC : BaseViewController {
    
    @IBOutlet weak var segmentControl: ScrollableSegmentedControl!
    @IBOutlet weak var tableview: UITableView! {
        didSet {
            tableview.delegate = self
            tableview.dataSource = self
            tableview.separatorStyle = .none
        }
    }
    @IBOutlet weak var squadsNotAnnounceLbl: UILabel!
    @IBOutlet weak var gadBannerView: GADBannerView!
    
    var firstTeam : String!
    var secondTeam : String!
    var selectedIndex : Int!
    var mit = ""
    var matchKey = ""
    var pp : String!
    var firstTeamModel = [SquadsModel]()
    var secondTeamModel = [SquadsModel]()
    var bannerAdView: FBAdView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    func initialSetup() {
        super.setupNavigationBarTitle("Squads", navBG: "", leftBarButtonsType: [.back], rightBarButtonsType: [])
        setupSegmentControl()
        apiHitGetSquad()
        let appDel = UIApplication.shared.delegate as! AppDelegate
        if (appDel.fbInterstitialAd != nil) && appDel.fbInterstitialAd.isAdValid && appDel.toShowInterstitial {
            appDel.fbInterstitialAd.show(fromRootViewController: self)
            appDel.fbInterstitialAd = nil
            appDel.fbInterstitialAd = appDel.loadInterstitialFbAd()
            appDel.toShowInterstitial = false
            appDel.runTimer()
        }
        self.loadFbBannerAd()
    }
    
    func setupSegmentControl() {
        segmentControl.fixedSegmentWidth = true
        segmentControl.segmentStyle = .textOnly
        segmentControl.underlineSelected = true
        segmentControl.insertSegment(withTitle: firstTeam, at: 0)
        segmentControl.insertSegment(withTitle: secondTeam, at: 1)
        segmentControl.selectedSegmentIndex = selectedIndex
        segmentControl.segmentContentColor = .white
        segmentControl.selectedSegmentContentColor = .white
        segmentControl.tintColor = .white
        segmentControl.setTitleTextAttributes([NSAttributedString.Key.font : UIFont(name: "Lato-Semibold", size: 17)!], for: .normal)
        segmentControl.addTarget(self, action: #selector(segmentSelected(sender:)), for: .valueChanged)
    }
    
    func loadFbBannerAd() {
            bannerAdView = FBAdView(placementID: AppHelper.appDelegate().fbBannerAdId, adSize: kFBAdSizeHeight50Banner, rootViewController: self)
            if UIDevice.current.hasTopNotch {
                bannerAdView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 84, width: UIScreen.main.bounds.width, height: 50)
            }
            else {
                bannerAdView.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - 60, width: UIScreen.main.bounds.width, height: 50)
            }
            self.view.addSubview(bannerAdView)
            bannerAdView.loadAd()
        }
    
    @objc func segmentSelected(sender:ScrollableSegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.selectedIndex = 0
            if self.firstTeamModel.count == 0 {
                self.squadsNotAnnounceLbl.isHidden = false
            }
            else {
                self.squadsNotAnnounceLbl.isHidden = true
            }
        }
        else {
            self.selectedIndex = 1
            if self.secondTeamModel.count == 0 {
                self.squadsNotAnnounceLbl.isHidden = false
            }
            else {
                self.squadsNotAnnounceLbl.isHidden = true
            }
        }
        self.tableview.reloadData()
    }
    
    func apiHitGetSquad() {
        let serviceName = "https://clgphase2.cricketlineguru.in/clg/api/v5/match/\(self.matchKey)/liveline?mit=\(self.mit)"
        Alamofire.request(serviceName, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            if response.result.isSuccess {
                let json = JSON(response.result.value!)
                if json["statusCode"].stringValue == "1" {
                    let responseData = json["responseData"]
                    self.pp = responseData["pP"].stringValue
                    let info = responseData["info"]
                    if !info["t1p"].isEmpty {
                        self.squadsNotAnnounceLbl.isHidden = true
                        for i in 0..<info["t1p"].count {
                            let singlePlayer = SquadsModel.init(json: info["t1p"][i])
                            self.firstTeamModel.append(singlePlayer)
                        }
                    }
                    if !info["t2p"].isEmpty {
                        self.squadsNotAnnounceLbl.isHidden = true
                        for i in 0..<info["t2p"].count {
                            let singlePlayer = SquadsModel.init(json: info["t2p"][i])
                            self.secondTeamModel.append(singlePlayer)
                        }
                    }
                    self.tableview.reloadData()
                }
                else {
                    self.squadsNotAnnounceLbl.isHidden = false
                }
            }
            else {
                if let kError = response.error?.localizedDescription {
                    Drop.down(kError)
                }
            }
        }
    }
}

extension SquadsVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if selectedIndex == 0 {
            return firstTeamModel.count
        }
        else {
            return secondTeamModel.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "SquadsCell") as! SquadsCell
        if selectedIndex == 0 {
            cell.playerNameLbl.text = self.firstTeamModel[indexPath.row].playerName
            cell.playerRoleLbl.text = self.firstTeamModel[indexPath.row].playerRole
            if self.firstTeamModel[indexPath.row].logo == "" {
                cell.playerImage.image = AppHelper.generateImageWithText(text: self.firstTeamModel[indexPath.row].playerName.uppercased(), image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:self.firstTeamModel[indexPath.row].playerName.uppercased()), size: CGSize(width: 50, height: 50)))
            }
            else {
                cell.playerImage.sd_setImage(with: URL(string: self.pp + self.firstTeamModel[indexPath.row].logo), placeholderImage: #imageLiteral(resourceName: "default"))
            }
        }
        else {
            cell.playerNameLbl.text = self.secondTeamModel[indexPath.row].playerName
            cell.playerRoleLbl.text = self.secondTeamModel[indexPath.row].playerRole
            if self.secondTeamModel[indexPath.row].logo == "" {
                cell.playerImage.image = AppHelper.generateImageWithText(text: self.secondTeamModel[indexPath.row].playerName.uppercased(), image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:self.secondTeamModel[indexPath.row].playerName.uppercased()), size: CGSize(width: 50, height: 50)))
            }
            else {
                cell.playerImage.sd_setImage(with: URL(string: self.pp + self.secondTeamModel[indexPath.row].logo), placeholderImage: #imageLiteral(resourceName: "default"))
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = AppStoryboard.browsePlayer.instantiateViewController(withIdentifier: PlayerDetailVC.className) as! PlayerDetailVC
        if selectedIndex == 0 {
            vc.getTeamIdFromPrevClassScoreCard(key:firstTeamModel[indexPath.row].playerKey , navTitle: firstTeamModel[indexPath.row].playerName)
        }
        else {
            vc.getTeamIdFromPrevClassScoreCard(key:secondTeamModel[indexPath.row].playerKey , navTitle: secondTeamModel[indexPath.row].playerName)
        }
        self.navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

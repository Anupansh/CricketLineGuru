//
//  UserPollVC.swift
//  cricrate
//  Created by Anuj Naruka on 2/13/18.
//  Copyright © 2018 Cricket Line Guru. All rights reserved.
//

import UIKit
import GoogleMobileAds

class UserPollVC: BaseViewController,UINavigationControllerDelegate,UIGestureRecognizerDelegate {
    
    //MARK:-IBOutlet
    
    @IBOutlet weak var TbView: UITableView!
    @IBOutlet weak var gadBannerView: GADBannerView!
    @IBOutlet weak var bannerHeight: NSLayoutConstraint!
    @IBOutlet weak var ChartView: PieChart!
    @IBOutlet weak var NoRecordLbl: UILabel!
    
    //MARK:Variables
    
    var interstitialAds: GADInterstitial!
    var currentPage = 1
    var isLoading = false
    var totalVote = Double()
    var pollsArr = [[String:Any]]()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var bannerAdView: FBAdView!
    
    internal var pollsData = CLGHomeResponseData()

    override func viewDidLoad(){
        super.viewDidLoad()
        setUp()
    }

    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //MARK:- Layers
    
    fileprivate func createTextWithLinesLayer() -> PieLineTextLayer {
        let lineTextLayer = PieLineTextLayer()
        var lineTextLayerSettings = PieLineTextLayerSettings()
        lineTextLayerSettings.lineColor = UIColor.white
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        lineTextLayerSettings.label.font = UIFont.systemFont(ofSize: 20)
        lineTextLayerSettings.label.textGenerator = {slice in
            return (formatter.string(from: slice.data.model.value as NSNumber).map{"\($0)"} ?? "")+"%"
//            return slice.data.model.value
        }
        lineTextLayer.settings = lineTextLayerSettings
        return lineTextLayer
    }
   
    //MARK:-Functions
    
    private func setUp(){
        self.setupNavigationBarTitle("MY POLL ACCURACY", navBG: "", leftBarButtonsType: [.back], rightBarButtonsType: [])
        self.TbView.isHidden = true
        self.NoRecordLbl.isHidden = true
        TbView.estimatedRowHeight = 200
        let appDel = UIApplication.shared.delegate as! AppDelegate
        if (appDel.fbInterstitialAd != nil) && appDel.fbInterstitialAd.isAdValid && appDel.toShowInterstitial {
            appDel.fbInterstitialAd.show(fromRootViewController: self)
            appDel.fbInterstitialAd = nil
            appDel.fbInterstitialAd = appDel.loadInterstitialFbAd()
            appDel.toShowInterstitial = false
            appDel.runTimer()
        }
        self.getAllPollData(currentPage: currentPage)
        self.loadFbBannerAd()
    }
    
    //MARK:- Get Poll Data
    
    internal func getAllPollData(currentPage:Int){
        if let accessToken = UserDefaults.standard.value(forKey: "accessToken") as? String{
            var tempHeader = header
            tempHeader["accessToken"] = UserDefaults.standard.value(forKey: "accessToken") as? String ?? ""
            var paramDict = [String:Any]()
            paramDict["pageNo"] = "\(self.currentPage)"
            paramDict["limit"] = "20"
            CLGUserService().newsService(url:NewDevBaseUrl+CLGRecentClass.userPoll , method: .post, showLoader: 1, header: tempHeader, parameters: paramDict).then(execute: { (data) -> Void in
                if data.statusCode == 1{
                    if let responseData = data.responseData{
                        self.pollsData = responseData
                        self.setData(data: responseData)
                    }
                }else{
                    self.NoRecordLbl.isHidden = false
                    self.TbView.isHidden = true
                }
            }).catch { (error) in
                print(error)
            }
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
    
    private func setData(data:CLGHomeResponseData){
        
        if let totalPoll = data.totalPoll{
            if totalPoll == 0{
                self.NoRecordLbl.isHidden = false
                self.TbView.isHidden = true
            }else if Double(totalPoll) >= self.totalVote{
                self.NoRecordLbl.isHidden = true
                self.TbView.isHidden = false
                self.totalVote = Double(totalPoll)
                var correctPol = 0.0
                var incorrectPol = 0.0
                var pendingPol = 0.0
                
                if let correctPoll = data.correctPoll{
                    correctPol = correctPoll
                }
                
                if let incorrectPoll = data.incorrectPoll{
                    incorrectPol = incorrectPoll
                }
                
                if let pendingPoll = data.pendingPoll{
                    pendingPol = pendingPoll
                }
                
                self.ChartView.outerRadius = 78
                self.ChartView.innerRadius = 0
                self.ChartView.strokeWidth = 0
                self.ChartView.isUserInteractionEnabled = false
                var model = [PieSliceModel]()
                
                if correctPol != 0{
                    model.append(PieSliceModel(value: correctPol, color: UIColor(red: 92/255, green: 198/255, blue: 109/255, alpha: 1.0), textColor:UIColor(red: 92/255, green: 198/255, blue: 109/255, alpha: 1.0)))
                }
                if incorrectPol != 0{
                    model.append(PieSliceModel(value: incorrectPol, color: UIColor(red: 229/255, green: 111/255, blue: 99/255, alpha: 1.0), textColor: UIColor(red: 229/255, green: 111/255, blue: 99/255, alpha: 1.0)))
                }
                if pendingPol != 0{
                    model.append(PieSliceModel(value: pendingPol, color: UIColor(red: 242/255, green: 196/255, blue: 54/255, alpha: 1.0), textColor: UIColor(red: 242/255, green: 196/255, blue: 54/255, alpha: 1.0)))
                }
                self.ChartView.models = model
                self.ChartView.layers = [self.createTextWithLinesLayer()]
                self.TbView.reloadData()
            }
        }else{
            self.NoRecordLbl.isHidden = false
            self.TbView.isHidden = true
        }
        
    }
    
   // MARK:-IBAction
    
    @IBAction func BackBtnAction(_ sender: Any){
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
}

extension UserPollVC: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?{
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserPollHeaderCell")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat{
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 40
    }
}

extension UserPollVC: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if let polls = pollsData.polls{
            return polls.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserPollCell", for: indexPath) 
        if indexPath.row % 2 == 0
        {
            cell.backgroundColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 1.0)
        }
        else
        {
            cell.backgroundColor = UIColor.white
        }
        cell.selectionStyle = .none
        let DateLbl = cell.viewWithTag(100) as! UILabel
        let TeamOneLbl = cell.viewWithTag(101) as! UILabel
        let YourPridictionLbl = cell.viewWithTag(104) as! UILabel
        let ResultBtn = cell.viewWithTag(103) as! UIButton
        
        if let polls = pollsData.polls{
            let poll = polls[indexPath.row]
            
            if let myPoll = poll.myPoll{
                YourPridictionLbl.text = myPoll
                
                if let winTeam = poll.winTeam{
                    if winTeam == myPoll{
                        ResultBtn.setTitle("", for: .normal)
                        ResultBtn.setImage(#imageLiteral(resourceName: "right"), for: .normal)
                    }else if winTeam.uppercased() == "PENDING"{
                        ResultBtn.setTitle("Pending", for: .normal)
                        ResultBtn.setImage(nil, for: .normal)
                    }else{
                        ResultBtn.setTitle("", for: .normal)
                        ResultBtn.setImage(#imageLiteral(resourceName: "wrong"), for: .normal)
                    }
                }
                if let matchDate = poll.match_date{
                    let date : Date = Date(timeIntervalSince1970: Double(matchDate/1000))
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd MMM yy"
                    let day = dateFormatter.string(from: date as Date)
                    DateLbl.text = "\(day.uppercased())"

                }
            }
            if let teams = poll.teams{
                TeamOneLbl.text = teams
            }
        }
        return cell
    }
}

extension UserPollVC:UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if ((scrollView.contentOffset.y + scrollView.frame.size.height) > scrollView.contentSize.height ) && !isLoading{
            isLoading = true
            var totalPage = totalVote/15.0
            let totalPageRem = totalVote.truncatingRemainder(dividingBy: 15)
            if totalPageRem > 0{
                totalPage += 1
            }
            if totalPage > Double(currentPage){
                currentPage += 1
                self.getAllPollData(currentPage: currentPage)
            }
        }
    }
}


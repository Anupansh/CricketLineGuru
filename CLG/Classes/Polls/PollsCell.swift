//
//  PollsCell.swift
//  cricrate
//
//  Created by Anuj Naruka on 7/28/17.
//  Copyright © 2017 Cricket Line Guru. All rights reserved.
//

import UIKit

class PollsCell:
UICollectionViewCell {
    
    //MARK:- IBOutlets
    @IBOutlet weak var matchTypeImageView: UIImageView!
    @IBOutlet weak var teamTwoImageView: CircularImageV!
    @IBOutlet weak var viewHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var quesBottomConst: NSLayoutConstraint!
    @IBOutlet weak var DateLbl: UILabel!
    @IBOutlet weak var MainView: UIView!
    @IBOutlet weak var PollTeamOnePercentLbl: UILabel!
    @IBOutlet weak var viewTopConst: NSLayoutConstraint!
    @IBOutlet weak var viewBottomConst: NSLayoutConstraint!
    @IBOutlet weak var TotalVotesLbl: UILabel!
    @IBOutlet weak var SubmitBtn: UIButton!
    @IBOutlet weak var UIviewTieFill: UIView!
    @IBOutlet weak var UiviewTeamOneFill: UIView!
    @IBOutlet weak var UiviewTeamTwoborder: UIView!
    @IBOutlet weak var TieBtn: UIButton!
    @IBOutlet weak var TeamTwoBtn: UIButton!
    @IBOutlet weak var UiviewTieBorder: UIView!
    @IBOutlet weak var UiviewTeamTwoFill: UIView!
    @IBOutlet weak var UiviewTeamOneBorder: UIView!
    @IBOutlet weak var UiviewTie: UIView!
    @IBOutlet weak var TeamOneBtn: UIButton!
    @IBOutlet weak var UiewTeamone: UIView!
    @IBOutlet weak var UiviewTeamTwo: UIView!
    @IBOutlet weak var PollTiePercentLbl: UILabel!
    @IBOutlet weak var PollTeamTwoPercentLbl: UILabel!
    @IBOutlet weak var PollTieLbl: UILabel!
    @IBOutlet weak var PollTeamOneLbl: UILabel!
    @IBOutlet weak var PollTeamTwoLbl: UILabel!
    @IBOutlet weak var PollQuesLbl: UILabel!
    @IBOutlet weak var TeamOneImageView: CircularImageV!
    @IBOutlet weak var TeamTwoLbl: UILabel!
    @IBOutlet weak var TeamOneLbl: UILabel!
    @IBOutlet weak var AnimateViewThreeWidth: NSLayoutConstraint!
    @IBOutlet weak var AnimateViewThree: UIView!
    @IBOutlet weak var AnimateViewTwoWidth: NSLayoutConstraint!
    @IBOutlet weak var AnimateViewTwo: UIView!
    @IBOutlet weak var AnimateViewOneWidth: NSLayoutConstraint!
    @IBOutlet weak var PredTeamTieLbl: UILabel!
    @IBOutlet weak var PredTeamOneLbl: UILabel!
    @IBOutlet weak var PredTeamTwoLbl: UILabel!
    @IBOutlet weak var AnimateViewOne: UIView!
    @IBOutlet weak var pollView: UIView!
    @IBOutlet weak var totalPollLbl: UILabel!
    @IBOutlet weak var pollSubmitLbl: UILabel!
    
    lazy var pollselected: Int16 = {
        let pollselected = Int16()
        return pollselected
    }()
    lazy var teamspath: String = {
        let teamspath = String()
        return teamspath
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setData(data:CLGPollsModel){
        
        if let matchDate = data.matchDate
        {
            
            if ((pollselected == 0) && matchDate > Date().toMillis()){
                if let pollQuestion = data.pollQuestion{
                    PollQuesLbl.text = pollQuestion
                }
                TotalVotesLbl.isHidden = true
                pollView.isHidden = true
                SubmitBtn.isHidden = false
                if ScreenSize.SCREEN_HEIGHT == 568{
                    viewTopConst.constant = 25
                    TeamTwoLbl.font = TeamTwoLbl.font.withSize(13)
                    TeamOneLbl.font = TeamOneLbl.font.withSize(13)
                    viewBottomConst.constant = 8
                    quesBottomConst.constant = 8
                    viewHeightConstant.constant = 20
                }
                else
                {
                    TeamTwoLbl.font = TeamTwoLbl.font.withSize(18)
                    TeamOneLbl.font = TeamOneLbl.font.withSize(18)
                }
                UiewTeamone.isHidden = false
                UiviewTeamTwo.isHidden = false
                UiviewTie.isHidden = false
                UiviewTeamOneBorder.isHidden = false
                UiviewTeamTwoborder.isHidden = false
                UiviewTieBorder.isHidden = false
                UIviewTieFill.isHidden = true
                UiviewTeamOneFill.isHidden = true
                UiviewTeamTwoFill.isHidden = true
                UiewTeamone.layer.borderWidth = 1.0
                UiviewTie.layer.borderWidth = 1.0
                UiviewTeamTwo.layer.borderWidth = 1.0
                PredTeamOneLbl.isHidden = true
                PredTeamTieLbl.isHidden = true
                PredTeamTwoLbl.isHidden = true
                PollTiePercentLbl.isHidden = true
                PollTeamOnePercentLbl.isHidden = true
                PollTeamTwoPercentLbl.isHidden = true
                AnimateViewOne.isHidden = true
                AnimateViewTwo.isHidden = true
                AnimateViewThree.isHidden = true
                UiewTeamone.layer.borderColor = UIColor(red: 47/255, green: 104/255, blue: 148/255, alpha: 1.0).cgColor
                UiviewTie.layer.borderColor = UIColor(red: 47/255, green: 104/255, blue: 148/255, alpha: 1.0).cgColor
                UiviewTeamTwo.layer.borderColor = UIColor(red: 47/255, green: 104/255, blue: 148/255, alpha: 1.0).cgColor
                UiewTeamone.backgroundColor = UIColor.white
                UiviewTie.backgroundColor = UIColor.white
                UiviewTeamTwo.backgroundColor = UIColor.white
            }
            else{
                if ScreenSize.SCREEN_HEIGHT == 568{
                    viewTopConst.constant = 25
                    TeamTwoLbl.font = TeamTwoLbl.font.withSize(13)
                    TeamOneLbl.font = TeamOneLbl.font.withSize(13)
                    viewBottomConst.constant = 8
                    quesBottomConst.constant = 8
                    viewHeightConstant.constant = 20
                }
                else
                {
                    TeamTwoLbl.font = TeamTwoLbl.font.withSize(18)
                    TeamOneLbl.font = TeamOneLbl.font.withSize(18)
                }
                PredTeamTieLbl.text = "TIE"
                PredTeamOneLbl.isHidden = false
                PredTeamTieLbl.isHidden = false
                PredTeamTwoLbl.isHidden = false
                PollTiePercentLbl.isHidden = false
                PollTeamOnePercentLbl.isHidden = false
                PollTeamTwoPercentLbl.isHidden = false
                AnimateViewOne.isHidden = false
                AnimateViewTwo.isHidden = false
                AnimateViewThree.isHidden = false
                PollQuesLbl.text = "PREDICTIONS"
                SubmitBtn.isHidden = true
                if (pollselected == 0 ){
                    pollView.isHidden = true
                    TotalVotesLbl.isHidden = false
                }
                else{
                    TotalVotesLbl.isHidden = true
                    pollView.isHidden = false
                    
                }
                UiviewTeamOneBorder.isHidden = true
                UiviewTeamTwoborder.isHidden = true
                UiviewTieBorder.isHidden = true
                UIviewTieFill.isHidden = true
                UiviewTeamOneFill.isHidden = true
                UiviewTeamTwoFill.isHidden = true
                UiewTeamone.isHidden = true
                UiviewTeamTwo.isHidden = true
                UiviewTie.isHidden = true
                UiewTeamone.backgroundColor = UIColor.clear
                UiviewTie.backgroundColor = UIColor.clear
                UiviewTeamTwo.backgroundColor = UIColor.clear
                AnimateViewThree.layer.cornerRadius = 4.0
                AnimateViewTwo.layer.cornerRadius = 4.0
                AnimateViewOne.layer.cornerRadius = 4.0
                
                
                
                if let totalVotes = data.totalVotes{
                    TotalVotesLbl.text = "Total Votes: " + "\(totalVotes)"
                    totalPollLbl.text = "Total Votess: " + "\(totalVotes)"
                    if(pollselected == 1){
                        pollSubmitLbl.text = "My Poll: " + "\(data.t1?.bkey?.uppercased() ?? "")"
                    }
                    else if(pollselected == 2){
                        pollSubmitLbl.text = "My Poll: " + "\(data.t2?.bkey?.uppercased() ?? "")"
                    }
                    else if(pollselected == 3){
                        pollSubmitLbl.text = "My Poll: " + "Tie"
                    }
                    else{
                        
                    }
                    var teamOnePercentage = 0.0
                    var teamTwoPercentage = 0.0
                    var tiePercentage = 0.0
                    
                    if totalVotes != 0{
                        if let teamCount1 = data.teamCount1{
                            if let teamCount2 = data.teamCount2{
                                if let tieCount = data.tieCount{
                                    teamOnePercentage = (Double(teamCount1)/Double(totalVotes)) * 100.0
                                    teamTwoPercentage = (Double(teamCount2)/Double(totalVotes)) * 100.0
                                    tiePercentage = (Double(tieCount)/Double(totalVotes)) * 100.0
                                }
                            }
                        }
                    }
                    if totalVotes == 0{
                        if pollselected != 0 && pollselected == 1{
                            TotalVotesLbl.text = "Total Votes: " + "\(1)"
                            totalPollLbl.text = "Total Votess: " + "\(1)"
                            pollSubmitLbl.text = "My Poll: " + "\(data.t1?.bkey?.uppercased() ?? "")"

                            teamOnePercentage = (Double(1)/Double(1)) * 100.0
                            teamTwoPercentage = (Double(0)/Double(1)) * 100.0
                            tiePercentage = (Double(0)/Double(1)) * 100.0
                        }
                        else if pollselected != 0 && pollselected == 2{
                            TotalVotesLbl.text = "Total Votes: " + "\(1)"
                            totalPollLbl.text = "Total Votess: " + "\(1)"
                            pollSubmitLbl.text = "My Poll: " + "\(data.t2?.bkey?.uppercased() ?? "")"
                            
                            teamOnePercentage = (Double(0)/Double(1)) * 100.0
                            teamTwoPercentage = (Double(1)/Double(1)) * 100.0
                            tiePercentage = (Double(0)/Double(1)) * 100.0
                        }
                        else if pollselected != 0 && pollselected == 3{
                            TotalVotesLbl.text = "Total Votes: " + "\(1)"
                            totalPollLbl.text = "Total Votess: " + "\(1)"
                            pollSubmitLbl.text = "My Poll: " + "Tie"
                            
                            teamOnePercentage = (Double(0)/Double(1)) * 100.0
                            teamTwoPercentage = (Double(0)/Double(1)) * 100.0
                            tiePercentage = (Double(1)/Double(1)) * 100.0
                        }
                        
                    }
                    if (teamOnePercentage >= teamTwoPercentage) && (teamOnePercentage >= tiePercentage){
                        AnimateViewOne.backgroundColor = UIColor(red: 0, green: 196/255, blue: 92/255, alpha: 1.0)
                        if teamTwoPercentage > tiePercentage{
                            AnimateViewTwo.backgroundColor = UIColor(red: 237/255, green: 186/255, blue: 0, alpha: 1.0)
                            AnimateViewThree.backgroundColor = UIColor(red: 224/255, green: 87/255, blue: 81/255, alpha: 1.0)
                        }
                        else{
                            AnimateViewTwo.backgroundColor = UIColor(red: 224/255, green: 87/255, blue: 81/255, alpha: 1.0)
                            AnimateViewThree.backgroundColor = UIColor(red: 237/255, green: 186/255, blue: 0, alpha: 1.0)
                        }
                    }
                    else if (teamTwoPercentage >= teamOnePercentage)&&(teamTwoPercentage >= tiePercentage){
                        AnimateViewTwo.backgroundColor = UIColor(red: 0, green: 196/255, blue: 92/255, alpha: 1.0)
                        if teamOnePercentage > tiePercentage{
                            AnimateViewOne.backgroundColor = UIColor(red: 237/255, green: 186/255, blue: 0, alpha: 1.0)
                            AnimateViewThree.backgroundColor = UIColor(red: 224/255, green: 87/255, blue: 81/255, alpha: 1.0)
                        }
                        else{
                            AnimateViewOne.backgroundColor = UIColor(red: 224/255, green: 87/255, blue: 81/255, alpha: 1.0)
                            AnimateViewThree.backgroundColor = UIColor(red: 237/255, green: 186/255, blue: 0, alpha: 1.0)
                        }
                    }
                    else{
                        AnimateViewThree.backgroundColor = UIColor(red: 0, green: 196/255, blue: 92/255, alpha: 1.0)
                        if teamOnePercentage > teamTwoPercentage{
                            AnimateViewOne.backgroundColor = UIColor(red: 237/255, green: 186/255, blue: 0, alpha: 1.0)
                            AnimateViewTwo.backgroundColor = UIColor(red: 224/255, green: 87/255, blue: 81/255, alpha: 1.0)
                        }
                        else{
                            AnimateViewOne.backgroundColor = UIColor(red: 224/255, green: 87/255, blue: 81/255, alpha: 1.0)
                            AnimateViewTwo.backgroundColor = UIColor(red: 237/255, green: 186/255, blue: 0, alpha: 1.0)
                        }
                    }
                    
                    if (Int(teamOnePercentage) + Int(teamTwoPercentage) + Int(tiePercentage)) < 100{
                        if teamOnePercentage > teamTwoPercentage && teamOnePercentage > tiePercentage{
                            teamOnePercentage += 1
                        }
                        else if teamTwoPercentage > tiePercentage && teamTwoPercentage > tiePercentage{
                            teamTwoPercentage += 1
                        }
                        else{
                            tiePercentage += 1
                        }
                    }
                    if totalVotes == 0
                    {
                        tiePercentage = 0
                    }
                    PollTeamOnePercentLbl.text = "\(Int(teamOnePercentage))%"
                    PollTeamTwoPercentLbl.text = "\(Int(teamTwoPercentage))%"
                    PollTiePercentLbl.text = "\(Int(tiePercentage))%"
                    AnimateViewOneWidth.constant = 0
                    AnimateViewTwoWidth.constant = 0
                    AnimateViewThreeWidth.constant = 0
                    self.contentView.layoutIfNeeded()
                    UIView.animate(withDuration: 0.8, animations: {
                        if ScreenSize.SCREEN_HEIGHT == 568{
                            self.AnimateViewOneWidth.constant = CGFloat(Float(teamOnePercentage) * 1.5)
                            self.AnimateViewTwoWidth.constant = CGFloat(Float(teamTwoPercentage) * 1.5)
                            self.AnimateViewThreeWidth.constant = CGFloat(Float(tiePercentage) * 1.5)
                        }else{
                            self.AnimateViewOneWidth.constant = CGFloat(Float(teamOnePercentage) * 1.7)
                            self.AnimateViewTwoWidth.constant = CGFloat(Float(teamTwoPercentage) * 1.7)
                            self.AnimateViewThreeWidth.constant = CGFloat(Float(tiePercentage) * 1.7)
                        }
                        self.contentView.layoutIfNeeded()
                    })
                    UiewTeamone.layer.borderColor = UIColor.clear.cgColor
                    UiviewTie.layer.borderColor = UIColor.clear.cgColor
                    UiviewTeamTwo.layer.borderColor = UIColor.clear.cgColor
                }
                
            }
            
        }
        
        if let matchDate = data.matchDate{
            let date : Date = Date(timeIntervalSince1970: Double(matchDate/1000))
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MMM-yyyy"
            let day = dateFormatter.string(from: date as Date)
            self.DateLbl.text = "\(day)"
        }
        
        if let matchType = data.matchType{
            switch matchType {
            case "test":
                self.matchTypeImageView.image = #imageLiteral(resourceName: "testt")
                break
            case "odi":
                self.matchTypeImageView.image = #imageLiteral(resourceName: "odi")
                break
            case "t20":
                self.matchTypeImageView.image = #imageLiteral(resourceName: "t20")
                break
            default:
                self.matchTypeImageView.image = #imageLiteral(resourceName: "t10")
                break
            }
//            switch matchType{
//            case 1:
//                self.matchTypeImageView.image = #imageLiteral(resourceName: "t10")
//                break
//            case 2:
//                self.matchTypeImageView.image = #imageLiteral(resourceName: "odi")
//                break
//                
//            default:
//                self.matchTypeImageView.image = #imageLiteral(resourceName: "testt")
//                break
//            }
        }
        
        /*if let teamId1 = data.teamId1{
            if let name = teamId1.name{
                PollTeamOneLbl.text = name.uppercased()
                TeamOneLbl.text = name.uppercased()
            }
            
            if let board_team_key = teamId1.board_team_key{
                PredTeamOneLbl.text = board_team_key.uppercased()
            }
            
            if let logo = teamId1.logo{
                TeamOneImageView.af_setImage(withURL: URL(string: logo)!)
            }else{
                TeamOneImageView.image = #imageLiteral(resourceName: "TeamPlaceholder")
            }
        }
        
        if let teamId2 = data.teamId2{
            if let name = teamId2.name{
                PollTeamTwoLbl.text = name.uppercased()
                PredTeamTwoLbl.text = name.uppercased()
                TeamTwoLbl.text = name.uppercased()
            }
            
            if let board_team_key = teamId2.board_team_key{
                PredTeamTwoLbl.text = board_team_key.uppercased()
            }
            
            if let logo = teamId2.logo{
                teamTwoImageView.af_setImage(withURL: URL(string: logo)!)
            }else{
                teamTwoImageView.image = #imageLiteral(resourceName: "TeamPlaceholder")
            }
        }*/
        if let teamId1 = data.t1{
            if let name = teamId1.name{
                PollTeamOneLbl.text = name.uppercased()
                TeamOneLbl.text = name.uppercased()
            }
            
            if let board_team_key = teamId1.bkey{
                PredTeamOneLbl.text = board_team_key.uppercased()
            }
            
            if let logo = teamId1.logo{
                if logo == ""
                    {
                        //TeamOneImageView.image = #imageLiteral(resourceName: "TeamPlaceholder")
                        if let key = teamId1.bkey, key != ""{
                            if let name = teamId1.name{
                                self.TeamOneImageView.image = AppHelper.loadImage(named: key.lowercased(),teamName:name)
                            }
                            else{
                                self.TeamOneImageView.image = AppHelper.loadImage(named: key.lowercased(),teamName:"N/A")
                            }
                            
                        }
                        else{
                            if let name = teamId1.name{
                                
                                self.TeamOneImageView.image = AppHelper.generateImageWithText(text: name, image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:name.uppercased()), size: CGSize(width: 50, height: 50)))
                                
                            }
                            else{
                                
                                self.TeamOneImageView.image = AppHelper.generateImageWithText(text: "N/A", image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:"N/A"), size: CGSize(width: 50, height: 50)))
                                
                            }
                            
                        }
                    }
                
                else{
                    TeamOneImageView.af_setImage(withURL: URL(string: teamspath+logo)!)
                }
                
            }else{
                //TeamOneImageView.image = #imageLiteral(resourceName: "TeamPlaceholder")
                if let key = teamId1.bkey, key != ""{
                    if let name = teamId1.name{
                        self.TeamOneImageView.image = AppHelper.loadImage(named: key.lowercased(),teamName:name)
                    }
                    else{
                        self.TeamOneImageView.image = AppHelper.loadImage(named: key.lowercased(),teamName:"N/A")
                    }
                    
                }
                else{
                    if let name = teamId1.name{
                        
                        self.TeamOneImageView.image = AppHelper.generateImageWithText(text: name, image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:name.uppercased()), size: CGSize(width: 50, height: 50)))
                        
                    }
                    else{
                        
                        self.TeamOneImageView.image = AppHelper.generateImageWithText(text: "N/A", image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:"N/A"), size: CGSize(width: 50, height: 50)))
                        
                    }
                    
                }
            }
        }
        
        if let teamId2 = data.t2{
            if let name = teamId2.name{
                PollTeamTwoLbl.text = name.uppercased()
                TeamTwoLbl.text = name.uppercased()
            }
            
            if let board_team_key = teamId2.bkey{
                PredTeamTwoLbl.text = board_team_key.uppercased()
            }
            
            if let logo = teamId2.logo{
                if logo == ""{
                    //teamTwoImageView.image = #imageLiteral(resourceName: "TeamPlaceholder")
                    if let key = teamId2.bkey, key != ""{
                        if let name = teamId2.name{
                            self.teamTwoImageView.image = AppHelper.loadImage(named: key.lowercased(),teamName:name)
                        }
                        else{
                            self.teamTwoImageView.image = AppHelper.loadImage(named: key.lowercased(),teamName:"N/A")
                        }
                        
                    }
                    else{
                        if let name = teamId2.name{
                            
                            self.teamTwoImageView.image = AppHelper.generateImageWithText(text: name, image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:name.uppercased()), size: CGSize(width: 50, height: 50)))
                            
                        }
                        else{
                            
                            self.teamTwoImageView.image = AppHelper.generateImageWithText(text: "N/A", image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:"N/A"), size: CGSize(width: 50, height: 50)))
                            
                        }
                        
                    }

                }
                else{
                    teamTwoImageView.af_setImage(withURL: URL(string:teamspath+logo)!)
                }
            }else{
                //teamTwoImageView.image = #imageLiteral(resourceName: "TeamPlaceholder")
                if let key = teamId2.bkey, key != ""{
                    if let name = teamId2.name{
                        self.teamTwoImageView.image = AppHelper.loadImage(named: key.lowercased(),teamName:name)
                    }
                    else{
                        self.teamTwoImageView.image = AppHelper.loadImage(named: key.lowercased(),teamName:"N/A")
                    }
                    
                }
                else{
                    if let name = teamId2.name{
                        
                        self.teamTwoImageView.image = AppHelper.generateImageWithText(text: name, image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:name.uppercased()), size: CGSize(width: 50, height: 50)))
                        
                    }
                    else{
                        
                        self.teamTwoImageView.image = AppHelper.generateImageWithText(text: "N/A", image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:"N/A"), size: CGSize(width: 50, height: 50)))
                        
                    }
                    
                }
                
            }
        }
    }
    /*{
        
        if let isPollSubmitted = data.isPollSubmitted,
            let matchDate = data.matchDate
            {
            
            if isPollSubmitted == false && matchDate > Date().toMillis(){
                if let pollQuestion = data.pollQuestion{
                    PollQuesLbl.text = pollQuestion
                }
                TotalVotesLbl.isHidden = true
                SubmitBtn.isHidden = false
                if ScreenSize.SCREEN_HEIGHT == 568{
                    viewTopConst.constant = 25
                    TeamTwoLbl.font = TeamTwoLbl.font.withSize(13)
                    TeamOneLbl.font = TeamOneLbl.font.withSize(13)
                    viewBottomConst.constant = 8
                    quesBottomConst.constant = 8
                    viewHeightConstant.constant = 20
                }
                else
                {
                    TeamTwoLbl.font = TeamTwoLbl.font.withSize(18)
                    TeamOneLbl.font = TeamOneLbl.font.withSize(18)
                }
                UiewTeamone.isHidden = false
                UiviewTeamTwo.isHidden = false
                UiviewTie.isHidden = false
                UiviewTeamOneBorder.isHidden = false
                UiviewTeamTwoborder.isHidden = false
                UiviewTieBorder.isHidden = false
                UIviewTieFill.isHidden = true
                UiviewTeamOneFill.isHidden = true
                UiviewTeamTwoFill.isHidden = true
                UiewTeamone.layer.borderWidth = 1.0
                UiviewTie.layer.borderWidth = 1.0
                UiviewTeamTwo.layer.borderWidth = 1.0
                PredTeamOneLbl.isHidden = true
                PredTeamTieLbl.isHidden = true
                PredTeamTwoLbl.isHidden = true
                PollTiePercentLbl.isHidden = true
                PollTeamOnePercentLbl.isHidden = true
                PollTeamTwoPercentLbl.isHidden = true
                AnimateViewOne.isHidden = true
                AnimateViewTwo.isHidden = true
                AnimateViewThree.isHidden = true
                UiewTeamone.layer.borderColor = UIColor(red: 47/255, green: 104/255, blue: 148/255, alpha: 1.0).cgColor
                UiviewTie.layer.borderColor = UIColor(red: 47/255, green: 104/255, blue: 148/255, alpha: 1.0).cgColor
                UiviewTeamTwo.layer.borderColor = UIColor(red: 47/255, green: 104/255, blue: 148/255, alpha: 1.0).cgColor
                UiewTeamone.backgroundColor = UIColor.white
                UiviewTie.backgroundColor = UIColor.white
                UiviewTeamTwo.backgroundColor = UIColor.white
            }else{
                if ScreenSize.SCREEN_HEIGHT == 568{
                    viewTopConst.constant = 25
                    TeamTwoLbl.font = TeamTwoLbl.font.withSize(13)
                    TeamOneLbl.font = TeamOneLbl.font.withSize(13)
                    viewBottomConst.constant = 8
                    quesBottomConst.constant = 8
                    viewHeightConstant.constant = 20
                }
                else
                {
                    TeamTwoLbl.font = TeamTwoLbl.font.withSize(18)
                    TeamOneLbl.font = TeamOneLbl.font.withSize(18)
                }
                PredTeamTieLbl.text = "TIE"
                PredTeamOneLbl.isHidden = false
                PredTeamTieLbl.isHidden = false
                PredTeamTwoLbl.isHidden = false
                PollTiePercentLbl.isHidden = false
                PollTeamOnePercentLbl.isHidden = false
                PollTeamTwoPercentLbl.isHidden = false
                AnimateViewOne.isHidden = false
                AnimateViewTwo.isHidden = false
                AnimateViewThree.isHidden = false
                PollQuesLbl.text = "PREDICTIONS"
                SubmitBtn.isHidden = true
                TotalVotesLbl.isHidden = false
                UiviewTeamOneBorder.isHidden = true
                UiviewTeamTwoborder.isHidden = true
                UiviewTieBorder.isHidden = true
                UIviewTieFill.isHidden = true
                UiviewTeamOneFill.isHidden = true
                UiviewTeamTwoFill.isHidden = true
                UiewTeamone.isHidden = true
                UiviewTeamTwo.isHidden = true
                UiviewTie.isHidden = true
                UiewTeamone.backgroundColor = UIColor.clear
                UiviewTie.backgroundColor = UIColor.clear
                UiviewTeamTwo.backgroundColor = UIColor.clear
                AnimateViewThree.layer.cornerRadius = 4.0
                AnimateViewTwo.layer.cornerRadius = 4.0
                AnimateViewOne.layer.cornerRadius = 4.0
                
                
                if let totalVotes = data.totalVotes{
                    TotalVotesLbl.text = "Total Votes: " + "\(totalVotes)"
                    
                    var teamOnePercentage = 0.0
                    var teamTwoPercentage = 0.0
                    var tiePercentage = 0.0
                    
                    if totalVotes != 0{
                        if let teamCount1 = data.teamCount1{
                            if let teamCount2 = data.teamCount2{
                                if let tieCount = data.tieCount{
                                    teamOnePercentage = (Double(teamCount1)/Double(totalVotes)) * 100.0
                                    teamTwoPercentage = (Double(teamCount2)/Double(totalVotes)) * 100.0
                                    tiePercentage = (Double(tieCount)/Double(totalVotes)) * 100.0
                                }
                            }
                        }
                    }
                    
                    if (teamOnePercentage >= teamTwoPercentage) && (teamOnePercentage >= tiePercentage){
                        AnimateViewOne.backgroundColor = UIColor(red: 0, green: 196/255, blue: 92/255, alpha: 1.0)
                        if teamTwoPercentage > tiePercentage{
                            AnimateViewTwo.backgroundColor = UIColor(red: 237/255, green: 186/255, blue: 0, alpha: 1.0)
                            AnimateViewThree.backgroundColor = UIColor(red: 224/255, green: 87/255, blue: 81/255, alpha: 1.0)
                        }
                        else{
                            AnimateViewTwo.backgroundColor = UIColor(red: 224/255, green: 87/255, blue: 81/255, alpha: 1.0)
                            AnimateViewThree.backgroundColor = UIColor(red: 237/255, green: 186/255, blue: 0, alpha: 1.0)
                        }
                    }
                    else if (teamTwoPercentage >= teamOnePercentage)&&(teamTwoPercentage >= tiePercentage){
                        AnimateViewTwo.backgroundColor = UIColor(red: 0, green: 196/255, blue: 92/255, alpha: 1.0)
                        if teamOnePercentage > tiePercentage{
                            AnimateViewOne.backgroundColor = UIColor(red: 237/255, green: 186/255, blue: 0, alpha: 1.0)
                            AnimateViewThree.backgroundColor = UIColor(red: 224/255, green: 87/255, blue: 81/255, alpha: 1.0)
                        }
                        else{
                            AnimateViewOne.backgroundColor = UIColor(red: 224/255, green: 87/255, blue: 81/255, alpha: 1.0)
                            AnimateViewThree.backgroundColor = UIColor(red: 237/255, green: 186/255, blue: 0, alpha: 1.0)
                        }
                    }
                    else{
                        AnimateViewThree.backgroundColor = UIColor(red: 0, green: 196/255, blue: 92/255, alpha: 1.0)
                        if teamOnePercentage > teamTwoPercentage{
                            AnimateViewOne.backgroundColor = UIColor(red: 237/255, green: 186/255, blue: 0, alpha: 1.0)
                            AnimateViewTwo.backgroundColor = UIColor(red: 224/255, green: 87/255, blue: 81/255, alpha: 1.0)
                        }
                        else{
                            AnimateViewOne.backgroundColor = UIColor(red: 224/255, green: 87/255, blue: 81/255, alpha: 1.0)
                            AnimateViewTwo.backgroundColor = UIColor(red: 237/255, green: 186/255, blue: 0, alpha: 1.0)
                        }
                    }
                    
                    if (Int(teamOnePercentage) + Int(teamTwoPercentage) + Int(tiePercentage)) < 100{
                        if teamOnePercentage > teamTwoPercentage && teamOnePercentage > tiePercentage{
                            teamOnePercentage += 1
                        }
                        else if teamTwoPercentage > tiePercentage && teamTwoPercentage > tiePercentage{
                            teamTwoPercentage += 1
                        }
                        else{
                            tiePercentage += 1
                        }
                    }
                    if totalVotes == 0
                    {
                        tiePercentage = 0
                    }
                    PollTeamOnePercentLbl.text = "\(Int(teamOnePercentage))%"
                    PollTeamTwoPercentLbl.text = "\(Int(teamTwoPercentage))%"
                    PollTiePercentLbl.text = "\(Int(tiePercentage))%"
                    AnimateViewOneWidth.constant = 0
                    AnimateViewTwoWidth.constant = 0
                    AnimateViewThreeWidth.constant = 0
                    self.contentView.layoutIfNeeded()
                    UIView.animate(withDuration: 0.8, animations: {
                        if ScreenSize.SCREEN_HEIGHT == 568{
                            self.AnimateViewOneWidth.constant = CGFloat(Float(teamOnePercentage) * 1.5)
                            self.AnimateViewTwoWidth.constant = CGFloat(Float(teamTwoPercentage) * 1.5)
                            self.AnimateViewThreeWidth.constant = CGFloat(Float(tiePercentage) * 1.5)
                        }else{
                            self.AnimateViewOneWidth.constant = CGFloat(Float(teamOnePercentage) * 1.7)
                            self.AnimateViewTwoWidth.constant = CGFloat(Float(teamTwoPercentage) * 1.7)
                            self.AnimateViewThreeWidth.constant = CGFloat(Float(tiePercentage) * 1.7)
                        }
                        self.contentView.layoutIfNeeded()
                    })
                    UiewTeamone.layer.borderColor = UIColor.clear.cgColor
                    UiviewTie.layer.borderColor = UIColor.clear.cgColor
                    UiviewTeamTwo.layer.borderColor = UIColor.clear.cgColor
                }
            }
        }
        
        if let matchDate = data.matchDate{
            let date : Date = Date(timeIntervalSince1970: Double(matchDate/1000))
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MMM-yyyy"
            let day = dateFormatter.string(from: date as Date)
            self.DateLbl.text = "\(day)"
        }
        
        if let matchType = data.matchType{
            switch matchType{
            case 1:
                self.matchTypeImageView.image =  #imageLiteral(resourceName: "t20")
                break
            case 2:
                self.matchTypeImageView.image = #imageLiteral(resourceName: "odi")
                break
            default:
                self.matchTypeImageView.image = #imageLiteral(resourceName: "test")
                break
            }
        }
        
        if let teamId1 = data.teamId1{
            if let name = teamId1.name{
                PollTeamOneLbl.text = name.uppercased()
                TeamOneLbl.text = name.uppercased()
            }
            
            if let board_team_key = teamId1.board_team_key{
                PredTeamOneLbl.text = board_team_key.uppercased()
            }
            
            if let logo = teamId1.logo{
                TeamOneImageView.af_setImage(withURL: URL(string: logo)!)
            }else{
                TeamOneImageView.image = #imageLiteral(resourceName: "TeamPlaceholder")
            }
        }
        
        if let teamId2 = data.teamId2{
            if let name = teamId2.name{
                PollTeamTwoLbl.text = name.uppercased()
                PredTeamTwoLbl.text = name.uppercased()
                TeamTwoLbl.text = name.uppercased()
            }
            
            if let board_team_key = teamId2.board_team_key{
                PredTeamTwoLbl.text = board_team_key.uppercased()
            }
            
            if let logo = teamId2.logo{
                teamTwoImageView.af_setImage(withURL: URL(string: logo)!)
            }else{
                teamTwoImageView.image = #imageLiteral(resourceName: "TeamPlaceholder")
            }
        }
    }*/
    override func prepareForReuse() {
        super.prepareForReuse()
        UiewTeamone.isHidden = true
        UiviewTeamTwo.isHidden = true
        UiviewTie.isHidden = true
        UiviewTeamOneBorder.isHidden = true
        UiviewTeamTwoborder.isHidden = true
        UiviewTieBorder.isHidden = true
        UIviewTieFill.isHidden = true
        UiviewTeamOneFill.isHidden = true
        UiviewTeamTwoFill.isHidden = true
        PredTeamOneLbl.isHidden = true
        PredTeamTieLbl.isHidden = true
        PredTeamTwoLbl.isHidden = true
        PollTiePercentLbl.isHidden = true
        PollTeamOnePercentLbl.isHidden = true
        PollTeamTwoPercentLbl.isHidden = true
        AnimateViewOne.isHidden = true
        AnimateViewTwo.isHidden = true
        AnimateViewThree.isHidden = true
        PredTeamOneLbl.isHidden = true
        PredTeamTieLbl.isHidden = true
        PredTeamTwoLbl.isHidden = true
        PollTiePercentLbl.isHidden = true
        PollTeamOnePercentLbl.isHidden = true
        PollTeamTwoPercentLbl.isHidden = true
        AnimateViewOne.isHidden = true
        AnimateViewTwo.isHidden = true
        AnimateViewThree.isHidden = true
        SubmitBtn.isHidden = true
        pollView.isHidden = true
        TotalVotesLbl.isHidden = true
        UiviewTeamOneBorder.isHidden = true
        UiviewTeamTwoborder.isHidden = true
        UiviewTieBorder.isHidden = true
        UIviewTieFill.isHidden = true
        UiviewTeamOneFill.isHidden = true
        UiviewTeamTwoFill.isHidden = true
        UiewTeamone.isHidden = true
        UiviewTeamTwo.isHidden = true
        UiviewTie.isHidden = true
        
    }
    override func draw(_ rect: CGRect) {
        MainView.layer.cornerRadius = 6.0
        UiviewTeamOneBorder.layer.cornerRadius =  UiviewTeamOneBorder.frame.height/2
        UiviewTeamTwoborder.layer.cornerRadius = UiviewTeamTwoborder.frame.height/2
        UiviewTieBorder.layer.cornerRadius = UiviewTieBorder.frame.height/2
        UIviewTieFill.layer.cornerRadius = UIviewTieFill.frame.height/2
        UiviewTeamOneFill.layer.cornerRadius = UiviewTeamOneFill.frame.height/2
        UiviewTeamTwoFill.layer.cornerRadius = UiviewTeamTwoFill.frame.height/2
        UiviewTie.layer.cornerRadius = 4.0
        UiviewTeamTwo.layer.cornerRadius = 4.0
        UiewTeamone.layer.cornerRadius = 4.0
        SubmitBtn.layer.cornerRadius = 4.0
        UiviewTieBorder.layer.borderWidth = 1.0
        UiviewTeamTwoborder.layer.borderWidth = 1.0
        UiviewTeamOneBorder.layer.borderWidth = 1.0
       UiviewTieBorder.layer.borderColor = UIColor(red: 59/255, green: 70/255, blue: 113/255, alpha: 1.0).cgColor
        UiviewTeamTwoborder.layer.borderColor = UIColor(red: 59/255, green: 70/255, blue: 113/255, alpha: 1.0).cgColor
        UiviewTeamOneBorder.layer.borderColor = UIColor(red: 59/255, green: 70/255, blue: 113/255, alpha: 1.0).cgColor
    }

}

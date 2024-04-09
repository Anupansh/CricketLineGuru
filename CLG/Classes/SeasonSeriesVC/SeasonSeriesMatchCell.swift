//
//  SeasonSeriesMatchCell.swift
//  cricrate
//
//  Created by Anuj Naruka on 10/7/17.
//  Copyright © 2017 Cricket Line Guru. All rights reserved.
//

import UIKit

class SeasonSeriesMatchCell: UITableViewCell {

    //MARK:-IBOutlets
    
    @IBOutlet weak var MainView: UIView!
    @IBOutlet weak var ImgViewLeftTeam: UIImageView!
    @IBOutlet weak var ImgViewRightTeam: UIImageView!
    @IBOutlet weak var ImgViewBanner: UIImageView!
    @IBOutlet weak var LblMatchDateTime: UILabel!
    @IBOutlet weak var LblVenue: UILabel!
    @IBOutlet weak var LblRightTeamName: UILabel!
    @IBOutlet weak var LblLeftTeamName: UILabel!
    @IBOutlet weak var LblResult: UILabel!
    lazy var teamsPath: String = {
        let teamsPath = String()
        return teamsPath
    }()
    override func awakeFromNib()
    {
        super.awakeFromNib()
        MainView.layer.cornerRadius = 8.0
        ImgViewLeftTeam.layer.cornerRadius = ImgViewLeftTeam.frame.height/2
        ImgViewLeftTeam?.clipsToBounds = true
        ImgViewRightTeam.layer.cornerRadius = ImgViewRightTeam.frame.height/2
        ImgViewRightTeam?.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(data:CLGHomeResponseResultSeriesMatchesData){
        self.ImgViewLeftTeam.image = #imageLiteral(resourceName: "TeamPlaceholder")
        self.ImgViewRightTeam.image = #imageLiteral(resourceName: "TeamPlaceholder")
        
       /* if let start_date = data.start_date{
            let date : Date = Date(timeIntervalSince1970: Double(start_date.timestamp!))
            self.ImgViewBanner.image = UIImage(named: (date.dayOfWeek())!)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM hh:mm a"
            if let related_name = data.related_name{
                var arr = related_name.components(separatedBy: "-")
                if arr.count <= 1{
                    self.LblVenue.text = dateFormatter.string(from: date) + ", " + related_name
                }
                else{
                    self.LblVenue.text = dateFormatter.string(from: date) + ", " + "\(arr[0])"
                }
            }
        }*/
        
        if let start_date = data.st_date{
            let matchDate = AppHelper.stringToGmtDate(strDate: start_date, format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
            if matchDate != nil{
                self.ImgViewBanner.image = UIImage(named: (matchDate!.dayOfWeek())!)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd MMM hh:mm a"
                if let related_name = data.rel_name{
                    var arr = related_name.components(separatedBy: "-")
                    if arr.count <= 1{
                        self.LblVenue.text = dateFormatter.string(from: matchDate!) + ", " + related_name
                    }
                    else{
                        self.LblVenue.text = dateFormatter.string(from: matchDate!) + ", " + "\(arr[0])"
                    }
                }
            }
        }
            
            
        if let venue = data.venue{
            var arr = venue.components(separatedBy: ",")
            if arr.count > 2
            {
                self.LblMatchDateTime.text = "\(arr[1]), \(arr[2])" //venue
            }
            else if arr.count > 1
            {
                self.LblMatchDateTime.text = "\(arr[1])"
            }
            else if arr.count == 1{
                self.LblMatchDateTime.text = "\(arr[0])"
            }
            else
            {
                self.LblMatchDateTime.text = ""
            }
        }else{
            self.LblMatchDateTime.text = ""
        }
        
        if let teams = data.teams{
            
            var lblAHeight = CGFloat()
            var lblBHeight = CGFloat()
            var lblAName = String()
            var lblBName = String()
            var lblAKey = String()
            var lblBKey = String()
            
            if let a = teams.a{
                if let name = a.name?.lowercased(){
                    lblAHeight = AppHelper.heightForLabel(text: name, font: UIFont(name: "Lato-Bold", size: 10.0)!, width: LblLeftTeamName.frame.size.width)
                    lblAName = name
                    if let key = a.key{
                       lblAKey = key
                    }
                }
                if let logo = a.logo, logo != ""{
                    self.ImgViewLeftTeam.af_setImage(withURL: URL(string: self.teamsPath + logo)!)
                }else{
                    if let key = a.key, key != ""{
                        if let name = a.name{
                            self.ImgViewLeftTeam.image = AppHelper.loadImage(named: key.lowercased(),teamName:name)
                        }
                        else{
                            self.ImgViewLeftTeam.image = AppHelper.loadImage(named: key.lowercased(),teamName:"N/A")
                        }
                        
                    }
                    else{
                        if let name = a.name{
                            
                            self.ImgViewLeftTeam.image = AppHelper.generateImageWithText(text: name, image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:name.uppercased()), size: CGSize(width: 50, height: 50)))
                            
                        }
                        else{
                            
                            self.ImgViewLeftTeam.image = AppHelper.generateImageWithText(text: "N/A", image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:"N/A"), size: CGSize(width: 50, height: 50)))
                            
                        }
                        
                    }
                    //self.ImgViewLeftTeam.image = #imageLiteral(resourceName: "TeamPlaceholder")
                }
            }
            
            if let b = teams.b{
                if let name = b.name?.lowercased(){
                    lblBHeight = AppHelper.heightForLabel(text: name, font: UIFont(name: "Lato-Bold", size: 10.0)!, width: LblRightTeamName.frame.size.width)
                    lblBName = name
                    if let key = b.key{
                        lblBKey = key
                    }
                }
                if let logo = b.logo, logo != ""{
                    self.ImgViewRightTeam.af_setImage(withURL: URL(string: self.teamsPath + logo)!)
                }else{
                    if let key = b.key, key != ""{
                        if let name = b.name{
                            self.ImgViewRightTeam.image = AppHelper.loadImage(named: key.lowercased(),teamName:name)
                        }
                        else{
                            self.ImgViewRightTeam.image = AppHelper.loadImage(named: key.lowercased(),teamName:"N/A")
                        }
                        
                    }
                    else{
                        if let name = b.name{
                            self.ImgViewRightTeam.image = AppHelper.generateImageWithText(text: name, image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:name.uppercased()), size: CGSize(width: 50, height: 50)))
                            
                        }
                        else{
                            self.ImgViewRightTeam.image = AppHelper.generateImageWithText(text: "N/A", image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:"N/A"), size: CGSize(width: 50, height: 50)))
                            
                        }
                        
                    }
                    //self.ImgViewRightTeam.image = #imageLiteral(resourceName: "TeamPlaceholder")
                }
            }
            
            if lblAName.contains("women") || lblBName.contains("women") || lblAHeight > 12 || lblBHeight > 12{
//                LblLeftTeamName.text = lblAKey.uppercased()
//                LblRightTeamName.text = lblBKey.uppercased()
                LblLeftTeamName.text = lblAName.uppercased()
                LblRightTeamName.text = lblBName.uppercased()
            }else{
                LblLeftTeamName.text = lblAName.uppercased()
                LblRightTeamName.text = lblBName.uppercased()
            }
            
        }
        
        if let status = data.status, status == "completed"{
            if let msgs = data.msgs{
                if let info = msgs.info{
                    self.LblResult.text = info
                    self.LblResult.textColor = UIColor(red: 250.0/255.0, green: 63.0/255.0, blue: 87.0/255.0, alpha: 1.0)
                }
            }
        }else{
            //self.LblResult.text = "Coming Soon"
            self.LblResult.textColor = UIColor(red: 250.0/255.0, green: 63.0/255.0, blue: 87.0/255.0, alpha: 1.0)
            if let start_date = data.st_date{
                let matchDate = AppHelper.stringToGmtDate(strDate: start_date, format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                if matchDate != nil{
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd MMM hh:mm a"
                    let matchmilisecnd = matchDate!.currentTimeMillis() //AppHelper.currentTimeInMiliseconds(currentDate:matchDate!,format:"dd MMM hh:mm a")
                    let datee = Date()
                    let currentmilisecond = datee.currentTimeMillis()//AppHelper.currentTimeInMiliseconds(currentDate:datee,format:"dd MMM hh:mm a")
                    
                    if matchmilisecnd <  currentmilisecond{
                        if let status = data.status, status == "completed"{
                            if let msgs = data.msgs{
                                if let info = msgs.info{
                                    self.LblResult.text = info
                                }
                            }
                        }
                        else{
                            self.LblResult.text = "LIVE"
                        }
                    }
                    else{
                        if AppHelper.getMilliseconds(strDate: matchDate!) >= -259200000  {
                            print("less than 3 days")
                            self.LblResult.text = "Coming Soon"
                        }else{
                            print("greater than 3 days")
                            self.LblResult.text = "Upcoming"
                        }
                    }
                }
            }
        }
    }
}

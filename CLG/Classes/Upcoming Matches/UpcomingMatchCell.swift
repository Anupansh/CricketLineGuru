//
//  UpcomingMatchCell.swift
//  cricrate
//
//  Created by Anuj Naruka on 9/20/17.
//  Copyright © 2017 Cricket Line Guru. All rights reserved.
//

import UIKit

class UpcomingMatchCell: UITableViewCell {
    
    //MARK:-IBOutlets
    
    @IBOutlet weak var MainView: UIView!
    @IBOutlet weak var ImgViewLeftTeam: CircularImageV!
    @IBOutlet weak var ImgViewRightTeam: CircularImageV!
    @IBOutlet weak var ImgViewBanner: UIImageView!
    @IBOutlet weak var LblMatchDateTime: UILabel!
    @IBOutlet weak var LblVenue: UILabel!
    @IBOutlet weak var LblTeamsname: UILabel!
    @IBOutlet weak var LblMatchNo: UILabel!
    @IBOutlet weak var LblRightTeamName: UILabel!
    @IBOutlet weak var LblLeftTeamName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.LblTeamsname.text = ""
        MainView.layer.cornerRadius = 8.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    func configureCell(upcomingData:CLGRecentMatchModelV3,path:String){
        self.ImgViewLeftTeam.image = #imageLiteral(resourceName: "TeamPlaceholder")
        self.ImgViewRightTeam.image = #imageLiteral(resourceName: "TeamPlaceholder")
        LblMatchDateTime.text = ""
        LblVenue.text = ""
        LblTeamsname.text = ""
        LblMatchNo.text = ""
        LblRightTeamName.text = ""
        LblLeftTeamName.text = ""
        
        if let start_date = upcomingData.st_date{
            let date = AppHelper.stringToGmtDate(strDate: start_date, format: "yyyy-MM-dd HH:mm:ss")
            self.ImgViewBanner.image = UIImage(named: (date?.dayOfWeek())!)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM hh:mm a"
            if let related_name = upcomingData.rel_name{
                var arr = related_name.components(separatedBy: "-")
                if arr.count <= 1{
                    self.LblVenue.text = dateFormatter.string(from: date!) + ", " + related_name
                }
                else{
                    self.LblVenue.text = dateFormatter.string(from: date!) + ", " + "\(arr[0])"
                }
            }
        }
        
//        if let name = upcomingData.name{
//            self.LblTeamsname.text = name
//        }
        if let venue = upcomingData.venue{
            var arr = venue.components(separatedBy: ",")
            if arr.count > 2
            {
                self.LblMatchDateTime.text = "\(arr[1]), \(arr[2])" //venue
            }
            else if arr.count > 1
            {
                self.LblMatchDateTime.text = "\(arr[1])"
            }
            else{
                self.LblVenue.text = ""
            }
        }else{
            self.LblVenue.text = ""
        }
        
        /*if let season = upcomingData.season{
            if let name = season.name{
                self.LblMatchNo.text = name
            }
        }*/
        if let sName = upcomingData.s_name{
            self.LblMatchNo.text = sName
        }
        
        if let teams = upcomingData.teams{
            if let a = teams.a{
                if let name = a.name?.lowercased(){
                    if name.contains("women"){
                        if let key = a.name{
                            self.LblLeftTeamName.text = key.uppercased()
                        }
                    }else{
                        self.LblLeftTeamName.text = a.name?.uppercased()
                    }
                }else{
                    self.LblLeftTeamName.text = ""
                }
                if let logo = a.logo, logo != ""{
                    self.ImgViewLeftTeam.af_setImage(withURL: URL(string: (path+logo).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
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
            }else{
                self.LblLeftTeamName.text = ""
            }
            if let b = teams.b{
                if let name = b.name?.lowercased(){
                    if name.contains("women"){
                        if let key = b.name{
                            self.LblRightTeamName.text = key.uppercased()
                        }
                    }else{
                        self.LblRightTeamName.text = b.name?.uppercased()
                    }
                }else{
                    self.LblRightTeamName.text = ""
                }
                if let logo = b.logo, logo != ""{
                    self.ImgViewRightTeam.af_setImage(withURL: URL(string: (path+logo).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
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
            }else{
                self.LblRightTeamName.text = ""
            }
        }
    }

    func configureCellTeam(upcomingData:CLGRecentMatchModel,path:String){
        self.ImgViewLeftTeam.image = #imageLiteral(resourceName: "TeamPlaceholder")
        self.ImgViewRightTeam.image = #imageLiteral(resourceName: "TeamPlaceholder")
        LblMatchDateTime.text = ""
        LblVenue.text = ""
        LblTeamsname.text = ""
        LblMatchNo.text = ""
        LblRightTeamName.text = ""
        LblLeftTeamName.text = ""
        
        if let start_date = upcomingData.st_date{
            let date = AppHelper.stringToGmtDate(strDate: start_date, format: "yyyy-MM-dd HH:mm:ss")
            self.ImgViewBanner.image = UIImage(named: (date?.dayOfWeek())!)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd MMM hh:mm a"
            if let related_name = upcomingData.rel_name{
                var arr = related_name.components(separatedBy: "-")
                if arr.count <= 1{
                    self.LblVenue.text = dateFormatter.string(from: date!) + ", " + related_name
                }
                else{
                    self.LblVenue.text = dateFormatter.string(from: date!) + ", " + "\(arr[0])"
                }
            }
        }
        
//        if let name = upcomingData.name{
//            self.LblTeamsname.text = name
//        }
        
        if let venue = upcomingData.venue{
            var arr = venue.components(separatedBy: ",")
            if arr.count > 2
            {
                self.LblMatchDateTime.text = "\(arr[1]), \(arr[2])" //venue
            }
            else if arr.count > 1
            {
                self.LblMatchDateTime.text = "\(arr[1])"
            }
            else{
                self.LblVenue.text = ""
            }
        }else{
            self.LblVenue.text = ""
        }
        
        if let season = upcomingData.season{
            if let name = season.name{
                self.LblMatchNo.text = name
            }
        }
        
        
        if let teams = upcomingData.teams{
            if let a = teams.a{
                if let name = a.name?.lowercased(){
                    if name.contains("women"){
                        if let key = a.name{
                            self.LblLeftTeamName.text = key.uppercased()
                        }
                    }else{
                        self.LblLeftTeamName.text = a.name?.uppercased()
                    }
                }else{
                    self.LblLeftTeamName.text = ""
                }
                if let logo = a.logo, logo != ""{
                    self.ImgViewLeftTeam.af_setImage(withURL: URL(string: (path+logo).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
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
            }else{
                self.LblLeftTeamName.text = ""
            }
            if let b = teams.b{
                if let name = b.name?.lowercased(){
                    if name.contains("women"){
                        if let key = b.name{
                            self.LblRightTeamName.text = key.uppercased()
                        }
                    }else{
                        self.LblRightTeamName.text = b.name?.uppercased()
                    }
                }else{
                    self.LblRightTeamName.text = ""
                }
                if let logo = b.logo, logo != ""{
                    self.ImgViewRightTeam.af_setImage(withURL: URL(string: (path+logo).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
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
            }else{
                self.LblRightTeamName.text = ""
            }
        }
    }
}

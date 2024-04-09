//
//  TeamCell.swift
//  CLG
//
//  Created by Brainmobi on 30/07/18.
//  Copyright © 2018 Anuj Naruka. All rights reserved.
//

import UIKit

class TeamCell: UITableViewCell {

    //MARK:- IBOutlets
    
    @IBOutlet weak var imgViewTeam: UIImageView!
    @IBOutlet weak var lblTeamName: UILabel!
    @IBOutlet weak var lblCountryName: UILabel!

    //MARK:- View LifeCycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCellData(data:CLGTeamNameModel,teamspath:String,classType:String){
        
        if let name = data.name{
            lblTeamName.text = name
        }
        
        if classType == "Team"{
            lblCountryName.text = ""
            if let logo = data.logo, logo != ""{
                self.imgViewTeam.af_setImage(withURL: URL(string: (teamspath+logo))!)
            }
            else if let playerImage = data.playerImage, playerImage != ""{
                self.imgViewTeam.af_setImage(withURL: URL(string: playerImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
            }
            else{
                if let key = data.key, key != ""{
                    if let name = data.name{
                        self.imgViewTeam.image = AppHelper.loadImage(named: key.lowercased(),teamName:name)
                    }
                    else{
                        self.imgViewTeam.image = AppHelper.loadImage(named: key.lowercased(),teamName:"N/A")
                    }
                }
                else{
                    if let name = data.name{
                        
                        self.imgViewTeam.image = AppHelper.generateImageWithText(text: name, image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:name.uppercased()), size: CGSize(width: 50, height: 50)))
                        
                    }
                    else{
                        
                        self.imgViewTeam.image = AppHelper.generateImageWithText(text: "N/A", image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:"N/A"), size: CGSize(width: 50, height: 50)))
                        
                    }
                    
                }
                //self.ImgViewLeftTeam.image = #imageLiteral(resourceName: "TeamPlaceholder")
            }
        }
        else{
            if let country = data.cntry{
                lblCountryName.text = country
            }
            else{
                lblCountryName.text = ""
            }
            if let logo = data.logo, logo != ""{
                self.imgViewTeam.af_setImage(withURL: URL(string: (teamspath+logo))!)
            }
             else if let playerImage = data.playerImage, playerImage != ""{
                self.imgViewTeam.af_setImage(withURL: URL(string: playerImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
            }
             else{
                //self.imgViewTeam.image = #imageLiteral(resourceName: "TeamPlaceholder")
                if let name = data.name{
                    
                    self.imgViewTeam.image = AppHelper.generateImageWithText(text: name, image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:name.uppercased()), size: CGSize(width: 50, height: 50)))
                    
                }
                else{
                    
                    self.imgViewTeam.image = AppHelper.generateImageWithText(text: "N/A", image: AppHelper.getImageWithColor(color: AppHelper.returnColorOfTeam(teamName:"N/A"), size: CGSize(width: 50, height: 50)))
                    
                }
            }
        }
    }
    
}

//
//  DescriptionImgCell.swift
//  CLG
//
//  Created by Brainmobi on 26/07/18.
//  Copyright © 2018 Anuj Naruka. All rights reserved.
//

import UIKit

class DescriptionImgCell: UITableViewCell {

    @IBOutlet weak var latestNewsImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(data:CLGHomeResponseDataNewsV3,baseUrl:String){
        self.latestNewsImage.layer.borderWidth = 1.0
        self.latestNewsImage.layer.borderColor = UIColor.clear.cgColor
        if let thumbUrl = data.image{
            self.latestNewsImage.af_setImage(withURL: URL(string: (baseUrl+thumbUrl).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
        }
        else{
            self.latestNewsImage.image = UIImage(named: "news_placeholder")
        }
    }
    
}

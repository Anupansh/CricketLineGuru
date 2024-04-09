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
    
    func setData(data:CLGHomeResponseResultNewsData){
        self.latestNewsImage.layer.borderWidth = 1.0
        self.latestNewsImage.layer.borderColor = UIColor.clear.cgColor
        if let thumbUrl = data.thumb_url{
            self.latestNewsImage.af_setImage(withURL: URL(string: thumbUrl)!)
        }
        else{
            self.latestNewsImage.image = UIImage(named: "news_placeholder")
        }
    }
    
}

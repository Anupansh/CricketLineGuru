//
//  matchLineAdCell.swift
//  CLG
//
//  Created by Anuj Naruka on 8/1/18.
//  Copyright © 2018 Anuj Naruka. All rights reserved.
//

import UIKit
import GoogleMobileAds

class matchLineAdCell: UITableViewCell {
    
    @IBOutlet weak var adView: FBNativeAdView!
    //MARK:-IBOutlet
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var fbmediaView: FBMediaView!
    @IBOutlet weak var adLbl: UILabel!
    @IBOutlet weak var calToViewActionBtn: UIButton!
    @IBOutlet weak var headlineLbl: UILabel!
    @IBOutlet weak var bodyViewLbl: UILabel!
    @IBOutlet weak var adImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

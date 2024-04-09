//
//  InfoCell.swift
//  CLG
//
//  Created by Anuj Naruka on 8/1/18.
//  Copyright © 2018 Anuj Naruka. All rights reserved.
//

import UIKit
import GoogleMobileAds

class InfoCell: UITableViewCell {
    
    //MARK:-IBOutlet
    @IBOutlet weak var proportionalWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblValue: UILabel!
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var nativeAdView: GADUnifiedNativeAdView!
    
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

//
//  HomeNewsAdCell.swift
//  CLG
//
//  Created by Anuj Naruka on 11/13/18.
//  Copyright © 2018 Anuj Naruka. All rights reserved.
//

import UIKit

class HomeNewsAdCell: UITableViewCell {
    
    @IBOutlet weak var lblNewsTime: UILabel!
    @IBOutlet weak var lblNewTitle: UILabel!
    @IBOutlet weak var lblNewsDiscription: UILabel!
    @IBOutlet weak var imgViewNews: UIImageView!
    @IBOutlet weak var youtubeImgVw: UIImageView!


    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        youtubeImgVw.isHidden = true
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}

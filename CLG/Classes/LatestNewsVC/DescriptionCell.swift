//
//  DescriptionCell.swift
//  CLG
//
//  Created by Brainmobi on 26/07/18.
//  Copyright © 2018 Anuj Naruka. All rights reserved.
//

import UIKit

class DescriptionCell: UITableViewCell {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(data:CLGHomeResponseDataNewsV3){
        if let created = data.created{
            let createdDate = AppHelper.stringToGmtDate(strDate: created, format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEE, MMMM dd - h:mm a"
            self.dateLbl.text = dateFormatter.string(from: createdDate!)
        }
        if let description = data.description{
            self.descriptionLbl.text = description.html2String
        }else{
            self.descriptionLbl.text = ""
        }
        if let title = data.title{
            self.titleLbl.text = title
        }else{
            self.titleLbl.text = ""
        }
    }
}

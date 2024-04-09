//
//  SeasonSeriesListCell.swift
//  cricrate
//  Created by Anuj Naruka on 10/7/17.
//  Copyright © 2017 Cricket Line Guru. All rights reserved.

import UIKit

class SeasonSeriesListCell: UITableViewCell
{
    //MARK:-IBOutlet
    
    @IBOutlet weak var LblSeasonSeriesName: UILabel!
    @IBOutlet weak var LblSeriesTime: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(data:CLGHomeResponseResultSeriesData){
        self.preservesSuperviewLayoutMargins = false
        self.separatorInset = UIEdgeInsets.zero
        self.layoutMargins = UIEdgeInsets.zero
        self.accessoryType = .disclosureIndicator
        self.accessoryView = UIImageView(image: #imageLiteral(resourceName: "shape"))
        if let name = data.name{
            self.LblSeasonSeriesName.text = name
        }
//        if let start_date = data.start_date{
//            if let end_date = data.end_date{
//                let date : Date = Date(timeIntervalSince1970: Double(start_date.timestamp!))
//                let date1 : Date = Date(timeIntervalSince1970: Double(end_date.timestamp!))
//                let loaclFormatter = DateFormatter()
//                loaclFormatter.dateFormat = "dd MMM"//EEE, MMM d, yyyy -
//                let StartDate = loaclFormatter.string(from: date as Date)
//                loaclFormatter.dateFormat = "dd MMM yyyy"//EEE, MMM d, yyyy -
//                let EndDate = loaclFormatter.string(from: date1 as Date)
//                self.LblSeriesTime.text = StartDate+" - "+EndDate
//            }
//        }
        if let start_date = data.st_date{
            if let end_date = data.end_date{
                let date : Date = Date(timeIntervalSince1970: Double(start_date))
                let date1 : Date = Date(timeIntervalSince1970: Double(end_date))
                let loaclFormatter = DateFormatter()
                loaclFormatter.dateFormat = "dd MMM"//EEE, MMM d, yyyy -
                let StartDate = loaclFormatter.string(from: date as Date)
                loaclFormatter.dateFormat = "dd MMM yyyy"//EEE, MMM d, yyyy -
                let EndDate = loaclFormatter.string(from: date1 as Date)
                self.LblSeriesTime.text = StartDate+" - "+EndDate
            }
        }
    }
}

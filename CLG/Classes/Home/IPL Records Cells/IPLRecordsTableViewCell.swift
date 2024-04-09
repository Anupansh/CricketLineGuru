//
//  IPLRecordsTableViewCell.swift
//  CLG
//
//  Created by Prachi Tiwari on 06/07/20.
//  Copyright © 2020 Anuj Naruka. All rights reserved.
//

import UIKit
import SDWebImage
import SwiftyJSON

class IPLRecordsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mostRunsCv: UICollectionView! {
        didSet {
            mostRunsCv.delegate = self
            mostRunsCv.dataSource = self
        }
    }
    @IBOutlet weak var mostRunsPageControl: UIPageControl!
    @IBOutlet weak var mostWicketsCv: UICollectionView! {
           didSet {
               mostWicketsCv.delegate = self
               mostWicketsCv.dataSource = self
           }
       }
    @IBOutlet weak var mostWicketsPageControl: UIPageControl!
    @IBOutlet weak var hundredsCv: UICollectionView! {
           didSet {
               hundredsCv.delegate = self
               hundredsCv.dataSource = self
           }
       }
    @IBOutlet weak var hundredsPageControl: UIPageControl!
    @IBOutlet weak var winnerCv: UICollectionView! {
           didSet {
               winnerCv.delegate = self
               winnerCv.dataSource = self
           }
       }
    @IBOutlet weak var winnerPageControl: UIPageControl!
    @IBOutlet weak var orangeCapCv: UICollectionView! {
           didSet {
               orangeCapCv.delegate = self
               orangeCapCv.dataSource = self
           }
       }
    @IBOutlet weak var orangeCapPageControl: UIPageControl!
    @IBOutlet weak var purpleCapCv: UICollectionView! {
           didSet {
               purpleCapCv.delegate = self
               purpleCapCv.dataSource = self
           }
       }
    @IBOutlet weak var purpleCapPageControl: UIPageControl!
    
    var playerBaseUrl = String()
    var teamBaseUrl = String()
    var firebaseBaseUrl = String()
    var mostRunsModel = [IPLPlayersModel]()
    var mostWicketsModel = [IPLPlayersModel]()
    var extraStatsModel = [IPLExtraStatsModel]()
    var winnerModel = [IPLWinnerModel]()
    var orangeCapModel = [IPLCapHolderModel]()
    var purpleCapModel = [IPLCapHolderModel]()
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension IPLRecordsTableViewCell : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == mostRunsCv {
            mostRunsPageControl.numberOfPages = mostRunsModel.count
            return mostRunsModel.count
        }
        else if collectionView == mostWicketsCv {
            mostWicketsPageControl.numberOfPages = mostWicketsModel.count
            return mostWicketsModel.count
        }
        else if collectionView == hundredsCv {
            hundredsPageControl.numberOfPages = extraStatsModel.count
            return extraStatsModel.count
        }
        else if collectionView == winnerCv {
            winnerPageControl.numberOfPages = winnerModel.count
            return winnerModel.count
        }
        else if collectionView == orangeCapCv {
            orangeCapPageControl.numberOfPages = orangeCapModel.count
            return orangeCapModel.count
        }
        else {
            purpleCapPageControl.numberOfPages = purpleCapModel.count
            return purpleCapModel.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == mostRunsCv {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MostRunsCVCell.className, for: indexPath) as! MostRunsCVCell
            cell.runsLbl.text = mostRunsModel[indexPath.row].total
            cell.playerName.text = mostRunsModel[indexPath.row].name
            cell.playerTeam.text = mostRunsModel[indexPath.row].team
            cell.playerImage.sd_setImage(with: URL(string: self.playerBaseUrl + mostRunsModel[indexPath.row].img!)!, placeholderImage: #imageLiteral(resourceName: "TeamPlaceholderOld"))
            return cell
        }
        else if collectionView == mostWicketsCv {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MostWicketsCVCell.className, for: indexPath) as! MostWicketsCVCell
            cell.wicketsLbl.text = mostWicketsModel[indexPath.row].total
            cell.playerName.text = mostWicketsModel[indexPath.row].name
            cell.playerTeam.text = mostWicketsModel[indexPath.row].team
            cell.playerImage.sd_setImage(with: URL(string: self.playerBaseUrl + mostWicketsModel[indexPath.row].img!)!, placeholderImage: #imageLiteral(resourceName: "TeamPlaceholderOld"))
            return cell
        }
        else if collectionView == hundredsCv {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HundredsCVCell.className, for: indexPath) as! HundredsCVCell
            cell.headingLbl.text = extraStatsModel[indexPath.row].heading
            cell.numberLbl.text = extraStatsModel[indexPath.row].total
            return cell
        }
        else if collectionView == winnerCv {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WinnerCvCell.className, for: indexPath) as! WinnerCvCell
            cell.yearLbl.text = winnerModel[indexPath.row].year
            cell.playerName.text = winnerModel[indexPath.row].team
            cell.playerImage.sd_setImage(with: URL(string: self.teamBaseUrl + winnerModel[indexPath.row].img!)!, placeholderImage: #imageLiteral(resourceName: "TeamPlaceholderOld"))
            return cell
        }
        else if collectionView == orangeCapCv {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OrangeCapCVCell.className, for: indexPath) as! OrangeCapCVCell
            cell.headerLbl.text = "Orange Cap - \(orangeCapModel[indexPath.row].year!)"
            cell.runsLbl.text = "\(orangeCapModel[indexPath.row].total!) runs"
            cell.playerName.text = orangeCapModel[indexPath.row].name
            cell.playerTeam.text = orangeCapModel[indexPath.row].team
            cell.playerImage.sd_setImage(with: URL(string: self.playerBaseUrl + orangeCapModel[indexPath.row].img!)!, placeholderImage: #imageLiteral(resourceName: "TeamPlaceholderOld"))
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PurpleCapCVCell.className, for: indexPath) as! PurpleCapCVCell
            cell.headerLbl.text = "Purple Cap - \(purpleCapModel[indexPath.row].year!)"
            cell.wicketsLbl.text = "\(purpleCapModel[indexPath.row].total!) wickets"
            cell.playerName.text = purpleCapModel[indexPath.row].name
            cell.playerTeam.text = purpleCapModel[indexPath.row].team
            cell.playerImage.sd_setImage(with: URL(string: self.playerBaseUrl + purpleCapModel[indexPath.row].img!)!, placeholderImage: #imageLiteral(resourceName: "TeamPlaceholderOld"))
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == mostRunsCv {
            mostRunsPageControl.currentPage = indexPath.row
        }
        else if collectionView == mostWicketsCv {
            mostWicketsPageControl.currentPage = indexPath.row
        }
        else if collectionView == hundredsCv {
            hundredsPageControl.currentPage = indexPath.row
        }
        else if collectionView == winnerCv {
            winnerPageControl.currentPage = indexPath.row
        }
        else if collectionView == orangeCapCv {
            orangeCapPageControl.currentPage = indexPath.row
        }
        else {
            purpleCapPageControl.currentPage = indexPath.row
        }
    }
}

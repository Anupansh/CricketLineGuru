//
//  LastBallScore.swift
//  CLG
//
//  Created by Anuj Naruka on 6/28/18.
//  Copyright © 2018 Anuj Naruka. All rights reserved.
//

import UIKit

var PreviousBallArr = [String]()

class LastBallScore: UITableViewCell {

    //MARK:-IBOutlets
    
    @IBOutlet weak var previousBallCv: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        self.previousBallCv.dataSource = self
//        self.previousBallCv.delegate = self
//        self.previousBallCv.register(UINib(nibName: "PreviousBallCell", bundle: nil), forCellWithReuseIdentifier: "PreviousBallCell")
//        self.previousBallCv.register(UINib(nibName: "SepratorCell", bundle: nil), forCellWithReuseIdentifier: "SepratorCell")
//    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setTableViewStructure()
        // Configure the view for the selected state
    }
    
    //MARK:-Functions
    func setTableViewStructure()
    {
        self.previousBallCv.dataSource = self
        self.previousBallCv.delegate = self
        self.previousBallCv.register(UINib(nibName: "PreviousBallCell", bundle: nil), forCellWithReuseIdentifier: "PreviousBallCell")
        self.previousBallCv.register(UINib(nibName: "SepratorCell", bundle: nil), forCellWithReuseIdentifier: "SepratorCell")
    }
}

//MARK: CollectionView DataSource
extension LastBallScore: UICollectionViewDataSource {

//    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        if (indexPath.row != PreviousBallArr.count - 1 ) {
//            collectionView.scrollToItem(at: IndexPath(item: ((PreviousBallArr.count)-1), section: 0), at: UICollectionViewScrollPosition.right, animated: false)
//        }
//    }
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
        {
            if PreviousBallArr.count == 1
            {
                if PreviousBallArr[0] == ""
                {
                    return 0
                }
            }
            return PreviousBallArr.count
        }
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PreviousBallCell", for: indexPath) as! PreviousBallCell
            cell.lblPreviousBall.text = PreviousBallArr[indexPath.item]
            cell.lblPreviousBall.backgroundColor = UIColor.clear
            if PreviousBallArr[indexPath.item] == "4"
            {
                cell.PrevBallView.backgroundColor = AppHelper.hexStringToUIColor(hex: "3498db")
                cell.PrevBallView.layer.borderColor = UIColor.clear.cgColor
                cell.PrevBallView.layer.borderWidth = 0.0
                cell.lblPreviousBall.textColor = UIColor.white
                cell.lblPreviousBall.font = UIFont(name: "Lato-Medium", size: 12.0)

            }
            else if PreviousBallArr[indexPath.item] == "6"
            {
                cell.PrevBallView.backgroundColor = AppHelper.hexStringToUIColor(hex: "#6f59c5")
                cell.PrevBallView.layer.borderColor = UIColor.clear.cgColor
                cell.PrevBallView.layer.borderWidth = 0.0
                cell.lblPreviousBall.textColor = UIColor.white
                cell.lblPreviousBall.font = UIFont(name: "Lato-Medium", size: 12.0)
                
            }
            else if PreviousBallArr[indexPath.item] == "W" || (PreviousBallArr[indexPath.item].hasPrefix("W") && !PreviousBallArr[indexPath.item].hasPrefix("Wd"))
            {
                cell.PrevBallView.backgroundColor = UIColor(red: 219/255, green: 86/255, blue: 80/255, alpha: 1.0)
                cell.PrevBallView.layer.borderColor = UIColor.clear.cgColor
                cell.PrevBallView.layer.borderWidth = 0.0
                cell.lblPreviousBall.textColor = UIColor.white
                cell.lblPreviousBall.font = UIFont(name: "Lato-Medium", size: 12.0)
                
            }
            else if PreviousBallArr[indexPath.item] == "Wd+W"
            {
                cell.PrevBallView.backgroundColor = UIColor(red: 219/255, green: 86/255, blue: 80/255, alpha: 1.0)
                cell.PrevBallView.layer.borderColor = UIColor.clear.cgColor
                cell.PrevBallView.layer.borderWidth = 0.0
                cell.lblPreviousBall.textColor = UIColor.white
                cell.lblPreviousBall.font = UIFont(name: "Lato-Medium", size: 11.0)
            }
            else if (PreviousBallArr[indexPath.item].hasPrefix("Wd") && PreviousBallArr[indexPath.item] != "Wd+W") || PreviousBallArr[indexPath.item].hasPrefix("N")
            {
                cell.PrevBallView.backgroundColor = .white
                cell.PrevBallView.layer.borderColor = UIColor(red: 59/255, green: 70/255, blue: 113/255, alpha: 1.0).cgColor
                cell.PrevBallView.layer.borderWidth = 1.0
                cell.lblPreviousBall.textColor = UIColor(red: 59/255, green: 70/255, blue: 113/255, alpha: 1.0)
                cell.lblPreviousBall.font = UIFont(name: "Lato-Medium", size: 12.0)
            }
            else if PreviousBallArr[indexPath.item] == "|"
            {
                let celll = collectionView.dequeueReusableCell(withReuseIdentifier: "SepratorCell", for: indexPath) as! SepratorCell
                return celll
            }
            else
            {
                cell.lblPreviousBall.textColor = .white
                if PreviousBallArr[indexPath.item] == "0"
                {
                    cell.PrevBallView.backgroundColor = AppHelper.hexStringToUIColor(hex: "#7f8c8d")

                }
                else
                {
                    cell.PrevBallView.backgroundColor = AppHelper.hexStringToUIColor(hex: "3A932F")

                }
                cell.PrevBallView.layer.borderWidth = 0.0
                cell.PrevBallView.layer.borderColor = UIColor.clear.cgColor
                cell.lblPreviousBall.font = UIFont(name: "Lato-Medium", size: 12.0)
                
            }
            
            return cell
        }
}
//MARK: CollectionView Flowlayout Delegate
    extension LastBallScore:UICollectionViewDelegateFlowLayout   {
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
        {
            if PreviousBallArr[indexPath.item] == "|"
            {
                return CGSize(width: 20, height: self.previousBallCv.frame.height)
            }
            else if PreviousBallArr[indexPath.item] != ""
            {
                //let str = PreviousBallArr[indexPath.item]
                //let starWidth = str.widthOfString(usingFont: UIFont(name: "Lato-Medium", size: 17)!) + 24
                //return CGSize(width: CGFloat(starWidth), height: self.previousBallCv.frame.height)
                return CGSize(width: self.frame.width/12.1 + 12, height: self.frame.height/2 + 6)
            }
            return CGSize(width: 30, height: self.previousBallCv.frame.height)
        }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 0.0
        }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
        {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }

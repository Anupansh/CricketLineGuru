//
//  DropDownView.swift
//  Legendary gamers
//  Created by Anuj Naruka on 3/8/18.
//

import Foundation
import UIKit

class DropDownView: UIView,UITableViewDelegate,UITableViewDataSource
{
    //MARK:Varible&Constant
    var gameMode = [String]()
    var imgArr = ["polls","accuracy"]
    //Methods
    @IBOutlet weak var tbView: UITableView!
    @IBOutlet weak var tbViewHeightConst: NSLayoutConstraint!
    class func instansiateFromNib() -> DropDownView
    {
        return Bundle.main.loadNibNamed("DropDownMenu", owner: self, options: nil)! [0] as! DropDownView
    }
    func cutomize()
    {
        tbView.delegate = self
        tbView.dataSource = self
        tbView.hideEmptyCells()
        tbView.register(UINib(nibName: "DropDownCell", bundle: nil), forCellReuseIdentifier: "DropDownCell")
        
    }
    func reloadTbView()
    {
        tbView.reloadData()
    }
    func animateView()
    {
        self.tbViewHeightConst.constant = 0
        self.layoutIfNeeded()
        UIView.animate(withDuration: 0.35) {
            self.tbViewHeightConst.constant = self.frame.height
            self.layoutIfNeeded()

        }
    }
    func closeAnimateView()
    {
        UIView.animate(withDuration: 0.35, animations: {
            self.tbViewHeightConst.constant = 0
            self.layoutIfNeeded()

        }) { (true) in
            self.removeFromSuperview()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return gameMode.count
    }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
     {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DropDownCell") as! DropDownCell
        cell.lbl.text = gameMode[indexPath.row]
        cell.imageView?.image = indexPath.row <= 1 ? UIImage(named: imgArr[indexPath.row]) : nil
        cell.selectionStyle = .none
        return cell
        }
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
     {
        return 45
    }
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
     {
        self.removeFromSuperview()
        if indexPath.row == 0
        {
            let storyboard = UIStoryboard(name: "Module2", bundle: nil)
            let topPollersVC = storyboard.instantiateViewController(withIdentifier: "TopPollersVC") as? TopPollersVC
            AppHelper.appDelegate().window?.visibleViewController()?.navigationController?.pushViewController(topPollersVC!, animated: true)
        }
        else if indexPath.row == 1
        {
                let storyboard = UIStoryboard(name: "Module2", bundle: nil)
                let UserPollVC = storyboard.instantiateViewController(withIdentifier: "UserPollVC") as? UserPollVC
            AppHelper.appDelegate().window?.visibleViewController()?.navigationController?.pushViewController(UserPollVC!, animated: true)
        }
    }
}

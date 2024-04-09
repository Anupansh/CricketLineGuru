//
//  HomeTabbarVC.swift
//  cricrate
//
//  Created by Anuj Naruka on 6/18/18.
//  Copyright © 2018 Cricket Line Guru. All rights reserved.
//

import UIKit

class HomeTabbarVC: UITabBarController {
    
    //MARK:-Variables
    
    public var line1View : UIView!
    public var line2View : UIView!
    public var line3View : UIView!
    public var line4View : UIView!
    public var line5View : UIView!
    public var currentSelectedIndex:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 1 {
            line1View.isHidden = true
            line2View.isHidden = true
            line3View.isHidden = true
            line4View.isHidden = true
            line5View.isHidden = true
            currentSelectedIndex = 0
        }else if item.tag == 2 {
            line2View.isHidden = true
            line1View.isHidden = true
            line3View.isHidden = true
            line4View.isHidden = true
            line5View.isHidden = true
            currentSelectedIndex = 1
        }else if item.tag == 3 {
            line3View.isHidden = true
            line1View.isHidden = true
            line2View.isHidden = true
            line4View.isHidden = true
            line5View.isHidden = true
            currentSelectedIndex = 2
        }else if item.tag == 4 {
            line4View.isHidden = true
            line1View.isHidden = true
            line2View.isHidden = true
            line3View.isHidden = true
            line5View.isHidden = true
            currentSelectedIndex = 3
        } else {
            line5View.isHidden = true
            line1View.isHidden = true
            line2View.isHidden = true
            line3View.isHidden = true
            line4View.isHidden = true
            currentSelectedIndex = 4
        }
    }
    func addViews()
    {
        var lineYposition = ScreenSize.SCREEN_HEIGHT - 2
        if ScreenSize.SCREEN_HEIGHT == 812
        {
            lineYposition = ScreenSize.SCREEN_HEIGHT - 30
        }
        line1View = UIView(frame: CGRect(x: 3*(ScreenSize.SCREEN_WIDTH/80), y: lineYposition , width: ScreenSize.SCREEN_WIDTH / 8, height: 2))
        line1View.backgroundColor =  AppColors.tabbarSelectedColor
        line1View.isHidden = true
        self.view.addSubview(line1View)
        
        line2View = UIView(frame: CGRect(x: 19*(ScreenSize.SCREEN_WIDTH/80), y: lineYposition , width: ScreenSize.SCREEN_WIDTH / 8, height: 2))
        line2View.backgroundColor =  AppColors.tabbarSelectedColor
        line2View.isHidden = true
        self.view.addSubview(line2View)
        
        line3View = UIView(frame: CGRect(x: 7*(ScreenSize.SCREEN_WIDTH/16), y: lineYposition , width: ScreenSize.SCREEN_WIDTH / 8, height: 2))
        line3View.backgroundColor =  AppColors.tabbarSelectedColor
        line3View.isHidden = true
        self.view.addSubview(line3View)
        
        line4View = UIView(frame: CGRect(x: 51*(ScreenSize.SCREEN_WIDTH/80), y: lineYposition , width: ScreenSize.SCREEN_WIDTH / 8, height: 2))
        line4View.backgroundColor =  AppColors.tabbarSelectedColor
        line4View.isHidden = true
        self.view.addSubview(line4View)
        
        line5View = UIView(frame: CGRect(x: 67*(ScreenSize.SCREEN_WIDTH/80), y: lineYposition , width: ScreenSize.SCREEN_WIDTH / 8, height: 2))
        line5View.backgroundColor =  AppColors.tabbarSelectedColor
        line5View.isHidden = true
        self.view.addSubview(line5View)
    }
    func hideLine1()
    {
        line1View.isHidden = true
    }
    func showLine1()
    {
        line1View.isHidden = true
        self.view.bringSubview(toFront: line1View)
    }
    //MARK:- Functions
    private func setUp()
    {
        currentSelectedIndex = 0
        self.delegate = self
        self.tabBar.isTranslucent = false
        if #available(iOS 10.0, *) {
            self.tabBar.unselectedItemTintColor = UIColor.white
        } else {
            // Fallback on earlier versions
        }
        self.addViews()
        //self.setUpView()
    }
    func setUpView(){
        self.tabBarController?.selectedIndex = 0
        for tabBarItem in tabBar.items!{
            tabBarItem.imageInsets = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        }
        self.delegate = self
        self.tabBar.barTintColor = .clear//AppColor.basePinkColour
        let bgView: UIImageView = UIImageView(image: UIImage(named: "bottombg"))
        bgView.frame = CGRect.init(x: 0.0, y: 0, width: self.tabBar.frame.width, height: self.tabBar.frame.height)
        bgView.backgroundColor = UIColor.white//you might need to modify this frame to your tabbar frame
        self.tabBar.addSubview(bgView)
        
        
        let homeSelectImage: UIImage! = UIImage(named: "home")?.withRenderingMode(.alwaysOriginal)
        let homeImage: UIImage! = UIImage(named: "home")?.withRenderingMode(.alwaysOriginal)
        
        let liveSelectImage: UIImage! = UIImage(named: "ic_live")?.withRenderingMode(.alwaysOriginal)
        let liveImage: UIImage! = UIImage(named: "ic_live")?.withRenderingMode(.alwaysOriginal)
        
        let matchSelectImage: UIImage! = UIImage(named: "upcoming")?.withRenderingMode(.alwaysOriginal)
        let matchImage: UIImage! = UIImage(named: "upcoming")?.withRenderingMode(.alwaysOriginal)
        
        let pollsSelectImage = UIImage(named: "poles")?.withRenderingMode(.alwaysOriginal)
        let pollsImage = UIImage(named: "poles")?.withRenderingMode(.alwaysOriginal)
        
        let moreSelectImage = UIImage(named: "more")?.withRenderingMode(.alwaysOriginal)
        let moreImage = UIImage(named: "more")?.withRenderingMode(.alwaysOriginal)
        
        (tabBar.items![0]).selectedImage = homeSelectImage
        (tabBar.items![0]).image = homeImage
        (tabBar.items![0]).title = "Home"
        (tabBar.items![1] ).selectedImage = liveSelectImage
        (tabBar.items![1] ).image = liveImage
        (tabBar.items![1]).title = "Live"
        (tabBar.items![2] ).selectedImage = matchSelectImage
        (tabBar.items![2] ).image = matchImage
        (tabBar.items![2]).title = "Matches"
        (tabBar.items![3] ).selectedImage = pollsSelectImage
        (tabBar.items![3] ).image = pollsImage
        (tabBar.items![3]).title = "Polls"
        (tabBar.items![4] ).selectedImage = moreSelectImage
        (tabBar.items![4] ).image = moreImage
        (tabBar.items![4]).title = "More"

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.setUpView()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
//TABBAR DELEGATE
extension HomeTabbarVC:UITabBarControllerDelegate
{
//    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool
//    {
//        if let nc = viewController as? UINavigationController,nc.viewControllers.count != 0
//        {
//            if (nc.viewControllers[0] as? HomeVC) != nil
//            {
//                self.view.bringSubview(toFront: line1View)
//            }
//            else if (nc.viewControllers[0] as? RecentMatchVC) != nil
//            {
//                self.view.bringSubview(toFront: line2View)
//            }
//            else if (nc.viewControllers[0] as? UpcomingMatchesVC) != nil
//            {
//                self.view.bringSubview(toFront: line3View)
//            }
//            else if (nc.viewControllers[0] as? PollScreenVC) != nil
//            {
//                self.view.bringSubview(toFront: line4View)
//            }
//            else if (nc.viewControllers[0] as? MoreVC) != nil
//            {
//                self.view.bringSubview(toFront: line5View)
//            }
//        }
//        return true
//    }
//}
}

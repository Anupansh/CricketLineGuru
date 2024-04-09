//
//  UtilityHelper.swift
//  Plans
//
//  Created by Shalu chaudhary on 4/16/18.
//  Copyright © 2018 Brainmobi. All rights reserved.
//

import Foundation
import UIKit

class UtilityHelper {
    
    // MARK: - Set Up Application UI Appearance
    
    class func setupApplicationUIAppearance() {
        
        //UINavigationBar.appearance().tintColor = AppColor.mainTintColour
        //UINavigationBar.appearance().barTintColor = AppColor.mainTintColour
        
        UINavigationBar.appearance().titleTextAttributes = [
//            NSAttributedStringKey.foregroundColor: AppColor.textColour,
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20.0)]
        
        // UIBarButtonItem.appearance().tintColor = UIColor.black
        UIBarButtonItem.appearance().titleTextAttributes(for: UIControlState())
        UITabBar.appearance().isTranslucent = false
        //UITabBar.appearance().tintColor = AppColor.mainTintColour
        UINavigationBar.appearance().setBackgroundImage(UIImage(named: "bg-1"), for: .default)
        
        // AppDelegate.delegate.window?.backgroundColor = UIColor.white
        
        let tableCellSelectionView = UIView()
        tableCellSelectionView.backgroundColor = UIColor(red: 255.0, green: 255.0, blue: 255.0, alpha: 1.0)
        UITableViewCell.appearance().selectedBackgroundView = tableCellSelectionView
        
        UITableView.appearance().backgroundColor = .white
        // UITableView.appearance().separatorColor = UIColor ( red: 0.8353, green: 0.84, blue: 0.8399, alpha: 1.0 )
        //UITableView.appearance().separatorInset = UIEdgeInsetsMake(0, 15, 0, 15)
        if #available(iOS 9.0, *) {
            UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = UIColor.white
        } else {
            // Fallback on earlier versions
        }
    }
    
    class func getTopMostViewController() -> UIViewController {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            // topController should now be your topmost view controller
            return topController
        }
        return UIViewController()
    }
}


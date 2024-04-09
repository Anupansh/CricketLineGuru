//
//  BaseViewController.swift
//  cricrate
//
//  Created by Anuj Naruka on 6/18/18.
//  Copyright © 2018 Cricket Line Guru. All rights reserved.
//
import Foundation
import UIKit
import FBAudienceNetwork

enum UINavigationBarButtonType: Int {
    case back
    case backWhite
    case post
    case share
    case edit
    case search
    case threeDot
    case filter
    
    var iconImage: UIImage? {
        switch self {
        case .back: return #imageLiteral(resourceName: "backWhite")
        case .backWhite: return #imageLiteral(resourceName: "backWhite")
        case .share: return #imageLiteral(resourceName: "share")
        case .edit: return #imageLiteral(resourceName: "share")
        case .search:return #imageLiteral(resourceName: "search")
        case .threeDot:return #imageLiteral(resourceName: "threeDot")
        case .filter:return #imageLiteral(resourceName: "filter")
        default: return nil
        }
    }
    var title: String? {
        switch self {
        case .post: return "POST"
            
        default: return nil
        }
        
    }
}
class BaseViewController: UIViewController
{
    
    private let navButtonWidth = 50.0
    private let edgeInset = CGFloat(10.0)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideStatusBar(false)
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    override var prefersStatusBarHidden: Bool {
        return false
    }
    func backViewController() -> UIViewController
    {
        let numberOfViewControllers: Int = self.navigationController!.viewControllers.count
        if numberOfViewControllers >= 2 {
            return self.navigationController!.viewControllers[numberOfViewControllers - 2]
        }
        return self.navigationController!.viewControllers[numberOfViewControllers-1]
    }
    
    func setupNavigationBarTitle(_ title: String, navBG: String, leftBarButtonsType: [UINavigationBarButtonType], rightBarButtonsType: [UINavigationBarButtonType], titleViewFrame: CGRect = CGRect(x: 0, y: 0, width: 180, height: 44)) {
        if !title.isEmpty {
            self.navigationItem.titleView = createLabel(text: title)
        }
        else
        {
//            self.navigationItem.titleView = UIImageView.init(image: #imageLiteral(resourceName: "titleImg"))
        }
        var rightBarButtonItems = [UIBarButtonItem]()
        for rightButtonType in rightBarButtonsType {
            let rightButtonItem = getBarButtonItem(for: rightButtonType, isLeftBarButtonItem: false)
            rightBarButtonItems.append(rightButtonItem)
        }
        if rightBarButtonItems.count > 0 {
            self.navigationItem.rightBarButtonItems = rightBarButtonItems
        }
        else
        {
             self.navigationItem.rightBarButtonItems = nil
        }
        var leftBarButtonItems = [UIBarButtonItem]()
        for leftButtonType in leftBarButtonsType {
            let leftButtonItem = getBarButtonItem(for: leftButtonType, isLeftBarButtonItem: true)
            leftBarButtonItems.append(leftButtonItem)
        }
        if leftBarButtonItems.count > 0 {
            self.navigationItem.leftBarButtonItems = leftBarButtonItems
        }
        if navBG != ""
        {
            if ScreenSize.SCREEN_HEIGHT == 812 && navBG == "navBarBG1"
            {
                self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "navBarBG3"), for: UIBarMetrics.default)
            }
            else
            {
                self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: navBG), for: UIBarMetrics.default)
            }
        }
        else
        {
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.isTranslucent = true
        }
    }
    
    func getBarButtonItem(for type: UINavigationBarButtonType, isLeftBarButtonItem: Bool) -> UIBarButtonItem {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: Int(navButtonWidth), height: 64))
        button.setTitleColor(.black, for: UIControlState())
        button.titleLabel?.font = UIFont.init(name: "SF-Pro-Text", size: 17)
        button.titleLabel?.textAlignment = .right
        button.titleLabel?.textColor = UIColor.white
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.tag = type.rawValue
        button.imageEdgeInsets = UIEdgeInsetsMake(0, isLeftBarButtonItem ? -edgeInset : edgeInset, 0, isLeftBarButtonItem ? edgeInset : -edgeInset)
        if let iconImage = type.iconImage {
            button.setImage(iconImage, for: UIControlState())
        }
        else if let title = type.title {
            button.setTitle(title, for: UIControlState())
            button.frame.size.width = 50.0
        }
        button.addTarget(self, action: #selector(BaseViewController.navigationButtonTapped(_:)), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }
    
    func createLabel(text: String) -> UILabel {
        
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: 200, height: 44))
        let frame = rect
        let lbl = UILabel.init(frame: frame)
        lbl.text = text
        lbl.numberOfLines = 0
        lbl.textAlignment = NSTextAlignment.center
        lbl.font = UIFont.init(name: "Lato-Bold", size: 17)
        lbl.textColor = UIColor.white
        
        return lbl
    }
    
    @objc func navigationButtonTapped(_ sender: AnyObject) {
        guard let buttonType = UINavigationBarButtonType(rawValue: sender.tag) else { return }
        switch buttonType {
        case .back: backButtonTapped()
        case .backWhite: backButtonTapped()
        case .share: shareTapped()
        case .edit: editTapped()
        case .post: postTapped()
        case .search:searchTapped()
        case .threeDot:threeDotTaped()
        case .filter:filterTaped()
        default: break
        }
        //self.baseDelegate?.navigationBarButtonDidTapped(buttonType)
    }
    
    func backButtonTapped() {
        if self.navigationController!.viewControllers.count > 1 {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func threeDotTaped(){
        
    }
    
    func searchTapped(){
        
    }
    
    func shareTapped() {
        AppHelper.share()
    }
    
    func postTapped() {
        
    }
    
    func editTapped() {
        
    }
    
    func filterTaped() {
        
    }
    @available(iOS, deprecated: 9.0)
    func hideStatusBar(_ hide: Bool)
    {
        UIApplication.shared.setStatusBarHidden(hide, with: .none)
    }
    
    func registerNib(tv:UITableView,cellName:String)
    {
        tv.register(UINib(nibName: cellName, bundle: nil), forCellReuseIdentifier: cellName)
    }
    
    func registerHeaderFooterNib(tv:UITableView,cellName:String)
    {
        tv.register(UINib(nibName: cellName, bundle: nil), forHeaderFooterViewReuseIdentifier: cellName)
    }
    
    func registerNibCV(cv:UICollectionView,cellName:String)
    {
        cv.register(UINib(nibName: cellName, bundle: nil), forCellWithReuseIdentifier: cellName)
    }
    
    func hideNavigationBar(_ hide: Bool)
    {
        self.navigationController?.isNavigationBarHidden = hide
    }
}

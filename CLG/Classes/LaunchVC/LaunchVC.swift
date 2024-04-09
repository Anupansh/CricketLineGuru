//
//  LaunchVC.swift
//  cricrate

import UIKit


class LaunchVC: UIViewController {

    override func viewDidLoad()
    {
        super.viewDidLoad()
        setUp()
        // Do any additional setup after loading the view.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK:-Functions
    
    private func setUp()
    {
        let transition = CATransition()
        transition.duration = 3.0
        transition.type = kCATransitionFade
        transition.subtype = kCATransitionFromRight
        view.layer.add(transition, forKey: kCATransition)
        self.navigateToHome()
    }
    
    private func navigateToHome()
    {
        let storyBoard = UIStoryboard(name: "Tabbar", bundle: nil)
        let mainViewController   = storyBoard.instantiateViewController(withIdentifier: "HomeTabbarVC")
        AppHelper.appDelegate().window?.rootViewController = mainViewController
    }

}

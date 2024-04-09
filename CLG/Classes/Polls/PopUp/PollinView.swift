//
//  PollinView.swift
//  CLG
//
//  Created by Brainmobi on 01/08/18.
//  Copyright © 2018 Anuj Naruka. All rights reserved.
//

import UIKit

protocol PollingDelegate{
    func dismissView(socialId:String,name:String,type:String,email:String)
    func googleSignIn()
}

class PollinView: UIView {

    //MARK:- Properties
    
    var delegate: PollingDelegate?
    //MARK:- IBOutlets
    
    @IBOutlet weak var blur: UIVisualEffectView!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var crossBtn: UIButton!

    //MARK:- User Action
    
    @IBAction func crossBtnAction(_ sender: Any) {
        self.hidePopUp()
    }
    
    @IBAction func fbBtnAction(_ sender: Any) {
//        fbLogin()
    }
    
    @IBAction func googleBtnAction(_ sender: Any) {
        self.delegate?.googleSignIn()
    }
    
//MARK: Show View Method
    
    func showPopup(hideCrossBtn:Bool){
        crossBtn.isHidden = hideCrossBtn
        blur.isHidden = !hideCrossBtn
        self.center = CGPoint(x: self.superview!.frame.width/2, y: 2 * self.superview!.frame.height)
        self.alpha = 0.0
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.7, options: UIViewAnimationOptions.curveEaseInOut, animations: { () -> Void in
            self.center = self.superview!.center
            self.alpha = 1.0
        })
        { (suceess) -> Void in
        }
    }
    
    //MARK: Hide View Method
    
    func hidePopUp(){
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.7, options: UIViewAnimationOptions.curveEaseInOut, animations: { () -> Void in
            self.center = CGPoint(x: self.superview!.frame.width/2, y: 2 * self.superview!.frame.height)
            self.alpha = 0.0
        })
        { (suceess) -> Void in
            self.removeFromSuperview()
        }
    }
    
    //MARK:- Fb Login
    
//    private func fbLogin() {
//        FacebookManager.shared.loginWithFacebook(readPermissions: [Permission.email.stringValue], target: UtilityHelper.getTopMostViewController())
//        FacebookManager.shared.fbInfoProvider = {
//            (success, fbUser) in
//            if let fbId = fbUser.fbId{
//                if let name = fbUser.name{
//                    self.delegate?.dismissView(socialId: fbId, name: name, type: "1", email:fbUser.email ?? "")
//                }
//            }
//        }
//    }
}

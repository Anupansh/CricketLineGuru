//
//  PhoneNumberView.swift
//  CLG
//
//  Created by Anuj Naruka on 9/7/18.
//  Copyright © 2018 Anuj Naruka. All rights reserved.
//

import UIKit

protocol PhoneDelegate{
    func getUserData()
}
class PhoneNumberView: UIView
{

    
        //MARK:- Properties
    var delegate: PhoneDelegate?
    var rankId = String()
    var priceAmount = Int()
        //MARK:- IBOutlets
        
        @IBOutlet weak var innerView: UIView!
        @IBOutlet weak var crossBtn: UIButton!
        @IBOutlet weak var phoneFld: UITextField!
        @IBOutlet weak var titleLbl: UILabel!
        @IBOutlet weak var phoneCnfFld: UITextField!
        @IBOutlet weak var alignConstraint: NSLayoutConstraint!

        
        //MARK:- User Action
        
        @IBAction func crossBtnAction(_ sender: Any) {
            self.hidePopUp()
        }
        
        @IBAction func submitBtnAction(_ sender: Any) {
            phoneFld.resignFirstResponder()
            phoneCnfFld.resignFirstResponder()
            if (phoneCnfFld.text?.isBlank)! || (phoneFld.text?.isBlank)! || (phoneCnfFld.text?.count)! < 10 || (phoneFld.text?.count)! < 10{
                Drop.down("Please enter your complete phone number.")
            }
            else if phoneCnfFld.text != phoneFld.text{
                Drop.down("Your confirm phone number does not match.")
            }
            else{
               hitApi()
            }
        }
    //MARK:- Override Functions
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        phoneFld.resignFirstResponder()
        phoneCnfFld.resignFirstResponder()
    }
    //MARK:-Keyboard notification
    @objc func keyboardWillShow(notification: NSNotification)
    {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        {
            let duration : TimeInterval = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval)!
            UIView.animate(withDuration: 2*duration, delay: 0, options: .beginFromCurrentState , animations: {
                self.alignConstraint.constant = -70
            }, completion: { (data) in
            })
            
            //do the chnages according ot this height
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardHeight = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.height{
            let duration : TimeInterval = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval)!
            UIView.animate(withDuration: 2*duration, delay: 0, options: .beginFromCurrentState , animations: {
                self.layoutIfNeeded()
                self.alignConstraint.constant = 0
            }, completion: nil)
        }
    }
    func  hitApi()
    {
        if let accessToken = UserDefaults.standard.value(forKey: "accessToken") as? String{
            var tempHeader = header
            tempHeader["accessToken"] = UserDefaults.standard.value(forKey: "accessToken") as? String ?? ""
            AlamofireServiceClass().serviceJsonEncoding(url: NewDevBaseUrl+CLGRecentClass.PhoneAdd, showLoader: 2, method: .post, header: tempHeader, parameters: ["userPhone" : phoneCnfFld.text!,"rankId":rankId], success: { (data) in
                if (data as! [String:Any])["statusCode"] as? Int == 1
                {
                   self.hidePopUp()
                    self.delegate?.getUserData()
                    Drop.down("Mobile number registered successfully.\n Your prize money will be credited to your paytm in 2 days.")
                }
            }) { (error) in
                print(error)
            }
        }
    }
        //MARK: Show View Method
        
        func showPopup(hideCrossBtn:Bool){
            crossBtn.isHidden = hideCrossBtn
            phoneFld.delegate = self
            phoneCnfFld.delegate = self
            self.titleLbl.text = "You have won Rs. \(priceAmount). Please enter your paytm mobile number below to redeem it."
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
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
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.7, options: UIViewAnimationOptions.curveEaseInOut, animations: { () -> Void in
                self.center = CGPoint(x: self.superview!.frame.width/2, y: 2 * self.superview!.frame.height)
                self.alpha = 0.0
            })
            { (suceess) -> Void in
                self.removeFromSuperview()
            }
    }

}
//MARK:- Text Field delegate

extension PhoneNumberView:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        let cs = NSCharacterSet(charactersIn: "0123456789").inverted
        let filtered = string.components(separatedBy: cs).joined(separator: "")
        let currentCharacterCount = textField.text?.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.count - range.length
        return newLength <= 10 && (string == filtered)
    }
}

//
//  UsernameChange.swift
//  CLG
//
//  Created by Anuj Naruka on 9/8/18.
//  Copyright © 2018 Anuj Naruka. All rights reserved.
//

import UIKit

protocol RefreshSettings {
    func refresh()
}

class UsernameChange: UIView {

        
        //MARK:- Properties
    var delegate:RefreshSettings?
        //MARK:- IBOutlets
        
        @IBOutlet weak var nameFld: UITextField!
        @IBOutlet weak var btnSubmit: UIButton!
        @IBOutlet weak var btnCross: UIButton!
        @IBOutlet weak var centerAlignConstant: NSLayoutConstraint!
        
        //MARK:- Override Functions
        
        override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            nameFld.resignFirstResponder()
        }
        
        //MARK:- User Action
        
        @IBAction func crossBtnAction(_ sender: Any){
            nameFld.resignFirstResponder()
            self.hidePopUp()
        }
        
        @IBAction func submitBtnAction(_ sender: Any) {
            nameFld.resignFirstResponder()
            var letterCount = 0
            
            for char in (nameFld.text?.trimmingCharacters(in: .whitespacesAndNewlines)) ?? ""
            {
                if Int(String(char)) != nil
                {
                    letterCount+=1
                }
            }
            if nameFld.text == ""{
                Drop.down("Please enter your user name")
            }else if (nameFld.text?.count)! > 30 || (nameFld.text?.count)! < 4 {
                Drop.down("User name can be of maximum 15 and minimum 4 characters")
            }
            else if letterCount > 5
            {
                Drop.down("Cannot enter numbers")
            }
            else if AppHelper.containsSwearWord(text: (nameFld.text?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased())!, swearWords: listOfWords)
            {
                Drop.down("Please refrain form using abusive content.")
                return
            }
            else{
               
                    sociallyUser()
            }
        }
        
        //MARK:- Set Gradient to Submit Button
        
        func customUI(){
//            btnSubmit.applyGradient(colours: [UIColor.init(red: 59.0/255.0, green: 70.0/255.0, blue: 113.0/255.0, alpha: 1.0),UIColor.init(red: 78.0/255.0, green: 29.0/255.0, blue: 98.0/255.0, alpha: 1.0)])
            nameFld.text = AppHelper.userDefaultsForKey(key: "userName") as? String ?? ""
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        }
        @objc func keyboardWillShow(notification: NSNotification)
        {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            {
                let duration : TimeInterval = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval)!
                let keyboardHeight = keyboardSize.size.height
                print("keyboard height: \(keyboardHeight)")
                UIView.animate(withDuration: 4*duration, delay: 0, options: .beginFromCurrentState , animations: {
                    self.centerAlignConstant.constant = -100
                }, completion: { (data) in
                })
            }
        }
        
        @objc func keyboardWillHide(notification: NSNotification) {
            if let keyboardHeight = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.height{
                
                let duration : TimeInterval = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval)!
                
                UIView.animate(withDuration: 2*duration, delay: 0, options: .beginFromCurrentState , animations: {
                    self.layoutIfNeeded()
                    self.centerAlignConstant.constant = 0
                }, completion: nil)
                
            }
        }
        //MARK: Show View Method
        
        func showPopup(){
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
            delegate?.refresh()
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
        
        
        //MARK:- Login as Socially
        
        private func sociallyUser(){
            var paramDict = [String:Any]()
            var tempHeader = header
            tempHeader["accessToken"] = UserDefaults.standard.value(forKey: "accessToken") as? String ?? ""
            paramDict["username"] = self.nameFld.text
            CLGUserService().newsService(url: NewDevBaseUrl+CLGRecentClass.Editprofile, method: .post, showLoader: 2, header: tempHeader, parameters: paramDict).then(execute: { (data) -> Void in
                if data.statusCode == 1{
//                    if let responseData = data.responseData, let accessToken = responseData.accessToken{
                        UserDefaults.standard.set(self.nameFld.text, forKey: "userName")
                        Drop.down("Username changed successfully")
//                    }
                }
                self.hidePopUp()
            }).catch { (error) in
                print(error)
            }
        }
    }

//MARK:- Text Field delegate

extension UsernameChange:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        let cs = NSCharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz 0123456789").inverted
        let filtered = string.components(separatedBy: cs).joined(separator: "")
        let currentCharacterCount = textField.text?.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.count - range.length
        return newLength <= 35 && (string == filtered)
    }
}

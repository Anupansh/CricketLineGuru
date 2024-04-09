//
//  Extensions.swift
//  GameMaster
//
//  Created by Akshay Rai on 04/02/16.
//  Copyright © 2016 AppInfy. All rights reserved.
//
//

import Foundation
import UIKit
import SystemConfiguration



//MARK: Stiring Extension
extension String{
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
    var length: Int{
        return self.count
    }
    var localizedString: String{
        return NSLocalizedString(self, comment: "")
    }
    
    func stringByRemovingLeadingTrailingWhitespaces() -> String {
        let spaceSet = NSCharacterSet.whitespaces
        return self.trimmingCharacters(in: spaceSet)
    }
    
    var stringByRemovingWhitespaces: String {
        return components(separatedBy: .whitespaces).joined()
    }
    
    //To check text field or String is blank or not
    var isBlank: Bool {
        get {
            let trimmed = trimmingCharacters(in: NSCharacterSet.whitespaces)
            return trimmed.isEmpty
        }
    }
    
    //Validate Email
    var isEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil
        } catch {
            return false
        }
    }
    
    //validate PhoneNumber
    var isPhoneNumber: Bool {
        
        let charcter  = NSCharacterSet(charactersIn: "+0123456789").inverted
        var filtered:String!
        let inputString:[String] = self.components(separatedBy: charcter)
        filtered = inputString.joined(separator: "") as String?
        return  self == filtered
        
    }
    
    var utf8Data: NSData? {
        return data(using: String.Encoding.utf8) as NSData?
    }
}

extension String {
    
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}

//MARK: UserDefault Extension
extension UserDefaults {
    
    class func save(value:AnyObject,forKey key:String)
    {
        UserDefaults.standard.set(value, forKey:key)
        UserDefaults.standard.synchronize()
    }
    
    class func getStringDataFromUserDefault(key:String) -> String?
    {
        if let value = UserDefaults.standard.object(forKey: key) as? String {
            return value
        }
        return nil
    }
    class func getAnyDataFromUserDefault(key:String) -> AnyObject?
    {
        if let value: AnyObject = UserDefaults.standard.object(forKey: key) as AnyObject? {
            
            return value
        }
        return nil
    }
    class func removeFromUserDefaultForKey(key:String)
    {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    class func clean()
    {
        let appDomain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: appDomain)
        UserDefaults.standard.synchronize()
    }
}



extension UIAlertController{
    class func showMessage(parent: UIViewController, messageText: String, messageTitle: String, buttonText: String) {
        let alert = UIAlertController(title: messageTitle, message: messageText, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: buttonText, style: UIAlertActionStyle.default, handler: nil))
        parent.present(alert, animated: true, completion: nil)
    }
}

class CircularImageV: UIImageView {
    override func layoutSubviews() {
        super.layoutSubviews()
        let radius: CGFloat = self.bounds.size.width / 2.0
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
}
extension UIImage {
    func image(alpha: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: alpha)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
extension UIButton{
    
    func makeBlurImage(targetButton:UIButton?)
    {
        let blur = UIVisualEffectView(effect: UIBlurEffect(style:
            UIBlurEffectStyle.light))
        blur.frame = targetButton!.bounds
        blur.isUserInteractionEnabled = false //This allows touches to forward to the 
        blur.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        targetButton!.insertSubview(blur, at: 0)
    }
    
    func roundButtonCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

extension UIView {
        @IBInspectable var cornerRadius: CGFloat {
            get {
                return layer.cornerRadius
            }
            set {
                layer.cornerRadius = newValue
                layer.masksToBounds = newValue > 0
            }
        }
        
        
        @IBInspectable var borderColor: UIColor? {
            get {
                return UIColor(cgColor: self.layer.borderColor!)
            }
            set {
                self.layer.borderColor = newValue?.cgColor
            }
        }
        
        @IBInspectable var rightBorder: CGFloat {
            get {
                return 0.0
            }
            set {
                let line = UIView(frame: CGRect(x: self.bounds.width, y: 0.0, width: newValue, height: self.bounds.height))
                line.translatesAutoresizingMaskIntoConstraints = false
                line.backgroundColor = self.borderColor
                self.addSubview(line)
                
                let views = ["line": line]
                let metrics = ["lineWidth": newValue]
                self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "[line(==lineWidth)]|", options: [], metrics: metrics, views: views))
                self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[line]|", options: [], metrics: nil, views: views))
            }
        }
        @IBInspectable var BorderWidth: CGFloat {
            get {
                return layer.borderWidth
            }
            set {
                layer.borderWidth = newValue
            }
        }
        @IBInspectable var topBorder: CGFloat {
            get {
                return 0.0
            }
            set {
                let line = UIView(frame: CGRect(x: 0.0, y: 0.0, width: self.bounds.width, height: newValue))
                line.translatesAutoresizingMaskIntoConstraints = false
                line.backgroundColor = self.borderColor
                self.addSubview(line)
                
                let views = ["line": line]
                let metrics = ["lineWidth": newValue]
                self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[line]|", options: [], metrics: nil, views: views))
                self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[line(==lineWidth)]", options: [], metrics: metrics, views: views))
            }
        }
        @IBInspectable var leftBorder: CGFloat {
            get {
                return 0.0
            }
            set {
                let line = UIView(frame: CGRect(x: 0.0, y: 0.0, width: newValue, height: self.bounds.height))
                line.translatesAutoresizingMaskIntoConstraints = false
                line.backgroundColor = self.borderColor
                self.addSubview(line)
                
                let views = ["line": line]
                let metrics = ["lineWidth": newValue]
                self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[line(==lineWidth)]", options: [], metrics: metrics, views: views))
                self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[line]|", options: [], metrics: nil, views: views))
            }
        }
        @IBInspectable var bottomBorder: CGFloat {
            get {
                return 0.0
            }
            set {
                
                var line: UIView!
                if let lin = self.viewWithTag(10){
                    line = lin;
                }
                else
                {
                    line = UIView(frame: CGRect(x: 0.0, y: self.bounds.height, width: self.bounds.width, height: newValue))
                    line.translatesAutoresizingMaskIntoConstraints = false
                    line.tag = 10;
                    self.addSubview(line)
                }
                line.backgroundColor = self.borderColor
                
                //            let line = UIView(frame: CGRect(x: 0.0, y: self.bounds.height, width: self.bounds.width, height: newValue))
                //            line.translatesAutoresizingMaskIntoConstraints = false
                //            line.backgroundColor = self.borderColor
                //            line.tag = 10;
                //            self.t
                //            self.addSubview(line)
                
                let views = ["line": line]
                let metrics = ["lineWidth": newValue]
                self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[line]|", options: [], metrics: nil, views: views))
                self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[line(==lineWidth)]|", options: [], metrics: metrics, views: views))
            }
        }
        @IBInspectable var shadowColor: UIColor {
            get {
                return UIColor(cgColor: self.layer.shadowColor!)
            }
            set {
                layer.shadowColor = newValue.cgColor
            }
        }
        @IBInspectable var shadowOpacity: Float {
            get {
                return layer.shadowOpacity
            }
            set {
                layer.shadowOpacity = newValue
            }
            
        }
        
        @IBInspectable var masksToBounds: Bool  {
            get {
                return layer.masksToBounds
            }
            set {
                layer.masksToBounds = newValue
            }
            
            
        }
        
        @IBInspectable var shadowOffset: CGSize  {
            get {
                return layer.shadowOffset
            }
            set {
                layer.shadowOffset = newValue
            }
            
        }
        @IBInspectable var shadowRadius: CGFloat  {
            get {
                return layer.shadowRadius
            }
            set {
                layer.shadowRadius = newValue
            }
            
        }
        //shadowRadius
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    func addDashedBorder(color:CGColor) {
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 1
        shapeLayer.lineJoin = kCALineJoinRound
        shapeLayer.lineDashPattern = [10,3]
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 5).cgPath
        
        self.layer.addSublayer(shapeLayer)
        
    }
    
    func makeBlurView(targetView:UIView?)
    {
        let blur = UIVisualEffectView(effect: UIBlurEffect(style:
            UIBlurEffectStyle.light))
        blur.frame = targetView!.bounds
        blur.isUserInteractionEnabled = false //This allows touches to forward to the
        blur.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        targetView!.insertSubview(blur, at: 0)
    }
    
    func makeBlurView1(targetView:UIView?)
    {
        let blur = UIVisualEffectView(effect: UIBlurEffect(style:
            UIBlurEffectStyle.dark))
        blur.frame = targetView!.bounds
        blur.isUserInteractionEnabled = false //This allows touches to forward to the
        blur.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        targetView!.insertSubview(blur, at: 0)
    }
    
    func addBlurArea(area: CGRect, targetView:UIView?) {
        let effect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurView = UIVisualEffectView(effect: effect)
        blurView.frame = CGRect(x: 0, y: 0, width: area.width, height: area.height)
        blurView.isUserInteractionEnabled = false //This allows touches to forward to the
        let container = UIView(frame: area)
        container.alpha = 0.7
        container.addSubview(blurView)
        
        targetView!.insertSubview(container, at: 0)
    }
    
    func getCurrentViewController() -> UIViewController? {
        
        if let rootController = UIApplication.shared.keyWindow?.rootViewController {
            var currentController: UIViewController! = rootController
            while( currentController.presentedViewController != nil ) {
                currentController = currentController.presentedViewController
            }
            return currentController
        }
        return nil
    }
}
extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}
extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random(),
                       green: .random(),
                       blue: .random(),
                       alpha: 1.0)
    }
}
extension UITextField{
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedStringKey.foregroundColor: newValue!])
        }
    }
}

extension NSData {
    var attributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self as Data, options:[NSAttributedString.DocumentReadingOptionKey.documentType:NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8], documentAttributes: nil)
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
}
extension Array where Element: Hashable {
    var setValue: Set<Element> {
        return Set<Element>(self)
    }
}
extension Date {
    func toMillis() -> Int64!
    {
        return Int64(self.timeIntervalSince1970*1000)
    }
    func isGreaterThanDate(dateToCompare: Date) -> Bool {
        //Declare Variables
        var isGreater = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedDescending {
            isGreater = true
        }
        
        //Return Result
        return isGreater
    }
    
    func isLessThanDate(dateToCompare: Date) -> Bool {
        //Declare Variables
        var isLess = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedAscending {
            isLess = true
        }
        
        //Return Result
        return isLess
    }
    
    func equalToDate(dateToCompare: Date) -> Bool {
        //Declare Variables
        var isEqualTo = false
        
        //Compare Values
        if self.compare(dateToCompare) == ComparisonResult.orderedSame {
            isEqualTo = true
        }
        
        //Return Result
        return isEqualTo
    }
    
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfYear], from: date, to: self).weekOfYear ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date)) years ago"   }
        if months(from: date)  > 0 { return "\(months(from: date)) months ago"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date)) weeks ago"   }
        if days(from: date)    > 0 { return "\(days(from: date)) days ago"    }
        if hours(from: date)   > 0 { return "\(hours(from: date)) hours ago"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date)) minutes ago" }
        if seconds(from: date) > 0 { return "\(seconds(from: date)) seconds ago" }
        return ""
    }
    func Countdown(from date: Date) -> Int {
        if seconds(from: date) > 0 { return seconds(from: date) }
        return 0
    }
    
}
extension UIPanGestureRecognizer {
    
    func isLeft(view: UIView) -> Bool {
        let velocity : CGPoint = self.velocity(in: view)
        if velocity.x > 0 {
            print("Gesture went right")
            return false
        } else {
            print("Gesture went left")
            return true
        }
    }
}

//MARK:- Check Network Availibility
public class Reachability {
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        /* Only Working for WIFI
         let isReachable = flags == .reachable
         let needsConnection = flags == .connectionRequired
         
         return isReachable && !needsConnection
         */
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
        
    }
}

extension NSObject:Utilities{
    
    
    enum ReachabilityStatus {
        case notReachable
        case reachableViaWWAN
        case reachableViaWiFi
    }
    
    var currentReachabilityStatus: ReachabilityStatus {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return .notReachable
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return .notReachable
        }
        
        if flags.contains(.reachable) == false {
            // The target host is not reachable.
            return .notReachable
        }
        else if flags.contains(.isWWAN) == true {
            // WWAN connections are OK if the calling application is using the CFNetwork APIs.
            return .reachableViaWWAN
        }
        else if flags.contains(.connectionRequired) == false {
            // If the target host is reachable and no connection is required then we'll assume that you're on Wi-Fi...
            return .reachableViaWiFi
        }
        else if (flags.contains(.connectionOnDemand) == true || flags.contains(.connectionOnTraffic) == true) && flags.contains(.interventionRequired) == false {
            // The connection is on-demand (or on-traffic) if the calling application is using the CFSocketStream or higher APIs and no [user] intervention is needed
            return .reachableViaWiFi
        }
        else {
            return .notReachable
        }
    }
    class var className: String {
        return String(describing: self)
    }
    var classNameString: String {
        return String(describing: self)
    }
}
// MARK: - Extentions

extension String {
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedStringKey.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    func heightOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedStringKey.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.height
    }
    var html2AttributedString: NSAttributedString? {
        do {
            guard let data = data(using: String.Encoding.utf8) else {
                return NSAttributedString(string: "")
            }
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)

        } catch {
            print(error)
            return NSAttributedString(string: "")
        }
    }
    
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}
extension NSAttributedString{
    func attributedStringWithSameFont(_ size:CGFloat) -> NSMutableAttributedString{
        let res: NSMutableAttributedString? = NSMutableAttributedString(attributedString: self)
        res?.beginEditing()
        var found: Bool = false
        res?.enumerateAttribute(NSAttributedStringKey.font, in: NSRange(location: 0, length: (res?.length)!), options: [], using: {(value, range, stop) -> Void in
            if (value != nil) {
                
                if (value as? UIFont) != nil{
                    let newFont: UIFont? = UIFont(name: "RobotoCondensed-Regular", size: size)
                    res?.removeAttribute(NSAttributedStringKey.font, range: range)
                    res?.addAttribute(NSAttributedStringKey.font, value: newFont ?? UIFont.systemFont(ofSize: size), range: range)
                    found = true
                }
                if let color = value as? UIColor{
                    res?.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: range)
                    found = true
                }
            }
        })
        if !found {
            // No font was found - do something else?
        }
        res?.endEditing()
        return res!
    }
}

extension UISearchBar {
    
    var textColor:UIColor? {
        get {
            if let textField = self.value(forKey: "searchField") as?
                UITextField  {
                return textField.textColor
            } else {
                return nil
            }
        }
        
        set (newValue) {
            if let textField = self.value(forKey: "searchField") as?
                UITextField  {
                textField.textColor = newValue
            }
        }
    }
}

extension UIView {
    func applyGradient(colours: [UIColor]) -> Void {
        self.applyGradient(colours: colours, locations: nil)
    }
    
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        self.layer.insertSublayer(gradient, at: 0)
    }
}
extension UIWindow {
    
    func visibleViewController() -> UIViewController? {
        if let rootViewController: UIViewController = self.rootViewController {
            return UIWindow.getVisibleViewControllerFrom(vc: rootViewController)
        }
        return nil
    }
    
    class func getVisibleViewControllerFrom(vc:UIViewController) -> UIViewController {
        
        if  vc.isKind(of: UINavigationController.self) {
            let navigationController = vc as! UINavigationController
            return UIWindow.getVisibleViewControllerFrom( vc: navigationController.visibleViewController!)
        } else if vc.isKind(of: UITabBarController.self) {
            let tabBarController = vc as! UITabBarController
            return UIWindow.getVisibleViewControllerFrom(vc: tabBarController.selectedViewController!)
        } else {
            if let presentedViewController = vc.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(vc: presentedViewController)
            } else {
                return vc
            }
        }
    }
}

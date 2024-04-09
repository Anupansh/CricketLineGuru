//
//  CommonFunctions.swift
//  GameMaster
//
//  Created by Akshay Rai on 04/02/16.
//  Copyright © 2016 AppInfy. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
//import DGActivityIndicatorView

enum UIUserInterfaceIdiom : Int
{
    case Unspecified
    case Phone
    case Pad
}
enum ThumbnailQuailty : String {
    case Zero = "0.jpg"
    case One = "1.jpg"
    case Two = "2.jpg"
    case Three = "3.jpg"
    
    case Default = "default.jpg"
    case Medium = "mqdefault.jpg"
    case High = "hqdefault.jpg"
    case Standard = "sddefault.jpg"
    case Max = "maxresdefault.jpg"
    
    /// All values sorted by image size (1,2,3 are the same size)
    static let allValues = [Default, One, Two, Three,  Medium, High, Zero, Standard, High]
}

struct ScreenSize
{
    static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
    static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}


class CommonFunctions
{
    

    class func getTimeTextForDateStringModified(date : Date) -> String
    {
//        print(Date())
        
        let formatter1 = DateFormatter.init()
//        formatter1.dateFormat = "yyyy-MM-dd HH:mm:ss"
//        formatter1.timeZone = NSTimeZone.init(name: "UTC") as TimeZone!
//        let date1 = formatter1.date(from: string)
        
        if (date != nil)
        {
            if Calendar.current.isDateInToday(date)
            {
                formatter1.dateFormat = "h:mm a"
                return(formatter1.string(from:date))
            }
            else if Calendar.current.isDateInYesterday(date)
            {
                return("Yesterday")
            }
            else
            {
                formatter1.dateFormat = "MM.dd.yy"
                return(formatter1.string(from:date))
            }
        }
        return ""
    }
    class func getTimeTextForDateString(string : String) -> String
    {
        print(Date())
        let formatter1 = DateFormatter.init()
        formatter1.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter1.timeZone = NSTimeZone.init(name: "UTC") as TimeZone?
        let date1 = formatter1.date(from: string)
        if (date1 != nil)
        {
            let elapsed = floor((date1?.timeIntervalSince(Date()))!)
            if elapsed <= 60
            {
                print("Just Now")
                return ("Just Now")
            }
            if elapsed > 60 && elapsed < 3600
            {
                print(String(Int( elapsed/60)) + " mins")
                return (String(Int( elapsed/60)) + " mins")
            }
            if elapsed < 86400 && elapsed >= 3600
            {
                print(String(Int( elapsed/3600)) + " hrs")
                return (String(Int( elapsed/3600)) + " hrs")
            }
        }
        return ""
    }
    
    class func offsetFrom(_ date:Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone.current
        let date2 : Date = Date()
        let strTodadate = formatter.string(from: date2)
        let datetoday = formatter.date(from: strTodadate)!
        
        
        let dayHourMinuteSecond: NSCalendar.Unit = [.day, .hour, .minute, .second]
        let difference = (Calendar.current as NSCalendar).components(dayHourMinuteSecond, from: date, to: datetoday, options: [])
        
        let seconds = "\(String(describing: difference.second!)) SECONDS AGO"
        let minutes = "\(String(describing: difference.minute!)) MINUTES AGO"
        let hours = "\(String(describing: difference.hour!)) HOURS AGO"
        let days = "\(String(describing: difference.day!)) DAYS AGO"
        
        if difference.day!    > 0 { return days }
        if difference.hour!   > 0 { return hours }
        if difference.minute! > 0 { return minutes }
        if difference.second! > 0 { return seconds }
        return ""
    }
    
    class func validateFullNameWithSpace(fullName: String) -> Bool
    {
        do
        {
            let regex = try NSRegularExpression(pattern: "[\\sa-zA-Z]+ [\\sa-zA-Z]+", options: .caseInsensitive)
            if regex.matches(in: fullName, options: [], range: NSMakeRange(0, fullName.count)).count > 0 {return true}
        }
        catch {}
        return false
    }
    
    class func validateEmail(emailAddress: String!) -> Bool
    {
        let emailRegex = "(?:(?:(?:(?: )(?:(?:(?:\\t| )\\r\\n)?(?:\\t| )+))+(?: ))|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: ))|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )[!-Z^-~])*(?: ))|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )(?:(?:(?:\\t| )\\r\\n)?(?:\\t| )+))+(?: ))|(?: )+)?$"
                
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        if !emailTest.evaluate(with: emailAddress)
        {
            return false
        }
        else if emailAddress.count == 0
        {
            return false
        }
        else
        {
            return true
        }
    }
    
        
    class func validatePassword(password: String!) -> Bool
    {
        if password.count <= 7
        {
            return false
        }
        else
        {
            return true
        }
    }
    
    class func validateOTP(password: String!) -> Bool
    {
        if password.count == 6
        {
            return true
        }
        else
        {
            return false
        }
    }
    class func validatePhone(phone : String!) -> Bool
    {
        let PHONE_REGEX = "^\\d{10}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: phone)
        return result
    }
    
    class func validateZipCode(zip : String!) -> Bool
    {
        if zip.count <= 6
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    
    class func validateName(name: String!) -> Bool
    {
        let newName = name.trimmingCharacters(in: .whitespaces)
        if newName.count >= 3
        {
            let NAME_REGEX = "[A-Za-z]+"
            let nameTest = NSPredicate(format: "SELF MATCHES %@", NAME_REGEX)
            let result =  nameTest.evaluate(with: name.trimmingCharacters(in: NSCharacterSet.whitespaces))
            return result
        }
        else
        {
            return false
        }
    }

    class func validateFullName(name: String!) -> Bool
    {
        let newName = name.trimmingCharacters(in: .whitespaces)
        if newName.count > 0
        {
            let NAME_REGEX = "[\\sa-zA-Z]+"
            let nameTest = NSPredicate(format: "SELF MATCHES %@", NAME_REGEX)
            let result =  nameTest.evaluate(with: name.trimmingCharacters(in: NSCharacterSet.whitespaces))
            return result
        }
        else
        {
            return false
        }
    }
    
    class func getIntValue(value:AnyObject?) -> Int? {
        if let v = value {
            let intValueStr = "\(v)"
            return Int(intValueStr)
        }
        return nil
    }
    
    //MARK:- delay Function
    class func delay(_ delay:Double, closure:@escaping ()->()) {
        
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
            execute: closure
        )
    }
    
    //MARK:- Image Processing 
    
    class func fixOrientationforImage(image: UIImage) -> UIImage {
        
        if image.imageOrientation == UIImageOrientation.up {
            return image
        }
        var transform: CGAffineTransform = CGAffineTransform.identity
        switch image.imageOrientation {
        case .up,.downMirrored:
            transform = transform.translatedBy(x: image.size.width, y: image.size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
        case .left,.leftMirrored:
            transform = transform.translatedBy(x: image.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi/2))
        case .right,.rightMirrored:
            transform = transform.translatedBy(x: 0, y: image.size.height)
            transform = transform.rotated(by: CGFloat(-Double.pi/2))
        default: break
        }
        switch image.imageOrientation {
        case .upMirrored,.downMirrored:
            transform = transform.translatedBy(x: image.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .leftMirrored,.rightMirrored:
            transform = transform.translatedBy(x: image.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        default: break
        }
        let ctx: CGContext = CGContext(data: nil, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: image.cgImage!.bitsPerComponent, bytesPerRow: 0, space: image.cgImage!.colorSpace!, bitmapInfo: image.cgImage!.bitmapInfo.rawValue)!
        ctx.concatenate(transform)
        switch image.imageOrientation {
        case .left,.leftMirrored,.right,.rightMirrored:
            ctx.draw(image.cgImage!, in: CGRect(x: 0, y: 0, width: image.size.height, height: image.size.width))
        default:
            ctx.draw(image.cgImage!, in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        }
        let cgimg: CGImage = ctx.makeImage()!
        let img: UIImage = UIImage(cgImage: cgimg)
        return img
    }
    
    func errorMessage(error: NSError) -> String{
        
        if error.code == -101{
            return "Network Error"
        }else{
            return "Server Error"
        }
    }
    
    class func resizeImage(size: CGSize, image: UIImage) -> UIImage{
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size);
        image.draw(in: rect)
        let picture1 = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return picture1!
    }

    class func getStringFromTimeinterval(interval: Int) -> String {
        var str: String
        if interval > 60 * 60 * 24 * 3 {
            str = "few days ago"
        }
        else if interval > 60 * 60 * 24 * 2 {
            str = "2 days ago"
        }
        else if interval > 60 * 60 * 24 {
            str = "1 day ago"
        }
        else if interval > 60 * 60 {
            let a: Int = interval / (60 * 60)
            if a > 1 {
                str = "\(a) hours ago"
            }
            else {
                str = "1 hour ago"
            }
        }
        else if interval > 60 {
            let a: Int = interval / 60
            if a > 1 {
                str = "\(a) mins ago"
            }
            else {
                str = "1 min ago"
            }
        }
        else {
            str = "\(interval) secs ago"
        }
        
        return str
    }
    
    class func videoSnapshot(_ vidURL: NSURL) -> UIImage? {
        
        let asset = AVURLAsset(url: vidURL as URL)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        
        let timestamp = CMTime(seconds: 1, preferredTimescale: 60)
        
        do {
            let imageRef = try generator.copyCGImage(at: timestamp, actualTime: nil)
            return UIImage(cgImage: imageRef)
        }
        catch let error as NSError
        {
            print("Image generation failed with error \(error)")
            return nil
        }
    }
}
class CustomTextField: UITextField
{
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
    
}
public class UserDefault  {
    //MARK: UserDefault
    class func saveToUserDefault(value:AnyObject, key:String)
    {
        UserDefaults.standard.set(value, forKey:key)
        UserDefaults.standard.synchronize()
    }
    
    class func userDefaultForKey(key:String) -> String
    {
        var optional:String?
        optional = UserDefaults.standard.object(forKey: key) as? String
        
        
        if (optional != nil)
        {
            return UserDefaults.standard.object(forKey: key) as! NSString as String
        }
        else
        {
            return ""
        }
    }
    
    class func userDefaultForAny(key:String) -> AnyObject?
    {
        var optional:AnyObject?
        optional = UserDefaults.standard.object(forKey: key) as AnyObject?
        
        
        if (optional != nil)
        {
            return UserDefaults.standard.object(forKey: key) as AnyObject?
        }
        else
        {
            return nil
        }
        
    }
    
    class func userdefaultForArray(key:String) -> Array<AnyObject>
    {
        return UserDefaults.standard.object(forKey: key) as! Array
    }
    
    class func removeFromUserDefaultForKey(key:String)
    {
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
        
    }
    
}

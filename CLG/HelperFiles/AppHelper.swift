//
//  AppHelper.swift
//  FITOPPO
//
//  Created by swatantra on 2/7/17.
//  Copyright © 2017 swatantra. All rights reserved.
//

import Foundation
import ObjectiveC
import QuartzCore
import UIKit
import DGActivityIndicatorView
import SystemConfiguration
import CoreData
typealias  DidSelectedAction = ((_ selectedAction: String) -> Void)
protocol Utilities {
}

extension Date {
    var YearbeFore: Date {
        return Calendar.current.date(byAdding: .year, value: -18, to: self)!
    }
    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return tomorrow.month != month
    }
    
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        return dateFormatter.string(from: self).lowercased()
    }
}

let Indicator = DGActivityIndicatorView(type: DGActivityIndicatorAnimationType.ballSpinFadeLoader, tintColor: UIColor.white, size: 50)
let Indicator1 = DGActivityIndicatorView(type: DGActivityIndicatorAnimationType.ballSpinFadeLoader, tintColor: AppColors.appBlueColor, size: 50)


extension UIDevice {
    var hasTopNotch: Bool {
        if #available(iOS 11.0, tvOS 11.0, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
        return false
    }
}

class AppHelper {
    var selectedActionBlock : DidSelectedAction!
    var startData:Date?

    static var sharedInstance = AppHelper()
    
    class func hasTopNotch() -> Bool {
        if #available(iOS 11.0, tvOS 11.0, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
        return false
    }
    
    private init() {
        startData=Date()
//        let navi: UINavigationController? = AppHelper.navigationController()
    }
    // MARK: - Helper method
    //    class func SaveUserInfoToCoreData(Dict:[String:Any])
    //    {
    //        let gamesData =  try! JSONSerialization.data(withJSONObject: Dict as Any, options: [])
    //        let jsonData = String(data:gamesData, encoding:.utf8)!
    //        var context:NSManagedObjectContext!
    //        context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //        let fetchRequest: NSFetchRequest<GamesData>
    //        fetchRequest = GamesData.fetchRequest()
    //        do {
    //            let items = try context.fetch(fetchRequest)
    //            if items.count == 0
    //            {
    //                let entity =
    //                    NSEntityDescription.entity(forEntityName: "GamesData",
    //                                               in: context)!
    //                let apiDataObj = NSManagedObject(entity: entity,
    //                                                 insertInto: context) as! GamesData
    //                apiDataObj.userData = jsonData
    //            }
    //            else
    //            {
    //                for item in items
    //                {
    //                    item.userData = jsonData
    //                }
    //            }
    //
    //            // Save Changes
    //            try context.save()
    //
    //        } catch {
    //            // Error Handling
    //            // ...
    //        }
    //    }
    //
    //    class func getUserData() -> [String:Any]
    //    {
    //        var userData = [String:Any]()
    //        var string = ""
    //        var context : NSManagedObjectContext!
    //        context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //        let fetchRequest: NSFetchRequest<GamesData>
    //        fetchRequest = GamesData.fetchRequest()
    //        fetchRequest.includesPropertyValues = false
    //        do {
    //            let items = try context.fetch(fetchRequest) as [NSManagedObject]
    //
    //            for item in items {
    //                string = (item.value(forKey: "userData") as? String)!
    //            }
    //            // Save Changes
    //            try context.save()
    //
    //        } catch
    //        {
    //            print(error.localizedDescription)
    //        }
    //        if let data = string.data(using: .utf8)
    //        {
    //            do
    //            {
    //                userData = try (JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject])!
    //            }
    //            catch
    //            {
    //                print(error.localizedDescription)
    //            }
    //        }
    //        return userData
    //    }
    //    class func SaveGamesToCoreData(Arr:[[String:Any]])
    //    {
    //        let gamesData =  try! JSONSerialization.data(withJSONObject: Arr as Any, options: [])
    //        let jsonData = String(data:gamesData, encoding:.utf8)!
    //        var context:NSManagedObjectContext!
    //            context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //        let fetchRequest: NSFetchRequest<GamesData>
    //            fetchRequest = GamesData.fetchRequest()
    //        do {
    //            let items = try context.fetch(fetchRequest)
    //            if items.count == 0
    //            {
    //                let entity =
    //                    NSEntityDescription.entity(forEntityName: "GamesData",
    //                                               in: context)!
    //                let apiDataObj = NSManagedObject(entity: entity,
    //                                                 insertInto: context) as! GamesData
    //                apiDataObj.gamesApiData = jsonData
    //            }
    //            else
    //            {
    //                for item in items
    //                {
    //                    item.gamesApiData = jsonData
    //                }
    //            }
    //
    //            // Save Changes
    //            try context.save()
    //
    //        } catch {
    //            // Error Handling
    //            // ...
    //        }
    //    }
    //    class func getGamesData() -> [[String:Any]]
    //    {
    //        var gamesData = [[String:Any]]()
    //        var string = ""
    //        var context : NSManagedObjectContext!
    //            context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    //        let fetchRequest: NSFetchRequest<GamesData>
    //            fetchRequest = GamesData.fetchRequest()
    //        fetchRequest.includesPropertyValues = false
    //        do {
    //            let items = try context.fetch(fetchRequest) as [NSManagedObject]
    //
    //            for item in items {
    //                string = (item.value(forKey: "gamesApiData") as? String)!
    //            }
    //            // Save Changes
    //            try context.save()
    //
    //        } catch
    //        {
    //            print(error.localizedDescription)
    //        }
    //        if let data = string.data(using: .utf8)
    //        {
    //            do
    //            {
    //                gamesData = try (JSONSerialization.jsonObject(with: data, options: []) as? [[String: AnyObject]])!
    //            }
    //            catch
    //            {
    //                print(error.localizedDescription)
    //            }
    //        }
    //        return gamesData
    //    }
    
    class func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    class func loadImage (named: String,teamName:String) -> UIImage {
        
        if let confirmedImage = UIImage(named: named) {
            return confirmedImage
        } else {
            //return textToImage(drawText: teamName as NSString, inImage: getImageWithColor(color: returnColorOfTeam(teamName:teamName.uppercased()), size: CGSize(width: 50, height: 50)), atPoint: CGPoint(x: 6.0, y: 14.5))
            return generateImageWithText(text: teamName, image: getImageWithColor(color: returnColorOfTeam(teamName:teamName.uppercased()), size: CGSize(width: 50, height: 50)))
        }
        
    }
    class func returnNameString(teamName:String) -> String{
        let teamNameArray = teamName.split(separator: " ")
        if teamNameArray.count == 1{
            return String(teamNameArray[0]).substring(0..<3).uppercased()
        }
        else if teamNameArray.count == 2{
            return String(teamNameArray[0]).substring(0..<1).uppercased() + String(teamNameArray[1]).substring(0..<1).uppercased()
        }
        else if teamNameArray.count == 3{
            if String(teamNameArray[1]) == "and" || String(teamNameArray[1]) == "And" || String(teamNameArray[1]) == "AND"{
                return String(teamNameArray[0]).substring(0..<1).uppercased() + String(teamNameArray[2]).substring(0..<1).uppercased()
            }
            else{
                return String(teamNameArray[0]).substring(0..<1).uppercased() + String(teamNameArray[1]).substring(0..<1).uppercased() + String(teamNameArray[2]).substring(0..<1).uppercased()
            }
        }
        else {
            if String(teamNameArray[1]) == "and" || String(teamNameArray[1]) == "And" || String(teamNameArray[1]) == "AND"{
                return String(teamNameArray[0]).substring(0..<1).uppercased() + String(teamNameArray[2]).substring(0..<1).uppercased() + String(teamNameArray[3]).substring(0..<1).uppercased()
            }
            else if String(teamNameArray[2]) == "and" || String(teamNameArray[2]) == "And" || String(teamNameArray[2]) == "AND"{
                return String(teamNameArray[0]).substring(0..<1).uppercased() + String(teamNameArray[1]).substring(0..<1).uppercased() + String(teamNameArray[3]).substring(0..<1).uppercased()
            }
            else{
                return String(teamNameArray[0]).substring(0..<1).uppercased() + String(teamNameArray[1]).substring(0..<1).uppercased() + String(teamNameArray[2]).substring(0..<1).uppercased()
            }
        }
        
    }
    class func returnColorOfTeam(teamName:String) -> UIColor{
        if teamName.hasPrefix("A") || teamName.hasPrefix("B") || teamName.hasPrefix("C") || teamName.hasPrefix("D") || teamName.hasPrefix("E"){
            return hexStringToUIColor(hex: "3498db")
        }
        else if teamName.hasPrefix("F") || teamName.hasPrefix("G") || teamName.hasPrefix("H") || teamName.hasPrefix("I") || teamName.hasPrefix("J"){
            return hexStringToUIColor(hex: "3A932F")
        }
        else if teamName.hasPrefix("K") || teamName.hasPrefix("L") || teamName.hasPrefix("M") || teamName.hasPrefix("N") || teamName.hasPrefix("O"){
            return hexStringToUIColor(hex: "D75857")
        }
        else if teamName.hasPrefix("P") || teamName.hasPrefix("Q") || teamName.hasPrefix("R") || teamName.hasPrefix("S") || teamName.hasPrefix("T"){
            return hexStringToUIColor(hex: "#f57f17")
        }
        else{
            return  hexStringToUIColor(hex: "#3e2723")
        }
        
    }
    class func generateImageWithText(text: String, image:UIImage) -> UIImage
    {
        let imageView = UIImageView(image: image)
        imageView.backgroundColor = UIColor.clear
        imageView.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        label.backgroundColor = UIColor.clear
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont(name: "Lato-Bold", size: 16)
        if text.count == 0 || text.count == 1 || text.count == 2 || text.count == 3{
            label.text = text.uppercased()
        }
        else{
            label.text = returnNameString(teamName: text as String)
        }
        
        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0);
        imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        label.layer.render(in: UIGraphicsGetCurrentContext()!)
        let imageWithText = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return imageWithText
    }
    class func aadIndictorImge() {
        let viewO=UIViewController()
        viewO.view.backgroundColor=UIColor.lightText
        viewO.modalPresentationStyle = .custom
        AppHelper.appDelegate().window?.rootViewController?.present(viewO, animated: true, completion: {
            
        })
        
    }
    
    class func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    class func stringToCurrentDate(strDate:String, format:String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        let date = dateFormatter.date(from: strDate)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = NSLocale.current
        let tempStr = dateFormatter.string(from: date!)
        return dateFormatter.date(from: tempStr)
    }
    class func stringToGmtDate(strDate:String, format:String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.date(from: strDate)
    }
    class func stringToDate(strDate:String, format:String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: strDate)
    }
    
    class func dateToString(date:Date, format:String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter.string(from: date)
    }
    
    class func heightForLabel(text:String, font:UIFont, width:CGFloat) -> CGFloat
    {
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
    class func getMilliseconds(strDate:Date) -> Int{
        //let dateFormatter = DateFormatter()
        //dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        //let date = dateFormatter.date(from: strDate)
        // print(date!)
        let millieseconds = getDiffernce(toTime: strDate)
        print("miliseconds = ", millieseconds)
        return Int(millieseconds)
    }
    class func getDiffernce(toTime:Date) -> Int{
        let elapsed = NSDate().timeIntervalSince(toTime)
        return Int(elapsed * 1000)
    }
    //Date to milliseconds
    class func currentTimeInMiliseconds(currentDate:Date,format:String) -> Int! {
        //let currentDate = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        let date = dateFormatter.date(from: dateFormatter.string(from: currentDate as Date))
        let nowDouble = date!.timeIntervalSince1970
        return Int(nowDouble*1000)
    }

    class func rootViewController() -> UIViewController
    {
        return (UIApplication.shared.keyWindow?.rootViewController)!
    }
//    class func navigationController() -> UINavigationController {
//        return (AppHelper.appDelegate().window!.rootViewController! as! UINavigationController)
//    }
    
    // MARK: Alert methods
    
    class func showAlert(title:String,_ message: String, okButtonTitle: String? = nil, target: UIViewController? = nil) {
        
        let topViewController: UIViewController? = AppHelper.topMostViewController(rootViewController: AppHelper.rootViewController())
        
        if let _ = topViewController {
            let alert = UIAlertController(title:title, message: message, preferredStyle: UIAlertController.Style.alert);
            let okBtnTitle = "OK"
            let okAction = UIAlertAction(title:okBtnTitle, style: UIAlertAction.Style.default, handler: nil);
            
            alert.addAction(okAction);
            if UIApplication.shared.applicationState != .background{
                topViewController?.present(alert, animated:true, completion:nil);
            }
        }
    }
    
    class func appDelegate() -> AppDelegate {
        return (UIApplication.shared.delegate! as! AppDelegate)
    }
    class func logout(dict:[String:Any])->Bool
    {
        if dict["statusCode"] != nil
        {
            if dict["statusCode"] as! Int == 0
            {
                if dict["error"] != nil
                {
                    if let error = dict["error"] as? [String:Any]
                    {
                        if error["errorCode"] != nil
                        {
                            if error["errorCode"] as! Int == 2
                            {
                                Drop.down("User session has expired.\n Kindly close the app and log back in.")
                                UserDefault.removeFromUserDefaultForKey(key: "accessToken")
                                return false
                            }
                        }
                    }
                }
            }
        }
        return true
    }
    class func showHud(type:Int){
        AppHelper.appDelegate().window?.isUserInteractionEnabled = false
        if type == 1{
            AppHelper.appDelegate().window?.visibleViewController()?.view.addSubview(Indicator!)
//            UIApplication.shared.keyWindow?.addSubview(Indicator!)
            Indicator?.center = (UIApplication.shared.keyWindow?.center)!
            Indicator!.startAnimating()
        }
        else if type == 2{
            AppHelper.appDelegate().window?.visibleViewController()?.view.addSubview(Indicator1!)
//            UIApplication.shared.keyWindow?.addSubview(Indicator1!)
            Indicator1?.center = (UIApplication.shared.keyWindow?.center)!
            Indicator1!.startAnimating()
        }
    }
    
    class func hideHud(){
        DispatchQueue.main.async {
            AppHelper.appDelegate().window?.isUserInteractionEnabled = true
            Indicator?.removeFromSuperview()
            Indicator1?.removeFromSuperview()
        }
    }
    class func StartProgressIndicator(view:UIView,color:UIColor)->DGActivityIndicatorView
    {
        AppHelper.appDelegate().window?.isUserInteractionEnabled = false
        let Indicator = DGActivityIndicatorView(type: .ballSpinFadeLoader, tintColor: color, size: 60)
        Indicator?.center = view.center
        view.addSubview(Indicator!)
        Indicator!.startAnimating()
        return Indicator!
    }
    class func StopProgressIndicator(view:DGActivityIndicatorView)
    {
        AppHelper.appDelegate().window?.isUserInteractionEnabled = true
        view.stopAnimating()
        view.removeFromSuperview()
    }
    class func intialiseViewController(fromMainStoryboard storyBoard: String, withName vcName: String) -> UIViewController {
        return UIStoryboard(name: storyBoard, bundle: nil).instantiateViewController(withIdentifier: vcName)
    }
    
    
    
    // MARK: - Indicator Method
    func makeRoundImg(img: UIImage) -> UIImage {
        let imgLayer = CALayer()
        imgLayer.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        imgLayer.contents = img.cgImage;
        imgLayer.masksToBounds = true;
        
        imgLayer.cornerRadius = 15 //img.frame.size.width/2
        
        UIGraphicsBeginImageContext(imgLayer.frame.size)
        imgLayer.render(in: UIGraphicsGetCurrentContext()!)
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return roundedImage!;
    }
    //    func cerateTabIcon(url:URL) {
    //        DispatchQueue.global().async {
    //            let data = try? Data(contentsOf: url)
    //            DispatchQueue.main.async {
    //                if let datav=data{
    //                    var img=UIImage(data: datav)
    //                    img=self.makeRoundImg(img: img!)
    //                    let tabHome = AppHelper.appDelegate().tabBarControllerAPP.tabBar.items![4]
    //                    //tabHome.title = "Home" // tabbar titlee
    //                    tabHome.image=img?.withRenderingMode(.alwaysOriginal)
    //                    tabHome.selectedImage=img?.withRenderingMode(.alwaysOriginal)// deselect image
    //                    //tabHome.selectedImage = img??.withRenderingMode(.alwaysOriginal) // select image
    //                    // self.profilePicView.af_setImage(withURL: url!)
    //                }
    //
    //            }
    //
    //        }
    //    }
    
    
    //MARK: image method
    
    class func saveImageData(_ image: UIImage, withImageName imageName: String) {
        var paths: [Any] = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory: String = paths[0] as! String
        var _: String = URL(fileURLWithPath: documentsDirectory).appendingPathComponent(imageName).absoluteString
        //        var imageData: Data? = image.uiImageJPEGRepresentation()
        //        imageData?.write(to: savedImagePath, options: false)
    }
    
    func removeImage(_ filename: String) {
        _ = FileManager.default
        let documentsPath: String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let _: String = URL(fileURLWithPath: documentsPath).appendingPathComponent(filename).absoluteString
        let _: Error?
    }
    
    class func getDocumentPathImageName(_ imageName: String) -> String {
        let paths: [Any] = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory: String = paths[0] as! String
        let savedImagePath: String = URL(fileURLWithPath: documentsDirectory).appendingPathComponent(imageName).absoluteString
        return savedImagePath
    }
    
    class func normalizedImage(_ image: UIImage) -> UIImage {
        if image.imageOrientation == .up {
            return image
        }
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        // image.draw(in: [0, 0, image.size])
        let normalizedImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return normalizedImage!
    }
    //MARK: Date
    class   func getNextYearDate(_ date: Date, year: String) -> Date {
        let calnder = Calendar.current
        let compnet: DateComponents? = calnder.dateComponents([.year, .month, .day], from: date)
        var refCmnt = DateComponents()
        refCmnt.day = compnet?.day
        refCmnt.month = compnet?.month
        refCmnt.year = (compnet?.year)! - (year as NSString).integerValue
        return calnder.date(from: refCmnt)!
    }
    class func unixDateString(_ date: Date) -> String {
        let   date1 = AppHelper.getUTCFormateDate(date)
        let unixTime = Double(date1.timeIntervalSince1970)
        return "\(unixTime)"
    }
    class func getUTCFormateDate(_ localDate: Date) -> Date {
        let  formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        
        formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        let dateString: String = formatter.string(from: localDate)
        return formatter.date(from: dateString)!
    }
    class func returnDate(fromUnixTimeStamp unixTimeStampString: String) -> Date {
        let dDate: Double = Double(unixTimeStampString)!
        let date = Date(timeIntervalSince1970: dDate)
        return AppHelper.getLocalDate(date)
    }
    class func getLocalDate(_ localDate: Date) -> Date {
        let timeZoneOffset: TimeInterval = TimeInterval(NSTimeZone.system.secondsFromGMT(for: localDate))
        let gmtDate = localDate.addingTimeInterval(timeZoneOffset)
        return gmtDate
    }
    //MARK: USER DEFAULT
    
    class func allPropertyNamesOf( myclass: AnyClass) -> [String] {
        var count: UInt32 = 0
        guard let properties = class_copyPropertyList(myclass, &count) else {
            return []
        }
        
        var rv = [String]()
        for i in 0..<count {
            let property: objc_property_t? = properties[Int(i)]
            let name = String(utf8String: property_getName(property!))
            rv.append(name!)
        }
        free(properties)
        return rv
    }
    class func saveToUserDefaults(value: AnyObject, withKey key: String) {
        let standardUserDefaults = UserDefaults.standard
        
        standardUserDefaults.set(value, forKey: key)
        standardUserDefaults.synchronize()
        
    }
    
    class func userDefaultsForKey(key: String) -> AnyObject {
        let standardUserDefaults = UserDefaults.standard
        var val: AnyObject
        val = standardUserDefaults.value(forKey: key) as AnyObject
        return val
    }
    
    class func removeFromUserDefaultsWithKey(key: String) {
        let  standardUserDefaults = UserDefaults.standard
        standardUserDefaults.removeObject(forKey: key)
        standardUserDefaults.synchronize()
    }
    class func nullCheck(_ stringD: AnyObject? = nil) -> AnyObject {
        if stringD is NSNull{
            return "" as AnyObject
        }
        else if let testData = stringD  {
            return testData
            
        }
        else{
            return "" as AnyObject
        }
        
    }
    
    class func getGradientLayer() -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.startPoint = CGPoint(x: 0.0, y: 0.5)
        layer.endPoint = CGPoint(x: 1.0, y: 0.5)
        layer.colors = [UIColor.init(red: 61.0/255.0, green: 68.0/255.0, blue: 117.0/255.0, alpha: 1.0).cgColor,UIColor.init(red: 78.0/255.0, green: 29.0/255.0, blue: 98.0/255.0, alpha: 1.0).cgColor]
        return layer
    }
    class func getMatchDateAndTime(type:Int,date:String) -> String {
        let createdDate = self.stringToGmtDate(strDate: date, format: "dd/MM/yyyy HH:mm") ?? Date()
        let dateFormatter = DateFormatter()
        if type == 1
        {
            dateFormatter.dateFormat = "h:mm a dd-MMM"
            return dateFormatter.string(from: createdDate)
        }
        else if type == 2
        {
            let createdDate1 = self.stringToDate(strDate: date, format: "dd/MM/yyyy HH:mm")
            dateFormatter.dateFormat = "dd MMM, h:mm a"
            var tempStr1 = dateFormatter.string(from: createdDate)
            dateFormatter.dateFormat = "h:mm a"
            var tempStr2 = dateFormatter.string(from: createdDate1!)
//            tempStr1 = tempStr1 + " IST \n| " + tempStr2 + " GMT"
            tempStr1 = tempStr1 + " your time"
            return tempStr1
        }
        else
        {
            return "\(Int((createdDate.timeIntervalSince1970)))"
        }
    }
    class func CheckForNumberAndString(_ checkString: String) -> Bool {
        //        let emailRegEx = "^(?=.*[0-9])(?=.*[a-zA-Z])([a-zA-Z0-9]+)$"
        let emailRegEx = "^(?=.*[A-Za-z])(?=.*\\d)(?=\\S+$)[A-Za-z\\d$@$!%*#?&]{7,30}$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: checkString)
    }
    class func emailValidate(_ checkString: String) -> Bool {
        //            let emailRegEx = "^([0-9a-zA-Z]([-\\.\\w]*[0-9a-zA-Z])*@([0-9a-zA-Z][-\\w]*[0-9a-zA-Z]\\.)+[a-zA-Z]{2,9})$"
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: checkString)
    }
    class func nameValidate(_ checkString: String) -> Bool {
        let nameRegEx = "^[A-Za-z\\s]{2,40}$"
        let nameTest = NSPredicate(format:"SELF MATCHES %@", nameRegEx)
        return nameTest.evaluate(with: checkString)
    }
    
    //MARK: VIEW METHOD
    class func addShadow(viewLayerObj:UIView ,withcolor:UIColor) {
        viewLayerObj.layer.shadowColor = withcolor.cgColor
        viewLayerObj.layer.shadowOffset = CGSize(width: 1, height: 1)
        viewLayerObj.layer.shadowOpacity = 1.0
        viewLayerObj.layer.shadowRadius = 5.0
        viewLayerObj.layer.masksToBounds = false
    }
    class func addLayer(viewLayerObj:UIView ,withcolor:UIColor) {
        viewLayerObj.layer.cornerRadius = 3.0
        viewLayerObj.layer.borderColor = withcolor.cgColor
        viewLayerObj.layer.borderWidth = 1
        viewLayerObj.layer.masksToBounds = false
    }
    class func showDataLableNotFound(tableView : UITableView, message : String, showView : UIView) {
        
        let emptyLabel = UILabel.init(frame : CGRect( x : 20,y :  0, width : showView.bounds.size.width-20, height : showView.bounds.size.height))
        emptyLabel.text = message
        emptyLabel.textColor = UIColor.darkGray
        emptyLabel.lineBreakMode = .byWordWrapping
        let font : UIFont = UIFont(name: "OpenSans", size: CGFloat(13))!
        emptyLabel.font = font
        emptyLabel.numberOfLines = 0;
        emptyLabel.textAlignment = NSTextAlignment.center
        tableView.backgroundView = emptyLabel
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
    }
    
    class func hideDataLableNotFound(tableView : UITableView) {
        tableView.backgroundView = nil
    }
    
    class func setupView(atUp value: Int, toview viewD: UIView) {
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(0.25)
        var rect: CGRect = viewD.frame
        if value == 0 {
            rect.origin.y = CGFloat(value)
        }
        else {
            rect.origin.y =  rect.origin.y-CGFloat(value)
        }
        viewD.frame = rect
        UIView.commitAnimations()
    }
    class func containsSwearWord(text: String, swearWords: [String]) -> Bool {
        return swearWords
            .reduce(false) { $0 || text.contains($1.lowercased()) }
    }
    class func share()
    {
        let textToShare = """
        Hi,

        Install Cricket Line Guru to get in touch with Live Cricket Updates-
        
        Android App- http://play.google.com/store/apps/details?id=com.app.cricketapp
        
        IPhone App- https://itunes.apple.com/in/app/cricket-line-guru/id1247859253?mt=8
        """
            let objectsToShare = [textToShare] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            activityVC.completionHandler = {(activityType, completed:Bool) in
                if !completed {
                    //cancelled
                    return
                }
                
                //shared successfully
                
                //below is how you would detect for different sharing services
                var activity:String = "other"
                if activityType == UIActivityType.postToTwitter {
                    activity = "twitter"
                }
                if activityType == UIActivityType.mail {
                    activity = "mail"
                }
                //more code here if you like
            }
            
            activityVC.excludedActivityTypes = [UIActivityType.postToWeibo,
                                                UIActivityType.message,
                                                UIActivityType.mail,
                                                UIActivityType.print,
                                                UIActivityType.copyToPasteboard,
                                                UIActivityType.assignToContact,
                                                UIActivityType.saveToCameraRoll,
                                                UIActivityType.addToReadingList,
                                                UIActivityType.postToFlickr,
                                                UIActivityType.postToVimeo,
                                                UIActivityType.postToFacebook,
                                                UIActivityType.postToTencentWeibo,
                                                UIActivityType.airDrop]
        activityVC.popoverPresentationController?.sourceView = self.topMostViewController(rootViewController: rootViewController())?.view
            self.topMostViewController(rootViewController: self.rootViewController())?.present(activityVC, animated: true, completion: nil)
    }
    
    class func share(vc : UIViewController) {
        let textToShare = """
        Hi,

        Install Cricket Line Guru to get in touch with Live Cricket Updates-
        
        Android App- http://play.google.com/store/apps/details?id=com.app.cricketapp
        
        IPhone App- https://itunes.apple.com/in/app/cricket-line-guru/id1247859253?mt=8
        """
            let objectsToShare = [textToShare] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            activityVC.completionHandler = {(activityType, completed:Bool) in
                if !completed {
                    //cancelled
                    return
                }
                
                //shared successfully
                
                //below is how you would detect for different sharing services
                var activity:String = "other"
                if activityType == UIActivityType.postToTwitter {
                    activity = "twitter"
                }
                if activityType == UIActivityType.mail {
                    activity = "mail"
                }
                //more code here if you like
            }
            
            activityVC.excludedActivityTypes = [UIActivityType.postToWeibo,
                                                UIActivityType.message,
                                                UIActivityType.mail,
                                                UIActivityType.print,
                                                UIActivityType.copyToPasteboard,
                                                UIActivityType.assignToContact,
                                                UIActivityType.saveToCameraRoll,
                                                UIActivityType.addToReadingList,
                                                UIActivityType.postToFlickr,
                                                UIActivityType.postToVimeo,
                                                UIActivityType.postToFacebook,
                                                UIActivityType.postToTencentWeibo,
                                                UIActivityType.airDrop]
//        activityVC.popoverPresentationController?.sourceView = self
//        vc.present(activityVC, animated: true, completion: nil)
        activityVC.popoverPresentationController?.sourceView = vc.view

        vc.present(activityVC, animated: true, completion: nil)
    }
    
    class func topMostViewController(rootViewController: UIViewController) -> UIViewController?
    {
        if let navigationController = rootViewController as? UINavigationController
        {
            return topMostViewController(rootViewController: navigationController.visibleViewController!)
        }
        
        if let tabBarController = rootViewController as? UITabBarController
        {
            if let selectedTabBarController = tabBarController.selectedViewController
            {
                return topMostViewController(rootViewController: selectedTabBarController)
            }
        }
        
        if let presentedViewController = rootViewController.presentedViewController
        {
            return topMostViewController(rootViewController: presentedViewController)
        }
        return rootViewController
    }
    class func getIndexPathFor(view: UIView, tableView: UITableView) -> IndexPath? {
        let point = tableView.convert(view.bounds.origin, from: view)
        let indexPath = tableView.indexPathForRow(at: point)
        return indexPath
    }
    
    class func getIndexPathFor(view: UIView, collectionView: UICollectionView) -> IndexPath? {
        let point = collectionView.convert(view.bounds.origin, from: view)
        let indexPath = collectionView.indexPathForItem(at: point)
        return indexPath
    }
    
    class func timeAgoSinceDate(_ date:Date,currentDate:Date, numericDates:Bool) -> String {
        let calendar = Calendar.current
        let now = currentDate
        let earliest = (now as NSDate).earlierDate(date)
        let latest = (earliest == now) ? date : now
        let components : DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())
        if (components.year! >= 2) {
            return "\(components.year!) years ago"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year ago"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months ago"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month ago"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks ago"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week ago"
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!) days ago"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1 day ago"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!) hours ago"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1 hour ago"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!) minutes ago"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1 minute ago"
            } else {
                return "A minute ago"
            }
        } else if (components.second! >= 3) {
            return "Just now"
        } else {
            return "Just now"
        }
        
    }
    
}
//Enums
enum ViewControllerType {
    case welcome
    case conversations
}

enum PhotoSource {
    case library
    case camera
}

enum ShowExtraView {
    case contacts
    case profile
    case preview
    case map
}

enum MessageType {
    case photo
    case text
    case location
}

enum MessageOwner {
    case sender
    case receiver
}
class PagedCollectionLayout : UICollectionViewFlowLayout {
    
    var previousOffset : CGFloat = 0
    var currentPage : CGFloat = 0
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        let sup = super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        
        guard
            let validCollection = collectionView,
            let dataSource = validCollection.dataSource
            else { return sup }
        
        let itemsCount = dataSource.collectionView(validCollection, numberOfItemsInSection: 0)
        
        // Imitating paging behaviour
        // Check previous offset and scroll direction
        if  (previousOffset > validCollection.contentOffset.x) && (velocity.x < 0) {
            currentPage = max(currentPage - 1, 0)
        }
        else if (previousOffset < validCollection.contentOffset.x) && (velocity.x > 0) {
            currentPage = min(currentPage + 1, CGFloat(itemsCount - 1))
        }
        
        let updatedOffset = ((collectionView!.frame.width-48) * currentPage)
        let updatedOffset1 = (((collectionView!.frame.width-48) + minimumLineSpacing) * currentPage)
        let updatedOffset2 = 38+((collectionView!.frame.width-48) * currentPage)
        print ("updatedOffset1-\(updatedOffset1)\ncollectionView-\((collectionView!.frame.width-48))\nminimumInteritemSpacing-\(minimumInteritemSpacing)")
        if currentPage == 0
        {
            self.previousOffset = updatedOffset
            return CGPoint(x: updatedOffset, y: proposedContentOffset.y)
        }
        else if Int(currentPage) == itemsCount-1
        {
            self.previousOffset = updatedOffset2
            return CGPoint(x: updatedOffset2, y: proposedContentOffset.y)
        }
        else
        {
            self.previousOffset = updatedOffset1
            return CGPoint(x: updatedOffset1, y: proposedContentOffset.y)
        }
    }
}

public extension String {
    
    //right is the first encountered string after left
    func between(_ left: String, _ right: String) -> String? {
        guard
            let leftRange = range(of: left), let rightRange = range(of: right, options: .backwards)
            , leftRange.upperBound <= rightRange.lowerBound
            else { return nil }
        
        let sub = self[leftRange.upperBound...]
        let closestToLeftRange = sub.range(of: right)!
        return String(sub[..<closestToLeftRange.lowerBound])
    }
    
    
    
    func substring(to : Int) -> String {
        let toIndex = self.index(self.startIndex, offsetBy: to)
        return String(self[...toIndex])
    }
    
    func substring(from : Int) -> String {
        let fromIndex = self.index(self.startIndex, offsetBy: from)
        return String(self[fromIndex...])
    }
    
    func substring(_ r: Range<Int>) -> String {
        let fromIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
        let toIndex = self.index(self.startIndex, offsetBy: r.upperBound)
        let indexRange = Range<String.Index>(uncheckedBounds: (lower: fromIndex, upper: toIndex))
        return String(self[indexRange])
    }
    
    func character(_ at: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: at)]
    }
    
    func lastIndexOfCharacter(_ c: Character) -> Int? {
        return range(of: String(c), options: .backwards)?.lowerBound.encodedOffset
    }
}

extension StringProtocol {
    var firstUppercased: String {
        return prefix(1).uppercased()  + dropFirst()
    }
    var firstCapitalized: String {
        return prefix(1).capitalized + dropFirst()
    }
}
extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}

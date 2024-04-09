//
//  AppDelegate.swift
//  cricrate
//


import UIKit
import CoreData
import GoogleMobileAds
import AVFoundation
import FirebaseAnalytics
import UserNotifications
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import FirebaseDatabase
import Fabric
import Crashlytics
import FBSDKCoreKit
import FirebaseFirestore

var fireBaseGlobalModel = [CLGFirbaseArrModel]()
//var fireBaseGlobalModelLive = [CLGFirbaseArrModel]()
var chatGlobalArr = [CLGChatArrModel]()
var fireBaseGlobalModelNew = [CLGFirbaseArrModel]()
var groupId = String()
var db : Firestore!
var dbNameArray:[String]? = []

@UIApplicationMain //Commit - 11:47 pm 24/07/18 version 2 build 1



class AppDelegate: UIResponder, UIApplicationDelegate,GADInterstitialDelegate, FBInterstitialAdDelegate, FBNativeAdDelegate
{
    var window: UIWindow?
    var disclamer = "Through our extensive knowledge about the system, and analysis about the same, we specialize in providing the users with Match Odds, as well as Sessions. We don't support betting and we are not responsible for any unlawful action taken by the user. The app is only meant for entertainment purposes. Any illegal activities done by the user is the sole responsibility of the user."
    var apiInfo = CLGHomeResponseDataApiV3()
    var message = ""
    var feedbackEmail = "feedback.clg@gmail.com"
    var feedbackMsg = ""
    var feedbackSubject = ""
    var ref: DatabaseReference!
    var interstitialAds: GADInterstitial!
    var adLoader = GADAdLoader()
    let numAdsToLoad = 5  
    var nativeAds = [GADUnifiedNativeAd]()
    var fbInterstitialAd: FBInterstitialAd!
    var toShowInterstitial =  true
    
//        let adInterstitialUnitID = "ca-app-pub-2647530763019536/6589794000"// lineguru live
//        var adBannerUnitID = "ca-app-pub-2647530763019536/9398611208" // lineguru live
//        var adNativeUnitID = "ca-app-pub-2647530763019536/4099603980" // lineguru live
//    var adNativeUnitID  = "ca-app-pub-3940256099942544/3986624511" // lineguru test
//    var adBannerUnitID = "ca-app-pub-3940256099942544/2934735716" // lineguru test
//    let adInterstitialUnitID = "ca-app-pub-3940256099942544/3986624511"// lineguru test
    
    let adInterstitialUnitID = "ca-app-pub-2647530763019536/9794000"// lineguru live
           var adBannerUnitID = "ca-app-pub-2647530763019536/8611208" // lineguru live
           var adNativeUnitID = "ca-app-pub-264753019536/4099603980" // lineguru live
    
    
    let fbInterstitialAdId = "308094136473294_645170409432330"
    let fbBannerAdId = "308094136473294_308094599806581"
    let fbNativeAdId = "308094136473294_645169559432415"
    
    let timeStamp = Timestamp()
    var fbnativeAd : FBNativeAd!
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//        self.interstitialAds = createAndLoadInterstitial()
        //self.requestNativeAdvanceAd()
        self.fbInterstitialAd = self.loadInterstitialFbAd()
        self.loadFbNativeAd()
        interstitialAds = GADInterstitial()
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [:])
        FirebaseApp.configure()
        db = Firestore.firestore()
        print(db)
        setUp()
        registerPush(app:application)
        self.firebaseConfigMethod()
//        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.3) {
            self.requestNativeAdvanceAd()
        }
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
        
        return true
    }
    
    func loadFbNativeAd() {
        fbnativeAd = FBNativeAd(placementID: self.fbNativeAdId)
        fbnativeAd.delegate = self
        fbnativeAd.loadAd()
    }
    
    func nativeAdDidLoad(_ nativeAd: FBNativeAd) {
        self.fbnativeAd = nativeAd
    }
    
    func nativeAd(_ nativeAd: FBNativeAd, didFailWithError error: Error) {
        self.loadFbNativeAd()
    }
    
    func loadInterstitialFbAd() -> FBInterstitialAd {
        let fbInterstitialAd = FBInterstitialAd(placementID: AppHelper.appDelegate().fbInterstitialAdId)
        fbInterstitialAd.delegate = self
        fbInterstitialAd.load()
        return fbInterstitialAd
    }
    
    func interstitialAdDidLoad(_ interstitialAd: FBInterstitialAd) {
        self.fbInterstitialAd = interstitialAd
    }
    
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial =
            GADInterstitial(adUnitID: AppHelper.appDelegate().adInterstitialUnitID)
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    
    func requestNativeAdvanceAd() {
        let options = GADMultipleAdsAdLoaderOptions()
        options.numberOfAds = numAdsToLoad
        // Prepare the ad loader and start loading ads.
        adLoader = GADAdLoader(adUnitID: AppHelper.appDelegate().adNativeUnitID,
                               rootViewController: self.window?.visibleViewController(),
                               adTypes: [.unifiedNative],
                               options: [options])
        
        self.adLoader.delegate = self
        adLoader.load(GADRequest())
    }
    
    func runTimer() {
        Timer.scheduledTimer(timeInterval: 120, target: self, selector: #selector(changeAdValue), userInfo: nil, repeats: false)
    }
    
    @objc func changeAdValue() {
        self.toShowInterstitial = true
    }
    
    func returnNativeAdArray() -> [GADUnifiedNativeAd]{
        return nativeAds
    }
    /// Tells the delegate an ad request succeeded.
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        self.interstitialAds = ad
    }
    
    /// Tells the delegate an ad request failed.
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
        self.interstitialAds = createAndLoadInterstitial()

    }
    
    /// Tells the delegate that an interstitial will be presented.
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        print("interstitialWillPresentScreen")
        
    }
    
    /// Tells the delegate the interstitial is to be animated off the screen.
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        print("interstitialWillDismissScreen")
        
    }
    
    /// Tells the delegate the interstitial had been animated off the screen.
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        print("interstitialDidDismissScreen")
        self.interstitialAds = nil
        self.interstitialAds = createAndLoadInterstitial()
    }
    
    /// Tells the delegate that a user click will open another app
    /// (such as the App Store), backgrounding the current app.
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        print("interstitialWillLeaveApplication")
        self.interstitialAds = createAndLoadInterstitial()
    }
    @objc func showAd(){
        if self.interstitialAds.isReady{
            self.interstitialAds.present(fromRootViewController: (self.window?.visibleViewController())!)
        }
    }
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
  
//    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool{
//        let sourceApplication: String? = options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String
//        let annotation = options[UIApplicationOpenURLOptionsKey.annotation]
//        if url.absoluteString.contains("fb227435798169211"){
//            return ApplicationDelegate.shared.application(app, open: url, sourceApplication: sourceApplication, annotation: annotation)
//        }
//        else{
//            return GIDSignIn.sharedInstance().handle(url,
//                                                     sourceApplication: sourceApplication,
//                                                     annotation: annotation)
//        }
//    }
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication){
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//        SocketIOManager.connectSocket()
        if let forceUpdate = UserDefault.userDefaultForAny(key: "ForceUpdate") as? String
        {
            if forceUpdate == "1"
            {
                UserDefault.saveToUserDefault(value: "1" as AnyObject, key: "ForceUpdate")
                let alert = UIAlertController(title: "Cricket Line Guru", message:"Please update to our latest version", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (data) in
                        let url  = NSURL(string: "https://itunes.apple.com/in/app/cricket-line-guru/id1247859253?mt=8")
                        if UIApplication.shared.canOpenURL(url! as URL) {
                            if #available(iOS 10.0, *) {
                                UIApplication.shared.open(url! as URL)
                            } else {
                                // Fallback on earlier versions
                                UIApplication.shared.openURL(url! as URL)
                            }
                        }
                        else
                        {
                            Drop.down("Unable to open Appstore")
                        }
                }))
                AppHelper.hideHud()
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.5) {
                    self.window?.visibleViewController()?.present(alert, animated: true, completion: nil)
                    
                }
            }
        }
        //self.requestNativeAdvanceAd()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        //  self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    // MARK: - Core Data stack
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "CLG")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.connection360.app" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1] as NSURL
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "CLG", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("CLG.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    lazy var privateManagedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    @available(iOS 10.0, *)
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void){
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
         UserDefaults.standard.setValue("uwefghbnwiuef8239r823r", forKey: "DeviceToken")
        
        //  print("Unable to register for remote notifications: \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var token = ""
        for i in 0..<deviceToken.count {
            token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        UserDefaults.standard.setValue(token, forKey: "DeviceToken")
        Messaging.messaging().setAPNSToken(deviceToken, type: MessagingAPNSTokenType.sandbox)
    }
    func connectToFcm() {
        /*// Won't connect since there is no token
        guard InstanceID.instanceID().token() != nil else {
            return;
        }
        
        // Disconnect previous FCM connection if it exists.
        Messaging.messaging().disconnect()
        //        Messaging.messaging().shouldEstablishDirectChannel = false       TODO
        //        Messaging.messaging().shouldEstablishDirectChannel = true     TODO
        
        Messaging.messaging().connect { (error) in
            if error != nil {
                //   print("Unable to connect with FCM. \(error)")
            } else {
                print("Connected to FCM.")
            }
        }*/
    }
    func testing(str:String)
    {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
//            Drop.down("\(str)")
//        })
    }
    func registerPush(app:UIApplication)
    {
        // [START register_for_notifications]
        if #available(iOS 10.0, *) {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            // For iOS 10 data message (sent via FCM)
            Messaging.messaging().delegate = self
            
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            app.registerUserNotificationSettings(settings)
            Messaging.messaging().delegate = self
            
        }
        app.registerForRemoteNotifications()
    }
    
    func firebaseConfigMethod()
    {
        let dbtime = UserDefault.userDefaultForAny(key: "DbDateTime") as? Int64
        let currentdbtime = Date().toMillis() ?? 0
        if (dbtime == nil || (dbtime! + 86400000) < currentdbtime){
        db.collection("f").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("hhhjkkjhjkhhkj \(document.documentID) => \((document.data()["names"] as! [String])[0] )")
                    dbNameArray?.removeAll()
                    for i in 0..<(document.data()["names"] as! [String]).count{
                        dbNameArray?.append((document.data()["names"] as! [String])[i])
                    }
                    
                    let randomInt = Int.random(in: 0...(dbNameArray!.count-1))
                    self.ref = Database.database(url: "https://"+(dbNameArray?[randomInt])!+".firebaseio.com/").reference()
                    self.testing(str:"DB5")
                    //Drop.down("https://"+(dbNameArray?[randomInt])!+".firebaseio.com/")
                    print("DB Url1= ", "https://"+(dbNameArray?[randomInt])!+".firebaseio.com/")

                    //UserDefault.saveToUserDefault(value: "https://"+(dbNameArray?[randomInt])!+".firebaseio.com/" as AnyObject, key: "DbUrlString")
                    UserDefault.saveToUserDefault(value: dbNameArray as AnyObject, key: "DbUrlArray")
                    UserDefault.saveToUserDefault(value: currentdbtime as AnyObject, key: "DbDateTime")
                    UserDefault.saveToUserDefault(value: "https://"+(dbNameArray?[randomInt])!+".firebaseio.com/" as AnyObject, key: "DbUrlString")

                    self.getSnapShotFromFirebase()
                    self.childRemovedConfigure()
                }
            }
        }
    }
        else{
            //let dburlstring = UserDefault.userDefaultForAny(key: "DbUrlString") as? String
            let dburlarray = UserDefault.userDefaultForAny(key: "DbUrlArray") as? [String]
            let randomInt = Int.random(in: 0...(dburlarray!.count-1))
            //Drop.down("https://"+(dburlarray?[randomInt])!+".firebaseio.com/")
            print("aslkjdas = ","https://"+(dburlarray?[randomInt])!+".firebaseio.com/")
            self.ref = Database.database(url: "https://"+(dburlarray?[randomInt])!+".firebaseio.com/").reference()
            self.testing(str:"DB5")
            print("DB Url2= ", (dburlarray?[randomInt])!)
            UserDefault.saveToUserDefault(value: "https://"+(dburlarray?[randomInt])!+".firebaseio.com/" as AnyObject, key: "DbUrlString")
            self.getSnapShotFromFirebase()
            self.childRemovedConfigure()
        }
        
    }
    
    func getSnapShotFromFirebase(){
        
        /*let random = arc4random()
         if Int(random%4) == 0
         {
         self.ref = Database.database(url: FireBaseDB5).reference()
         self.testing(str:"DB5")
         }
         else if Int(random%cnt) == 1
         {
         self.ref = Database.database(url: FireBaseDB2).reference()
         self.testing(str:"DB2")
         }
         else if random%4 == 2
         {
         self.ref = Database.database(url: FireBaseDB3).reference()
         self.testing(str:"DB4")
         }
         else if random%4 == 3
         {
         self.ref = Database.database(url: FireBaseDB4).reference()
         self.testing(str:"DB5")
         }*/
        //**********Testing Only*************
        //            ref = Database.database().reference()
        
        //************************************
        self.ref.observeSingleEvent(of: DataEventType.value) { (Snapshot) in
            print(Snapshot)
            var tempSnapshot = [[String:Any]]()
            for item in Snapshot.children.allObjects as! [DataSnapshot]
            {
                var temp = (item.value as! [String:Any])
                temp["matchKey"] = item.key
                if temp["t1"] != nil{
                    let tempt1 = temp["t1"] as! [String:String]
                    if tempt1["f"] != ""{
                        tempSnapshot.append(temp)
                    }
                }
            }
            
            CLGUserService().FirebaseAllMatches(arr: tempSnapshot)
            self.ref.observe(DataEventType.childAdded) { (Snapshot) in
                print(Snapshot)
                var tempBool = true
                for item in fireBaseGlobalModelNew
                {
                    if item.matchKey == Snapshot.key
                    {
                        tempBool = false
                        break
                    }
                }
                if tempBool
                {
                    var tempDict = Snapshot.value as! [String:Any]
                    tempDict["matchKey"] = Snapshot.key
                    let tempModel = CLGUserService().GetFirebaseArrModel(dict:tempDict)
                    FireBaseHomeObservers().removeObservers(ref:self.ref)
                    //FireBaseHomeObservers().removeLiveObservers(ref:self.ref)
                    if tempModel.t1 != nil && tempModel.t1?.f != ""{
                        fireBaseGlobalModelNew.append(tempModel)
                    }
                    /*if tempModel.con?.mstus == "L"{
                     fireBaseGlobalModelLive.append(tempModel)
                     }*/
                    FireBaseHomeObservers().setHomeScreenObserver(ref:self.ref)
                    //FireBaseHomeObservers().setLiveScreenObserver(ref:self.ref)
                    NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                    NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
                    NotificationCenter.default.post(name: .refreshBadgeCount, object: nil)
                    
                }
            }
            FireBaseHomeObservers().setHomeScreenObserver(ref:self.ref)
            //FireBaseHomeObservers().setLiveScreenObserver(ref:self.ref)
            NotificationCenter.default.post(name: .refreshHomeView, object: nil)
            NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
            NotificationCenter.default.post(name: .refreshBadgeCount, object: nil)
            
        }
    }
    func childRemovedConfigure(){
        ref.observe(DataEventType.childRemoved) { (Snapshot) in
            print(Snapshot)
            if let vc = (AppHelper.appDelegate().window?.visibleViewController() as? MatchLineVC), let index = vc.index, fireBaseGlobalModel[index].matchKey == Snapshot.key
            {
                NotificationCenter.default.post(name: .moveToHome, object: nil)
                DispatchQueue.main.asyncAfter(deadline: .now()+0.6, execute: {
                    for (index,item) in fireBaseGlobalModelNew.enumerated()
                    {
                        if item.matchKey == Snapshot.key
                        {
                            FireBaseHomeObservers().removeObservers(ref:self.ref)
                            //FireBaseHomeObservers().removeLiveObservers(ref:self.ref)
                            
                            fireBaseGlobalModelNew.remove(at: index)
                            FireBaseHomeObservers().setHomeScreenObserver(ref:self.ref)
                            
                            /*for (indexx,itemm) in fireBaseGlobalModelLive.enumerated(){
                             if item.matchKey == itemm.matchKey{
                             fireBaseGlobalModelLive.remove(at: indexx)
                             }
                             }*/
                            
                            // FireBaseHomeObservers().setLiveScreenObserver(ref:self.ref)
                            
                            NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                            NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
                            NotificationCenter.default.post(name: .refreshBadgeCount, object: nil)

                            
                        }
                    }
                })
            }
            else if didAdShow == "1"
            {
                didAdShow = Snapshot.key
            }
            else
            {
                for (index,item) in fireBaseGlobalModelNew.enumerated()
                {
                    if item.matchKey == Snapshot.key
                    {
                        FireBaseHomeObservers().removeObservers(ref:self.ref)
                        //FireBaseHomeObservers().removeLiveObservers(ref:self.ref)
                        fireBaseGlobalModelNew.remove(at: index)
                        /*for (indexx,itemm) in fireBaseGlobalModelLive.enumerated(){
                         if item.matchKey == itemm.matchKey{
                         fireBaseGlobalModelLive.remove(at: indexx)
                         }
                         }*/
                        FireBaseHomeObservers().setHomeScreenObserver(ref:self.ref)
                        //FireBaseHomeObservers().setLiveScreenObserver(ref:self.ref)
                        
                        NotificationCenter.default.post(name: .refreshHomeView, object: nil)
                        NotificationCenter.default.post(name: .refreshLiveViewAgain, object: nil)
                        NotificationCenter.default.post(name: .refreshBadgeCount, object: nil)
                        
                    }
                }
            }
            print(Snapshot)
        }
    }
    func setUp()
    {
//        GADMobileAds.configure(withApplicationID: "ca-app-pub-3940256099942544~1458002511")

//                GADMobileAds.configure(withApplicationID: "ca-app-pub-2647530763019536~7921878008")// lineguru live
//        GADMobileAds.configure(withApplicationID: "ca-app-pub-4850510676564897~6300907768")// test
//        GIDSignIn.sharedInstance().clientID = "746725812668-6sqqh7cu7cshhm9bctmr12cnv3mu048b.apps.googleusercontent.com"

        if UserDefaults.standard.object(forKey: "AudioLanguage") == nil,
            UserDefaults.standard.object(forKey: "isSpeech") == nil
        {
            AppHelper.saveToUserDefaults(value: "ENG" as AnyObject, withKey: "AudioLanguage")
            AppHelper.saveToUserDefaults(value: "0" as AnyObject, withKey: "isSpeech")
        }
        UIApplication.shared.statusBarStyle = .lightContent
        Fabric.with([Crashlytics.self])
        if let version = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String)
        {
            if let saveVersion = UserDefaults.standard.value(forKey: "appVersion") as? String,
                saveVersion == version
            {
                
            }
            else
            {
                AppHelper.saveToUserDefaults(value: version as AnyObject, withKey: "appVersion")
                AppHelper.removeFromUserDefaultsWithKey(key: "accessToken" )
                AppHelper.removeFromUserDefaultsWithKey(key: "NewsDate" )
                AppHelper.removeFromUserDefaultsWithKey(key: "PlayerDate" )
                AppHelper.removeFromUserDefaultsWithKey(key: "TeamDate" )
                AppHelper.removeFromUserDefaultsWithKey(key: "RankingDate" )
                AppHelper.removeFromUserDefaultsWithKey(key: "UpcomingDate" )
                AppHelper.removeFromUserDefaultsWithKey(key: "RecentDate" )
                AppHelper.removeFromUserDefaultsWithKey(key: "SeriesDate" )
                AppHelper.removeFromUserDefaultsWithKey(key: "HomeDate" )
                AppHelper.removeFromUserDefaultsWithKey(key: "userId" )
                AppHelper.removeFromUserDefaultsWithKey(key: "isNews" )
                AppHelper.removeFromUserDefaultsWithKey(key: "isSeries" )
            }
        }
        
    }
    
}

// [START ios_10_message_handling]
@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        completionHandler([])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo : NSDictionary = response.notification.request.content.userInfo as NSDictionary
        // Print message ID.
        if let type = userInfo.value(forKey: "type")
        {
            let storyBoard = UIStoryboard(name: "Tabbar", bundle: nil)
            let mainViewController  = storyBoard.instantiateViewController(withIdentifier: "HomeTabbarVC")
            self.window?.rootViewController = mainViewController
            self.window?.makeKeyAndVisible()
            //            if type as! String == "1"
            //            {
            //                mainViewController.selectedState = ViewState.Home
            //            }
            //            if  type as! String == "2"
            //            {
            //                mainViewController.selectedState = ViewState.MatchLine
            //            }
        }
        completionHandler()
    }
}

extension AppDelegate : MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        UserDefaults.standard.setValue(fcmToken, forKey: "FCMtoken")
        if let flag = UserDefaults.getAnyDataFromUserDefault(key: "isNotificationOn") as? Bool
        {
            if flag
            {
                Messaging.messaging().subscribe(toTopic: "match")
                Messaging.messaging().subscribe(toTopic: "topic_ios") // 2
                Messaging.messaging().subscribe(toTopic: "topic_all_match_app") // 6
            }
            else
            {
//                Messaging.messaging().unsubscribe(fromTopic: "match")
                Messaging.messaging().unsubscribe(fromTopic: "topic_ios")
                Messaging.messaging().unsubscribe(fromTopic: "topic_all_match_app")
                Messaging.messaging().unsubscribe(fromTopic: "match") { (error) in
                    print(error ?? "unsubscribe Successful")
                }
            }
        }
        else
        {
            Messaging.messaging().subscribe(toTopic: "match")
            Messaging.messaging().subscribe(toTopic: "topic_ios")
            Messaging.messaging().subscribe(toTopic: "topic_all_match_app")

        }
        self.connectToFcm()

    }
    
}
extension AppDelegate:GADUnifiedNativeAdLoaderDelegate
{
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADUnifiedNativeAd) {
        nativeAds.append(nativeAd)
        print("Native add ", nativeAds.count)
    }
}
extension AppDelegate:GADAdLoaderDelegate{
    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
        print("\(adLoader) failed with error: \(error.localizedDescription)")
    }
}

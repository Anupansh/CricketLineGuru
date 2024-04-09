//
//  FacebookManager.swift
//  Extras
//
//  Created by Anmol's Macbook Air on 03/07/18.
//  Copyright © 2018 Girijesh Kumar. All rights reserved.
//

import Foundation
import FBSDKCoreKit

let params = ["fields": "id, name,first_name, last_name, email, birthday, is_verified,user_friends"]

enum Permission: String {
    case publicProfile
    case birthday
    case friends
    case photos
    case email
    
    var stringValue: String {
        switch self {
        case .publicProfile: return "public_profile"
        case .birthday: return "user_birthday"
        case .photos: return "user_photos"
        case .email: return "email"
        case .friends: return "user_friends"
        }
    }
}

class FacebookManager: NSObject {
    
    // MARK: - Singleton Instantiation
//    private static let _shared: FacebookManager = FacebookManager()
//    static var shared: FacebookManager {
//        return ._shared
//    }
//    
//    // MARK: - Private Properties
//    private weak var guestViewC: UIViewController? = nil
//    
//    // MARK: - Public Properties
//    public var fbInfoProvider: ((Bool, FBUser)->())? = nil
//    
//    // MARK: - Initializers
//    private override init() {
//        // This will resctrict the instantiation of this class.
//    }
//    
    // MARK: - Public Methods
//    func loginWithFacebook(readPermissions: [String], target: UIViewController?) {
//        guard let target = target else { return }
//        self.guestViewC = target
//        let login = LoginManager()
////        login.loginBehavior = .native
//        login.logOut()
//        login.logIn(permissions: readPermissions,
//                    from: guestViewC, handler: { (result, error) in
//                        if (error == nil) {
//                            if let loginResult: LoginManagerLoginResult = result {
//
//                                if(loginResult.isCancelled) {
//                                    //Show Cancel alert
//                                } else if(loginResult.grantedPermissions.contains("email")) {
//                                    self.getInfoAboutUser()
//                                }
//                            }
//                        } else {
//                            return
//                        }
//        })
//    }
    
    // MARK: - Private Methods
//    private func getInfoAboutUser() {
//        if AccessToken.current != nil {
//            let params = ["fields": "id, name, first_name, last_name, email, birthday, is_verified"]
//            let requestMe = GraphRequest.init(graphPath: "me", parameters: params)
//            let connection = GraphRequestConnection()
//            connection.add(requestMe, completionHandler: {
//                (request, result, error) in
//                let result = result as? [String: Any]
//                if error != nil {
//                    LoginManager().logOut()
//                    return
//                } else {
//
//                    let fbUser = FBUser()
//                    if let birthday = result?["birthday"] as? String {
//                        fbUser.birthday = birthday
//                        fbUser.age = self.retrieveAgeFrom(birthday: birthday)
//                    }
//                    if let email = result?["email"] as? String {
//                        fbUser.email = email
//                    }
//                    if let name = result?["name"] as? String {
//                        fbUser.name = name
//                    }
//                    if let fname = result?["first_name"] as? String {
//                        fbUser.fname = fname
//                    }
//                    if let lname = result?["last_name"] as? String {
//                        fbUser.lname = lname
//                    }
//                    if let userID = result?["id"] as? String{
//                        fbUser.fbId = userID
//                        self.getFriendsList(userId: userID)
//                    }
//                    if let isVerified = result?["is_verified"] as? Bool {
//                        fbUser.is_verified = isVerified
//                    }
//                    if let facebookToken = AccessToken.current?.tokenString {
//                        fbUser.fbToken = facebookToken
//                    }
//                    self.fbInfoProvider?(true, fbUser)
//                }
//            })
//            connection.start()
//        }
//    }
    
//    private func retrieveAgeFrom(birthday: String) -> Int {
//        let dateOfBrith = Date.convertFBDateString(dateString: birthday);
//        let age = dateOfBrith.userAge();
//        return age
//    }
    
//    func getFriendsList(userId: String) {
//        let request = GraphRequest(graphPath: "\(userId)/taggable_friends", parameters: params)
//        let connection = GraphRequestConnection()
//        connection.add(request, completionHandler: {
//            (request, response, error) in
//            if(error != nil){
//                print(error)
//            }
//            if(error == nil) {
//                print(response)
//            }})
//        connection.start()
//    }
}

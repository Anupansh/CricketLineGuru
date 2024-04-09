//
//  ServiceClass.swift
//  Legendary gamers
//
//  Created by Anuj Naruka on 3/14/18.
//
import Alamofire
import Foundation

class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

final class AlamofireServiceClass:NSObject

{
    let manager = Alamofire.SessionManager.default
    static let shared = AlamofireServiceClass()
    
    func serviceUrlEncoding(url:String, showLoader:Int, method:HTTPMethod, header:[String:String]? = nil, parameters:[String:Any]?, success: @escaping (Any)-> (), failure: @escaping (Error)->()) -> Void
        {
            if showLoader == 1
            {
                AppHelper.showHud(type:1)
            }
            else if showLoader == 2
            {
                AppHelper.showHud(type:2)
            }
            if currentReachabilityStatus != .notReachable
            {
                manager.session.configuration.timeoutIntervalForResource = 15
                manager.session.configuration.timeoutIntervalForRequest = 15
                manager.request(URL(string: url)!, method: method, parameters: parameters, encoding: URLEncoding.default, headers: header)
                    .validate()
                    .responseJSON {
                        (response) -> Void in
                        guard let data = response.data,
                            let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
//                                AppHelper.sharedInstance.showAlertView(title: APP_NAME, message:"Server not responding", cancelButtonTille: "OK", otherButtonTitles: "", andSelectedValuesCallBack: { (data) in
//                                    print(data)
//                                })
                                AppHelper.hideHud()
                                return
                        }
                    switch(response.result)
                    {
                        case .success(let value):
                            guard let data = response.data,
                                let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
//                                    AppHelper.sharedInstance.showAlertView(title: APP_NAME, message:"Server not responding", cancelButtonTille: "OK", otherButtonTitles: "", andSelectedValuesCallBack: { (data) in
//                                        print(data)
//                                    })
                                    return
                                        AppHelper.hideHud()
                            }
                            
                            if AppHelper.logout(dict: json!)
                            {
                                success(json)
                        }
                            if showLoader != 0
                            {
                            AppHelper.hideHud()
                        }
                        case .failure(let error):
                            Drop.down((response.result.error?.localizedDescription)!)
                            failure(error)
                    }
                    
                }
            }
            else{
                AppHelper.hideHud()
                Drop.down("Unable to connect to the internet, please try again later")
                failure(NSError(domain: "HomeService", code: 1001, userInfo: ["errorMessage" : "Unable to connect to the internet, please try again later"]))
                return
                
            }
    }
    func serviceJsonEncoding(url:String, showLoader:Int, method:HTTPMethod, header:[String:String]? = nil, parameters:[String:Any]?, success: @escaping (Any)-> (), failure: @escaping (Error)->()) -> Void
    {
        if showLoader == 1
        {
            AppHelper.showHud(type:1)
        }
        else if showLoader == 2
        {
            AppHelper.showHud(type:2)
        }
        if currentReachabilityStatus != .notReachable
        {
            manager.session.configuration.timeoutIntervalForResource = 15
            manager.session.configuration.timeoutIntervalForRequest = 15
            manager.request(URL(string: url)!, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: header)
                .validate()
                .responseJSON {
                    (response) -> Void in
                    guard let data = response.data,
                        let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
//                            AppHelper.sharedInstance.showAlertView(title: APP_NAME, message:"Server not responding", cancelButtonTille: "OK", otherButtonTitles: "", andSelectedValuesCallBack: { (data) in
//                                print(data)
//                            })
                            AppHelper.hideHud()
                            return
                    }
                    switch(response.result)
                    {
                    case .success(let value):
                        guard let data = response.data,
                            let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
//                                AppHelper.sharedInstance.showAlertView(title: APP_NAME, message:"Server not responding", cancelButtonTille: "OK", otherButtonTitles: "", andSelectedValuesCallBack: { (data) in
//                                    print(data)
//                                })
                                AppHelper.hideHud()
                                return
                        }
                        
                        if AppHelper.logout(dict: json!)
                        {
                            success(json)
                        }
                    case .failure(let error):
                        
//                        AppHelper.sharedInstance.showAlertView(title: APP_NAME, message:(response.result.error?.localizedDescription)!, cancelButtonTille: "OK", otherButtonTitles: "", andSelectedValuesCallBack: { (data) in
                            Drop.down((response.result.error?.localizedDescription)!)

//                        })
                        failure(error)
                    }
                    if showLoader != 0
                    {
                        AppHelper.hideHud()
                    }
            }
        }
        else{
//            AppHelper.sharedInstance.showAlertView(title: "Network", message:"Unable to connect to the internet, please try again later", cancelButtonTille: "OK", otherButtonTitles: "", andSelectedValuesCallBack: { (data) in
//                print(data)
//            })
            AppHelper.hideHud()
            failure(NSError(domain: "HomeService", code: 1001, userInfo: ["errorMessage" : "Unable to connect to the internet, please try again later"]))
            Drop.down("Unable to connect to the internet, please try again later")
            return
            
        }
    }
     func multipartImageService(url:String, data:[Any], withName:[String], fileName:[String], mimeType:[String], header:[String:String]? = nil, parameters:[String:Any]?, success: @escaping (Any)-> (), failure: @escaping (Error)->()) -> Void
    {
        if currentReachabilityStatus != .notReachable
        {
            AppHelper.showHud(type:1)
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                for (index,item) in data.enumerated()
                {
                    multipartFormData.append(UIImageJPEGRepresentation(item as! UIImage, 0.5)!, withName: withName[index], fileName: fileName[index], mimeType: mimeType[index])
//                    multipartFormData.append(UIImageJPEGRepresentation(item as! UIImage, 1)!, withName: withName[index])
                }
                for (key, value) in parameters!
                {
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
            }, to:URL(string: url)!, headers:header)
            { (result) in
                switch result {
                    
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (progress) in
                        //Print progress
                        print("progress")
                    })
                    upload.responseData { response in
                        // self.getBasicProfile()
                        upload.responseJSON { response in
                            print(response)
                            AppHelper.hideHud()
                    switch(response.result)
                    {
                    case .success(let value):
                        guard let data = response.data,
                            let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
//                                AppHelper.sharedInstance.showAlertView(title: APP_NAME, message:"Server not responding", cancelButtonTille: "OK", otherButtonTitles: "", andSelectedValuesCallBack: { (data) in
//                                    print(data)
//                                })
                                return
                        }
                       
                        if AppHelper.logout(dict: json!)
                        {
                        success(json)
                        }
                        
                    case .failure(let error):
//                        AppHelper.sharedInstance.showAlertView(title: APP_NAME, message:(response.result.error?.localizedDescription)!, cancelButtonTille: "OK", otherButtonTitles: "", andSelectedValuesCallBack: { (data) in
//                            print(data)
//                        })
                            AppHelper.hideHud()
                        failure(error)
                    }
                }
            }
                case .failure(let error):
//                    AppHelper.sharedInstance.showAlertView(title: APP_NAME, message:error.localizedDescription, cancelButtonTille: "OK", otherButtonTitles: "", andSelectedValuesCallBack: { (data) in
//                        print(data)
//                    })
                    AppHelper.hideHud()

        }
        }
        }
        else{
//            AppHelper.sharedInstance.showAlertView(title: "Network", message:"Unable to connect to the internet, please try again later", cancelButtonTille: "OK", otherButtonTitles: "", andSelectedValuesCallBack: { (data) in
//                print(data)
//            })
            AppHelper.hideHud()
            Drop.down("Unable to connect to the internet, please try again later")
            return
            
        }
    }
     func multipartVideoService(url:String, data:Any, withName:String, header:[String:String]? = nil, parameters:[String:Any]?, success: @escaping (Any)-> (), failure: @escaping (Error)->()) -> Void
    {
        if currentReachabilityStatus != .notReachable
        {
            
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append((data as! URL), withName: withName)
                for (key, value) in parameters! {
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
            }, to:URL(string: url)!, headers:header)
            { (result) in
                switch result {
                    
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (progress) in
                        //Print progress
                        print("progress")
                    })
                    upload.responseData { response in
                        // self.getBasicProfile()
                        upload.responseJSON { response in
                            print(response)
                            switch(response.result)
                            {
                            case .success(let value):
                                guard let data = response.data,
                                    let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
//                                        AppHelper.sharedInstance.showAlertView(title: APP_NAME, message:"Server not responding", cancelButtonTille: "OK", otherButtonTitles: "", andSelectedValuesCallBack: { (data) in
//                                            print(data)
//                                        })
                                        return
                                }
                                
                                if AppHelper.logout(dict: json!)
                                {
                                    success(json)
                                }
                            case .failure(let error):
//                                AppHelper.sharedInstance.showAlertView(title: APP_NAME, message:(response.result.error?.localizedDescription)!, cancelButtonTille: "OK", otherButtonTitles: "", andSelectedValuesCallBack: { (data) in
//                                    print(data)
//                                })
                                failure(error)
                            }
                        }
                    }
                case .failure(let error):
//                    AppHelper.sharedInstance.showAlertView(title: APP_NAME, message:error.localizedDescription, cancelButtonTille: "OK", otherButtonTitles: "", andSelectedValuesCallBack: { (data) in
//                        print(data)
//                    })
                    failure(error)
                    
                }
            }
        }
        else{
            Drop.down("Unable to connect to the internet, please try again later")

            return
            
        }
    }



}

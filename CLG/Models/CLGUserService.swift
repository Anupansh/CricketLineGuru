//
//  UserService.swift
//  WikiWalks
//
//  Created by Girijesh Kumar on 18/12/17.
//  Copyright © 2017 Girijesh Kumar. All rights reserved.
//

import Foundation
import PromiseKit
import ObjectMapper
import XCGLogger
import Alamofire

class CLGUserService
{
    func HomeService(url:String, method:HTTPMethod, showLoader:Int, header:[String:String]? = nil, parameters:[String:Any]?) -> Promise<HomeApiResponseV3>
    {
        return Promise { fullfill, reject in
            
           AlamofireServiceClass.shared.serviceUrlEncoding(url: url, showLoader: showLoader, method: method, header:header, parameters: parameters, success: { (data) in
                if let dict = data as? [String:Any],
                    let notiModel = Mapper<HomeApiResponseV3>().map(JSON: dict)
                {
//                    self._log.debug("response :\(jsonString)")
                    fullfill(notiModel)
                }
                else
                {
                    reject(NSError(domain: "ProfileViewService",code:1000,userInfo: ["errorMessage":"Request time out"]))
                }
            }, failure: { (error) in
                reject(NSError(domain: "ProfileViewService",code:1001,userInfo: ["errorMessage":"No internet"]))
            })
        }
    }
    func newsServiceV3(url:String, method:HTTPMethod, showLoader:Int, header:[String:String]? = nil, parameters:[String:Any]?) -> Promise<HomeApiResponseV3>
    {
        return Promise { fullfill, reject in
            
            AlamofireServiceClass.shared.serviceUrlEncoding(url: url, showLoader: showLoader, method: method, header:header, parameters: parameters, success: { (data) in
                if let dict = data as? [String:Any],
                    let notiModel = Mapper<HomeApiResponseV3>().map(JSON: dict)
                {
                    //                    self._log.debug("response :\(jsonString)")
                    fullfill(notiModel)
                }
                else
                {
                    reject(NSError(domain: "ProfileViewService",code:1000,userInfo: ["errorMessage":"Request time out"]))
                }
            }, failure: { (error) in
                reject(NSError(domain: "ProfileViewService",code:1001,userInfo: ["errorMessage":"No internet"]))
                print(error)
            })
        }
    }
    
    func newsService(url:String, method:HTTPMethod, showLoader:Int, header:[String:String]? = nil, parameters:[String:Any]?) -> Promise<HomeApiResponse>
    {
        return Promise { fullfill, reject in
            
            AlamofireServiceClass.shared.serviceJsonEncoding(url: url, showLoader: showLoader, method: method, header:header, parameters: parameters, success: { (data) in
                if let dict = data as? [String:Any],
                    let notiModel = Mapper<HomeApiResponse>().map(JSON: dict)
                {
                    //                    self._log.debug("response :\(jsonString)")
                    fullfill(notiModel)
                }
                else
                {
                    reject(NSError(domain: "ProfileViewService",code:1000,userInfo: ["errorMessage":"Request time out"]))
                }
            }, failure: { (error) in
                reject(NSError(domain: "ProfileViewService",code:1001,userInfo: ["errorMessage":"No internet"]))
                print(error)
            })
        }
    }
    func newsServiceeeV3(url:String, method:HTTPMethod, showLoader:Int, header:[String:String]? = nil, parameters:[String:Any]?) -> Promise<HomeApiResponse>
    {
        return Promise { fullfill, reject in
            
            AlamofireServiceClass.shared.serviceUrlEncoding(url: url, showLoader: showLoader, method: method, header:header, parameters: parameters, success: { (data) in
                if let dict = data as? [String:Any],
                    let notiModel = Mapper<HomeApiResponse>().map(JSON: dict)
                {
                    //                    self._log.debug("response :\(jsonString)")
                    fullfill(notiModel)
                }
                else
                {
                    reject(NSError(domain: "ProfileViewService",code:1000,userInfo: ["errorMessage":"Request time out"]))
                }
            }, failure: { (error) in
                reject(NSError(domain: "ProfileViewService",code:1001,userInfo: ["errorMessage":"No internet"]))
                print(error)
            })
        }
    }
    func seriesService(url:String, method:HTTPMethod, showLoader:Int, header:[String:String]? = nil, parameters:[String:Any]?) -> Promise<CLGSeriesApiResponse>
    {
        return Promise { fullfill, reject in
            
            AlamofireServiceClass.shared.serviceJsonEncoding(url: url, showLoader: showLoader, method: method, header:header, parameters: parameters, success: { (data) in
                if let dict = data as? [String:Any],
                    let notiModel = Mapper<CLGSeriesApiResponse>().map(JSON: dict)
                {
                    //                    self._log.debug("response :\(jsonString)")
                    fullfill(notiModel)
                }
                else
                {
                    reject(NSError(domain: "ProfileViewService",code:1000,userInfo: ["errorMessage":"Request time out"]))
                }
            }, failure: { (error) in
                reject(NSError(domain: "ProfileViewService",code:1001,userInfo: ["errorMessage":"No internet"]))
                print(error)
            })
        }
    }
    
    func seriesServiceee(url:String, method:HTTPMethod, showLoader:Int, header:[String:String]? = nil, parameters:[String:Any]?) -> Promise<CLGSeriesApiResponse>
        
    {
        return Promise { fullfill, reject in
            
            AlamofireServiceClass.shared.serviceUrlEncoding(url: url, showLoader: showLoader, method: method, header:header, parameters: parameters, success: { (data) in
                if let dict = data as? [String:Any],
                    let notiModel = Mapper<CLGSeriesApiResponse>().map(JSON: dict)
                {
                    //                    self._log.debug("response :\(jsonString)")
                    fullfill(notiModel)
                }
                else
                {
                    reject(NSError(domain: "ProfileViewService",code:1000,userInfo: ["errorMessage":"Request time out"]))
                }
            }, failure: { (error) in
                reject(NSError(domain: "ProfileViewService",code:1001,userInfo: ["errorMessage":"No internet"]))
            })
        }
    }
    
    
    func playerDetailService(url:String, method:HTTPMethod, showLoader:Int, header:[String:String]? = nil, parameters:[String:Any]?) -> Promise<CLGPlayerDetailApiResponse>
    {
        return Promise { fullfill, reject in
            
            AlamofireServiceClass.shared.serviceJsonEncoding(url: url, showLoader: showLoader, method: method, header:header, parameters: parameters, success: { (data) in
                if let dict = data as? [String:Any],
                    let notiModel = Mapper<CLGPlayerDetailApiResponse>().map(JSON: dict)
                {
                    fullfill(notiModel)
                }
                else
                {
                    reject(NSError(domain: "ProfileViewService",code:1000,userInfo: ["errorMessage":"Request time out"]))
                }
            }, failure: { (error) in
                reject(NSError(domain: "ProfileViewService",code:1001,userInfo: ["errorMessage":"No internet"]))
                print(error)
            })
        }
    }
    func playerDetailServiceee(url:String, method:HTTPMethod, showLoader:Int, header:[String:String]? = nil, parameters:[String:Any]?) -> Promise<CLGPlayerDetailApiResponse>
    {
        return Promise { fullfill, reject in
            
            AlamofireServiceClass.shared.serviceUrlEncoding(url: url, showLoader: showLoader, method: method, header:header, parameters: parameters, success: { (data) in
                if let dict = data as? [String:Any],
                    let notiModel = Mapper<CLGPlayerDetailApiResponse>().map(JSON: dict)
                {
                    //                    self._log.debug("response :\(jsonString)")
                    fullfill(notiModel)
                }
                else
                {
                    reject(NSError(domain: "ProfileViewService",code:1000,userInfo: ["errorMessage":"Request time out"]))
                }
            }, failure: { (error) in
                reject(NSError(domain: "ProfileViewService",code:1001,userInfo: ["errorMessage":"No internet"]))
            })
        }
    }
    func scorecardService(url:String, method:HTTPMethod, showLoader:Int, header:[String:String]? = nil, parameters:[String:Any]?) -> Promise<CLGScorcardApi>
    {
        return Promise { fullfill, reject in
            
            AlamofireServiceClass.shared.serviceJsonEncoding(url: url, showLoader: showLoader, method: method, header:header, parameters: parameters, success: { (data) in
                if let dict = data as? [String:Any],
                    let notiModel = Mapper<CLGScorcardApi>().map(JSON: dict)
                {
                    fullfill(notiModel)
                }
                else
                {
                    reject(NSError(domain: "ProfileViewService",code:1000,userInfo: ["errorMessage":"Request time out"]))
                }
            }, failure: { (error) in
                print(error)
            })
        }
    }
    
    func scorecardServiceee(url:String, method:HTTPMethod, showLoader:Int, header:[String:String]? = nil, parameters:[String:Any]?) -> Promise<CLGScorcardApi>
    {
        return Promise { fullfill, reject in
            
            AlamofireServiceClass.shared.serviceUrlEncoding(url: url, showLoader: showLoader, method: method, header:header, parameters: parameters, success: { (data) in
                if let dict = data as? [String:Any],
                    let notiModel = Mapper<CLGScorcardApi>().map(JSON: dict)
                {
                    fullfill(notiModel)
                }
                else
                {
                    reject(NSError(domain: "ProfileViewService",code:1000,userInfo: ["errorMessage":"Request time out"]))
                }
            }, failure: { (error) in
                print(error)
            })
        }

    }
    
    func commentryService(url:String, method:HTTPMethod, showLoader:Int, header:[String:String]? = nil, parameters:[String:Any]?) -> Promise<CLGCommentryResponseData>
    {
        return Promise { fullfill, reject in
            
            AlamofireServiceClass.shared.serviceJsonEncoding(url: url, showLoader: showLoader, method: method, header:header, parameters: parameters, success: { (data) in
                if let dict = data as? [String:Any],
                    let notiModel = Mapper<CLGCommentryResponseData>().map(JSON: dict)
                {
                    fullfill(notiModel)
                }
                else
                {
                    reject(NSError(domain: "ProfileViewService",code:1000,userInfo: ["errorMessage":"Request time out"]))
                }
            }, failure: { (error) in
                print(error)
            })
        }
    }
    func commentryServiceee(url:String, method:HTTPMethod, showLoader:Int, header:[String:String]? = nil, parameters:[String:Any]?) -> Promise<CLGCommentryResponseData>
    {
        return Promise { fullfill, reject in
            
            AlamofireServiceClass.shared.serviceUrlEncoding(url: url, showLoader: showLoader, method: method, header:header, parameters: parameters, success: { (data) in
                if let dict = data as? [String:Any],
                    let notiModel = Mapper<CLGCommentryResponseData>().map(JSON: dict)
                {
                    fullfill(notiModel)
                }
                else
                {
                    reject(NSError(domain: "ProfileViewService",code:1000,userInfo: ["errorMessage":"Request time out"]))
                }
            }, failure: { (error) in
                print(error)
            })
        }
    }
    func FirebaseAllMatches(arr:[[String:Any]])
    {
         let listModel = Mapper<CLGFirbaseArrModel>().mapArray(JSONArray: arr)
        
            fireBaseGlobalModelNew = listModel
            //fireBaseGlobalModelLive.removeAll()
        /*for dict in fireBaseGlobalModelNew{
            if (dict.con?.mstus == "L") && (!(dict.t1?.f?.contains("Testing"))! && !(dict.t2?.f?.contains("Testing"))!){
                fireBaseGlobalModelLive.append(dict)
            }
        }*/
        print(fireBaseGlobalModelNew)
    }
    func GetChatModel (dict:[String:Any]) -> CLGChatArrModel
    {
        return Mapper<CLGChatArrModel>().map(JSON: dict)!
    }
    func GetChatArrModel (arr:[[String:Any]]) -> [CLGChatArrModel]
    {
        return Mapper<CLGChatArrModel>().mapArray(JSONArray: arr)
    }
    func GetFirebaseArrModel (dict:[String:Any]) -> CLGFirbaseArrModel
    {
        return Mapper<CLGFirbaseArrModel>().map(JSON: dict)!
    }
    func GetConModel (dict:[String:Any]) -> CLGFirbaseConfigModel
    {
        return Mapper<CLGFirbaseConfigModel>().map(JSON: dict)!
    }
    func GetInningModel (dict:[String:Any]) -> CLGFirbaseInningModel
    {
        return Mapper<CLGFirbaseInningModel>().map(JSON: dict)!
    }
    func GetMarketModel (dict:[String:Any]) -> CLGFirbaseMarkrtModel
    {
        return Mapper<CLGFirbaseMarkrtModel>().map(JSON: dict)!
    }
    func GetTeamModel (dict:[String:Any]) -> CLGFirbaseTeamModel
    {
        return Mapper<CLGFirbaseTeamModel>().map(JSON: dict)!
    }
    func GetCurrentStatusModel (dict:[String:Any]) -> CLGFirbaseCurrentStatusModel
    {
        return Mapper<CLGFirbaseCurrentStatusModel>().map(JSON: dict)!
    }
    func GetPlayerStatusModel (dict:[String:Any]) -> CLGFirbasePlayerStatusModel
    {
        return Mapper<CLGFirbasePlayerStatusModel>().map(JSON: dict)!
    }
    func GetPartnershipModel (dict:[String:Any]) -> CLGFirbasePartnership
    {
        return Mapper<CLGFirbasePartnership>().map(JSON: dict)!
    }
    func GetMatchInfoModel (dict:[String:Any]) -> CLGMatchInfo
    {
        return Mapper<CLGMatchInfo>().map(JSON: dict)!
    }
    func GetLambiModel (dict:[String:Any]) -> CLGFirbaseTestLambi
    {
        return Mapper<CLGFirbaseTestLambi>().map(JSON: dict)!
    }
    
//    func ProfileEditService(url:String, method:HTTPMethod, data:[Any]? = nil, fileName:[String]? = nil, withName:[String]? = nil, mimeType:[String],isMultipart:Bool, header:[String:String]? = nil, parameters:[String:Any]?) -> Promise<StoryProfileApiResponse>
//    {
//        return Promise { fullfill, reject in
//            if isMultipart
//            {
//                ServiceClass.shared.multipartImageService(url: url, data: data!, withName: withName!, fileName: fileName!, mimeType: mimeType, header: header, parameters: parameters, success: { (data) in
//                if let dict = data as? [String:Any],
//                    let notiModel = Mapper<StoryProfileApiResponse>().map(JSON: dict)
//                {
//                    //                    self._log.debug("response :\(jsonString)")
//                    fullfill(notiModel)
//                }
//                else
//                {
//                    reject(NSError(domain: "ProfileViewService",code:1000,userInfo: ["errorMessage":"Request time out"]))
//                }
//            }, failure: { (error) in
//                print(error)
//            })
//            }
//            else
//            {
//                ServiceClass.shared.serviceJsonEncoding(url: url, showLoader: true, method: method, header:header, parameters: parameters, success: { (data) in
//                if let dict = data as? [String:Any],
//                    let notiModel = Mapper<StoryProfileApiResponse>().map(JSON: dict)
//                {
//                    //                    self._log.debug("response :\(jsonString)")
//                    fullfill(notiModel)
//                }
//                else
//                {
//                    reject(NSError(domain: "ProfileViewService",code:1000,userInfo: ["errorMessage":"Request time out"]))
//                }
//            }, failure: { (error) in
//                print(error)
//            })
//            }
//        }
//    }
//    func FollowFollowingListService(url:String, method:HTTPMethod, header:[String:String]? = nil, parameters:[String:Any]?) -> Promise<followFollowersApiResponse>
//    {
//        return Promise { fullfill, reject in
//
//            ServiceClass.shared.serviceUrlEncoding(url: url, showLoader: true, method: method, header:header, parameters: parameters, success: { (data) in
//                if let dict = data as? [String:Any],
//                    let notiModel = Mapper<followFollowersApiResponse>().map(JSON: dict)
//                {
//                    //                    self._log.debug("response :\(jsonString)")
//                    fullfill(notiModel)
//                }
//                else
//                {
//                    reject(NSError(domain: "ProfileViewService",code:1000,userInfo: ["errorMessage":"Request time out"]))
//                }
//            }, failure: { (error) in
//                print(error)
//            })
//        }
//    }
//    func GetFeedService(url:String, method:HTTPMethod, showLoader:Bool, header:[String:String]? = nil, parameters:[String:Any]?) -> Promise<StoryFeedResult>
//    {
//        return Promise { fullfill, reject in
//
//            ServiceClass.shared.serviceUrlEncoding(url: url, showLoader: showLoader, method: method, header:header, parameters: parameters, success: { (data) in
//                print(data)
//                if let dict = data as? [String:Any],
//                    let notiModel = Mapper<StoryFeedResult>().map(JSON: dict)
//                {
//                    //                    self._log.debug("response :\(jsonString)")
//                    fullfill(notiModel)
//                }
//                else
//                {
//                    reject(NSError(domain: "ProfileViewService",code:1000,userInfo: ["errorMessage":"Request time out"]))
//                }
//            }, failure: { (error) in
//                print(error)
//            })
//        }
//    }
}


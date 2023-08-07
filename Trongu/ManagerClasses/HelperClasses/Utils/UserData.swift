//
//  UserData.swift
//  NiftyExpert
//
//  Created by MAC on 17/04/19.
//  Copyright © 2019 MAC. All rights reserved.
//

import UIKit


class ImageEntity: Codable {
    var statusCode: Int?
    var message: String?
    var data: ResponseData?
}

class ResponseData: Codable {
//    var original:String?
//    var thumbnail:String?
//    var type:String?
    var s3Url: String?
    
}

class ImageModel: NSObject {
//    
//    class func uploadDocument(data:Data, key: API.DataKey, complitionHandler: @escaping(_ image: ResponseData) -> ()) {
//        
//        let params:JSON? = ["access_token": UserDefaultsCustom.getAccessToken()]
//        
//        ActivityIndicator.sharedInstance.showActivityIndicator()
//        ApiHandler.uploadDocument(apiName: API.Name.fileUpload, dataArray: [data], dataKey: key.rawValue, params: params) { (isSucceeded, response, data) in
//            DispatchQueue.main.async {
//                print("responose is ****** \(response)")
//                ActivityIndicator.sharedInstance.hideActivityIndicator()
//                if isSucceeded == true {
//                    guard let data = data else { return }
//                    do {
//                        let decoder = JSONDecoder()
//                        let jsonResponse = try decoder.decode(ImageEntity.self, from: data)
//                        guard let data = jsonResponse.data else {return}
//                        complitionHandler(data)
//                    } catch let err {
//                        print(err)
//                    }
//                } else {
//                    if let message = response["message"] as? String {
//                        Singleton.sharedInstance.showErrorMessage(error: message, isError: .error)
//                    }
//                }
//            }
//        }
//    }
    
}

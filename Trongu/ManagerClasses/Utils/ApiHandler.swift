//
//  ApiHandler.swift
//  CullintonsCustomer
//
//  Created by Nitin Kumar on 03/04/18.
//  Copyright © 2018 Nitin Kumar. All rights reserved.
//

import UIKit

class ApiHandler {

    static public func call(apiName:String, params: [String : Any]?, httpMethod:API.HttpMethod, receivedResponse: @escaping (_ succeeded:Bool, _ response:[String:Any], _ data:Data?) -> ()) {
        if IJReachability.isConnectedToNetwork() == true {
            HttpManager.requestToServer(apiName, params: params!, httpMethod: httpMethod, isZipped: false, receivedResponse: { (isSucceeded, response, data) in
                DispatchQueue.main.async {
                    print("\n\nAPI name: \(apiName)\n apiHandler responce:- \(response)")
                    print("params:-     \(params)")
                    if(isSucceeded) {
                        if let status = response["status"] as? Int {
                            switch (status) {
                            case 200:
                                receivedResponse(true, response, data)
                            case API.statusCodes.UNAUTHORIZED_ACCESS:
                                Singleton.shared.showErrorMessage(error: AlertMessage.INVALID_ACCESS_TOKEN, isError: .error)
                                Singleton.shared.logoutFromDevice()
                                receivedResponse(false, [:], nil)
                            case API.statusCodes.INVALID_ACCESS_TOKEN:
                                if let message = response["message"] as? String {
                                    if message == "invalid access token" {
                                        Singleton.shared.showErrorMessage(error: AlertMessage.INVALID_ACCESS_TOKEN, isError: .error)
                                        Singleton.shared.logoutFromDevice()
                                        receivedResponse(false, [:], nil)
                                    } else {
                                        receivedResponse(false, ["statusCode": status, "message": message], nil)
                                    }
                                } else {
                                    receivedResponse(false, ["statusCode": status, "message": AlertMessage.SERVER_NOT_RESPONDING], nil)
                                    Singleton.shared.showErrorMessage(error: AlertMessage.INVALID_ACCESS_TOKEN, isError: .error)
                                    Singleton.shared.logoutFromDevice()
                                    receivedResponse(false, [:], nil)
                                }
                            default:
                                if response["data"] != nil, let message = response["message"] as? String {
                                    receivedResponse(true, ["statusCode": 1, "message": message, "data": []], nil)
                                } else
                                if let message = response["message"] as? String {
                                    receivedResponse(false, ["statusCode": status, "message": message], nil)
                                  
                                    Singleton.shared.logoutFromDevice()
                                    
                                } else {
                                    receivedResponse(false, ["statusCode": status, "message": AlertMessage.SERVER_NOT_RESPONDING], nil)
                                }
                            }
                        } else {
                            receivedResponse(false, ["statusCode":0,"message":AlertMessage.SERVER_NOT_RESPONDING], nil)
                        }
                    } else {
                        receivedResponse(false, ["statusCode":0, "message":AlertMessage.SERVER_NOT_RESPONDING],nil)
                    }
                }
            })
        } else {
            receivedResponse(false, ["statusCode": 0, "message":AlertMessage.NO_INTERNET_CONNECTION], nil)
        }
    }
    
    static public func uploadImage(apiName:String, imgs_deleted:[String], params: [String : Any]?, isImage:Bool = true, receivedResponse: @escaping (_ succeeded:Bool, _ response:[String:Any], _ data:Data?) -> ()) {
        if IJReachability.isConnectedToNetwork() == true {
            HttpManager.uploadingMultipleTask(apiName, params: params ?? [:], imgs_deleted: imgs_deleted) { (isSucceeded, response, data) in
                DispatchQueue.main.async {
                    print(response)
                    if(isSucceeded){
                        if let status = response["status"] as? Int {
                            switch(status) {
                            case API.statusCodes.UNAUTHORIZED_ACCESS:
                                Singleton.shared.showErrorMessage(error: AlertMessage.INVALID_ACCESS_TOKEN, isError: .error)
                                Singleton.shared.logoutFromDevice()
                                receivedResponse(false, [:], nil)
                            case 1:
                                receivedResponse(true, response, data)
                            case API.statusCodes.INVALID_ACCESS_TOKEN:
                                Singleton.shared.showErrorMessage(error: AlertMessage.INVALID_ACCESS_TOKEN, isError: .error)
                                Singleton.shared.logoutFromDevice()
                                receivedResponse(false, [:], nil)
                            default:
                                if let message = response["message"] as? String {
                                    receivedResponse(false, ["statusCode":status, "message":message], nil)
                                } else {
                                    receivedResponse(false, ["statusCode":status, "message":AlertMessage.SERVER_NOT_RESPONDING], nil)
                                }
                            }
                        } else {
                            receivedResponse(false, ["statusCode":0,"message":AlertMessage.SERVER_NOT_RESPONDING], nil)
                        }
                    } else {
                        receivedResponse(false, ["statusCode":0, "message":AlertMessage.SERVER_NOT_RESPONDING],nil)
                    }
                }
            }
        } else {
            receivedResponse(false, ["statusCode":0, "message":AlertMessage.NO_INTERNET_CONNECTION], nil)
        }
    }
   
    
    static public func callWithMultipartForm(apiName:String, params: [String:Any], receivedResponse: @escaping (_ succeeded:Bool, _ response:[String:Any], _ data:Data?) -> ()) {
        if IJReachability.isConnectedToNetwork() == true {
            HttpManager.uploadingMultipleTask(apiName, params: params) { (isSucceeded, response, data) in
               
                DispatchQueue.main.async {
                    print(response)
                    if(isSucceeded){
                        if let status = response["status"] as? Int {
                            switch(status) {
                            case API.statusCodes.EMAIL_NOT_Verified:
                                Singleton.shared.showErrorMessage(error: AlertMessage.Email_Veryfication, isError: .error)
                                ActivityIndicator.shared.hideActivityIndicator()
                            case API.statusCodes.UNAUTHORIZED_ACCESS:
                                Singleton.shared.showErrorMessage(error: AlertMessage.INVALID_ACCESS_TOKEN, isError: .error)
                                Singleton.shared.logoutFromDevice()
                                receivedResponse(false, [:], nil)
                            case 200:
                                receivedResponse(true, response, data)
//                                Singleton.shared.showErrorMessage(error: "Sign Up Successfully", isError: .success)
                            case API.statusCodes.INVALID_ACCESS_TOKEN :
                                Singleton.shared.showErrorMessage(error: AlertMessage.INVALID_ACCESS_TOKEN, isError: .error)
                                Singleton.shared.logoutFromDevice()
                                receivedResponse(false, [:], nil)
                            default:
                                if let code = response["code"] as? Int, code == API.statusCodes.UNAUTHORIZED_ACCESS {
                                    
                                    Singleton.shared.showErrorMessage(error: AlertMessage.INVALID_ACCESS_TOKEN, isError: .error)
                                    Singleton.shared.logoutFromDevice()
                                    receivedResponse(false, [:], nil)
                                } else {
                                    if let message = response["message"] as? String {
                                        receivedResponse(false, ["statusCode":status, "message":message], nil)
                                    } else {
                                        receivedResponse(false, ["statusCode":status, "message":AlertMessage.SERVER_NOT_RESPONDING], nil)
                                    }
                                }
                            }
                        } else {
                            receivedResponse(false, ["statusCode":0,"message":AlertMessage.SERVER_NOT_RESPONDING], nil)
                        }
                    } else {
                        receivedResponse(false, ["statusCode":0, "message":AlertMessage.SERVER_NOT_RESPONDING],nil)
                    }
                }
            }
        } else {
            receivedResponse(false, ["statusCode":0, "message":AlertMessage.NO_INTERNET_CONNECTION], nil)
        }
        
    }
    
    static public func uploadDocument(apiName:String, dataArray:[Data]?, dataKey:String, params: [String : Any]?, receivedResponse: @escaping (_ succeeded:Bool, _ response:[String:Any], _ data:Data?) -> ()) {
        if IJReachability.isConnectedToNetwork() == true {
            
            HttpManager.uploadingDocuments(apiName, params: params ?? [:], dataArray: dataArray, dataKey: dataKey) { (isSucceeded, response, data) in
                DispatchQueue.main.async {
                    print(response)
                    if(isSucceeded){
                        if let status = response["code"] as? Int {
                            switch(status) {
                            case API.statusCodes.SHOW_DATA:
                                receivedResponse(true, response, data)
                            
                            case API.statusCodes.UNAUTHORIZED_ACCESS:
                                Singleton.shared.showErrorMessage(error: AlertMessage.INVALID_ACCESS_TOKEN, isError: .error)
                                Singleton.shared.logoutFromDevice()
                                receivedResponse(false, [:], nil)
                            
                            case API.statusCodes.INVALID_ACCESS_TOKEN:
                                
                                Singleton.shared.showErrorMessage(error: AlertMessage.INVALID_ACCESS_TOKEN, isError: .error)
                                Singleton.shared.logoutFromDevice()
                                receivedResponse(false, [:], nil)
                            default:
                                if let message = response["message"] as? String {
                                    receivedResponse(false, ["statusCode":status, "message":message], nil)
                                } else {
                                    receivedResponse(false, ["statusCode":status, "message":AlertMessage.SERVER_NOT_RESPONDING], nil)
                                }
                            }
                        } else {
                            receivedResponse(false, ["statusCode":0,"message":AlertMessage.SERVER_NOT_RESPONDING], nil)
                        }
                    } else {
                        receivedResponse(false, ["statusCode":0, "message":AlertMessage.SERVER_NOT_RESPONDING],nil)
                    }
                }
            }
        } else {
            receivedResponse(false, ["statusCode":0, "message":AlertMessage.NO_INTERNET_CONNECTION], nil)
        }
        
    }
}

extension ApiHandler{
    static public func updateProfile(apiName:String, params: [String:Any], profilePhoto: PickerData?, receivedResponse: @escaping ( _ succeeded:Bool,  _ response:[String:Any], _ data:Data?) -> ()) {
        if IJReachability.isConnectedToNetwork() == true {
            HttpManager.uploadingMultipleTasks(url: apiName, params: params, profilePhoto: profilePhoto) { (isSucceeded, response, data) in
                DispatchQueue.main.async {
                    print(response)
                    if(isSucceeded){
                        if let status = response["status"] as? Int {
                            switch(status) {
                            case 200:
                                receivedResponse(true, response, data)
                            case API.statusCodes.INVALID_ACCESS_TOKEN:
                                Singleton.shared.showErrorMessage(error: AlertMessage.INVALID_ACCESS_TOKEN, isError: .error)
                                receivedResponse(false, [:], nil)
                            default:
                                if let message = response["message"] as? String {
                                    receivedResponse(false, ["statusCode":status, "message":message], nil)
                                } else {
                                    receivedResponse(false, ["statusCode":status, "message":AlertMessage.SERVER_NOT_RESPONDING], nil)
                                }
                            }
                        } else {
                            receivedResponse(false, ["statusCode":0,"message":AlertMessage.SERVER_NOT_RESPONDING], nil)
                        }
                    } else {
                        receivedResponse(false, ["statusCode":0, "message":AlertMessage.SERVER_NOT_RESPONDING],nil)
                    }
                }
            }
        } else {
            receivedResponse(false, ["statusCode":0, "message":AlertMessage.NO_INTERNET_CONNECTION], nil)
        }
    }
}
extension ApiHandler{
    static public func uploadPost(key:String,apiName:String, dataArray: [PickerData]?, imgs_deleted:[String], imageKey:[String], params: [String : Any]?, isImage:Bool = true, receivedResponse: @escaping (_ succeeded:Bool, _ response:[String:Any], _ data:Data?) -> ()) {
        if IJReachability.isConnectedToNetwork() == true {
            HttpManager.uploadingMultipleTask(apiName, key: key, params: params!, imgs_deleted: imgs_deleted, isImage: isImage, dataArray:dataArray,  imageKey: imageKey) { (isSucceeded, response, data) in
                DispatchQueue.main.async {
                    print(response)
                    if(isSucceeded){
                        if let status = response["status"] as? Int {
                            switch(status) {
                            case 200:
                                receivedResponse(true, response, data)
                            case API.statusCodes.INVALID_ACCESS_TOKEN:
                                Singleton.shared.showErrorMessage(error: AlertMessage.INVALID_ACCESS_TOKEN, isError: .error)
                                Singleton.shared.gotoLogin()
                                receivedResponse(false, [:], nil)
                            default:
                                if let message = response["message"] as? String {
                                    receivedResponse(false, ["statusCode":status, "message":message], nil)
                                } else {
                                    receivedResponse(false, ["statusCode":status, "message":AlertMessage.SERVER_NOT_RESPONDING], nil)
                                }
                            }
                        } else {
                            receivedResponse(false, ["statusCode":0,"message":AlertMessage.SERVER_NOT_RESPONDING], nil)
                        }
                    } else {
                        receivedResponse(false, ["statusCode":0, "message":AlertMessage.SERVER_NOT_RESPONDING],nil)
                    }
                }
            }
        } else {
            receivedResponse(false, ["statusCode":0, "message":AlertMessage.NO_INTERNET_CONNECTION], nil)
        }
    }
    
    
    static public func uploadVideo(key:String,apiName:String, dataArray: [PickerData]?, imgs_deleted:[String], imageKey:[String], params: [String : Any]?, isImage:Bool = true, receivedResponse: @escaping (_ succeeded:Bool, _ response:[String:Any], _ data:Data?) -> ()) {
        if IJReachability.isConnectedToNetwork() == true {
            HttpManager.uploadingMultipleTaskVideo(apiName, key: key, params: params!, imgs_deleted: imgs_deleted, isImage: isImage, dataArray:dataArray,  imageKey: imageKey) { (isSucceeded, response, data) in
                DispatchQueue.main.async {
                    print(response)
                    if(isSucceeded){
                        if let status = response["status"] as? Int {
                            switch(status) {
                            case 200:
                                receivedResponse(true, response, data)
                            case API.statusCodes.INVALID_ACCESS_TOKEN:
                                Singleton.shared.showErrorMessage(error: AlertMessage.INVALID_ACCESS_TOKEN, isError: .error)
                                Singleton.shared.gotoLogin()
                                receivedResponse(false, [:], nil)
                            default:
                                if let message = response["message"] as? String {
                                    receivedResponse(false, ["statusCode":status, "message":message], nil)
                                } else {
                                    receivedResponse(false, ["statusCode":status, "message":AlertMessage.SERVER_NOT_RESPONDING], nil)
                                }
                            }
                        } else {
                            receivedResponse(false, ["statusCode":0,"message":AlertMessage.SERVER_NOT_RESPONDING], nil)
                        }
                    } else {
                        receivedResponse(false, ["statusCode":0, "message":AlertMessage.SERVER_NOT_RESPONDING],nil)
                    }
                }
            }
        } else {
            receivedResponse(false, ["statusCode":0, "message":AlertMessage.NO_INTERNET_CONNECTION], nil)
        }
    }
    
    
}

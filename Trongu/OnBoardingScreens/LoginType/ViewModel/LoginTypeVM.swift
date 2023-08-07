//
//  LoginTypeVM.swift
//  Trongu
//
//  Created by dr mac on 26/07/23.
//

import Foundation

protocol LoginTypeVMObserver: NSObjectProtocol {
    func observeLoginTypeSucessfull()
    func oberseveAppleTypeSuccessfull()
    func oberseveFBTypeSuccessfull()

}
class LoginTypeVM : NSObject{
    var observer: LoginTypeVMObserver?
    init(observer: LoginTypeVMObserver?) {
        self.observer = observer
    }
    
    func apiGoogleStatus(email:String,googleID:String){
        var params = JSON()
        params["email"] = email
        params["device_token"] = UserDefaultsCustom.deviceToken
        params["device_type"] = "2"
        params["google_id"] = googleID
        params["login_type"] = "0"
        ActivityIndicator.shared.showActivityIndicator()
        ApiHandler.callWithMultipartForm(apiName: API.Name.googleLogin, params: params) {[weak self] succeeded, response, data in
            DispatchQueue.main.async {
                ActivityIndicator.shared.hideActivityIndicator()
                if let self = self{
                    if succeeded == true, let data{
                        let decoder = JSONDecoder()
                        if let message = response["message"] as? String {
                            self.showMessage(message: message, isError: .success)
                            do {
                                let decoded = try decoder.decode(UserModel.self, from: data)
                                if let userData = decoded.data {
                                    UserDefaultsCustom.saveUserData(userData: userData)
                                    UserDefaultsCustom.userId = userData.id
                                    UserDefaultsCustom.authToken = userData.access_token
                                    DefaultManager.shared.isNew = "yes"
                                    if let message = response["message"] as? String {
                                        self.showMessage(message: message, isError: .success)
                                    }
                                    self.observer?.observeLoginTypeSucessfull()
                                }
                            } catch {
                                print("error",error)
                            }
                        }
                    }else{
                        if let message = response["message"] as? String {
                            self.showMessage(message: message, isError: .error)
                        }
                    }
                }
            }
        }
        
    }
    
    func apiAppleStatus(email:String,appleId:String){
        var params = JSON()
        params["email"] = email
        params["device_token"] = UserDefaultsCustom.deviceToken
        params["device_type"] = "2"
        params["apple_id"] = appleId
        params["login_type"] = "0"
        print(params,"Parrehjwerhk")
        ActivityIndicator.shared.showActivityIndicator()
        ApiHandler.callWithMultipartForm(apiName: API.Name.appleLogin, params: params) {[weak self] succeeded, response, data in
            DispatchQueue.main.async {
                ActivityIndicator.shared.hideActivityIndicator()
                if let self = self{
                    if succeeded == true, let data{
                        let decoder = JSONDecoder()
                        if let message = response["message"] as? String {
                            self.showMessage(message: message, isError: .success)
                            do {
                                let decoded = try decoder.decode(UserModel.self, from: data)
                                if let userData = decoded.data {
                                    UserDefaultsCustom.saveUserData(userData: userData)
                                    UserDefaultsCustom.userId = userData.id
                                    UserDefaultsCustom.authToken = userData.access_token
                                    DefaultManager.shared.isNew = "yes"
                                    if let message = response["message"] as? String {
                                        self.showMessage(message: message, isError: .success)
                                    }
                                    self.observer?.oberseveAppleTypeSuccessfull()
                                }
                            } catch {
                                print("error",error)
                            }
                        }
                    }else{
                        if let message = response["message"] as? String {
                            self.showMessage(message: message, isError: .error)
                        }
                    }
                }
            }
        }
        
    }
    
    func apiFacebookStatus(email:String,fbId:String){
        var params = JSON()
        params["email"] = email
        params["device_token"] = UserDefaultsCustom.deviceToken
        params["device_type"] = "2"
        params["facebook_id"] = fbId
        params["login_type"] = "0"
        ActivityIndicator.shared.showActivityIndicator()
        ApiHandler.callWithMultipartForm(apiName: API.Name.fbLogin, params: params) {[weak self] succeeded, response, data in
            DispatchQueue.main.async {
                ActivityIndicator.shared.hideActivityIndicator()
                if let self = self{
                    if succeeded == true, let data{
                        let decoder = JSONDecoder()
                        if let message = response["message"] as? String {
                            self.showMessage(message: message, isError: .success)
                            do {
                                let decoded = try decoder.decode(UserModel.self, from: data)
                                if let userData = decoded.data {
                                    UserDefaultsCustom.saveUserData(userData: userData)
                                    UserDefaultsCustom.userId = userData.id
                                    UserDefaultsCustom.authToken = userData.access_token
                                    DefaultManager.shared.isNew = "yes"
                                    if let message = response["message"] as? String {
                                        self.showMessage(message: message, isError: .success)
                                    }
                                    self.observer?.oberseveFBTypeSuccessfull()
                                }
                            } catch {
                                print("error",error)
                            }
                        }
                    }else{
                        if let message = response["message"] as? String {
                            self.showMessage(message: message, isError: .error)
                        }
                    }
                }
            }
        }
        
    }
}

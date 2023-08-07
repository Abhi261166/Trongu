//
//  LoginVM.swift
//  Trongu
//
//  Created by dr mac on 19/07/23.
//

import Foundation
protocol LoginVMObserver: NSObjectProtocol {
    func observeLoginSucessfull()
}

class LoginVM: NSObject {
    
    var observer: LoginVMObserver?
    
    init(observer: LoginVMObserver?) {
        self.observer = observer
    }
    
    func apiLogin(email: String, password: String){
        var params = JSON()
        params["email"] = email
        params["password"] = password
        params["device_type"] = "2"
        params["device_token"] = UserDefaultsCustom.deviceToken
        print("params : ", params)
        //        add loader
        ActivityIndicator.shared.showActivityIndicator()
        ApiHandler.callWithMultipartForm(apiName: API.Name.login, params: params) { [weak self] succeeded, response, data in
            DispatchQueue.main.async {
                //        remove loader
                ActivityIndicator.shared.hideActivityIndicator()
                if let self = self {
                    if succeeded == true, let data {
                        let decoder = JSONDecoder()
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
                                self.observer?.observeLoginSucessfull()
                            }
                            
                        } catch {
                            print("error", error)
                        }
                    } else {
                        if let message = response["message"] as? String {
                            self.showMessage(message: message, isError: .error)
                        }
                    }
                }
            }
        }
    }
    
}

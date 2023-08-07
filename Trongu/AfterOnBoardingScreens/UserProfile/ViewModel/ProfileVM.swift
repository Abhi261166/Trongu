//
//  ProfileVM.swift
//  Trongu
//
//  Created by dr mac on 19/07/23.
//

//

protocol ProfileVMObserver: NSObjectProtocol {
    func observeGetProfileSucessfull()
    
}


import UIKit
class ProfileVM: NSObject {
    
    var observer: ProfileVMObserver?
    var userData:UserData?

    init(observer: ProfileVMObserver?) {
        self.observer = observer
    }

    //MARK: Get Profile Api

    func apiGetProfile() {
        var params = JSON()
        params["other_id"] = ""
//        params = [:]
        print("params : ", params)
        ActivityIndicator.shared.showActivityIndicator()
        ApiHandler.callWithMultipartForm(apiName: API.Name.getProfile, params: params) { [weak self]
            succeeded, response, data in
            
            DispatchQueue.main.async {
                ActivityIndicator.shared.hideActivityIndicator()
                
                if let self = self {
                    if succeeded == true, let data {
                        let decoder = JSONDecoder()
                        do {
                            let decoded = try decoder.decode(UserModel.self, from: data)
                            if let userData = decoded.data {
                                self.userData = userData
                                UserDefaultsCustom.saveUserData(userData: userData)
                            }
                            self.observer?.observeGetProfileSucessfull()
                        }catch{
                            print("error", error)
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

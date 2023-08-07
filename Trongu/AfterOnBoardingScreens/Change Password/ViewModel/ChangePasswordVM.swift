//
//  ChangePasswordVM.swift
//  Trongu
//
//  Created by dr mac on 25/07/23.
//


protocol ChangePasswordVMObserver : NSObjectProtocol{
    func observeGetChangePasswordSucessfull()
}

import UIKit

class ChangePasswordVM :NSObject{
    var observer: ChangePasswordVMObserver?
    
    init(observer: ChangePasswordVMObserver?) {
        self.observer = observer
    }
    
    func apiChangePassword(oldPswrd:String,newPswrd:String){
        var params = JSON()
        params["old_password"] = oldPswrd
        params["new_password"] = newPswrd
        print("params :", params)
        ActivityIndicator.shared.showActivityIndicator()
        ApiHandler.callWithMultipartForm(apiName: API.Name.changePass, params: params) {[weak self] succeeded, response, data in
            DispatchQueue.main.async {
                ActivityIndicator.shared.hideActivityIndicator()
                if let self = self {
                    if succeeded == true, let data {
                        let decoder = JSONDecoder()
                        do {
                            if let message = response["message"] as? String {
                                self.showMessage(message: "Password changed successfully", isError: .success)
                            }
                            self.observer?.observeGetChangePasswordSucessfull()
                        } catch {
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

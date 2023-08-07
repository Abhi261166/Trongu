//
//  ForgotPasswordVM.swift
//  Trongu
//
//  Created by dr mac on 19/07/23.
//

import Foundation

protocol ForgotPasswordVMObserver: NSObjectProtocol {
    func observeForgotPasswordSucessfull()
}


class ForgotPasswordVM: NSObject {
    
    var observer : ForgotPasswordVMObserver?
    init(observer: ForgotPasswordVMObserver?) {
        self.observer = observer
    }
    
    func apiForgotPassword(email: String) {
        var params = JSON()
        params["email"] = email
        print("params : ", params)
//        add loader
        ActivityIndicator.shared.showActivityIndicator()
        ApiHandler.callWithMultipartForm(apiName: API.Name.forgotPassword, params: params) { [weak self] succeeded, response, data in
            DispatchQueue.main.async {
//        remove loader
                ActivityIndicator.shared.hideActivityIndicator()
                if let self = self {
                    if succeeded == true, let data {
                        let decoder = JSONDecoder()
                        do {
                            if let message = response["message"] as? String {
                                self.showMessage(message: message, isError: .success)
                            }
                            self.observer?.observeForgotPasswordSucessfull()
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

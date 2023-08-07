//
//  LogoutVM.swift
//  Trongu
//
//  Created by dr mac on 20/07/23.
//

import Foundation
protocol LogoutVMObserver: NSObjectProtocol {
    func observeLogoutSucessfull()
}
class LogoutVM: NSObject {
    
    var observer: LogoutVMObserver?
    init(observer: LogoutVMObserver?) {
        self.observer = observer
    }
    func apiLogout(){
        var params = JSON()
        params = [:]
        print("params : ", params)
        //        add loader
        ActivityIndicator.shared.showActivityIndicator()
        ApiHandler.call(apiName: API.Name.logout, params: params, httpMethod: .GET) { [weak self] succeeded, response, data in
            DispatchQueue.main.async {
                ActivityIndicator.shared.hideActivityIndicator()
                if let self = self {
                    if succeeded == true, let data {
                        let decoder = JSONDecoder()
                        do {
                            if let message = response["message"] as? String {
                                self.showMessage(message: message, isError: .success)
                            }
                            self.observer?.observeLogoutSucessfull()
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

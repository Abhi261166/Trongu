//
//  SettingsVM.swift
//  Trongu
//
//  Created by apple on 15/09/23.
//

import UIKit

protocol SettingsVMObserver: NSObjectProtocol {
    func observeSwitchPublicPrivateSucessfull(index:Int)
}

class SettingsVM: NSObject {

    var observer: SettingsVMObserver?
    init(observer: SettingsVMObserver?) {
        self.observer = observer
    }
    func apiPublicPrivate(index:Int){
        var params = JSON()
        params = [:]
        print("params : ", params)
        //        add loader
        ActivityIndicator.shared.showActivityIndicator()
        ApiHandler.call(apiName: API.Name.accountType, params: params, httpMethod: .GET) { [weak self] succeeded, response, data in
            DispatchQueue.main.async {
                ActivityIndicator.shared.hideActivityIndicator()
                if let self = self {
                    if succeeded == true {
                        self.observer?.observeSwitchPublicPrivateSucessfull(index: index)
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

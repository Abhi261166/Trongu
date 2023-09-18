//
//  BlockReportVM.swift
//  Trongu
//
//  Created by apple on 18/09/23.
//

import UIKit

protocol BlockReportVMObserver: NSObjectProtocol {
   
    func observeBlockUserSucessfull()
    func observeReportUserSucessfull()
    
}

class BlockReportVM: NSObject {

    var observer: BlockReportVMObserver?
    
    
    init(observer: BlockReportVMObserver?) {
        self.observer = observer
    }
    
    // MARK: Block/Unblock Api
    
    func apiBlockUser(userId: String) {
        var params = JSON()
        params["block_id"] = userId
        print("params : ", params)
        
        //        add loader
        ActivityIndicator.shared.showActivityIndicator()
        ApiHandler.callWithMultipartForm(apiName: API.Name.blockUser, params: params) { succeeded, response, data in
            DispatchQueue.main.async {
                //        remove loader
                ActivityIndicator.shared.hideActivityIndicator()
                if succeeded == true{
                    if let message = response["message"] as? String {
                        self.showMessage(message: message, isError: .success)
                    }
                        self.observer?.observeBlockUserSucessfull()
                }else{
                    
                    if let message = response["message"] as? String {
                        self.showMessage(message: message, isError: .error)
                    }
                    
                }
            }
        }
    }
    
    // MARK: Report User Api
    
    func apiReportUser(userId: String) {
        var params = JSON()
        params["report_id"] = userId
        print("params : ", params)
        
        //        add loader
        ActivityIndicator.shared.showActivityIndicator()
        ApiHandler.callWithMultipartForm(apiName: API.Name.reportUser, params: params) { succeeded, response, data in
            DispatchQueue.main.async {
                //        remove loader
                ActivityIndicator.shared.hideActivityIndicator()
                if succeeded == true{
                    if let message = response["message"] as? String {
                        self.showMessage(message: message, isError: .success)
                    }
                        self.observer?.observeReportUserSucessfull()
                    
                }else{
                    if let message = response["message"] as? String {
                        self.showMessage(message: message, isError: .error)
                    }
                }
            }
        }
    }
    
}

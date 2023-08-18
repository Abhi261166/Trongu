//
//  DeleteVM.swift
//  Trongu
//
//  Created by apple on 18/08/23.
//

import UIKit

protocol DeleteVMObserver: NSObjectProtocol {
    func observeDeletePostSucessfull()
}

class DeleteVM: NSObject {

    var observer: DeleteVMObserver?
    
    init(observer: DeleteVMObserver?) {
        self.observer = observer
    }
    
//MARK: - Home Posts List Api -
    
    func apiDeletePost(postId:String) {
        var params = JSON()
        params["post_id"] = postId
        
        print("params : ", params)
        
// add loader
        ActivityIndicator.shared.showActivityIndicator()
        ApiHandler.callWithMultipartForm(apiName: API.Name.deletePost, params: params) { [weak self] succeeded, response, data in
            DispatchQueue.main.async {
                ActivityIndicator.shared.hideActivityIndicator()
                if let self = self{
                    if succeeded == true, let data {
                        let decoder = JSONDecoder()
                        do {
                            
                            if let message = response["message"] as? String {
                                self.showMessage(message: message, isError: .success)
                            }
                            self.observer?.observeDeletePostSucessfull()
                           
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

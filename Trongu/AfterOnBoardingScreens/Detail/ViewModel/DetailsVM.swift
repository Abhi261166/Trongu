//
//  DetailsVM.swift
//  Trongu
//
//  Created by apple on 25/09/23.
//

import UIKit

protocol DetailsVMObserver: NSObjectProtocol {
   
    func observeGetPostDetailsSucessfull()
    func observeLikedSucessfull()
    
}

class DetailsVM: NSObject {

    var observer: DetailsVMObserver?
    var postDetails:Post?
    
    init(observer: DetailsVMObserver?) {
        self.observer = observer
    }
    
    func apiPostDetails(postId: String?){
        var params = JSON()
        params["post_id"] = postId
        
        print("params : ", params)
        //        add loader
        ActivityIndicator.shared.showActivityIndicator()
        ApiHandler.callWithMultipartForm(apiName: API.Name.getPostDetails, params: params) { [weak self] succeeded, response, data in
            DispatchQueue.main.async {
                //        remove loader
                ActivityIndicator.shared.hideActivityIndicator()
                if let self = self {
                    if succeeded == true, let data {
                        let decoder = JSONDecoder()
                        do {
                            let decoded = try decoder.decode(PostDetailsModel.self, from: data)
                            if let postDetails = decoded.data {
                                self.postDetails = postDetails
                                self.observer?.observeGetPostDetailsSucessfull()
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
    
    
    //MARK: - like Post APi -
    
    func apiLikePost(postId:String?,type:String?) {
        var params = JSON()
        params["post_id"] = postId
        params["type"] = type
        
        print("params : ", params)
        
        // add loader
        //  ActivityIndicator.shared.showActivityIndicator()
        ApiHandler.callWithMultipartForm(apiName: API.Name.likePost, params: params) { [weak self] succeeded, response, data in
            DispatchQueue.main.async {
                //       ActivityIndicator.shared.hideActivityIndicator()
                if let self = self{
                    if succeeded == true {
                        self.observer?.observeLikedSucessfull()
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

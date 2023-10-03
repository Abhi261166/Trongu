//
//  FeedbackVM.swift
//  Trongu
//
//  Created by apple on 29/09/23.
//

import UIKit
protocol FeedbackVMObserver: NSObjectProtocol {
    func observeFeedbackTypesSucessfull()
    func observeFeedbackSentSucessfull()
}


class FeedbackVM: NSObject {
    
    var observer: FeedbackVMObserver?
    var arrFeedbackTypes:[Feedback] = []
    
    init(observer: FeedbackVMObserver?) {
        self.observer = observer
    }
    
    func apiFeedbackTypes(){
        var params = JSON()
        params = [:]
        print("params : ", params)
        //        add loader
        ActivityIndicator.shared.showActivityIndicator()
        ApiHandler.call(apiName: API.Name.feedBackTypes, params: params, httpMethod: .GET) { [weak self] succeeded, response, data in
            DispatchQueue.main.async {
                ActivityIndicator.shared.hideActivityIndicator()
                if let self = self {
                    if succeeded == true, let data {
                        let decoder = JSONDecoder()
                        do {
                            let decoded = try decoder.decode(FeedbackModel.self, from: data)
                            let FeedbackTypes = decoded.data
                            self.arrFeedbackTypes.append(contentsOf: FeedbackTypes)
                         
                            self.observer?.observeFeedbackTypesSucessfull()
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
    
    
    
    //MARK: - Send Feedback Api -
    
    func apiSendFeedback(feedback:String?,feedback_category:String?) {
        var params = JSON()
        params["feedback"] = feedback
        params["feedback_category"] = feedback_category
        print("params : ", params)
        
        // add loader
        ActivityIndicator.shared.showActivityIndicator()
        ApiHandler.callWithMultipartForm(apiName: API.Name.SendFeedBack, params: params) { [weak self] succeeded, response, data in
            DispatchQueue.main.async {
                ActivityIndicator.shared.hideActivityIndicator()
                if let self = self{
                    if succeeded == true {
                        self.observer?.observeFeedbackSentSucessfull()
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

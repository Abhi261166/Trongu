//
//  NotificationListVM.swift
//  Trongu
//
//  Created by apple on 21/09/23.
//

import UIKit

protocol NotificationListVMObserver: NSObjectProtocol {
   
    func observeNotificationListSucessfull()
    func observeAcceptedOrRejectedSucessfull()
    func observeUpdateCountSucessfull(comeFrom:String)
    
}

class NotificationListVM: NSObject {

    var observer: NotificationListVMObserver?
    var arrNotificationList:[NotificationItem] = []
    var perPage = 20
    var pageNo = 0
    var isLastPage: Bool = false
    
    
    init(observer: NotificationListVMObserver?) {
        self.observer = observer
    }
    
    //MARK: - Home Posts List Api -
    
    func apiNotificationList() {
        var params = JSON()
        params["per_page"] = perPage
        params["page_no"] = pageNo + 1
        print("params : ", params)
        
        // add loader
        ActivityIndicator.shared.showActivityIndicator()
        ApiHandler.callWithMultipartForm(apiName: API.Name.getNotificationListing, params: params) { [weak self] succeeded, response, data in
            DispatchQueue.main.async {
                ActivityIndicator.shared.hideActivityIndicator()
                if let self = self{
                    if succeeded == true, let data {
                        let decoder = JSONDecoder()
                        do {
                            let decoded = try decoder.decode(NotificationModel.self, from: data)
                            let notification = decoded.data
                            if self.pageNo == 0 {
                                self.arrNotificationList.removeAll()
                            }
                            self.arrNotificationList.append(contentsOf: notification)
                            self.isLastPage = notification.count < (self.perPage)
                            self.pageNo += 1
                            self.observer?.observeNotificationListSucessfull()
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
    
    //MARK: - Follow Request Accept/Reject APi -
    
    func apiFollowRequestAcceptReject(otherUserId:String?,requestStatus:Int?,id:String?) {
        var params = JSON()
        params["follow_id"] = otherUserId
        params["id"] = id
        params["request_status"] = requestStatus
        
        print("params : ", params)
       
        ApiHandler.callWithMultipartForm(apiName: API.Name.acceptRejectFollowRequest, params: params) { [weak self] succeeded, response, data in
            DispatchQueue.main.async {
               
                if let self = self{
                    if succeeded == true {
                        self.observer?.observeAcceptedOrRejectedSucessfull()
                    } else {
                        if let message = response["message"] as? String {
                            self.showMessage(message: message, isError: .error)
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - Follow Request Accept/Reject APi -
    
    func apiUpdateSeen(comeFrom:String) {
        var params = JSON()
        params = [:]
        
        print("params : ", params)
       
        ApiHandler.callWithMultipartForm(apiName: API.Name.notificationCountUpdate, params: params) { [weak self] succeeded, response, data in
            DispatchQueue.main.async {
               
                if let self = self{
                    if succeeded == true {
                        self.observer?.observeUpdateCountSucessfull(comeFrom: comeFrom)
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

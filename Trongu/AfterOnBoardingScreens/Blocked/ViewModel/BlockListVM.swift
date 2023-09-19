//
//  BlockListVM.swift
//  Trongu
//
//  Created by apple on 19/09/23.
//

import UIKit

protocol  BlockListVMObserver: NSObjectProtocol {
    func observeBlockListFetchedSuccessfull()
    func observeUnblockSucessfull()
  
}

class BlockListVM: NSObject {
    
    var observer: BlockListVMObserver?
    var userArray:[UserData] = []
    var perPage = 10
    var pageNo = 0
    var isLastPage: Bool = false
    
    
    init(observer: BlockListVMObserver?) {
        self.observer = observer
    }
//MARK: Api block user listing
    
    func apiBlockUserList(text:String?) {
        var params = JSON()
        params["search"] = text
        params["per_page"] = perPage
        params["page_no"] = pageNo + 1
        
        print("params : ", params)
//        add loader
        ActivityIndicator.shared.showActivityIndicator()
        ApiHandler.callWithMultipartForm(apiName: API.Name.blockUserListing, params: params) { succeeded, response, data in
            DispatchQueue.main.async {
//        remove loader
        ActivityIndicator.shared.hideActivityIndicator()
                    if succeeded == true, let data {
                        let decoder = JSONDecoder()
                        do {
                            let decoded = try decoder.decode(BlockListModel.self, from: data)
                            
                            if self.pageNo == 0 {
                                self.userArray.removeAll()
                            }
//
                            if let users = decoded.data {
                                self.isLastPage = users.count < (self.perPage)
                                self.userArray.append(contentsOf: users)
                                print("SearchUsers:-\(users.count)")
                            }
                            self.pageNo += 1
                            self.observer?.observeBlockListFetchedSuccessfull()
                        } catch {
                            print("error", error)
                        }
                    }
            }
        }
    }
    
    // MARK: Block/Unblock Api
    
    func apiUnblockUser(userId: String) {
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
                        self.observer?.observeUnblockSucessfull()
                }else{
                    
                    if let message = response["message"] as? String {
                        self.showMessage(message: message, isError: .error)
                    }
                    
                }
            }
        }
    }
    
}

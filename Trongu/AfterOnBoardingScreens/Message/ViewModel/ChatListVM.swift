//
//  ChatListVM.swift
//  Trongu
//
//  Created by apple on 26/09/23.
//

import UIKit

protocol ChatListVMObserver: NSObjectProtocol {
    func observerChatListApi()
   
}

class ChatListVM: NSObject {

    var observer: ChatListVMObserver?
    var par_page         : Int = 30
    var page_no          : Int = 0
    var isLoadedAllData  : Bool = false
    var isLoadingData    : Bool = false
    var getChatUsersData : [AllChat] = []
    var isLastPage: Bool = false
    
    init(observer:ChatListVMObserver?) {
        self.observer = observer
    }
    
    //MARK: Get chat list Api
    func getChatListApi() {
        var params = JSON()
        params["per_page"] = "\(par_page)"
        params["page_no"] = "\(page_no+1)"
        
        print("params : ", params)
//        add loader
      // ActivityIndicator.shared.showActivityIndicator()
        ApiHandler.callWithMultipartForm(apiName: API.Name.getAllChatUsers, params: params) { [weak self] succeeded, response, data in
            DispatchQueue.main.async {
//        remove loader
      //  ActivityIndicator.shared.hideActivityIndicator()
                if let self = self {
                    if succeeded == true, let data {
                        let decoder = JSONDecoder()
                        do {
                            let decoded = try? decoder.decode(ChatListModel.self, from: data)
                            
                            if self.page_no == 0 {
                                self.getChatUsersData.removeAll()
                            }
//
                            if let messagesData = decoded?.data {
                                self.isLastPage = messagesData.count < (self.par_page)
                                self.getChatUsersData.append(contentsOf: messagesData)
                                print("SearchUsers:-\(messagesData.count)")
                            }
                            self.page_no += 1
                            self.observer?.observerChatListApi()
                        } catch {
                            print("error", error)
                        }
                    }
                }
            }
        }
    }
    
}

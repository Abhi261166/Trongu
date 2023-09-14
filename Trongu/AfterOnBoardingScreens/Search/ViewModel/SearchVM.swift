//
//  SearchVM.swift
//  Trongu
//
//  Created by apple on 25/08/23.
//

import UIKit

protocol SearchVMObserver: NSObjectProtocol {
    func observeSearchSucessfull()
    func observeDeleteFromRecentSucessfull()
}

class SearchVM: NSObject {

    var observer: SearchVMObserver?
    var arrUserAndPlace:[Search] = []
    var arrRecentSearchUserAndPlace:[RecentSearch] = []
    var otherUserData:UserData?
    
    var perPage = 10
    var pageNo = 0
    var isLastPage: Bool = false
    var type = "1"
    
    init(observer: SearchVMObserver?) {
        self.observer = observer
    }
    
    //MARK: Search Api
    func apiSearch(text: String) {
        var params = JSON()
        params["per_page"] = perPage
        params["page_no"] = pageNo + 1
        params["search"] = text
        if text == ""{
            params["type"] = self.type
        }

        print("params : ", params)
//        add loader
      //  ActivityIndicator.shared.showActivityIndicator()
        ApiHandler.callWithMultipartForm(apiName: API.Name.search, params: params) { [weak self] succeeded, response, data in
            DispatchQueue.main.async {
//        remove loader
       // ActivityIndicator.shared.hideActivityIndicator()
                if let self = self {
                    if succeeded == true, let data {
                        let decoder = JSONDecoder()
                        do {
                            let decoded = try decoder.decode(SearchModel.self, from: data)

                            if self.pageNo == 0 {
                                self.arrUserAndPlace.removeAll()
                            }

                            if let data = decoded.search {
                                self.isLastPage = data.count < (self.perPage)
                                self.arrUserAndPlace.append(contentsOf: data)
                            }
                            
                            if let data = decoded.recentSearch {
                               // self.isLastPage = data.count < (self.perPage)
                                self.arrRecentSearchUserAndPlace.append(contentsOf: data)
                            }
                            
                            self.pageNo += 1
                            self.observer?.observeSearchSucessfull()
                        } catch {
                            print("error", error)
                        }
                    }
                }
            }
        }
    }
    

//   MARK: - Add Recent Api -

    func apiAddRecentHistory(actionId: String,actionType: String) {
        var params = JSON()
        params["action_id"] = actionId
        params["action_type"] = actionType

        print("params : ", params)
//        add loader
        ActivityIndicator.shared.showActivityIndicator()
        ApiHandler.callWithMultipartForm(apiName: API.Name.addToRecent, params: params) { [weak self] succeeded, response, data in
            DispatchQueue.main.async {
//        remove loader
        ActivityIndicator.shared.hideActivityIndicator()
                if let self = self {
                    if succeeded == true {
                       
                    }
                }
            }
        }
    }

    
    //MARK: Remove Recent User
    func apiRemoveRecentHistory(actionId: String,actionType: String) {
        var params = JSON()
        params["action_id"] = actionId
        params["action_type"] = actionType
        print("params : ", params)
        ApiHandler.callWithMultipartForm(apiName: API.Name.deleteFromRecent, params: params) { [weak self] succeeded, response, data in
            DispatchQueue.main.async {
                if let self = self {
                    if succeeded == true {
                            self.observer?.observeDeleteFromRecentSucessfull()
                    }
                }
            }
        }
    }
    
}


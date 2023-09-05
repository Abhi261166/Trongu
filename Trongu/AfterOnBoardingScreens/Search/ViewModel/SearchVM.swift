//
//  SearchVM.swift
//  Trongu
//
//  Created by apple on 25/08/23.
//

import UIKit

protocol SearchVMObserver: NSObjectProtocol {
    func observeSearchSucessfull()
    func setSearchSucessfull()
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
        params["pageno"] = pageNo + 1
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
    
    
//    // MARK: Get other user profile Api
//
//    func apiGetUsers(userID: String) {
//        var params = JSON()
//        params["otheruser_id"] = userID
//
//        print("params : ", params)
////        add loader
//        ActivityIndicator.shared.showActivityIndicator()
//        ApiHandler.callWithMultipartForm(apiName: API.Name.getOtherUserProfile, params: params) { [weak self] succeeded, response, data in
//            DispatchQueue.main.async {
////        remove loader
//        ActivityIndicator.shared.hideActivityIndicator()
//                if let self = self {
//                    if succeeded == true, let data {
//                        let decoder = JSONDecoder()
//                        do {
//
//                            let decoded = try decoder.decode(SignupModel.self, from: data)
//                            if let userData = decoded.data {
//                                self.otherUserData = userData
//                            }
//                        self.observer?.setSearchSucessfull()
//                        } catch {
//                            print("error", error)
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//    //MARK: Add Recent Api
//
//    func apiAddRecentHistory(userID: String) {
//        var params = JSON()
//        params["user_id"] = userID
//        params["type"] = self.type
//
//        print("params : ", params)
////        add loader
//        ActivityIndicator.shared.showActivityIndicator()
//        ApiHandler.callWithMultipartForm(apiName: API.Name.addRecentHistory, params: params) { [weak self] succeeded, response, data in
//            DispatchQueue.main.async {
////        remove loader
//        ActivityIndicator.shared.hideActivityIndicator()
//                if let self = self {
//                    if succeeded == true, let data {
//                        let decoder = JSONDecoder()
//                        do {
//                           print("In Recent history api")
////                            let decoded = try decoder.decode(SignupModel.self, from: data)
////                            if let userData = decoded.data {
////                                self.otherUserData = userData
////                            }
//                         //   self.observer?.observeGetProfileSucessfull()
//                        } catch {
//                            print("error", error)
//                        }
//                    }
//                }
//            }
//        }
//    }
//
//    //MARK: Remove Recent User
//    func apiRemoveRecentHistory(userID: String) {
//        var params = JSON()
//        params["user_id"] = userID
//
//        print("params : ", params)
////        add loader
//      //  ActivityIndicator.shared.showActivityIndicator()
//        ApiHandler.callWithMultipartForm(apiName: API.Name.removeRecentHistory, params: params) { [weak self] succeeded, response, data in
//            DispatchQueue.main.async {
////        remove loader
//       // ActivityIndicator.shared.hideActivityIndicator()
//                if let self = self {
//                    if succeeded == true, let data {
//                        let decoder = JSONDecoder()
//                        do {
//                            self.observer?.setRecentSucessfull()
//
//                        } catch {
//                            print("error", error)
//                        }
//                    }
//                }
//            }
//        }
//    }
    
    
}


//
//  SearchVM.swift
//  Trongu
//
//  Created by apple on 25/08/23.
//

import UIKit

protocol SearchVMObserver: NSObjectProtocol {
    func observeSearchSucessfull()
    func setRecentSucessfull()
    func setSearchSucessfull()
}

class SearchVM: NSObject {

    var observer: SearchVMObserver?
    var userArray:[UserData] = []
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
        ApiHandler.callWithMultipartForm(apiName: API.Name.recentSearch, params: params) { [weak self] succeeded, response, data in
            DispatchQueue.main.async {
//        remove loader
       // ActivityIndicator.shared.hideActivityIndicator()
                if let self = self {
                    if succeeded == true, let data {
                        let decoder = JSONDecoder()
                        do {
                            let decoded = try decoder.decode(SearchModel.self, from: data)
                            
                            if self.pageNo == 0 {
                                self.userArray.removeAll()
                            }
                            
                            if let users = decoded.data {
                                self.isLastPage = users.count < (self.perPage)
                                
                                
                             //   self.userArray.append(contentsOf: users)
                                print("SearchUsers:-\(users.count)")
                                
                                for user in users{
                                    
                                    if UserDefaultsCustom.userId == user.id{
                                        
                                    }else{
                                        self.userArray.append(user)
                                    }
                                }
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


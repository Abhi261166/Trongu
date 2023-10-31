//
//  LikesVM.swift
//  Trongu
//
//  Created by apple on 05/09/23.
//

import UIKit
protocol LikesVMObserver: NSObjectProtocol {
    func observeLikesListSucessfull()
    func observeSearchLikesListSucessfull()
    func observeFollowUnfollowSucessfull()
}

class LikesVM: NSObject {

    var observer: LikesVMObserver?
    var perPage = 20
    var pageNo = 0
    var isLastPage: Bool = false
    var arrUser: [Datum] = []
    var arrUsers: [User] = []
    
    init(observer: LikesVMObserver?) {
        self.observer = observer
    }
    
    
    // MARK: - Follow/Unfollow Api -
    
    func apiFollowUnfollow(userID: String) {
        var params = JSON()
        params["other_id"] = userID
        
        print("params : ", params)
        ApiHandler.callWithMultipartForm(apiName: API.Name.follow, params: params) { succeeded, response, data in
            DispatchQueue.main.async {
                
                if succeeded == true {
                  
                        self.observer?.observeFollowUnfollowSucessfull()
                   
                }
            }
        }
    }
    
    
    //MARK: Like List Api
    func apiLikesList(postId: String) {
        var params = JSON()
//        params["per_page"] = perPage
//        params["pageno"] = pageNo + 1
          params["post_id"] = postId
       
        print("params : ", params)
//        add loader
        ActivityIndicator.shared.showActivityIndicator()
        ApiHandler.callWithMultipartForm(apiName: API.Name.likesList, params: params) { [weak self] succeeded, response, data in
            DispatchQueue.main.async {
//        remove loader
        ActivityIndicator.shared.hideActivityIndicator()
                if let self = self {
                    if succeeded == true, let data {
                        let decoder = JSONDecoder()
                        do {
                            let decoded = try decoder.decode(LikesModel.self, from: data)

                            if let data = decoded.data {
                                self.arrUser.append(contentsOf: data)
                            }
                          
                            self.observer?.observeLikesListSucessfull()
                        } catch {
                            print("error", error)
                        }
                    }
                }
            }
        }
    }
    
    //MARK: Search Api
    func apiSearch(postId: String,text:String) {
        var params = JSON()
          params["per_page"] = perPage
          params["pageno"] = pageNo + 1
          params["post_id"] = postId
          params["search"] = text
       
        print("params : ", params)
//        add loader
       // ActivityIndicator.shared.showActivityIndicator()
        ApiHandler.callWithMultipartForm(apiName: API.Name.searchLikesList, params: params) { [weak self] succeeded, response, data in
            DispatchQueue.main.async {
//        remove loader
       // ActivityIndicator.shared.hideActivityIndicator()
                if let self = self {
                    if succeeded == true, let data {
                        let decoder = JSONDecoder()
                        do {
                            let decoded = try decoder.decode(LikeModel.self, from: data)

                            if self.pageNo == 0 {
                                self.arrUsers.removeAll()
                            }

                            if let data = decoded.data {
                                self.isLastPage = data.count < (self.perPage)
                                self.arrUsers.append(contentsOf: data)
                            }
                            
                            self.pageNo += 1
                            self.observer?.observeSearchLikesListSucessfull()
                        } catch {
                            print("error", error)
                        }
                    }
                }
            }
        }
    }
    
}

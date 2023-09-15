//
//  FollowersVM.swift
//  Trongu
//
//  Created by apple on 15/09/23.
//

import UIKit

protocol FollowersVMObserver: NSObjectProtocol {
    func observeFollowingListSucessfull()
}

class FollowersVM: NSObject {
    
    var observer: FollowersVMObserver?
    var perPage = 20
    var pageNo = 0
    var arrUser:[Follower] = []
    var isLastPage: Bool = false
    
    init(observer: FollowersVMObserver?) {
        self.observer = observer
    }
    
    //MARK: - Follow/Unfollow Listing -
    func apiFollowFollowingList(search: String ,userID: String) {
        var params = JSON()
        params["search"] = search
        params["per_page"] = perPage
        params["pageno"] = pageNo + 1
        
        if userID != UserDefaultsCustom.userId{
            params["otheruser_id"] = userID
        }
        
        print("params : ", params)
        //        add loader
        ActivityIndicator.shared.showActivityIndicator()
        ApiHandler.callWithMultipartForm(apiName: API.Name.getFollowFollowingList, params: params) { succeeded, response, data in
            DispatchQueue.main.async {
                //        remove loader
                ActivityIndicator.shared.hideActivityIndicator()
                if succeeded == true, let data {
                    let decoder = JSONDecoder()
                    do {
                        let decoded = try decoder.decode(FollowersModel.self, from: data)
                        
                        if self.pageNo == 0 {
                            self.arrUser.removeAll()
                        }
                        
                        if let users = decoded.followers {
                            self.isLastPage = users.count < (self.perPage)
                            self.arrUser.append(contentsOf: users)
                            print("SearchUsers:-\(users.count)")
                        }
                        self.pageNo += 1
                        self.observer?.observeFollowingListSucessfull()
                    } catch {
                        print("error", error)
                    }
                }
            }
        }
    }
    
    
}

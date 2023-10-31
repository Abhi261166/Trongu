//
//  FollowersVM.swift
//  Trongu
//
//  Created by apple on 15/09/23.
//

import UIKit

protocol FollowersVMObserver: NSObjectProtocol {
    func observeFollowingListSucessfull()
    func observeRemoveFromListSucessfull()
    func observeUnfollowSucessfull()
    func observeGetProfileSucessfull()
    
}

class FollowersVM: NSObject {
    
    var observer: FollowersVMObserver?
    var perPage = 20
    var pageNo = 0
    var arrUser:[Follower] = []
    var isLastPage: Bool = false
    var userData:UserData?
    var roomId:String?
    
    init(observer: FollowersVMObserver?) {
        self.observer = observer
    }
    
    //MARK: - Follow/Unfollow Listing -
    func apiFollowFollowingList(search: String ,userID: String,isFollower:Bool = true) {
        var params = JSON()
        params["search"] = search
        params["other_id"] = userID
        params["per_page"] = perPage
        params["page_no"] = pageNo + 1
        
        print("params : ", params)
        //        add loader
        
        if search.count == 0{
            ActivityIndicator.shared.showActivityIndicator()
        }
        
        ApiHandler.callWithMultipartForm(apiName: API.Name.getFollowFollowingList, params: params) { succeeded, response, data in
            DispatchQueue.main.async {
                //        remove loader
                if search.count == 0{
                    ActivityIndicator.shared.hideActivityIndicator()
                }
                if succeeded == true, let data {
                    let decoder = JSONDecoder()
                    do {
                        let decoded = try decoder.decode(FollowersModel.self, from: data)
                        
                        if self.pageNo == 0 {
                            self.arrUser.removeAll()
                        }
                        
                        if isFollower{
                            if let users = decoded.followers {
                                self.isLastPage = users.count < (self.perPage)
                                self.arrUser.append(contentsOf: users)
                                print("SearchUsers:-\(users.count)")
                            }
                        }else{
                            if let users = decoded.followings {
                                self.isLastPage = users.count < (self.perPage)
                                self.arrUser.append(contentsOf: users)
                                print("SearchUsers:-\(users.count)")
                            }
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
    
    
    // MARK: Remove from followers Api
    func apiRemoveFromFollower(userId: String) {
        var params = JSON()
        params["follower_user"] = userId
        print("params : ", params)
        
        //        add loader
        ActivityIndicator.shared.showActivityIndicator()
        ApiHandler.callWithMultipartForm(apiName: API.Name.removeFollower, params: params) { succeeded, response, data in
            DispatchQueue.main.async {
                //        remove loader
                ActivityIndicator.shared.hideActivityIndicator()
                if succeeded == true{
                    if let message = response["message"] as? String {
                        self.showMessage(message: message, isError: .success)
                    }
                        self.observer?.observeRemoveFromListSucessfull()
                }else{
                    
                    if let message = response["message"] as? String {
                        self.showMessage(message: message, isError: .error)
                    }
                    
                }
            }
        }
    }
    
    
    
    // MARK: - Follow/Unfollow Api -
    
    func apiUnfollow(userID: String) {
        var params = JSON()
        params["other_id"] = userID
        print("params : ", params)
        
        ApiHandler.callWithMultipartForm(apiName: API.Name.follow, params: params) { succeeded, response, data in
            DispatchQueue.main.async {
                if succeeded == true {
                        self.observer?.observeUnfollowSucessfull()
                }
            }
        }
    }
    
    func apiGetProfile(userId:String,isOtherUser:Bool = false) {
        var params = JSON()
        params["other_id"] = userId
//        params = [:]
        print("params : ", params)
        ActivityIndicator.shared.showActivityIndicator()
        ApiHandler.callWithMultipartForm(apiName: API.Name.getProfile, params: params) { [weak self]
            succeeded, response, data in
            
            DispatchQueue.main.async {
                ActivityIndicator.shared.hideActivityIndicator()
                
                if let self = self {
                    if succeeded == true, let data {
                        let decoder = JSONDecoder()
                        do {
                            let decoded = try decoder.decode(UserModel.self, from: data)
                            if let userData = decoded.data {
                                self.userData = userData
                                self.roomId = decoded.room_id
                                if isOtherUser{
                                    print("Do Not Save Data...")
                                }else{
                                    UserDefaultsCustom.saveUserData(userData: userData)
                                }
                                
                            }
                            self.observer?.observeGetProfileSucessfull()
                        }catch{
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
    
    
    
}

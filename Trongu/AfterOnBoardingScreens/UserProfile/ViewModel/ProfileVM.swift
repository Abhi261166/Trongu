//
//  ProfileVM.swift
//  Trongu
//
//  Created by dr mac on 19/07/23.
//

//

protocol ProfileVMObserver: NSObjectProtocol {
    func observeGetProfileSucessfull()
    func observeGetProfilePostsSucessfull()
    func observeFollowUnfollowSucessfull()
}


import UIKit
class ProfileVM: NSObject {
    
    var observer: ProfileVMObserver?
    var userData:UserData?
    var arrPostList:[Post] = []
    var perPage = 20
    var pageNo = 0
    var isLastPage: Bool = false
    
    init(observer: ProfileVMObserver?) {
        self.observer = observer
    }

    //MARK: Get Profile Api

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
    
    //MARK: - Profile Post List APi -
    
    func apiProfilePostDetails(type:String,userId:String) {
        var params = JSON()
        params["other_id"] = userId
        params["action_type"] = type
        params["per_page"] = perPage
        params["page_no"] = pageNo + 1
        print("params : ", params)
        
        // add loader
        ActivityIndicator.shared.showActivityIndicator()
        ApiHandler.callWithMultipartForm(apiName: API.Name.profilePostDetails, params: params) { [weak self] succeeded, response, data in
            DispatchQueue.main.async {
                ActivityIndicator.shared.hideActivityIndicator()
                if let self = self{
                    if succeeded == true, let data {
                        let decoder = JSONDecoder()
                        do {
                            let decoded = try decoder.decode(HomeDataModel.self, from: data)
                            let posts = decoded.data
                            if self.pageNo == 0 {
                                self.arrPostList.removeAll()
                            }
                            self.arrPostList.append(contentsOf: posts)
                            self.isLastPage = posts.count < (self.perPage)
                            self.pageNo += 1
                            self.observer?.observeGetProfilePostsSucessfull()
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
    
   
    //MARK: - Profile Bucket List APi -
    
    func apiBucketList(type:String,userId:String) {
        var params = JSON()
        params["other_id"] = userId
        params["action_type"] = type
        params["per_page"] = perPage
        params["page_no"] = pageNo + 1
        print("params : ", params)
        
        // add loader
        ActivityIndicator.shared.showActivityIndicator()
        ApiHandler.callWithMultipartForm(apiName: API.Name.profilePostDetails, params: params) { [weak self] succeeded, response, data in
            DispatchQueue.main.async {
                ActivityIndicator.shared.hideActivityIndicator()
                if let self = self{
                    if succeeded == true, let data {
                        let decoder = JSONDecoder()
                        do {
                            let decoded = try decoder.decode(HomeDataModel.self, from: data)
                            let posts = decoded.data
                            if self.pageNo == 0 {
                                self.arrPostList.removeAll()
                            }
                            self.arrPostList.append(contentsOf: posts)
                            self.isLastPage = posts.count < (self.perPage)
                            self.pageNo += 1
                            self.observer?.observeGetProfilePostsSucessfull()
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
    
    
    
    // MARK: - Follow/Unfollow Api -
    
    func apiFollowUnfollow(userID: String) {
        var params = JSON()
        params["other_id"] = userID
        
        print("params : ", params)
        //        add loader
      //  ActivityIndicator.shared.showActivityIndicator()
        ApiHandler.callWithMultipartForm(apiName: API.Name.follow, params: params) { succeeded, response, data in
            DispatchQueue.main.async {
        //        remove loader
         //       ActivityIndicator.shared.hideActivityIndicator()
                if succeeded == true {
                  
                        self.observer?.observeFollowUnfollowSucessfull()
                   
                }
            }
        }
    }
    
}

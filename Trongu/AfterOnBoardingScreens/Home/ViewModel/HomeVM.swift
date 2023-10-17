//
//  HomeVM.swift
//  Trongu
//
//  Created by apple on 08/08/23.
//

import Foundation

protocol HomeVMObserver: NSObjectProtocol {
    func observeGetHomeDataSucessfull()
    func observeLikedSucessfull()
    func observeGetProfilePostsSucessfull()
    func observeAddedToBucket()
    
}

class HomeVM: NSObject {
    
    var observer: HomeVMObserver?
    var arrPostList:[Post] = []
    var perPage = 20
    var pageNo = 0
    var isLastPage: Bool = false
    var notificationCount = 0
    
    init(observer: HomeVMObserver?) {
        self.observer = observer
    }
    
    //MARK: - Home Posts List Api -
    
    func apiHomePostList() {
        var params = JSON()
        params["per_page"] = perPage
        params["page_no"] = pageNo + 1
        print("params : ", params)
        
        // add loader
        ActivityIndicator.shared.showActivityIndicator()
        ApiHandler.callWithMultipartForm(apiName: API.Name.postList, params: params) { [weak self] succeeded, response, data in
            DispatchQueue.main.async {
                ActivityIndicator.shared.hideActivityIndicator()
                if let self = self{
                    if succeeded == true, let data {
                        let decoder = JSONDecoder()
                        do {
                            let decoded = try decoder.decode(HomeDataModel.self, from: data)
                            self.notificationCount = decoded.noticationCount ?? 0
                            let posts = decoded.data
                            if self.pageNo == 0 {
                                self.arrPostList.removeAll()
                            }
                            self.arrPostList.append(contentsOf: posts)
                            self.isLastPage = posts.count < (self.perPage)
                            self.pageNo += 1
                            self.observer?.observeGetHomeDataSucessfull()
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
    
    
    
    //MARK: - Home Posts List Api -
    
    func apiFilterHomePostList(place:String? = nil,budget:String? = nil ,noOfDays:String? = nil,tripCat:String? = nil,ethnicity:String? = nil,complexity:String? = nil) {
        var params = JSON()
        params["place"] = place
        params["budget"] = budget
        params["no_of_days"] = noOfDays
        params["trip_category"] = tripCat
        params["trip_complexity"] = complexity
        params["ethnicity"] = ethnicity
        
        params["per_page"] = perPage
        params["page_no"] = pageNo + 1
        print("params : ", params)
        
        // add loader
        ActivityIndicator.shared.showActivityIndicator()
        ApiHandler.callWithMultipartForm(apiName: API.Name.postFilter, params: params) { [weak self] succeeded, response, data in
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
                            self.observer?.observeGetHomeDataSucessfull()
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
    
    
    
    //MARK: - like Post APi -
    
    func apiLikePost(postId:String,type:String) {
        var params = JSON()
        params["post_id"] = postId
        params["type"] = type
        
        print("params : ", params)
        
        // add loader
        //  ActivityIndicator.shared.showActivityIndicator()
        ApiHandler.callWithMultipartForm(apiName: API.Name.likePost, params: params) { [weak self] succeeded, response, data in
            DispatchQueue.main.async {
                //       ActivityIndicator.shared.hideActivityIndicator()
                if let self = self{
                    if succeeded == true {
                        self.observer?.observeLikedSucessfull()
                    } else {
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
    
    //MARK: - Add to bucket post -
    
    func apiAddTobucket(postId:String) {
        var params = JSON()
        params["post_id"] = postId
        print("params : ", params)
        
        // add loader
        //  ActivityIndicator.shared.showActivityIndicator()
        ApiHandler.callWithMultipartForm(apiName: API.Name.addToBucket, params: params) { [weak self] succeeded, response, data in
            DispatchQueue.main.async {
                //       ActivityIndicator.shared.hideActivityIndicator()
                if let self = self{
                    if succeeded == true {
                        if let message = response["message"] as? String {
                            self.showMessage(message: message, isError: .success)
                        }
                        self.observer?.observeAddedToBucket()
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


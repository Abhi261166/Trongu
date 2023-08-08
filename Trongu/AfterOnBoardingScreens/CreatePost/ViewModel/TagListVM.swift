//
//  TagListVM.swift
//  Trongu
//
//  Created by apple on 08/08/23.
//

import UIKit
import YPImagePicker

protocol TagListVMObserver: NSObjectProtocol {
    func observeGetTagListSucessfull()
    
}

class TagListVM: NSObject {
    
    var observer: TagListVMObserver?
    var arrTagList:[TagList] = []
    
    init(observer: TagListVMObserver?) {
        self.observer = observer
    }
    
    //MARK: Tag List Api
    func apiTagList() {
            var params = JSON()
             params = [:]
            print("params : ", params)

    //        add loader
        ActivityIndicator.shared.showActivityIndicator()
        
        ApiHandler.call(apiName: API.Name.tagList, params: params, httpMethod: API.HttpMethod.GET) { [weak self] succeeded, response, data in
                DispatchQueue.main.async {
    //        remove loader
        ActivityIndicator.shared.hideActivityIndicator()
                    
                    if let self = self {
                        if succeeded == true, let data {
                            let decoder = JSONDecoder()
                            do {
                                let decoded = try decoder.decode(TagListModel.self, from: data)
                                let tagList = decoded.followers
                                self.arrTagList.append(contentsOf: tagList ?? [])
                                let tagList2 = decoded.followings
                                self.arrTagList.append(contentsOf: tagList2 ?? [])
                                self.observer?.observeGetTagListSucessfull()
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
    
    
    func apiCreatePost(tags:String,budget:String,noOffDays:String,tripCat:String,disc:String,tripComp:String,arrPosts:[YPMediaItem]){
        
        
    }
    
}

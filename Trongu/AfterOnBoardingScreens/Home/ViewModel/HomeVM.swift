//
//  HomeVM.swift
//  Trongu
//
//  Created by apple on 08/08/23.
//

import Foundation

protocol HomeVMObserver: NSObjectProtocol {
    func observeGetHomeDataSucessfull()
}

class HomeVM: NSObject {
    
    var observer: HomeVMObserver?
    var arrPostList:[Post] = []
    var perPage = 10
    var pageNo = 0
    var isLastPage: Bool = false
    
    
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
}


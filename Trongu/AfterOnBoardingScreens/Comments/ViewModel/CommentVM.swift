//
//  CommentVM.swift
//  Trongu
//
//  Created by apple on 21/08/23.
//

import UIKit
protocol CommentVMObserver: NSObjectProtocol {
    func observeGetCommentListSucessfull()
 
    
}

class CommentVM: NSObject {

    var observer: CommentVMObserver?
    var arrCommentList:[Comment] = []
    var perPage = 10
    var pageNo = 0
    var isLastPage: Bool = false
    
    init(observer: CommentVMObserver?) {
        self.observer = observer
    }
    
    //MARK: - Comments List APi -
    
    func apiCommentList(postId:String) {
        var params = JSON()
        params["post_id"] = postId
        params["per_page"] = perPage
        params["page_no"] = pageNo + 1
        print("params : ", params)
        
        // add loader
        ActivityIndicator.shared.showActivityIndicator()
        ApiHandler.callWithMultipartForm(apiName: API.Name.commentList, params: params) { [weak self] succeeded, response, data in
            DispatchQueue.main.async {
                ActivityIndicator.shared.hideActivityIndicator()
                if let self = self{
                    if succeeded == true, let data {
                        let decoder = JSONDecoder()
                        do {
                            let decoded = try decoder.decode(CommentModel.self, from: data)
                            let comment = decoded.data
                            if self.pageNo == 0 {
                                self.arrCommentList.removeAll()
                            }
                            self.arrCommentList.append(contentsOf: comment)
                            self.isLastPage = comment.count < (self.perPage)
                            self.pageNo += 1
                            self.observer?.observeGetCommentListSucessfull()
                        } catch {
                            print("error", error)
                        }
                    } else {
                        if let message = response["message"] as? String {
                          //  self.showMessage(message: message, isError: .error)
                        }
                    }
                }
            }
        }
    }
}

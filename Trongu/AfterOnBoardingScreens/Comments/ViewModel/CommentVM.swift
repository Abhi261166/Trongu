//
//  CommentVM.swift
//  Trongu
//
//  Created by apple on 21/08/23.
//

import UIKit
protocol CommentVMObserver: NSObjectProtocol {
    func observeGetCommentListSucessfull()
    func observeAddCommentSucessfull()
    
    
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
                            self.showMessage(message: message, isError: .error)
                        }
                    }
                }
            }
        }
    }
    
    //MARK: - Send Comment -
    
    func apiSendComment(postId:String,comment:String,replyToId:String,commentId:String, isReply:Bool) {
        var params = JSON()
        
        if isReply{
            params["post_id"] = postId
            params["comment"] = comment
            params["reply_to_id"] = replyToId
            params["reply_comment_id"] = commentId
            print("params : ", params)
        }else{
            params["post_id"] = postId
            params["comment"] = comment
            params["reply_to_id"] = "0"
            params["reply_comment_id"] = "0"
            print("params : ", params)
        }
        
        // add loader
       // ActivityIndicator.shared.showActivityIndicator()
        ApiHandler.callWithMultipartForm(apiName: API.Name.addcomment, params: params) { [weak self] succeeded, response, data in
            DispatchQueue.main.async {
             //   ActivityIndicator.shared.hideActivityIndicator()
                if let self = self{
                    if succeeded == true{
                        let decoder = JSONDecoder()
                            self.observer?.observeAddCommentSucessfull()
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

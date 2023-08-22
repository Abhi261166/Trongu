//
//  CommentModel.swift
//  Trongu
//
//  Created by apple on 21/08/23.
//

import UIKit

// MARK: - Comment Model -
//struct CommentModel: Codable {
//    let status: Int
//    let message, commentCount: String
//    let data: [Comment]
//
//    enum CodingKeys: String, CodingKey {
//        case status, message
//        case commentCount = "CommentCount"
//        case data
//    }
//}
//
//// MARK: - Datum
//struct Comment: Codable {
//    let commentID, userID, postID, comment: String
//    let replyCommentID, replyToID, status, createdAt: String
//    let replyComment: [Comment]?
//    let replyCommentCount: String?
//
//
//    enum CodingKeys: String, CodingKey {
//        case commentID = "comment_id"
//        case userID = "user_id"
//        case postID = "post_id"
//        case comment
//        case replyCommentID = "reply_comment_id"
//        case replyToID = "reply_to_id"
//        case status
//        case createdAt = "created_at"
//        case replyComment, replyCommentCount
//    }
//}


struct CommentModel: Codable {
    let status: Int
    let message, commentCount: String
    let data: [Comment]

    enum CodingKeys: String, CodingKey {
        case status, message
        case commentCount = "CommentCount"
        case data
    }
}

// MARK: - Datum
struct Comment: Codable {
    let commentID, userID, postID, comment: String
    let replyCommentID, replyToID, status, createdAt: String
    let name, username: String
    let userImage: String
    let replyComment: [ReplyComment]
    let replyCommentCount: String

    enum CodingKeys: String, CodingKey {
        case commentID = "comment_id"
        case userID = "user_id"
        case postID = "post_id"
        case comment
        case replyCommentID = "reply_comment_id"
        case replyToID = "reply_to_id"
        case status
        case createdAt = "created_at"
        case name, username, userImage, replyComment, replyCommentCount
    }
}

// MARK: - ReplyComment
struct ReplyComment: Codable {
    let commentID, userID, postID, comment: String
    let replyCommentID, replyToID, status, createdAt: String
    let name, userName: String
    let image: String

    enum CodingKeys: String, CodingKey {
        case commentID = "comment_id"
        case userID = "user_id"
        case postID = "post_id"
        case comment
        case replyCommentID = "reply_comment_id"
        case replyToID = "reply_to_id"
        case status
        case createdAt = "created_at"
        case name
        case userName = "user_name"
        case image
    }
}

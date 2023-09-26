//
//  ChatModel.swift
//  Trongu
//
//  Created by apple on 26/09/23.
//

import UIKit

class ChatModel: NSObject {

}
// MARK: - Create Room Model -

struct CreateRoomModel: Codable {
    let status: Int
    let message: String
    let data: ChatUserData
}

// MARK: - Chat User Data -
struct ChatUserData: Codable {
    let userID, roomID, otherID, status: String
    let createdAt, id: String

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case roomID = "room_id"
        case otherID = "other_id"
        case status
        case createdAt = "created_at"
        case id
    }
}


// MARK: - Chat List Model -
//struct ChatListModel: Codable {
//    let code, status: Int
//    let message: String
//    let data: [AllChat]
//    let lastPage: Bool
//
//    enum CodingKeys: String, CodingKey {
//        case code, status, message, data
//        case lastPage = "last_page"
//    }
//}
//
//// MARK: - AllChat -
//struct AllChat: Codable {
//    let id, userID, otheruserID, roomID: String
//    let creationAt, lastMessage, lastMessageTime, messageCount: String
//    let fullName, profilePhoto: String
//    let userActive: String
//    enum CodingKeys: String, CodingKey {
//        case id
//        case userID = "user_id"
//        case otheruserID = "otheruser_id"
//        case roomID = "room_id"
//        case creationAt = "creation_at"
//        case fullName = "full_name"
//        case profilePhoto = "profile_photo"
//        case lastMessage, lastMessageTime, messageCount
//        case userActive = "userActive"
//    }
//}

struct ChatListModel: Codable {
    let status: Int
    let message: String
    let data: [AllChat]
}

// MARK: - Datum
struct AllChat: Codable {
    let id, userID, otherID, status: String
    let roomID, createdAt, badgeCount, lastMessage: String
    let lastMessageTime, userName: String
    let userImage: String

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case otherID = "other_id"
        case status
        case roomID = "room_id"
        case createdAt = "created_at"
        case badgeCount
        case lastMessage = "LastMessage"
        case lastMessageTime = "LastMessageTime"
        case userName, userImage
    }
}

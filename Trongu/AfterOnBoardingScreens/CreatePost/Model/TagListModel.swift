//
//  TagListModel.swift
//  Trongu
//
//  Created by apple on 08/08/23.
//

import Foundation

struct TagListModel: Codable {
    let status: Int?
    let message: String?
    let followings, followers: [TagList]?
}

// MARK: - Follow
struct TagList: Codable {
    let id, userID, otherID, requestStatus: String?
    let status, createdAt, name, userName: String?
    let image: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case otherID = "other_id"
        case requestStatus = "request_status"
        case status
        case createdAt = "created_at"
        case name
        case userName = "user_name"
        case image
    }
}

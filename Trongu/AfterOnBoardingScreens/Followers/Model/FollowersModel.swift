//
//  FollowersModel.swift
//  Trongu
//
//  Created by apple on 15/09/23.
//

import UIKit

    // MARK: - Welcome -
    struct FollowersModel: Codable {
            let status: Int
            let message: String
            let followings, followers: [Follower]?
    }

    // MARK: - Follower -
    struct Follower: Codable {
        let id, userID, otherID, requestStatus: String
            let status, createdAt, name, userName: String
            let image: String?
            let isFollow: String
            let userImage: String?

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
                case isFollow = "is_follow"
                case userImage
            }
    }


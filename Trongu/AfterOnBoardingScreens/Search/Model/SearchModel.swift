//
//  SearchModel.swift
//  Trongu
//
//  Created by apple on 25/08/23.
//

import UIKit

// MARK: - Search Model -
struct SearchModel: Codable {
    let status: Int
    let message: String
    let search: [Search]?
    let recentSearch: [RecentSearch]?

    enum CodingKeys: String, CodingKey {
        case status, message
        case search = "Search"
        case recentSearch = "Recent search"
    }
}

// MARK: - RecentSearch -
struct RecentSearch: Codable {
    let id, googleID, facebookID, appleID: String
    let name, userName, actionType , loginType, gender: String
    let email: String
    let image: String
    let password, place, bio, dob: String
    let ethnicity, deviceToken, deviceType, isStatus: String
    let mailStatus, smsStatus, status, authKey: String
    let accessToken, lat, long, verificationToken: String
    let passwordResetToken, expireAt, superUser, isPrivate: String
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case googleID = "google_id"
        case facebookID = "facebook_id"
        case appleID = "apple_id"
        case name
        case userName = "user_name"
        case loginType = "login_type"
        case gender, email, image, password, place, bio, dob, ethnicity
        case deviceToken = "device_token"
        case deviceType = "device_type"
        case isStatus = "is_status"
        case mailStatus = "mail_status"
        case smsStatus = "sms_status"
        case status
        case authKey = "auth_key"
        case accessToken = "access_token"
        case lat, long
        case verificationToken = "verification_token"
        case passwordResetToken = "password_reset_token"
        case expireAt = "expire_at"
        case superUser = "super_user"
        case isPrivate = "is_private"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case actionType = "action_type"
    }
}

// MARK: - Search -
struct Search: Codable {
    let actionID, actionType, place, name: String
    let userName: String
    let image: String
    let videoURL: String?
    let postID: String?

    enum CodingKeys: String, CodingKey {
        case actionID = "action_id"
        case actionType = "action_type"
        case place, name
        case userName = "user_name"
        case image
        case videoURL = "video_url"
        case postID = "post_id"
    }
}

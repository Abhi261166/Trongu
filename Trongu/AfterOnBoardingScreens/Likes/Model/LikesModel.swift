//
//  LikesModel.swift
//  Trongu
//
//  Created by apple on 05/09/23.
//

import UIKit

// MARK: - Likes Model -
struct LikesModel: Codable {
    let status: Int
    let message: String
    let data: [Datum]?
}

// MARK: - Datum
struct Datum: Codable {
    let id, userID, postID, likeType: String
    let type, status, createdAt: String
    let userdetail: [Userdetail]
    let isFollow: String

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case postID = "post_id"
        case likeType = "like_type"
        case type, status
        case createdAt = "created_at"
        case userdetail
        case isFollow = "is_follow"
    }
}

// MARK: - Userdetail
struct Userdetail: Codable {
    let id, googleID, facebookID, appleID: String
    let name, userName, loginType, gender: String
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
    }
}


// MARK: - Welcome
struct LikeModel: Codable {
    let status: Int
    let message: String
    let data: [User]?
}

// MARK: - Datum
struct User: Codable {
    let id, googleID, facebookID, appleID: String
    let name, userName, loginType, gender: String
    let email: String
    let image: String
    let password, place, bio, dob: String
    let ethnicity, deviceToken, deviceType, isStatus: String
    let mailStatus, smsStatus, status, authKey: String
    let accessToken, lat, long, verificationToken: String
    let passwordResetToken, expireAt, superUser, isPrivate: String
    let createdAt, updatedAt, isFollow: String

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
        case isFollow = "is_follow"
    }
}

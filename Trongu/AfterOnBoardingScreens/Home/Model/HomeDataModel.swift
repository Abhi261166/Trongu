//
//  HomeDataModel.swift
//  Trongu
//
//  Created by apple on 08/08/23.
//

import Foundation


struct HomeDataModel: Codable {
    let status: Int
    let message: String
    let noticationCount:Int
    let data: [Post]
}

struct ProfilePostsModel: Codable {
    let status: Int
    let message: String
    let data: [Post]
}

// MARK: - Datum
struct Post: Codable {
    var id, userID, budget, noOfDays: String
    var isLike,is_report,post_like_count:String?
    var trip_complexity_name,no_of_days_name:String
    var tripCategory, description, tripComplexity, status: String
    var createdAt: String
    var postImagesVideo: [PostImagesVideo] = []
    var tripCategoryName: String
    var tagPeople: [TagPerson]?
    var userDetail: UserDetail
    var commentCount:String?
    var latestComments:[LatestComment]?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case budget
        case noOfDays = "no_of_days"
        case tripCategory = "trip_category"
        case description
        case tripComplexity = "trip_complexity"
        case status
        case createdAt = "created_at"
        case postImagesVideo
        case tripCategoryName = "trip_category_name"
        case tagPeople = "tag_people"
        case userDetail = "user_detail"
        case isLike = "is_like"
        case post_like_count = "post_like_count"
        case trip_complexity_name
        case no_of_days_name
        case is_report
        case latestComments = "comment"
        case commentCount = "comment_count"
        
    }
}

enum CreatedAt: String, Codable {
    case the20230812153948 = "2023-08-12 15:39:48"
}
// MARK: - Latest Comments -

struct LatestComment: Codable {
    var comment_id, post_id, user_id, comment: String
    var reply_comment_id, reply_to_id, status: String
    let created_at: String
    var user_name: String?
    let name: String
    

    enum CodingKeys: String, CodingKey {
      case comment_id
      case post_id
      case user_id
      case comment
      case reply_comment_id
      case reply_to_id
      case status
      case created_at
      case user_name
      case name
      
    }
}

// MARK: - PostImagesVideo -
struct PostImagesVideo: Codable {
    var id, postID, place, date: String
    var time, lat, long: String
    let image: String
    var country: String?
    let videoTitle: String
    let videoURL: String
    let height, width: String
    let thumbNailImage: String
    let type, deviceType, songFrom, songTitle: String
    let fullMusicURL, artistID, artistName, trackID: String
    let trackType, trackPicture, playbackSeconds, albumName: String
    let albumID, trackName, videoStartTime, videoEndTime: String
    let status: String
    let createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case postID = "post_id"
        case place, date, time, lat, long, image
        case videoTitle = "video_title"
        case videoURL = "video_url"
        case height, width
        case thumbNailImage = "thumb_nail_image"
        case type
        case deviceType = "device_type"
        case songFrom = "song_from"
        case songTitle = "song_title"
        case fullMusicURL = "full_music_url"
        case artistID = "artist_id"
        case artistName = "artist_name"
        case trackID = "track_id"
        case trackType = "track_type"
        case trackPicture = "track_picture"
        case playbackSeconds = "playback_seconds"
        case albumName = "album_name"
        case albumID = "album_id"
        case trackName = "track_name"
        case videoStartTime = "video_start_time"
        case videoEndTime = "video_end_time"
        case status
        case country
        case createdAt = "created_at"
    }
}

// MARK: - TagPerson -
struct TagPerson: Codable {
    let id, name: String
}

// MARK: - UserData -
struct UserDetail: Codable {
    let id, googleID, facebookID, appleID: String
    let name, userName, loginType, gender: String
    let email: String
    let image: String
    let password, place, bio, dob: String?
    let ethnicity, deviceToken, deviceType, isStatus: String
    let mailStatus, smsStatus, status, authKey: String
    let accessToken, lat, long, verificationToken: String
    let passwordResetToken: String
    let expireAt, createdAt: String
    let updatedAt: String

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
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - Profile Map Model -
struct ProfileMapModel: Codable {
    let status: Int
    let message: String
    let postDetail, bucketDetail: [TDetail]?

    enum CodingKeys: String, CodingKey {
        case status, message
        case postDetail = "Post detail"
        case bucketDetail = "Bucket detail"
    }
}

// MARK: - TDetail
struct TDetail: Codable {
    let place, time, date, lat: String
    let long: String
}

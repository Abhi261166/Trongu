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
    let isOnline:String

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case otherID = "other_id"
        case status
        case isOnline = "is_online"
        case roomID = "room_id"
        case createdAt = "created_at"
        case badgeCount
        case lastMessage = "LastMessage"
        case lastMessageTime = "LastMessageTime"
        case userName, userImage
    }
}


// MARK: - Welcome
//struct AllMessagesModel: Codable {
//    let status: Int
//    let message, userName: String
//    let userImage: String
//    let data: [MessageDetails]
//}

// MARK: - Datum
//struct MessageDetails: Codable {
//    let msgID, userID, otherID, roomID: String
//    let message, postID, type, imageID: String
//    let readStatus, status, createdAt: String
//    let images, videos: [Image]
//    let post: PostClass?
//    let postImages: [PostImage]?
//    let userDetails: UserDetails?
//
//    enum CodingKeys: String, CodingKey {
//        case msgID = "msg_id"
//        case userID = "user_id"
//        case otherID = "other_id"
//        case roomID = "room_id"
//        case message
//        case postID = "post_id"
//        case type
//        case imageID = "image_id"
//        case readStatus = "read_status"
//        case status
//        case createdAt = "created_at"
//        case images, videos, post, postImages, userDetails
//    }
//}

// MARK: - Image
struct Image: Codable {
    let id, msgID: String
    let image: String
    let video: String
    let thumbnailImage, type, status, createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case msgID = "msg_id"
        case image, video
        case thumbnailImage = "thumbnail_image"
        case type, status
        case createdAt = "created_at"
    }
}


// MARK: - PostClass
struct PostClass: Codable {
    let id, userID, budget, noOfDays: String
    let description, tripComplexity, status: String
    let tripCategory:String
    let createdAt: String

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
    }
}

// MARK: - PostImage -

struct PostImage: Codable {
    let id, postID, place, date: String
    let time, lat, long: String
    let image: String
    let videoTitle, videoURL, height, width: String
    let thumbNailImage, type, deviceType, songFrom: String
    let songTitle, fullMusicURL, artistID, artistName: String
    let trackID, trackType, trackPicture, playbackSeconds: String
    let albumName, albumID, trackName, videoStartTime: String
    let videoEndTime, status, createdAt, video: String
    let thumbnailImage: String

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
        case createdAt = "created_at"
        case video
        case thumbnailImage = "thumbnail_image"
    }
}

// MARK: - UserDetails
struct UserDetails: Codable {
    let id, googleID, facebookID, appleID: String
    let name, userName, loginType, gender: String
    let email: String
    let image: String
    let password, place, bio, dob: String
    let ethnicity, deviceToken, deviceType, isStatus: String
    let mailStatus, smsStatus, status, authKey: String
    let accessToken, lat, long, verificationToken: String
    let passwordResetToken, expireAt, superUser, isOnline: String
    let isPrivate, createdAt, updatedAt: String

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
        case isOnline = "is_online"
        case isPrivate = "is_private"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct SendMessageModel: Codable {
    let status: Int
    let message: String
    let data: MessageDetails
}

struct AllMessagesModel: Codable {
    let status: Int
    let message, userName: String
    let userImage: String
    let data: [MessageDetails]?
    
    init(status: Int, message: String, userName: String, userImage: String, data: [MessageDetails]?) {
        self.status = status
        self.message = message
        self.userName = userName
        self.userImage = userImage
        self.data = data
    }
}

// MARK: - Datum
struct MessageDetails: Codable {
    let msgID, userID, otherID: String
    let roomID: String
    let message: String
    let postID, type, imageID, readStatus: String
    let status, createdAt: String
    let images, videos: [Imagess]?
    
    let post: PostDetails?

    enum CodingKeys: String, CodingKey {
        case msgID = "msg_id"
        case userID = "user_id"
        case otherID = "other_id"
        case roomID = "room_id"
        case message
        case postID = "post_id"
        case type
        case imageID = "image_id"
        case readStatus = "read_status"
        case status
        case createdAt = "created_at"
        case images, videos, post
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.msgID = try container.decode(String.self, forKey: .msgID)
        self.userID = try container.decode(String.self, forKey: .userID)
        self.otherID = try container.decode(String.self, forKey: .otherID)
        self.roomID = try container.decode(String.self, forKey: .roomID)
        self.message = try container.decode(String.self, forKey: .message)
        self.postID = try container.decode(String.self, forKey: .postID)
        self.type = try container.decode(String.self, forKey: .type)
        self.imageID = try container.decode(String.self, forKey: .imageID)
        self.readStatus = try container.decode(String.self, forKey: .readStatus)
        self.status = try container.decode(String.self, forKey: .status)
        self.createdAt = try container.decode(String.self, forKey: .createdAt)
        
        
        do{
            self.post = try container.decodeIfPresent(PostDetails.self, forKey: .post)
        }catch{
            self.post = nil
            debugPrint("we have found error in parsing PostDetail",error)
        }
        self.images = try container.decodeIfPresent([Imagess].self, forKey: .images)
        self.videos = try container.decodeIfPresent([Imagess].self, forKey: .videos)
    }
    

}

// MARK: - Image
struct Imagess: Codable {
    let id, msgID: String
    let image: String
    let video: String
    let thumbnailImage: String
    let type, status, createdAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case msgID = "msg_id"
        case image, video
        case thumbnailImage = "thumbnail_image"
        case type, status
        case createdAt = "created_at"
    }
}

struct PostDetails: Codable {
    let id, user_id, description : String
    let postImages:PostImageDetails?
    let userDetails:PostUserDetails?

    enum CodingKeys: String, CodingKey {
        case id
        case user_id
        case description
        case postImages
        case userDetails
    }
    init(id: String, user_id: String, description: String, postImages: PostImageDetails?, userDetails: PostUserDetails?) {
        self.id = id
        self.user_id = user_id
        self.description = description
        self.postImages = postImages
        self.userDetails = userDetails
    }
}

struct PostImageDetails: Codable {
    let image, thumb_nail_image : String

    enum CodingKeys: String, CodingKey {
        case image
        case thumb_nail_image
    }
    init(image: String, thumb_nail_image: String) {
        self.image = image
        self.thumb_nail_image = thumb_nail_image
    }
}

struct PostUserDetails: Codable {
    let id, image,name : String

    enum CodingKeys: String, CodingKey {
        case id
        case image
        case name
    }
    init(id: String,name: String, image: String) {
        self.id = id
        self.image = image
        self.name = name
    }
}


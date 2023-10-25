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


// MARK: - Welcome
struct AllMessagesModel: Codable {
    let status: Int
    let message, userName: String
    let userImage: String
    let data: [MessageDetails]
}

// MARK: - Datum
struct MessageDetails: Codable {
    let msgID, userID, otherID: String
    let roomID: String
    let message: String
    let postID, type, imageID, readStatus: String
    let status, createdAt: String
    let images, videos: [Image]
    let post: PostClass
    let postImages: [PostImage]?
    let userDetails: UserDetails?

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
        case images, videos, post, postImages, userDetails
    }
}

enum PostUnion: Codable {
    case anythingArray([JSONAny])
    case postClass(PostClass)

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode([JSONAny].self) {
            self = .anythingArray(x)
            return
        }
        if let x = try? container.decode(PostClass.self) {
            self = .postClass(x)
            return
        }
        throw DecodingError.typeMismatch(PostUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for PostUnion"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .anythingArray(let x):
            try container.encode(x)
        case .postClass(let x):
            try container.encode(x)
        }
    }
}


enum PostCreatedAt: String, Codable {
    case the20230927051012 = "2023-09-27 05:10:12"
}

enum Description: String, Codable {
    case helloooo = "Helloooo"
}

enum NoOfDays: String, Codable {
    case the3Days = "3 days"
}

enum TripComplexity: String, Codable {
    case smooth = "Smooth"
}


enum DateEnum: String, Codable {
    case the092723 = "09/27/23"
}

enum Place: String, Codable {
    case mohali = "Mohali"
}

enum Time: String, Codable {
    case the1022AmIst = "10:22 AM IST"
}

enum RoomID: String, Codable {
    case the3VcQNqHAuOTPZYeICYB5WnRIWcnFgVqG = "3VcQNqHAuOTPZYeICYB5WnRIWcnFgVqG"
}

enum AuthKey: String, Codable {
    case dzaDMAHgcE46FJvTbtBVZIMXGtNw0Pf0 = "DzaDmaHgcE46FJvTbtBVZIMxGtNw0Pf0"
}

enum Bio: String, Codable {
    case hellooo = "Hellooo"
}

enum UserDetailsCreatedAt: String, Codable {
    case the20230927050735 = "2023-09-27 05:07:35"
}

enum Dob: String, Codable {
    case the27092023 = "27-09-2023"
}

enum Email: String, Codable {
    case testYopmailCOM = "test@yopmail.com"
}

enum Name: String, Codable {
    case testUser = "test user"
}

enum Password: String, Codable {
    case the2Y13NFBV3RVZYE0WZRXUJDHD5UjUEA8B356FBXUc49UNyjNDqxkmpqVoC = "$2y$13$nFBV3rVZYE0WZRXUJDHD5ujUEA8B356fBXUc49UNyjNDqxkmpqVoC"
}

enum UserName: String, Codable {
    case test = "test"
}

enum VerificationToken: String, Codable {
    case the2TCCpmFJS9QRbd51LPqnm7TFBICBXH1695791255 = "2tCCpmFJS9Q-rbd51lPqnm7TF-BIcBXH_1695791255"
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
        return nil
    }

    required init?(stringValue: String) {
        key = stringValue
    }

    var intValue: Int? {
        return nil
    }

    var stringValue: String {
        return key
    }
}

class JSONAny: Codable {

    let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }

    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }

    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: self.value)
        }
    }
}

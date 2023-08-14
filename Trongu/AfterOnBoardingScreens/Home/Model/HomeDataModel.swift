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
    let data: [Post]
}

// MARK: - Datum
struct Post: Codable {
    let id, userID, budget, noOfDays: String
    let tripCategory, description, tripComplexity, status: String
    let createdAt: String
    let postImagesVideo: [PostImagesVideo]
    let tripCategoryName: String
    let tagPeople: [[TagPerson]]?

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
    }
}

enum CreatedAt: String, Codable {
    case the20230812153948 = "2023-08-12 15:39:48"
}

// MARK: - PostImagesVideo -
struct PostImagesVideo: Codable {
    var id, postID, place, date: String
    var time, lat, long: String
    let image: String
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
        case createdAt = "created_at"
    }
}

// MARK: - TagPerson
struct TagPerson: Codable {
    let id, name: String
}

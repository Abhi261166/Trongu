//
//  NotificationModel.swift
//  Trongu
//
//  Created by apple on 21/09/23.
//

// MARK: - Welcome
struct NotificationModel: Codable {
    let status: Int?
    let message: String?
    let data: [NotificationItem]?
}

// MARK: - Datum
struct NotificationItem: Codable {
    let id, followID, title, description: String?
    let massPushID, seen: String?
    let notification: String?
    let userID, otherID, postID, notificationType: String?
    let status, requestStatus, createdAt: String?
    let requestStatuss: String?
    let userName: String?
    let userImage: String?
    let isFollow: String?

    enum CodingKeys: String, CodingKey {
        case id
        case followID = "follow_id"
        case title, description
        case massPushID = "mass_push_id"
        case seen, notification
        case userID = "user_id"
        case otherID = "other_id"
        case postID = "post_id"
        case notificationType = "notification_type"
        case status
        case requestStatus = "request_status"
        case createdAt = "created_at"
        case requestStatuss = "request_statuss"
        case userName = "user_name"
        case userImage = "user_image"
        case isFollow = "is_follow"
    }
}

//
//  FeedbackModel.swift
//  Trongu
//
//  Created by apple on 29/09/23.
//

import Foundation

// MARK: - Welcome -
struct FeedbackModel: Codable {
    let status: Int
    let message: String
    let data: [Feedback]
}

// MARK: - Datum
struct Feedback: Codable {
    let id, name, status, createdAt: String

    enum CodingKeys: String, CodingKey {
        case id, name, status
        case createdAt = "created_at"
    }
}

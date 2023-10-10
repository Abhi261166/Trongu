//
//  CategoriesModel.swift
//  Trongu
//
//  Created by apple on 05/10/23.
//

import Foundation

// MARK: - CategoriesModel -
struct CategoriesModel: Codable {
    let status: Int
    let message: String
    let tripComplexity, tripCategory, numberOfDays: [Category]

    enum CodingKeys: String, CodingKey {
        case status, message
        case tripComplexity = "Trip complexity"
        case tripCategory = "TripCategory"
        case numberOfDays = "NumberOfDays"
    }
}

// MARK: - NumberOfDay
struct Category: Codable {
    let id: String
    let noOfDays: String?
    let status, createdAt: String
    let name: String?

    enum CodingKeys: String, CodingKey {
        case id
        case noOfDays = "no_of_days"
        case status
        case createdAt = "created_at"
        case name
    }
}

struct SignUpCatModel: Codable {
    let status: Int
    let message: String
    let ethnicity, gender: [SignUpCatItem]

    enum CodingKeys: String, CodingKey {
        case status, message
        case ethnicity = "Ethnicity"
        case gender = "Gender"
    }
}

// MARK: - Ethnicity
struct SignUpCatItem: Codable {
    let id: String
    let name: String?
    let status, createdAt: String
    let genderName: String?

    enum CodingKeys: String, CodingKey {
        case id, name, status
        case createdAt = "created_at"
        case genderName = "gender_name"
    }
}

//
//  PostDetailsModel.swift
//  Trongu
//
//  Created by apple on 25/09/23.
//

import Foundation

struct PostDetailsModel: Codable {
    let status: Int
    let message: String
    let data: Post?
}

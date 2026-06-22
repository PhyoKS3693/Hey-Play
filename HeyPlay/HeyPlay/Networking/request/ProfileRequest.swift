//
//  ProfileRequest.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 06/15/26.
//

import Foundation

// MARK: - Update Profile Request
struct UpdateProfileRequest: Encodable {
    let name: String
    let email: String?
    let gender: Int?
    let profileImage: String?

    enum CodingKeys: String, CodingKey {
        case name
        case email
        case gender
        case profileImage
    }
}

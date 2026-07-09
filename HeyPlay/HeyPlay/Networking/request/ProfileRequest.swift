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

// MARK: - Link Account Request
struct LinkAccountRequest: Encodable {
    let accountType: Int
    let googleId: String?
    let email: String?
    let appleId: String?
    let lineUserId: String?

    enum CodingKeys: String, CodingKey {
        case accountType
        case googleId
        case email
        case appleId
        case lineUserId
    }

    // Factory methods for each account type
    static func google(googleId: String, email: String) -> LinkAccountRequest {
        return LinkAccountRequest(
            accountType: 2,
            googleId: googleId,
            email: email,
            appleId: nil,
            lineUserId: nil
        )
    }

    static func apple(appleId: String) -> LinkAccountRequest {
        return LinkAccountRequest(
            accountType: 3,
            googleId: nil,
            email: nil,
            appleId: appleId,
            lineUserId: nil
        )
    }

    static func line(lineUserId: String) -> LinkAccountRequest {
        return LinkAccountRequest(
            accountType: 4,
            googleId: nil,
            email: nil,
            appleId: nil,
            lineUserId: lineUserId
        )
    }
}

// MARK: - Unlink Account Request
struct UnlinkAccountRequest: Encodable {
    let accountType: Int

    enum CodingKeys: String, CodingKey {
        case accountType
    }

    // Factory methods for each account type
    static func google() -> UnlinkAccountRequest {
        return UnlinkAccountRequest(accountType: 2)
    }

    static func apple() -> UnlinkAccountRequest {
        return UnlinkAccountRequest(accountType: 3)
    }

    static func line() -> UnlinkAccountRequest {
        return UnlinkAccountRequest(accountType: 4)
    }
}

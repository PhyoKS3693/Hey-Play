//
//  BaseAPIResponse.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 02/09/26.
//

import Foundation

// MARK: - Base API Response
struct BaseAPIResponse<T: Decodable>: Decodable {
    let responseCode: String
    let responseMessage: String
    let versionUpgradeCode: Int?
    let versionUpgradeTitle: String?
    let versionUpgradeMessage: String?
    let versionUpgradeUrl: String?
    let emptyTitle: String?
    let emptyMessage: String?
    let shortErrorTitle: String?
    let data: T?

    var isSuccess: Bool {
        return responseCode == "1"
    }
}

// MARK: - Empty Data Response (for APIs that don't return data)
struct EmptyData: Decodable {}

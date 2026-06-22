//
//  BaseAPIResponse.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 02/09/26.
//

import Foundation

// MARK: - API Error Detail
struct APIErrorDetail: Decodable {
    let fieldCode: String
    let errorMessage: String
}

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
    let errors: [APIErrorDetail]?
    let data: T?

    var isSuccess: Bool {
        return responseCode == "1"
    }

    var isSessionExpired: Bool {
        return responseCode == "1000" && errors?.contains(where: { $0.fieldCode == "1004" }) == true
    }
}

// MARK: - Empty Data Response (for APIs that don't return data)
struct EmptyData: Decodable {}

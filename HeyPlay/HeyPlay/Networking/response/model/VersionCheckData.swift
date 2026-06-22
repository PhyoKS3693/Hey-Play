//
//  VersionCheckData.swift
//  HeyPlay
//
//  Created by Claude on 18/06/2026.
//

import Foundation

// MARK: - Version Check Response
typealias VersionCheckResponse = BaseAPIResponse<VersionCheckData>

// MARK: - Version Check Data
struct VersionCheckData: Decodable {
    let title: String?
    let message: String?
    let isForceUpdateExist: Bool?
    let isNormalUpdateExist: Bool?
    let storeUrl: String?

    var safeTitle: String {
        return title ?? "Update Available"
    }

    var safeMessage: String {
        return message ?? "A new version of the app is available."
    }

    var safeStoreUrl: String {
        return storeUrl ?? ""
    }

    var needsUpdate: Bool {
        return (isForceUpdateExist == true) || (isNormalUpdateExist == true)
    }

    var isForceUpdate: Bool {
        return isForceUpdateExist == true
    }

    var isNormalUpdate: Bool {
        return isNormalUpdateExist == true
    }
}

//
//  SupportData.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 02/09/26.
//

import Foundation

// MARK: - Support List Response
typealias SupportListResponse = BaseAPIResponse<SupportListData>

// MARK: - Support List Data
struct SupportListData: Decodable {
    let aboutUsLink: String?
    let privacyAndPolicyLink: String?
    let tcLink: String?

    var safeAboutUsLink: String {
        return aboutUsLink ?? ""
    }

    var safePrivacyPolicyLink: String {
        return privacyAndPolicyLink ?? ""
    }

    var safeTermsLink: String {
        return tcLink ?? ""
    }
}

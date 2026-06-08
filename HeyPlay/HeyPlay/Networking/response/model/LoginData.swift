//
//  LoginData.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 02/09/26.
//

import Foundation

// MARK: - Login Response
typealias LoginResponse = BaseAPIResponse<LoginData>

// MARK: - Login Data
struct LoginData: Decodable {
    let id: Int?
    let name: String?
    let account: String?
    let sessionId: String?
    let referralCode: String?
    let profileImage: String?
    let activePlanTypeName: String?
    let activePlanName: String?
    let expiredTime: String?
    let signupType: Int?

    // MARK: - Computed Properties for backward compatibility
    var customerId: String {
        return id != nil ? String(id!) : ""
    }

    var phoneNo: String {
        return account ?? ""
    }

    var subscriptionExpireDate: String {
        return expiredTime ?? ""
    }

    var hasActiveSubscription: Bool {
        return !(activePlanName ?? "").isEmpty
    }
}

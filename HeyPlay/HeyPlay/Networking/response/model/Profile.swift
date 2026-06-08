//
//  Profile.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 03/23/26.
//

import Foundation

// MARK: - Profile Data
struct Profile: Decodable {
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
    var customerId: Int {
        return id ?? 0
    }

    var customerName: String {
        return name ?? ""
    }

    var phoneNumber: String {
        return account ?? ""
    }

    // MARK: - Safe Accessors
    var safeName: String { name ?? "Guest" }
    var safePhone: String { account ?? "" }
    var safePlanName: String {
        if let planName = activePlanName, !planName.isEmpty {
            return planName
        }
        return activePlanTypeName ?? "Free"
    }

    var isLoggedIn: Bool {
        return (id ?? 0) > 0
    }

    var hasActiveSubscription: Bool {
        return !(activePlanName ?? "").isEmpty || !(activePlanTypeName ?? "").isEmpty
    }

    var fullProfileImageURL: String? {
        guard let imagePath = profileImage, !imagePath.isEmpty else { return nil }
        if imagePath.hasPrefix("http") {
            return imagePath
        }
        return "http://103.59.163.3/heyplay-api" + imagePath
    }

    // MARK: - Subscription Status
    var subscriptionStatus: SubscriptionStatus {
        let planName = activePlanName?.lowercased() ?? ""
        let planTypeName = activePlanTypeName?.lowercased() ?? ""

        if planName.contains("premium") || planTypeName.contains("premium") {
            return .premium
        } else if planName.contains("vip") || planTypeName.contains("vip") {
            return .vip
        }
        return .free
    }

    var isVIP: Bool {
        return subscriptionStatus == .vip
    }

    var isPremium: Bool {
        return subscriptionStatus == .premium
    }

    enum SubscriptionStatus {
        case free
        case vip
        case premium

        var displayName: String {
            switch self {
            case .free: return "Free"
            case .vip: return "VIP"
            case .premium: return "Premium"
            }
        }

        var badgeColor: String {
            switch self {
            case .free: return "gray"
            case .vip: return "gold"
            case .premium: return "purple"
            }
        }
    }
}

// MARK: - Type Alias for API Response
typealias ProfileResponse = BaseAPIResponse<Profile>

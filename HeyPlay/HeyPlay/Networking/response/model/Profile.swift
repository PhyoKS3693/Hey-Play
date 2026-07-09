//
//  Profile.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 03/23/26.
//

import Foundation

// MARK: - Profile Data
struct Profile: Decodable, Equatable {
    let id: Int?
    let name: String?
    let account: String?
    let email: String?
    let gender: Int?
    let sessionId: String?
    let referralCode: String?
    let profileImage: String?
    let activePlanTypeName: String?
    let activePlanName: String?
    let expiredTime: String?
    let signupType: Int?
    let registerType: Int?
    let dayLeft: Int?
    let dayLeftDesc: String?
    let isLinkedToGoogle: Bool?
    let isLinkedToApple: Bool?
    let isLinkedToLine: Bool?
    let isLinkedToFacebook: Bool?

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
        // Always show "VIP Package" if user has active subscription
        if hasActiveSubscription {
            return "VIP Package"
        }
        return "Free"
    }

    var isLoggedIn: Bool {
        return (id ?? 0) > 0
    }

    var hasActiveSubscription: Bool {
        // Check if there's an active subscription based on dayLeft and expiredTime
        let daysLeft = dayLeft ?? 0
        let expireTime = expiredTime ?? ""
        return daysLeft > 0 && !expireTime.isEmpty
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

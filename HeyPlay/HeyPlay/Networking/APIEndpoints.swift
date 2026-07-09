//
//  APIEndpoints.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 02/09/26.
//

import Foundation

// MARK: - Base URLs
struct BaseURL {
    static let api = "http://103.59.163.3/heyplay-api"
}

// MARK: - API Endpoints
enum APIEndpoint {

    // MARK: - Home
    case getHomeData
    case playlistDetail

    // MARK: - Search
    case searchContents
    case searchPreload
    case saveSearchHistory

    // MARK: - Content
    case contentDetail
    case contentWatch

    // MARK: - Auth / Login
    case validatePhoneBeforeLogin
    case loginOTPVerify
    case loginWithGoogle
    case loginWithApple
    case loginWithLine
    case registerDeviceToken

    // MARK: - Profile
    case profile
    case profileUpdate
    case linkedAccount
    case unlinkAccount

    // MARK: - Last Watch
    case lastWatchAdd
    case lastWatchDelete
    case lastWatchDeleteAll
    case lastWatchList

    // MARK: - Watch Later
    case watchLaterAdd
    case watchLaterDelete
    case watchLaterDeleteAll
    case watchLaterList

    // MARK: - Support
    case getSupportList

    // MARK: - Redeem Code
    case redeemPromoCode

    // MARK: - Reel
    case reelList

    // MARK: - Subscription Plan
    case subscriptionPlanTypeList
    case subscriptionPlanPreload
    case subscriptionPlanBuy
    case subscriptionPlanHistories

    // MARK: - Notification
    case notificationList
    case notificationDetail

    // MARK: - Favourite
    case favouriteAdd
    case favouriteRemove
    case favouriteList

    // MARK: - Phone Number Change
    case validateNewPhoneForChange
    case updatePhoneNumber

    // MARK: - Version Check
    case checkAppVersion

    // MARK: - Properties
    var path: String {
        switch self {
        // Home
        case .getHomeData:
            return "/api/home/getHomeData"
        case .playlistDetail:
            return "/api/playlist/detail"

        // Search
        case .searchContents:
            return "/api/search/contents"
        case .searchPreload:
            return "/api/search/preload"
        case .saveSearchHistory:
            return "/api/search/saveSearchHistory"

        // Content
        case .contentDetail:
            return "/api/content/detail"
        case .contentWatch:
            return "/api/content/watch"

        // Auth / Login
        case .validatePhoneBeforeLogin:
            return "/api/auth/validate-phone-before-login"
        case .loginOTPVerify:
            return "/api/auth/login/otpVerify"
        case .loginWithGoogle:
            return "/api/auth/login-with-google"
        case .loginWithApple:
            return "/api/auth/login-with-apple"
        case .loginWithLine:
            return "/api/auth/login-with-line"
        case .registerDeviceToken:
            return "/api/auth/register-device-token"

        // Profile
        case .profile:
            return "/api/customer/profile"
        case .profileUpdate:
            return "/api/customer/updateProfile"
        case .linkedAccount:
            return "/api/customer/linkedAccount"
        case .unlinkAccount:
            return "/api/customer/unlinkAccount"

        // Last Watch
        case .lastWatchAdd:
            return "/api/lastWatch/add"
        case .lastWatchDelete:
            return "/api/lastWatch/delete"
        case .lastWatchDeleteAll:
            return "/api/lastWatch/deleteAll"
        case .lastWatchList:
            return "/api/lastWatch/list"

        // Watch Later
        case .watchLaterAdd:
            return "/api/watchLater/add"
        case .watchLaterDelete:
            return "/api/watchLater/delete"
        case .watchLaterDeleteAll:
            return "/api/watchLater/deleteAll"
        case .watchLaterList:
            return "/api/watchLater/list"

        // Support
        case .getSupportList:
            return "/api/getSupportList"

        // Redeem Code
        case .redeemPromoCode:
            return "/api/promocode/redeem"

        // Reel
        case .reelList:
            return "/api/reel/list"

        // Subscription Plan
        case .subscriptionPlanTypeList:
            return "/api/subscription-plan-type/list"
        case .subscriptionPlanPreload:
            return "/api/subscription-plan/preload"
        case .subscriptionPlanBuy:
            return "/api/subscription-plan/buy"
        case .subscriptionPlanHistories:
            return "/api/subscription-plan/histories"

        // Notification
        case .notificationList:
            return "/api/notification/list"
        case .notificationDetail:
            return "/api/notification/detail"

        // Favourite
        case .favouriteAdd:
            return "/api/favourite/add"
        case .favouriteRemove:
            return "/api/favourite/remove"
        case .favouriteList:
            return "/api/favourite/list"

        // Phone Number Change
        case .validateNewPhoneForChange:
            return "/api/customer/validateNewPhoneForPhoneNoChange"
        case .updatePhoneNumber:
            return "/api/customer/updatePhoneNumber"

        // Version Check
        case .checkAppVersion:
            return "/api/check/checkAppVersion"
        }
    }

    var url: String {
        return BaseURL.api + path
    }
}

// MARK: - HTTP Headers
struct APIHeaders {
    static func defaultHeaders(customerId: String, sessionId: String) -> [String: String] {
        let phoneUUID = AppDefaultsManager.shared.phoneUUID
        return [
            "customerId": customerId,
            "sessionId": sessionId,
            "phoneUUID": phoneUUID,
            "Content-Type": "application/json"
        ]
    }

    static func authHeaders(deviceType: String = "2", versionNumber: String = "1.0") -> [String: String] {
        let phoneUUID = AppDefaultsManager.shared.phoneUUID
        return [
            "deviceType": deviceType,
            "versionNumber": versionNumber,
            "phoneUUID": phoneUUID,
            "Content-Type": "application/json"
        ]
    }
}

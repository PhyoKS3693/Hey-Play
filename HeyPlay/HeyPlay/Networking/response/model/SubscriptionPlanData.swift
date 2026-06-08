//
//  SubscriptionPlanData.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 02/09/26.
//

import Foundation

// MARK: - Subscription Plan Type List Response
typealias SubscriptionPlanTypeListResponse = BaseAPIResponse<SubscriptionPlanTypeListData>

// MARK: - Subscription Plan Type List Data (Wrapper)
struct SubscriptionPlanTypeListData: Decodable {
    let subscriptionPlanTypeResponseList: [SubscriptionPlanType]?
}

// MARK: - Subscription Plan Type
struct SubscriptionPlanType: Decodable, Identifiable {
    let id: Int
    let name: String?
    let description: String?

    // Computed properties for UI
    var isVIP: Bool {
        return name?.lowercased().contains("vip") ?? false
    }

    var isFree: Bool {
        return name?.lowercased().contains("free") ?? false
    }

    var displayName: String {
        return name ?? "Plan"
    }

    var badgeText: String {
        return description ?? (isVIP ? "Unlimited" : "Limited")
    }
}

// MARK: - Subscription Preload Response
typealias SubscriptionPreloadResponse = BaseAPIResponse<SubscriptionPreloadData>

// MARK: - Subscription Preload Data
struct SubscriptionPreloadData: Decodable {
    let packageList: [SubscriptionPackage]?
    let paymentMethodList: [PaymentMethod]?
    let currentSubscription: CurrentSubscription?
}

// MARK: - Subscription Package
struct SubscriptionPackage: Decodable, Identifiable {
    let id: Int
    let name: String?
    let description: String?
    let sellingPrice: Double?
    let sellingPriceDesc: String?

    // MARK: - Computed Properties
    var priceDisplay: String {
        return sellingPriceDesc ?? "\(sellingPrice ?? 0) Ks"
    }

    var durationText: String {
        return description ?? name ?? ""
    }
}

// MARK: - Payment Method
struct PaymentMethod: Decodable, Identifiable {
    let id: Int
    let name: String?
    let imagePath: String?

    // MARK: - Computed Properties
    var fullImageURL: String? {
        guard let imagePath = imagePath, !imagePath.isEmpty else { return nil }
        if imagePath.hasPrefix("http") {
            return imagePath
        }
        return "http://103.59.163.3/heyplay-api" + imagePath
    }

    var displayName: String {
        return name ?? "Unknown"
    }
}

// MARK: - Current Subscription
struct CurrentSubscription: Decodable {
    let packageName: String?
    let startDate: String?
    let expiryDate: String?
    let remainingDays: Int?
    let isActive: Bool?
}

// MARK: - Buy Package Response
typealias BuyPackageResponse = BaseAPIResponse<BuyPackageData>

// MARK: - Buy Package Data
struct BuyPackageData: Decodable {
    let purchaseId: String?
    let transactionId: String?
    let packageName: String?
    let amount: String?
    let currency: String?
    let purchaseDate: String?
    let expiryDate: String?
    let paymentUrl: String?
    let status: String?
}

// MARK: - Package History Response
typealias PackageHistoryResponse = BaseAPIResponse<PackageHistoryData>

// MARK: - Package History Data (Wrapper)
struct PackageHistoryData: Decodable {
    let histories: [PackageHistory]
}

// MARK: - Package History
struct PackageHistory: Decodable, Identifiable {
    let transactionId: String
    let transactionTime: String?
    let packageName: String?
    let packageDescription: String?
    let price: Double?
    let priceDesc: String?
    let paymentMethodName: String?
    let duration: Int?
    let durationDisplayText: String?
    let paymentStatus: Int?
    let paymentStatusDesc: String?

    // Computed properties for UI
    var id: String { transactionId }

    var displayPrice: String {
        return priceDesc ?? "\(price ?? 0) Ks"
    }

    var displayDuration: String {
        return durationDisplayText ?? "\(duration ?? 0) Day"
    }

    var displayPaymentMethod: String {
        return paymentMethodName ?? "Unknown"
    }

    var displayTime: String {
        return transactionTime ?? ""
    }

    var displayStatus: String {
        return paymentStatusDesc ?? "Unknown"
    }

    var isPending: Bool {
        return paymentStatus == 1
    }

    var isSuccess: Bool {
        return paymentStatus == 2
    }

    var isFailed: Bool {
        return paymentStatus == 3
    }
}

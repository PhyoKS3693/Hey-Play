//
//  SubscriptionPlanRequest.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 02/09/26.
//

import Foundation

// MARK: - Subscription Plan Type List Request
struct SubscriptionPlanTypeListRequest: Encodable {
    // Empty request body
}

// MARK: - Subscription Plan Preload Request
struct SubscriptionPlanPreloadRequest: Encodable {
    // Empty request body
}

// MARK: - Buy Package Request
struct BuyPackageRequest: Encodable {
    let paymentMethodId: String
    let packageId: String
}

// MARK: - Package History Request
struct PackageHistoryRequest: Encodable {
    let fromDate: String
    let toDate: String

    init(fromDate: String = "", toDate: String = "") {
        self.fromDate = fromDate
        self.toDate = toDate
    }
}

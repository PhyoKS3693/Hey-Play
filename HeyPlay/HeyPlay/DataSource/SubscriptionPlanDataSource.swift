//
//  SubscriptionPlanDataSource.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 11/6/25.
//

import Foundation

struct SubscriptionPlan: Identifiable {
    let id = UUID()
    let title: String // API name as-is (e.g., "VIP" or "Free")
    let badge: String // API description (e.g., "Unlimited" or "Limited")
    let planDescription: String
    let features: [PlanFeature]
    let planTypeId: Int? // Store API plan type ID

    var isVIP: Bool {
        return title.lowercased().contains("vip")
    }

    var isFree: Bool {
        return title.lowercased().contains("free")
    }
}

struct PlanFeature: Identifiable {
    let id = UUID()
    let featureName: String
    let isAvailable: Bool
}



//
//  SubscriptionPlanDataSource.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 11/6/25.
//

import Foundation

struct SubscriptionPlan: Identifiable {
    let id = UUID()
    let title: String
    let badge: String
    let planDescription: String
    let features: [PlanFeature]
}

struct PlanFeature: Identifiable {
    let id = UUID()
    let featureName: String
    let isAvailable: Bool
}



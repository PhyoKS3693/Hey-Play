//
//  SubscriptionViewModel.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 10/24/25.
//

import Foundation
import Combine
import UIKit

final class SubscriptionViewModel: ObservableObject {
    
    @Published var subscriptionPlans: [SubscriptionPlan] = [
        
        // FREE PLAN
        SubscriptionPlan(
            title: "Free Plan",
            badge: "Limited",
            planDescription: "Enjoy HeyPlay for free! Watch a wide selection of movies and TV shows with ads.",
            features: [
                PlanFeature(featureName: "Access to selected movies & TV shows", isAvailable: true),
                PlanFeature(featureName: "Watch with ads", isAvailable: true),
                PlanFeature(featureName: "Limited episodes for series", isAvailable: true),
                PlanFeature(featureName: "No exclusive content", isAvailable: false),
                PlanFeature(featureName: "No early access", isAvailable: false)
            ]
        ),
        
        // VIP PLAN
        SubscriptionPlan(
            title: "VIP Plan",
            badge: "Unlimited",
            planDescription: "Go VIP and unlock exclusive shows, all episodes, and new releases without ads.",
            features: [
                PlanFeature(featureName: "All Free Plan features", isAvailable: true),
                PlanFeature(featureName: "Unlimited access to HeyPlay VIP content", isAvailable: true),
                PlanFeature(featureName: "No ads - smooth watching", isAvailable: true),
                PlanFeature(featureName: "Early access to new releases", isAvailable: true),
                PlanFeature(featureName: "Exclusive movies & early releases", isAvailable: true)
            ]
        )
    ]
}

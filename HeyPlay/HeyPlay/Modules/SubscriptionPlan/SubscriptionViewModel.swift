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

    // MARK: - Published Properties
    @Published var subscriptionPlans: [SubscriptionPlan] = []
    @Published var planTypes: [SubscriptionPlanType] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    // MARK: - API Call
    func fetchSubscriptionPlanTypes() {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil

        Task { @MainActor in
            let result = await SubscriptionPlanService.shared.getSubscriptionPlanTypeList()

            isLoading = false

            switch result {
            case .success(let planTypes):
                self.planTypes = planTypes
                self.convertToSubscriptionPlans(planTypes)
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                // Fallback to default plans on error
                self.loadDefaultPlans()
            }
        }
    }

    // MARK: - Convert API Data to UI Model
    private func convertToSubscriptionPlans(_ planTypes: [SubscriptionPlanType]) {
        subscriptionPlans = planTypes.map { planType in
            let isVIP = planType.isVIP

            print("📦 Converting plan - ID: \(planType.id), Name: \(planType.name ?? ""), Description: \(planType.description ?? "")")
            print("   → Display Name: \(planType.displayName), Badge: \(planType.badgeText), isVIP: \(isVIP)")

            return SubscriptionPlan(
                title: planType.displayName, // Uses API name as-is (e.g., "VIP" or "Free")
                badge: planType.badgeText, // Uses API description (e.g., "Unlimited" or "Limited")
                planDescription: isVIP
                    ? "Go VIP and unlock exclusive shows, all episodes, and new releases without ads."
                    : "Enjoy HeyPlay for free! Watch a wide selection of movies and TV shows with ads.",
                features: isVIP ? vipFeatures() : freeFeatures(),
                planTypeId: planType.id // Store API ID for reference
            )
        }

        print("✅ Total plans converted: \(subscriptionPlans.count)")
    }

    // MARK: - Feature Lists
    private func freeFeatures() -> [PlanFeature] {
        return [
            PlanFeature(featureName: "Access to selected movies & TV shows", isAvailable: true),
            PlanFeature(featureName: "Watch with ads", isAvailable: true),
            PlanFeature(featureName: "Limited episodes for series", isAvailable: true),
            PlanFeature(featureName: "No exclusive content", isAvailable: false),
            PlanFeature(featureName: "No early access", isAvailable: false)
        ]
    }

    private func vipFeatures() -> [PlanFeature] {
        return [
            PlanFeature(featureName: "All Free Plan features", isAvailable: true),
            PlanFeature(featureName: "Unlimited access to HeyPlay VIP content", isAvailable: true),
            PlanFeature(featureName: "No ads - smooth watching", isAvailable: true),
            PlanFeature(featureName: "Early access to new releases", isAvailable: true),
            PlanFeature(featureName: "Exclusive movies & early releases", isAvailable: true)
        ]
    }

    // MARK: - Fallback Default Plans
    private func loadDefaultPlans() {
        subscriptionPlans = [
            // FREE PLAN
            SubscriptionPlan(
                title: "Free",
                badge: "Limited",
                planDescription: "Enjoy HeyPlay for free! Watch a wide selection of movies and TV shows with ads.",
                features: freeFeatures(),
                planTypeId: 1
            ),

            // VIP PLAN
            SubscriptionPlan(
                title: "VIP",
                badge: "Unlimited",
                planDescription: "Go VIP and unlock exclusive shows, all episodes, and new releases without ads.",
                features: vipFeatures(),
                planTypeId: 2
            )
        ]
    }
}

//
//  MenuViewModel.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 10/23/25.
//

import Foundation
import Combine
import UIKit

final class MenuViewModel: ObservableObject {

    // MARK: - Published Properties
    @Published var profile: Profile?
    @Published var isLoading: Bool = false
    @Published var sections: [MenuSettingsSectionData] = []

    // MARK: - Computed Properties
    var isLoggedIn: Bool {
        return AppDefaultsManager.shared.isLoggedIn
    }

    var userName: String {
        return profile?.safeName ?? "Guest"
    }

    var userPhone: String {
        return profile?.safePhone ?? ""
    }

    var userId: String {
        if let customerId = profile?.customerId {
            return "HP\(customerId)"
        }
        return ""
    }

    var isVIP: Bool {
        return profile?.isVIP ?? false
    }

    var isPremium: Bool {
        return profile?.isPremium ?? false
    }

    var hasActiveSubscription: Bool {
        // Use Profile's hasActiveSubscription which checks dayLeft > 0 and expiredTime not empty
        return profile?.hasActiveSubscription ?? false
    }

    var subscriptionPlanName: String {
        return profile?.safePlanName ?? "Free"
    }

    var expiredTime: String {
        return profile?.expiredTime ?? ""
    }

    var profileImageURL: String? {
        return profile?.fullProfileImageURL
    }

    // Get days remaining from API response (dayLeft field)
    var daysRemaining: Int {
        return profile?.dayLeft ?? 0
    }

    var daysRemainingText: String {
        return "\(daysRemaining) Days"
    }

    // MARK: - Init
    init() {
        updateSections()
        if isLoggedIn {
            fetchProfile()
        }
    }

    // MARK: - Update Sections based on Login Status
    func updateSections() {
        if isLoggedIn {
            // Logged in user sees all menu items
            sections = [
                MenuSettingsSectionData(
                    section: .general,
                    items: [.profile, .changePhone, .watchlist, .subscription, .vipHistory, .redemption]
                ),
                MenuSettingsSectionData(
                    section: .help,
                    items: [.policies, .about]
                )
            ]
        } else {
            // Guest user sees only Help section (Policies, About Us)
            sections = [
                MenuSettingsSectionData(
                    section: .help,
                    items: [.policies, .about]
                )
            ]
        }
    }

    // MARK: - Fetch Profile
    func fetchProfile() {
        guard isLoggedIn else {
            profile = nil
            updateSections()
            return
        }

        isLoading = true

        Task { @MainActor in
            let result = await ProfileService.shared.getProfile()

            isLoading = false

            switch result {
            case .success(let data):
                self.profile = data
                self.updateSections()
            case .failure(let error):
                print("Error fetching profile: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Logout
    func logout() {
        AppDefaultsManager.shared.logout()
        profile = nil
        updateSections()
        ViewNavigation.shared.showLoginView()
    }

    // MARK: - Copy User ID
    func copyUserId() {
        UIPasteboard.general.string = userId
    }
}

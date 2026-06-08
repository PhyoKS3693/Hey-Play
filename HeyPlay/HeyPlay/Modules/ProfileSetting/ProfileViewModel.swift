//
//  ProfileViewModel.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 10/24/25.
//

import Foundation
import Combine
import UIKit

final class ProfileViewModel: ObservableObject {

    // MARK: - Published Properties
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var profile: Profile?

    // MARK: - Computed Properties
    var isLoggedIn: Bool {
        return AppDefaultsManager.shared.isLoggedIn
    }

    var userName: String {
        return profile?.safeName ?? "Guest"
    }

    var userPlan: String {
        return profile?.safePlanName ?? "Free"
    }

    var profileImageURL: String? {
        return profile?.fullProfileImageURL
    }

    var subscriptionStatus: Profile.SubscriptionStatus {
        return profile?.subscriptionStatus ?? .free
    }

    // MARK: - API Calls
    func fetchProfile() {
        guard isLoggedIn else {
            profile = nil
            return
        }

        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil

        Task { @MainActor in
            let result = await ProfileService.shared.getProfile()

            isLoading = false

            switch result {
            case .success(let data):
                self.profile = data
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }

    // MARK: - Logout
    func logout() {
        AppDefaultsManager.shared.logout()
        profile = nil
        ViewNavigation.shared.showLoginView()
    }
}

//
//  PoliciesViewModel.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 10/24/25.
//

import Foundation
import Combine
import UIKit

final class PoliciesViewModel: ObservableObject {

    // MARK: - Published Properties
    @Published var privacyPolicyURL: String = ""
    @Published var termsURL: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    // MARK: - Fetch Support Links
    func fetchSupportLinks() {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil

        Task { @MainActor in
            let result = await SupportService.shared.getSupportList()

            isLoading = false

            switch result {
            case .success(let data):
                self.privacyPolicyURL = data.safePrivacyPolicyLink
                self.termsURL = data.safeTermsLink
                print("✅ Privacy Policy URL fetched: \(self.privacyPolicyURL)")
                print("✅ Terms & Conditions URL fetched: \(self.termsURL)")
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                print("❌ Failed to fetch support links: \(error.localizedDescription)")
            }
        }
    }
}

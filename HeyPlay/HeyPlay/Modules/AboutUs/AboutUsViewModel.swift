//
//  AboutUsViewModel.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 10/24/25.
//

import Foundation
import Combine
import UIKit

final class AboutUsViewModel: ObservableObject {

    // MARK: - Published Properties
    @Published var aboutUsURL: String = ""
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
                self.aboutUsURL = data.safeAboutUsLink
                print("✅ About Us URL fetched: \(self.aboutUsURL)")
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                print("❌ Failed to fetch support links: \(error.localizedDescription)")
            }
        }
    }
}

//
//  PlanViewModel.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 11/6/25.
//

import Foundation
import Combine

final class PlanViewModel: ObservableObject {

    // MARK: - Package Info
    @Published var packageName: String = ""
    @Published var packageType: String = ""
    @Published var chargedAmount: String = ""
    @Published var packageId: Int?

    // MARK: - Payment Methods
    @Published var paymentMethods: [PaymentMethod] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    // MARK: - Fetch Payment Methods
    func fetchPaymentMethods() {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil

        Task { @MainActor in
            let result = await SubscriptionPlanService.shared.getSubscriptionPlanPreload()

            isLoading = false

            switch result {
            case .success(let data):
                self.paymentMethods = data.paymentMethodList ?? []
                print("✅ Fetched \(self.paymentMethods.count) payment methods")
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                print("❌ Failed to fetch payment methods: \(error.localizedDescription)")
            }
        }
    }
}

//
//  BuyPlanViewModel.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 11/8/25.
//

import Foundation
import Combine

final class BuyPlanViewModel: ObservableObject {

    // MARK: - Package Info
    var packageId: Int?
    var packageName: String = ""
    var packageType: String = ""
    var chargedAmount: String = ""

    // MARK: - Payment Methods
    @Published var paymentMethods: [PaymentMethod] = []
    @Published var selectedPaymentMethod: PaymentMethod?

    // MARK: - Payment Method Info (for backward compatibility)
    var paymentMethodId: Int? {
        return selectedPaymentMethod?.id
    }
    var paymentMethodName: String {
        return selectedPaymentMethod?.displayName ?? ""
    }
    var paymentMethodIcon: String {
        return selectedPaymentMethod?.fullImageURL ?? ""
    }

    // MARK: - User Info
    var phoneNumber: String {
        return AppDefaultsManager.shared.phoneNumber ?? ""
    }

    // MARK: - State
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var purchaseSuccess: Bool = false
    @Published var paymentUrl: String?

    // MARK: - Fetch Payment Methods
    func fetchPaymentMethods() async {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }

        let result = await SubscriptionPlanService.shared.getSubscriptionPlanPreload()

        await MainActor.run {
            isLoading = false

            switch result {
            case .success(let data):
                self.paymentMethods = data.paymentMethodList ?? []
                // Auto-select first payment method if available
                if let firstMethod = self.paymentMethods.first {
                    self.selectedPaymentMethod = firstMethod
                }
                print("✅ Fetched \(self.paymentMethods.count) payment methods")
                // Debug: Print all payment method names
                for method in self.paymentMethods {
                    print("💳 Payment Method: ID=\(method.id), Name=\(method.name ?? "nil"), DisplayName=\(method.displayName)")
                }
            case .failure(let error):
                print("❌ Failed to fetch payment methods: \(error.localizedDescription)")
                self.errorMessage = error.localizedDescription
            }
        }
    }

    // MARK: - Buy Package
    func buyPackage() async {
        guard let packageId = packageId, let paymentMethodId = paymentMethodId else {
            await MainActor.run {
                self.errorMessage = "Please select a payment method"
            }
            return
        }

        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }

        print("🛒 Buying package - PackageID: \(packageId), PaymentMethodID: \(paymentMethodId)")

        let result = await SubscriptionPlanService.shared.buyPackage(
            paymentMethodId: "\(paymentMethodId)",
            packageId: "\(packageId)"
        )

        await MainActor.run {
            isLoading = false

            switch result {
            case .success(let data):
                print("✅ Purchase successful - PaymentURL: \(data.paymentUrl ?? "nil")")
                self.paymentUrl = data.paymentUrl
                self.purchaseSuccess = true

                // Notify Home tab to refresh user info
                NotificationCenter.default.post(name: NSNotification.Name("SubscriptionChanged"), object: nil)

            case .failure(let error):
                print("❌ Purchase failed: \(error.localizedDescription)")
                self.errorMessage = error.localizedDescription
            }
        }
    }
}

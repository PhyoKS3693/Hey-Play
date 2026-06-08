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

    // MARK: - Payment Method Info
    var paymentMethodId: Int?
    var paymentMethodName: String = ""
    var paymentMethodIcon: String = ""

    // MARK: - User Info
    var phoneNumber: String {
        return AppDefaultsManager.shared.phoneNumber ?? ""
    }

    // MARK: - State
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var purchaseSuccess: Bool = false
    @Published var paymentUrl: String?

    // MARK: - Buy Package
    func buyPackage() async {
        guard let packageId = packageId, let paymentMethodId = paymentMethodId else {
            await MainActor.run {
                self.errorMessage = "Missing package or payment method information"
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
            case .failure(let error):
                print("❌ Purchase failed: \(error.localizedDescription)")
                self.errorMessage = error.localizedDescription
            }
        }
    }
}

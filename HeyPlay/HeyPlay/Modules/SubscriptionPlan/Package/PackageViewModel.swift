//
//  PackageViewModel.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 11/6/25.
//

import Foundation
import Combine

final class PackageViewModel: ObservableObject {

    // MARK: - Published Properties
    @Published var packagePlans: [PackagePlan] = []
    @Published var paymentMethods: [PaymentMethod] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    // MARK: - Selected Package
    @Published var selectedPackageId: Int?
    @Published var selectedPackageName: String = ""
    @Published var selectedPackageType: String = ""
    @Published var selectedPackageAmount: String = ""

    // MARK: - API Call
    func fetchSubscriptionPreload() {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil

        Task { @MainActor in
            let result = await SubscriptionPlanService.shared.getSubscriptionPlanPreload()

            isLoading = false

            switch result {
            case .success(let data):
                self.convertPackages(data.packageList ?? [])
                self.paymentMethods = data.paymentMethodList ?? []
                print("✅ Fetched \(self.packagePlans.count) packages and \(self.paymentMethods.count) payment methods")
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                print("❌ Failed to fetch preload: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Convert API Data
    private func convertPackages(_ packages: [SubscriptionPackage]) {
        packagePlans = packages.map { package in
            let icon = getPackageIcon(for: package.name ?? "")

            return PackagePlan(
                packageId: package.id,
                packageName: package.name ?? "",
                packageBilledType: package.description ?? "",
                packageChargedAmount: package.sellingPriceDesc ?? "\(package.sellingPrice ?? 0) Ks",
                packageIcon: icon
            )
        }

        // Auto-select first package
        if let firstPackage = packagePlans.first {
            selectedPackageId = firstPackage.packageId
            selectedPackageName = firstPackage.packageName
            selectedPackageType = firstPackage.packageBilledType
            selectedPackageAmount = firstPackage.packageChargedAmount
        }
    }

    // MARK: - Get Package Icon
    private func getPackageIcon(for name: String) -> String {
        let lowercased = name.lowercased()

        if lowercased.contains("1 day") || lowercased.contains("daily") {
            return "ic_daily_package_calender"
        } else if lowercased.contains("7 day") || lowercased.contains("weekly") {
            return "ic_weekly_package_calender"
        } else if lowercased.contains("30 day") || lowercased.contains("month") && !lowercased.contains("+") {
            return "ic_monthly_package_calender"
        } else if lowercased.contains("3") && lowercased.contains("+") {
            return "ic_3+1_package_calender"
        } else if lowercased.contains("6") && lowercased.contains("+") {
            return "ic_6+2_package_calender"
        } else if lowercased.contains("year") {
            return "ic_yearly_package_calender"
        } else {
            return "ic_monthly_package_calender"
        }
    }
}

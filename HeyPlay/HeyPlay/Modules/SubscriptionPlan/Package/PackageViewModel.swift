//
//  PackageViewModel.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 11/6/25.
//

import Foundation

enum Package: String, Hashable {
    case monthly_usd = "Monthly Subscription"
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
    case threePlusOne = "3 Months + 1 Month Free"
    case sixPlusTwo = "6 Months + 2 Months Free"
    case yearly = "Yearly"
}

final class PackageViewModel: ObservableObject {
    
    @Published var packagePlans: [PackagePlan] = [
        PackagePlan(
            packageName: "Monthly Subscription",
            packageBilledType: "Billed monthly",
            packageChargedAmount: "$2.99 USD",
            packageIcon: "ic_monthly_package_calender"),
        PackagePlan(
            packageName: "Daily",
            packageBilledType: "Billed daily",
            packageChargedAmount: "300 MMK",
            packageIcon: "ic_daily_package_calender"),
        PackagePlan(
            packageName: "Weekly",
            packageBilledType: "Billed weekly",
            packageChargedAmount: "1,500 MMK",
            packageIcon: "ic_weekly_package_calender"),
        PackagePlan(
            packageName: "Monthly",
            packageBilledType: "Billed monthly",
            packageChargedAmount: "3,000 MMK",
            packageIcon: "ic_monthly_package_calender"),
        PackagePlan(
            packageName: "3 Months + 1 Month Free",
            packageBilledType: "Billed in 3 months",
            packageChargedAmount: "9,000 MMK",
            packageIcon: "ic_3+1_package_calender"),
        PackagePlan(
            packageName: "6 Months + 2 Months Free",
            packageBilledType: "Billed in 6 months",
            packageChargedAmount: "18,000 MMK",
            packageIcon: "ic_6+2_package_calender"),
        PackagePlan(
            packageName: "Yearly",
            packageBilledType: "Billed in 1 year",
            packageChargedAmount: "36,000 MMK",
            packageIcon: "ic_yearly_package_calender")
    ]
    
    @Published var selectedPackageName: String = Package.daily.rawValue
    @Published var selectedPackageType: String = "Billed daily"
    @Published var selectedPackageAmount: String = "300 MMK"
}

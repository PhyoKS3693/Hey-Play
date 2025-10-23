//
//  MenuDataSource.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 10/23/25.
//

import Foundation

struct MenuSettingsSectionData: Identifiable {
    let id = UUID()
    let section: MenuSection
    let items: [MenuItem]
}

enum MenuSection: String, CaseIterable {
    case general = "General"
    case help = "Help"
}

enum MenuItem: Identifiable {
    var id: String { displayName }
    
    case profile
    case changePhone
    case watchlist
    case subscription
    case vipHistory
    case redemption
    case policies
    case about
    
    var displayName: String {
        switch self {
            case .profile: return "Profile Setting"
            case .changePhone: return "Change Phone Number"
            case .watchlist: return "Watchlist"
            case .subscription: return "Subscription Plan"
            case .vipHistory: return "VIP History"
            case .redemption: return "Redemption Code"
            case .policies: return "Policies"
            case .about: return "About Us"
        }
    }
    
    var diaplayIcon: String {
        switch self {
            case .profile: return "menu_profile"
            case .changePhone: return "menu_phone"
            case .watchlist: return "menu_watchlist"
            case .subscription: return "menu_subscription_plan"
            case .vipHistory: return "menu_vip_history"
            case .redemption: return "menu_redeem_code"
            case .policies: return "menu_policies"
            case .about: return "menu_about_us"
        }
    }
}

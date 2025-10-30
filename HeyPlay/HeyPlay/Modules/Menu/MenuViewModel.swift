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
    
    @Published var sections: [MenuSettingsSectionData] = [
        MenuSettingsSectionData(
            section: .general,
            items: [.profile, .changePhone, .watchlist, .subscription, .vipHistory, .redemption]),
        MenuSettingsSectionData(
            section: .help,
            items: [.policies, .about])
    ]
}

//
//  NotificationViewModel.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 30/10/2025.
//

import Foundation
import Combine
import UIKit

final class NotificationViewModel: ObservableObject {
    var notificationItems = [NotificationItem]()
    init () {
        for index in 0..<10 {
            notificationItems.append(
                NotificationItem(
                    title: "Notifiation \(index)",
                    message: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.... ")
            )
        }
    }
}

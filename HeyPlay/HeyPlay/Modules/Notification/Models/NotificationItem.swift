//
//  NotificationItem.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 30/10/2025.
//

import Foundation

struct NotificationItem: Identifiable {
    var id: String = UUID().uuidString
    var title: String?
    var message: String?
    var date: Date? = Date()
}

//
//  NotificationDetailViewModel.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 05/11/2025.
//

import Foundation
import SwiftUI
import Combine

final class NotificationDetailViewModel: ObservableObject {

    @Published var notificationDetail: APINotificationDetail?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

}

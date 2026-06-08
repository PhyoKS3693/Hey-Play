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

    // MARK: - Published Properties
    @Published var isLoading: Bool = false
    @Published var isLoadingMore: Bool = false
    @Published var errorMessage: String?
    @Published var notifications: [APINotification] = []

    // MARK: - Pagination
    private var currentPage: Int = 1
    private var hasMoreData: Bool = true

    // MARK: - Computed Properties
    var unreadCount: Int {
        return notifications.filter { !$0.isRead }.count
    }

    // MARK: - Legacy Support (for existing UI)
    var notificationItems: [NotificationItem] {
        // Convert APINotification to NotificationItem for backward compatibility
        return notifications.map { apiNotification in
            NotificationItem(
                title: apiNotification.title,
                message: apiNotification.plainMessage,
                date: nil
            )
        }
    }

    // MARK: - Computed Properties
    var notificationCount: Int {
        return notifications.count
    }

    var canLoadMore: Bool {
        return hasMoreData && !isLoadingMore
    }

    // MARK: - Get Notification at Index
    func getNotification(at index: Int) -> APINotification? {
        guard index < notifications.count else { return nil }
        return notifications[index]
    }

    // MARK: - API Calls
    func fetchNotifications() {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil
        currentPage = 1

        Task { @MainActor in
            let result = await NotificationService.shared.getNotificationList(pageNo: currentPage)

            isLoading = false

            switch result {
            case .success(let data):
                self.notifications = data.notificationList ?? []
                self.hasMoreData = !(data.notificationList ?? []).isEmpty
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }

    // MARK: - Refresh Data (Pull to Refresh)
    func refreshData() {
        currentPage = 1
        hasMoreData = true
        fetchNotifications()
    }

    // MARK: - Load More Data (Pagination)
    func loadMoreData() {
        guard canLoadMore && !isLoading else { return }

        isLoadingMore = true
        currentPage += 1

        Task { @MainActor in
            let result = await NotificationService.shared.getNotificationList(pageNo: currentPage)

            isLoadingMore = false

            switch result {
            case .success(let data):
                let newNotifications = data.notificationList ?? []
                self.notifications.append(contentsOf: newNotifications)
                self.hasMoreData = !newNotifications.isEmpty
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.currentPage -= 1 // Revert page on failure
            }
        }
    }

    // MARK: - Get Notification Detail
    func getNotificationDetail(notiId: Int) async -> APINotificationDetail? {
        let result = await NotificationService.shared.getNotificationDetail(
            notiId: notiId,
            notiHistoryFlag: 0
        )

        switch result {
        case .success(let detail):
            return detail
        case .failure(let error):
            self.errorMessage = error.localizedDescription
            return nil
        }
    }

}

//
//  NotificationData.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 02/09/26.
//

import Foundation

// MARK: - Notification Type Enum
enum NotificationType: Int {
    case normal = 1      // Announcements - No redirection
    case movie = 2       // Movie Detail Screen
    case series = 3      // Series Detail Screen

    var description: String {
        switch self {
        case .normal: return "Announcements"
        case .movie: return "Movie Detail Screen"
        case .series: return "Series Detail Screen"
        }
    }
}

// MARK: - Notification List Response
typealias NotificationListResponse = BaseAPIResponse<NotificationListData>

// MARK: - Notification List Data
struct NotificationListData: Decodable {
    let notificationList: [APINotification]?
}

// MARK: - API Notification
struct APINotification: Decodable, Identifiable {
    let id: Int
    let title: String?
    let message: String?
    let listingImage: String?
    let categoryName: String?
    let notiHistoryFlag: String?
    let notificationType: Int?
    let notificationTypeDesc: String?
    let detailViewName: String?
    let detailViewId: Int?
    let actionLabel: String?
    let episodeViewName: String?
    let episodeId: Int?
    let createdTime: String?

    var isRead: Bool {
        return notiHistoryFlag == "1"
    }

    var fullImageURL: String? {
        guard let listingImage = listingImage, !listingImage.isEmpty else { return nil }
        if listingImage.hasPrefix("http") {
            return listingImage
        }
        return "http://103.59.163.3/heyplay-api" + listingImage
    }

    // For HTML content stripping
    var plainMessage: String {
        return message?.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil) ?? ""
    }

    var type: NotificationType? {
        guard let notificationType = notificationType else { return nil }
        return NotificationType(rawValue: notificationType)
    }

    // Navigation helper
    func navigate() {
        guard let type = type else {
            print("⚠️ [Notification] Unknown notification type")
            return
        }

        switch type {
        case .normal:
            // No redirection for announcements
            print("📢 [Notification] Announcement notification - no redirection")
            return

        case .movie:
            // Navigate to movie detail
            guard let detailViewId = detailViewId else {
                print("⚠️ [Notification] Movie notification missing detailViewId")
                return
            }
            print("🎬 [Notification] Navigating to movie detail: \(detailViewId)")
            ViewNavigation.shared.showMovieDetail(detailType: .movie, movieId: detailViewId)

        case .series:
            // Navigate to series detail
            guard let detailViewId = detailViewId else {
                print("⚠️ [Notification] Series notification missing detailViewId")
                return
            }
            print("📺 [Notification] Navigating to series detail: \(detailViewId)")

            if let episodeId = episodeId {
                // TODO: Navigate with episode auto-selection
                print("📺 [Notification] Should auto-select episode: \(episodeId)")
                ViewNavigation.shared.showMovieDetail(detailType: .series, movieId: detailViewId)
            } else {
                ViewNavigation.shared.showMovieDetail(detailType: .series, movieId: detailViewId)
            }
        }
    }
}

// MARK: - Notification Detail Response
typealias NotificationDetailResponse = BaseAPIResponse<APINotificationDetail>

// MARK: - API Notification Detail
struct APINotificationDetail: Decodable {
    let id: Int?
    let title: String?
    let message: String?
    let detailImage: String?
    let createdTime: String?
    let notiCategoryId: Int?
    let notiCategoryName: String?
    let notificationType: Int?
    let notificationTypeDesc: String?
    let detailViewName: String?
    let detailViewId: Int?
    let webUrlOpenTypeDesc: String?
    let actionLabel: String?
    let episodeViewName: String?
    let episodeId: Int?
    let detailEpisodeId: Int?

    var fullImageURL: String? {
        guard let detailImage = detailImage, !detailImage.isEmpty else { return nil }
        if detailImage.hasPrefix("http") {
            return detailImage
        }
        return "http://103.59.163.3/heyplay-api" + detailImage
    }

    // For HTML content stripping
    var plainMessage: String {
        return message?.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil) ?? ""
    }

    var type: NotificationType? {
        guard let notificationType = notificationType else { return nil }
        return NotificationType(rawValue: notificationType)
    }

    // Navigation helper
    func navigate() {
        guard let type = type else {
            print("⚠️ [Notification] Unknown notification type")
            return
        }

        switch type {
        case .normal:
            // No redirection for announcements
            print("📢 [Notification] Announcement notification - no redirection")
            return

        case .movie:
            // Navigate to movie detail
            guard let detailViewId = detailViewId else {
                print("⚠️ [Notification] Movie notification missing detailViewId")
                return
            }
            print("🎬 [Notification] Navigating to movie detail: \(detailViewId)")
            ViewNavigation.shared.showMovieDetail(detailType: .movie, movieId: detailViewId)

        case .series:
            // Navigate to series detail
            guard let detailViewId = detailViewId else {
                print("⚠️ [Notification] Series notification missing detailViewId")
                return
            }
            print("📺 [Notification] Navigating to series detail: \(detailViewId)")

            // Use episodeId first, fallback to detailEpisodeId
            let episodeToSelect = episodeId ?? detailEpisodeId

            if let episodeId = episodeToSelect {
                // TODO: Navigate with episode auto-selection
                print("📺 [Notification] Should auto-select episode: \(episodeId)")
                ViewNavigation.shared.showMovieDetail(detailType: .series, movieId: detailViewId)
            } else {
                ViewNavigation.shared.showMovieDetail(detailType: .series, movieId: detailViewId)
            }
        }
    }
}

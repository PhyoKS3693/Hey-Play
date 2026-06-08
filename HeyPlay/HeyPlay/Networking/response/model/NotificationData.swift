//
//  NotificationData.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 02/09/26.
//

import Foundation

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
    let actionLabel: String?
    let episodeViewName: String?
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
    let webUrlOpenTypeDesc: String?
    let actionLabel: String?
    let episodeViewName: String?
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
}

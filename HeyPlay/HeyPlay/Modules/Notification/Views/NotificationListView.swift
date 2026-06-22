//
//  NotificationListView.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 30/10/2025.
//

import Foundation
import SwiftUI
import Combine

struct NotificationListView : View {
    @ObservedObject var viewModel : NotificationViewModel

    init(_ viewmodel : NotificationViewModel) {
        // Remove default separators and background
        viewModel = viewmodel
        UITableView.appearance().separatorStyle = .none
        UITableView.appearance().backgroundColor = UIColor.black
        UITableViewCell.appearance().backgroundColor = UIColor.black
    }

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.notifications) { notification in
                    NotificationItemCard(notification: notification)
                        .onTapGesture {
                            handleNotificationTap(notification)
                        }
                        .onAppear {
                            // Load more when reaching last item
                            if notification.id == viewModel.notifications.last?.id {
                                viewModel.loadMoreData()
                            }
                        }
                }

                if viewModel.isLoadingMore {
                    HStack {
                        Spacer()
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .padding()
                        Spacer()
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
    }

    // MARK: - Handle Notification Tap
    private func handleNotificationTap(_ notification: APINotification) {
        print("📬 [NotificationList] Tapped notification: \(notification.id)")

        guard let type = notification.type else {
            print("⚠️ [NotificationList] Unknown notification type, showing detail")
            // Fallback to detail screen for unknown types
            Task {
                if let detail = await viewModel.getNotificationDetail(notiId: notification.id) {
                    await MainActor.run {
                        ViewNavigation.shared.showNotificationDetail(notificationDetail: detail)
                    }
                }
            }
            return
        }

        print("📬 [NotificationList] Notification type: \(type.description)")

        switch type {
        case .normal:
            // Announcements - Show notification detail screen
            Task {
                if let detail = await viewModel.getNotificationDetail(notiId: notification.id) {
                    await MainActor.run {
                        ViewNavigation.shared.showNotificationDetail(notificationDetail: detail)
                    }
                }
            }

        case .movie:
            // Movie Detail - Navigate directly to movie detail screen
            guard let detailViewId = notification.detailViewId else {
                print("⚠️ [NotificationList] Movie notification missing detailViewId")
                return
            }
            print("🎬 [NotificationList] Navigating to movie detail: \(detailViewId)")
            ViewNavigation.shared.showMovieDetail(detailType: .movie, movieId: detailViewId)

        case .series:
            // Series Detail - Navigate directly to series detail screen
            guard let detailViewId = notification.detailViewId else {
                print("⚠️ [NotificationList] Series notification missing detailViewId")
                return
            }
            print("📺 [NotificationList] Navigating to series detail: \(detailViewId)")

            if let episodeId = notification.episodeId {
                print("📺 [NotificationList] Should auto-select episode: \(episodeId)")
                // TODO: Pass episode ID for auto-selection
                ViewNavigation.shared.showMovieDetail(detailType: .series, movieId: detailViewId)
            } else {
                ViewNavigation.shared.showMovieDetail(detailType: .series, movieId: detailViewId)
            }
        }
    }
}

// MARK: - Notification Item Card (Matches Design)
struct NotificationItemCard: View {
    let notification: APINotification

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Category Icon
            notificationIcon
                .font(.system(size: 28))
                .foregroundColor(.white)
                .frame(width: 48, height: 48)

            // Content
            VStack(alignment: .leading, spacing: 8) {
                // Title and Date Row
                HStack(alignment: .top) {
                    Text(notification.categoryName ?? notification.notificationTypeDesc ?? "Notification")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .lineLimit(1)

                    Spacer()

                    // Date and Time
                    if let createdTime = notification.createdTime {
                        Text(createdTime)
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.7))
                            .lineLimit(1)
                    }
                }

                // Message Preview
                Text(notification.plainMessage)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.8))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(red: 0.2, green: 0.2, blue: 0.2))
        )
    }

    // Icon based on notification type
    @ViewBuilder
    private var notificationIcon: some View {
        let category = notification.categoryName?.lowercased() ?? ""
        let type = notification.notificationTypeDesc?.lowercased() ?? ""

        if category.contains("account") || category.contains("updated") {
            Image(systemName: "bell")
        } else if category.contains("announcement") || type.contains("announcement") {
            Image(systemName: "tag")
        } else if category.contains("expired") || type.contains("expired") {
            Image(systemName: "clock.badge.exclamationmark")
        } else if category.contains("success") || type.contains("success") {
            Image(systemName: "checkmark.circle")
        } else if category.contains("error") || type.contains("error") {
            Image(systemName: "exclamationmark.circle")
        } else if category.contains("movie") || type.contains("movie") {
            Image(systemName: "play.rectangle")
        } else if category.contains("series") || type.contains("series") {
            Image(systemName: "play.rectangle")
        } else if category.contains("version") || category.contains("update") {
            Image(systemName: "arrow.triangle.2.circlepath")
        } else {
            Image(systemName: "bell")
        }
    }
}

#Preview {
    NotificationListView(
        NotificationViewModel()
    )
}


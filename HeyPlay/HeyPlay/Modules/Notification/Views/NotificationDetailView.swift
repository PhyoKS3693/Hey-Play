//
//  NotificationDetailView.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 31/10/2025.
//

import Foundation
import SwiftUI


struct NotificationDetailView: View {

    var host: HostController?
    var onBack: (() -> Void)?

    @ObservedObject private var viewModel: NotificationDetailViewModel

    init(_ viewModel: NotificationDetailViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 0) {
            Spacer()
                .frame(height: 50)

            // Custom Navigation Bar
            HStack {
                Button(action: {
                    onBack?()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .padding()
                }

                Spacer()

                Text("Notification Detail")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)

                Spacer()

                // Invisible button for balance
                Button(action: {}) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20))
                        .foregroundColor(.clear)
                        .padding()
                }
            }
            .background(Color.black)

            if let detail = viewModel.notificationDetail {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Image (if available)
                        if let imageURL = detail.fullImageURL, !imageURL.isEmpty {
                            if #available(iOS 15.0, *) {
                                AsyncImage(url: URL(string: imageURL)) { phase in
                                    switch phase {
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 200)
                                            .clipped()
                                            .cornerRadius(12)
                                    case .failure:
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(height: 200)
                                            .cornerRadius(12)
                                    case .empty:
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.3))
                                            .frame(height: 200)
                                            .cornerRadius(12)
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                            }
                        }

                        // Title
                        Text(detail.title ?? "Notification")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)

                        // Date and Category
                        HStack(spacing: 12) {
                            if let createdTime = detail.createdTime {
                                Text(createdTime)
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.7))
                            }

                            if let category = detail.notiCategoryName {
                                Text(category)
                                    .font(.system(size: 14))
                                    .foregroundColor(.white.opacity(0.7))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(Color.white.opacity(0.1))
                                    .cornerRadius(6)
                            }
                        }

                        // Message
                        Text(detail.plainMessage)
                            .font(.system(size: 16))
                            .foregroundColor(.white.opacity(0.9))
                            .lineSpacing(6)

                        // Action Button (for Movie/Series notifications)
                        if let type = detail.type, type != .normal, let actionLabel = detail.actionLabel {
                            Button(action: {
                                handleActionTap(detail)
                            }) {
                                Text(actionLabel)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                                    .background(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color(red: 0.8, green: 0.2, blue: 0.4), Color(red: 0.6, green: 0.1, blue: 0.3)]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .cornerRadius(12)
                            }
                            .padding(.top, 20)
                        }

                        Spacer()
                    }
                    .padding(20)
                }
            } else {
                Spacer()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                Spacer()
            }
        }
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
    }

    // MARK: - Handle Action Button Tap
    private func handleActionTap(_ detail: APINotificationDetail) {
        print("📬 [NotificationDetail] Action button tapped")

        // Close the detail screen first
        onBack?()

        // Small delay to allow navigation to complete
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            detail.navigate()
        }
    }
}

#Preview {
    NotificationDetailView(.init())
}

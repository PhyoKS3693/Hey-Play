//
//  NotificationView.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 30/10/2025.
//

import SwiftUI
import Combine

struct NotificationView : View {
    @ObservedObject private var viewModel: NotificationViewModel
    var onDismiss: (() -> Void)?
    init(_ viewModel: NotificationViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            Spacer()
                .frame(height: 40)
            NotifictaionTopView {
                onDismiss?()
            }

            if viewModel.isLoading && viewModel.notifications.isEmpty {
                // Initial loading
                Spacer()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
                Spacer()
            } else if viewModel.notifications.isEmpty {
                // Empty state
                Spacer()
                VStack(spacing: 16) {
                    Image(systemName: "bell.slash")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    Text("No notifications")
                        .foregroundColor(.gray)
                        .font(.system(size: 18, weight: .medium))
                }
                Spacer()
            } else {
                NotificationListView(viewModel)
            }

            Spacer()
                .frame(height: 40)
        }
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            if viewModel.notifications.isEmpty {
                viewModel.fetchNotifications()
            }
        }
    }
}


#Preview {
    NotificationView(.init())
}

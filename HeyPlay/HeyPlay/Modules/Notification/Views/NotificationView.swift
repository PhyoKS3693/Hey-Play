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
            NotificationListView(viewModel)
            Spacer()
                .frame(height: 40)
        }
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
    }
}


#Preview {
    NotificationView(.init())
}

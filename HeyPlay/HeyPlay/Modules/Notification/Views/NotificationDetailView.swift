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
    
    @ObservedObject private var viewModel: NotificationDetailViewModel
    @State private var isLoading = true
    
    init(_ viewModel: NotificationDetailViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 0, content: {
                Spacer()
                    .frame(height: 50)
                CustomNavigationBar()
                CommonWebView(source: .url("https://www.apple.com/newsroom/"), isLoading: $isLoading)
                Spacer()
            })
        }
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    NotificationDetailView(.init())
}

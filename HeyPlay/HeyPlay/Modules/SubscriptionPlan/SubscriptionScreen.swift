//
//  SubscriptionScreen.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 10/24/25.
//

import SwiftUI

struct SubscriptionScreen: View {
    var host: HostController?
    
    @ObservedObject private var viewModel: SubscriptionViewModel
    
    init(_ viewModel: SubscriptionViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        Text("Coming Soon")
            .font(FontUtility.heading1())
            .foregroundColor(Color("white_color"))
    }
}

#Preview {
    SubscriptionScreen(.init())
}

//
//  VIPHistoryScreen.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 10/24/25.
//

import SwiftUI

struct VIPHistoryScreen: View {
    var host: HostController?
    
    @ObservedObject private var viewModel: VIPHistoryViewModel
    
    init(_ viewModel: VIPHistoryViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        Text("Hello, VIP History")
    }
}

#Preview {
    VIPHistoryScreen(.init())
}

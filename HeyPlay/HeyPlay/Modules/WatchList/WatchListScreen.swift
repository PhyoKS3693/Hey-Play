//
//  WatchListScreen.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 10/24/25.
//

import SwiftUI

struct WatchListScreen: View {
    var host: HostController?
    
    @StateObject private var viewModel: WatchListViewModel
    
    init(_ viewModel: WatchListViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        Text("Hello, Watch list")
    }
}

#Preview {
    WatchListScreen(.init())
}

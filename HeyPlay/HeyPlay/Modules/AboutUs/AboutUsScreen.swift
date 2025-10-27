//
//  AboutUsScreen.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 10/24/25.
//

import SwiftUI

struct AboutUsScreen: View {
    
    var host: HostController?
    
    @ObservedObject private var viewModel: AboutUsViewModel
    @State private var isLoading = true
    
    init(_ viewModel: AboutUsViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            CommonWebView(source: .url("https://www.apple.com/newsroom/"), isLoading: $isLoading)
        }
    }
}

#Preview {
    AboutUsScreen(.init())
}

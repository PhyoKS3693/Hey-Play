//
//  PoliciesScreen.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 10/24/25.
//

import SwiftUI

struct PoliciesScreen: View {
    
    var host: HostController?
    
    @ObservedObject private var viewModel: PoliciesViewModel
    @State private var isLoading = true
    
    init(_ viewModel: PoliciesViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            CommonWebView(source: .url("https://www.apple.com/privacy/"), isLoading: $isLoading)
        }
    }
}

#Preview {
    PoliciesScreen(.init())
}

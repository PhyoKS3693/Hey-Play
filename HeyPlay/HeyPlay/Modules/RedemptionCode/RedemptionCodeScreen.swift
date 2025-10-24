//
//  RedemptionCodeScreen.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 10/24/25.
//

import SwiftUI

struct RedemptionCodeScreen: View {
    var host: HostController?
    
    @StateObject private var viewModel: RedemptionCodeViewModel
    
    init(_ viewModel: RedemptionCodeViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        Text("Hello, Redemption Code")
    }
}

#Preview {
    RedemptionCodeScreen(.init())
}

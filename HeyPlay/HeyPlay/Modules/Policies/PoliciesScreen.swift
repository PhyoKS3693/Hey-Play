//
//  PoliciesScreen.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 10/24/25.
//

import SwiftUI

struct PoliciesScreen: View {
    
    var host: HostController?
    
    @StateObject private var viewModel: PoliciesViewModel
    
    init(_ viewModel: PoliciesViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        Text("Hello, Policies!")
    }
}

#Preview {
    PoliciesScreen(.init())
}

//
//  AboutUsScreen.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 10/24/25.
//

import SwiftUI

struct AboutUsScreen: View {
    
    var host: HostController?
    
    @StateObject private var viewModel: AboutUsViewModel
    
    init(_ viewModel: AboutUsViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        Text("Hello, About Us!")
    }
}

#Preview {
    AboutUsScreen(.init())
}

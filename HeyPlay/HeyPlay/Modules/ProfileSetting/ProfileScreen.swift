//
//  ProfileScreen.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 10/24/25.
//

import SwiftUI

struct ProfileScreen: View {
    var host: HostController?
    
    @StateObject private var viewModel: ProfileViewModel
    
    init(_ viewModel: ProfileViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        Text("Hello, Profile")
    }
}

#Preview {
    ProfileScreen(.init())
}

//
//  ProfileScreen.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 10/24/25.
//

import SwiftUI

struct ProfileScreen: View {
    var host: HostController?
    
    @ObservedObject private var viewModel: ProfileViewModel
    
    init(_ viewModel: ProfileViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            
        }
    }
}

#Preview {
    ProfileScreen(.init())
}

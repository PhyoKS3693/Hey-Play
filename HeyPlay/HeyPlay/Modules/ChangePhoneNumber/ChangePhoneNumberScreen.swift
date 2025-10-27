//
//  ChangePhoneNumberScreen.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 10/24/25.
//

import SwiftUI

struct ChangePhoneNumberScreen: View {
    var host: HostController?
    
    @StateObject private var viewModel: ChangePhoneNumberViewModel
    
    init(_ viewModel: ChangePhoneNumberViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        Text("Hello, Change Phone number")
    }
}

#Preview {
    ChangePhoneNumberScreen(.init())
}

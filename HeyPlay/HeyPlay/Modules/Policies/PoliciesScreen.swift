//
//  PoliciesScreen.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 10/24/25.
//

import SwiftUI

struct PoliciesScreen: View {
    
    var host: HostController?
    
    var didTapBack: (() -> Void)?
    
    @ObservedObject private var viewModel: PoliciesViewModel
    @State private var isLoading = true
    
    init(_ viewModel: PoliciesViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            navView()
            
            ZStack {
                CommonWebView(source: .url("https://www.apple.com/privacy/"), isLoading: $isLoading)
            }
        }
    }
    
    private func navView() -> some View {
        ZStack (alignment: .leading){
            Button{
                didTapBack?()
            } label: {
                Image("ic.backBtn")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
            }
            
            HStack {
                
                
                Spacer()
                
                Text("Policies")
                    .font(FontUtility.heading1())
                    .foregroundColor(Color("white_color"))
                
                Spacer()
            }
        }
        .padding(10)
    }
}

#Preview {
    PoliciesScreen(.init())
}

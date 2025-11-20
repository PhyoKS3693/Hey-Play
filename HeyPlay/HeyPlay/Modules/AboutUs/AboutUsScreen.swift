//
//  AboutUsScreen.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 10/24/25.
//

import SwiftUI

struct AboutUsScreen: View {
    
    var host: HostController?
    
    var didTapBack: (() -> Void)?
    
    @ObservedObject private var viewModel: AboutUsViewModel
    @State private var isLoading = true
    
    init(_ viewModel: AboutUsViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack{
            navView()
            
            ZStack {
                CommonWebView(source: .url("https://www.apple.com/newsroom/"), isLoading: $isLoading)
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
                
                Text("About Us")
                    .font(FontUtility.heading1())
                    .foregroundColor(Color("white_color"))
                
                Spacer()
            }
        }
        .padding(10)
    }
}

#Preview {
    AboutUsScreen(.init())
}

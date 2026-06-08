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

            if viewModel.isLoading && viewModel.aboutUsURL.isEmpty {
                Spacer()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
                Spacer()
            } else if !viewModel.aboutUsURL.isEmpty {
                ZStack {
                    CommonWebView(source: .url(viewModel.aboutUsURL), isLoading: $isLoading)
                }
            } else {
                Spacer()
                Text("Failed to load content")
                    .foregroundColor(.gray)
                    .font(FontUtility.body1())
                Spacer()
            }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .onAppear {
            if viewModel.aboutUsURL.isEmpty {
                viewModel.fetchSupportLinks()
            }
        }
        .alert(isPresented: Binding<Bool>(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.errorMessage ?? ""),
                dismissButton: .default(Text("OK"))
            )
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

//
//  ProfileScreen.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 10/24/25.
//

import SwiftUI

struct ProfileScreen: View {
    var host: HostController?

    var didTapBack: (() -> Void)?

    @ObservedObject private var viewModel: ProfileViewModel

    init(_ viewModel: ProfileViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {

                navView()
                
                HStack {
                    Spacer()
                    
                    ZStack {
                        Image("ic-user")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                        
                        Image("ic_camera")
                            .frame(width: 26, height: 26)
                    }
                    
                    Spacer()
                }
                
                VStack(alignment: .leading) {
                    Text("Name")
                        .font(FontUtility.caption())
                        .foregroundColor(Color.white)

                    Text(viewModel.profile?.name ?? "")
                        .padding(.horizontal, 20)
                        .frame(height: 40)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.black)
                        .font(FontUtility.body1())
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white, lineWidth: 1)
                        )
                        .foregroundColor(.white)
                }
                .padding(10)
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("Account")
                            .font(FontUtility.caption())
                            .foregroundColor(Color("white_color"))

                        Text("(Optional)")
                            .font(FontUtility.caption())
                            .foregroundColor(Color("castType"))
                    }

                    Text(viewModel.profile?.account ?? "")
                        .padding(.horizontal, 20)
                        .frame(height: 40)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.black)
                        .font(FontUtility.body1())
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white, lineWidth: 1)
                        )
                        .foregroundColor(.white)
                }
                .padding(10)
                
                Text("Linked Accounts")
                    .font(FontUtility.headline2())
                    .foregroundColor(Color.white)
                    .padding(.vertical, 10)
                
                renderLinkedAccount("ic.facebook", "Facebook", "www.facebook.com")
                
                renderLinkedAccount("ic.apple", "Apple", nil)
                
                renderLinkedAccount("ic.google", "Google", "www.google.com")
                
                renderLinkedAccount("ic.line", "Line", nil)

            }
        }
        .onAppear {
            viewModel.fetchProfile()
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
                
                Text("Profile")
                    .font(FontUtility.heading1())
                    .foregroundColor(Color("white_color"))
                
                Spacer()
            }
        }
        .padding(10)
    }
    
    private func renderLinkedAccount(_ icon: String,_ name: String,_ url :String?) -> some View {
        Button{
            print()
        } label: {
            HStack {
                Image(icon)
                    .frame(width: 20, height: 20)
                    .padding(8)
                
                VStack (alignment: .leading) {
                    Text(name)
                        .font(FontUtility.caption())
                        .foregroundColor(.white)
                        .padding(.top, 8)
                        .padding(.bottom, 4)
                    
                    if url != nil {
                        Text(url ?? "")
                            .font(FontUtility.body1())
                            .foregroundColor(.white)
                            .padding(.bottom, 8)
                    }
                }
                
                Spacer()
                
                if url != nil {
                    Image("ic-delete")
                        .frame(width: 20, height: 20)
                        .padding(8)
                }else {
                    Image("btn_add")
                        .frame(width: 69, height: 26)
                        .padding(8)
                }
            }
        }
        .padding(.horizontal, 20)
        .background(Color.black)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white, lineWidth: 1)
        )
        .foregroundColor(.white)
    }
}

#Preview {
    ProfileScreen(.init())
}

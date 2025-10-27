//
//  ProfileScreen.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 10/24/25.
//

import SwiftUI

struct ProfileScreen: View {
    var host: HostController?
    
    @State var userName: String = ""
    @State var userPhone: String = ""
    
    @ObservedObject private var viewModel: ProfileViewModel
    
    init(_ viewModel: ProfileViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                HStack {
                    Spacer()
                    
                    ZStack {
                        Image("ic-user")
                            .frame(width: 80, height: 80)
                        
                        Image("ic_camera")
                            .frame(width: 26, height: 26)
                    }
                    
                    Spacer()
                }
                
                Text("Name")
                    .font(FontUtility.regularFont(size: 11))
                    .foregroundColor(Color("white_color"))
                
                TextField("", text: $userName)
                    .padding(.horizontal, 20)
                    .frame(height: 40)
                    .background(Color.black)
                    .font(FontUtility.normalFont())
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white, lineWidth: 1)
                    )
                    .foregroundColor(.white)
                
                HStack {
                    Text("Account")
                        .font(FontUtility.regularFont(size: 11))
                        .foregroundColor(Color("white_color"))
                    
                    Text("(Optional)")
                        .font(FontUtility.regularFont(size: 11))
                        .foregroundColor(Color("grey_color"))
                }
                
                TextField("", text: $userPhone)
                    .padding(.horizontal, 20)
                    .frame(height: 40)
                    .background(Color.black)
                    .font(FontUtility.normalFont())
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white, lineWidth: 1)
                    )
                    .foregroundColor(.white)
                
                Text("Linked Accounts")
                    .font(FontUtility.mediumFont())
                    .foregroundColor(Color("white_color"))
                    .padding(.vertical, 10)
                
                renderLinkedAccount("ic.facebook", "Facebook", "www.facebook.com")
                
                renderLinkedAccount("ic.apple", "Apple", nil)
                
                renderLinkedAccount("ic.google", "Google", "www.google.com")
                
                renderLinkedAccount("ic.line", "Line", nil)
                
            }
        }
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
                        .font(FontUtility.regularFont(size: 13))
                        .foregroundColor(.white)
                        .padding(.top, 8)
                        .padding(.bottom, 4)
                    
                    if url != nil {
                        Text(url ?? "")
                            .font(FontUtility.regularFont(size: 13))
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

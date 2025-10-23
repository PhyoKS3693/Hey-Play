//
//  MenuScreen.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 10/23/25.
//

import SwiftUI

struct MenuScreen: View {
    
    var host: HostController?
    
    @StateObject private var viewModel: MenuViewModel
    
    init(_ viewModel: MenuViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                guestSection()
                
                loginNormalUser("Cho Nwe", "09777777777", "HPUCCFVZ1")
                
                loginVIPUser("Cho Nwe", "09777777777", "HPUCCFVZ1", "2025-02-27 | 20:29:11")
                
                ForEach(viewModel.sections) { section in
                    VStack {
                        sectionTitle(section.section.rawValue)
                        LazyVStack {
                            ForEach(section.items) { item in
                                Button {
                                    handleSelection(item)
                                } label: {
                                    sectionItem(item.diaplayIcon, item.displayName)
                                }
                            }
                        }
                        .background {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color("darkGrey_Color"))
                        }
                        
                    }
                    .padding(.horizontal, 12)
                }
            }
        }
        
        
    }
    
    private func guestSection() -> some View {
        VStack {
            Button {
                handleLogin()
            } label: {
                HStack {
                    Image("menu_profile")
                        .frame(width: 42, height: 42)
                        .background(
                            Circle()
                                .fill(Color.white.opacity(0.1))
                        )
                        .padding(12)
                    
                    
                    VStack(alignment: .leading) {
                        Text("Login")
                            .padding(.vertical, 4)
                            .font(FontUtility.mediumFont())
                            .foregroundStyle(Color("white_color"))
                        
                        Text("Choose Login Method")
                            .padding(.bottom, 4)
                            .font(FontUtility.regularFont(size: 11))
                            .foregroundStyle(Color("white_color"))
                    }
                    
                    Spacer()
                    
                    Image("arrow_right")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(.trailing, 20)
                }
            }

        }
        .background {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color("darkGrey_Color"))
        }
        .padding(.horizontal, 12)
    }
    
    private func handleLogin(){
        print("Guest Login Tap")
    }
    
    private func loginNormalUser(_ userName: String,_ userPhoneNumber: String,_ userId: String) -> some View {
        VStack {
            HStack {
                Image("ic-user")
                    .frame(width: 42, height: 42)
                    .background(
                        Circle()
                            .fill(Color.white.opacity(0.1))
                    )
                    .padding(12)
                
                
                VStack(alignment: .leading) {
                    Text(userName)
                        .padding(.vertical, 4)
                        .font(FontUtility.mediumFont())
                        .foregroundStyle(Color("white_color"))
                    
                    Text(userPhoneNumber)
                        .padding(.bottom, 4)
                        .font(FontUtility.regularFont(size: 11))
                        .foregroundStyle(Color("white_color"))
                }
                
                Spacer()
                
                Button {
                    copyUserID()
                } label: {
                    HStack {
                        Image("ic_copy")
                            .frame(width: 15, height: 15)
                            .padding(.vertical,8)
                            .padding(.leading, 8)
                        
                        Text(userId)
                            .font(FontUtility.regularFont(size: 10))
                            .foregroundStyle(Color("yellow_color"))
                            .padding(.trailing, 8)
                    }
                    .frame(height: 26)
                    .background {
                        RoundedRectangle(cornerRadius: 13)
                            .fill(Color("yellow_color").opacity(0.1))
                    }
                    .padding(.trailing, 20)
                }

            }

        }
        .background {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color("darkGrey_Color"))
        }
        .padding(.horizontal, 12)
    }
    
    private func copyUserID(){
        print("Copy User Id Tap")
    }
    
    private func loginVIPUser(_ userName: String,_ userPhoneNumber: String,_ userId: String,_ expireDate: String) -> some View {
        VStack {
            HStack {
                Image("ic-user")
                    .frame(width: 42, height: 42)
                    .background(
                        Circle()
                            .fill(Color.white.opacity(0.1))
                    )
                    .padding(12)
                
                
                VStack(alignment: .leading) {
                    Text(userName)
                        .padding(.vertical, 4)
                        .font(FontUtility.mediumFont())
                        .foregroundStyle(Color("white_color"))
                    
                    Text(userPhoneNumber)
                        .padding(.bottom, 4)
                        .font(FontUtility.regularFont(size: 11))
                        .foregroundStyle(Color("white_color"))
                }
                
                Spacer()
                
                Button {
                    copyUserID()
                } label: {
                    HStack {
                        Image("ic_copy")
                            .frame(width: 15, height: 15)
                            .padding(.vertical,8)
                            .padding(.leading, 8)
                        
                        Text(userId)
                            .font(FontUtility.regularFont(size: 10))
                            .foregroundStyle(Color("yellow_color"))
                            .padding(.trailing, 8)
                    }
                    .background {
                        RoundedRectangle(cornerRadius: 13)
                            .fill(Color("yellow_color").opacity(0.1))
                    }
                    .frame(height: 26)
                    .padding(.trailing, 20)
                }
                

            }
            
            Rectangle()
                .fill(Color.clear)
                .frame(height: 1)
                .overlay(
                    Rectangle()
                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [5,5]))
                        .foregroundColor(Color("black_Color"))
                )
                .padding(.horizontal, 16)
            
            HStack {
                VStack(alignment: .leading) {
                    Text("VIP Package")
                        .font(FontUtility.mediumFont())
                        .foregroundStyle(Color("primaryBgColor"))
                    
                    Text("Expire Date : \(expireDate)")
                        .font(FontUtility.regularFont(size: 10))
                        .foregroundStyle(Color("white_color"))
                }
                
                Spacer()
                
                Button {
                    tapExpireDate()
                } label: {
                    HStack {
                        Image("ic_calender")
                            .frame(width: 20, height: 20)
                            .padding(.vertical,8)
                            .padding(.leading, 8)
                        
                        Text("30 Days")
                            .font(FontUtility.regularFont(size: 13))
                            .foregroundStyle(Color("white_color"))
                            .padding(.trailing, 8)
                    }
                }
                .background {
                    RoundedRectangle(cornerRadius: 13)
                        .fill(Color("grey_Color"))
                    
                }
                .frame(height: 31)
                .padding(.trailing, 8)

            }
            .padding(.horizontal,12)
            .padding(.bottom, 12)

        }
        .background {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color("darkGrey_Color"))
        }
        .padding(.horizontal, 12)
    }
    
    private func tapExpireDate(){
        print("Expire Date Tap")
    }
    
    private func sectionTitle(_ sectionName: String) -> some View {
        HStack {
            Text(sectionName)
                .font(FontUtility.largeTitleFont())
                .foregroundStyle(Color("white_color"))
            
            Spacer()
        }
        
    }
    
    private func sectionItem(_ sectionIcon: String,_ sectionName: String) -> some View {
        HStack {
            Image(sectionIcon)
                .resizable()
                .frame(width: 20, height: 20)
                .padding(.horizontal, 10)
            
            Text(sectionName)
                .font(FontUtility.normalFont())
                .foregroundStyle(Color("white_color"))
            
            Spacer()
            
            Image("arrow_right")
                .resizable()
                .frame(width: 20, height: 20)
                .padding(.horizontal, 10)
        }
        .padding(10)
        
    }
    
    private func handleSelection(_ item: MenuItem) {
        switch item {
        case .profile:
            print("Go to Profile")
        case .changePhone:
            print("Go to Change Phone Number")
        case .watchlist:
            print("Go to Watchlist")
        case .subscription:
            print("Go to Subscription Plan")
        case .vipHistory:
            print("Go to VIP History")
        case .redemption:
            print("Go to Redemption Code")
        case .policies:
            print("Go to Policies")
        case .about:
            print("Go to About Us")
        }
    }
}

#Preview {
    MenuScreen(.init())
}

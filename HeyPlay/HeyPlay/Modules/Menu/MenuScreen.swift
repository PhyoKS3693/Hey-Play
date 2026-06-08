//
//  MenuScreen.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 10/23/25.
//

import SwiftUI

struct MenuScreen: View {

    var host: HostController?

    var didSelectProfile: (() -> Void)?
    var didSelectChangePhoneNumber: (() -> Void)?
    var didSelectWatchList: (() -> Void)?
    var didSelectSubscriptionPlan: (() -> Void)?
    var didSelectVIPHistory: (() -> Void)?
    var didSelectRedemptionCode: (() -> Void)?
    var didSelectPolicies: (() -> Void)?
    var didSelectAboutUs: (() -> Void)?
    var didSelectLogout: (() -> Void)?

    @ObservedObject private var viewModel: MenuViewModel

    @State private var showRedeemAlert = false
    @State private var showLogoutAlert = false
    @State var redeemCode: String = ""
    @State private var redeemErrorMessage: String?
    @State private var isRedeemLoading: Bool = false

    init(_ viewModel: MenuViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }


    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                navView()

                // Show appropriate user section based on login status
                userSection()

                // Menu sections
                ForEach(viewModel.sections) { section in
                    VStack {
                        sectionTitle(section.section.rawValue)
                        VStack {
                            ForEach(section.items) { item in
                                Button {
                                    handleSelection(item)
                                } label: {
                                    sectionItem(item.diaplayIcon, item.displayName)
                                }
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.darkGrey)
                        )

                    }
                    .padding(.horizontal, 12)
                }

                // Logout button (only for logged in users)
                if viewModel.isLoggedIn {
                    logoutButton()
                }
            }
            .customDialog(isPresented: $showRedeemAlert) {
                showRedeemCodeDialog()
            }
            .alert(isPresented: $showLogoutAlert) {
                Alert(
                    title: Text("Logout"),
                    message: Text("Are you sure you want to logout?"),
                    primaryButton: .destructive(Text("Logout")) {
                        viewModel.logout()
                    },
                    secondaryButton: .cancel()
                )
            }
            .padding(.bottom, 100)
        }
        .onAppear {
            viewModel.fetchProfile()
        }
    }

    // MARK: - User Section (conditionally rendered)
    @ViewBuilder
    private func userSection() -> some View {
        if !viewModel.isLoggedIn {
            // Guest user - show login prompt
            guestSection()
        } else if viewModel.hasActiveSubscription {
            // VIP/Premium user
            loginVIPUser(
                viewModel.userName,
                viewModel.userPhone,
                viewModel.userId,
                viewModel.subscriptionPlanName,
                viewModel.expiredTime,
                viewModel.daysRemainingText
            )
        } else {
            // Normal logged in user (Free)
            loginNormalUser(
                viewModel.userName,
                viewModel.userPhone,
                viewModel.userId
            )
        }
    }
    
    private func navView() -> some View {
        HStack {
            Text("Menu")
                .font(FontUtility.heading2())
                .foregroundColor(Color("white_color"))
            
            Spacer()
            
            Button {
                ViewNavigation.shared.showNotification()
            } label: {
                Image("ic-noti")
            }
            .frame(width: 32, height: 32)

            Button {
                ViewNavigation.shared.showSearchView()
            } label: {
                Image("ic-search")
            }
            .frame(width: 32, height: 32)

        }
        .padding(.horizontal, 12)
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
                            .font(FontUtility.subHeadline())
                            .foregroundColor(Color.white)
                        
                        Text("Choose Login Method")
                            .padding(.bottom, 4)
                            .font(FontUtility.caption())
                            .foregroundColor(Color.white)
                    }
                    
                    Spacer()
                    
                    Image("arrow_right")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(.trailing, 20)
                }
            }

        }
        .background (
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.darkGrey)
        )
        .padding(.horizontal, 12)
    }
    
    private func handleLogin() {
        ViewNavigation.shared.showLoginView()
    }

    // MARK: - Logout Button
    private func logoutButton() -> some View {
        Button {
            showLogoutAlert = true
        } label: {
            HStack {
                Image(systemName: "rectangle.portrait.and.arrow.right")
                    .foregroundColor(.red)
                    .frame(width: 20, height: 20)
                    .padding(.horizontal, 10)

                Text("Logout")
                    .font(FontUtility.smallText1())
                    .foregroundColor(.red)

                Spacer()
            }
            .padding(10)
        }
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.darkGrey)
        )
        .padding(.horizontal, 12)
        .padding(.top, 20)
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
                        .font(FontUtility.subHeadline())
                        .foregroundColor(Color.white)
                    
                    Text(userPhoneNumber)
                        .padding(.bottom, 4)
                        .font(FontUtility.caption())
                        .foregroundColor(Color.white)
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
                            .font(FontUtility.caption())
                            .foregroundColor(Color.yellow)
                            .padding(.trailing, 8)
                    }
                    .frame(height: 26)
                    .background (
                        RoundedRectangle(cornerRadius: 13)
                            .fill(Color.yellow.opacity(0.1))
                    )
                    .padding(.trailing, 20)
                }

            }

        }
        .background (
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.darkGrey)
        )
        .padding(.horizontal, 12)
    }
    
    private func copyUserID() {
        viewModel.copyUserId()
        // Show a brief toast/feedback that ID was copied
        print("User ID copied: \(viewModel.userId)")
    }
    
    private func loginVIPUser(_ userName: String, _ userPhoneNumber: String, _ userId: String, _ planName: String, _ expireDate: String, _ daysRemaining: String) -> some View {
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
                        .font(FontUtility.subHeadline())
                        .foregroundColor(Color.white)

                    Text(userPhoneNumber)
                        .padding(.bottom, 4)
                        .font(FontUtility.caption())
                        .foregroundColor(Color.white)
                }

                Spacer()

                Button {
                    copyUserID()
                } label: {
                    HStack {
                        Image("ic_copy")
                            .frame(width: 15, height: 15)
                            .padding(.vertical, 8)
                            .padding(.leading, 8)

                        Text(userId)
                            .font(FontUtility.caption())
                            .foregroundColor(Color.yellow)
                            .padding(.trailing, 8)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 13)
                            .fill(Color.yellow.opacity(0.1))
                    )
                    .frame(height: 26)
                    .padding(.trailing, 20)
                }
            }

            Rectangle()
                .fill(Color.clear)
                .frame(height: 1)
                .overlay(
                    Rectangle()
                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [5, 5]))
                        .foregroundColor(Color.black)
                )
                .padding(.horizontal, 16)

            HStack {
                VStack(alignment: .leading) {
                    Text(planName)
                        .font(FontUtility.subHeadline())
                        .foregroundColor(Color("pink_Color"))

                    Text("Expire Date : \(expireDate)")
                        .font(FontUtility.caption())
                        .foregroundColor(Color("white_color"))
                }

                Spacer()

                HStack {
                    Image("ic_calender")
                        .frame(width: 20, height: 20)
                        .padding(.vertical, 8)
                        .padding(.leading, 8)

                    Text(daysRemaining)
                        .font(FontUtility.subHeadline())
                        .foregroundColor(Color.white)
                        .padding(.trailing, 8)
                }
                .background(
                    RoundedRectangle(cornerRadius: 13)
                        .fill(Color.grey)
                )
                .frame(height: 31)
                .padding(.trailing, 8)
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 12)
        }
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.darkGrey)
        )
        .padding(.horizontal, 12)
    }
    
    
    private func sectionTitle(_ sectionName: String) -> some View {
        HStack {
            Text(sectionName)
                .font(FontUtility.largeTitle())
                .foregroundColor(Color.white)
            
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
                .font(FontUtility.smallText1())
                .foregroundColor(Color.white)
            
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
            didSelectProfile?()
        case .changePhone:
            didSelectChangePhoneNumber?()
        case .watchlist:
            didSelectWatchList?()
        case .subscription:
            didSelectSubscriptionPlan?()
        case .vipHistory:
            didSelectVIPHistory?()
        case .redemption:
            // Reset state before showing dialog
            redeemCode = ""
            redeemErrorMessage = nil
            isRedeemLoading = false
            showRedeemAlert = true
            //didSelectRedemptionCode?()
        case .policies:
            didSelectPolicies?()
        case .about:
            didSelectAboutUs?()
        }
    }
    
    private func showRedeemCodeDialog() -> some View {
        ZStack {
            CustomDialogView(
                iconName: "redeem_dialog_icon",
                title: "Redeem",
                message: "Please enter redemption code",
                closeAction: {
                    showRedeemAlert = false
                    redeemCode = ""
                    redeemErrorMessage = nil
                },
                primaryButtonTitle: "Confirm",
                primaryAction: {
                    // Call API
                    redeemPromoCode()
                },
                primaryButtonDisabled: redeemCode.count != 10 || isRedeemLoading,
                secondaryButtonTitle: nil,
                secondaryAction: {
                    print("Cancel tapped")
                }
            ) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Redemption Code")
                        .font(FontUtility.caption())
                        .foregroundColor(Color.white)

                    TextField("", text: $redeemCode)
                        .padding(.horizontal, 20)
                        .frame(height: 40)
                        .font(FontUtility.body1())
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white, lineWidth: 1)
                        )
                        .foregroundColor(.white)
                        .keyboardType(.numberPad)
                        .onChange(of: redeemCode) { newValue in
                            // Limit to 10 characters
                            if newValue.count > 10 {
                                redeemCode = String(newValue.prefix(10))
                            }
                            // Clear error when user types
                            redeemErrorMessage = nil
                        }

                    // Error Message (Red)
                    if let errorMessage = redeemErrorMessage {
                        Text(errorMessage)
                            .font(FontUtility.caption())
                            .foregroundColor(.red)
                            .padding(.horizontal, 4)
                    }
                }
            }

            // Loading Overlay
            if isRedeemLoading {
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)

                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
            }
        }
    }

    // MARK: - Redeem Promo Code API Call
    private func redeemPromoCode() {
        guard redeemCode.count == 10 else {
            redeemErrorMessage = "Please enter a valid 10-digit promo code"
            return
        }

        isRedeemLoading = true
        redeemErrorMessage = nil

        Task { @MainActor in
            let result = await RedeemCodeService.shared.redeemPromoCode(promoCode: redeemCode)

            isRedeemLoading = false

            switch result {
            case .success(let message):
                print("✅ [MenuScreen] Redemption successful: \(message)")
                // Close dialog and navigate to success screen
                showRedeemAlert = false
                redeemCode = "" // Reset
                didSelectRedemptionCode?()

            case .failure(let error):
                // Show error below text field (don't navigate)
                if let apiError = error as? APIError {
                    switch apiError {
                    case .serverError(let message):
                        redeemErrorMessage = message
                    default:
                        redeemErrorMessage = error.localizedDescription
                    }
                } else {
                    redeemErrorMessage = error.localizedDescription
                }
                print("❌ [MenuScreen] Redemption failed: \(redeemErrorMessage ?? "")")
            }
        }
    }
}

#Preview {
    MenuScreen(.init())
}

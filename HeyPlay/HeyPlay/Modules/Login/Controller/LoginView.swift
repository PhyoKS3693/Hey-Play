//
//  LoginView.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 14/10/2025.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    @State private var tapApple = false
    @State private var tapGoogle = false
    @State private var tapFacebook = false
    @State private var tapLine = false
    @State private var tapSkip = false

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    SkipButtonView(isTapSkip: $tapSkip)
                    ScrollView {
                        VStack(spacing: 20, content: {
                            LoginTopView()
                            TextWithTitleView(phoneNumber: $viewModel.phoneNumber)

                            // Continue Button
                            Button(action: {
                                hideKeyboard()
                                viewModel.validatePhoneNumber()
                            }) {
                                Text("Continue".localized())
                                    .font(FontUtility.body1())
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity, minHeight: 50)
                            .background(viewModel.canProceedToOTP ? Color.primaryBg : Color.gray)
                            .cornerRadius(20)
                            .disabled(!viewModel.canProceedToOTP)
                            .padding(.horizontal, 20)

                            SepartorView()
                            RoundedButtonView(
                                buttonType: .apple ,
                                isTap: $tapApple
                            )
                            RoundedButtonView(
                                buttonType: .google ,
                                isTap: $tapGoogle
                            )
                            RoundedButtonView(
                                buttonType: .facebook ,
                                isTap: $tapFacebook
                            )
                            RoundedButtonView(
                                buttonType: .line ,
                                isTap: $tapLine
                            )
                        })
                    }

                    NavigationLink(
                        destination: OTPView(viewModel: viewModel),
                        isActive: $viewModel.showOTPScreen
                    ) {
                        EmptyView()
                    }
                }

                // Loading Overlay
                if viewModel.isLoading {
                    Color.black.opacity(0.5)
                        .edgesIgnoringSafeArea(.all)

                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Color.black
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        hideKeyboard()
                    }
            )
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
            .onChange(of: tapGoogle) { newValue in
                if newValue {
                    handleGoogleSignIn()
                    tapGoogle = false
                }
            }
            .onChange(of: tapApple) { newValue in
                if newValue {
                    handleAppleSignIn()
                    tapApple = false
                }
            }
            .onChange(of: viewModel.loginSuccess) { success in
                if success {
                    // Navigate to home screen
                    navigateToHome()
                }
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }

    // MARK: - Google Sign In Handler
    private func handleGoogleSignIn() {
        // Get the presenting view controller
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            viewModel.errorMessage = "Unable to present Google Sign-In"
            return
        }

        // Find the topmost view controller
        var topController = rootViewController
        while let presented = topController.presentedViewController {
            topController = presented
        }

        // Trigger Google Sign-In
        GoogleSignInHelper.shared.signIn(presenting: topController) { result in
            switch result {
            case .success(let userInfo):
                print("✅ Google Sign-In successful")
                print("   Google ID: \(userInfo.googleId)")
                print("   Email: \(userInfo.email)")
                print("   Name: \(userInfo.name)")

                // Call the login API with Google credentials
                viewModel.loginWithGoogle(
                    googleId: userInfo.googleId,
                    email: userInfo.email,
                    name: userInfo.name,
                    profileImage: userInfo.profileImage,
                    deviceToken: nil // Add device token if you have FCM integrated
                )

            case .failure(let error):
                // Check if user cancelled the sign-in
                let nsError = error as NSError
                if nsError.domain == "com.google.GIDSignIn" && nsError.code == -5 {
                    // User cancelled - don't show error
                    print("ℹ️ Google Sign-In cancelled by user")
                    return
                }

                // Show error for other failures
                print("❌ Google Sign-In failed: \(error.localizedDescription)")
                viewModel.errorMessage = error.localizedDescription
            }
        }
    }

    // MARK: - Apple Sign In Handler
    private func handleAppleSignIn() {
        // Get the presenting view controller
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            viewModel.errorMessage = "Unable to present Apple Sign-In"
            return
        }

        // Find the topmost view controller
        var topController = rootViewController
        while let presented = topController.presentedViewController {
            topController = presented
        }

        // Trigger Apple Sign-In
        AppleSignInHelper.shared.signIn(presenting: topController) { result in
            switch result {
            case .success(let userInfo):
                print("✅ Apple Sign-In successful")
                print("   Apple ID: \(userInfo.appleId)")
                print("   Email: \(userInfo.email.isEmpty ? "(empty - backend should look up)" : userInfo.email)")
                print("   Name: \(userInfo.name.isEmpty ? "(empty - backend should look up)" : userInfo.name)")
                print("   First Sign-In: \(userInfo.isFirstSignIn)")

                // Call the login API with Apple credentials
                // Note: On subsequent logins, email and name will be empty
                // Backend should look up user by appleId and return stored email/name
                viewModel.loginWithApple(
                    appleId: userInfo.appleId,
                    email: userInfo.email,
                    name: userInfo.name,
                    deviceToken: nil // Add device token if you have FCM integrated
                )

            case .failure(let error):
                // Check if user cancelled the sign-in
                let nsError = error as NSError
                if nsError.code == 1001 { // ASAuthorizationError.canceled
                    // User cancelled - don't show error
                    print("ℹ️ Apple Sign-In cancelled by user")
                    return
                }

                // Show error for other failures
                print("❌ Apple Sign-In failed: \(error.localizedDescription)")
                viewModel.errorMessage = error.localizedDescription
            }
        }
    }

    // MARK: - Navigate to Home
    private func navigateToHome() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return
        }

        let homeVC = HomeViewController()
        let navController = UINavigationController(rootViewController: homeVC)
        navController.isNavigationBarHidden = false

        window.rootViewController = navController
        window.makeKeyAndVisible()
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

}

struct LoginTopView : View {
    var body: some View {
        VStack(spacing: 10,  content: {
            Image("ic.splash.logo")
                .frame(width: 113 , height: 95 , alignment: .center)
                .padding(.top, 20)
                .padding(.bottom, 20)
            
            Text("Get Started".localized())
                .font(FontUtility.headline2())
                .foregroundColor(.white)
            
            Text("Hello! Let’s join with us".localized())
                .font(FontUtility.subHeadline())
                .foregroundColor(.white)
        })
    }
}

struct SepartorView : View {
    var body: some View {
        HStack(spacing: 10) {
            Rectangle()
                .frame(width: 80, height: 1)
                .foregroundColor(.lightGrey)
            
            Text("OR".localized())
                .font(FontUtility.smallText1())
                .foregroundColor(.white)
            
            Rectangle()
                .frame(width: 80, height: 1)
                .foregroundColor(.lightGrey)
        }
    }
}

struct SkipButtonView : View {
    @Binding var isTapSkip : Bool
    var body: some View {
        HStack {
            Spacer()
            Button {
                print("Tap skip")
                // Navigate to Home instead of OTP
                ViewNavigation.shared.showMainTabBar()
            } label: {
                Text("Skip".localized())
                    .font(FontUtility.body1())
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
            }
            .background(Color(red: 0.25, green: 0.25, blue: 0.25))
            .clipShape(Capsule())
            .padding(.horizontal, 16)
        }
        .padding(.top , 50)
    }
}


//
//  OTPView.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 14/10/2025.
//

import Foundation
import SwiftUI
import Combine

struct OTPView : View {
    @ObservedObject var viewModel: LoginViewModel
    @State var timeCount : Int = 60
    @State var canResend : Bool = false
    @State private var timer: Timer?
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            VStack {
                // Back Button
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .font(.system(size: 20))
                            .padding()
                    }
                    Spacer()
                }

                OTPTopView(phoneNumber: maskPhoneNumber(viewModel.phoneNumber))
                OTPTextView(otpText: $viewModel.otpCode)

                Button {
                    hideKeyboard()
                    viewModel.verifyOTPAndLogin()
                } label: {
                    Text("Verify".localized())
                        .font(FontUtility.body1())
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(viewModel.canVerifyOTP ? Color.primaryBg : Color.gray)
                .cornerRadius(20)
                .padding(.horizontal, 20)
                .disabled(!viewModel.canVerifyOTP)

                // Resend OTP
                HStack {
                    Text("If you didn't receive a code? ".localized())
                        .foregroundColor(.white)
                        .font(FontUtility.body2())

                    if canResend {
                        Button(action: {
                            viewModel.resendOTP()
                            startCountdown()
                        }) {
                            Text("Resend OTP".localized())
                                .foregroundColor(Color.primaryBg)
                                .font(FontUtility.body2())
                                .underline()
                        }
                    } else {
                        Text("in \(timeCount)s")
                            .foregroundColor(.gray)
                            .font(FontUtility.body2())
                    }
                }
                .padding()

                Spacer()
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
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .onAppear {
            startCountdown()
        }
        .onDisappear {
            stopCountdown()
        }
        .onChange(of: viewModel.loginSuccess) { success in
            if success {
                print("✅ Login success detected in OTPView")
                // Navigate to Home with a slight delay to ensure UI is updated
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    print("✅ Calling showMainTabBar()")
                    self.showMainTabBar()
                }
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

    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }

    private func maskPhoneNumber(_ phone: String) -> String {
        guard phone.count >= 6 else { return phone }
        let start = phone.prefix(2)
        let end = phone.suffix(3)
        return "\(start)*****\(end)"
    }

    private func startCountdown() {
        // Stop any existing timer
        stopCountdown()

        // Reset countdown
        timeCount = 60
        canResend = false

        // Start new timer on main run loop
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [self] _ in
            DispatchQueue.main.async {
                if self.timeCount > 0 {
                    self.timeCount -= 1
                } else {
                    self.canResend = true
                    self.stopCountdown()
                }
            }
        }
    }

    private func stopCountdown() {
        timer?.invalidate()
        timer = nil
    }

    private func showMainTabBar() {
        ViewNavigation.shared.showMainTabBar()
    }
}



struct OTPTopView : View {
    var phoneNumber : String = ""
    var body: some View {
        VStack(spacing: 20, content: {
            Spacer()
                .frame(height: 30)
            Image("ic.otpImage")
                .resizable()
                .frame(width: 100, height: 100)
            
            Text("Verification".localized())
                .foregroundColor(.white)
                .font(FontUtility.headline2())
            
            Text(String(format: "Please enter your 6-digits OTP codes that’s\nwe’ve sent to your mobile number".localized(), phoneNumber))
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .font(FontUtility.subHeadline())
            
        })
        .padding()
    }
}

#Preview {
    OTPView(viewModel: LoginViewModel())
}

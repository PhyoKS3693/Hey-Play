//
//  VerifyOtpScreen.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 10/30/25.
//

import SwiftUI

struct VerifyOtpScreen: View {
    var host: HostController?

    var didTapBack: (() -> Void)?
    var didTapVerifyOTP: (() -> Void)?

    @ObservedObject private var viewModel: VerifyOtpViewModel
    @State private var showWrongOTPAlert = false
    @State private var isCancel = false
    @State private var isResend = false
    @State private var alertTitle = "Error"
    @State private var alertMessage = "Your OTP code is wrong"

    init(_ viewModel: VerifyOtpViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            VStack {
                navView()

                Image("ic.otpImage")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .padding(.horizontal, 10)

                Text("Verification")
                    .font(FontUtility.heading2())
                    .foregroundColor(Color("white_color"))
                    .padding(.vertical, 10)

                Text("Please enter your 6-digits OTP codes that's we've sent to your mobile number \(viewModel.maskedPhoneNumber)")
                    .font(FontUtility.subHeadline())
                    .foregroundColor(Color("white_color"))
                    .padding(.vertical, 10)
                    .multilineTextAlignment(.center)

                OTPTextView(otpText: $viewModel.otpCode)

                Button {
                    hideKeyboard()
                    didTapVerifyOTP?()
                } label: {
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Verify")
                            .font(FontUtility.body1())
                            .foregroundColor(Color.white)
                    }
                }
                .frame(maxWidth: .infinity, minHeight: 50)
                .padding(.horizontal)
                .background(Color("pink_Color"))
                .cornerRadius(20)
                .disabled(viewModel.isLoading)

                if viewModel.canResend {
                    Button {
                        Task {
                            await viewModel.resendOTP()
                        }
                    } label: {
                        Text("If you didn't receive a code? Resend OTP")
                            .font(FontUtility.body2())
                            .foregroundColor(Color("pink_Color"))
                            .underline()
                    }
                    .padding(.vertical, 10)
                } else {
                    Text("If you didn't receive a code? Resend OTP in (\(viewModel.countdown)s)")
                        .font(FontUtility.body2())
                        .foregroundColor(Color("white_color"))
                        .padding(.vertical, 10)
                }

                Spacer()
            }
            .background(
                Color.black
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        hideKeyboard()
                    }
            )

            // Wrong OTP Alert
            if showWrongOTPAlert {
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        // Dismiss on background tap
                    }

                WrongOTPAlertView(
                    isCancel: $isCancel,
                    isResend: $isResend,
                    title: $alertTitle,
                    message: $alertMessage,
                    showWrongAlert: $showWrongOTPAlert
                )
            }
        }
        .onAppear {
            viewModel.startCountdown()
        }
        .onDisappear {
            viewModel.stopCountdown()
        }
        .onChange(of: viewModel.errorMessage) { error in
            if let errorMsg = error {
                print("❌ [VerifyOtpScreen] Error occurred: \(errorMsg)")
                alertTitle = "Error"
                alertMessage = errorMsg
                showWrongOTPAlert = true
            }
        }
        .onChange(of: isCancel) { cancel in
            if cancel {
                print("🚫 [VerifyOtpScreen] User cancelled, clearing OTP")
                viewModel.otpCode = ""
                viewModel.errorMessage = nil
                isCancel = false
            }
        }
        .onChange(of: isResend) { resend in
            if resend {
                print("🔄 [VerifyOtpScreen] User requested resend OTP")
                Task {
                    await viewModel.resendOTP()
                }
                isResend = false
            }
        }
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
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
                
                Text("Verification Code")
                    .font(FontUtility.heading1())
                    .foregroundColor(Color("white_color"))
                
                Spacer()
            }
        }
        .padding(10)
        
    }
}


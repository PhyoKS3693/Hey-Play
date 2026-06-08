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
    
    init(_ viewModel: VerifyOtpViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
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

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(FontUtility.body2())
                    .foregroundColor(Color.red)
                    .padding(.vertical, 5)
            }

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
        .onAppear {
            viewModel.startCountdown()
        }
        .onDisappear {
            viewModel.stopCountdown()
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


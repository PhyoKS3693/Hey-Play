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
            
            Text("Please enter your 6-digits OTP codes that’s we’ve sent to your mobile number 09 ******210")
                .font(FontUtility.subHeadline())
                .foregroundColor(Color("white_color"))
                .padding(.vertical, 10)
            
            OTPTextView()
            
            Button {
                didTapVerifyOTP?()
            } label: {
                Text("Verify")
                    .font(FontUtility.body1())
                    .foregroundColor(Color.white)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color("pink_Color"))
            .cornerRadius(20)
            
            Text("If you didn’t receive a code? Resend OTP in (56s)")
                .font(FontUtility.body2())
                .foregroundColor(Color("white_color"))
                .padding(.vertical, 10)
            
            Spacer()
            
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
                
                Text("Verification Code")
                    .font(FontUtility.heading1())
                    .foregroundColor(Color("white_color"))
                
                Spacer()
            }
        }
        .padding(10)
        
    }
}


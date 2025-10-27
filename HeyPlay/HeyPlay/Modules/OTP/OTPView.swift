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
    @State var tapVerify : Bool = false
    @State var timeCount : Int = 10
    @State var isCancel : Bool = false
    @State var isResend : Bool = false
    @State var isShowAlert : Bool = false
    @State var title : String = "Wrong OTP"
    @State var message : String = "Please try again later"
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    OTPTopView(phoneNumber: "12*****483")
                    OTPTextView()
                    RoundedButtonView(
                        buttonType: .verify,
                        isTap: $tapVerify
                    )
                    TimerView(timeCount: $timeCount)
                    Spacer()
                }
                if isShowAlert {
                    showAlert()
                }
            }
            .onReceive(Just(tapVerify)) { newValue in
                if newValue {
                    presentHomeVC()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
            .edgesIgnoringSafeArea(.all)
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
    @ViewBuilder
    func showAlert() -> some View {
        if isShowAlert {
            Color.black.opacity(0.4) // dim background
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    withAnimation {
                        isShowAlert = false
                    }
                }
            
            WrongOTPAlertView(
                isCancel: $isCancel,
                isResend: $isResend,
                title: $title,
                message: $message,
                showWrongAlert: $isShowAlert
            )
            .transition(.scale)
            .zIndex(1)
        }
    }
    
    private func presentHomeVC() {
        guard let window = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.windows.first })
            .first else { return }
        
        //           let vc = HomeViewController()
        //           rootVC.present(vc, animated: true)
        let controller = HomeViewController()
        
        let navVC = UINavigationController(rootViewController: controller)
        navVC.navigationBar.isHidden = false
        window.rootViewController = navVC
        window.makeKeyAndVisible()
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

struct TimerView : View {
    @Binding var timeCount : Int
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Text(String(format: "If you didn’t receive a code? Resend OTP in ".localized(), timeCount))
            .foregroundColor(.white)
            .font(FontUtility.body2())
            .padding()
            .onReceive(timer) { _ in
                if timeCount > 0 {
                    timeCount -= 1
                }
            }
    }
}

#Preview {
    OTPView()
}

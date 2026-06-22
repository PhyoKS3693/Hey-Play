//
//  WrongOTPAlertView.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 14/10/2025.
//

import Foundation
import SwiftUI

struct WrongOTPAlertView : View {
    @Binding var isCancel : Bool
    @Binding var isResend : Bool
    @Binding var title : String
    @Binding var message : String
    @Binding var showWrongAlert : Bool
    
    var body: some View {
        ZStack{
            VStack(spacing: 20) {
                CrossBtnView(
                    isShow: $showWrongAlert
                )

                Image("ic.otpError")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)

                AlertMessageView(
                    title: $title,
                    message: $message
                )

                ButtonsView(
                    isCancel: $isCancel,
                    isResend: $isResend,
                    isShow: $showWrongAlert
                )
            }
            .padding(.all, 20)
        }
        .frame(maxWidth: 360)
        .background(Color(red: 28/255, green: 28/255, blue: 30/255))
        .cornerRadius(30)
    }
}

struct CrossBtnView : View {
    @Binding var isShow : Bool
    var body: some View {
        HStack{
            Spacer()
            Button {
                isShow = false
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(width: 30, height: 30)
            }
        }
    }
}

struct AlertMessageView : View {
    @Binding var title : String
    @Binding var message : String

    var body: some View {
        VStack(spacing: 12) {
            Text(title)
                .foregroundColor(.white)
                .font(FontUtility.heading2())
                .fontWeight(.semibold)

            Text(message)
                .foregroundColor(.white)
                .font(FontUtility.body1())
                .multilineTextAlignment(.center)
        }
    }
}

struct ButtonsView : View {
    @Binding var isCancel : Bool
    @Binding var isResend : Bool
    @Binding var isShow : Bool

    var body: some View {
        HStack(spacing: 12) {
            Button {
                print("🚫 [OTP] Cancel tapped")
                isCancel = true
                isShow = false
            } label: {
                Text("Cancel".localized())
                    .font(FontUtility.body1())
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.black)
            .cornerRadius(25)

            Button {
                print("🔄 [OTP] Resend tapped")
                isResend = true
                isShow = false
            } label: {
                Text("Resend".localized())
                    .font(FontUtility.body1())
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color("pink_Color"))
            .cornerRadius(25)
        }
    }
}

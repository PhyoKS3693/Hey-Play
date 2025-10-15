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
            VStack{
                CrossBtnView(
                    isShow: $showWrongAlert
                )
                Image("ic.otpError")
                    .resizable()
                    .frame(width: 80, height: 80)
                Spacer()
                AlertMessageView(
                    title: $title,
                    message: $message
                )
                Spacer()
                ButtonsView(
                    isCancel: $isCancel,
                    isResend: $isResend,
                    isShow: $showWrongAlert
                )
            }
            .padding(.all , 20)

        }
        .frame(maxWidth: 360, maxHeight: 300)
        .background(Color.grey)
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
                Image("ic.cross")
                    .resizable()
                    .frame(width: 30, height: 30)

            }

        }
    }
}

struct AlertMessageView : View {
    @Binding var title : String
    @Binding var message : String
    
    var body: some View {
        VStack{
            Text(title)
                .foregroundColor(.white)
                .font(FontUtility.largeTitleFont())
            Spacer()
            Text(message)
                .foregroundColor(.white)
                .font(FontUtility.normalFont())
        }
        .padding()
    }
}

struct ButtonsView : View {
    @Binding var isCancel : Bool
    @Binding var isResend : Bool
    @Binding var isShow : Bool
    
    var body: some View {
        HStack(spacing: 15, content: {
            Button {
                print("Cancel")
                isCancel = true
                isShow = false
            } label: {
                Text("Cancel".localized())
                    .font(FontUtility.mediumFont())
                    .foregroundColor(.white)
                    
                    
            }
            .frame(maxWidth: .infinity , minHeight: 50)
            .background(Color.black)
            .cornerRadius(15)
            
            Button {
                print("Resend")
                isResend = true
                isShow = false
            } label: {
                Text("Resend".localized())
                    .font(FontUtility.mediumFont())
                    .foregroundColor(.white)
                    
                    
            }
            .frame(maxWidth: .infinity , minHeight: 50)
            .background(Color.primaryBg)
            .cornerRadius(15)

        })
    }
}

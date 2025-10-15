//
//  LoginView.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 14/10/2025.
//

import SwiftUI

struct LoginView: View {
    @State var phoneNumber: String = ""
    @State private var tapContinue = false
    @State private var tapApple = false
    @State private var tapGoogle = false
    @State private var tapFacebook = false
    @State private var tapLine = false
    @State private var tapSkip = false
    
    
    var body: some View {
        NavigationView {
            VStack {
                SkipButtonView(isTapSkip: $tapSkip)
                ScrollView {
                    VStack(spacing: 20, content: {
                        LoginTopView()
                        TextWithTitleView(phoneNumber: $phoneNumber)
                        RoundedButtonView(
                            buttonType: .normal ,
                            isTap: $tapContinue
                        )
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
                
                NavigationLink(destination: OTPView(),
                               isActive: $tapSkip) {
                    EmptyView()
                }
                
                NavigationLink(destination: OTPView(),
                               isActive: $tapContinue) {
                    EmptyView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
            .edgesIgnoringSafeArea(.all)
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
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
                .font(FontUtility.largeTitleFont())
                .foregroundColor(.white)
            
            Text("Hello! Let’s join with us".localized())
                .font(FontUtility.normalFont())
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
                .font(FontUtility.largeTitleFont())
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
                isTapSkip = true
            } label: {
                Text("Skip".localized())
                    .font(FontUtility.normalFont())
                    .foregroundColor(.white)
                    .padding()
            }
            .foregroundColor(.white)
            .frame(width: 70, height: 30)
            .background(Color.lightGrey)
            .cornerRadius(15)
            .padding(.horizontal, 8)
        }
        .padding(.top , 50)
    }
}


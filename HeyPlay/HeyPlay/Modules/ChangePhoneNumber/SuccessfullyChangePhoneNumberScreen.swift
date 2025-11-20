//
//  SuccessfullyChangePhoneNumberScreen.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 10/30/25.
//

import SwiftUI

struct SuccessfullyChangePhoneNumberScreen: View {
    var host: HostController?
    
    var didTapOK: (() -> Void)?
    
    init() {
        
    }
    
    var body: some View {
        VStack {
            Image("redeem_success")
                .resizable()
                .scaledToFit()
                .frame(width: 220, height: 220)
            
            Text("Successful")
                .font(FontUtility.heading2())
                .foregroundColor(Color.white)
                .padding(10)
            
            Text("You have successful changed and  verify your mobile number")
                .font(FontUtility.subHeadline())
                .foregroundColor(Color.white)
                .padding(10)
            
            Button {
                didTapOK?()
            } label: {
                Text("Okay")
                    .font(FontUtility.body1())
                    .foregroundColor(Color.white)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color("pink_Color"))
            .cornerRadius(20)
            
            Spacer()
        }
    }
}

#Preview {
    SuccessfullyChangePhoneNumberScreen()
}

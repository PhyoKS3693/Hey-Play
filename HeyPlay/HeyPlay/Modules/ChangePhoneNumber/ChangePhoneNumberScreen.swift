//
//  ChangePhoneNumberScreen.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 10/24/25.
//

import SwiftUI

struct ChangePhoneNumberScreen: View {
    var host: HostController?
    
    var didTapBack: (() -> Void)?
    var didTapContinue: (() -> Void)?
    
    @ObservedObject private var viewModel: ChangePhoneNumberViewModel
    
    @State var newPhoneNumber: String = ""
    
    init(_ viewModel: ChangePhoneNumberViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 20){
            navView()
            
            Image("change_phone_image")
                .resizable()
                .scaledToFit()
                .frame(width: 228, height: 234)
            
            Text("Phone Number")
                .font(FontUtility.subHeadline())
                .foregroundColor(Color.white)
                .padding(.horizontal, 4)
            
            Text("Your new phone number")
                .font(FontUtility.body1())
                .foregroundColor(Color.white)
                .padding(.horizontal, 4)
            
            VStack(alignment: .leading) {
                Text("Phone Number")
                    .font(FontUtility.caption())
                    .foregroundColor(Color.white)
                
                TextField("", text: $newPhoneNumber)
                    .padding(.horizontal, 20)
                    .frame(height: 40)
                    .font(FontUtility.body1())
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white, lineWidth: 1)
                    )
                    .foregroundColor(.white)
                
                Text("Ooredoo ဖုန်းနံပါတ်များဖြင့်ပြောင်းလို့မရသေးပါ")
                    .font(FontUtility.body2())
                    .foregroundColor(Color.red)
            }
            
            Button {
                didTapContinue?()
            } label: {
                Text("Continue")
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
                
                Text("Change Phone Number")
                    .font(FontUtility.heading1())
                    .foregroundColor(Color("white_color"))
                
                Spacer()
            }
        }
        .padding(10)
        
    }
}

#Preview {
    ChangePhoneNumberScreen(.init())
}

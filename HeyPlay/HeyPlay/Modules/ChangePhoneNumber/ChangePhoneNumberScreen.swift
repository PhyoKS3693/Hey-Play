//
//  ChangePhoneNumberScreen.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 10/24/25.
//

import SwiftUI

struct ChangePhoneNumberScreen: View {
    var host: HostController?
    
    @ObservedObject private var viewModel: ChangePhoneNumberViewModel
    
    @State var newPhoneNumber: String = ""
    
    init(_ viewModel: ChangePhoneNumberViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 20){
            Image("change_phone_image")
                .resizable()
                .scaledToFit()
                .frame(width: 228, height: 234)
            
            Text("Phone Number")
                .font(FontUtility.subHeadline())
                .foregroundColor(Color("white_color"))
                .padding(.horizontal, 4)
            
            Text("Your new phone number")
                .font(FontUtility.body1())
                .foregroundColor(Color("white_color"))
                .padding(.horizontal, 4)
            
            VStack(alignment: .leading) {
                Text("Phone Number")
                    .font(FontUtility.caption())
                    .foregroundColor(Color("white_color"))
                
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
                    .foregroundColor(Color("red_Color"))
            }
            
            Button {
                //didTapOkay?()
            } label: {
                Text("Continue")
                    .font(FontUtility.body1())
                    .foregroundColor(Color("white_color"))
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
    ChangePhoneNumberScreen(.init())
}

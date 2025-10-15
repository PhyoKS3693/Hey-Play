//
//  TextWithTitleView.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 14/10/2025.
//

import Foundation
import SwiftUI

struct TextWithTitleView : View {
    @Binding var phoneNumber: String

    var body: some View {
        VStack (alignment: .leading , spacing: 10, content: {
            Text("Phone Number".localized())
                .font(FontUtility.normalFont())
                .foregroundColor(.white)
            
            ZStack(alignment: .leading) {
                if phoneNumber.isEmpty {
                    Text("09 123456789")
                        .foregroundColor(.gray) 
                        .padding(.leading, 20)
                }

                TextField("", text: $phoneNumber)
                    .padding(.horizontal, 20)
                    .frame(height: 40)
                    .background(Color.black)
                    .font(FontUtility.normalFont())
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white, lineWidth: 1)
                    )
                    .foregroundColor(.white)
            }
        })
        .padding()
    }
}

//
//  CastView.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 15/10/2025.
//

import Foundation
import SwiftUI

struct CastView: View {
    var itemCount : Int = 8
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 16) {
                ForEach(0..<itemCount) { index in
                    CastItemView()
                }
            }
            .padding()
        }
    }
}

struct CastItemView : View {
    var title : String = "Actor"
    var name : String = "Nyunt Win"
    var image : String = ""
    var body: some View {
        Button(action: {
            print("Button Action")
        }, label: {
            HStack(spacing: 10, content: {
                Image("ic-user")
                    .resizable()
                    .frame(width: 35, height: 35)
                    .cornerRadius(17.5)
                    .padding(.leading , 10)
                VStack(alignment: .leading, content: {
                    Text(title)
                        .font(FontUtility.regularFont(size: 8))
                        .foregroundColor(Color.castType)
                        .multilineTextAlignment(.leading)
                    
                    Text(name)
                        .font(FontUtility.regularFont(size: 10))
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.leading)
                })
                .padding(.top , 15)
                .padding(.bottom , 15)
                .padding(.trailing , 15)
            })
        })
        .background(Color.castBg)
        .cornerRadius(15)
    }
}


#Preview {
    CastView()
}

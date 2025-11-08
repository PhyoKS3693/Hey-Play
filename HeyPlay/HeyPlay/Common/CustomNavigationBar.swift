//
//  CustomNavigationBar.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 05/11/2025.
//

import Foundation
import SwiftUI
import Combine

struct CustomNavigationBar : View {
    @Environment(\.presentationMode) var presentationMode
    
//    var onBack: (() -> Void)?
    var body: some View {
        HStack {
            Button(action: {
//                onBack?()
                presentationMode.wrappedValue.dismiss()
            }) {
                Image("ic.nav.back")
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
            }
            Spacer()
        }
        .padding()
        .background(Color.black)
    }
}

#Preview {
    CustomNavigationBar()
}

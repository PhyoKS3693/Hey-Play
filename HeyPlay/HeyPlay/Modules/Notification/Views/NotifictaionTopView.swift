//
//  NotifictaionTopView.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 30/10/2025.
//

import Foundation
import SwiftUI
import Combine

struct NotifictaionTopView : View {
   
    var onDismiss : (() -> Void)?
    var body: some View {
        HStack {
            Text("Notifictaion".localized())
                .foregroundColor(Color.white)
                .font(FontUtility.heading2())
            
            Spacer()
            
            Button {
                onDismiss?()
            } label: {
                Image("ic.cross")
                    .resizable()
                    .frame(width: 30 , height: 30)
            }
        }
        .padding()
        .background(Color.black)
    }
}

#Preview {
    NotifictaionTopView()
}

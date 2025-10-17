//
//  CustomNavigationBarView.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 15/10/2025.
//

import Foundation
import SwiftUI

struct CustomNavBar: View {
    var onBack: (() -> Void)?
    var onShare: (() -> Void)?
    
    var body: some View {
        HStack {
            // Back button
            Button(action: {
                onBack?()
            }) {
                Image("ic.backBtn")
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
                    .background(Color.grey)
                    .clipShape(Circle())
            }
            
            Spacer()
            
            // Center VIP badge
            HStack(spacing: 6) {
                Image("ic.vip")
                    .foregroundColor(.white)
                    .background(
                        Circle()
                            .fill(Color.pink)
                            .frame(width: 20, height: 20)
                    )
                    .frame(width: 20, height: 20)
                
                Text("VIP".localized())
                    .font(FontUtility.largeTitleFont())
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 8)
            .background(Color.grey)
            .cornerRadius(20)
            
            Spacer()
            
            // Share button
            Button(action: {
                onShare?()
            }) {
                Image("ic.share")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
                    .background(Color.grey)
                    .clipShape(Circle())
            }
        }
        .padding(.vertical, 8)
        .cornerRadius(20)
    }
}

#Preview {
    CustomNavBar(onBack: nil, onShare: nil)
}

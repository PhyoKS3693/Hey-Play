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
    var onFavorite: (() -> Void)?
    var onShare: (() -> Void)?
    var subscriptionType: String = "VIP"
    var isFree: Bool = false
    var isFavorite: Bool = false
    var isLoggedIn: Bool = false

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

            // Center subscription badge (VIP or Free)
            if !subscriptionType.isEmpty {
                HStack(spacing: 6) {
                    Image(isFree ? "ic-free" : "ic.vip")
                        .resizable()
                        .renderingMode(.original)
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)

                    Text(subscriptionType)
                        .font(FontUtility.heading2())
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 15)
                .padding(.vertical, 8)
                .background(Color.grey)
                .cornerRadius(20)
            }

            Spacer()

            // Favorite button - only show when logged in
            if isLoggedIn {
                Button(action: {
                    onFavorite?()
                }) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: 32, height: 32)
                        .background(Color.grey)
                        .clipShape(Circle())
                }
            }

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
    CustomNavBar(
        onBack: nil,
        onFavorite: nil,
        onShare: nil,
        subscriptionType: "VIP",
        isFree: false,
        isFavorite: false,
        isLoggedIn: true
    )
}

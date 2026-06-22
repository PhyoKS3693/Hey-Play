//
//  CustomAdBannerView.swift
//  HeyPlay
//
//  Created by Claude on 18/06/2026.
//

import SwiftUI
import Kingfisher

@available(iOS 14.0, *)
struct CustomAdBannerView: View {

    let adsSetting: AdsSetting

    @State private var showLoginDialog = false

    var body: some View {
        ZStack {
            Button(action: {
                handleAdTap()
            }) {
                KFImage(URL(string: adsSetting.safeImage))
                    .placeholder {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .clipped()
                    .cornerRadius(8)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.horizontal, 10)
            .padding(.vertical, 8)

            // Login Required Dialog
            if showLoginDialog {
                LoginRequiredDialog(
                    isPresented: $showLoginDialog,
                    onLogin: {
                        print("📢 [CustomAd] Navigating to login screen")
                        ViewNavigation.shared.showLoginView()
                    }
                )
            }
        }
    }

    private func handleAdTap() {
        guard !adsSetting.safeLink.isEmpty else { return }

        print("📢 [CustomAd] Tapped ad: \(adsSetting.safeTitle)")
        print("📢 [CustomAd] Link: \(adsSetting.safeLink)")
        print("📢 [CustomAd] Is External: \(adsSetting.isExternal ?? false)")
        print("📢 [CustomAd] Auth Required: \(adsSetting.isAuthRequired ?? false)")

        // Check if auth is required
        if adsSetting.isAuthRequired == true {
            if !AppDefaultsManager.shared.isLoggedIn {
                print("⚠️ [CustomAd] Auth required but user not logged in - showing login dialog")
                showLoginDialog = true
                return
            }
        }

        // Open link
        if let url = URL(string: adsSetting.safeLink) {
            if adsSetting.isExternal == true {
                // Open in external browser
                print("📢 [CustomAd] Opening in external browser: \(url)")
                UIApplication.shared.open(url)
            } else {
                // Open in-app
                print("📢 [CustomAd] Opening in-app: \(url)")
                UIApplication.shared.open(url)
            }
        }
    }
}

// MARK: - Preview
#if DEBUG
@available(iOS 14.0, *)
struct CustomAdBannerView_Previews: PreviewProvider {
    static var previews: some View {
        CustomAdBannerView(
            adsSetting: AdsSetting(
                id: 1,
                title: "Vote Ads",
                image: "https://img.heyplay.video/staging/images/payment_method/payment_method_image/payment_method_image_28128021465797991.jpg",
                link: "https://www.google.com/",
                isCustomAds: true,
                isAuthRequired: false,
                isExternal: true
            )
        )
        .background(Color.black)
    }
}
#endif

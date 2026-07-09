//
//  CustomAdBannerView.swift
//  HeyPlay
//
//  Created by Claude on 18/06/2026.
//

import SwiftUI
import Kingfisher
import SafariServices

@available(iOS 14.0, *)
struct CustomAdBannerView: View {

    let adsSetting: AdsSetting

    var body: some View {
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
                showLoginDialog()
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
                // Open in internal browser (SFSafariViewController)
                print("📢 [CustomAd] Opening in internal browser: \(url)")
                openInternalBrowser(url: url)
            }
        }
    }

    private func showLoginDialog() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            print("⚠️ [CustomAd] Could not get root view controller")
            return
        }

        // Get the topmost view controller
        var topController = rootViewController
        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
        }

        // Create a binding for the presented state
        let dialogView = LoginRequiredDialogWrapper(
            onDismiss: {
                topController.dismiss(animated: true)
            },
            onLogin: {
                topController.dismiss(animated: true) {
                    print("📢 [CustomAd] Navigating to login screen")
                    ViewNavigation.shared.showLoginView()
                }
            }
        )

        let hostingController = UIHostingController(rootView: dialogView)
        hostingController.view.backgroundColor = .clear
        hostingController.modalPresentationStyle = .overFullScreen
        hostingController.modalTransitionStyle = .crossDissolve

        topController.present(hostingController, animated: true)
    }

    private func openInternalBrowser(url: URL) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            print("⚠️ [CustomAd] Could not get root view controller")
            return
        }

        let safariVC = SFSafariViewController(url: url)
        safariVC.modalPresentationStyle = .pageSheet

        // Present from the topmost view controller
        var topController = rootViewController
        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
        }

        topController.present(safariVC, animated: true)
    }
}

// MARK: - Login Required Dialog Wrapper
@available(iOS 14.0, *)
struct LoginRequiredDialogWrapper: View {
    let onDismiss: () -> Void
    let onLogin: () -> Void
    @State private var isPresented = true

    var body: some View {
        LoginRequiredDialog(
            isPresented: $isPresented,
            onLogin: {
                onLogin()
            },
            onCancel: {
                onDismiss()
            }
        )
        .onChange(of: isPresented) { newValue in
            if !newValue {
                onDismiss()
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

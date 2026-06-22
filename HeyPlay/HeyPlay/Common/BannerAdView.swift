//
//  BannerAdView.swift
//  HeyPlay
//
//  Created by Claude on 18/06/2026.
//

import SwiftUI
import GoogleMobileAds

// MARK: - Banner Ad View for SwiftUI
@available(iOS 14.0, *)
struct BannerAdView: UIViewRepresentable {

    let adSize: AdSize

    init(adSize: AdSize = AdSizeBanner) {
        self.adSize = adSize
    }

    func makeUIView(context: Context) -> BannerView {
        let bannerView = BannerView(adSize: adSize)
        bannerView.adUnitID = AdManager.AdUnitID.banner

        // Get root view controller
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            bannerView.rootViewController = rootViewController
        }

        bannerView.load(Request())
        return bannerView
    }

    func updateUIView(_ uiView: BannerView, context: Context) {
        // No update needed
    }
}

// MARK: - Banner Ad Container with Size
@available(iOS 14.0, *)
struct BannerAdContainer: View {

    let adSize: AdSize
    let backgroundColor: Color

    init(adSize: AdSize = AdSizeBanner, backgroundColor: Color = Color.black) {
        self.adSize = adSize
        self.backgroundColor = backgroundColor
    }

    var body: some View {
        VStack(spacing: 0) {
            BannerAdView(adSize: adSize)
                .frame(width: CGFloat(adSize.size.width), height: CGFloat(adSize.size.height))
        }
        .frame(maxWidth: .infinity)
        .background(backgroundColor)
    }
}

// MARK: - Preview
#if DEBUG
@available(iOS 14.0, *)
struct BannerAdView_Previews: PreviewProvider {
    static var previews: some View {
        BannerAdContainer()
    }
}
#endif

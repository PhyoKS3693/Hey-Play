//
//  AdManager.swift
//  HeyPlay
//
//  Created by Claude on 18/06/2026.
//

import Foundation
import GoogleMobileAds
import UIKit

final class AdManager: NSObject {

    static let shared = AdManager()

    private override init() {
        super.init()
    }

    // MARK: - Ad Unit IDs
    struct AdUnitID {
        // Test IDs for development
        static let bannerTest = "ca-app-pub-3940256099942544/2934735716"
        static let interstitialTest = "ca-app-pub-3940256099942544/4411468910"
        static let rewardedTest = "ca-app-pub-3940256099942544/1712485313"

        // Production IDs
        static var banner: String {
            #if DEBUG
            return bannerTest
            #else
            return "ca-app-pub-5296255593265550/3097508452" // Your banner ad unit
            #endif
        }

        static var interstitial: String {
            #if DEBUG
            return interstitialTest
            #else
            // TODO: Create interstitial ad unit in AdMob Console and add ID here
            return "ca-app-pub-5296255593265550/XXXXXXXXXX"
            #endif
        }

        static var rewarded: String {
            #if DEBUG
            return rewardedTest
            #else
            // TODO: Create rewarded ad unit in AdMob Console and add ID here
            return "ca-app-pub-5296255593265550/XXXXXXXXXX"
            #endif
        }
    }

    // MARK: - Properties
    private var interstitialAd: InterstitialAd?
    private var rewardedAd: RewardedAd?
    private var isLoadingInterstitial = false
    private var isLoadingRewarded = false

    // MARK: - Banner Ad
    func createBannerView(for viewController: UIViewController) -> BannerView {
        let bannerView = BannerView(adSize: AdSizeBanner)
        bannerView.adUnitID = AdUnitID.banner
        bannerView.rootViewController = viewController
        bannerView.delegate = self
        return bannerView
    }

    func loadBannerAd(_ bannerView: BannerView) {
        let request = Request()
        bannerView.load(request)
        print("📢 [AdManager] Loading banner ad")
    }

    // MARK: - Interstitial Ad
    func loadInterstitialAd(completion: ((Bool) -> Void)? = nil) {
        guard !isLoadingInterstitial else {
            print("⚠️ [AdManager] Interstitial ad already loading")
            completion?(false)
            return
        }

        isLoadingInterstitial = true
        print("📢 [AdManager] Loading interstitial ad")

        let request = Request()
        InterstitialAd.load(with: AdUnitID.interstitial, request: request) { [weak self] ad, error in
            self?.isLoadingInterstitial = false

            if let error = error {
                print("❌ [AdManager] Failed to load interstitial ad: \(error.localizedDescription)")
                completion?(false)
                return
            }

            print("✅ [AdManager] Interstitial ad loaded")
            self?.interstitialAd = ad
            self?.interstitialAd?.fullScreenContentDelegate = self
            completion?(true)
        }
    }

    func showInterstitialAd(from viewController: UIViewController, completion: (() -> Void)? = nil) {
        if let interstitialAd = interstitialAd {
            interstitialAd.present(from: viewController)
            print("📢 [AdManager] Showing interstitial ad")
        } else {
            print("⚠️ [AdManager] Interstitial ad not ready")
            completion?()
            // Preload next ad
            loadInterstitialAd()
        }
    }

    // MARK: - Rewarded Ad
    func loadRewardedAd(completion: ((Bool) -> Void)? = nil) {
        guard !isLoadingRewarded else {
            print("⚠️ [AdManager] Rewarded ad already loading")
            completion?(false)
            return
        }

        isLoadingRewarded = true
        print("📢 [AdManager] Loading rewarded ad")

        let request = Request()
        RewardedAd.load(with: AdUnitID.rewarded, request: request) { [weak self] ad, error in
            self?.isLoadingRewarded = false

            if let error = error {
                print("❌ [AdManager] Failed to load rewarded ad: \(error.localizedDescription)")
                completion?(false)
                return
            }

            print("✅ [AdManager] Rewarded ad loaded")
            self?.rewardedAd = ad
            self?.rewardedAd?.fullScreenContentDelegate = self
            completion?(true)
        }
    }

    func showRewardedAd(from viewController: UIViewController, onRewarded: @escaping (AdReward) -> Void, onDismissed: (() -> Void)? = nil) {
        if let rewardedAd = rewardedAd {
            rewardedAd.present(from: viewController) {
                let reward = rewardedAd.adReward
                print("🎁 [AdManager] User earned reward: \(reward.amount) \(reward.type)")
                onRewarded(reward)
            }
        } else {
            print("⚠️ [AdManager] Rewarded ad not ready")
            onDismissed?()
            // Preload next ad
            loadRewardedAd()
        }
    }

    // MARK: - Check Ad Availability
    var isInterstitialAdReady: Bool {
        return interstitialAd != nil
    }

    var isRewardedAdReady: Bool {
        return rewardedAd != nil
    }
}

// MARK: - BannerViewDelegate
extension AdManager: BannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: BannerView) {
        print("✅ [AdManager] Banner ad loaded successfully")
    }

    func bannerView(_ bannerView: BannerView, didFailToReceiveAdWithError error: Error) {
        print("❌ [AdManager] Banner ad failed to load: \(error.localizedDescription)")
    }

    func bannerViewDidRecordImpression(_ bannerView: BannerView) {
        print("📊 [AdManager] Banner ad impression recorded")
    }

    func bannerViewWillPresentScreen(_ bannerView: BannerView) {
        print("📢 [AdManager] Banner ad will present screen")
    }

    func bannerViewWillDismissScreen(_ bannerView: BannerView) {
        print("📢 [AdManager] Banner ad will dismiss screen")
    }

    func bannerViewDidDismissScreen(_ bannerView: BannerView) {
        print("📢 [AdManager] Banner ad dismissed screen")
    }
}

// MARK: - FullScreenContentDelegate
extension AdManager: FullScreenContentDelegate {
    func adDidRecordImpression(_ ad: FullScreenPresentingAd) {
        print("📊 [AdManager] Full screen ad impression recorded")
    }

    func adDidRecordClick(_ ad: FullScreenPresentingAd) {
        print("👆 [AdManager] Full screen ad clicked")
    }

    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("❌ [AdManager] Full screen ad failed to present: \(error.localizedDescription)")
    }

    func adWillPresentFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("📢 [AdManager] Full screen ad will present")
    }

    func adWillDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("📢 [AdManager] Full screen ad will dismiss")
    }

    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("📢 [AdManager] Full screen ad dismissed")

        // Preload next ad after dismissal
        if ad is InterstitialAd {
            interstitialAd = nil
            loadInterstitialAd()
        } else if ad is RewardedAd {
            rewardedAd = nil
            loadRewardedAd()
        }
    }
}

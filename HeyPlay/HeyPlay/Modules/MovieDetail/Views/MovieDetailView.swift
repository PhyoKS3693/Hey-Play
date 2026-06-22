//
//  MovieDetailView.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 15/10/2025.
//

import Foundation
import SwiftUI

@available(iOS 14.0, *)
struct MovieDetailView: View {
    @ObservedObject var viewModel: MovieDetailViewModel

    @State var tapTrailer: Bool = false
    @State var tapRecommend: Bool = false
    @State var tapEpisodes: Bool = false
    @State var detailType: DetailType = .series
    @State private var isSticky = false
    @State private var scrollOffset: CGFloat = 0
    @State private var showingShare = false
    @State private var showUpgradeDialog = false
    @State private var showSeasonPicker = false
    @State private var currentSelectedSeason: String = "Season 1"

    @Environment(\.presentationMode) var presentationMode

    init(viewModel: MovieDetailViewModel, detailType: DetailType = .series) {
        self.viewModel = viewModel
        self._detailType = State(initialValue: detailType)
    }

    var body: some View {
        ZStack {
            VStack {
                Spacer()
                    .frame(height: 50)
                CustomNavBar(
                    onBack: {
                        presentationMode.wrappedValue.dismiss()
                    },
                    onFavorite: {
                        print("💝 [MovieDetailView] Favorite button tapped - DetailType: \(detailType)")
                        viewModel.toggleFavourite()
                    },
                    onShare: {
                        showingShare = true
                    },
                    subscriptionType: viewModel.subscriptionType,
                    isFree: viewModel.isFree,
                    isFavorite: viewModel.isFavourite,
                    isLoggedIn: AppDefaultsManager.shared.isLoggedIn
                )

                if isSticky {
                    SeriesAndTrailerAndRecommendView(
                        tapTrailer: $tapTrailer,
                        tapRecommend: $tapRecommend,
                        tapEpisodes: $tapEpisodes,
                        detailType: $detailType
                    )
                }

                ScrollView(showsIndicators: false) {
                    ZStack(alignment: .bottom, content: {
                        MovieDetailTopView(imageURL: viewModel.imageURL)
                        MovieDetailInfoView(
                            viewModel: viewModel,
                            detailType: $detailType,
                            showUpgradeDialog: $showUpgradeDialog,
                            showSeasonPicker: $showSeasonPicker,
                            currentSelectedSeason: $currentSelectedSeason
                        )
                        .padding(.bottom, 15)
                    })

                    // Ad Section - Show custom ad if enabled, otherwise show Google ad
                    if let adsSetting = viewModel.contentDetail?.adsSetting,
                       adsSetting.isCustomAds == true,
                       adsSetting.id != nil {
                        // Custom Ad from API
                        CustomAdBannerView(adsSetting: adsSetting)
                    } else {
                        // Google AdMob Banner as fallback
                        BannerAdContainer()
                    }

                    SeriesAndTrailerAndRecommendView(
                        tapTrailer: $tapTrailer,
                        tapRecommend: $tapRecommend,
                        tapEpisodes: $tapEpisodes,
                        detailType: $detailType
                    )

                    MovieDetailBottomView(
                        viewModel: viewModel,
                        tapTrailer: $tapTrailer,
                        tapRecommend: $tapRecommend,
                        tapEpisodes: $tapEpisodes,
                        detailType: $detailType,
                        showUpgradeDialog: $showUpgradeDialog
                    )

                    GeometryReader { geo in
                        Color.clear
                            .preference(
                                key: ScrollOffsetPreferenceKey.self,
                                value: geo.frame(in: .global).minY
                            )
                    }
                    .frame(height: 0)
                }
                .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                    scrollOffset = value
                    // Sticky header is disabled for all tabs
                    self.isSticky = false
                }
            }

            // Loading Overlay
            if viewModel.isLoading {
                LoadingOverlayView()
            }

            // Upgrade VIP Dialog
            if showUpgradeDialog {
                UpgradeVIPDialog(
                    isPresented: $showUpgradeDialog,
                    onUpgrade: {
                        // Navigate to subscription plans
                        print("✅ [MovieDetailView] Navigating to subscription plan screen")
                        ViewNavigation.shared.showSubscriptionPlan()
                    }
                )
            }
        }
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
        .toast($viewModel.toast)
        .onAppear {
            viewModel.fetchContentDetail()
        }
        .onChange(of: viewModel.contentDetail) { newDetail in
            // Set default tab based on content type
            if detailType == .series {
                tapEpisodes = true
                tapTrailer = false
                tapRecommend = false
            } else {
                tapEpisodes = false
                tapTrailer = true
                tapRecommend = false
            }

            // Set current selected season - match contentDetail.id with season.movieId
            if let contentDetail = newDetail {
                // Find the season where movieId matches contentDetail.id
                if let matchingSeason = viewModel.seasonList.first(where: { $0.movieId == contentDetail.id }) {
                    currentSelectedSeason = matchingSeason.safeSeasonName
                    print("🎬 [MovieDetailView] Found matching season: \(matchingSeason.safeSeasonName) (movieId: \(matchingSeason.movieId ?? -1) == contentId: \(contentDetail.id))")
                } else if let firstSeason = viewModel.seasonList.first {
                    // Fallback to first season if no match found
                    currentSelectedSeason = firstSeason.safeSeasonName
                    print("⚠️ [MovieDetailView] No matching season found, using first season: \(firstSeason.safeSeasonName)")
                }
            }
        }
        .sheet(isPresented: $showingShare) {
            ShareSheetView(
                title: viewModel.title,
                shareUrl: viewModel.contentDetail?.safeShareUrl ?? ""
            )
        }
    }
}

// MARK: - Loading Overlay View
@available(iOS 14.0, *)
struct LoadingOverlayView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 16) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)

                Text("Loading...")
                    .foregroundColor(.white)
                    .font(.subheadline)
            }
            .padding(30)
            .background(Color.black.opacity(0.7))
            .cornerRadius(16)
        }
    }
}

// MARK: - Share Sheet View
@available(iOS 14.0, *)
struct ShareSheetView: View {
    let title: String
    let shareUrl: String

    var body: some View {
        let text = "Check out \(title)!"
        let activityItems = buildActivityItems()

        return ActivityView(
            activityItems: activityItems,
            excludedActivityTypes: [.assignToContact, .addToReadingList]
        ) { activity, completed, items, error in
            if completed {
                print("Shared via:", activity?.rawValue ?? "unknown")
            } else {
                print("Share cancelled")
            }
            if let err = error {
                print("Share error:", err)
            }
        }
    }

    private func buildActivityItems() -> [Any] {
        let text = "Check out \(title)!"
        var activityItems: [Any] = [text]

        if let url = URL(string: shareUrl), !shareUrl.isEmpty {
            activityItems.append(url)
            print("✅ [ShareSheetView] Sharing with URL: \(shareUrl)")
        } else {
            print("⚠️ [ShareSheetView] No valid share URL available")
        }

        return activityItems
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}


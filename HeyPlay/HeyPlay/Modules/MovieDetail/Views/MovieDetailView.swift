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
    @State private var selectedEpisodeId: Int?
    @State private var displayImageURL: String = ""
    @State private var displayTitle: String = ""

    @Environment(\.presentationMode) var presentationMode

    var initialEpisodeId: Int?

    init(viewModel: MovieDetailViewModel, detailType: DetailType = .series, initialEpisodeId: Int? = nil) {
        self.viewModel = viewModel
        self._detailType = State(initialValue: detailType)
        self.initialEpisodeId = initialEpisodeId
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
                        MovieDetailTopView(
                            imageURL: displayImageURL.isEmpty ? viewModel.imageURL : displayImageURL
                        )
                        MovieDetailInfoView(
                            viewModel: viewModel,
                            detailType: $detailType,
                            showUpgradeDialog: $showUpgradeDialog,
                            showSeasonPicker: $showSeasonPicker,
                            currentSelectedSeason: $currentSelectedSeason,
                            displayTitle: displayTitle
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
                        showUpgradeDialog: $showUpgradeDialog,
                        showLoginDialog: $viewModel.showLoginDialog,
                        selectedEpisodeId: $selectedEpisodeId,
                        onEpisodeSelected: { episode in
                            if let episode = episode {
                                // Episode selected - show episode info
                                print("📺 [MovieDetailView] Episode selected: \(episode.name ?? "")")
                                displayImageURL = episode.safeDetailImage
                                displayTitle = episode.name ?? ""
                            } else {
                                // Episode deselected - show series detail info
                                print("📺 [MovieDetailView] Episode deselected - showing series info")
                                displayImageURL = ""
                                displayTitle = ""
                            }
                        }
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

            // Login Required Dialog
            if viewModel.showLoginDialog {
                LoginRequiredDialog(
                    isPresented: $viewModel.showLoginDialog,
                    onLogin: {
                        print("📢 [MovieDetailView] Navigating to login screen")
                        ViewNavigation.shared.showLoginView()
                    },
                    onCancel: {
                        viewModel.showLoginDialog = false
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

            // Reset episode selection and display when content changes
            selectedEpisodeId = nil
            displayImageURL = ""
            displayTitle = ""
        }
        .onChange(of: viewModel.episodes) { episodes in
            // Auto-select episode if initialEpisodeId is provided and not yet selected
            if let initialEpisodeId = initialEpisodeId,
               selectedEpisodeId == nil,
               !episodes.isEmpty {
                if let episode = episodes.first(where: { $0.episodeId == initialEpisodeId }) {
                    print("📺 [MovieDetailView] Auto-selecting episode from notification: \(episode.name ?? "")")
                    selectedEpisodeId = episode.id
                    displayImageURL = episode.safeDetailImage
                    displayTitle = episode.name ?? ""
                } else {
                    print("⚠️ [MovieDetailView] Episode with ID \(initialEpisodeId) not found in current episode list")
                }
            }

            // Reset episode selection when episodes change (e.g., season change)
            // But only if we're not auto-selecting from notification
            if initialEpisodeId == nil || selectedEpisodeId != nil {
                // Don't reset if we just auto-selected
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


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
                    if tapRecommend {
                        self.isSticky = scrollOffset <= 1590
                    } else if tapTrailer || tapEpisodes {
                        self.isSticky = false
                    }
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
                        // TODO: Implement navigation to subscription page
                        print("Navigate to subscription plans")
                    }
                )
            }

            // Season Dropdown Overlay
            if showSeasonPicker && detailType == .series && viewModel.hasSeasons {
                ZStack {
                    // Tap outside to dismiss
                    Color.clear
                        .contentShape(Rectangle())
                        .onTapGesture {
                            showSeasonPicker = false
                        }

                    // Dropdown list positioned below season button
                    GeometryReader { geometry in
                        VStack(spacing: 0) {
                            Spacer()
                                .frame(height: 445)

                            HStack(spacing: 0) {
                                SeasonDropdownList(
                                    viewModel: viewModel,
                                    isOpen: $showSeasonPicker,
                                    currentSelectedSeason: $currentSelectedSeason
                                )
                                .frame(width: (geometry.size.width - 40 - 16) / 2)
                                .padding(.leading, 20)

                                Spacer()
                            }

                            Spacer()
                        }
                    }
                }
            }
        }
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
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

            // Set current selected season
            if let selectedId = viewModel.selectedSeasonId,
               let season = viewModel.seasonList.first(where: { $0.seasonId == selectedId }) {
                currentSelectedSeason = season.safeSeasonName
            } else if let firstSeason = viewModel.seasonList.first {
                currentSelectedSeason = firstSeason.safeSeasonName
            }
        }
        .sheet(isPresented: $showingShare) {
            let text = "Check out \(viewModel.title)!"
            let url = URL(string: "https://example.com")!
            ActivityView(activityItems: [text, url],
                         excludedActivityTypes: [.assignToContact, .addToReadingList]) { activity, completed, items, error in
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

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}


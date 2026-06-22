//
//  MovieDetailTopView.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 15/10/2025.
//

import Foundation
import SwiftUI
import Kingfisher

@available(iOS 14.0, *)
struct MovieDetailTopView: View {
    var imageURL: String = ""

    var body: some View {
        // Movie poster image - landscape header image with fixed height
        if let url = URL(string: imageURL), !imageURL.isEmpty {
            KFImage(url)
                .placeholder {
                    Image("image2")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: UIScreen.main.bounds.width, height: 400)
                        .clipped()
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width, height: 400)
                .clipped()
        } else {
            Image("image2")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width, height: 400)
                .clipped()
        }
    }
}

@available(iOS 14.0, *)
struct MovieDetailInfoView: View {
    @ObservedObject var viewModel: MovieDetailViewModel
    @Binding var detailType: DetailType
    @Binding var showUpgradeDialog: Bool
    @Binding var showSeasonPicker: Bool
    @Binding var currentSelectedSeason: String

    var body: some View {
        if #available(iOS 15.0, *) {
            VStack(spacing: 16) {
                MovieTitleInfoView(viewModel: viewModel)
                MovieActionButtonsView(
                    viewModel: viewModel,
                    detailType: $detailType,
                    showUpgradeDialog: $showUpgradeDialog,
                    showSeasonPicker: $showSeasonPicker,
                    currentSelectedSeason: $currentSelectedSeason
                )
            }
            .background(
                ZStack {
                    Color(red: 59/255, green: 57/255, blue: 59/255)
                        .opacity(0.5)
                }
                    .cornerRadius(20)
            )
            .padding(.horizontal, 10)
            .overlay(alignment: .bottomLeading) {
                // Season dropdown overlay - appears below the info card
                // Only show if there's more than one season
                if showSeasonPicker && detailType == .series && viewModel.hasSeasons && viewModel.seasonList.count > 1 {
                    GeometryReader { geometry in
                        HStack {
                            SeasonDropdownList(
                                viewModel: viewModel,
                                isOpen: $showSeasonPicker,
                                currentSelectedSeason: $currentSelectedSeason
                            )
                            .frame(width: (geometry.size.width - 20 - 16) / 2)
                            .padding(.leading, 20)

                            Spacer()
                        }
                        .offset(y: 55)
                    }
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
}

@available(iOS 14.0, *)
struct MovieTitleInfoView: View {
    @ObservedObject var viewModel: MovieDetailViewModel

    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            // MARK: Movie title
            Text(viewModel.title.isEmpty ? "Movie Title" : viewModel.title)
                .font(FontUtility.heading1())
                .foregroundColor(.white)
                .multilineTextAlignment(.center)

            // MARK: Details row
            HStack(spacing: 15) {
                // Release Date - only show for movies
                if !viewModel.releaseDate.isEmpty {
                    HStack(spacing: 5) {
                        Image("ic.calendar")
                            .resizable()
                            .frame(width: 15, height: 15)

                        Text(viewModel.releaseDate)
                            .font(FontUtility.smallText1())
                            .foregroundColor(Color.white)
                    }
                }

                // Show separator only if both release date and duration exist
                if !viewModel.releaseDate.isEmpty && !viewModel.duration.isEmpty {
                    Text("|")
                        .foregroundColor(Color("searchColor"))
                }

                // Duration
                if !viewModel.duration.isEmpty {
                    HStack(spacing: 5) {
                        Image("ic.time")
                            .resizable()
                            .frame(width: 15, height: 15)

                        Text(viewModel.duration)
                            .font(FontUtility.smallText1())
                            .foregroundColor(Color.white)
                    }
                }
            }

            // Subscription Type Badge removed - already shown at top

            HStack(spacing: 10) {
                Image("ic.type")
                    .resizable()
                    .frame(width: 15, height: 15)

                Text(viewModel.categoryDisplayText.isEmpty ? "No category available" : viewModel.categoryDisplayText)
                    .font(FontUtility.smallText1())
                    .foregroundColor(Color.white)
            }
        }
        .padding(.top, 10)
    }
}

@available(iOS 14.0, *)
struct MovieActionButtonsView: View {
    @ObservedObject var viewModel: MovieDetailViewModel
    @Binding var detailType: DetailType
    @Binding var showUpgradeDialog: Bool
    @Binding var showSeasonPicker: Bool
    @Binding var currentSelectedSeason: String

    var didTapVideoPlay: (() -> Void)?

    var body: some View {
        HStack(spacing: 16) {
            if detailType == .movie {
                Button(action: {
                    handlePlayTapped()
                }) {
                    HStack {
                        Image(systemName: "play.fill")
                        Text("Play")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: 40)
                    .background(Color.primaryBg)
                    .cornerRadius(25)
                }
            } else {
                if viewModel.hasSeasons {
                    SeasonDropdownButton(
                        selectedSeason: $currentSelectedSeason,
                        isOpen: $showSeasonPicker,
                        seasonCount: viewModel.seasonList.count
                    )
                } else {
                    // No seasons available - show disabled button
                    HStack {
                        Text("Season 1")
                        Image("ic.downarrow")
                            .resizable()
                            .frame(width: 25, height: 25)
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: 40)
                    .background(Color.black.opacity(0.7))
                    .cornerRadius(25)
                }
            }

            Button(action: {
                viewModel.toggleWatchList()
            }) {
                HStack(spacing: 8) {
                    if viewModel.isInWatchList {
                        Image("ic_watchlist_active")
                            .resizable()
                            .renderingMode(.original)
                            .frame(width: 18, height: 18)
                    } else {
                        Image(systemName: "plus")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    Text("Watchlist")
                        .font(.headline)
                        .foregroundColor(viewModel.isInWatchList ? Color("pink_Color") : .white)
                }
                .frame(maxWidth: .infinity, maxHeight: 40)
                .background(Color.black.opacity(0.7))
                .cornerRadius(20)
            }
        }
        .padding(.all, 10)
    }

    // MARK: - Handle Play Tapped
    private func handlePlayTapped() {
        print("🎬 [MovieActionButtonsView] Play tapped")
        print("🎬 [MovieActionButtonsView] isPlayable: \(viewModel.isPlayable)")
        print("🎬 [MovieActionButtonsView] streamingUrl: \(viewModel.streamingUrl)")

        if viewModel.isPlayable {
            // Playable - show video player
            print("✅ [MovieActionButtonsView] Content is playable, showing player")

            // Get movieId from contentDetail
            let movieId = viewModel.contentDetail?.id ?? 0

            ViewNavigation.shared.showVideoPlayer(
                streamingUrl: viewModel.streamingUrl,
                title: viewModel.title,
                movieId: movieId,
                episodeId: nil
            )
        } else {
            // Not playable - show upgrade dialog
            print("⚠️ [MovieActionButtonsView] Content not playable, showing upgrade dialog")
            showUpgradeDialog = true
        }
    }
}

// MARK: - Season Dropdown Button
@available(iOS 14.0, *)
struct SeasonDropdownButton: View {
    @Binding var selectedSeason: String
    @Binding var isOpen: Bool
    var seasonCount: Int = 1

    var body: some View {
        Button(action: {
            // Only toggle dropdown if there's more than one season
            if seasonCount > 1 {
                isOpen.toggle()
            }
        }) {
            HStack {
                Text(selectedSeason)
                // Only show arrow if there's more than one season
                if seasonCount > 1 {
                    Image(isOpen ? "ic.upArrow" : "ic.downarrow")
                        .resizable()
                        .frame(width: 25, height: 25)
                }
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, maxHeight: 40)
            .background(Color.black.opacity(0.7))
            .cornerRadius(25)
        }
    }
}

// MARK: - Season Dropdown List
@available(iOS 14.0, *)
struct SeasonDropdownList: View {
    @ObservedObject var viewModel: MovieDetailViewModel
    @Binding var isOpen: Bool
    @Binding var currentSelectedSeason: String

    private let itemHeight: CGFloat = 50
    private let maxHeight: CGFloat = 200

    var body: some View {
        VStack(spacing: 0) {
            ForEach(viewModel.seasonList, id: \.id) { season in
                Button(action: {
                    print("📺 [SeasonDropdownList] Season tapped: \(season.safeSeasonName)")
                    print("📺 [SeasonDropdownList] Season movieId: \(season.movieId ?? -1)")
                    viewModel.selectSeason(season)
                    currentSelectedSeason = season.safeSeasonName
                    isOpen = false
                }) {
                    Text(season.safeSeasonName)
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: itemHeight)
                        .contentShape(Rectangle())
                }
            }
        }
        .background(Color.black)
        .cornerRadius(20)
        .frame(maxHeight: maxHeight)
    }
}


#if DEBUG
@available(iOS 14.0, *)
struct MovieDetailTopView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailTopView(imageURL: "")
    }
}
#endif

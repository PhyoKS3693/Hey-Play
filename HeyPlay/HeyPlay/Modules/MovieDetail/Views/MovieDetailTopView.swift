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
        // Movie poster image (no overlay badge)
        if let url = URL(string: imageURL), !imageURL.isEmpty {
            KFImage(url)
                .placeholder {
                    Image("image2")
                        .resizable()
                        .frame(maxWidth: .infinity, maxHeight: 400)
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, maxHeight: 400)
                .clipped()
        } else {
            Image("image2")
                .resizable()
                .frame(maxWidth: .infinity, maxHeight: 400)
        }
    }
}

@available(iOS 14.0, *)
struct MovieDetailInfoView: View {
    @ObservedObject var viewModel: MovieDetailViewModel
    @Binding var detailType: DetailType
    @Binding var showUpgradeDialog: Bool

    var body: some View {
        VStack(spacing: 16) {
            MovieTitleInfoView(viewModel: viewModel)
            MovieActionButtonsView(
                viewModel: viewModel,
                detailType: $detailType,
                showUpgradeDialog: $showUpgradeDialog
            )
        }
        .background(
            // MARK: Blurred background card
            BlurView(style: .systemUltraThinMaterialDark)
                .cornerRadius(20)
                .shadow(radius: 8)
        )
        .padding(.horizontal, 10)
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

            // Subscription Type Badge
            if !viewModel.subscriptionType.isEmpty {
                HStack(spacing: 4) {
                    Image(viewModel.isFree ? "ic-free" : "ic-vip")
                        .resizable()
                        .renderingMode(.original)
                        .frame(width: 16, height: 16)
                        .foregroundColor(.white)

                    Text(viewModel.subscriptionType)
                        .font(FontUtility.smallText1())
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.white.opacity(0.3))
                .cornerRadius(12)
            }

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
                Button(action: {
                    print("Season tapped")
                }) {
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
                HStack {
                    Image(systemName: viewModel.isInWatchList ? "checkmark" : "plus")
                    Text("Watchlist")
                }
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, maxHeight: 40)
                .background(viewModel.isInWatchList ? Color.primaryBg : Color.black.opacity(0.7))
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

#if DEBUG
@available(iOS 14.0, *)
struct MovieDetailTopView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailTopView(imageURL: "")
    }
}
#endif

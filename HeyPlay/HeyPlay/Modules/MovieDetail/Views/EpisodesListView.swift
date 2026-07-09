//
//  EpisodesListView.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 17/10/2025.
//

import Foundation
import SwiftUI
import Kingfisher

@available(iOS 14.0, *)
struct EpisodesListView : View {
    var episodes: [Episode] = []
    var movieTitle: String = ""
    var movieId: Int = 0
    @Binding var showUpgradeDialog: Bool
    @Binding var showLoginDialog: Bool
    @Binding var selectedEpisodeId: Int?
    var onEpisodeSelected: ((Episode?) -> Void)?

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(Array(episodes.enumerated()), id: \.element.id) { index, episode in
                    EpisodeItemView(
                        episodeName: episode.name ?? "Episode \(index + 1)",
                        description: episode.safeDescription,
                        thumbnailURL: episode.safeDetailImage,
                        isPlayable: episode.isPlayable,
                        streamingUrl: episode.safeStreamingUrl,
                        movieTitle: movieTitle,
                        movieId: movieId,
                        episodeId: String(episode.episodeId ?? 0),
                        showUpgradeDialog: $showUpgradeDialog,
                        showLoginDialog: $showLoginDialog,
                        isSelected: selectedEpisodeId == episode.id,
                        onTap: {
                            // Toggle selection - if already selected, deselect it
                            if selectedEpisodeId == episode.id {
                                selectedEpisodeId = nil
                                onEpisodeSelected?(nil)
                            } else {
                                selectedEpisodeId = episode.id
                                onEpisodeSelected?(episode)
                            }
                        }
                    )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(Color.black)
    }
}

@available(iOS 14.0, *)
struct EpisodeItemView : View {
    var episodeName: String = "Episode 1"
    var description: String = "အန်တီက အကယ်ဒမီဆုရအောင် ကြိုးစားလာခဲ့တာ... "
    var thumbnailURL: String = ""
    var isPlayable: Bool = false
    var streamingUrl: String = ""
    var movieTitle: String = ""
    var movieId: Int = 0
    var episodeId: String? = nil
    @Binding var showUpgradeDialog: Bool
    @Binding var showLoginDialog: Bool
    var isSelected: Bool = false
    var onTap: (() -> Void)?

    var body: some View {
        Button(action: {
            onTap?()
        }) {
            episodeContent
        }
        .buttonStyle(PlainButtonStyle())
    }

    var episodeContent: some View {
        HStack(spacing: 12) {
            // Thumbnail with FREE/VIP badge overlay
            ZStack(alignment: .bottomLeading) {
                if let url = URL(string: thumbnailURL), !thumbnailURL.isEmpty {
                    KFImage(url)
                        .placeholder {
                            Image("series")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 120, height: 90)
                                .cornerRadius(12)
                                .clipped()
                        }
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 120, height: 90)
                        .cornerRadius(12)
                        .clipped()
                } else {
                    Image("series")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 120, height: 90)
                        .cornerRadius(12)
                        .clipped()
                }

                // FREE/VIP Badge
                HStack(spacing: 4) {
                    Image(isPlayable ? "ic-free" : "ic-vip")
                        .resizable()
                        .frame(width: 14, height: 14)

                    Text(isPlayable ? "FREE" : "VIP")
                        .font(FontUtility.smallText4())
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 6)
                .padding(.vertical, 3)
                .background(
                    ZStack {
                        BlurView(style: .systemUltraThinMaterialDark)
                        Color.white.opacity(0.04)
                    }
                )
                .cornerRadius(8)
                .padding(8)
            }
            .frame(width: 120, height: 90)

            // Episode info
            VStack(alignment: .leading, spacing: 4) {
                Text(episodeName)
                    .font(FontUtility.body2())
                    .foregroundColor(.white)
                    .lineLimit(1)

                Text(description)
                    .font(FontUtility.smallText2())
                    .foregroundColor(Color.white.opacity(0.6))
                    .lineLimit(2)
            }

            Spacer()

            // Play button or Buy VIP button
            Button {
                handlePlayTapped()
            } label: {
                if isPlayable {
                    // Free episode - show play icon
                    Image("ic.series.play")
                        .resizable()
                        .frame(width: 40, height: 40)
                } else {
                    // VIP episode - show "Buy VIP" button
                    Text("Buy VIP")
                        .font(FontUtility.smallText1())
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color("primaryBgColor"))
                        .cornerRadius(22)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.darkGrey)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isSelected ? Color("pink_Color") : Color.clear, lineWidth: 3)
        )
    }

    // MARK: - Handle Play Tapped
    private func handlePlayTapped() {
        print("🎬 [EpisodeItemView] Play tapped for: \(episodeName)")
        print("🎬 [EpisodeItemView] isPlayable: \(isPlayable)")
        print("🎬 [EpisodeItemView] streamingUrl: \(streamingUrl)")
        print("🎬 [EpisodeItemView] movieId: \(movieId), episodeId: \(episodeId ?? "nil")")

        if isPlayable {
            // Playable - show video player
            print("✅ [EpisodeItemView] Episode is playable, showing player")
            ViewNavigation.shared.showVideoPlayer(
                streamingUrl: streamingUrl,
                title: "\(movieTitle) - \(episodeName)",
                movieId: movieId,
                episodeId: episodeId
            )
        } else {
            // Not playable - check if user is logged in
            if !AppDefaultsManager.shared.isLoggedIn {
                print("⚠️ [EpisodeItemView] User not logged in, showing login dialog")
                showLoginDialog = true
            } else {
                // Logged in but not VIP - show upgrade dialog
                print("⚠️ [EpisodeItemView] Episode not playable, showing upgrade dialog")
                showUpgradeDialog = true
            }
        }
    }
}


#if DEBUG
@available(iOS 14.0, *)
struct EpisodesListView_Previews: PreviewProvider {
    static var previews: some View {
        EpisodesListView(
            episodes: [],
            movieTitle: "Movie Title",
            movieId: 0,
            showUpgradeDialog: .constant(false),
            showLoginDialog: .constant(false),
            selectedEpisodeId: .constant(nil),
            onEpisodeSelected: nil
        )
    }
}
#endif

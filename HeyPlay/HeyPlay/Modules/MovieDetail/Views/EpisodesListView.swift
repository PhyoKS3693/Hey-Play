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

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10, content: {
                if episodes.isEmpty {
                    ForEach(0..<10, id: \.self) { _ in
                        EpisodeItemView(
                            episodeName: "Episode",
                            description: "Loading...",
                            thumbnailURL: "",
                            isPlayable: false,
                            streamingUrl: "",
                            movieTitle: "",
                            movieId: 0,
                            episodeId: nil,
                            showUpgradeDialog: $showUpgradeDialog
                        )
                    }
                } else {
                    ForEach(episodes) { episode in
                        EpisodeItemView(
                            episodeName: episode.episodeName,
                            description: episode.description ?? "",
                            thumbnailURL: episode.thumbnail ?? "",
                            isPlayable: episode.isPlayable,
                            streamingUrl: episode.safeStreamingUrl,
                            movieTitle: movieTitle,
                            movieId: movieId,
                            episodeId: String(episode.episodeId ?? 0),
                            showUpgradeDialog: $showUpgradeDialog
                        )
                    }
                }
            })
            .padding()
        }
        .background(Color.grey)
        .cornerRadius(15)
        .edgesIgnoringSafeArea(.all)
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

    var body: some View {
        HStack(spacing: 10, content: {
            if let url = URL(string: thumbnailURL), !thumbnailURL.isEmpty {
                KFImage(url)
                    .placeholder {
                        Image("series")
                            .resizable()
                            .frame(width: 120, height: 70)
                    }
                    .resizable()
                    .frame(width: 120, height: 70)
            } else {
                Image("series")
                    .resizable()
                    .frame(width: 120, height: 70)
            }

            EpisodeInfoView(
                episodeName: episodeName,
                description: description
            )

            Button {
                handlePlayTapped()
            } label: {
                Image("ic.series.play")
                    .resizable()
                    .frame(width: 30 , height: 30)
            }

        })
        .padding(.all , 10)
        .background(Color.castBg)
        .cornerRadius(15)

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
            // Not playable - show upgrade dialog
            print("⚠️ [EpisodeItemView] Episode not playable, showing upgrade dialog")
            showUpgradeDialog = true
        }
    }
}

@available(iOS 14.0, *)
struct EpisodeInfoView : View {
    var episodeName : String = ""
    var description : String = ""
    var body: some View {
        VStack(alignment: .leading, spacing: 10, content: {
            Text(episodeName)
                .font(FontUtility.body2())
                .foregroundColor(.white)
            
            Text(description)
                .font(FontUtility.body2())
                .foregroundColor(Color.castType)
        })
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
            showUpgradeDialog: .constant(false)
        )
    }
}
#endif

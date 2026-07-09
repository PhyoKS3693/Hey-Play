//
//  MovieDetailBottomView.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 15/10/2025.
//

import Foundation
import SwiftUI
import Kingfisher
import AVKit

@available(iOS 14.0, *)
struct MovieDetailBottomView: View {
    @ObservedObject var viewModel: MovieDetailViewModel
    @Binding var tapTrailer: Bool
    @Binding var tapRecommend: Bool
    @Binding var tapEpisodes: Bool
    @Binding var detailType: DetailType
    @Binding var showUpgradeDialog: Bool
    @Binding var showLoginDialog: Bool
    @Binding var selectedEpisodeId: Int?
    var onEpisodeSelected: ((Episode?) -> Void)?

    var body: some View {
        VStack(content: {
            if tapEpisodes {
                if viewModel.hasEpisodes {
                    EpisodesListView(
                        episodes: viewModel.episodes,
                        movieTitle: viewModel.title,
                        movieId: viewModel.contentDetail?.id ?? 0,
                        showUpgradeDialog: $showUpgradeDialog,
                        showLoginDialog: $showLoginDialog,
                        selectedEpisodeId: $selectedEpisodeId,
                        onEpisodeSelected: onEpisodeSelected
                    )
                } else {
                    EmptyEpisodesView()
                }
            }

            if tapRecommend {
                RecommendView(movies: viewModel.recommendMovies) { movieId, isSeries in
                    let detailType: DetailType = isSeries ? .series : .movie
                    ViewNavigation.shared.showMovieDetail(detailType: detailType, movieId: movieId)
                }
            }

            if tapTrailer {
                ZStack {
                    VStack {
                        MovieDetailDescriptionView(
                            description: viewModel.description,
                            imageURL: viewModel.imageURL,
                            trailerUrl: viewModel.contentDetail?.safeTrailerUrl ?? ""
                        )

                        CastView(cast: viewModel.cast)
                    }
                }
                .background(Color.grey)
                .cornerRadius(20)
            }
            Spacer()
        })
        .background(Color.black)
    }
}

@available(iOS 14.0, *)
struct SeriesAndTrailerAndRecommendView : View {
    @Binding var tapTrailer : Bool
    @Binding var tapRecommend : Bool
    @Binding var tapEpisodes : Bool
    @Binding var detailType : DetailType

    var body: some View {
            HStack(spacing: 16) {

                if detailType == .series {
                    Button(action: {
                        tapEpisodes = true
                        tapTrailer = false
                        tapRecommend = false
                    }) {
                        Text("Episodes".localized())
                            .font(FontUtility.body1())
                        .foregroundColor(.white)

                    }
                    .frame(maxWidth: 150, minHeight: 40)
                    .background(tapEpisodes ? Color.primaryBg : Color.recommendBG)
                    .cornerRadius(25)
                }
                
                Button(action: {
                    tapEpisodes = false
                    tapTrailer = true
                    tapRecommend = false
                }) {
                    Text("Trailers & Info".localized())
                        .font(FontUtility.body1())
                    .foregroundColor(.white)
                    
                }
                .frame(maxWidth: 150, minHeight: 40)
                .background(tapTrailer ? Color.primaryBg : Color.recommendBG)
                .cornerRadius(25)
                
                Button(action: {
                    tapEpisodes = false
                    tapTrailer = false
                    tapRecommend = true
                }) {
                    Text("Recommend".localized())
                        .font(FontUtility.body1())
                    .foregroundColor(.white)
                    
                }
                .frame(maxWidth: 150, minHeight: 40)
                .background(tapRecommend ? Color.primaryBg : Color.recommendBG)
                .cornerRadius(20)
                
                Spacer()
            }
            .padding(.vertical , 10)
    }
}

@available(iOS 14.0, *)
struct MovieDetailDescriptionView: View {
    var description: String = ""
    var imageURL: String = ""
    var trailerUrl: String = ""

    var body: some View {
        VStack(spacing: 12) {
            // Show video player if trailer URL is available, otherwise show poster image
            if !trailerUrl.isEmpty, let url = URL(string: trailerUrl) {
                TrailerVideoPlayer(videoURL: url)
                    .frame(height: 300)
                    .cornerRadius(20)
                    .padding(.top, 12)
                    .padding(.horizontal, 12)
            } else {
                ZStack {
                    if let url = URL(string: imageURL), !imageURL.isEmpty {
                        KFImage(url)
                            .placeholder {
                                Image("image2")
                                    .resizable()
                                    .frame(height: 300)
                                    .cornerRadius(20)
                            }
                            .resizable()
                            .frame(height: 300)
                            .cornerRadius(20)
                    } else {
                        Image("image2")
                            .resizable()
                            .frame(height: 300)
                            .cornerRadius(20)
                    }

                    Image("ic-play")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                }
                .padding(.top, 12)
                .padding(.horizontal, 12)
            }

            HStack {
                Text("Description".localized())
                    .font(FontUtility.headline2())
                    .foregroundColor(.white)

                Spacer()
            }
            .padding(.horizontal, 12)

            Text(description.isEmpty ? "No description available." : description)
                .font(FontUtility.body2())
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.bottom, 16)
        }
    }
}

@available(iOS 14.0, *)
struct TrailerVideoPlayer: UIViewControllerRepresentable {
    let videoURL: URL

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let player = AVPlayer(url: videoURL)
        let controller = AVPlayerViewController()
        controller.player = player
        controller.showsPlaybackControls = true

        // Auto-play trailer
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            player.play()
        }

        return controller
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        // Update player if URL changes
        if let currentURL = (uiViewController.player?.currentItem?.asset as? AVURLAsset)?.url,
           currentURL != videoURL {
            let newPlayer = AVPlayer(url: videoURL)
            uiViewController.player = newPlayer
            newPlayer.play()
        }
    }
}

@available(iOS 14.0, *)
struct EmptyEpisodesView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "film.stack")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundColor(.gray)
                .padding(.top, 40)

            Text("No Episodes Available")
                .font(FontUtility.headline2())
                .foregroundColor(.white)

            Text("Episodes for this series are not available yet.")
                .font(FontUtility.body2())
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
    }
}

#if DEBUG
@available(iOS 14.0, *)
struct MovieDetailBottomView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailBottomView(
            viewModel: MovieDetailViewModel(movieId: 1),
            tapTrailer: .constant(true),
            tapRecommend: .constant(false),
            tapEpisodes: .constant(false),
            detailType: .constant(.series),
            showUpgradeDialog: .constant(false),
            showLoginDialog: .constant(false),
            selectedEpisodeId: .constant(nil),
            onEpisodeSelected: nil
        )
    }
}
#endif

//
//  MovieDetailViewModel.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 02/09/26.
//

import Foundation
import Combine

final class MovieDetailViewModel: ObservableObject {

    // MARK: - Published Properties
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var contentDetail: ContentDetail?

    // MARK: - Content Info
    private var movieId: Int = 0
    private var detailType: DetailType = .movie

    // MARK: - Computed Properties
    var title: String {
        return contentDetail?.title ?? ""
    }

    var description: String {
        return contentDetail?.description ?? ""
    }

    var imageURL: String {
        return contentDetail?.image ?? ""
    }

    var releaseDate: String {
        return contentDetail?.releaseDate ?? ""
    }

    var duration: String {
        return contentDetail?.duration ?? ""
    }

    var isFavourite: Bool {
        return contentDetail?.isFavourite ?? false
    }

    var isInWatchList: Bool {
        return contentDetail?.isInWatchLater ?? false
    }

    var subscriptionType: String {
        return contentDetail?.subscriptionTypeDesc ?? ""
    }

    var isFree: Bool {
        return contentDetail?.isFree ?? true
    }

    var isVIP: Bool {
        return contentDetail?.isVIP ?? false
    }

    var categoryDisplayText: String {
        return contentDetail?.categoryDisplayText ?? ""
    }

    var recommendMovies: [Movie] {
        return contentDetail?.recommendMovies ?? []
    }

    var cast: [MovieArtist] {
        return contentDetail?.movieArtistList ?? []
    }

    var episodes: [Episode] {
        return contentDetail?.episodes ?? []
    }

    var hasEpisodes: Bool {
        return !episodes.isEmpty
    }

    var isPlayable: Bool {
        return contentDetail?.isPlayable ?? false
    }

    var streamingUrl: String {
        return contentDetail?.safeStreamingUrl ?? ""
    }

    // MARK: - Init
    init(movieId: Int = 0, detailType: DetailType = .movie) {
        self.movieId = movieId
        self.detailType = detailType
    }

    // MARK: - Set Movie ID
    func setMovieId(_ id: Int) {
        self.movieId = id
    }

    // MARK: - Set Detail Type
    func setDetailType(_ type: DetailType) {
        self.detailType = type
    }

    // MARK: - Fetch Content Detail
    func fetchContentDetail() {
        guard movieId > 0 else {
            errorMessage = "Invalid movie ID"
            return
        }

        isLoading = true
        errorMessage = nil

        Task { @MainActor in
            let result = await ContentService.shared.getContentDetail(movieId: movieId)

            isLoading = false

            switch result {
            case .success(let data):
                self.contentDetail = data
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }

    // MARK: - Toggle Favourite
    func toggleFavourite() {
        guard movieId > 0 else {
            print("❌ [MovieDetailViewModel] Invalid movieId: \(movieId)")
            return
        }

        let currentStatus = isFavourite
        let contentType = detailType == .movie ? "Movie" : "Series"
        print("❤️ [MovieDetailViewModel] Toggling favourite - Current status: \(currentStatus ? "Favorited" : "Not favorited")")
        print("📺 [MovieDetailViewModel] Content Type: \(contentType), ID: \(movieId)")

        Task {
            let result: Result<Void, Error>

            if currentStatus {
                // Remove from favourites
                if detailType == .movie {
                    print("💔 [MovieDetailViewModel] Removing movieId \(movieId) from favourites")
                    result = await FavouriteService.shared.removeFavourite(
                        movieId: movieId,
                        seriesId: nil,
                        reelId: nil
                    )
                } else {
                    print("💔 [MovieDetailViewModel] Removing seriesId \(movieId) from favourites")
                    result = await FavouriteService.shared.removeFavourite(
                        movieId: nil,
                        seriesId: movieId,
                        reelId: nil
                    )
                }
            } else {
                // Add to favourites
                if detailType == .movie {
                    print("❤️ [MovieDetailViewModel] Adding movieId \(movieId) to favourites")
                    result = await FavouriteService.shared.addFavourite(
                        movieId: String(movieId),
                        seriesId: nil,
                        reelId: nil
                    )
                } else {
                    print("❤️ [MovieDetailViewModel] Adding seriesId \(movieId) to favourites")
                    result = await FavouriteService.shared.addFavourite(
                        movieId: nil,
                        seriesId: String(movieId),
                        reelId: nil
                    )
                }
            }

            switch result {
            case .success:
                print("✅ [MovieDetailViewModel] Favourite toggled successfully")
                // Refetch to get updated status
                await MainActor.run {
                    fetchContentDetail()
                }
            case .failure(let error):
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    print("❌ [MovieDetailViewModel] Favourite toggle failed: \(error.localizedDescription)")
                }
            }
        }
    }

    // MARK: - Toggle Watch List
    func toggleWatchList() {
        guard movieId > 0 else { return }

        let currentStatus = isInWatchList

        Task {
            let result: Result<Void, Error>

            if currentStatus {
                // Remove from watch later - need to get the ID first
                // Note: This might need adjustment based on your data structure
                result = await WatchLaterService.shared.deleteWatchLater(id: movieId)
            } else {
                // Add to watch later
                result = await WatchLaterService.shared.addWatchLater(movieId: movieId)
            }

            switch result {
            case .success:
                print("✅ Watch list toggled successfully")
                // Refetch to get updated status
                await MainActor.run {
                    fetchContentDetail()
                }
            case .failure(let error):
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    print("❌ Watch list toggle failed: \(error.localizedDescription)")
                }
            }
        }
    }
}

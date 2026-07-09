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
    @Published var toast: ToastModel?
    @Published var showLoginDialog: Bool = false

    // MARK: - Content Info
    private var movieId: Int = 0
    private var detailType: DetailType = .movie

    // MARK: - Computed Properties
    var currentDetailType: DetailType {
        return detailType
    }

    var title: String {
        return contentDetail?.title ?? ""
    }

    var description: String {
        return contentDetail?.description ?? ""
    }

    var imageURL: String {
        return contentDetail?.detailImage ?? ""
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

    var seasonList: [Season] {
        return contentDetail?.seasonList ?? []
    }

    var hasSeasons: Bool {
        return !seasonList.isEmpty
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

    // MARK: - Select Season
    func selectSeason(_ season: Season) {
        guard let newMovieId = season.movieId, newMovieId > 0 else {
            print("❌ [MovieDetailViewModel] Invalid movieId in season")
            return
        }

        print("🎬 [MovieDetailViewModel] Selecting season: \(season.safeSeasonName)")
        print("🎬 [MovieDetailViewModel] Using movieId: \(newMovieId)")

        // Update the movieId from the selected season
        self.movieId = newMovieId

        // Fetch content detail with the new movieId
        fetchContentDetail()
    }

    // MARK: - Fetch Content Detail
    func fetchContentDetail() {
        guard movieId > 0 else {
            print("❌ [MovieDetailViewModel] Invalid movie ID: \(movieId)")
            errorMessage = "Invalid movie ID"
            return
        }

        print("📡 [MovieDetailViewModel] Fetching content detail for movieId: \(movieId), type: \(detailType)")
        print("📡 [MovieDetailViewModel] API Call - movieId parameter: \(movieId)")
        isLoading = true
        errorMessage = nil

        Task { @MainActor in
            print("🔄 [MovieDetailViewModel] Making API request to ContentService...")
            let result = await ContentService.shared.getContentDetail(movieId: movieId)

            isLoading = false

            switch result {
            case .success(let data):
                print("✅ [MovieDetailViewModel] Successfully fetched content detail for: \(data.title ?? "Unknown")")
                print("✅ [MovieDetailViewModel] Returned movieId: \(data.id)")
                print("✅ [MovieDetailViewModel] Episode count: \(data.episodes?.count ?? 0)")
                self.contentDetail = data
            case .failure(let error):
                print("❌ [MovieDetailViewModel] Failed to fetch content detail: \(error.localizedDescription)")
                self.errorMessage = error.localizedDescription
            }
        }
    }

    // MARK: - Toggle Favourite
    func toggleFavourite() {
        print("🔘 [MovieDetailViewModel] toggleFavourite() called")
        print("🔐 [MovieDetailViewModel] isLoggedIn: \(AppDefaultsManager.shared.isLoggedIn)")
        print("🎬 [MovieDetailViewModel] movieId: \(movieId)")
        print("📺 [MovieDetailViewModel] detailType: \(detailType)")

        // Check if user is logged in
        guard AppDefaultsManager.shared.isLoggedIn else {
            print("⚠️ [MovieDetailViewModel] User not logged in - showing login dialog")
            showLoginDialog = true
            return
        }

        guard movieId > 0 else {
            print("❌ [MovieDetailViewModel] Invalid movieId: \(movieId)")
            return
        }

        let currentStatus = isFavourite
        let contentType = detailType == .movie ? "Movie" : "Series"
        print("❤️ [MovieDetailViewModel] Toggling favourite - Current status: \(currentStatus ? "Favorited" : "Not favorited")")
        print("📺 [MovieDetailViewModel] Content Type: \(contentType), ID: \(movieId)")
        print("🎬 [MovieDetailViewModel] DetailType: \(detailType)")

        Task {
            let result: Result<Void, Error>

            if currentStatus {
                // Remove from favourites - use movieId for both movies and series
                print("💔 [MovieDetailViewModel] Removing \(contentType) with movieId \(movieId) from favourites")
                result = await FavouriteService.shared.removeFavourite(
                    movieId: movieId,
                    seriesId: nil,
                    reelId: nil
                )
            } else {
                // Add to favourites - use movieId for both movies and series
                print("❤️ [MovieDetailViewModel] Adding \(contentType) with movieId \(movieId) to favourites")
                result = await FavouriteService.shared.addFavourite(
                    movieId: String(movieId),
                    seriesId: nil,
                    reelId: nil
                )
            }

            switch result {
            case .success:
                print("✅ [MovieDetailViewModel] Favourite toggled successfully")
                // Refetch to get updated status
                await MainActor.run {
                    fetchContentDetail()

                    // Show toast message
                    let message = currentStatus ? "Remove from favorite list successfully." : "Added to favorite list successfully."
                    toast = ToastModel(message: message, iconName: "ic.splash.logo")

                    // Auto-hide toast after 2 seconds
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self.toast = nil
                    }
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
        // Check if user is logged in
        guard AppDefaultsManager.shared.isLoggedIn else {
            print("⚠️ [MovieDetailViewModel] User not logged in - showing login dialog")
            showLoginDialog = true
            return
        }

        guard movieId > 0 else {
            print("❌ [MovieDetailViewModel] Invalid movieId: \(movieId)")
            return
        }

        let currentStatus = isInWatchList
        print("📋 [MovieDetailViewModel] Toggling watchlist - Current status: \(currentStatus ? "In watchlist" : "Not in watchlist")")

        Task {
            let result: Result<Void, Error>

            if currentStatus {
                // Remove from watchlist - use watchLaterId
                guard let watchlistId = contentDetail?.watchLaterId, watchlistId > 0 else {
                    print("❌ [MovieDetailViewModel] Invalid watchLaterId")
                    await MainActor.run {
                        errorMessage = "Invalid watchlist ID"
                    }
                    return
                }
                print("🗑️ [MovieDetailViewModel] Removing from watchlist with ID: \(watchlistId)")
                result = await WatchLaterService.shared.deleteWatchLater(id: watchlistId)
            } else {
                // Add to watchlist - use movieId
                print("➕ [MovieDetailViewModel] Adding movieId \(movieId) to watchlist")
                result = await WatchLaterService.shared.addWatchLater(movieId: movieId)
            }

            switch result {
            case .success:
                print("✅ [MovieDetailViewModel] Watchlist toggled successfully")
                // Refetch to get updated status
                await MainActor.run {
                    fetchContentDetail()

                    // Show toast message
                    let message = currentStatus ? "Remove from watch list successfully." : "Added to watch list successfully."
                    toast = ToastModel(message: message, iconName: "ic.splash.logo")

                    // Auto-hide toast after 2 seconds
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self.toast = nil
                    }
                }
            case .failure(let error):
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    print("❌ [MovieDetailViewModel] Watchlist toggle failed: \(error.localizedDescription)")
                }
            }
        }
    }
}

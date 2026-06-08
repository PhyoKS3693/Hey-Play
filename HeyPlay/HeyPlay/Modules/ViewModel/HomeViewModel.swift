//
//  HomeViewModel.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 02/09/26.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {

    // MARK: - Published Properties
    @Published var isLoading: Bool = false
    @Published var isLoadingMore: Bool = false
    @Published var errorMessage: String?
    @Published var homeData: HomeData?

    // MARK: - Pagination
    private var currentPage: Int = 1
    private var hasMoreData: Bool = true

    // MARK: - Computed Properties
    var banners: [Banner] {
        return homeData?.bannerList ?? []
    }

    var playlists: [Playlist] {
        return homeData?.playlists ?? []
    }

    var lastWatchList: [Movie] {
        return homeData?.lastWatchContentList ?? []
    }

    var canLoadMore: Bool {
        return hasMoreData && !isLoadingMore
    }

    // MARK: - Get Playlist by SystemType
    func getPlaylist(for systemType: Playlist.SystemType) -> Playlist? {
        return playlists.first { $0.system == systemType }
    }

    func getMovies(for systemType: Playlist.SystemType) -> [Movie] {
        return getPlaylist(for: systemType)?.movieList ?? []
    }

    func getPlaylistTitle(for systemType: Playlist.SystemType) -> String {
        return getPlaylist(for: systemType)?.title ?? ""
    }

    // Get playlist by index (for custom playlists)
    func getPlaylist(at index: Int) -> Playlist? {
        guard index < playlists.count else { return nil }
        return playlists[index]
    }

    // MARK: - API Calls
    func fetchHomeData() {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil
        currentPage = 1

        Task { @MainActor in
            let result = await HomeService.shared.getHomeData()

            isLoading = false

            switch result {
            case .success(let data):
                self.homeData = data
                self.hasMoreData = !data.playlists.isEmpty
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }

    // MARK: - Refresh Data (Pull to Refresh)
    func refreshData() {
        currentPage = 1
        hasMoreData = true
        fetchHomeData()
    }

    // MARK: - Load More Data (Pagination)
    func loadMoreData() {
        guard canLoadMore && !isLoading else { return }

        isLoadingMore = true
        currentPage += 1

        Task { @MainActor in
            // Simulate loading more data
            // In real scenario, you would call API with pagination
            try? await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds

            isLoadingMore = false

            // For demo: Set hasMoreData to false after a few pages
            if currentPage >= 3 {
                hasMoreData = false
            }
        }
    }
}

// MARK: - Home Section Data Mapping
extension HomeViewModel {

    /// Maps HomeSection enum to playlist data
    func getData(for section: HomeSection) -> (title: String, movies: [Movie])? {
        switch section {
        case .user:
            return nil
        case .banner:
            return nil
        case .recent:
            return ("Continue Watching", lastWatchList)
        case .movie:
            if let playlist = getPlaylist(for: .movies) {
                return (playlist.title, playlist.movieList)
            }
            return nil
        case .latest_movie:
            if let playlist = getPlaylist(for: .latestMovies) {
                return (playlist.title, playlist.movieList)
            }
            return nil
        case .series:
            if let playlist = getPlaylist(for: .latestSeries) {
                return (playlist.title, playlist.movieList)
            }
            return nil
        case .collection, .collection_type_1:
            // Return additional playlists that are not system types
            let customPlaylists = playlists.filter { $0.system == nil }
            if let playlist = customPlaylists.first {
                return (playlist.title, playlist.movieList)
            }
            return nil
        case .popular:
            if let playlist = getPlaylist(for: .popular) {
                return (playlist.title, playlist.movieList)
            }
            return nil
        }
    }
}

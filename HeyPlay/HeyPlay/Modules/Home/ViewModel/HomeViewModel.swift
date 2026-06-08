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
    @Published var profile: Profile?

    // MARK: - Pagination
    private var currentPage: Int = 1
    private var hasMoreData: Bool = true

    // MARK: - Login Status
    var isLoggedIn: Bool {
        return AppDefaultsManager.shared.isLoggedIn
    }

    // MARK: - Computed Properties
    var banners: [Banner] {
        return homeData?.safeBannerList ?? []
    }

    var playlists: [Playlist] {
        return homeData?.safePlaylists ?? []
    }

    var lastWatchList: [Movie] {
        return homeData?.safeLastWatchContentList ?? []
    }

    var canLoadMore: Bool {
        return hasMoreData && !isLoadingMore
    }

    // MARK: - Get Playlist by Layout Type
    func getPlaylists(for layoutType: Playlist.LayoutType) -> [Playlist] {
        return playlists.filter { $0.layoutType == layoutType }
    }

    func getFirstPlaylist(for layoutType: Playlist.LayoutType) -> Playlist? {
        return getPlaylists(for: layoutType).first
    }

    // Get playlist by index (for ordered access)
    func getPlaylist(at index: Int) -> Playlist? {
        guard index < playlists.count else { return nil }
        return playlists[index]
    }

    // Get movies from first playlist of a specific layout
    func getMovies(for layoutType: Playlist.LayoutType) -> [Movie] {
        return getFirstPlaylist(for: layoutType)?.safeMovieList ?? []
    }

    func getPlaylistTitle(for layoutType: Playlist.LayoutType) -> String {
        return getFirstPlaylist(for: layoutType)?.safeTitle ?? ""
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
                self.hasMoreData = !(data.playlists ?? []).isEmpty
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }

    // MARK: - Fetch Profile Data
    func fetchProfile() {
        guard isLoggedIn else {
            profile = nil
            return
        }

        Task { @MainActor in
            let result = await ProfileService.shared.getProfile()

            switch result {
            case .success(let data):
                self.profile = data
            case .failure(let error):
                print("Error fetching profile: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Fetch All Data (Home + Profile)
    func fetchAllData() {
        fetchHomeData()
        fetchProfile()
    }

    // MARK: - Refresh Data (Pull to Refresh)
    func refreshData() {
        currentPage = 1
        hasMoreData = true
        fetchAllData()
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

// MARK: - Home Section Types
enum HomeSectionType {
    case user
    case banner
    case recent  // lastWatchContentList
    case playlist(Playlist)  // Dynamic playlist section
}

// MARK: - Home Section Data Mapping
extension HomeViewModel {

    /// Get all sections to display in order
    /// Returns: [user, banner, recent (if has data), playlist1, playlist2, ...]
    func getAllSections() -> [HomeSectionType] {
        var sections: [HomeSectionType] = [.user, .banner]

        // Add recent if there's watch history
        if !lastWatchList.isEmpty {
            sections.append(.recent)
        }

        // Add each playlist as a section in order
        for playlist in playlists {
            sections.append(.playlist(playlist))
        }

        return sections
    }

    /// Get the number of sections
    var sectionCount: Int {
        return getAllSections().count
    }

    /// Get section type at index
    func getSectionType(at index: Int) -> HomeSectionType? {
        let sections = getAllSections()
        guard index < sections.count else { return nil }
        return sections[index]
    }

    /// Get playlist at section index (for playlist sections only)
    func getPlaylistForSection(at index: Int) -> Playlist? {
        guard let sectionType = getSectionType(at: index),
              case .playlist(let playlist) = sectionType else {
            return nil
        }
        return playlist
    }
}

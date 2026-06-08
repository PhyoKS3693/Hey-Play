//
//  CollectionResultViewModel.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 05/29/26.
//

import Foundation
import Combine

final class CollectionResultViewModel: ObservableObject {

    // MARK: - Published Properties
    @Published var isLoading: Bool = false
    @Published var isLoadingMore: Bool = false
    @Published var errorMessage: String?

    @Published var playlistTitle: String = ""
    @Published var totalCountText: String = ""
    @Published var movies: [Movie] = []

    // MARK: - Properties
    var playlistId: String = ""
    private var currentPage: Int = 1
    private var hasMoreData: Bool = true

    // MARK: - Computed Properties
    var shouldShowEmptyState: Bool {
        return !isLoading && movies.isEmpty
    }

    var canLoadMore: Bool {
        return hasMoreData && !isLoadingMore && !isLoading
    }

    // MARK: - Init
    init(playlistId: String = "", playlistTitle: String = "") {
        self.playlistId = playlistId
        self.playlistTitle = playlistTitle
    }

    // MARK: - Fetch Playlist Detail
    func fetchPlaylistDetail() async {
        guard !isLoading && hasMoreData else { return }

        await MainActor.run {
            if currentPage == 1 {
                isLoading = true
            } else {
                isLoadingMore = true
            }
            errorMessage = nil
        }

        print("📋 [CollectionResultViewModel] Fetching page \(currentPage) for playlist \(playlistId)")

        let result = await HomeService.shared.getPlaylistDetail(
            playlistId: playlistId,
            pageNo: currentPage
        )

        await MainActor.run {
            isLoading = false
            isLoadingMore = false

            switch result {
            case .success(let data):
                // Update playlist info from first page
                if currentPage == 1 {
                    self.playlistTitle = data.playlistTitle
                    self.totalCountText = data.totalMoviesText
                    self.movies = data.movies
                } else {
                    self.movies.append(contentsOf: data.movies)
                }

                // Check if more data available (if less than expected, no more data)
                self.hasMoreData = data.movies.count >= 20 // Assuming 20 items per page

                print("✅ [CollectionResultViewModel] Loaded \(data.movies.count) movies, total: \(self.movies.count)")

            case .failure(let error):
                self.errorMessage = error.localizedDescription
                print("❌ [CollectionResultViewModel] Error: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Load More
    func loadMore() async {
        guard canLoadMore else { return }

        await MainActor.run {
            currentPage += 1
        }

        await fetchPlaylistDetail()
    }

    // MARK: - Refresh
    func refresh() async {
        await MainActor.run {
            currentPage = 1
            movies = []
            hasMoreData = true
        }

        await fetchPlaylistDetail()
    }

    // MARK: - Reset
    func reset() {
        currentPage = 1
        movies = []
        hasMoreData = true
        isLoading = false
        isLoadingMore = false
        errorMessage = nil
    }
}

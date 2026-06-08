//
//  SearchViewModel.swift
//  HeyPlay
//
//  Created by Aye Myat Min on 05/05/26.
//

import Foundation
import Combine

final class SearchViewModel: ObservableObject {

    // MARK: - Published Properties

    // Loading States
    @Published var isLoading: Bool = false
    @Published var isLoadingMore: Bool = false
    @Published var isLoadingPreload: Bool = false

    // Error Handling
    @Published var errorMessage: String?

    // Search State
    @Published var searchKey: String = ""
    @Published var selectedMovieType: String = "" // "" for All, "1" for Movie, "2" for Series
    @Published var selectedMovieOrigin: String = "" // Empty for All

    // Search Results
    @Published var searchResults: [Movie] = []

    // Pagination
    @Published var currentPage: Int = 1
    @Published var hasMoreData: Bool = true

    // Search Preload Data
    @Published var recentSearches: [String] = []
    @Published var trendingSearches: [String] = []
    @Published var trendingTitle: String = "" // e.g., "လူကြိုက်များသောရှာဖွေမှု"

    // UI State
    @Published var isShowingResults: Bool = false // Show results vs. preload screen

    // MARK: - Computed Properties

    var hasResults: Bool {
        return !searchResults.isEmpty
    }

    var shouldShowEmptyState: Bool {
        return isShowingResults && !isLoading && searchResults.isEmpty
    }

    var canLoadMore: Bool {
        return hasMoreData && !isLoadingMore && !isLoading
    }

    // MARK: - Initialization

    init() {}

    // MARK: - Load Search Preload (Initial Screen)

    @MainActor
    func loadSearchPreload() async {
        isLoadingPreload = true
        errorMessage = nil

        let result = await SearchService.shared.getSearchPreload()

        isLoadingPreload = false

        switch result {
        case .success(let data):
            // Get recent searches
            self.recentSearches = data.recentSearches

            // Get trending searches from keywords array
            if let firstKeywordGroup = data.keywords?.first {
                self.trendingTitle = firstKeywordGroup.title ?? ""
                self.trendingSearches = firstKeywordGroup.keys ?? []
            } else {
                self.trendingTitle = ""
                self.trendingSearches = []
            }

        case .failure(let error):
            self.errorMessage = error.localizedDescription
        }
    }

    // MARK: - Perform Search

    @MainActor
    func performSearch() async {
        // Validate
        guard !searchKey.trimmingCharacters(in: .whitespaces).isEmpty else {
            isShowingResults = false
            return
        }

        // Reset pagination
        currentPage = 1
        searchResults = []
        hasMoreData = true
        isLoading = true
        errorMessage = nil
        isShowingResults = true

        // Perform search
        await executeSearch()

        // Save search history (fire and forget)
        Task {
            _ = await SearchService.shared.saveSearchHistory(searchString: searchKey)
        }
    }

    // MARK: - Execute Search (Reusable)

    @MainActor
    private func executeSearch() async {
        let result = await SearchService.shared.searchContents(
            searchKey: searchKey,
            pageNo: currentPage,
            movieType: selectedMovieType,
            movieOrigin: selectedMovieOrigin
        )

        isLoading = false
        isLoadingMore = false

        switch result {
        case .success(let data):
            let newMovies = data.movieList

            if currentPage == 1 {
                self.searchResults = newMovies
            } else {
                self.searchResults.append(contentsOf: newMovies)
            }

            // Check if more data available (if less than expected, no more data)
            self.hasMoreData = newMovies.count >= 20 // Assuming 20 items per page

        case .failure(let error):
            self.errorMessage = error.localizedDescription
        }
    }

    // MARK: - Load More (Pagination)

    @MainActor
    func loadMore() async {
        guard !isLoadingMore && hasMoreData && !isLoading else { return }

        isLoadingMore = true
        currentPage += 1

        await executeSearch()
    }

    // MARK: - Apply Filters

    @MainActor
    func applyFilters(movieType: String, movieOrigin: String) async {
        selectedMovieType = movieType
        selectedMovieOrigin = movieOrigin
        currentPage = 1
        searchResults = []
        hasMoreData = true

        await performSearch()
    }

    // MARK: - Clear Search

    func clearSearch() {
        searchKey = ""
        searchResults = []
        isShowingResults = false
        currentPage = 1
        hasMoreData = true
        errorMessage = nil
        selectedMovieType = ""
        selectedMovieOrigin = ""
    }

    // MARK: - Quick Search (From Recent/Trending)

    @MainActor
    func quickSearch(query: String) async {
        searchKey = query
        await performSearch()
    }

    // MARK: - Browse Content (Empty Search with Filters)

    @MainActor
    func browseContent(movieType: String = "", movieOrigin: String = "") async {
        // Reset state
        searchKey = ""
        currentPage = 1
        searchResults = []
        hasMoreData = true
        isLoading = true
        errorMessage = nil
        isShowingResults = true

        // Set filters
        selectedMovieType = movieType
        selectedMovieOrigin = movieOrigin

        // Execute search with empty searchKey
        await executeSearch()
    }

    // MARK: - Load More for Browse

    @MainActor
    func loadMoreBrowse() async {
        await loadMore()
    }
}

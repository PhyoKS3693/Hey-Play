//
//  WatchListViewModel.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 10/24/25.
//

import Foundation
import Combine
import UIKit

// MARK: - Watch List Type
enum WatchListType {
    case watchLater    // Content saved for later
    case lastWatch     // Watch history
    case favourites    // Liked content
}

final class WatchListViewModel: ObservableObject {

    // MARK: - Published Properties
    @Published var isLoading: Bool = false
    @Published var isLoadingMore: Bool = false
    @Published var errorMessage: String?
    @Published var listType: WatchListType = .watchLater

    // MARK: - Data Arrays
    @Published var watchLaterItems: [WatchLaterItem] = []
    @Published var lastWatchItems: [LastWatchItem] = []
    @Published var favouriteItems: [FavouriteItem] = []

    // MARK: - Pagination
    private var currentPage: Int = 1
    private var hasMoreData: Bool = true

    // MARK: - Computed Properties
    var itemCount: Int {
        switch listType {
        case .watchLater:
            return watchLaterItems.count
        case .lastWatch:
            return lastWatchItems.count
        case .favourites:
            return favouriteItems.count
        }
    }

    var canLoadMore: Bool {
        return hasMoreData && !isLoadingMore
    }

    var emptyMessage: String {
        switch listType {
        case .watchLater:
            return "No items in your watch list"
        case .lastWatch:
            return "No watch history yet"
        case .favourites:
            return "No favourites yet"
        }
    }

    // MARK: - Init
    init(listType: WatchListType = .watchLater) {
        self.listType = listType
    }

    // MARK: - Fetch Data
    func fetchData() {
        switch listType {
        case .watchLater:
            fetchWatchLater()
        case .lastWatch:
            fetchLastWatch()
        case .favourites:
            fetchFavourites()
        }
    }

    // MARK: - Fetch Watch Later
    private func fetchWatchLater() {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil
        currentPage = 1

        Task { @MainActor in
            let result = await WatchLaterService.shared.getWatchLaterList(pageNo: currentPage)

            isLoading = false

            switch result {
            case .success(let data):
                self.watchLaterItems = data.movies ?? []
                self.hasMoreData = !(data.movies ?? []).isEmpty
                print("✅ [WatchList] Fetched \(self.watchLaterItems.count) watchLater items")
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                print("❌ [WatchList] Failed to fetch watchLater: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Fetch Last Watch
    private func fetchLastWatch() {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil
        currentPage = 1

        Task { @MainActor in
            let result = await LastWatchService.shared.getLastWatchList(pageNo: currentPage)

            isLoading = false

            switch result {
            case .success(let data):
                self.lastWatchItems = data.lastWatchList ?? []
                self.hasMoreData = !(data.lastWatchList ?? []).isEmpty
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }

    // MARK: - Fetch Favourites
    private func fetchFavourites() {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil
        currentPage = 1

        Task { @MainActor in
            let result = await FavouriteService.shared.getFavouriteList(pageNo: currentPage)

            isLoading = false

            switch result {
            case .success(let data):
                self.favouriteItems = data.favouriteMovieList ?? []
                self.hasMoreData = !(data.favouriteMovieList ?? []).isEmpty
                print("✅ [WatchList] Fetched \(self.favouriteItems.count) favourite items")
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                print("❌ [WatchList] Failed to fetch favourites: \(error.localizedDescription)")
            }
        }
    }

    // MARK: - Refresh Data
    func refreshData() {
        currentPage = 1
        hasMoreData = true
        fetchData()
    }

    // MARK: - Load More
    func loadMoreData() {
        guard canLoadMore && !isLoading else {
            print("⏸️ [WatchList] Cannot load more - canLoadMore: \(canLoadMore), isLoading: \(isLoading)")
            return
        }

        print("📄 [WatchList] Loading more data - Page: \(currentPage + 1), Type: \(listType)")
        isLoadingMore = true
        currentPage += 1

        switch listType {
        case .watchLater:
            loadMoreWatchLater()
        case .lastWatch:
            loadMoreLastWatch()
        case .favourites:
            loadMoreFavourites()
        }
    }

    private func loadMoreWatchLater() {
        Task { @MainActor in
            let result = await WatchLaterService.shared.getWatchLaterList(pageNo: currentPage)

            isLoadingMore = false

            switch result {
            case .success(let data):
                let newItems = data.movies ?? []
                print("✅ [WatchList] Loaded \(newItems.count) more watchLater items")
                self.watchLaterItems.append(contentsOf: newItems)
                self.hasMoreData = !newItems.isEmpty
                if !self.hasMoreData {
                    print("🏁 [WatchList] No more watchLater data available")
                }
            case .failure(let error):
                print("❌ [WatchList] Failed to load more watchLater: \(error.localizedDescription)")
                self.errorMessage = error.localizedDescription
                self.currentPage -= 1
            }
        }
    }

    private func loadMoreLastWatch() {
        Task { @MainActor in
            let result = await LastWatchService.shared.getLastWatchList(pageNo: currentPage)

            isLoadingMore = false

            switch result {
            case .success(let data):
                let newItems = data.lastWatchList ?? []
                print("✅ [WatchList] Loaded \(newItems.count) more lastWatch items")
                self.lastWatchItems.append(contentsOf: newItems)
                self.hasMoreData = !newItems.isEmpty
                if !self.hasMoreData {
                    print("🏁 [WatchList] No more lastWatch data available")
                }
            case .failure(let error):
                print("❌ [WatchList] Failed to load more lastWatch: \(error.localizedDescription)")
                self.errorMessage = error.localizedDescription
                self.currentPage -= 1
            }
        }
    }

    private func loadMoreFavourites() {
        Task { @MainActor in
            let result = await FavouriteService.shared.getFavouriteList(pageNo: currentPage)

            isLoadingMore = false

            switch result {
            case .success(let data):
                let newItems = data.favouriteMovieList ?? []
                print("✅ [WatchList] Loaded \(newItems.count) more favourite items")
                self.favouriteItems.append(contentsOf: newItems)
                self.hasMoreData = !newItems.isEmpty
                if !self.hasMoreData {
                    print("🏁 [WatchList] No more favourite data available")
                }
            case .failure(let error):
                print("❌ [WatchList] Failed to load more favourites: \(error.localizedDescription)")
                self.errorMessage = error.localizedDescription
                self.currentPage -= 1
            }
        }
    }

    // MARK: - Delete Item
    func deleteWatchLaterItem(watchLaterId: Int) {
        Task { @MainActor in
            let result = await WatchLaterService.shared.deleteWatchLater(id: watchLaterId)

            switch result {
            case .success:
                print("✅ [WatchList] Deleted watchLater item with ID: \(watchLaterId)")
                self.watchLaterItems.removeAll { $0.watchLaterId == watchLaterId }
            case .failure(let error):
                print("❌ [WatchList] Failed to delete watchLater: \(error.localizedDescription)")
                self.errorMessage = error.localizedDescription
            }
        }
    }

    func deleteLastWatchItem(id: String) {
        Task { @MainActor in
            let result = await LastWatchService.shared.deleteLastWatch(lastWatchId: id)

            switch result {
            case .success:
                self.lastWatchItems.removeAll { $0.id == id }
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }

    func deleteFavouriteItem(movieId: Int?, seriesId: Int?, reelId: String?) {
        Task { @MainActor in
            let result = await FavouriteService.shared.removeFavourite(
                movieId: movieId,
                seriesId: seriesId,
                reelId: reelId
            )

            switch result {
            case .success:
                if let movieId = movieId {
                    self.favouriteItems.removeAll { $0.movieId == movieId }
                }
                // Note: Favourite API only returns movies, not reels
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }

    // MARK: - Delete All
    func deleteAllItems() {
        switch listType {
        case .watchLater:
            deleteAllWatchLater()
        case .lastWatch:
            deleteAllLastWatch()
        case .favourites:
            // No delete all for favourites, would need to delete one by one
            break
        }
    }

    private func deleteAllWatchLater() {
        Task { @MainActor in
            let result = await WatchLaterService.shared.deleteAllWatchLater()

            switch result {
            case .success:
                self.watchLaterItems.removeAll()
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }

    private func deleteAllLastWatch() {
        Task { @MainActor in
            let result = await LastWatchService.shared.deleteAllLastWatch()

            switch result {
            case .success:
                self.lastWatchItems.removeAll()
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
}

//
//  HotViewModel.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 03/23/26.
//

import Foundation
import Combine

final class HotViewModel: ObservableObject {

    // MARK: - Published Properties
    @Published var isLoading: Bool = false
    @Published var isLoadingMore: Bool = false
    @Published var errorMessage: String?
    @Published var reels: [Reel] = []

    // Callback for favorite toggle updates
    var onFavoriteToggled: ((Int, Bool, Int) -> Void)?  // (index, isFavorite, likeCount)
    var onLoginRequired: (() -> Void)?  // Callback when login is required

    // MARK: - Pagination
    private var currentPage: Int = 1
    private var hasMoreData: Bool = true
    private var currentSeed: String? = nil

    // MARK: - Computed Properties
    var reelCount: Int {
        return reels.count
    }

    var canLoadMore: Bool {
        return hasMoreData && !isLoadingMore
    }

    // MARK: - Get Reel at Index
    func getReel(at index: Int) -> Reel? {
        guard index < reels.count else { return nil }
        return reels[index]
    }

    // MARK: - API Calls
    func fetchReels(reelId: Int? = nil) {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil
        currentPage = 1
        currentSeed = nil // Reset seed for fresh fetch

        Task { @MainActor in
            let result = await ReelService.shared.getReelList(pageNo: currentPage, reelId: reelId, seed: nil)

            isLoading = false

            switch result {
            case .success(let data):
                self.reels = data.safeReelList
                self.hasMoreData = !data.safeReelList.isEmpty
                // Store seed from response for pagination
                if let seed = data.seed {
                    self.currentSeed = String(seed)
                }
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }

    // MARK: - Refresh Data (Pull to Refresh)
    func refreshData() {
        currentPage = 1
        hasMoreData = true
        fetchReels()
    }

    // MARK: - Load More Data (Pagination)
    func loadMoreData() {
        guard canLoadMore && !isLoading else { return }

        isLoadingMore = true
        currentPage += 1

        Task { @MainActor in
            let result = await ReelService.shared.getReelList(pageNo: currentPage, reelId: nil, seed: currentSeed)

            isLoadingMore = false

            switch result {
            case .success(let data):
                let newReels = data.safeReelList
                self.reels.append(contentsOf: newReels)
                self.hasMoreData = !newReels.isEmpty
                // Update seed from response for next pagination
                if let seed = data.seed {
                    self.currentSeed = String(seed)
                }
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                self.currentPage -= 1 // Revert page on failure
            }
        }
    }

    // MARK: - Toggle Favorite
    func toggleFavorite(at index: Int) {
        guard index < reels.count else { return }

        // Check if user is logged in
        guard AppDefaultsManager.shared.isLoggedIn else {
            print("⚠️ [HotViewModel] User not logged in - showing login dialog")
            onLoginRequired?()
            return
        }

        let reel = reels[index]
        let reelId = String(reel.id)
        let currentStatus = reel.isFavourite ?? false
        let currentCount = reel.reactionCountInt

        print("❤️ [HotViewModel] Toggling favourite - ReelID: \(reelId), Current Status: \(currentStatus)")

        Task { @MainActor in
            // Update UI immediately (optimistic update)
            reels[index].isFavourite = !currentStatus

            // Update like count
            let newCount: Int
            if !currentStatus {
                // Adding to favorites - increment count
                newCount = currentCount + 1
                reels[index].reactionCount = String(newCount)
            } else {
                // Removing from favorites - decrement count
                newCount = max(0, currentCount - 1)
                reels[index].reactionCount = String(newCount)
            }

            // Notify UI to update
            onFavoriteToggled?(index, !currentStatus, newCount)

            // Make API call
            let result: Result<Void, Error>

            if currentStatus {
                // Remove from favourites
                print("💔 [HotViewModel] Removing from favourites")
                result = await FavouriteService.shared.removeFavourite(
                    movieId: nil,
                    seriesId: nil,
                    reelId: reelId
                )
            } else {
                // Add to favourites
                print("❤️ [HotViewModel] Adding to favourites")
                result = await FavouriteService.shared.addFavourite(
                    movieId: nil,
                    seriesId: nil,
                    reelId: reelId
                )
            }

            switch result {
            case .success:
                print("✅ [HotViewModel] Favourite toggled successfully for reel: \(reelId)")
                // State already updated optimistically, no need to refetch
            case .failure(let error):
                print("❌ [HotViewModel] Failed to toggle favourite: \(error.localizedDescription)")
                // Revert the optimistic update on failure
                self.reels[index].isFavourite = currentStatus
                self.reels[index].reactionCount = String(currentCount)
                self.errorMessage = error.localizedDescription

                // Notify UI to revert
                self.onFavoriteToggled?(index, currentStatus, currentCount)
            }
        }
    }

    // MARK: - Toggle Watch Later
    // Note: Watch Later might not apply to reels (short-form content)
    // This is included for completeness but may not be used in UI
    func toggleWatchLater(at index: Int) {
        guard index < reels.count else { return }

        // Check if user is logged in
        guard AppDefaultsManager.shared.isLoggedIn else {
            print("⚠️ [HotViewModel] User not logged in - showing login dialog")
            onLoginRequired?()
            return
        }

        // Watch Later typically doesn't apply to reels/short videos
        // Reels are meant for quick consumption, not saving for later
        print("Watch Later not applicable for reels")
    }
}

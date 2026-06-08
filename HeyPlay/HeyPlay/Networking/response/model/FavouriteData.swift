//
//  FavouriteData.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 02/09/26.
//

import Foundation

// MARK: - Favourite List Response
typealias FavouriteListResponse = BaseAPIResponse<FavouriteListData>

// MARK: - Favourite List Data
struct FavouriteListData: Decodable {
    let favouriteMovieList: [FavouriteItem]?
}

// MARK: - Favourite Item
struct FavouriteItem: Decodable, Identifiable {
    let id: Int
    let name: String?
    let movieId: Int?
    let description: String?
    let totalEpisode: Int?
    let totalEpisodeText: String?
    let listingImage: String?
    let isFavourite: Bool?
    let subscriptionType: Int?
    let subscriptionTypeDesc: String?
    let favoriteOn: String?

    // Computed properties for compatibility
    var movieName: String? { name }
    var reelName: String? { name }
    var addedDate: String? { favoriteOn }

    var fullImageURL: String {
        guard let listingImage = listingImage, !listingImage.isEmpty else { return "" }
        if listingImage.hasPrefix("http") {
            return listingImage
        }
        return "http://103.59.163.3/heyplay-api" + listingImage
    }

    var isMovie: Bool {
        return true // All items from favouriteMovieList are movies
    }

    var isReel: Bool {
        return false // No reels in favouriteMovieList
    }

    var isFree: Bool {
        return subscriptionType == 1
    }

    var isSeries: Bool {
        // Check if it has episodes - if totalEpisode > 1, it's likely a series
        return (totalEpisode ?? 0) > 1
    }

    var reelId: Int? {
        return nil // No reels in favouriteMovieList
    }
}

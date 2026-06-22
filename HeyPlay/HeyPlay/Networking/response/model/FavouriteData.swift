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
    let reelList: [FavouriteReelItem]?
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
    let type: Int? // 1 = Movie, 2 = Series, 3 = Reel/Short

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
        return type == 1
    }

    var isReel: Bool {
        return type == 3
    }

    var isFree: Bool {
        return subscriptionType == 1
    }

    var isSeries: Bool {
        return type == 2 || (totalEpisode ?? 0) > 1
    }

    var reelId: Int? {
        return isReel ? movieId : nil
    }
}

// MARK: - Favourite Reel Item
struct FavouriteReelItem: Decodable, Identifiable {
    let id: Int
    let reelId: Int?
    let name: String?
    let description: String?
    let listingImage: String?
    let favoriteOn: String?
    let totalEpisode: Int?
    let totalEpisodeText: String?
    let typeDescription: String?
    let subscriptionTypeDesc: String?
    let isFavourite: Bool?

    var fullImageURL: String {
        guard let listingImage = listingImage, !listingImage.isEmpty else { return "" }
        if listingImage.hasPrefix("http") {
            return listingImage
        }
        return "http://103.59.163.3/heyplay-api" + listingImage
    }
}

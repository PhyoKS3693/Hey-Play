//
//  FavouriteRequest.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 02/09/26.
//

import Foundation

// MARK: - Add Favourite Request
struct AddFavouriteRequest: Encodable {
    let movieId: String?
    let seriesId: String?
    let reelId: String?

    init(movieId: String? = nil, seriesId: String? = nil, reelId: String? = nil) {
        // Only set values if they're not empty
        self.movieId = (movieId?.isEmpty == false) ? movieId : nil
        self.seriesId = (seriesId?.isEmpty == false) ? seriesId : nil
        self.reelId = (reelId?.isEmpty == false) ? reelId : nil
    }
}

// MARK: - Remove Favourite Request
struct RemoveFavouriteRequest: Encodable {
    let movieId: Int?
    let seriesId: Int?
    let reelId: String?

    init(movieId: Int? = nil, seriesId: Int? = nil, reelId: String? = nil) {
        self.movieId = movieId
        self.seriesId = seriesId
        // Only set reelId if it's not empty
        self.reelId = (reelId?.isEmpty == false) ? reelId : nil
    }
}

// MARK: - Favourite List Request
struct FavouriteListRequest: Encodable {
    let pageNo: Int

    init(pageNo: Int = 1) {
        self.pageNo = pageNo
    }
}

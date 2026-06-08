//
//  WatchLaterData.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 02/09/26.
//

import Foundation

// MARK: - Watch Later List Response
typealias WatchLaterListResponse = BaseAPIResponse<WatchLaterData>

// MARK: - Watch Later Data
struct WatchLaterData: Decodable {
    let movies: [WatchLaterItem]?
}

// MARK: - Watch Later Item
struct WatchLaterItem: Decodable, Identifiable {
    let watchLaterId: Int
    let id: Int  // Movie ID - used for Identifiable protocol
    let name: String?
    let type: Int?
    let typeDescription: String?
    let movieCategoryList: [String]?
    let totalEpisode: Int?
    let totalEpisodeText: String?
    let listingImage: String?
    let streamingUrl: String?
    let downloadStreamingUrl: String?
    let watchLaterTime: String?
    let lastWatch: String?
    let lastWatchTimeStamps: Int?
    let lastWatchEpisodeId: Int?
    let lastWatchEpisodeNumber: Int?
    let lastWatchEpisodeName: String?
    let purchaseId: Int?
    let purchaseNo: String?
    let watchTypeDesc: String?
    let subscriptionType: Int?
    let subscriptionTypeDesc: String?

    // Computed properties for convenience
    var movieName: String? { name }
    var addedDate: String? { watchLaterTime }

    var fullImageURL: String {
        guard let listingImage = listingImage, !listingImage.isEmpty else { return "" }
        if listingImage.hasPrefix("http") {
            return listingImage
        }
        return "http://103.59.163.3/heyplay-api" + listingImage
    }

    var isFree: Bool {
        return subscriptionType == 1
    }

    var isSeries: Bool {
        return (type ?? 1) == 2
    }

    var movieId: Int {
        return id
    }
}

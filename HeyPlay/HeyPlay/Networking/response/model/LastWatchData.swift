//
//  LastWatchData.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 02/09/26.
//

import Foundation

// MARK: - Last Watch List Response
typealias LastWatchListResponse = BaseAPIResponse<LastWatchData>

// MARK: - Last Watch Data
struct LastWatchData: Decodable {
    let lastWatchList: [LastWatchItem]?
    let totalCount: Int?
    let currentPage: Int?
    let totalPages: Int?
}

// MARK: - Last Watch Item
struct LastWatchItem: Decodable, Identifiable {
    let id: String
    let movieId: Int?
    let movieEpisodeId: Int?
    let movieName: String?
    let episodeName: String?
    let listingImage: String?
    let lastWatchTimeStamps: String?
    let duration: Int?
    let lastWatchDate: String?
    let movieType: Int?
    let subscriptionType: Int?

    var fullImageURL: String {
        guard let listingImage = listingImage, !listingImage.isEmpty else { return "" }
        if listingImage.hasPrefix("http") {
            return listingImage
        }
        return "http://103.59.163.3/heyplay-api" + listingImage
    }

    var isSeries: Bool {
        return (movieType ?? 1) == 2
    }
}

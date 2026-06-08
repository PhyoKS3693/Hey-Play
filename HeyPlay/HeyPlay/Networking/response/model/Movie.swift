//
//  Movie.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 02/09/26.
//

import Foundation

// MARK: - Movie
struct Movie: Decodable, Identifiable {
    let id: Int
    let episodeId: Int?  // For series episodes
    let name: String?
    let type: Int?
    let typeDescription: String?
    let movieCategoryList: [MovieCategory]?
    let totalEpisode: Int?
    let totalEpisodeText: String?
    let listingImage: String?
    let landScapseImage: String?
    let tvListingImage: String?
    let streamingUrl: String?
    let downloadStreamingUrl: String?
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

    // MARK: - Computed Properties
    var isMovie: Bool {
        return (type ?? 1) == 1
    }

    var isSeries: Bool {
        return (type ?? 1) == 2
    }

    var isEpisode: Bool {
        return episodeId != nil
    }

    var safeEpisodeId: Int {
        return episodeId ?? 0
    }

    var isFree: Bool {
        return (subscriptionType ?? 1) == 1
    }

    var isVIP: Bool {
        return (subscriptionType ?? 1) == 2
    }

    var hasStreamingUrl: Bool {
        return !(streamingUrl ?? "").isEmpty
    }

    var fullImageURL: String {
        guard let listingImage = listingImage, !listingImage.isEmpty else { return "" }
        if listingImage.hasPrefix("http") {
            return listingImage
        }
        return "http://103.59.163.3/heyplay-api" + listingImage
    }

    var fullTVImageURL: String? {
        guard let tvImage = tvListingImage, !tvImage.isEmpty else { return nil }
        if tvImage.hasPrefix("http") {
            return tvImage
        }
        return "http://103.59.163.3/heyplay-api" + tvImage
    }
}

// MARK: - Movie Category
struct MovieCategory: Decodable, Identifiable {
    let id: Int
    let name: String?
}

// MARK: - Subscription Type
enum SubscriptionType: Int {
    case free = 1
    case vip = 2
    case premium = 3

    var description: String {
        switch self {
        case .free: return "Free"
        case .vip: return "VIP"
        case .premium: return "Premium"
        }
    }
}

// MARK: - Content Type
enum ContentType: Int {
    case movie = 1
    case series = 2

    var description: String {
        switch self {
        case .movie: return "Movie"
        case .series: return "Series"
        }
    }
}

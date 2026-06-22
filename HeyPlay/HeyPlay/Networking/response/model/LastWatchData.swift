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
    let movies: [LastWatchItem]?

    // For backward compatibility
    var lastWatchList: [LastWatchItem]? {
        return movies
    }
}

// MARK: - Last Watch Item
struct LastWatchItem: Decodable, Identifiable {
    let lastWatchId: Int?
    let contentIdFromAPI: Int?  // The "id" field from API
    let movieId: Int?
    let seriesId: Int?  // API might return seriesId instead of movieId for series
    let episodeId: Int?
    let name: String?
    let listingImage: String?
    let lastWatchTimeStamps: Int?
    let lastWatch: String?
    let type: Int?
    let subscriptionType: Int?
    let subscriptionTypeDesc: String?
    let lastWatchEpisodeId: Int?
    let lastWatchEpisodeName: String?

    // Custom decoding to handle both movieId and seriesId
    enum CodingKeys: String, CodingKey {
        case lastWatchId = "lastWatchId"
        case contentIdFromAPI = "id"
        case movieId = "movieId"
        case seriesId = "seriesId"
        case episodeId = "episodeId"
        case name = "name"
        case listingImage = "listingImage"
        case lastWatchTimeStamps = "lastWatchTimeStamps"
        case lastWatch = "lastWatch"
        case type = "type"
        case subscriptionType = "subscriptionType"
        case subscriptionTypeDesc = "subscriptionTypeDesc"
        case lastWatchEpisodeId = "lastWatchEpisodeId"
        case lastWatchEpisodeName = "lastWatchEpisodeName"
    }

    // Custom decoder to debug what's actually in the JSON
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        lastWatchId = try? container.decode(Int.self, forKey: .lastWatchId)
        contentIdFromAPI = try? container.decode(Int.self, forKey: .contentIdFromAPI)
        movieId = try? container.decode(Int.self, forKey: .movieId)
        seriesId = try? container.decode(Int.self, forKey: .seriesId)
        episodeId = try? container.decode(Int.self, forKey: .episodeId)
        name = try? container.decode(String.self, forKey: .name)
        listingImage = try? container.decode(String.self, forKey: .listingImage)
        lastWatchTimeStamps = try? container.decode(Int.self, forKey: .lastWatchTimeStamps)
        lastWatch = try? container.decode(String.self, forKey: .lastWatch)
        type = try? container.decode(Int.self, forKey: .type)
        subscriptionType = try? container.decode(Int.self, forKey: .subscriptionType)
        subscriptionTypeDesc = try? container.decode(String.self, forKey: .subscriptionTypeDesc)
        lastWatchEpisodeId = try? container.decode(Int.self, forKey: .lastWatchEpisodeId)
        lastWatchEpisodeName = try? container.decode(String.self, forKey: .lastWatchEpisodeName)

        // Debug log all available fields
        print("🔍 [LastWatchItem] Decoded item:")
        print("   lastWatchId: \(lastWatchId ?? -1)")
        print("   id (from API): \(contentIdFromAPI ?? -1)")
        print("   movieId: \(movieId ?? -1)")
        print("   seriesId: \(seriesId ?? -1)")
        print("   name: \(name ?? "nil")")
        print("   type: \(type ?? -1)")
    }

    // Identifiable protocol requirement (must be named 'id')
    var id: String {
        return String(lastWatchId ?? 0)
    }

    // Computed properties for backward compatibility and UI
    var stringId: String {
        return id
    }

    var movieName: String? {
        return name
    }

    var lastWatchDate: String? {
        return lastWatch
    }

    var movieType: Int? {
        return type
    }

    // Get the correct content ID based on type (movieId for movies, seriesId for series)
    var contentId: Int {
        // Try multiple field names in order of preference
        if isSeries {
            return seriesId ?? contentIdFromAPI ?? movieId ?? 0
        } else {
            return movieId ?? contentIdFromAPI ?? seriesId ?? 0
        }
    }

    var fullImageURL: String {
        guard let listingImage = listingImage, !listingImage.isEmpty else { return "" }
        if listingImage.hasPrefix("http") {
            return listingImage
        }
        return "http://103.59.163.3/heyplay-api" + listingImage
    }

    var isSeries: Bool {
        return (type ?? 1) == 2
    }

    var isFree: Bool {
        return (subscriptionType ?? 1) == 1
    }
}

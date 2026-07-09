//
//  Reel.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 03/23/26.
//

import Foundation

// MARK: - Reel Data
struct ReelData: Decodable {
    let reels: [Reel]?
    let seed: Int?

    var safeReelList: [Reel] { reels ?? [] }
}

// MARK: - Reel
struct Reel: Decodable, Identifiable {
    let reelId: Int
    let movieId: Int?
    let title: String?
    let description: String?
    let streamingUrl: String?
    let listingImage: String?
    var isFavourite: Bool?
    let type: Int?
    let typeDesc: String?
    var reactionCount: String?

    // MARK: - Identifiable
    var id: Int { reelId }

    // MARK: - Safe Accessors
    var safeTitle: String { title ?? "" }
    var safeDescription: String { description ?? "" }
    var safeTypeDesc: String { typeDesc ?? "" }

    var fullThumbnailURL: String {
        guard let imagePath = listingImage, !imagePath.isEmpty else { return "" }
        if imagePath.hasPrefix("http") {
            return imagePath
        }
        return "http://103.59.163.3/heyplay-api" + imagePath
    }

    var fullStreamingURL: String? {
        guard let streamPath = streamingUrl, !streamPath.isEmpty else { return nil }
        if streamPath.hasPrefix("http") {
            return streamPath
        }
        return "http://103.59.163.3/heyplay-api" + streamPath
    }

    var reactionCountInt: Int {
        guard let countStr = reactionCount else { return 0 }
        return Int(countStr) ?? 0
    }

    var reactionCountText: String {
        let count = reactionCountInt
        if count >= 1000000 {
            return String(format: "%.1fM", Double(count) / 1000000)
        } else if count >= 1000 {
            return String(format: "%.1fK", Double(count) / 1000)
        }
        return "\(count)"
    }

    var isMovie: Bool {
        return (type ?? 1) == 1
    }

    var isSeries: Bool {
        return (type ?? 1) == 2
    }
}

// MARK: - Type Alias for API Response
typealias ReelListResponse = BaseAPIResponse<ReelData>

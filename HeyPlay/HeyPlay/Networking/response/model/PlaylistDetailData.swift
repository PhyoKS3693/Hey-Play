//
//  PlaylistDetailData.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 05/29/26.
//

import Foundation

struct PlaylistDetailData: Decodable {
    let playlistId: Int?
    let title: String?
    let typeDesc: String?
    let totalCount: Int?
    let totalCountDesc: String?
    let movieList: [Movie]

    enum CodingKeys: String, CodingKey {
        case playlistId
        case title
        case typeDesc
        case totalCount
        case totalCountDesc
        case movieList
    }

    // Computed properties for safe access
    var playlistTitle: String {
        return title ?? ""
    }

    var totalMoviesText: String {
        return totalCountDesc ?? "Total Movies: \(totalCount ?? 0)"
    }

    var movies: [Movie] {
        return movieList
    }
}

// Response wrapper
typealias PlaylistDetailResponse = BaseAPIResponse<PlaylistDetailData>

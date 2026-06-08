//
//  LastWatchRequest.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 02/09/26.
//

import Foundation

// MARK: - Add Last Watch Request
struct AddLastWatchRequest: Encodable {
    let movieId: Int
    let movieEpisodeId: String?
    let lastWatchTimeStamps: String

    init(movieId: Int, movieEpisodeId: String? = "", lastWatchTimeStamps: String) {
        self.movieId = movieId
        self.movieEpisodeId = movieEpisodeId
        self.lastWatchTimeStamps = lastWatchTimeStamps
    }
}

// MARK: - Delete Last Watch Request
struct DeleteLastWatchRequest: Encodable {
    let lastWatchId: String
}

// MARK: - Delete All Last Watch Request
struct DeleteAllLastWatchRequest: Encodable {
    // Empty request body
}

// MARK: - Last Watch List Request
struct LastWatchListRequest: Encodable {
    let pageNo: Int

    init(pageNo: Int = 1) {
        self.pageNo = pageNo
    }
}

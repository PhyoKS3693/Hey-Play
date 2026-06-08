//
//  ContentRequest.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 02/09/26.
//

import Foundation

// MARK: - Content Detail Request
struct ContentDetailRequest: Encodable {
    let movieId: Int
    let seasonId: String?

    init(movieId: Int, seasonId: String? = "") {
        self.movieId = movieId
        self.seasonId = seasonId
    }
}

// MARK: - Content Watch Request
struct ContentWatchRequest: Encodable {
    let movieId: Int
    let episodeId: String?

    init(movieId: Int, episodeId: String? = "") {
        self.movieId = movieId
        self.episodeId = episodeId
    }
}

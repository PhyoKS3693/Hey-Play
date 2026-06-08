//
//  WatchData.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 02/09/26.
//

import Foundation

// MARK: - Watch Data Response
typealias WatchDataResponse = BaseAPIResponse<WatchData>

// MARK: - Watch Data
struct WatchData: Decodable {
    let movieId: Int?
    let episodeId: Int?
    let streamingUrl: String?
    let downloadStreamingUrl: String?
    let name: String?
    let description: String?
    let duration: Int?
    let lastWatchTimeStamps: Int?
    let subtitleUrl: String?
    let qualityOptions: [QualityOption]?
}

// MARK: - Quality Option
struct QualityOption: Decodable {
    let quality: String?
    let url: String?
}

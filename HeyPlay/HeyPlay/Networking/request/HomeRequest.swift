//
//  HomeRequest.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 02/09/26.
//

import Foundation

// MARK: - Home Data Request
struct HomeDataRequest: Encodable {
    // Empty request body
}

// MARK: - Playlist Detail Request
struct PlaylistDetailRequest: Encodable {
    let playlistId: String
    let pageNo: Int

    init(playlistId: String, pageNo: Int = 1) {
        self.playlistId = playlistId
        self.pageNo = pageNo
    }
}

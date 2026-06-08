//
//  WatchLaterRequest.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 02/09/26.
//

import Foundation

// MARK: - Add Watch Later Request
struct AddWatchLaterRequest: Encodable {
    let movieId: Int
}

// MARK: - Delete Watch Later Request
struct DeleteWatchLaterRequest: Encodable {
    let id: Int
}

// MARK: - Delete All Watch Later Request
struct DeleteAllWatchLaterRequest: Encodable {
    // Empty request body
}

// MARK: - Watch Later List Request
struct WatchLaterListRequest: Encodable {
    let pageNo: Int

    init(pageNo: Int = 1) {
        self.pageNo = pageNo
    }
}

//
//  SearchRequest.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 02/09/26.
//

import Foundation

// MARK: - Content Search Request
struct ContentSearchRequest: Encodable {
    let searchKey: String
    let pageNo: String
    let movieType: String
    let movieOrigin: String

    init(
        searchKey: String = "",
        pageNo: Int = 1,
        movieType: String = "",
        movieOrigin: String = ""
    ) {
        self.searchKey = searchKey
        self.pageNo = String(pageNo)
        self.movieType = movieType
        self.movieOrigin = movieOrigin
    }
}

// MARK: - Search Preload Request
struct SearchPreloadRequest: Encodable {
    // Empty request body
}

// MARK: - Save Search History Request
struct SaveSearchHistoryRequest: Encodable {
    let searchString: String
}

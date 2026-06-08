//
//  SearchData.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 02/09/26.
//

import Foundation

// MARK: - Search Data
struct SearchData: Decodable {
    let movieList: [Movie]
}

// MARK: - Search Preload Data
struct SearchPreloadData: Decodable {
    let keywords: [SearchKeywordGroup]?
    let recentSearchKeywords: [String]?

    // Computed properties for backward compatibility
    var trendingSearches: [String] {
        return keywords?.first?.keys ?? []
    }

    var recentSearches: [String] {
        return recentSearchKeywords ?? []
    }
}

// MARK: - Search Keyword Group
struct SearchKeywordGroup: Decodable {
    let title: String?
    let keys: [String]?
}

// MARK: - Type Aliases for API Responses
typealias SearchResponse = BaseAPIResponse<SearchData>
typealias SearchPreloadResponse = BaseAPIResponse<SearchPreloadData>
typealias SaveSearchHistoryResponse = BaseAPIResponse<EmptyData>

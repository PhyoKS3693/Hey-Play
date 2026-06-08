//
//  ContentFilters.swift
//  HeyPlay
//
//  Created by Aye Myat Min on 05/05/26.
//

import Foundation

// MARK: - Movie Type Filter
enum MovieTypeFilter: String, CaseIterable {
    case all = ""
    case movie = "1"
    case series = "2"

    var displayName: String {
        switch self {
        case .all: return "All"
        case .movie: return "Movies"
        case .series: return "Series"
        }
    }
}

// MARK: - Movie Origin Filter
enum MovieOriginFilter: String, CaseIterable {
    case all = ""
    case local = "1"
    case international = "2"

    var displayName: String {
        switch self {
        case .all: return "All"
        case .local: return "Local"
        case .international: return "International"
        }
    }
}

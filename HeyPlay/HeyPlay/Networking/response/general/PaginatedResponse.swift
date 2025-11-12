//
//  PaginatedResponse.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 11/12/25.
//

import Foundation

public struct PaginatedResponse<T: Decodable>: Decodable {
    public let status: Int?
    public let message: String?
    public let data: T
    public let meta: Meta
    
    public struct Meta: Decodable {
        public let pagination: Pagination
    }

    public struct Pagination: Decodable {
        public let total: Int
        public let count: Int
        public let perPage: Int
        public let currentPage: Int
        public let totalPages: Int
        public let links: Links

        public enum CodingKeys: String, CodingKey {
            case total
            case count
            case perPage = "per_page"
            case currentPage = "current_page"
            case totalPages = "total_pages"
            case links
        }
    }
    
    public struct Links: Decodable {
        public let previous: String?
        public let next: String?
    }
}

extension PaginatedResponse {
    func asErrorResponse() -> ErrorResponse {
        .init(status: status ?? -1, message: message ?? "")
    }
}

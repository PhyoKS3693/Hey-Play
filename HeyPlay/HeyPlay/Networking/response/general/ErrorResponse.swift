//
//  ErrorResponse.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 11/12/25.
//

import Foundation

public struct ErrorResponse: Decodable {
    public let status: Int
    public let message: String
}

extension ErrorResponse: LocalizedError {
    
    public var failureReason: String? { message }
    public var errorDescription: String? { message }
    
}

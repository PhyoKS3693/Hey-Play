//
//  BasicResponse.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 11/12/25.
//

import Foundation

public struct BasicResponse: Decodable {
    public let status: Int
    public let message: String
}

extension BasicResponse {
    func asErrorResponse() -> ErrorResponse {
        .init(status: status, message: message)
    }
}

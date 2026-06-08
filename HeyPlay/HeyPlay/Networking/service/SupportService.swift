//
//  SupportService.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 02/09/26.
//

import Foundation
import Alamofire

// MARK: - Support Service Protocol
protocol SupportServiceProtocol {
    func getSupportList() async -> Result<SupportListData, Error>
}

// MARK: - Support Service
final class SupportService: SupportServiceProtocol {

    static let shared = SupportService()

    private init() {}

    // MARK: - Get Support List
    func getSupportList() async -> Result<SupportListData, Error> {
        let response = await APIClient.shared.request(
            urlConvertible: APIEndpoint.getSupportList.url,
            method: .post,
            parameters: [:],
            encoding: JSONEncoding.default,
            headers: HTTPHeaders([:]),
            responseType: SupportListResponse.self
        )

        switch response.result {
        case .success(let apiResponse):
            if apiResponse.isSuccess, let data = apiResponse.data {
                return .success(data)
            } else {
                return .failure(APIError.serverError(apiResponse.responseMessage))
            }
        case .failure(let error):
            return .failure(error)
        }
    }
}

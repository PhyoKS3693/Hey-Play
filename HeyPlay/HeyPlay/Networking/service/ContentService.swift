//
//  ContentService.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 02/09/26.
//

import Foundation
import Alamofire

// MARK: - Content Service Protocol
protocol ContentServiceProtocol {
    func getContentDetail(movieId: Int, seasonId: String?) async -> Result<ContentDetail, Error>
    func watchContent(movieId: Int, episodeId: String?) async -> Result<WatchData, Error>
}

// MARK: - Content Service
final class ContentService: ContentServiceProtocol {

    static let shared = ContentService()

    private init() {}

    // MARK: - Get Content Detail
    func getContentDetail(movieId: Int, seasonId: String? = nil) async -> Result<ContentDetail, Error> {
        let request = ContentDetailRequest(movieId: movieId, seasonId: seasonId)

        let response = await APIClient.shared.request(
            urlConvertible: APIEndpoint.contentDetail.url,
            method: .post,
            parameters: request.asDictionary(),
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(APIHeaders.defaultHeaders(
                customerId: AppDefaultsManager.shared.customerId ?? "",
                sessionId: AppDefaultsManager.shared.sessionId ?? ""
            )),
            responseType: ContentDetailResponse.self
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

    // MARK: - Watch Content
    func watchContent(movieId: Int, episodeId: String? = nil) async -> Result<WatchData, Error> {
        let request = ContentWatchRequest(movieId: movieId, episodeId: episodeId)

        let response = await APIClient.shared.request(
            urlConvertible: APIEndpoint.contentWatch.url,
            method: .post,
            parameters: request.asDictionary(),
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(APIHeaders.defaultHeaders(
                customerId: AppDefaultsManager.shared.customerId ?? "",
                sessionId: AppDefaultsManager.shared.sessionId ?? ""
            )),
            responseType: WatchDataResponse.self
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

// MARK: - Encodable Extension
extension Encodable {
    func asDictionary() -> [String: Any] {
        guard let data = try? JSONEncoder().encode(self),
              let dictionary = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
        else {
            return [:]
        }
        return dictionary
    }
}

// MARK: - API Error
enum APIError: Error, LocalizedError {
    case serverError(String)
    case noData
    case invalidResponse

    var errorDescription: String? {
        switch self {
        case .serverError(let message):
            return message
        case .noData:
            return "No data received"
        case .invalidResponse:
            return "Invalid response from server"
        }
    }
}

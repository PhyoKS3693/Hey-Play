//
//  LastWatchService.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 02/09/26.
//

import Foundation
import Alamofire

// MARK: - Last Watch Service Protocol
protocol LastWatchServiceProtocol {
    func addLastWatch(movieId: Int, movieEpisodeId: String?, lastWatchTimeStamps: String) async -> Result<Void, Error>
    func deleteLastWatch(lastWatchId: String) async -> Result<Void, Error>
    func deleteAllLastWatch() async -> Result<Void, Error>
    func getLastWatchList(pageNo: Int) async -> Result<LastWatchData, Error>
}

// MARK: - Last Watch Service
final class LastWatchService: LastWatchServiceProtocol {

    static let shared = LastWatchService()

    private init() {}

    // MARK: - Add Last Watch
    func addLastWatch(
        movieId: Int,
        movieEpisodeId: String? = nil,
        lastWatchTimeStamps: String
    ) async -> Result<Void, Error> {
        let request = AddLastWatchRequest(
            movieId: movieId,
            movieEpisodeId: movieEpisodeId,
            lastWatchTimeStamps: lastWatchTimeStamps
        )

        let response = await APIClient.shared.request(
            urlConvertible: APIEndpoint.lastWatchAdd.url,
            method: .post,
            parameters: request.asDictionary(),
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(APIHeaders.defaultHeaders(
                customerId: AppDefaultsManager.shared.customerId ?? "",
                sessionId: AppDefaultsManager.shared.sessionId ?? ""
            )),
            responseType: BaseAPIResponse<EmptyData>.self
        )

        switch response.result {
        case .success(let apiResponse):
            if apiResponse.isSuccess {
                return .success(())
            } else {
                return .failure(APIError.serverError(apiResponse.responseMessage))
            }
        case .failure(let error):
            return .failure(error)
        }
    }

    // MARK: - Delete Last Watch
    func deleteLastWatch(lastWatchId: String) async -> Result<Void, Error> {
        let request = DeleteLastWatchRequest(lastWatchId: lastWatchId)

        let response = await APIClient.shared.request(
            urlConvertible: APIEndpoint.lastWatchDelete.url,
            method: .post,
            parameters: request.asDictionary(),
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(APIHeaders.defaultHeaders(
                customerId: AppDefaultsManager.shared.customerId ?? "",
                sessionId: AppDefaultsManager.shared.sessionId ?? ""
            )),
            responseType: BaseAPIResponse<EmptyData>.self
        )

        switch response.result {
        case .success(let apiResponse):
            if apiResponse.isSuccess {
                return .success(())
            } else {
                return .failure(APIError.serverError(apiResponse.responseMessage))
            }
        case .failure(let error):
            return .failure(error)
        }
    }

    // MARK: - Delete All Last Watch
    func deleteAllLastWatch() async -> Result<Void, Error> {
        let request = DeleteAllLastWatchRequest()

        let response = await APIClient.shared.request(
            urlConvertible: APIEndpoint.lastWatchDeleteAll.url,
            method: .post,
            parameters: request.asDictionary(),
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(APIHeaders.defaultHeaders(
                customerId: AppDefaultsManager.shared.customerId ?? "",
                sessionId: AppDefaultsManager.shared.sessionId ?? ""
            )),
            responseType: BaseAPIResponse<EmptyData>.self
        )

        switch response.result {
        case .success(let apiResponse):
            if apiResponse.isSuccess {
                return .success(())
            } else {
                return .failure(APIError.serverError(apiResponse.responseMessage))
            }
        case .failure(let error):
            return .failure(error)
        }
    }

    // MARK: - Get Last Watch List
    func getLastWatchList(pageNo: Int = 1) async -> Result<LastWatchData, Error> {
        print("📡 [LastWatchService] Calling getLastWatchList API - pageNo: \(pageNo)")
        let request = LastWatchListRequest(pageNo: pageNo)

        let response = await APIClient.shared.request(
            urlConvertible: APIEndpoint.lastWatchList.url,
            method: .post,
            parameters: request.asDictionary(),
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(APIHeaders.defaultHeaders(
                customerId: AppDefaultsManager.shared.customerId ?? "",
                sessionId: AppDefaultsManager.shared.sessionId ?? ""
            )),
            responseType: LastWatchListResponse.self
        )

        switch response.result {
        case .success(let apiResponse):
            print("📥 [LastWatchService] API Response - success: \(apiResponse.isSuccess), message: \(apiResponse.responseMessage)")
            if apiResponse.isSuccess, let data = apiResponse.data {
                let itemCount = data.movies?.count ?? 0
                print("✅ [LastWatchService] Parsed \(itemCount) items")
                if let firstItem = data.movies?.first {
                    print("📝 [LastWatchService] First item - id(API): \(firstItem.contentIdFromAPI ?? -999), movieId: \(firstItem.movieId ?? -999), seriesId: \(firstItem.seriesId ?? -999), type: \(firstItem.type ?? -999)")
                }
                return .success(data)
            } else {
                print("❌ [LastWatchService] API returned error: \(apiResponse.responseMessage)")
                return .failure(APIError.serverError(apiResponse.responseMessage))
            }
        case .failure(let error):
            print("❌ [LastWatchService] Network error: \(error.localizedDescription)")
            return .failure(error)
        }
    }
}

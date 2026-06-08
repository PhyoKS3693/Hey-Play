//
//  WatchLaterService.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 02/09/26.
//

import Foundation
import Alamofire

// MARK: - Watch Later Service Protocol
protocol WatchLaterServiceProtocol {
    func addWatchLater(movieId: Int) async -> Result<Void, Error>
    func deleteWatchLater(id: Int) async -> Result<Void, Error>
    func deleteAllWatchLater() async -> Result<Void, Error>
    func getWatchLaterList(pageNo: Int) async -> Result<WatchLaterData, Error>
}

// MARK: - Watch Later Service
final class WatchLaterService: WatchLaterServiceProtocol {

    static let shared = WatchLaterService()

    private init() {}

    // MARK: - Add Watch Later
    func addWatchLater(movieId: Int) async -> Result<Void, Error> {
        let request = AddWatchLaterRequest(movieId: movieId)

        let response = await APIClient.shared.request(
            urlConvertible: APIEndpoint.watchLaterAdd.url,
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

    // MARK: - Delete Watch Later
    func deleteWatchLater(id: Int) async -> Result<Void, Error> {
        let request = DeleteWatchLaterRequest(id: id)

        let response = await APIClient.shared.request(
            urlConvertible: APIEndpoint.watchLaterDelete.url,
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

    // MARK: - Delete All Watch Later
    func deleteAllWatchLater() async -> Result<Void, Error> {
        let request = DeleteAllWatchLaterRequest()

        let response = await APIClient.shared.request(
            urlConvertible: APIEndpoint.watchLaterDeleteAll.url,
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

    // MARK: - Get Watch Later List
    func getWatchLaterList(pageNo: Int = 1) async -> Result<WatchLaterData, Error> {
        let request = WatchLaterListRequest(pageNo: pageNo)

        let response = await APIClient.shared.request(
            urlConvertible: APIEndpoint.watchLaterList.url,
            method: .post,
            parameters: request.asDictionary(),
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(APIHeaders.defaultHeaders(
                customerId: AppDefaultsManager.shared.customerId ?? "",
                sessionId: AppDefaultsManager.shared.sessionId ?? ""
            )),
            responseType: WatchLaterListResponse.self
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

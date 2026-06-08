//
//  FavouriteService.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 02/09/26.
//

import Foundation
import Alamofire

// MARK: - Favourite Service Protocol
protocol FavouriteServiceProtocol {
    func addFavourite(movieId: String?, seriesId: String?, reelId: String?) async -> Result<Void, Error>
    func removeFavourite(movieId: Int?, seriesId: Int?, reelId: String?) async -> Result<Void, Error>
    func getFavouriteList(pageNo: Int) async -> Result<FavouriteListData, Error>
}

// MARK: - Favourite Service
final class FavouriteService: FavouriteServiceProtocol {

    static let shared = FavouriteService()

    private init() {}

    // MARK: - Add Favourite
    func addFavourite(movieId: String? = nil, seriesId: String? = nil, reelId: String? = nil) async -> Result<Void, Error> {
        print("❤️ [FavouriteService] Adding to favourites")
        if let movieId = movieId, !movieId.isEmpty {
            print("🎬 [FavouriteService] MovieID: \(movieId)")
        }
        if let seriesId = seriesId, !seriesId.isEmpty {
            print("📺 [FavouriteService] SeriesID: \(seriesId)")
        }
        if let reelId = reelId, !reelId.isEmpty {
            print("🎞️ [FavouriteService] ReelID: \(reelId)")
        }

        let request = AddFavouriteRequest(movieId: movieId, seriesId: seriesId, reelId: reelId)
        let params = request.asDictionary()
        print("📦 [FavouriteService] Request params: \(params)")

        let response = await APIClient.shared.request(
            urlConvertible: APIEndpoint.favouriteAdd.url,
            method: .post,
            parameters: params,
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
                print("✅ [FavouriteService] Successfully added to favourites")
                return .success(())
            } else {
                print("❌ [FavouriteService] Failed to add: \(apiResponse.responseMessage)")
                return .failure(APIError.serverError(apiResponse.responseMessage))
            }
        case .failure(let error):
            print("❌ [FavouriteService] Network error: \(error.localizedDescription)")
            return .failure(error)
        }
    }

    // MARK: - Remove Favourite
    func removeFavourite(movieId: Int? = nil, seriesId: Int? = nil, reelId: String? = nil) async -> Result<Void, Error> {
        print("💔 [FavouriteService] Removing from favourites")
        if let movieId = movieId {
            print("🎬 [FavouriteService] MovieID: \(movieId)")
        }
        if let seriesId = seriesId {
            print("📺 [FavouriteService] SeriesID: \(seriesId)")
        }
        if let reelId = reelId, !reelId.isEmpty {
            print("🎞️ [FavouriteService] ReelID: \(reelId)")
        }

        let request = RemoveFavouriteRequest(movieId: movieId, seriesId: seriesId, reelId: reelId)
        let params = request.asDictionary()
        print("📦 [FavouriteService] Request params: \(params)")

        let response = await APIClient.shared.request(
            urlConvertible: APIEndpoint.favouriteRemove.url,
            method: .post,
            parameters: params,
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
                print("✅ [FavouriteService] Successfully removed from favourites")
                return .success(())
            } else {
                print("❌ [FavouriteService] Failed to remove: \(apiResponse.responseMessage)")
                return .failure(APIError.serverError(apiResponse.responseMessage))
            }
        case .failure(let error):
            print("❌ [FavouriteService] Network error: \(error.localizedDescription)")
            return .failure(error)
        }
    }

    // MARK: - Get Favourite List
    func getFavouriteList(pageNo: Int = 1) async -> Result<FavouriteListData, Error> {
        let request = FavouriteListRequest(pageNo: pageNo)

        let response = await APIClient.shared.request(
            urlConvertible: APIEndpoint.favouriteList.url,
            method: .post,
            parameters: request.asDictionary(),
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(APIHeaders.defaultHeaders(
                customerId: AppDefaultsManager.shared.customerId ?? "",
                sessionId: AppDefaultsManager.shared.sessionId ?? ""
            )),
            responseType: FavouriteListResponse.self
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

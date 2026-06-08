//
//  HomeService.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 02/09/26.
//

import Foundation
import Alamofire

// MARK: - Home Service Protocol
protocol HomeServiceProtocol {
    func getHomeData() async -> Result<HomeData, Error>
    func getPlaylistDetail(playlistId: String, pageNo: Int) async -> Result<PlaylistDetailData, Error>
}

// MARK: - Home Service
final class HomeService: HomeServiceProtocol {

    static let shared = HomeService()

    private init() {}

    // MARK: - Get Home Data
    func getHomeData() async -> Result<HomeData, Error> {
        let request = HomeDataRequest()

        let response = await APIClient.shared.request(
            urlConvertible: APIEndpoint.getHomeData.url,
            method: .post,
            parameters: request.asDictionary(),
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(APIHeaders.defaultHeaders(
                customerId: AppDefaultsManager.shared.customerId ?? "",
                sessionId: AppDefaultsManager.shared.sessionId ?? ""
            )),
            responseType: HomeDataResponse.self
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

    // MARK: - Get Playlist Detail
    func getPlaylistDetail(playlistId: String, pageNo: Int = 1) async -> Result<PlaylistDetailData, Error> {
        print("📋 [HomeService] Fetching playlist detail for ID: \(playlistId), page: \(pageNo)")

        let request = PlaylistDetailRequest(playlistId: playlistId, pageNo: pageNo)

        let response = await APIClient.shared.request(
            urlConvertible: APIEndpoint.playlistDetail.url,
            method: .post,
            parameters: request.asDictionary(),
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(APIHeaders.defaultHeaders(
                customerId: AppDefaultsManager.shared.customerId ?? "",
                sessionId: AppDefaultsManager.shared.sessionId ?? ""
            )),
            responseType: PlaylistDetailResponse.self
        )

        switch response.result {
        case .success(let apiResponse):
            if apiResponse.isSuccess, let data = apiResponse.data {
                print("✅ [HomeService] Successfully fetched \(data.movies.count) movies from playlist")
                return .success(data)
            } else {
                print("❌ [HomeService] Error: \(apiResponse.responseMessage)")
                return .failure(APIError.serverError(apiResponse.responseMessage))
            }
        case .failure(let error):
            print("❌ [HomeService] Network error: \(error.localizedDescription)")
            return .failure(error)
        }
    }
}

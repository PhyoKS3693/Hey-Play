//
//  SearchService.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 02/09/26.
//

import Foundation
import Alamofire

// MARK: - Search Service Protocol
protocol SearchServiceProtocol {
    func searchContents(searchKey: String, pageNo: Int, movieType: String, movieOrigin: String) async -> Result<SearchData, Error>
    func getSearchPreload() async -> Result<SearchPreloadData, Error>
    func saveSearchHistory(searchString: String) async -> Result<Void, Error>
}

// MARK: - Search Service
final class SearchService: SearchServiceProtocol {

    static let shared = SearchService()

    private init() {}

    // MARK: - Search Contents
    func searchContents(
        searchKey: String = "",
        pageNo: Int = 1,
        movieType: String = "",
        movieOrigin: String = ""
    ) async -> Result<SearchData, Error> {
        let request = ContentSearchRequest(
            searchKey: searchKey,
            pageNo: pageNo,
            movieType: movieType,
            movieOrigin: movieOrigin
        )

        let response = await APIClient.shared.request(
            urlConvertible: APIEndpoint.searchContents.url,
            method: .post,
            parameters: request.asDictionary(),
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(APIHeaders.defaultHeaders(
                customerId: AppDefaultsManager.shared.customerId ?? "",
                sessionId: AppDefaultsManager.shared.sessionId ?? ""
            )),
            responseType: SearchResponse.self
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

    // MARK: - Get Search Preload
    func getSearchPreload() async -> Result<SearchPreloadData, Error> {
        let request = SearchPreloadRequest()

        let response = await APIClient.shared.request(
            urlConvertible: APIEndpoint.searchPreload.url,
            method: .post,
            parameters: request.asDictionary(),
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(APIHeaders.defaultHeaders(
                customerId: AppDefaultsManager.shared.customerId ?? "",
                sessionId: AppDefaultsManager.shared.sessionId ?? ""
            )),
            responseType: SearchPreloadResponse.self
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

    // MARK: - Save Search History
    func saveSearchHistory(searchString: String) async -> Result<Void, Error> {
        let request = SaveSearchHistoryRequest(searchString: searchString)

        let response = await APIClient.shared.request(
            urlConvertible: APIEndpoint.saveSearchHistory.url,
            method: .post,
            parameters: request.asDictionary(),
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(APIHeaders.defaultHeaders(
                customerId: AppDefaultsManager.shared.customerId ?? "",
                sessionId: AppDefaultsManager.shared.sessionId ?? ""
            )),
            responseType: SaveSearchHistoryResponse.self
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
}

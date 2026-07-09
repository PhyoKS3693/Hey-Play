//
//  ReelService.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 03/23/26.
//

import Foundation
import Alamofire

// MARK: - Reel Service Protocol
protocol ReelServiceProtocol {
    func getReelList(pageNo: Int, reelId: Int?, seed: String?) async -> Result<ReelData, Error>
}

// MARK: - Reel Service
final class ReelService: ReelServiceProtocol {

    static let shared = ReelService()

    private init() {}

    // MARK: - Get Reel List
    func getReelList(pageNo: Int = 1, reelId: Int? = nil, seed: String? = nil) async -> Result<ReelData, Error> {
        let request = ReelListRequest(pageNo: pageNo, reelId: reelId, seed: seed)

        let response = await APIClient.shared.request(
            urlConvertible: APIEndpoint.reelList.url,
            method: .post,
            parameters: request.asDictionary(),
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(APIHeaders.defaultHeaders(
                customerId: AppDefaultsManager.shared.customerId ?? "",
                sessionId: AppDefaultsManager.shared.sessionId ?? ""
            )),
            responseType: ReelListResponse.self
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

// MARK: - Reel List Request
struct ReelListRequest: Encodable {
    let pageNo: Int
    let reelId: Int?
    let seed: String?

    init(pageNo: Int = 1, reelId: Int? = nil, seed: String? = nil) {
        self.pageNo = pageNo
        self.reelId = reelId
        self.seed = seed
    }
}

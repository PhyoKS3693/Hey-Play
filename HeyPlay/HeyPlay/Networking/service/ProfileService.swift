//
//  ProfileService.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 03/23/26.
//

import Foundation
import Alamofire

// MARK: - Profile Service Protocol
protocol ProfileServiceProtocol {
    func getProfile() async -> Result<Profile, Error>
}

// MARK: - Profile Service
final class ProfileService: ProfileServiceProtocol {

    static let shared = ProfileService()

    private init() {}

    // MARK: - Get Profile
    func getProfile() async -> Result<Profile, Error> {
        let response = await APIClient.shared.request(
            urlConvertible: APIEndpoint.profile.url,
            method: .post,
            parameters: [:],
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(APIHeaders.defaultHeaders(
                customerId: AppDefaultsManager.shared.customerId ?? "",
                sessionId: AppDefaultsManager.shared.sessionId ?? ""
            )),
            responseType: ProfileResponse.self
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

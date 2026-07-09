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
    func updateProfile(name: String, email: String?, gender: Int?, profileImage: String?) async -> Result<Profile, Error>
    func linkAccount(request: LinkAccountRequest) async -> Result<Profile, Error>
    func unlinkAccount(request: UnlinkAccountRequest) async -> Result<Profile, Error>
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
                // Extract error message from errors array if available
                let errorMessage: String
                if let errors = apiResponse.errors, let firstError = errors.first {
                    errorMessage = firstError.errorMessage
                    print("❌ [ProfileService] Get profile failed with fieldCode \(firstError.fieldCode): \(errorMessage)")
                } else {
                    errorMessage = apiResponse.responseMessage
                    print("❌ [ProfileService] Get profile failed: \(errorMessage)")
                }
                return .failure(APIError.serverError(errorMessage))
            }
        case .failure(let error):
            return .failure(error)
        }
    }

    // MARK: - Update Profile
    func updateProfile(name: String, email: String?, gender: Int?, profileImage: String?) async -> Result<Profile, Error> {
        let request = UpdateProfileRequest(name: name, email: email, gender: gender, profileImage: profileImage)

        print("📤 [ProfileService] Updating profile - name: \(name), email: \(email ?? "nil"), gender: \(gender?.description ?? "nil"), profileImage: \(profileImage != nil ? "present" : "nil")")

        let response = await APIClient.shared.request(
            urlConvertible: APIEndpoint.profileUpdate.url,
            method: .post,
            parameters: request.asDictionary(),
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(APIHeaders.defaultHeaders(
                customerId: AppDefaultsManager.shared.customerId ?? "",
                sessionId: AppDefaultsManager.shared.sessionId ?? ""
            )),
            responseType: ProfileResponse.self
        )

        switch response.result {
        case .success(let apiResponse):
            print("📥 [ProfileService] API Response - success: \(apiResponse.isSuccess), message: \(apiResponse.responseMessage)")

            if apiResponse.isSuccess {
                // If successful but no data returned, fetch the updated profile
                if let data = apiResponse.data {
                    print("✅ [ProfileService] Profile updated successfully with data")
                    return .success(data)
                } else {
                    print("✅ [ProfileService] Profile updated successfully, fetching updated profile...")
                    // Fetch the updated profile since the update API didn't return data
                    return await getProfile()
                }
            } else {
                // Extract error message from errors array if available
                let errorMessage: String
                if let errors = apiResponse.errors, let firstError = errors.first {
                    errorMessage = firstError.errorMessage
                    print("❌ [ProfileService] Update failed with fieldCode \(firstError.fieldCode): \(errorMessage)")
                } else {
                    errorMessage = apiResponse.responseMessage
                    print("❌ [ProfileService] Update failed: \(errorMessage)")
                }
                return .failure(APIError.serverError(errorMessage))
            }
        case .failure(let error):
            print("❌ [ProfileService] Network error: \(error.localizedDescription)")
            return .failure(error)
        }
    }

    // MARK: - Link Account
    func linkAccount(request: LinkAccountRequest) async -> Result<Profile, Error> {
        print("📤 [ProfileService] Linking account - accountType: \(request.accountType)")

        let response = await APIClient.shared.request(
            urlConvertible: APIEndpoint.linkedAccount.url,
            method: .post,
            parameters: request.asDictionary(),
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(APIHeaders.defaultHeaders(
                customerId: AppDefaultsManager.shared.customerId ?? "",
                sessionId: AppDefaultsManager.shared.sessionId ?? ""
            )),
            responseType: ProfileResponse.self
        )

        switch response.result {
        case .success(let apiResponse):
            print("📥 [ProfileService] Link Account Response - success: \(apiResponse.isSuccess), message: \(apiResponse.responseMessage)")

            if apiResponse.isSuccess {
                // If successful but no data returned, fetch the updated profile
                if let data = apiResponse.data {
                    print("✅ [ProfileService] Account linked successfully with data")
                    return .success(data)
                } else {
                    print("✅ [ProfileService] Account linked successfully, fetching updated profile...")
                    // Fetch the updated profile since the link API didn't return data
                    return await getProfile()
                }
            } else {
                // Extract error message from errors array if available
                let errorMessage: String
                if let errors = apiResponse.errors, let firstError = errors.first {
                    errorMessage = firstError.errorMessage
                    print("❌ [ProfileService] Link account failed with fieldCode \(firstError.fieldCode): \(errorMessage)")
                } else {
                    errorMessage = apiResponse.responseMessage
                    print("❌ [ProfileService] Link account failed: \(errorMessage)")
                }
                return .failure(APIError.serverError(errorMessage))
            }
        case .failure(let error):
            print("❌ [ProfileService] Network error: \(error.localizedDescription)")
            return .failure(error)
        }
    }

    // MARK: - Unlink Account
    func unlinkAccount(request: UnlinkAccountRequest) async -> Result<Profile, Error> {
        print("📤 [ProfileService] Unlinking account - accountType: \(request.accountType)")

        let response = await APIClient.shared.request(
            urlConvertible: APIEndpoint.unlinkAccount.url,
            method: .post,
            parameters: request.asDictionary(),
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(APIHeaders.defaultHeaders(
                customerId: AppDefaultsManager.shared.customerId ?? "",
                sessionId: AppDefaultsManager.shared.sessionId ?? ""
            )),
            responseType: ProfileResponse.self
        )

        switch response.result {
        case .success(let apiResponse):
            print("📥 [ProfileService] Unlink Account Response - success: \(apiResponse.isSuccess), message: \(apiResponse.responseMessage)")

            if apiResponse.isSuccess {
                // If successful but no data returned, fetch the updated profile
                if let data = apiResponse.data {
                    print("✅ [ProfileService] Account unlinked successfully with data")
                    return .success(data)
                } else {
                    print("✅ [ProfileService] Account unlinked successfully, fetching updated profile...")
                    // Fetch the updated profile since the unlink API didn't return data
                    return await getProfile()
                }
            } else {
                // Extract error message from errors array if available
                let errorMessage: String
                if let errors = apiResponse.errors, let firstError = errors.first {
                    errorMessage = firstError.errorMessage
                    print("❌ [ProfileService] Unlink account failed with fieldCode \(firstError.fieldCode): \(errorMessage)")
                } else {
                    errorMessage = apiResponse.responseMessage
                    print("❌ [ProfileService] Unlink account failed: \(errorMessage)")
                }
                return .failure(APIError.serverError(errorMessage))
            }
        case .failure(let error):
            print("❌ [ProfileService] Network error: \(error.localizedDescription)")
            return .failure(error)
        }
    }
}



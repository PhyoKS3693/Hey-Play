//
//  VersionCheckService.swift
//  HeyPlay
//
//  Created by Claude on 18/06/2026.
//

import Foundation
import Alamofire

final class VersionCheckService {
    static let shared = VersionCheckService()

    private init() {}

    // MARK: - Check App Version
    func checkAppVersion() async -> Result<VersionCheckData, Error> {
        // Get current app version
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"

        // Prepare headers with version number and device type
        let headersDict = APIHeaders.authHeaders(deviceType: "2", versionNumber: appVersion)
        let headers = HTTPHeaders(headersDict)

        print("📱 [VersionCheck] Checking version: \(appVersion)")

        let response = await APIClient.shared.request(
            urlConvertible: APIEndpoint.checkAppVersion.url,
            method: .post,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: headers,
            responseType: VersionCheckResponse.self
        )

        switch response.result {
        case .success(let apiResponse):
            if apiResponse.isSuccess, let data = apiResponse.data {
                print("✅ [VersionCheck] Success")
                print("   Force Update: \(data.isForceUpdate)")
                print("   Normal Update: \(data.isNormalUpdate)")
                if data.needsUpdate {
                    print("   Store URL: \(data.safeStoreUrl)")
                }
                return .success(data)
            } else {
                let error = APIError.serverError(apiResponse.responseMessage)
                print("❌ [VersionCheck] Server error: \(apiResponse.responseMessage)")
                return .failure(error)
            }

        case .failure(let error):
            print("❌ [VersionCheck] Network error: \(error.localizedDescription)")
            return .failure(error)
        }
    }
}

//
//  PhoneChangeService.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 02/09/26.
//

import Foundation
import Alamofire

// MARK: - Phone Change Service Protocol
protocol PhoneChangeServiceProtocol {
    func validateNewPhone(newPhone: String) async -> Result<ValidatePhoneData, Error>
    func updatePhoneNumber(newPhone: String, otp: String, securityKey: String) async -> Result<Void, Error>
}

// MARK: - Phone Change Service
final class PhoneChangeService: PhoneChangeServiceProtocol {

    static let shared = PhoneChangeService()

    private init() {}

    // MARK: - Validate New Phone
    func validateNewPhone(newPhone: String) async -> Result<ValidatePhoneData, Error> {
        print("🌐 [PhoneChangeService] Preparing API request for phone: \(newPhone)")

        let request = ValidateNewPhoneRequest(newPhone: newPhone)
        let params = request.asDictionary()
        let customerId = AppDefaultsManager.shared.customerId ?? ""
        let sessionId = AppDefaultsManager.shared.sessionId ?? ""

        print("📦 [PhoneChangeService] Request params: \(params)")
        print("🔑 [PhoneChangeService] CustomerID: \(customerId), SessionID: \(sessionId)")
        print("🌍 [PhoneChangeService] Endpoint: \(APIEndpoint.validateNewPhoneForChange.url)")

        let response = await APIClient.shared.request(
            urlConvertible: APIEndpoint.validateNewPhoneForChange.url,
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(APIHeaders.defaultHeaders(
                customerId: customerId,
                sessionId: sessionId
            )),
            responseType: ValidatePhoneResponse.self
        )

        print("📨 [PhoneChangeService] Response received")

        switch response.result {
        case .success(let apiResponse):
            print("✅ [PhoneChangeService] API Success - ResponseCode: \(apiResponse.responseCode), Message: \(apiResponse.responseMessage)")
            if apiResponse.isSuccess, let data = apiResponse.data {
                print("✅ [PhoneChangeService] Data received - SecurityKey: \(data.securityKey ?? "nil")")
                return .success(data)
            } else {
                print("❌ [PhoneChangeService] API returned error: \(apiResponse.responseMessage)")
                return .failure(APIError.serverError(apiResponse.responseMessage))
            }
        case .failure(let error):
            print("❌ [PhoneChangeService] Network/API failure: \(error.localizedDescription)")
            return .failure(error)
        }
    }

    // MARK: - Update Phone Number
    func updatePhoneNumber(newPhone: String, otp: String, securityKey: String) async -> Result<Void, Error> {
        let request = UpdatePhoneNumberRequest(newPhone: newPhone, otp: otp, securityKey: securityKey)

        let response = await APIClient.shared.request(
            urlConvertible: APIEndpoint.updatePhoneNumber.url,
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
}

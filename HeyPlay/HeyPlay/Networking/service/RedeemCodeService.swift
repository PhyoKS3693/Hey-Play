//
//  RedeemCodeService.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 02/09/26.
//

import Foundation
import Alamofire

// MARK: - Redeem Code Service Protocol
protocol RedeemCodeServiceProtocol {
    func redeemPromoCode(promoCode: String) async -> Result<String, Error>
}

// MARK: - Redeem Code Service
final class RedeemCodeService: RedeemCodeServiceProtocol {

    static let shared = RedeemCodeService()

    private init() {}

    // MARK: - Redeem Promo Code
    func redeemPromoCode(promoCode: String) async -> Result<String, Error> {
        print("🎟️ [RedeemCodeService] Redeeming promo code: \(promoCode)")

        let request = RedeemCodeRequest(promoCode: promoCode)

        let response = await APIClient.shared.request(
            urlConvertible: APIEndpoint.redeemPromoCode.url,
            method: .post,
            parameters: request.asDictionary(),
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(APIHeaders.defaultHeaders(
                customerId: AppDefaultsManager.shared.customerId ?? "",
                sessionId: AppDefaultsManager.shared.sessionId ?? ""
            )),
            responseType: RedeemCodeResponse.self
        )

        switch response.result {
        case .success(let apiResponse):
            if apiResponse.isSuccess {
                print("✅ [RedeemCodeService] Promo code redeemed successfully")
                // Return the success message from API
                return .success(apiResponse.responseMessage)
            } else {
                // Extract error message from errors array if available
                let errorMessage: String
                if let errors = apiResponse.errors, let firstError = errors.first {
                    errorMessage = firstError.errorMessage
                    print("❌ [RedeemCodeService] Failed with fieldCode \(firstError.fieldCode): \(errorMessage)")
                } else {
                    errorMessage = apiResponse.responseMessage
                    print("❌ [RedeemCodeService] Failed: \(errorMessage)")
                }
                return .failure(APIError.serverError(errorMessage))
            }
        case .failure(let error):
            print("❌ [RedeemCodeService] API Error: \(error.localizedDescription)")
            return .failure(error)
        }
    }
}

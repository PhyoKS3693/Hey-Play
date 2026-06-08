//
//  SubscriptionPlanService.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 02/09/26.
//

import Foundation
import Alamofire

// MARK: - Subscription Plan Service Protocol
protocol SubscriptionPlanServiceProtocol {
    func getSubscriptionPlanTypeList() async -> Result<[SubscriptionPlanType], Error>
    func getSubscriptionPlanPreload() async -> Result<SubscriptionPreloadData, Error>
    func buyPackage(paymentMethodId: String, packageId: String) async -> Result<BuyPackageData, Error>
    func getPackageHistory(fromDate: String, toDate: String) async -> Result<[PackageHistory], Error>
}

// MARK: - Subscription Plan Service
final class SubscriptionPlanService: SubscriptionPlanServiceProtocol {

    static let shared = SubscriptionPlanService()

    private init() {}

    // MARK: - Get Subscription Plan Type List
    func getSubscriptionPlanTypeList() async -> Result<[SubscriptionPlanType], Error> {
        let request = SubscriptionPlanTypeListRequest()

        let response = await APIClient.shared.request(
            urlConvertible: APIEndpoint.subscriptionPlanTypeList.url,
            method: .post,
            parameters: request.asDictionary(),
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(APIHeaders.defaultHeaders(
                customerId: AppDefaultsManager.shared.customerId ?? "",
                sessionId: AppDefaultsManager.shared.sessionId ?? ""
            )),
            responseType: SubscriptionPlanTypeListResponse.self
        )

        switch response.result {
        case .success(let apiResponse):
            if apiResponse.isSuccess, let data = apiResponse.data {
                return .success(data.subscriptionPlanTypeResponseList ?? [])
            } else {
                return .failure(APIError.serverError(apiResponse.responseMessage))
            }
        case .failure(let error):
            return .failure(error)
        }
    }

    // MARK: - Get Subscription Plan Preload
    func getSubscriptionPlanPreload() async -> Result<SubscriptionPreloadData, Error> {
        let request = SubscriptionPlanPreloadRequest()

        let response = await APIClient.shared.request(
            urlConvertible: APIEndpoint.subscriptionPlanPreload.url,
            method: .post,
            parameters: request.asDictionary(),
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(APIHeaders.defaultHeaders(
                customerId: AppDefaultsManager.shared.customerId ?? "",
                sessionId: AppDefaultsManager.shared.sessionId ?? ""
            )),
            responseType: SubscriptionPreloadResponse.self
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

    // MARK: - Buy Package
    func buyPackage(paymentMethodId: String, packageId: String) async -> Result<BuyPackageData, Error> {
        let request = BuyPackageRequest(paymentMethodId: paymentMethodId, packageId: packageId)

        let response = await APIClient.shared.request(
            urlConvertible: APIEndpoint.subscriptionPlanBuy.url,
            method: .post,
            parameters: request.asDictionary(),
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(APIHeaders.defaultHeaders(
                customerId: AppDefaultsManager.shared.customerId ?? "",
                sessionId: AppDefaultsManager.shared.sessionId ?? ""
            )),
            responseType: BuyPackageResponse.self
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

    // MARK: - Get Package History
    func getPackageHistory(fromDate: String = "", toDate: String = "") async -> Result<[PackageHistory], Error> {
        print("📋 [SubscriptionPlanService] Fetching package history from: \(fromDate), to: \(toDate)")

        let request = PackageHistoryRequest(fromDate: fromDate, toDate: toDate)

        let response = await APIClient.shared.request(
            urlConvertible: APIEndpoint.subscriptionPlanHistories.url,
            method: .post,
            parameters: request.asDictionary(),
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(APIHeaders.defaultHeaders(
                customerId: AppDefaultsManager.shared.customerId ?? "",
                sessionId: AppDefaultsManager.shared.sessionId ?? ""
            )),
            responseType: PackageHistoryResponse.self
        )

        switch response.result {
        case .success(let apiResponse):
            if apiResponse.isSuccess, let data = apiResponse.data {
                print("✅ [SubscriptionPlanService] Successfully fetched \(data.histories.count) history records")
                return .success(data.histories)
            } else {
                print("❌ [SubscriptionPlanService] Error: \(apiResponse.responseMessage)")
                return .failure(APIError.serverError(apiResponse.responseMessage))
            }
        case .failure(let error):
            print("❌ [SubscriptionPlanService] Network error: \(error.localizedDescription)")
            return .failure(error)
        }
    }
}

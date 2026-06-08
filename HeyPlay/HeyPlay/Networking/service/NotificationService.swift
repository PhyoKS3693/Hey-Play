//
//  NotificationService.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 02/09/26.
//

import Foundation
import Alamofire

// MARK: - Notification Service Protocol
protocol NotificationServiceProtocol {
    func getNotificationList(pageNo: Int) async -> Result<NotificationListData, Error>
    func getNotificationDetail(notiId: Int, notiHistoryFlag: Int) async -> Result<APINotificationDetail, Error>
}

// MARK: - Notification Service
final class NotificationService: NotificationServiceProtocol {

    static let shared = NotificationService()

    private init() {}

    // MARK: - Get Notification List
    func getNotificationList(pageNo: Int = 1) async -> Result<NotificationListData, Error> {
        let request = NotificationListRequest(pageNo: pageNo)

        let response = await APIClient.shared.request(
            urlConvertible: APIEndpoint.notificationList.url,
            method: .post,
            parameters: request.asDictionary(),
            encoding: JSONEncoding.default,
            headers: HTTPHeaders([:]),
            responseType: NotificationListResponse.self
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

    // MARK: - Get Notification Detail
    func getNotificationDetail(notiId: Int, notiHistoryFlag: Int = 0) async -> Result<APINotificationDetail, Error> {
        let request = NotificationDetailRequest(notiId: notiId, notiHistoryFlag: notiHistoryFlag)

        let response = await APIClient.shared.request(
            urlConvertible: APIEndpoint.notificationDetail.url,
            method: .post,
            parameters: request.asDictionary(),
            encoding: JSONEncoding.default,
            headers: HTTPHeaders([:]),
            responseType: NotificationDetailResponse.self
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

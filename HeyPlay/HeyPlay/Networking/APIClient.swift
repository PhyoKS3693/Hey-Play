//
//  APIClient.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 11/12/25.
//

import Foundation
import Alamofire

class APIClient {
    static let shared = APIClient()

    private init() {
        setupSession()
    }

    private func setupSession() {
        let config = URLSessionConfiguration.af.default
        session = Session(
            configuration: config,
            interceptor: Interceptor(
                interceptors: [
                ]
            )
        )
    }

    private var session: Session!

    // MARK: - Default Headers
    private func mergeHeaders(_ headers: HTTPHeaders?) -> HTTPHeaders {
        var defaultHeaders: [String: String] = [
            "deviceType": "2",  // iOS device type
            "Content-Type": "application/json"
        ]

        // Merge with passed headers (passed headers override defaults)
        if let headers = headers {
            for header in headers {
                defaultHeaders[header.name] = header.value
            }
        }

        return HTTPHeaders(defaultHeaders)
    }
    
    func request<T: Decodable>(
        urlConvertible: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil,
        emptyResponseCodes: Set<Int> = [204, 205],
        responseType: T.Type,
        decoder: DataDecoder = JSONDecoder()
    ) async -> DataResponse<T, AFError> {
        let mergedHeaders = mergeHeaders(headers)
        let response = await withCheckedContinuation { cont in
            request(
                urlConvertible: urlConvertible, method: method,
                parameters: parameters, encoding: encoding, headers: mergedHeaders,
                emptyResponseCodes: emptyResponseCodes,
                responseType: responseType,
                decoder: decoder,
                completion: { cont.resume(returning: $0 ) }
            )
        }

        // Check for session expiration
        checkSessionExpiration(response: response)

        return response
    }

    // MARK: - Session Expiration Check
    private func checkSessionExpiration<T: Decodable>(response: DataResponse<T, AFError>) {
        // Try to extract session expiration info from response data
        if let data = response.data {
            do {
                // Decode as a dictionary to check responseCode and errors
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let responseCode = json["responseCode"] as? String,
                   responseCode == "1000",
                   let errors = json["errors"] as? [[String: Any]] {

                    // Check if any error has fieldCode "1004"
                    let hasSessionExpiredError = errors.contains { error in
                        (error["fieldCode"] as? String) == "1004"
                    }

                    if hasSessionExpiredError {
                        print("🚨 [APIClient] Session expired detected!")
                        DispatchQueue.main.async {
                            ViewNavigation.shared.handleSessionExpired()
                        }
                    }
                }
            } catch {
                // Ignore JSON parsing errors - response might not be JSON
            }
        }
    }
    
    func request<T: Decodable>(
        urlConvertible: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil,
        emptyResponseCodes: Set<Int> = [204, 205],
        responseType: T.Type,
        decoder: DataDecoder = JSONDecoder(),
        completion: @escaping (DataResponse<T, AFError>) -> Void
    ) {
        session.request(
            urlConvertible,
            method: method,
            parameters: parameters,
            encoding: encoding,
            headers: headers
        )
//        .validate()
        .responseDecodable(
            of: responseType,
            decoder: decoder,
            emptyResponseCodes: emptyResponseCodes
        ) { response in
            completion(response)
        }
    }
}

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
        return await withCheckedContinuation { cont in
            request(
                urlConvertible: urlConvertible, method: method,
                parameters: parameters, encoding: encoding, headers: mergedHeaders,
                emptyResponseCodes: emptyResponseCodes,
                responseType: responseType,
                decoder: decoder,
                completion: { cont.resume(returning: $0 ) }
            )
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

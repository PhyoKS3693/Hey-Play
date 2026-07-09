//
//  AuthService.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 02/09/26.
//

import Foundation
import Alamofire

// MARK: - Auth Service Protocol
protocol AuthServiceProtocol {
    func validatePhoneBeforeLogin(phoneNo: String) async -> Result<ValidatePhoneData, Error>
    func loginOTPVerify(phoneNo: String, securityKey: String, otpCode: String, otpType: Int, deviceToken: String?) async -> Result<LoginData, Error>
    func loginWithGoogle(googleId: String, email: String, name: String, profileImage: String?, deviceToken: String?) async -> Result<LoginData, Error>
    func loginWithApple(appleId: String, email: String, name: String, deviceToken: String?) async -> Result<LoginData, Error>
    func loginWithLine(lineUserId: String, name: String, deviceToken: String?) async -> Result<LoginData, Error>
    func registerDeviceToken(fcmToken: String, deviceType: String) async -> Result<Void, Error>
}

// MARK: - Auth Service
final class AuthService: AuthServiceProtocol {

    static let shared = AuthService()

    private init() {}

    // MARK: - Validate Phone Before Login
    func validatePhoneBeforeLogin(phoneNo: String) async -> Result<ValidatePhoneData, Error> {
        let request = ValidatePhoneBeforeLoginRequest(phoneNo: phoneNo)

        let response = await APIClient.shared.request(
            urlConvertible: APIEndpoint.validatePhoneBeforeLogin.url,
            method: .post,
            parameters: request.asDictionary(),
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(APIHeaders.authHeaders()),
            responseType: ValidatePhoneResponse.self
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

    // MARK: - Login OTP Verify
    func loginOTPVerify(
        phoneNo: String,
        securityKey: String,
        otpCode: String,
        otpType: Int = 1,
        deviceToken: String? = nil
    ) async -> Result<LoginData, Error> {
        let request = LoginOTPVerifyRequest(
            phoneNo: phoneNo,
            securityKey: securityKey,
            otpCode: otpCode,
            otpType: otpType,
            deviceToken: deviceToken
        )

        let response = await APIClient.shared.request(
            urlConvertible: APIEndpoint.loginOTPVerify.url,
            method: .post,
            parameters: request.asDictionary(),
            encoding: JSONEncoding.default,
            headers: HTTPHeaders([:]),
            responseType: LoginResponse.self
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
                    print("❌ [AuthService] OTP verify failed with fieldCode \(firstError.fieldCode): \(errorMessage)")
                } else {
                    errorMessage = apiResponse.responseMessage
                    print("❌ [AuthService] OTP verify failed: \(errorMessage)")
                }
                return .failure(APIError.serverError(errorMessage))
            }
        case .failure(let error):
            return .failure(error)
        }
    }

    // MARK: - Login With Google
    func loginWithGoogle(
        googleId: String,
        email: String,
        name: String,
        profileImage: String? = nil,
        deviceToken: String? = nil
    ) async -> Result<LoginData, Error> {
        print("📱 [AuthService] Google Login with deviceType: 2 (iOS)")

        let request = GoogleLoginRequest(
            googleId: googleId,
            email: email,
            name: name,
            profileImage: profileImage,
            deviceToken: deviceToken
        )

        let response = await APIClient.shared.request(
            urlConvertible: APIEndpoint.loginWithGoogle.url,
            method: .post,
            parameters: request.asDictionary(),
            encoding: JSONEncoding.default,
            headers: HTTPHeaders([:]),  // deviceType: 2 now added automatically by APIClient
            responseType: LoginResponse.self
        )

        switch response.result {
        case .success(let apiResponse):
            if apiResponse.isSuccess, let data = apiResponse.data {
                print("✅ [AuthService] Google login successful")
                return .success(data)
            } else {
                print("❌ [AuthService] Google login failed: \(apiResponse.responseMessage)")
                return .failure(APIError.serverError(apiResponse.responseMessage))
            }
        case .failure(let error):
            print("❌ [AuthService] Google login network error: \(error.localizedDescription)")
            return .failure(error)
        }
    }

    // MARK: - Login With Apple
    func loginWithApple(
        appleId: String,
        email: String,
        name: String,
        deviceToken: String? = nil
    ) async -> Result<LoginData, Error> {
        let request = AppleLoginRequest(
            appleId: appleId,
            email: email,
            name: name,
            deviceToken: deviceToken,
            deviceType: 2
        )

        let response = await APIClient.shared.request(
            urlConvertible: APIEndpoint.loginWithApple.url,
            method: .post,
            parameters: request.asDictionary(),
            encoding: JSONEncoding.default,
            headers: HTTPHeaders([:]),
            responseType: LoginResponse.self
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

    // MARK: - Login With LINE
    func loginWithLine(
        lineUserId: String,
        name: String,
        deviceToken: String? = nil
    ) async -> Result<LoginData, Error> {
        print("📱 [AuthService] LINE Login")
        print("   LINE User ID: \(lineUserId)")
        print("   Name: \(name)")
        print("   Device Token: \(deviceToken ?? "nil")")
        print("   Device Type: 2 (iOS)")

        let request = LineLoginRequest(
            lineUserId: lineUserId,
            name: name,
            deviceToken: deviceToken,
            deviceType: 2
        )

        print("📤 [AuthService] Request payload: \(request.asDictionary())")

        let response = await APIClient.shared.request(
            urlConvertible: APIEndpoint.loginWithLine.url,
            method: .post,
            parameters: request.asDictionary(),
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(APIHeaders.authHeaders()),
            responseType: LoginResponse.self
        )

        switch response.result {
        case .success(let apiResponse):
            print("📥 [AuthService] Response: \(apiResponse.responseMessage)")
            if apiResponse.isSuccess, let data = apiResponse.data {
                print("✅ [AuthService] LINE login successful")
                return .success(data)
            } else {
                print("❌ [AuthService] LINE login failed: \(apiResponse.responseMessage)")
                if let errors = apiResponse.errors {
                    print("❌ [AuthService] Errors: \(errors)")
                }
                return .failure(APIError.serverError(apiResponse.responseMessage))
            }
        case .failure(let error):
            print("❌ [AuthService] LINE login network error: \(error.localizedDescription)")
            return .failure(error)
        }
    }

    // MARK: - Register Device Token
    func registerDeviceToken(
        fcmToken: String,
        deviceType: String = "2"
    ) async -> Result<Void, Error> {
        guard let customerId = AppDefaultsManager.shared.customerId,
              let sessionId = AppDefaultsManager.shared.sessionId else {
            print("⚠️ [AuthService] Cannot register device token - no customerId or sessionId")
            return .failure(APIError.serverError("Not logged in"))
        }

        print("📤 [AuthService] Registering device token with backend")
        print("   FCM Token: \(fcmToken)")
        print("   Customer ID: \(customerId)")
        print("   Device Type: \(deviceType)")

        let request = RegisterDeviceTokenRequest(
            fcmToken: fcmToken,
            deviceType: deviceType
        )

        let response = await APIClient.shared.request(
            urlConvertible: APIEndpoint.registerDeviceToken.url,
            method: .post,
            parameters: request.asDictionary(),
            encoding: JSONEncoding.default,
            headers: HTTPHeaders(APIHeaders.defaultHeaders(
                customerId: customerId,
                sessionId: sessionId
            )),
            responseType: BaseAPIResponse<EmptyData>.self
        )

        switch response.result {
        case .success(let apiResponse):
            if apiResponse.isSuccess {
                print("✅ [AuthService] Device token registered successfully")
                return .success(())
            } else {
                print("❌ [AuthService] Device token registration failed: \(apiResponse.responseMessage)")
                return .failure(APIError.serverError(apiResponse.responseMessage))
            }
        case .failure(let error):
            print("❌ [AuthService] Device token registration network error: \(error.localizedDescription)")
            return .failure(error)
        }
    }
}

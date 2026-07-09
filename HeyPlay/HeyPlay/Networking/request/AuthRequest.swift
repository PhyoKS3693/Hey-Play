//
//  AuthRequest.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 02/09/26.
//

import Foundation

// MARK: - Validate Phone Before Login Request
struct ValidatePhoneBeforeLoginRequest: Encodable {
    let phoneNo: String
}

// MARK: - Login OTP Verify Request
struct LoginOTPVerifyRequest: Encodable {
    let phoneNo: String
    let securityKey: String
    let otpCode: String
    let otpType: Int
    let deviceToken: String?

    init(
        phoneNo: String,
        securityKey: String,
        otpCode: String,
        otpType: Int = 1,
        deviceToken: String? = nil
    ) {
        self.phoneNo = phoneNo
        self.securityKey = securityKey
        self.otpCode = otpCode
        self.otpType = otpType
        self.deviceToken = (deviceToken == nil || deviceToken?.isEmpty == true) ? nil : deviceToken
    }
}

// MARK: - Google Login Request
struct GoogleLoginRequest: Encodable {
    let googleId: String
    let email: String
    let name: String
    let profileImage: String?
    let deviceToken: String?

    init(
        googleId: String,
        email: String,
        name: String,
        profileImage: String? = nil,
        deviceToken: String? = nil
    ) {
        self.googleId = googleId
        self.email = email
        self.name = name
        self.profileImage = (profileImage == nil || profileImage?.isEmpty == true) ? nil : profileImage
        self.deviceToken = (deviceToken == nil || deviceToken?.isEmpty == true) ? nil : deviceToken
    }
}

// MARK: - Apple Login Request
struct AppleLoginRequest: Encodable {
    let appleId: String
    let email: String
    let name: String
    let deviceToken: String?
    let deviceType: Int

    init(
        appleId: String,
        email: String,
        name: String,
        deviceToken: String? = nil,
        deviceType: Int = 2
    ) {
        self.appleId = appleId
        self.email = email
        self.name = name
        self.deviceToken = (deviceToken == nil || deviceToken?.isEmpty == true) ? nil : deviceToken
        self.deviceType = deviceType
    }
}

// MARK: - LINE Login Request
struct LineLoginRequest: Encodable {
    let lineUserId: String
    let name: String
    let deviceToken: String?
    let deviceType: Int

    init(
        lineUserId: String,
        name: String,
        deviceToken: String? = nil,
        deviceType: Int = 2
    ) {
        self.lineUserId = lineUserId
        self.name = name
        // Don't send empty string, send nil if no token
        self.deviceToken = (deviceToken == nil || deviceToken?.isEmpty == true) ? nil : deviceToken
        self.deviceType = deviceType
    }
}

// MARK: - Register Device Token Request
struct RegisterDeviceTokenRequest: Encodable {
    let fcmToken: String
    let deviceType: String

    init(
        fcmToken: String,
        deviceType: String = "2"
    ) {
        self.fcmToken = fcmToken
        self.deviceType = deviceType
    }
}

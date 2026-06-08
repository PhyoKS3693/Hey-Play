//
//  LoginViewModel.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 02/09/26.
//

import Foundation
import Combine
import UIKit

final class LoginViewModel: ObservableObject {

    // MARK: - Published Properties
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var phoneNumber: String = ""
    @Published var otpCode: String = ""

    // MARK: - OTP Flow Properties
    @Published var securityKey: String?
    @Published var showOTPScreen: Bool = false
    @Published var loginSuccess: Bool = false

    // MARK: - Login Data
    private var loginData: LoginData?

    // MARK: - Validation
    var isPhoneNumberValid: Bool {
        // Phone number validation (7-11 digits)
        let trimmed = phoneNumber.trimmingCharacters(in: .whitespaces)
        return trimmed.count >= 7 && trimmed.count <= 11 && trimmed.allSatisfy { $0.isNumber }
    }

    var isOTPValid: Bool {
        return otpCode.count == 6
    }

    var canProceedToOTP: Bool {
        return isPhoneNumberValid && !isLoading
    }

    var canVerifyOTP: Bool {
        return isOTPValid && securityKey != nil && !isLoading
    }

    // MARK: - Step 1: Validate Phone Before Login
    func validatePhoneNumber() {
        guard canProceedToOTP else {
            errorMessage = "Please enter a valid phone number"
            return
        }

        isLoading = true
        errorMessage = nil

        Task { @MainActor in
            let result = await AuthService.shared.validatePhoneBeforeLogin(phoneNo: phoneNumber)

            isLoading = false

            switch result {
            case .success(let data):
                self.securityKey = data.securityKey
                self.showOTPScreen = true
                print("OTP sent successfully: \(data.otpCode ?? "")")
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }

    // MARK: - Step 2: Verify OTP and Login
    func verifyOTPAndLogin(deviceToken: String? = nil) {
        guard canVerifyOTP else {
            errorMessage = "Please enter valid OTP"
            return
        }

        guard let securityKey = securityKey else {
            errorMessage = "Security key missing"
            return
        }

        isLoading = true
        errorMessage = nil

        Task { @MainActor in
            let result = await AuthService.shared.loginOTPVerify(
                phoneNo: phoneNumber,
                securityKey: securityKey,
                otpCode: otpCode,
                otpType: 1,
                deviceToken: deviceToken
            )

            isLoading = false

            switch result {
            case .success(let data):
                self.loginData = data
                self.saveLoginData(data)
                self.loginSuccess = true
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }

    // MARK: - Google Login
    func loginWithGoogle(googleId: String, email: String, name: String, profileImage: String? = nil, deviceToken: String? = nil) {
        isLoading = true
        errorMessage = nil

        Task { @MainActor in
            let result = await AuthService.shared.loginWithGoogle(
                googleId: googleId,
                email: email,
                name: name,
                profileImage: profileImage,
                deviceToken: deviceToken
            )

            isLoading = false

            switch result {
            case .success(let data):
                self.loginData = data
                self.saveLoginData(data)
                self.loginSuccess = true
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }

    // MARK: - Apple Login
    func loginWithApple(appleId: String, email: String, name: String, deviceToken: String? = nil) {
        isLoading = true
        errorMessage = nil

        Task { @MainActor in
            let result = await AuthService.shared.loginWithApple(
                appleId: appleId,
                email: email,
                name: name,
                deviceToken: deviceToken
            )

            isLoading = false

            switch result {
            case .success(let data):
                self.loginData = data
                self.saveLoginData(data)
                self.loginSuccess = true
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }

    // MARK: - Save Login Data
    private func saveLoginData(_ data: LoginData) {
        // Save customerId (converted from id)
        AppDefaultsManager.shared.customerId = data.customerId

        // Save sessionId
        if let sessionId = data.sessionId {
            AppDefaultsManager.shared.sessionId = sessionId
        }

        // Save phone number (from account field)
        AppDefaultsManager.shared.phoneNumber = data.phoneNo

        // Mark as logged in
        AppDefaultsManager.shared.isLoggedIn = true
    }

    // MARK: - Reset State
    func reset() {
        phoneNumber = ""
        otpCode = ""
        securityKey = nil
        showOTPScreen = false
        loginSuccess = false
        errorMessage = nil
        isLoading = false
    }

    // MARK: - Resend OTP
    func resendOTP() {
        otpCode = ""
        validatePhoneNumber()
    }
}

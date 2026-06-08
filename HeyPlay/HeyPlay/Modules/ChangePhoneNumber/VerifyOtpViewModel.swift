//
//  VerifyOtpViewModel.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 10/30/25.
//

import Foundation
import Combine
import UIKit

final class VerifyOtpViewModel: ObservableObject {

    // MARK: - Published Properties
    @Published var otpCode: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var countdown: Int = 60
    @Published var canResend: Bool = false

    // MARK: - Properties
    var newPhoneNumber: String = ""
    var securityKey: String = ""
    private var timer: Timer?

    // MARK: - Computed Properties
    var maskedPhoneNumber: String {
        guard newPhoneNumber.count >= 3 else { return newPhoneNumber }
        let prefix = String(newPhoneNumber.prefix(2))
        let suffix = String(newPhoneNumber.suffix(3))
        let masked = String(repeating: "*", count: newPhoneNumber.count - 5)
        return prefix + masked + suffix
    }

    // MARK: - Timer Methods
    func startCountdown() {
        countdown = 60
        canResend = false

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            DispatchQueue.main.async {
                if self.countdown > 0 {
                    self.countdown -= 1
                } else {
                    self.canResend = true
                    self.timer?.invalidate()
                    self.timer = nil
                }
            }
        }
    }

    func stopCountdown() {
        timer?.invalidate()
        timer = nil
    }

    deinit {
        stopCountdown()
    }

    // MARK: - Resend OTP
    func resendOTP() async -> Bool {
        guard canResend else { return false }

        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }

        let result = await PhoneChangeService.shared.validateNewPhone(newPhone: newPhoneNumber)

        await MainActor.run {
            isLoading = false

            switch result {
            case .success(let data):
                self.securityKey = data.securityKey ?? ""
                self.errorMessage = nil
                self.startCountdown()
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }

        return errorMessage == nil
    }

    // MARK: - Verify OTP
    func verifyOTP() async -> Bool {
        // Validate OTP
        guard !otpCode.isEmpty else {
            await MainActor.run {
                errorMessage = "Please enter OTP code"
            }
            return false
        }

        guard otpCode.count == 6 else {
            await MainActor.run {
                errorMessage = "OTP must be 6 digits"
            }
            return false
        }

        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }

        let result = await PhoneChangeService.shared.updatePhoneNumber(
            newPhone: newPhoneNumber,
            otp: otpCode,
            securityKey: securityKey
        )

        await MainActor.run {
            isLoading = false

            switch result {
            case .success:
                // Update phone number in AppDefaults
                AppDefaultsManager.shared.phoneNumber = newPhoneNumber
                self.errorMessage = nil
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }

        return errorMessage == nil
    }
}

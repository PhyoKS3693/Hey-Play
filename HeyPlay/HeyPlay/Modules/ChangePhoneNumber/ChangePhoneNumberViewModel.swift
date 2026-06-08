//
//  ChangePhoneNumberViewModel.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 10/24/25.
//

import Foundation
import Combine
import UIKit

final class ChangePhoneNumberViewModel: ObservableObject {

    // MARK: - Published Properties
    @Published var newPhoneNumber: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var securityKey: String?

    // MARK: - Validation
    func validatePhoneNumber() -> Bool {
        let trimmedPhone = newPhoneNumber.trimmingCharacters(in: .whitespaces)

        // Check if empty
        guard !trimmedPhone.isEmpty else {
            errorMessage = "Please enter a phone number"
            return false
        }

        // Check if contains only numbers
        guard trimmedPhone.allSatisfy({ $0.isNumber }) else {
            errorMessage = "Phone number must contain only digits"
            return false
        }

        // Check length range (7-11 digits)
        guard trimmedPhone.count >= 7 && trimmedPhone.count <= 11 else {
            if trimmedPhone.count < 7 {
                errorMessage = "Phone number must be at least 7 digits"
            } else {
                errorMessage = "Phone number cannot exceed 11 digits"
            }
            return false
        }

        errorMessage = nil
        return true
    }

    // MARK: - Validate New Phone
    func validateNewPhone() async -> Bool {
        print("📱 [ChangePhoneNumber] Starting phone validation for: \(newPhoneNumber)")

        guard validatePhoneNumber() else {
            print("❌ [ChangePhoneNumber] Phone validation failed: \(errorMessage ?? "Unknown error")")
            return false
        }

        print("✅ [ChangePhoneNumber] Phone validation passed, calling API...")

        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }

        print("🌐 [ChangePhoneNumber] Making API call to validate phone: \(newPhoneNumber)")
        let result = await PhoneChangeService.shared.validateNewPhone(newPhone: newPhoneNumber)

        await MainActor.run {
            isLoading = false

            switch result {
            case .success(let data):
                print("✅ [ChangePhoneNumber] API Success - SecurityKey: \(data.securityKey ?? "nil")")
                self.securityKey = data.securityKey
                self.errorMessage = nil
            case .failure(let error):
                print("❌ [ChangePhoneNumber] API Failed: \(error.localizedDescription)")
                self.errorMessage = error.localizedDescription
            }
        }

        let success = securityKey != nil
        print("🔑 [ChangePhoneNumber] Validation complete. Success: \(success)")
        return success
    }
}

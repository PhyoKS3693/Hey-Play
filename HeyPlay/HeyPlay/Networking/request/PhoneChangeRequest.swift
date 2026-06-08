//
//  PhoneChangeRequest.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 02/09/26.
//

import Foundation

// MARK: - Validate New Phone Request
struct ValidateNewPhoneRequest: Encodable {
    let newPhone: String
}

// MARK: - Update Phone Number Request
struct UpdatePhoneNumberRequest: Encodable {
    let newPhone: String
    let otp: String
    let securityKey: String
}

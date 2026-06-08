//
//  ValidatePhoneData.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 02/09/26.
//

import Foundation

// MARK: - Validate Phone Response
typealias ValidatePhoneResponse = BaseAPIResponse<ValidatePhoneData>

// MARK: - Validate Phone Data
struct ValidatePhoneData: Decodable {
    let phoneNo: String?
    let otpType: Int?
    let otpTypeDesc: String?
    let isAccountExist: Bool?
    let securityKey: String?
    let otpCode: String? // For development/testing - sometimes returned
    let message: String? // For error messages
}

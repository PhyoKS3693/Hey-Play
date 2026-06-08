//
//  AppDefaultsManager.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 11/18/25.
//

import Foundation

final class AppDefaultsManager {

    static let shared = AppDefaultsManager()
    private init() {}

    private let defaults = UserDefaults.standard

    enum Key: String {
        case language
        case customerId
        case sessionId
        case phoneNumber
        case isLoggedIn
    }

    // MARK: - Auth Properties
    var customerId: String? {
        get { string(for: .customerId) }
        set { if let value = newValue { set(value, for: .customerId) } }
    }

    var sessionId: String? {
        get { string(for: .sessionId) }
        set { if let value = newValue { set(value, for: .sessionId) } }
    }

    var phoneNumber: String? {
        get { string(for: .phoneNumber) }
        set { if let value = newValue { set(value, for: .phoneNumber) } }
    }

    var isLoggedIn: Bool {
        get { bool(for: .isLoggedIn) }
        set { set(newValue, for: .isLoggedIn) }
    }

    // Save Boolean
    func set(_ value: Bool, for key: Key) {
        defaults.set(value, forKey: key.rawValue)
    }

    func bool(for key: Key) -> Bool {
        defaults.bool(forKey: key.rawValue)
    }

    // Save String
    func set(_ value: String, for key: Key) {
        defaults.set(value, forKey: key.rawValue)
    }

    func string(for key: Key) -> String? {
        defaults.string(forKey: key.rawValue)
    }

    // Save Integer
    func set(_ value: Int, for key: Key) {
        defaults.set(value, forKey: key.rawValue)
    }

    func int(for key: Key) -> Int {
        defaults.integer(forKey: key.rawValue)
    }
    
    // Save Double
    func set(_ value: Double, for key: Key) {
        defaults.set(value, forKey: key.rawValue)
    }

    func double(for key: Key) -> Double {
        defaults.double(forKey: key.rawValue)
    }

    // MARK: - Session Management
    var hasValidSession: Bool {
        guard let sessionId = sessionId, !sessionId.isEmpty,
              let customerId = customerId, !customerId.isEmpty else {
            return false
        }
        return true
    }

    func saveLoginCredentials(customerId: String, sessionId: String, phoneNumber: String? = nil) {
        self.customerId = customerId
        self.sessionId = sessionId
        if let phone = phoneNumber {
            self.phoneNumber = phone
        }
        self.isLoggedIn = true
    }

    func logout() {
        defaults.removeObject(forKey: Key.customerId.rawValue)
        defaults.removeObject(forKey: Key.sessionId.rawValue)
        defaults.removeObject(forKey: Key.phoneNumber.rawValue)
        defaults.removeObject(forKey: Key.isLoggedIn.rawValue)
    }
}


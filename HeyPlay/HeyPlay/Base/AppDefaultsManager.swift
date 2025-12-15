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

    func int(for key: Key) -> Double {
        defaults.double(forKey: key.rawValue)
    }
}


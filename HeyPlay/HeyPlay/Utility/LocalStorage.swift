//
//  LocalStorage.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 14/10/2025.
//

import Foundation

struct UserDefaultKey {
    static let Localize = "localize"
}

class LocalStorage {
    static let shared = LocalStorage()
    let defaults = UserDefaults.standard
    
    func setLocalize(_ localized: String) {
        defaults.setValue(localized, forKey: UserDefaultKey.Localize)
    }
    
    func getLocalize() -> String? {
        if let localize = defaults.object(forKey: UserDefaultKey.Localize) {
            return localize as? String
        }
        return nil
    }
    
}

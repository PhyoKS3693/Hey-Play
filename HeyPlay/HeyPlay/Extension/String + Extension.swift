//
//  String + Extension.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 14/10/2025.
//

import Foundation

extension String {
    func localized(lang: String? = nil) ->String {
        
        var path: String
        
        if let lang = lang {
            path = Bundle.main.path(forResource: lang, ofType: "lproj") ?? ""
        } else {
            path = Bundle.main.path(forResource: LocalStorage.shared.getLocalize(), ofType: "lproj") ?? ""
        }
        
        let bundle = Bundle(path: path)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}

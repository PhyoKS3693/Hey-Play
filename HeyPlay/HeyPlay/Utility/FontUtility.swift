//
//  FontUtility.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 14/10/2025.
//

import Foundation
import UIKit
import SwiftUI

enum AppFont: String {
    case black = "Poppins-Black"
    case blackItalic = "Poppins-BlackItalic"
    case bold = "Poppins-Bold"
    case boldItalic = "Poppins-BoldItalic"
    case extraBold = "Poppins-ExtraBold"
    case extraBoldItalic = "Poppins-ExtraBoldItalic"
    case italic = "Poppins-Italic"
    case light = "Poppins-Light"
    case lightItalic = "Poppins-LightItalic"
    case medium = "Poppins-Medium"
    case mediumItalic = "Poppins-MediumItalic"
    case regular = "Poppins-Regular"
    case thin = "Poppins-Thin"
    case thinItalic = "Poppins-ThinItalic"
    case semiBold = "Poppins-SemiBold"
    case semiBoldItalic = "Poppins-SemiBoldItalic"
}

struct FontUtility {
    
    static func font(_ font: AppFont, size: CGFloat) -> UIFont {
        return UIFont(name: font.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }

    static func system(size: CGFloat, weight: UIFont.Weight = .regular) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: weight)
    }

    static func dynamicFont(_ font: AppFont, textStyle: UIFont.TextStyle) -> UIFont {
        let font = UIFont(name: font.rawValue, size: UIFont.preferredFont(forTextStyle: textStyle).pointSize)
        return UIFontMetrics(forTextStyle: textStyle).scaledFont(for: font ?? UIFont.systemFont(ofSize: 17))
    }

    
    static func largeTitle() -> UIFont {
        return font(.medium, size: 17)
    }
    
    static func normal() -> UIFont {
        return font(.medium, size: 13)
    }
    
    static func medium() -> UIFont {
        return font(.medium, size: 17)
    }

    
    static func largeTitleFont() -> Font {
        return Font(largeTitle())
    }
    
    static func normalFont() -> Font {
        return Font(normal())
    }
    
    static func mediumFont() -> Font {
        return Font(medium())
    }
}

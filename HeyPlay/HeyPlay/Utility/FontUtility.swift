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
    
    
    //MARK: - FontStyleGuideLine
    static func largeTitle() -> Font {
        return Font(font(.semiBold, size: 23))
    }
    
    static func heading1() -> Font {
        return Font(font(.semiBold, size: 22))
    }
    
    static func heading2() -> Font {
        return Font(font(.semiBold, size: 20))
    }
    
    static func headline1() -> Font {
        return Font(font(.semiBold, size: 17))
    }
    
    static func headline2() -> Font {
        return Font(font(.semiBold, size: 17))
    }
    
    static func subHeadline() -> Font {
        return Font(font(.medium, size: 13))
    }
    
    static func body1() -> Font {
        return Font(font(.regular, size: 13))
    }
    
    static func body2() -> Font {
        return Font(font(.regular, size: 12))
    }
    
    static func caption() -> Font {
        return Font(font(.regular, size: 11))
    }
    
    static func smallText1() -> Font {
        return Font(font(.regular, size: 10))
    }
    
    static func smallText2() -> Font {
        return Font(font(.regular, size: 10))
    }
    
    static func smallText3() -> Font {
        return Font(font(.regular, size: 8))
    }
    
    static func smallText4() -> Font {
        return Font(font(.regular, size: 10))
    }
    
    
    //MARK: - UIFont
    static func largeTitle() -> UIFont {
        return font(.semiBold, size: 23)
    }
    
    static func heading1() -> UIFont {
        return font(.semiBold, size: 22)
    }
    
    static func heading2() -> UIFont {
        return font(.semiBold, size: 20)
    }
    
    static func headline1() -> UIFont {
        return font(.semiBold, size: 17)
    }
    
    static func headline2() -> UIFont {
        return font(.semiBold, size: 17)
    }
    
    static func subHeadline() -> UIFont {
        return font(.medium, size: 13)
    }
    
    static func body1() -> UIFont {
        return font(.regular, size: 13)
    }
    
    static func body2() -> UIFont {
        return font(.regular, size: 12)
    }
    
    static func caption() -> UIFont {
        return font(.regular, size: 11)
    }
    
    static func smallText1() -> UIFont {
        return font(.regular, size: 10)
    }
    
    static func smallText2() -> UIFont {
        return font(.regular, size: 10)
    }
    
    static func smallText3() -> UIFont {
        return font(.regular, size: 8)
    }
    
    static func smallText4() -> UIFont {
        return font(.regular, size: 10)
    }
    
}

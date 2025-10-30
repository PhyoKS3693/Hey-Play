//
//  RoundedButtonView.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 14/10/2025.
//

import Foundation
import SwiftUI

enum RoundedButtonViewType {
    case normal
    case apple
    case google
    case facebook
    case line
    case verify
    
    func getTitle() -> String {
        switch self {
        case .normal:
            return "Continue".localized()
        case .apple:
            return "Continue with Apple".localized()
        case .google:
            return "Continue with Google".localized()
        case .facebook:
            return "Continue with Facebook".localized()
        case .line:
            return "Continue with Line".localized()
        case .verify:
            return "Verify".localized()
        }
    }
    
    func getImage() -> Image? {
        switch self {
        case .apple:
            return Image("ic.apple")
        case .google:
            return Image("ic.google")
        case .facebook:
            return Image("ic.facebook")
        case .line:
            return Image("ic.line")
        default:
            return nil
        }
    }
    
    func getColor() -> Color {
        switch self {
        case .normal , .verify:
            return .primaryBg
        default:
            return .grey
        }
    }
}
struct RoundedButtonView :  View {
    var buttonType : RoundedButtonViewType
    @Binding var isTap : Bool
    var body: some View {
        
        Button(action: {
            print("Button tapped")
            isTap = true
        }) {
            HStack(spacing: 8) {
                if let img = buttonType.getImage() {
                    img
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                
                Text(buttonType.getTitle())
                    .font(FontUtility.body1())
                
                if buttonType != .normal && buttonType != .verify {
                    Spacer()
                    Image("ic.forwardArrow")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
            }
            .padding()
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, maxHeight: 40)
        .background(buttonType.getColor())
        .cornerRadius(20)
        .padding(.horizontal, 20)
    }
}

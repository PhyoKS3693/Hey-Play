//
//  OTPTextView.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 14/10/2025.
//

import Foundation
import SwiftUI

struct OTPTextView: View {
    @Binding var otpText: String
    let maxDigits = 6

    var body: some View {
        ZStack {
            HStack(spacing: 12) {
                ForEach(0..<maxDigits, id: \.self) { index in
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.gray, lineWidth: 1)
                            .frame(width: 48, height: 60)

                        // Show entered digits or empty
                        Text(getDigit(at: index))
                            .font(.system(size: 24, weight: .bold, design: .monospaced))
                            .foregroundColor(.white)
                    }
                }
            }
            .padding()

            // Hidden TextField for keyboard input
            TextField("", text: $otpText)
                .keyboardType(.numberPad)
                .textContentType(.oneTimeCode)
                .foregroundColor(.clear)
                .accentColor(.clear)
                .disableAutocorrection(true)
                .onChange(of: otpText) { newVal in
                    // Limit to maxDigits
                    if newVal.count > maxDigits {
                        otpText = String(newVal.prefix(maxDigits))
                    }
                }

        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.becomeFirstResponder), to: nil, from: nil, for: nil)
        }
    }

    private func getDigit(at index: Int) -> String {
        if index < otpText.count {
            let stringIndex = otpText.index(otpText.startIndex, offsetBy: index)
            return String(otpText[stringIndex])
        }
        return ""
    }
}

#Preview {
    OTPTextView(otpText: .constant("123456"))
}

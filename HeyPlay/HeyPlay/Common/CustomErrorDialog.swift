//
//  CustomErrorDialog.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 02/09/26.
//

import Foundation
import SwiftUI

// MARK: - API Error Model
struct APIErrorModel: Identifiable {
    let id = UUID()
    let title: String
    let message: String

    init(title: String = "Error", message: String) {
        self.title = title
        self.message = message
    }
}

// MARK: - Custom Error Dialog
struct CustomErrorDialog: View {
    @Binding var isShow: Bool
    var title: String
    var message: String
    var onConfirm: (() -> Void)?

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                // Close button
                HStack {
                    Spacer()
                    Button {
                        isShow = false
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 30, height: 30)
                    }
                }

                // Error icon
                Image("ic.otpError")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)

                // Title
                Text(title)
                    .foregroundColor(.white)
                    .font(FontUtility.heading2())
                    .fontWeight(.semibold)

                // Message
                Text(message)
                    .foregroundColor(.white)
                    .font(FontUtility.body1())
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 10)

                // OK Button
                Button {
                    isShow = false
                    onConfirm?()
                } label: {
                    Text("OK")
                        .font(FontUtility.body1())
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color("pink_Color"))
                .cornerRadius(25)
            }
            .padding(.all, 20)
        }
        .frame(maxWidth: 360)
        .background(Color(red: 28/255, green: 28/255, blue: 30/255))
        .cornerRadius(30)
    }
}

// MARK: - Error Dialog Modifier
struct ErrorDialogModifier: ViewModifier {
    @Binding var error: APIErrorModel?

    func body(content: Content) -> some View {
        ZStack {
            content

            if let error = error {
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        // Prevent dismiss on background tap
                    }

                CustomErrorDialog(
                    isShow: Binding(
                        get: { self.error != nil },
                        set: { if !$0 { self.error = nil } }
                    ),
                    title: error.title,
                    message: error.message
                )
            }
        }
    }
}

// MARK: - View Extension
extension View {
    func errorDialog(_ error: Binding<APIErrorModel?>) -> some View {
        self.modifier(ErrorDialogModifier(error: error))
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        Color.black.ignoresSafeArea()

        CustomErrorDialog(
            isShow: .constant(true),
            title: "Error",
            message: "Invalid OTP code. Please try again."
        )
    }
}

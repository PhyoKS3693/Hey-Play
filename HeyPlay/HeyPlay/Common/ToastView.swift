//
//  ToastView.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 02/09/26.
//

import SwiftUI

// MARK: - Toast Model
struct ToastModel: Equatable {
    let message: String
    let iconName: String

    static func == (lhs: ToastModel, rhs: ToastModel) -> Bool {
        return lhs.message == rhs.message && lhs.iconName == rhs.iconName
    }
}

// MARK: - Toast View
struct ToastView: View {
    let message: String
    let iconName: String

    var body: some View {
        HStack(spacing: 12) {
            Image(iconName)
                .resizable()
                .renderingMode(.original)
                .frame(width: 20, height: 20)

            Text(message)
                .font(FontUtility.body1())
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)

            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color.darkGrey.opacity(0.95))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
    }
}

// MARK: - Toast Modifier
struct ToastModifier: ViewModifier {
    @Binding var toast: ToastModel?

    func body(content: Content) -> some View {
        ZStack {
            content

            if let toast = toast {
                VStack {
                    Spacer()

                    ToastView(message: toast.message, iconName: toast.iconName)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 100)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .animation(.spring(response: 0.4, dampingFraction: 0.8), value: toast)

                }
                .zIndex(1)
            }
        }
    }
}

// MARK: - View Extension
extension View {
    func toast(_ toast: Binding<ToastModel?>) -> some View {
        self.modifier(ToastModifier(toast: toast))
    }
}

// MARK: - Preview
#Preview {
    ZStack {
        Color.black.ignoresSafeArea()

        VStack(spacing: 20) {
            ToastView(
                message: "Added to favorite list successfully.",
                iconName: "ic.splash.logo"
            )

            ToastView(
                message: "Remove from favorite list successfully.",
                iconName: "ic.splash.logo"
            )

            ToastView(
                message: "Added to watch list successfully.",
                iconName: "ic.splash.logo"
            )

            ToastView(
                message: "Remove from watch list successfully.",
                iconName: "ic.splash.logo"
            )
        }
        .padding()
    }
}

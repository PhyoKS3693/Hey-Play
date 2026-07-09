//
//  LoginRequiredDialog.swift
//  HeyPlay
//
//  Created by Claude on 18/06/2026.
//

import SwiftUI

@available(iOS 14.0, *)
struct LoginRequiredDialog: View {

    @Binding var isPresented: Bool
    let onLogin: () -> Void
    var onCancel: (() -> Void)? = nil

    var body: some View {
        ZStack {
            // Dimmed background - covers entire screen
            Color.black.opacity(0.6)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    isPresented = false
                    onCancel?()
                }

            // Use existing CustomDialogView - centered in screen
            CustomDialogView(
                iconName: "ic_session_expired",
                title: "Login Required",
                message: "Please login to access this content",
                showCloseButton: true,
                closeAction: {
                    isPresented = false
                    onCancel?()
                },
                primaryButtonTitle: "Login",
                primaryAction: {
                    isPresented = false
                    onLogin()
                },
                primaryButtonDisabled: false,
                secondaryButtonTitle: "Cancel",
                secondaryAction: {
                    isPresented = false
                    onCancel?()
                }
            ) {
                EmptyView()
            }
        }
    }
}

// MARK: - Preview
#if DEBUG
@available(iOS 14.0, *)
struct LoginRequiredDialog_Previews: PreviewProvider {
    static var previews: some View {
        LoginRequiredDialog(
            isPresented: .constant(true),
            onLogin: {
                print("Login tapped")
            },
            onCancel: {
                print("Cancel tapped")
            }
        )
    }
}
#endif

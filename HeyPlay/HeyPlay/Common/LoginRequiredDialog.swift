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

    var body: some View {
        ZStack {
            // Dimmed background
            Color.black.opacity(0.6)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    isPresented = false
                }

            // Dialog content
            VStack(spacing: 0) {
                // Icon
                Image("ic_session_expired")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.white)
                    .frame(width: 60, height: 60)
                    .padding(.top, 30)

                // Title
                Text("Login Required")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 20)

                // Message
                Text("Please login to access this content")
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .padding(.top, 12)

                // Buttons
                HStack(spacing: 12) {
                    // Cancel button
                    Button(action: {
                        isPresented = false
                    }) {
                        Text("Cancel")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(8)
                    }

                    // Login button
                    Button(action: {
                        isPresented = false
                        onLogin()
                    }) {
                        Text("Login")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 48)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color(red: 0.8, green: 0.2, blue: 0.4), Color(red: 0.6, green: 0.1, blue: 0.3)]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(8)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 24)
            }
            .frame(width: 320)
            .background(Color(red: 0.15, green: 0.15, blue: 0.15))
            .cornerRadius(16)
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
            }
        )
    }
}
#endif

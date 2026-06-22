//
//  UpdateDialogView.swift
//  HeyPlay
//
//  Created by Claude on 18/06/2026.
//

import SwiftUI

// MARK: - Force Update Dialog
@available(iOS 14.0, *)
struct ForceUpdateDialog: View {
    let title: String
    let message: String
    let onUpdate: () -> Void

    var body: some View {
        ZStack {
            // Dimmed background (non-dismissible)
            Color.black.opacity(0.8)
                .edgesIgnoringSafeArea(.all)

            // Dialog content
            VStack(spacing: 0) {
                // Custom Icon
                Image("ic_force_update")
                    .resizable()
                    .renderingMode(.original)
                    .frame(width: 100, height: 100)
                    .padding(.top, 30)

                // Title
                Text(title)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 10)

                // Message
                Text(message)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .lineSpacing(4)

                // Update button (only button - no dismiss)
                Button(action: {
                    onUpdate()
                }) {
                    Text("Update Now")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color("pink_Color"))
                        .cornerRadius(12)
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

// MARK: - Normal Update Dialog
@available(iOS 14.0, *)
struct NormalUpdateDialog: View {
    @Binding var isPresented: Bool
    let title: String
    let message: String
    let onUpdate: () -> Void

    var body: some View {
        ZStack {
            // Dimmed background (dismissible)
            Color.black.opacity(0.6)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    isPresented = false
                }

            // Dialog content
            VStack(spacing: 0) {
                // Custom Icon
                Image("ic_force_update")
                    .resizable()
                    .renderingMode(.original)
                    .frame(width: 100, height: 100)
                    .padding(.top, 30)

                // Title
                Text(title)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 10)

                // Message
                Text(message)
                    .font(.system(size: 14))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    .lineSpacing(4)

                // Buttons
                HStack(spacing: 12) {
                    // Later button
                    Button(action: {
                        isPresented = false
                    }) {
                        Text("Later")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(12)
                    }

                    // Update button
                    Button(action: {
                        isPresented = false
                        onUpdate()
                    }) {
                        Text("Update Now")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color("pink_Color"))
                            .cornerRadius(12)
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
struct UpdateDialogView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForceUpdateDialog(
                title: "Force Update",
                message: "This is a force update alert! A new version is available with exciting features!",
                onUpdate: {
                    print("Update tapped")
                }
            )
            .previewDisplayName("Force Update")

            NormalUpdateDialog(
                isPresented: .constant(true),
                title: "Normal Update",
                message: "This is a normal update alert! A new version is available with exciting features!",
                onUpdate: {
                    print("Update tapped")
                }
            )
            .previewDisplayName("Normal Update")
        }
    }
}
#endif

//
//  UpgradeVIPDialog.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 05/26/26.
//

import SwiftUI

@available(iOS 14.0, *)
struct UpgradeVIPDialog: View {
    @Binding var isPresented: Bool
    var onUpgrade: (() -> Void)?

    var body: some View {
        ZStack {
            // Background overlay
            Color.black.opacity(0.7)
                .ignoresSafeArea()

            // Dialog content
            VStack(spacing: 30) {
                // Close button
                HStack {
                    Spacer()
                    Button(action: {
                        isPresented = false
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)

                // Icon
                ZStack {
                    Circle()
                        .fill(Color("primaryBgColor"))
                        .frame(width: 100, height: 100)

                    Image(systemName: "play.fill")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)

                    Image(systemName: "checkmark")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .offset(x: 25, y: -20)
                }

                // Title
                Text("Upgrade VIP")
                    .font(FontUtility.heading1())
                    .foregroundColor(.white)

                // Message
                Text("Are you sure you want to upgrade to VIP?")
                    .font(FontUtility.body1())
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)

                // Buttons
                HStack(spacing: 15) {
                    // Cancel button
                    Button(action: {
                        isPresented = false
                    }) {
                        Text("Cancel")
                            .font(FontUtility.heading2())
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color.black.opacity(0.8))
                            .cornerRadius(25)
                    }

                    // Yes button
                    Button(action: {
                        isPresented = false
                        onUpgrade?()
                    }) {
                        Text("Yes")
                            .font(FontUtility.heading2())
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color("primaryBgColor"))
                            .cornerRadius(25)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
            .frame(maxWidth: 350)
            .background(Color(red: 0.2, green: 0.2, blue: 0.2))
            .cornerRadius(20)
        }
    }
}

#if DEBUG
@available(iOS 14.0, *)
struct UpgradeVIPDialog_Previews: PreviewProvider {
    static var previews: some View {
        UpgradeVIPDialog(isPresented: .constant(true))
    }
}
#endif

//
//  SessionExpiredDialog.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 06/15/26.
//

import Foundation
import SwiftUI

@available(iOS 14.0, *)
struct SessionExpiredDialog: View {
    @Binding var isPresented: Bool
    var onOkTapped: (() -> Void)?

    var body: some View {
        ZStack {
            // Background overlay
            Color.black.opacity(0.7)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Image("ic_session_expired")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .padding(.top, 20)

                Text("Session Expired")
                    .font(FontUtility.heading2())
                    .fontWeight(.semibold)
                    .foregroundColor(.white)

                Text("You will be redirected to the Login page.")
                    .font(FontUtility.body1())
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)

                Button {
                    print("✅ [SessionExpired] OK tapped, clearing session and redirecting to login")
                    isPresented = false
                    onOkTapped?()
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
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .frame(maxWidth: 360)
            .background(Color(red: 28/255, green: 28/255, blue: 30/255))
            .cornerRadius(30)
            .padding(.horizontal, 20)
        }
    }
}

#if DEBUG
@available(iOS 14.0, *)
struct SessionExpiredDialog_Previews: PreviewProvider {
    static var previews: some View {
        SessionExpiredDialog(isPresented: .constant(true), onOkTapped: {
            print("OK tapped")
        })
    }
}
#endif

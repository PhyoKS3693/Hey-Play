//
//  ChangePhoneNumberScreen.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 10/24/25.
//

import SwiftUI

struct ChangePhoneNumberScreen: View {
    var host: HostController?

    var didTapBack: (() -> Void)?
    var didTapContinue: (() -> Void)?

    @ObservedObject private var viewModel: ChangePhoneNumberViewModel

    init(_ viewModel: ChangePhoneNumberViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 20){
                navView()

                Image("change_phone_image")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 228, height: 234)

                Text("Phone Number")
                    .font(FontUtility.subHeadline())
                    .foregroundColor(Color.white)
                    .padding(.horizontal, 4)

                Text("Your new phone number")
                    .font(FontUtility.body1())
                    .foregroundColor(Color.white)
                    .padding(.horizontal, 4)

            VStack(alignment: .leading) {
                Text("Phone Number")
                    .font(FontUtility.caption())
                    .foregroundColor(Color.white)

                TextField("", text: $viewModel.newPhoneNumber)
                    .padding(.horizontal, 20)
                    .frame(height: 40)
                    .font(FontUtility.body1())
                    .keyboardType(.numberPad)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white, lineWidth: 1)
                    )
                    .foregroundColor(.white)
                    .onChange(of: viewModel.newPhoneNumber) { newValue in
                        // Limit to 11 characters
                        if newValue.count > 11 {
                            viewModel.newPhoneNumber = String(newValue.prefix(11))
                        }
                    }

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(FontUtility.body2())
                        .foregroundColor(Color.red)
                        .padding(.top, 4)
                }
            }
            .padding(.horizontal, 30)

                Button {
                    print("🔘 [ChangePhoneNumberScreen] Continue button action triggered")
                    hideKeyboard()
                    print("⌨️ [ChangePhoneNumberScreen] Keyboard hidden, calling didTapContinue")
                    didTapContinue?()
                    print("📞 [ChangePhoneNumberScreen] didTapContinue called")
                } label: {
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Continue")
                            .font(FontUtility.body1())
                            .foregroundColor(Color.white)
                    }
                }
                .frame(maxWidth: .infinity, minHeight: 50)
                .background(Color("pink_Color"))
                .cornerRadius(20)
                .padding(.horizontal, 30)
                .disabled(viewModel.isLoading)

                Spacer()
            }
            .background(
                Color.black
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        hideKeyboard()
                    }
            )

            // Loading Overlay
            if viewModel.isLoading {
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
            }
        }
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    private func navView() -> some View {
        ZStack (alignment: .leading){
            Button{
                didTapBack?()
            } label: {
                Image("ic.backBtn")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 32, height: 32)
            }
            
            HStack {
                
                
                Spacer()
                
                Text("Change Phone Number")
                    .font(FontUtility.heading1())
                    .foregroundColor(Color("white_color"))
                
                Spacer()
            }
        }
        .padding(10)
        
    }
}

#Preview {
    ChangePhoneNumberScreen(.init())
}

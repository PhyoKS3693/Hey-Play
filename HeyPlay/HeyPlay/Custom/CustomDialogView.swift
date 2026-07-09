//
//  CustomDialogView.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 10/29/25.
//

import SwiftUI

struct DialogOverlay<DialogContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let dialogContent: DialogContent

    func body(content: Content) -> some View {
        ZStack {
            content
                .blur(radius: isPresented ? 2 : 0)
                .disabled(isPresented)

            if isPresented {
                Color.black.opacity(0.5)

                dialogContent
                    .transition(.scale.combined(with: .opacity))
                    .zIndex(1)
            }
        }
        .animation(.easeInOut, value: isPresented)
    }
}

extension View {
    func customDialog<DialogContent: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder dialogContent: () -> DialogContent
    ) -> some View {
        self.modifier(DialogOverlay(isPresented: isPresented, dialogContent: dialogContent()))
    }
}

struct CustomDialogView<Content: View>: View {
    let iconName: String
    let title: String
    let message: String?
    let showCloseButton: Bool
    let closeAction: (() -> Void)?
    let content: Content
    let primaryButtonTitle: String?
    let primaryAction: (() -> Void)?
    let primaryButtonDisabled: Bool
    let secondaryButtonTitle: String?
    let secondaryAction: (() -> Void)?

    init(
        iconName: String,
        title: String,
        message: String? = nil,
        showCloseButton: Bool = true,
        closeAction: (() -> Void)? = nil,
        primaryButtonTitle: String? = nil,
        primaryAction: (() -> Void)? = nil,
        primaryButtonDisabled: Bool = false,
        secondaryButtonTitle: String? = nil,
        secondaryAction: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.iconName = iconName
        self.title = title
        self.message = message
        self.showCloseButton = showCloseButton
        self.closeAction = closeAction
        self.primaryButtonTitle = primaryButtonTitle
        self.primaryAction = primaryAction
        self.primaryButtonDisabled = primaryButtonDisabled
        self.secondaryButtonTitle = secondaryButtonTitle
        self.secondaryAction = secondaryAction
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 16){
            if showCloseButton {
                HStack {
                    Spacer()
                    Button(action: {
                        closeAction?()
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white.opacity(0.7))
                            .padding(8)
                    }
                }
            }
            
            Image(iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .padding(.top, showCloseButton ? 0 : 20)
            
            Text(title)
                .font(FontUtility.headline2())
                .foregroundColor(Color.white)
            
            if let message = message {
                Text(message)
                    .font(FontUtility.subHeadline())
                    .foregroundColor(Color.white)
            }
            
            content
            
            HStack(spacing: 16) {
                if let secondaryButtonTitle = secondaryButtonTitle {
                    Button {
                        secondaryAction?()
                    } label: {
                        Text(secondaryButtonTitle)
                            .font(FontUtility.body1())
                            .foregroundColor(Color.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                    }
                    .background(Color.black)
                    .cornerRadius(28)
                }

                if let primaryButtonTitle = primaryButtonTitle {

                    Button {
                        primaryAction?()
                    } label: {
                        Text(primaryButtonTitle)
                            .font(FontUtility.body1())
                            .foregroundColor(Color.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                    }
                    .background(primaryButtonDisabled ? Color.gray : Color("primaryBgColor"))
                    .cornerRadius(28)
                    .disabled(primaryButtonDisabled)
                }
            }
        }
        .padding()
        .background(Color.grey)
        .cornerRadius(30)
        .padding(.horizontal, 24)
    }
}

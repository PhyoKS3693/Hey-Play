//
//  BuyPlanViewScreen.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 11/8/25.
//

import SwiftUI

struct BuyPlanViewScreen: View {
    var host: HostController?

    var didTapBack: (() -> Void)?
    var didCompletePurchase: ((_ paymentUrl: String?) -> Void)?

    @ObservedObject private var viewModel: BuyPlanViewModel

    init(_ viewModel: BuyPlanViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack (alignment: .leading) {
            navView()
            
            ZStack {
                Image("package_bg")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 60)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(viewModel.packageName)
                            .font(FontUtility.subHeadline())
                            .foregroundColor(Color("white_color"))
                        
                        Text(viewModel.packageType)
                            .font(FontUtility.smallText1())
                            .foregroundColor(Color("white_color"))
                    }
                    .padding(10)
                    
                    Spacer()
                                        
                    Text(viewModel.chargedAmount)
                        .font(FontUtility.subHeadline())
                        .foregroundColor(Color("white_color"))
                        .padding(10)
                }
            }
            .padding(10)
            
            Text("Phone Number")
                .font(FontUtility.caption())
                .foregroundColor(Color("white_color"))
                .padding(.top, 10)

            HStack {
                Text(viewModel.phoneNumber)
                    .font(FontUtility.body1())
                    .foregroundColor(.white)
                    .padding(.leading, 20)

                Spacer()

                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .padding(.trailing, 20)
            }
            .frame(height: 40)
            .background(Color.black)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white, lineWidth: 1)
            )
            
            Text("Payment Method")
                .font(FontUtility.heading2())
                .foregroundColor(Color("white_color"))
                .padding(10)
            
            HStack(spacing: 10) {
                Image(systemName: "creditcard.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                    .foregroundColor(.white)

                Text(viewModel.paymentMethodName)
                    .font(FontUtility.body2())
                    .foregroundColor(Color("white_color"))

                Spacer()

            }
            .frame(maxWidth: .infinity)
            .padding(14)
            .background (
                RoundedRectangle(cornerRadius: 19)
                    .fill(Color("darkGrey_Color"))
            )
            
            Spacer()

            Button {
                Task {
                    await viewModel.buyPackage()
                }
            } label: {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Continue")
                        .font(FontUtility.body1())
                        .foregroundColor(Color("white_color"))
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color("pink_Color"))
            .cornerRadius(20)
            .disabled(viewModel.isLoading)
        }
        .padding(.horizontal, 16)
        .onChange(of: viewModel.purchaseSuccess) { success in
            if success {
                didCompletePurchase?(viewModel.paymentUrl)
            }
        }
        .alert(isPresented: Binding<Bool>(
            get: { viewModel.errorMessage != nil },
            set: { if !$0 { viewModel.errorMessage = nil } }
        )) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.errorMessage ?? ""),
                dismissButton: .default(Text("OK"))
            )
        }
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
                
                Text("Plan")
                    .font(FontUtility.heading1())
                    .foregroundColor(Color("white_color"))
                
                Spacer()
            }
        }
        .padding(10)
    }
}

#Preview {
    BuyPlanViewScreen(.init())
}

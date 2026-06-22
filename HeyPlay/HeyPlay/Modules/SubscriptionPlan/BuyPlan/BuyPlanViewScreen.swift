//
//  BuyPlanViewScreen.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 11/8/25.
//

import SwiftUI
import Kingfisher

struct BuyPlanViewScreen: View {
    var host: HostController?

    var didTapBack: (() -> Void)?
    var didCompletePurchase: ((_ paymentUrl: String?) -> Void)?

    @ObservedObject private var viewModel: BuyPlanViewModel

    init(_ viewModel: BuyPlanViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        VStack(spacing: 0) {
            navView()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
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
            
            Text("Choose Payment Method")
                .font(FontUtility.heading2())
                .foregroundColor(Color("white_color"))
                .padding(.vertical, 10)

            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
            } else if viewModel.paymentMethods.isEmpty {
                Text("No payment methods available")
                    .font(FontUtility.body2())
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
            } else {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewModel.paymentMethods) { paymentMethod in
                        PaymentMethodCard(
                            paymentMethod: paymentMethod,
                            isSelected: viewModel.selectedPaymentMethod?.id == paymentMethod.id,
                            onTap: {
                                viewModel.selectedPaymentMethod = paymentMethod
                            }
                        )
                    }
                }
            }

            Spacer()
                .frame(minHeight: 20)
                }
                .padding(.horizontal, 16)
            }

            // Continue Button (Fixed at bottom)
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
            .background(
                viewModel.selectedPaymentMethod != nil ?
                    Color("pink_Color") : Color.gray.opacity(0.5)
            )
            .cornerRadius(20)
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
            .disabled(viewModel.isLoading || viewModel.selectedPaymentMethod == nil)
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .onAppear {
            if viewModel.paymentMethods.isEmpty {
                Task {
                    await viewModel.fetchPaymentMethods()
                }
            }
        }
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

// MARK: - Payment Method Card
struct PaymentMethodCard: View {
    let paymentMethod: PaymentMethod
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: {
            print("💳 [PaymentCard] Tapped: \(paymentMethod.displayName)")
            onTap()
        }) {
            VStack(spacing: 10) {
                Spacer()

                // Payment Method Image
                if let imageURL = paymentMethod.fullImageURL, let url = URL(string: imageURL) {
                    KFImage(url)
                        .placeholder {
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 80, height: 80)
                                .cornerRadius(12)
                        }
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .cornerRadius(12)
                } else {
                    Image(systemName: "creditcard.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.white.opacity(0.7))
                }

                // Payment Method Name
                Text(paymentMethod.displayName)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity)

                Spacer()
            }
            .padding(12)
            .frame(maxWidth: .infinity)
            .frame(height: 160)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(red: 45/255, green: 45/255, blue: 47/255))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        isSelected ? Color("pink_Color") : Color.clear,
                        lineWidth: 2
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
        .onAppear {
            print("💳 [PaymentCard] Displaying: \(paymentMethod.displayName)")
        }
    }
}

#Preview {
    BuyPlanViewScreen(.init())
}

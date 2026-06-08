//
//  PlanViewScreen.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 11/6/25.
//

import SwiftUI

struct PlanViewScreen: View {
    var host: HostController?
    
    var didTapBack: (() -> Void)?
    
    @ObservedObject private var viewModel: PlanViewModel
    
    var didSelectPaymentMethod: ((_ paymentMethodId: Int,_ paymentMethodName: String) -> Void)?
    
    init(_ viewModel: PlanViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(alignment: .leading){
            navView()

            // Selected Package Display
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

            Text("Choose Payment Method")
                .font(FontUtility.heading2())
                .foregroundColor(Color("white_color"))
                .padding(10)

            if viewModel.isLoading {
                Spacer()
                HStack {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                    Spacer()
                }
                Spacer()
            } else if viewModel.paymentMethods.isEmpty {
                Spacer()
                HStack {
                    Spacer()
                    Text("No payment methods available")
                        .foregroundColor(.gray)
                        .font(FontUtility.body1())
                    Spacer()
                }
                Spacer()
            } else {
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        ForEach(viewModel.paymentMethods) { paymentMethod in
                            renderPaymentMethod(paymentMethod)
                        }
                    }
                    .padding(.horizontal, 10)
                }
            }

            Spacer()
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .onAppear {
            if viewModel.paymentMethods.isEmpty {
                viewModel.fetchPaymentMethods()
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
    
    private func renderPaymentMethod(_ paymentMethod: PaymentMethod) -> some View {
        Button {
            didSelectPaymentMethod?(
                paymentMethod.id,
                paymentMethod.name ?? ""
            )
        } label: {
            if #available(iOS 15.0, *) {
                AsyncImage(url: URL(string: paymentMethod.fullImageURL ?? "")) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 76, height: 76)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 76, height: 76)
                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image(systemName: "creditcard")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white)
            }
        }
        .frame(width: 111, height: 111)
        .background (
            RoundedRectangle(cornerRadius: 15)
                .fill(Color("darkGrey_Color"))
        )
    }
}

#Preview {
    PlanViewScreen(.init())
}

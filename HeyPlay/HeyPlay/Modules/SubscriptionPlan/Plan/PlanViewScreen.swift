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
    
    var didSelectPaymentMethod: ((_ name: String,_ type: String,_ amount: String,_ icon: String) -> Void)?
    
    init(_ viewModel: PlanViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(alignment: .leading){
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
            
            Text("Choose Payment Method")
                .font(FontUtility.heading2())
                .foregroundColor(Color("white_color"))
                .padding(10)
            
            HStack {
                renderPaymentMethod("ATOM")
                
                renderPaymentMethod("Ooredoo")
                
                renderPaymentMethod("MPT")
            }
            
            HStack {
                renderPaymentMethod("MyTel")
                
                renderPaymentMethod("KBZ_Pay")
                
                renderPaymentMethod("Wave_Pay")
            }
            
            Spacer()
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
    
    private func renderPaymentMethod(_ paymentMethod: String) -> some View {
        Button {
            didSelectPaymentMethod?(viewModel.packageName, viewModel.packageType, viewModel.chargedAmount, paymentMethod)
        } label: {
            Image(paymentMethod)
                .frame(width: 76, height: 76)
        }
        .frame(width: 111, height: 111)
        .padding()
        .background (
            RoundedRectangle(cornerRadius: 15)
                .fill(Color("darkGrey_Color"))
        )
    }
}

#Preview {
    PlanViewScreen(.init())
}

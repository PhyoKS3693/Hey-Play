//
//  BuyPlanViewScreen.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 11/8/25.
//

import SwiftUI

struct BuyPlanViewScreen: View {
    var host: HostController?
    
    @State var phone: String = ""
    
    @ObservedObject private var viewModel: BuyPlanViewModel
    
    init(_ viewModel: BuyPlanViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack (alignment: .leading) {
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
            
            TextField("", text: $phone)
                .padding(.horizontal, 20)
                .frame(height: 40)
                .background(Color.black)
                .font(FontUtility.body1())
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white, lineWidth: 1)
                )
                .foregroundColor(.white)
            
            Text("Payment Method")
                .font(FontUtility.heading2())
                .foregroundColor(Color("white_color"))
                .padding(10)
            
            HStack(spacing: 10) {
                Image(viewModel.paymentIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                
                Text("ATOM")
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
                
            } label: {
                Text("Continue")
                    .font(FontUtility.body1())
                    .foregroundColor(Color("white_color"))
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color("pink_Color"))
            .cornerRadius(20)
        }
    }
}

#Preview {
    BuyPlanViewScreen(.init())
}

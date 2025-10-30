//
//  RedemptionCodeScreen.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 10/24/25.
//

import SwiftUI

struct RedemptionCodeScreen: View {
    var host: HostController?
    
    var didTapOkay: (() -> Void)?
    
    @ObservedObject private var viewModel: RedemptionCodeViewModel
    
    init(_ viewModel: RedemptionCodeViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 20){
            Image("redeem_success")
                .resizable()
                .scaledToFit()
                .frame(width: 220, height: 220)
            
            Text("Successful")
                .font(FontUtility.headline2())
                .foregroundColor(Color("white_color"))
                .padding(.horizontal, 4)
            
            Text("Your redemption code is success")
                .font(FontUtility.body1())
                .foregroundColor(Color("white_color"))
                .padding(.horizontal, 4)
            
            Button {
                didTapOkay?()
            } label: {
                Text("Okay")
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
    RedemptionCodeScreen(.init())
}

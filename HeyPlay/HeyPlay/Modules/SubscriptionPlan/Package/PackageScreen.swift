//
//  PackageScreen.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 11/6/25.
//

import SwiftUI

struct PackageScreen: View {
    var host: HostController?
    
    var didSelectPaymentPlan: ((_ name: String,_ type: String,_ amount: String) -> Void)?
    
    @ObservedObject private var viewModel: PackageViewModel
    
    init(_ viewModel: PackageViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(spacing: 12) {
            Text("The best plan for you")
                .font(FontUtility.heading1())
                .foregroundColor(Color("white_color"))
            
            Text("Choose the payment Plan that suit you")
                .font(FontUtility.subHeadline())
                .foregroundColor(Color("white_color"))
            
            ScrollView(showsIndicators: false){
                VStack {
                    ForEach(viewModel.packagePlans){ package in
                        renderPackage(package)
                    }
                }
            }
            
            Button {
                didSelectPaymentPlan?(viewModel.selectedPackageName, viewModel.selectedPackageType, viewModel.selectedPackageAmount)
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
    
    private func renderPackage(_ package: PackagePlan) -> some View {
        Button {
            viewModel.selectedPackageName = package.packageName
            viewModel.selectedPackageType = package.packageBilledType
            viewModel.selectedPackageAmount = package.packageChargedAmount
        } label: {
            HStack(spacing: 10) {
                radio(selected: package.packageName == viewModel.selectedPackageName)
                    .frame(width: 20, height: 20)
                
                Image(package.packageIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 26, height: 26)
                
                VStack(alignment: .leading) {
                    Text(package.packageName)
                        .font(FontUtility.subHeadline())
                        .foregroundColor(Color("white_color"))
                    
                    Text(package.packageBilledType)
                        .font(FontUtility.smallText1())
                        .foregroundColor(Color("white_color"))
                }
                
                Spacer()
                
                Text(package.packageChargedAmount)
                    .font(FontUtility.subHeadline())
                    .foregroundColor(Color("white_color"))
            }
        }
        .padding(12)
        .background (
            RoundedRectangle(cornerRadius: 15)
                .fill(Color("darkGrey_Color"))
        )
    }
    
    private func radio(selected: Bool) -> some View {
        ZStack {
            Circle()
                .stroke( selected ? Color("pink_Color") : Color("lightGrey_Color"), lineWidth: 2 )
                
            if selected {
                Circle()
                    .fill(Color("pink_Color"))
                    .padding(4)
            }
        }
    }
}

#Preview {
    PackageScreen(.init())
}

//
//  SubscriptionScreen.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 10/24/25.
//

import SwiftUI

struct SubscriptionScreen: View {
    var host: HostController?
    
    var didTapUpgradeToVIP: (() -> Void)?
    var didTapBack: (() -> Void)?
    
    @ObservedObject private var viewModel: SubscriptionViewModel
    
    init(_ viewModel: SubscriptionViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                navView()

                if viewModel.isLoading {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                    Spacer()
                } else if viewModel.subscriptionPlans.isEmpty {
                    Spacer()
                    Text("No subscription plans available")
                        .foregroundColor(.gray)
                        .font(FontUtility.body1())
                    Spacer()
                } else {
                    ScrollView {
                        ForEach(viewModel.subscriptionPlans) { subscription in
                            renderPlan(subscription)
                        }
                    }

                    Button {
                        didTapUpgradeToVIP?()
                    } label: {
                        Text("Upgrade to VIP")
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
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .onAppear {
            if viewModel.subscriptionPlans.isEmpty {
                viewModel.fetchSubscriptionPlanTypes()
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
                
                Text("Subscription Plan")
                    .font(FontUtility.heading1())
                    .foregroundColor(Color("white_color"))
                
                Spacer()
            }
        }
        .padding(10)
    }
    
    private func renderPlan(_ plan: SubscriptionPlan) -> some View {
        VStack(spacing: 8) {
            ZStack {
                // Use computed property instead of string comparison
                Image(plan.isFree ? "free_plan_bg" : "vip_plan_bg")
                    .resizable()
                    .scaledToFill()
                    .padding(.horizontal, 10)
                    .padding(.top, 10)
                    .cornerRadius(15)
                    .frame(height: 87)


                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        // Display API name
                        Text(plan.title)
                            .font(FontUtility.heading1())
                            .foregroundColor(Color("white_color"))

                        // Display API description as badge
                        Text(plan.badge)
                            .font(FontUtility.smallText1())
                            .foregroundColor(Color("white_color"))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background (
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color("white_color").opacity(0.2))
                            )
                    }

                    Spacer()

                    // Use computed property for icon selection
                    Image(plan.isFree ? "ic_free" : "ic_vip")
                        .resizable()
                        .frame(width: 40, height: 40)
                }
                .padding(20)
            }
            
            Text(plan.planDescription)
                .font(FontUtility.body2())
                .padding(8)
                .foregroundColor(Color("white_color"))
            
            VStack(spacing: 4) {
                ForEach(plan.features) { feature in
                    renderFeature(feature.featureName, feature.isAvailable)
                }
            }
            .padding(.horizontal, 8)
            
        }
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .background (
            RoundedRectangle(cornerRadius: 15)
                .fill(Color("darkGrey_Color"))
        )
    }
    
    private func renderFeature(_ title: String,_ isAvailable: Bool) -> some View {
        HStack(spacing: 10) {
            Image(isAvailable ? "feature_is_available" : "feature_is_not_available")
                .frame(width: 18, height: 18)
            
            Text(title)
                .font(FontUtility.body2())
                .foregroundColor(Color("white_color"))
            
            Spacer()
                
        }
        .frame(maxWidth: .infinity)
        .padding(14)
        .background (
            RoundedRectangle(cornerRadius: 19)
                .fill(Color("grey_Color"))
        )
    }
}

#Preview {
    SubscriptionScreen(.init())
}

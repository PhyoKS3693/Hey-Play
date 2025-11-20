//
//  VIPHistoryScreen.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 10/24/25.
//

import SwiftUI

struct VIPHistoryScreen: View {
    var host: HostController?
    
    var didTapBack: (() -> Void)?
    
    @ObservedObject private var viewModel: VIPHistoryViewModel
    
    init(_ viewModel: VIPHistoryViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            navView()
            
            HStack {
                VStack(alignment: .leading) {
                    Text("Start Date")
                        .font(FontUtility.caption())
                        .foregroundColor(Color.white)
                    
                    Button {
                        print("start tap")
                    } label: {
                        Text("2025-02-07")
                            .font(FontUtility.body1())
                            .foregroundColor(Color.white)
                    }
                    .padding(10)
                    .frame(width: 140, height: 40)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                }
                
                VStack(alignment: .leading) {
                    Text("End Date")
                        .font(FontUtility.caption())
                        .foregroundColor(Color.white)
                    
                    Button {
                        print("end tap")
                    } label: {
                        Text("2025-02-07")
                            .font(FontUtility.body1())
                            .foregroundColor(Color.white)
                    }
                    .frame(width: 140, height: 40)
                    .frame(height: 40)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                }
                
                Spacer()
                
                Button {
                    print("tap")
                } label: {
                    Image("btn_search")
                        .frame(width: 20, height: 20)
                }
                .padding(.horizontal, 10)
            }
            
            ScrollView {
                renderTransactionHistory("Daily", "300", "hnCnOALmtn24", "ATOM", "1 Day", 1)
                
                renderTransactionHistory("Monthly", "300", "hnCnOALmtn24", "KBZ Pay", "1 Month", 2)
                
                renderTransactionHistory("Daily", "300", "hnCnOALmtn24", "ATOM", "1 Day", 3)
            }
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
                
                Text("VIP History")
                    .font(FontUtility.heading1())
                    .foregroundColor(Color("white_color"))
                
                Spacer()
            }
        }
        .padding(10)
    }
    
    private func renderTransactionHistory(_ type: String,_ amount: String,_ paymentId: String,_ paymentMethod: String,_ duration: String,_ status: Int) -> some View {
        VStack(alignment: .leading) {
            ZStack {
                Image(status == 1 ? "bg_active_transaction" : "bg_failed_and_expired_transaction")
                    .resizable()
                    .scaledToFill()
                    .frame(width: .infinity,  height: 40)
                    
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(type)
                            .font(FontUtility.headline2())
                            .foregroundColor(Color.white)
                            .padding(.vertical, 4)
                        
                        Text("Billed \(type)")
                            .font(FontUtility.smallText1())
                            .foregroundColor(Color.white)
                            .padding(.vertical, 2)
                    }
                    .padding(.horizontal, 10)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("\(amount) MMK")
                            .font(FontUtility.headline2())
                            .foregroundColor(Color.white)
                            .padding(.horizontal, 4)
                
                        
                        if status == 1 {
                            Text("Active")
                                .font(FontUtility.smallText3())
                                .foregroundColor(Color.black)
                                .padding(.horizontal, 4)
                                .padding(.vertical, 2)
                                .background(
                                    RoundedRectangle(cornerRadius: 13)
                                        .fill(Color.neon)
                                )
                            
                        } else if status == 2 {
                            Text("Failed")
                                .font(FontUtility.smallText3())
                                .foregroundColor(Color.black)
                                .padding(.horizontal, 4)
                                .padding(.vertical, 2)
                                .background(
                                    RoundedRectangle(cornerRadius: 13)
                                        .fill(Color.yellow)
                                )
                        }else {
                            Text("Expired")
                                .font(FontUtility.smallText3())
                                .foregroundColor(Color.black)
                                .padding(.horizontal, 4)
                                .padding(.vertical, 2)
                                .background(
                                    RoundedRectangle(cornerRadius: 13)
                                        .fill(Color.lightGrey)
                                )
                        }
                    }
                    .padding(.horizontal, 10)
                }
            }
            
            HStack {
                Text("Payment ID")
                    .font(FontUtility.body2())
                    .foregroundColor(Color.white)
                    .padding(.vertical, 4)
                
                Spacer()
                
                Text(paymentId)
                    .font(FontUtility.body2())
                    .foregroundColor(Color.white)
                    .padding(.vertical, 4)
            }
            .padding(.horizontal, 10)
            
            Divider()
            
            HStack {
                Text("Gateway")
                    .font(FontUtility.body2())
                    .foregroundColor(Color.white)
                    .padding(.vertical, 4)
                
                Spacer()
                
                Text(paymentMethod)
                    .font(FontUtility.body2())
                    .foregroundColor(Color.white)
                    .padding(.vertical, 4)
            }
            .padding(.horizontal, 10)
            
            Divider()
            
            HStack {
                Text("Duration")
                    .font(FontUtility.body2())
                    .foregroundColor(Color.white)
                    .padding(.vertical, 8)
                
                Spacer()
                
                Text(duration)
                    .font(FontUtility.body2())
                    .foregroundColor(Color.white)
                    .padding(.vertical, 8)
            }
            .padding(.horizontal, 10)
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.darkGrey)
        )
        .padding(.horizontal, 12)
        .padding(.top, 6)
        .padding(.bottom, 6)
    }
}

#Preview {
    VIPHistoryScreen(.init())
}

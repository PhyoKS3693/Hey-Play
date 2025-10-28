//
//  VIPHistoryScreen.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 10/24/25.
//

import SwiftUI

struct VIPHistoryScreen: View {
    var host: HostController?
    
    @ObservedObject private var viewModel: VIPHistoryViewModel
    
    init(_ viewModel: VIPHistoryViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Start Date")
                        .font(FontUtility.regularFont(size: 11))
                        .foregroundColor(Color("white_color"))
                    
                    Button {
                        print("start tap")
                    } label: {
                        Text("2025-02-07")
                            .font(FontUtility.regularFont(size: 13))
                            .foregroundColor(Color("white_color"))
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
                        .font(FontUtility.regularFont(size: 11))
                        .foregroundColor(Color("white_color"))
                    
                    Button {
                        print("end tap")
                    } label: {
                        Text("2025-02-07")
                            .font(FontUtility.regularFont(size: 13))
                            .foregroundColor(Color("white_color"))
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
    
    private func renderTransactionHistory(_ type: String,_ amount: String,_ paymentId: String,_ paymentMethod: String,_ duration: String,_ status: Int) -> some View {
        VStack(alignment: .leading) {
            ZStack {
                Image(status == 1 ? "bg_active_transaction" : "bg_failed_and_expired_transaction")
                    .scaledToFill()
                    .frame(height: 40)
                    
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(type)
                            .font(FontUtility.mediumFont())
                            .foregroundColor(Color("white_color"))
                            .padding(.vertical, 4)
                        
                        Text("Billed \(type)")
                            .font(FontUtility.regularFont(size: 10))
                            .foregroundColor(Color("white_color"))
                            .padding(.vertical, 2)
                    }
                    .padding(.horizontal, 10)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("\(amount) MMK")
                            .font(FontUtility.mediumFont())
                            .foregroundColor(Color("white_color"))
                            .padding(.horizontal, 4)
                
                        
                        if status == 1 {
                            Text("Active")
                                .font(FontUtility.regularFont(size: 8))
                                .foregroundColor(Color("black_Color"))
                                .padding(.horizontal, 4)
                                .padding(.vertical, 2)
                                .background(
                                    RoundedRectangle(cornerRadius: 13)
                                        .fill(Color("neon_Color"))
                                )
                            
                        } else if status == 2 {
                            Text("Failed")
                                .font(FontUtility.regularFont(size: 8))
                                .foregroundColor(Color("black_Color"))
                                .padding(.horizontal, 4)
                                .padding(.vertical, 2)
                                .background(
                                    RoundedRectangle(cornerRadius: 13)
                                        .fill(Color("yellow_color"))
                                )
                        }else {
                            Text("Expired")
                                .font(FontUtility.regularFont(size: 8))
                                .foregroundColor(Color("black_Color"))
                                .padding(.horizontal, 4)
                                .padding(.vertical, 2)
                                .background(
                                    RoundedRectangle(cornerRadius: 13)
                                        .fill(Color("lightGrey_Color"))
                                )
                        }
                    }
                    .padding(.horizontal, 10)
                }
            }
            
            HStack {
                Text("Payment ID")
                    .font(FontUtility.regularFont(size: 12))
                    .foregroundColor(Color("white_color"))
                    .padding(.vertical, 4)
                
                Spacer()
                
                Text(paymentId)
                    .font(FontUtility.regularFont(size: 12))
                    .foregroundColor(Color("white_color"))
                    .padding(.vertical, 4)
            }
            .padding(.horizontal, 10)
            
            Divider()
            
            HStack {
                Text("Gateway")
                    .font(FontUtility.regularFont(size: 12))
                    .foregroundColor(Color("white_color"))
                    .padding(.vertical, 4)
                
                Spacer()
                
                Text(paymentMethod)
                    .font(FontUtility.regularFont(size: 12))
                    .foregroundColor(Color("white_color"))
                    .padding(.vertical, 4)
            }
            .padding(.horizontal, 10)
            
            Divider()
            
            HStack {
                Text("Duration")
                    .font(FontUtility.regularFont(size: 12))
                    .foregroundColor(Color("white_color"))
                    .padding(.vertical, 8)
                
                Spacer()
                
                Text(duration)
                    .font(FontUtility.regularFont(size: 12))
                    .foregroundColor(Color("white_color"))
                    .padding(.vertical, 8)
            }
            .padding(.horizontal, 10)
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color("darkGrey_Color"))
        )
        .padding(.horizontal, 12)
        .padding(.top, 6)
        .padding(.bottom, 6)
    }
}

#Preview {
    VIPHistoryScreen(.init())
}

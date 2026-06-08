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

            // Date Filter Section
            HStack {
                VStack(alignment: .leading) {
                    Text("Start Date")
                        .font(FontUtility.caption())
                        .foregroundColor(Color.white)

                    Button {
                        viewModel.showStartDatePicker.toggle()
                    } label: {
                        Text(viewModel.startDateString)
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
                        viewModel.showEndDatePicker.toggle()
                    } label: {
                        Text(viewModel.endDateString)
                            .font(FontUtility.body1())
                            .foregroundColor(Color.white)
                    }
                    .frame(width: 140, height: 40)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.gray, lineWidth: 1)
                    )
                }

                Spacer()

                Button {
                    viewModel.search()
                } label: {
                    Image("btn_search")
                        .frame(width: 20, height: 20)
                }
                .padding(.horizontal, 10)
            }

            // Loading Indicator
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .padding()
                Spacer()
            }
            // History List
            else if viewModel.hasHistories {
                ScrollView {
                    ForEach(viewModel.histories) { history in
                        renderTransactionHistory(history)
                    }
                }
            }
            // Empty State
            else {
                VStack {
                    Spacer()
                    Text("No transaction history")
                        .font(FontUtility.body1())
                        .foregroundColor(Color.gray)
                    Spacer()
                }
            }
        }
        .sheet(isPresented: $viewModel.showStartDatePicker) {
            VStack(spacing: 20) {
                Text("Select Start Date")
                    .font(FontUtility.heading2())
                    .foregroundColor(.white)
                    .padding(.top, 20)

                DatePicker(
                    "Start Date",
                    selection: $viewModel.startDate,
                    in: ...viewModel.maxDate, // Maximum is today
                    displayedComponents: .date
                )
                .datePickerStyle(GraphicalDatePickerStyle())
                .colorScheme(.dark) // Force dark color scheme for visibility
                .accentColor(Color("primaryBgColor")) // Selected date color
                .padding()
                .background(Color(red: 0.15, green: 0.15, blue: 0.15)) // Dark grey background
                .cornerRadius(10)
                .onChange(of: viewModel.startDate) { newValue in
                    viewModel.selectStartDate(newValue)
                }

                Button(action: {
                    viewModel.showStartDatePicker = false
                }) {
                    Text("Done")
                        .font(FontUtility.body1())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color("primaryBgColor"))
                        .cornerRadius(10)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .padding(.horizontal, 20)
            .background(Color.black)
        }
        .sheet(isPresented: $viewModel.showEndDatePicker) {
            VStack(spacing: 20) {
                Text("Select End Date")
                    .font(FontUtility.heading2())
                    .foregroundColor(.white)
                    .padding(.top, 20)

                DatePicker(
                    "End Date",
                    selection: $viewModel.endDate,
                    in: viewModel.endDateMinimum...viewModel.maxDate, // Between start date and today
                    displayedComponents: .date
                )
                .datePickerStyle(GraphicalDatePickerStyle())
                .colorScheme(.dark) // Force dark color scheme for visibility
                .accentColor(Color("primaryBgColor")) // Selected date color
                .padding()
                .background(Color(red: 0.15, green: 0.15, blue: 0.15)) // Dark grey background
                .cornerRadius(10)
                .onChange(of: viewModel.endDate) { newValue in
                    viewModel.selectEndDate(newValue)
                }

                Button(action: {
                    viewModel.showEndDatePicker = false
                }) {
                    Text("Done")
                        .font(FontUtility.body1())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color("primaryBgColor"))
                        .cornerRadius(10)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .padding(.horizontal, 20)
            .background(Color.black)
        }
        .onAppear {
            Task {
                await viewModel.fetchHistory()
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
                
                Text("VIP History")
                    .font(FontUtility.heading1())
                    .foregroundColor(Color("white_color"))
                
                Spacer()
            }
        }
        .padding(10)
    }
    
    private func renderTransactionHistory(_ history: PackageHistory) -> some View {
        let status = history.paymentStatus ?? 0

        return VStack(alignment: .leading) {
            // Header with package info and status
            ZStack {
                Image(status == 1 ? "bg_active_transaction" : "bg_failed_and_expired_transaction")
                    .resizable()
                    .scaledToFill()
                    .frame(height: 60)

                HStack {
                    VStack(alignment: .leading) {
                        Text(history.packageName ?? "Unknown Package")
                            .font(FontUtility.headline2())
                            .foregroundColor(Color.white)
                            .padding(.vertical, 4)

                        Text(history.displayTime)
                            .font(FontUtility.smallText1())
                            .foregroundColor(Color.white)
                            .padding(.vertical, 2)
                    }
                    .padding(.horizontal, 10)

                    Spacer()

                    VStack(alignment: .trailing) {
                        Text(history.displayPrice)
                            .font(FontUtility.headline2())
                            .foregroundColor(Color.white)
                            .padding(.horizontal, 4)

                        // Status badge
                        Text(history.displayStatus)
                            .font(FontUtility.smallText3())
                            .foregroundColor(Color.black)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 2)
                            .background(
                                RoundedRectangle(cornerRadius: 13)
                                    .fill(getStatusColor(status))
                            )
                    }
                    .padding(.horizontal, 10)
                }
            }

            // Transaction ID
            HStack {
                Text("Transaction ID")
                    .font(FontUtility.body2())
                    .foregroundColor(Color.white)
                    .padding(.vertical, 4)

                Spacer()

                Text(history.transactionId)
                    .font(FontUtility.body2())
                    .foregroundColor(Color.white)
                    .padding(.vertical, 4)
            }
            .padding(.horizontal, 10)

            Divider()

            // Payment Method
            HStack {
                Text("Gateway")
                    .font(FontUtility.body2())
                    .foregroundColor(Color.white)
                    .padding(.vertical, 4)

                Spacer()

                Text(history.displayPaymentMethod)
                    .font(FontUtility.body2())
                    .foregroundColor(Color.white)
                    .padding(.vertical, 4)
            }
            .padding(.horizontal, 10)

            Divider()

            // Duration
            HStack {
                Text("Duration")
                    .font(FontUtility.body2())
                    .foregroundColor(Color.white)
                    .padding(.vertical, 8)

                Spacer()

                Text(history.displayDuration)
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

    // Helper to get status color
    private func getStatusColor(_ status: Int) -> Color {
        switch status {
        case 1: return Color.neon // Pending
        case 2: return Color.green // Success
        case 3: return Color.red // Failed
        default: return Color.lightGrey
        }
    }
}

#Preview {
    VIPHistoryScreen(.init())
}

//
//  SearchView.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 24/10/2025.
//

import Foundation
import SwiftUI

struct SearchView : View {
    @StateObject private var viewModel = SearchViewModel()

    var body: some View {
        if #available(iOS 15.0, *) {
            VStack {
                Spacer()
                    .frame(height: 50)
                SearchTopView()
                SearchTextView(viewModel: viewModel)
                
                if viewModel.isLoading {
                    // Loading state
                    Spacer()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5)
                    Spacer()
                } else if viewModel.isShowingResults {
                    // Search results
                    SearchResultsView(viewModel: viewModel)
                } else {
                    // Preload view (recent/trending searches)
                    RecentView(viewModel: viewModel)
                    MostSearchView(viewModel: viewModel)
                }
                
                Spacer()
            }
            .padding()
            .background(Color.black)
            .edgesIgnoringSafeArea(.all)
            .task {
                await viewModel.loadSearchPreload()
            }
            .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
                Button("OK") {
                    viewModel.errorMessage = nil
                }
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        } else {
            // Fallback on earlier versions
        }
    }
}

struct SearchTopView : View {
    var body: some View {
        HStack {
            Text("Search")
                .foregroundColor(Color.white)
                .font(FontUtility.heading2())
            Spacer()
            Button(action: {
                // Dismiss the entire navigation controller
                if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let rootViewController = windowScene.windows.first?.rootViewController {
                    var topController = rootViewController
                    while let presented = topController.presentedViewController {
                        topController = presented
                    }
                    topController.dismiss(animated: true)
                }
            }) {
                Image("ic.cross")
                    .resizable()
                    .frame(width: 30 , height: 30)
            }
        }
        .padding()

    }
}

struct SearchTextView : View {
    @ObservedObject var viewModel: SearchViewModel

    var body: some View {
        HStack {
            ZStack(alignment: .leading) {
                if viewModel.searchKey.isEmpty {
                    Text("Search by keywords".localized())
                        .foregroundColor(.white.opacity(0.5))
                        .padding(.leading, 20)
                }

                if #available(iOS 15.0, *) {
                    TextField("", text: $viewModel.searchKey)
                        .padding(.horizontal, 20)
                        .frame(height: 40)
                        .background(Color.black)
                        .font(FontUtility.caption())
                        .foregroundColor(.white)
                        .onSubmit {
                            Task {
                                await viewModel.performSearch()
                            }
                        }
                } else {
                    // Fallback on earlier versions
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.white, lineWidth: 1)
            )

            if !viewModel.searchKey.isEmpty {
                Button(action: {
                    viewModel.clearSearch()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white)
                }
            }

            Button(action: {
                Task {
                    await viewModel.performSearch()
                }
            }) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
            }
        }
    }
}

#Preview {
    SearchView()
}

//
//  MovieSeriesTabView.swift
//  HeyPlay
//
//  Created by Aye Myat Min on 05/05/26.
//

import Foundation
import SwiftUI

struct MovieSeriesTabView: View {
    @StateObject private var viewModel = SearchViewModel()
    @ObservedObject private var errorManager = ErrorManager.shared
    @State private var selectedTab: MovieTypeFilter
    @State private var selectedOrigin: MovieOriginFilter = .all

    init(initialTab: MovieTypeFilter = .movie) {
        _selectedTab = State(initialValue: initialTab)
    }

    var body: some View {
        VStack(spacing: 0) {
            // Top Navigation Bar
            TopNavigationBar()

            // Tab Selector (Movie / Series)
            TabSelector(selectedTab: $selectedTab)
                .onChange(of: selectedTab) { newTab in
                    Task {
                        await viewModel.browseContent(
                            movieType: newTab.rawValue,
                            movieOrigin: selectedOrigin.rawValue
                        )
                    }
                }

            // Origin Filter (Optional)
            if selectedOrigin != .all {
                OriginFilterBar(selectedOrigin: $selectedOrigin)
                    .onChange(of: selectedOrigin) { newOrigin in
                        Task {
                            await viewModel.browseContent(
                                movieType: selectedTab.rawValue,
                                movieOrigin: newOrigin.rawValue
                            )
                        }
                    }
            }

            // Content List
            if viewModel.isLoading && viewModel.currentPage == 1 {
                // Initial loading
                Spacer()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
                Spacer()
            } else if viewModel.shouldShowEmptyState {
                // Empty state
                EmptyContentView()
            } else {
                // Content grid
                ContentGridView(viewModel: viewModel)
            }
        }
        .background(Color.black)
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            // Load initial content (Movies by default)
            Task {
                await viewModel.browseContent(
                    movieType: selectedTab.rawValue,
                    movieOrigin: selectedOrigin.rawValue
                )
            }
        }
        .errorDialog($errorManager.currentError)
        .onChange(of: viewModel.errorMessage) { error in
            if let errorMsg = error {
                ErrorManager.shared.showError(title: "Error", message: errorMsg)
                viewModel.errorMessage = nil
            }
        }
    }
}

// MARK: - Top Navigation Bar
struct TopNavigationBar: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.white)
                    .font(.system(size: 20))
            }

            Spacer()

            Text("Browse")
                .foregroundColor(.white)
                .font(.system(size: 20, weight: .semibold))

            Spacer()

            // Placeholder for balance
            Color.clear
                .frame(width: 30)
        }
        .padding()
        .frame(height: 60)
        .background(Color.black)
    }
}

// MARK: - Tab Selector
struct TabSelector: View {
    @Binding var selectedTab: MovieTypeFilter

    var body: some View {
        HStack(spacing: 0) {
            ForEach([MovieTypeFilter.movie, MovieTypeFilter.series], id: \.self) { tab in
                Button(action: {
                    selectedTab = tab
                }) {
                    VStack(spacing: 8) {
                        Text(tab.displayName)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(selectedTab == tab ? .white : .gray)

                        if selectedTab == tab {
                            Rectangle()
                                .fill(Color.orange)
                                .frame(height: 3)
                        } else {
                            Rectangle()
                                .fill(Color.clear)
                                .frame(height: 3)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .background(Color.black)
    }
}

// MARK: - Origin Filter Bar
struct OriginFilterBar: View {
    @Binding var selectedOrigin: MovieOriginFilter

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(MovieOriginFilter.allCases, id: \.self) { origin in
                    Button(action: {
                        selectedOrigin = origin
                    }) {
                        Text(origin.displayName)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(selectedOrigin == origin ? .white : .gray)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                selectedOrigin == origin
                                    ? Color.orange
                                    : Color.gray.opacity(0.3)
                            )
                            .cornerRadius(20)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        .background(Color.black)
    }
}

// MARK: - Content Grid View
struct ContentGridView: View {
    @ObservedObject var viewModel: SearchViewModel

    let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.searchResults) { movie in
                    MovieGridCard(movie: movie)
                        .onAppear {
                            // Load more when reaching last item
                            if movie.id == viewModel.searchResults.last?.id {
                                Task {
                                    await viewModel.loadMoreBrowse()
                                }
                            }
                        }
                }

                if viewModel.isLoadingMore {
                    HStack {
                        Spacer()
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .padding()
                        Spacer()
                    }
                    .gridCellColumns(3)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 16)
        }
    }
}

// MARK: - Movie Grid Card
struct MovieGridCard: View {
    let movie: Movie

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Movie Poster
            if #available(iOS 15.0, *) {
                AsyncImage(url: URL(string: movie.fullImageURL)) { phase in
                    switch phase {
                    case .empty:
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .aspectRatio(2/3, contentMode: .fit)
                            .cornerRadius(8)
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .aspectRatio(2/3, contentMode: .fit)
                            .cornerRadius(8)
                            .clipped()
                    case .failure:
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .aspectRatio(2/3, contentMode: .fit)
                            .cornerRadius(8)
                            .overlay(
                                Image(systemName: "photo")
                                    .foregroundColor(.gray)
                            )
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                // Fallback for earlier versions
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .aspectRatio(2/3, contentMode: .fit)
                    .cornerRadius(8)
            }

            // Subscription Badge (matching list style)
            HStack {
                HStack(spacing: 3) {
                    Image(movie.isFree ? "ic-free" : "ic-vip")
                        .resizable()
                        .frame(width: 16, height: 16)

                    Text(movie.subscriptionTypeDesc ?? "")
                        .font(FontUtility.smallText4())
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 5)
                .padding(.vertical, 3)
                .frame(width: 38, height: 22)
                .background(
                    ZStack {
                        BlurView(style: .systemUltraThinMaterialDark)
                        Color.white.opacity(0.04)
                    }
                )
                .cornerRadius(11)

                Spacer()
            }

            // Movie Name
            Text(movie.name ?? "")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(.white)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
        }
    }
}

// MARK: - Empty Content View
struct EmptyContentView: View {
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "film")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            Text("No content available")
                .foregroundColor(.gray)
                .font(.system(size: 18, weight: .medium))
                .padding(.top, 16)
            Spacer()
        }
    }
}

#Preview {
    MovieSeriesTabView()
}

//
//  SearchResultsView.swift
//  HeyPlay
//
//  Created by Aye Myat Min on 05/05/26.
//

import Foundation
import SwiftUI

struct SearchResultsView: View {
    @ObservedObject var viewModel: SearchViewModel

    let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        if viewModel.shouldShowEmptyState {
            // Empty state
            VStack {
                Spacer()
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 50))
                    .foregroundColor(.gray)
                Text("No results found")
                    .foregroundColor(.gray)
                    .font(.system(size: 18, weight: .medium))
                    .padding(.top, 16)
                Text("Try searching with different keywords")
                    .foregroundColor(.gray.opacity(0.7))
                    .font(.system(size: 14))
                    .padding(.top, 4)
                Spacer()
            }
        } else {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(viewModel.searchResults) { movie in
                        SearchMovieGridCard(movie: movie)
                            .onTapGesture {
                                let detailType: DetailType = movie.isSeries ? .series : .movie
                                ViewNavigation.shared.showMovieDetail(detailType: detailType, movieId: movie.id)
                            }
                            .onAppear {
                                // Load more when reaching last item
                                if movie.id == viewModel.searchResults.last?.id {
                                    Task {
                                        await viewModel.loadMore()
                                    }
                                }
                            }
                    }

                    if viewModel.isLoadingMore {
                        if #available(iOS 16.0, *) {
                            HStack {
                                Spacer()
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .padding()
                                Spacer()
                            }
                            .gridCellColumns(3)
                        } else {
                            // Fallback on earlier versions
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
            }
        }
    }
}

// MARK: - Search Movie Grid Card (Grid Layout)
struct SearchMovieGridCard: View {
    let movie: Movie

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Movie Poster with Badge Overlay
            ZStack(alignment: .bottomLeading) {
                if #available(iOS 15.0, *) {
                    AsyncImage(url: URL(string: movie.fullImageURL)) { phase in
                        switch phase {
                        case .empty:
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .aspectRatio(2/3, contentMode: .fit)
                                .cornerRadius(12)
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .aspectRatio(2/3, contentMode: .fit)
                                .cornerRadius(12)
                                .clipped()
                        case .failure:
                            Rectangle()
                                .fill(Color.gray.opacity(0.3))
                                .aspectRatio(2/3, contentMode: .fit)
                                .cornerRadius(12)
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
                        .cornerRadius(12)
                }

                // VIP/FREE Badge Overlay (Bottom-Left)
                HStack(spacing: 3) {
                    Image(movie.isFree ? "ic-free" : "ic-vip")
                        .resizable()
                        .renderingMode(.original)
                        .frame(width: 16, height: 16)
                        .foregroundColor(.white)

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
                .padding(8)
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

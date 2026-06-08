//
//  WatchListScreen.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 10/24/25.
//

import SwiftUI
import Kingfisher

struct WatchListScreen: View {
    var host: HostController?

    var didTapClearAll: (() -> Void)?
    var didTapBack: (() -> Void)?

    @ObservedObject private var viewModel: WatchListViewModel

    @State private var selectedTab: WatchListType = .lastWatch

    init(_ viewModel: WatchListViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(alignment: .leading) {
            navView()

            // Tabs Row
            HStack(spacing: 10) {
                // Recent Tab
                Button {
                    selectedTab = .lastWatch
                    viewModel.listType = .lastWatch
                    viewModel.refreshData()
                } label: {
                    Text("Recent")
                        .font(FontUtility.body1())
                        .foregroundColor(Color.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                }
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(selectedTab == .lastWatch ? Color("primaryBgColor") : Color.darkGrey)
                )

                // Watchlist Tab
                Button {
                    selectedTab = .watchLater
                    viewModel.listType = .watchLater
                    viewModel.refreshData()
                } label: {
                    Text("Watchlist")
                        .font(FontUtility.body1())
                        .foregroundColor(Color.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                }
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(selectedTab == .watchLater ? Color("primaryBgColor") : Color.darkGrey)
                )

                // Favorite Tab
                Button {
                    selectedTab = .favourites
                    viewModel.listType = .favourites
                    viewModel.refreshData()
                } label: {
                    Text("Favorite")
                        .font(FontUtility.body1())
                        .foregroundColor(Color.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                }
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(selectedTab == .favourites ? Color("primaryBgColor") : Color.darkGrey)
                )

                Spacer()
            }
            .padding(.horizontal, 10)

            // Clear All Button Row (on new line)
            if selectedTab != .favourites {
                HStack {
                    Spacer()
                    Button {
                        self.didTapClearAll?()
                    } label: {
                        Text("Clear All")
                            .font(FontUtility.body2())
                            .foregroundColor(Color.red)
                    }
                }
                .padding(.horizontal, 10)
                .padding(.top, 4)
            }

            ScrollView(showsIndicators: false) {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 50)
                } else {
                    switch selectedTab {
                    case .lastWatch:
                        renderRecentList()
                    case .watchLater:
                        renderWatchLaterList()
                    case .favourites:
                        renderFavouritesList()
                    }
                }
            }
            .onAppear {
                viewModel.listType = selectedTab
                viewModel.fetchData()
            }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }

    // MARK: - Recent List
    private func renderRecentList() -> some View {
        VStack {
            if viewModel.lastWatchItems.isEmpty {
                Text(viewModel.emptyMessage)
                    .foregroundColor(.gray)
                    .padding(.top, 50)
            } else {
                ForEach(viewModel.lastWatchItems) { item in
                    renderRecentItem(item)
                        .onAppear {
                            // Load more when reaching the last item
                            if item.id == viewModel.lastWatchItems.last?.id {
                                viewModel.loadMoreData()
                            }
                        }
                }

                // Loading indicator for pagination
                if viewModel.isLoadingMore {
                    HStack {
                        Spacer()
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .padding()
                        Spacer()
                    }
                }
            }
        }
    }

    private func renderRecentItem(_ item: LastWatchItem) -> some View {
        HStack {
            ZStack {
                KFImage(URL(string: item.fullImageURL))
                    .placeholder {
                        Color.gray
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 120, height: 67)
                    .clipped()
                    .cornerRadius(8)

                Image("ic-play")
                    .frame(width: 20, height: 20)
            }
            .padding(.leading, 10)
            .padding(.vertical, 6)

            VStack(alignment: .leading) {
                Text(item.movieName ?? "")
                    .font(FontUtility.body2())
                    .foregroundColor(Color.white)
                    .padding(.vertical, 4)
                    .lineLimit(2)

                HStack {
                    Image("ic_clock")
                        .frame(width: 15, height: 15)
                        .padding(.trailing, 4)

                    Text("Last watch on:")
                        .font(FontUtility.smallText1())
                        .foregroundColor(Color.white)

                    Text(item.lastWatchDate ?? "")
                        .font(FontUtility.smallText1())
                        .foregroundColor(Color.white)

                    Spacer()

                    Button {
                        viewModel.deleteLastWatchItem(id: item.id)
                    } label: {
                        Image("ic-delete")
                            .frame(width: 20, height: 20)
                            .padding(.horizontal, 8)
                    }
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.darkGrey)
        )
        .frame(maxWidth: .infinity)
        .padding(.vertical, 5)
        .padding(.horizontal, 10)
        .onTapGesture {
            let detailType: DetailType = item.isSeries ? .series : .movie
            ViewNavigation.shared.showMovieDetail(detailType: detailType, movieId: item.movieId ?? 0)
        }
    }

    // MARK: - Watch Later List
    private func renderWatchLaterList() -> some View {
        VStack {
            if viewModel.watchLaterItems.isEmpty {
                Text(viewModel.emptyMessage)
                    .foregroundColor(.gray)
                    .padding(.top, 50)
            } else {
                ForEach(viewModel.watchLaterItems) { item in
                    renderWatchLaterItem(item)
                        .onAppear {
                            // Load more when reaching the last item
                            if item.id == viewModel.watchLaterItems.last?.id {
                                viewModel.loadMoreData()
                            }
                        }
                }

                // Loading indicator for pagination
                if viewModel.isLoadingMore {
                    HStack {
                        Spacer()
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .padding()
                        Spacer()
                    }
                }
            }
        }
    }

    private func renderWatchLaterItem(_ item: WatchLaterItem) -> some View {
        HStack {
            ZStack(alignment: .bottomLeading) {
                KFImage(URL(string: item.fullImageURL))
                    .placeholder {
                        Color.gray
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 120, height: 67)
                    .clipped()
                    .cornerRadius(8)

                Image(item.isFree ? "free_badge" : "vip_badge")
                    .frame(width: 40, height: 22)
                    .padding(.leading, 4)
                    .padding(.bottom, 6)
            }
            .padding(.leading, 10)
            .padding(.vertical, 6)

            VStack(alignment: .leading) {
                Text(item.movieName ?? "")
                    .font(FontUtility.body2())
                    .foregroundColor(Color.white)
                    .padding(.vertical, 4)
                    .lineLimit(2)

                HStack {
                    Image("ic_clock")
                        .frame(width: 15, height: 15)
                        .padding(.trailing, 4)

                    Text("Watchlist on:")
                        .font(FontUtility.smallText1())
                        .foregroundColor(Color.white)

                    Text(item.addedDate ?? "")
                        .font(FontUtility.smallText1())
                        .foregroundColor(Color.white)

                    Spacer()

                    Button {
                        viewModel.deleteWatchLaterItem(watchLaterId: item.watchLaterId)
                    } label: {
                        Image("ic-delete")
                            .frame(width: 20, height: 20)
                            .padding(.horizontal, 8)
                    }
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.darkGrey)
        )
        .padding(.vertical, 5)
        .padding(.horizontal, 10)
        .onTapGesture {
            let detailType: DetailType = item.isSeries ? .series : .movie
            ViewNavigation.shared.showMovieDetail(detailType: detailType, movieId: item.movieId ?? 0)
        }
    }

    // MARK: - Favourites List
    private func renderFavouritesList() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            if viewModel.favouriteItems.isEmpty {
                Text(viewModel.emptyMessage)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 50)
            } else {
                // Movies Grid
                VStack(alignment: .leading, spacing: 12) {
                    Text("Movies")
                        .font(FontUtility.heading2())
                        .foregroundColor(.white)
                        .padding(.horizontal, 10)

                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 10),
                        GridItem(.flexible(), spacing: 10),
                        GridItem(.flexible(), spacing: 10)
                    ], spacing: 16) {
                        ForEach(viewModel.favouriteItems) { item in
                            renderMovieItem(item)
                                .onAppear {
                                    // Load more when reaching the last item
                                    if item.id == viewModel.favouriteItems.last?.id {
                                        viewModel.loadMoreData()
                                    }
                                }
                        }
                    }
                    .padding(.horizontal, 10)
                }

                // Loading indicator for pagination
                if viewModel.isLoadingMore {
                    HStack {
                        Spacer()
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .padding()
                        Spacer()
                    }
                }
            }
        }
        .padding(.vertical, 10)
    }

    private func renderMovieItem(_ item: FavouriteItem) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topLeading) {
                KFImage(URL(string: item.fullImageURL))
                    .placeholder {
                        Color.gray
                    }
                    .resizable()
                    .aspectRatio(3/4, contentMode: .fill)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .cornerRadius(12)

                // VIP/Free Badge
                if item.subscriptionType == 2 {
                    Image("vip_badge")
                        .resizable()
                        .frame(width: 40, height: 22)
                        .padding(8)
                } else {
                    Image("free_badge")
                        .resizable()
                        .frame(width: 40, height: 22)
                        .padding(8)
                }
            }

            Text(item.movieName ?? item.reelName ?? "")
                .font(FontUtility.smallText1())
                .foregroundColor(.white)
                .lineLimit(2)
        }
        .onTapGesture {
            let detailType: DetailType = item.isSeries ? .series : .movie
            ViewNavigation.shared.showMovieDetail(detailType: detailType, movieId: item.movieId ?? item.reelId ?? 0)
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

                Text("Watchlist")
                    .font(FontUtility.heading1())
                    .foregroundColor(Color("white_color"))

                Spacer()
            }
        }
        .padding(10)
    }
}

#Preview {
    WatchListScreen(.init())
}

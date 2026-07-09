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
    @State private var showClearAllDialog: Bool = false
    @State private var hasLoadedInitialData: Bool = false

    init(_ viewModel: WatchListViewModel) {
        _viewModel = .init(wrappedValue: viewModel)
    }

    private var clearAllMessage: String {
        switch selectedTab {
        case .lastWatch:
            return "Are you sure you want to clear all recent items?"
        case .watchLater:
            return "Are you sure you want to clear all watchlist items?"
        case .favourites:
            return "Are you sure you want to clear all favourite items?"
        }
    }

    private var shouldShowClearAllButton: Bool {
        switch selectedTab {
        case .lastWatch:
            return !viewModel.lastWatchItems.isEmpty
        case .watchLater:
            return !viewModel.watchLaterItems.isEmpty
        case .favourites:
            return false // Never show for favourites
        }
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
            // Only show if:
            // 1. Not on favourites tab
            // 2. Has items in the current list
            if selectedTab != .favourites && shouldShowClearAllButton {
                HStack {
                    Spacer()
                    Button {
                        showClearAllDialog = true
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
                if !hasLoadedInitialData {
                    print("📱 [WatchList] Initial load - fetching data for tab: \(selectedTab)")
                    viewModel.listType = selectedTab
                    viewModel.fetchData()
                    hasLoadedInitialData = true
                }
            }
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
        .customDialog(isPresented: $showClearAllDialog) {
            CustomDialogView(
                iconName: "img_question",
                title: "Clear All",
                message: clearAllMessage,
                showCloseButton: true,
                closeAction: {
                    showClearAllDialog = false
                },
                primaryButtonTitle: "Yes",
                primaryAction: {
                    showClearAllDialog = false
                    didTapClearAll?()
                },
                secondaryButtonTitle: "Cancel",
                secondaryAction: {
                    showClearAllDialog = false
                }
            ) {
                EmptyView()
            }
        }
    }

    // MARK: - Recent List
    private func renderRecentList() -> some View {
        VStack {
            if viewModel.lastWatchItems.isEmpty {
                EmptyStateView()
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
            let contentId = item.contentId
            print("🎬 [WatchList] Recent item tapped - contentId: \(contentId), id(API): \(item.contentIdFromAPI ?? -1), movieId: \(item.movieId ?? -1), seriesId: \(item.seriesId ?? -1), name: \(item.movieName ?? "N/A"), type: \(detailType)")
            ViewNavigation.shared.showMovieDetail(detailType: detailType, movieId: contentId)
        }
    }

    // MARK: - Watch Later List
    private func renderWatchLaterList() -> some View {
        VStack {
            if viewModel.watchLaterItems.isEmpty {
                EmptyStateView()
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
            if viewModel.favouriteItems.isEmpty && viewModel.favouriteReels.isEmpty {
                EmptyStateView()
            } else {
                // Short Section (Horizontal Scroll)
                if !viewModel.favouriteReels.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Short")
                                .font(FontUtility.heading2())
                                .foregroundColor(.white)

                            Spacer()

                            Button(action: {
                                print("🔥 [WatchList] View All Shorts tapped - Navigating to Hot tab")
                                ViewNavigation.shared.showHotTab()
                            }) {
                                HStack(spacing: 4) {
                                    Text("View All")
                                        .font(FontUtility.body2())
                                        .foregroundColor(.white)
                                    Image(systemName: "chevron.right")
                                        .font(.system(size: 12))
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        .padding(.horizontal, 10)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(viewModel.favouriteReels) { item in
                                    renderShortItem(item)
                                }
                            }
                            .padding(.horizontal, 10)
                        }
                    }
                }

                // Movies Grid
                if !viewModel.favouriteItems.isEmpty {
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

    // MARK: - Render Short Item (Vertical aspect ratio for reels)
    private func renderShortItem(_ item: FavouriteReelItem) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topLeading) {
                KFImage(URL(string: item.fullImageURL))
                    .placeholder {
                        Color.gray
                    }
                    .resizable()
                    .aspectRatio(9/16, contentMode: .fill)
                    .frame(width: 140, height: 200)
                    .clipped()
                    .cornerRadius(12)

                // Note: API doesn't return subscriptionType for reels
                // Using Free badge as default
                Image("free_badge")
                    .resizable()
                    .frame(width: 40, height: 22)
                    .padding(8)
            }
        }
        .onTapGesture {
            if let reelId = item.reelId {
                print("🔥 [WatchList] Short tapped - reelId: \(reelId), navigating to Hot tab with reelId")
                ViewNavigation.shared.showHotTab(reelId: reelId)
            }
        }
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

// MARK: - Empty State View
struct EmptyStateView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            // Empty icon
            Image("empty_watch_list")
                .resizable()
                .frame(width: 100, height: 100)

            // No Results Found text
            Text("No Results Found")
                .font(FontUtility.heading2())
                .foregroundColor(.white)

            // Continue button
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Continue")
                    .font(FontUtility.body1())
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color("pink_Color"))
                    .cornerRadius(25)
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)

            Spacer()
        }
    }
}

#Preview {
    WatchListScreen(.init())
}

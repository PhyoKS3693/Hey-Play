//
//  HomeViewController + Extension .swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 07/08/2025.
//

import Foundation
import UIKit
import SafariServices

extension HomeViewController {
    func setupTableView() {
        tblHome.delegate = self
        tblHome.dataSource = self
        tblHome.registerForCell(strID: HomeUserInfoTableViewCell.identifier)
        tblHome.registerForCell(strID: BannerTableViewCell.identifier)
        tblHome.registerForCell(strID: RecentTableViewCell.identifier)
        tblHome.registerForCell(strID: MovieTableViewCell.identifier)
        tblHome.registerForCell(strID: LatestMovieTableViewCell.identifier)
        tblHome.registerForCell(strID: SeriesTableViewCell.identifier)
        tblHome.registerForCell(strID: MovieCollectionTableViewCell.identifier)
        tblHome.registerForCell(strID: MovieCollectionTypeOneTableViewCell.identifier)
        tblHome.registerForCell(strID: PopularTableViewCell.identifier)

        // Register programmatic cells (no XIB)
        tblHome.register(CustomAdTableViewCell.self, forCellReuseIdentifier: CustomAdTableViewCell.identifier)
        tblHome.register(GoogleAdTableViewCell.self, forCellReuseIdentifier: GoogleAdTableViewCell.identifier)

        tblHome.showsVerticalScrollIndicator = false
        tblHome.reloadData()
    }
}
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.sectionCount
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionType = viewModel.getSectionType(at: indexPath.section) else {
            return UITableViewCell()
        }

        switch sectionType {
        case .user:
            print("📋 [HomeViewController] Dequeuing HomeUserInfoTableViewCell")
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeUserInfoTableViewCell.identifier, for: indexPath) as? HomeUserInfoTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: viewModel.profile)
            cell.onSubscribeTapped = { [weak self] in
                // Navigate to subscription buy plan screen
                ViewNavigation.shared.showSubscriptionPlan()
            }
            cell.onLoginTapped = { [weak self] in
                ViewNavigation.shared.showLoginView()
            }
            return cell

        case .banner:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: BannerTableViewCell.identifier, for: indexPath) as? BannerTableViewCell else {
                return UITableViewCell()
            }
            if !viewModel.banners.isEmpty {
                cell.configure(with: viewModel.banners)
            } else {
                cell.items = [UIImage(named: "image1"), UIImage(named: "image2"), UIImage(named: "image3")]
            }
            cell.onBannerTapped = { [weak self] banner in
                self?.handleBannerTap(banner)
            }
            return cell

        case .recent:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: RecentTableViewCell.identifier, for: indexPath) as? RecentTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(title: "Continue Watching", movies: viewModel.lastWatchList)
            cell.navigateToMovieDetail = { [weak self] id in
                ViewNavigation.shared.showMovieDetail(detailType: .movie, movieId: id)
            }
            // Show delete button for Continue Watching
            cell.showDeleteButton = true

            // Handle delete action
            cell.onDeleteMovie = { [weak self] movieId in
                self?.handleDeleteMovie(movieId: movieId)
            }

            // Continue Watching doesn't have "View All" - don't set navigateToViewAll callback
            // The "See All" button will be hidden in the cell or do nothing
            cell.btnSeeAll.isHidden = true
            return cell

        case .customAd:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomAdTableViewCell.identifier, for: indexPath) as? CustomAdTableViewCell else {
                return UITableViewCell()
            }
            if let adsSetting = viewModel.homeData?.adsSetting {
                cell.configure(with: adsSetting)
            }
            return cell

        case .googleAd:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: GoogleAdTableViewCell.identifier, for: indexPath) as? GoogleAdTableViewCell else {
                return UITableViewCell()
            }
            return cell

        case .playlist(let playlist):
            return configurePlaylistCell(for: playlist, at: indexPath)
        }
    }

    // MARK: - Configure Playlist Cell based on Layout Type
    private func configurePlaylistCell(for playlist: Playlist, at indexPath: IndexPath) -> UITableViewCell {
        let title = playlist.safeTitle
        let movies = playlist.safeMovieList

        switch playlist.layoutType {
        case .layout1:
            // Layout 1: Horizontal scrolling portrait cards (LatestMovieTableViewCell)
            guard let cell = tblHome.dequeueReusableCell(withIdentifier: LatestMovieTableViewCell.identifier, for: indexPath) as? LatestMovieTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(title: title, movies: movies)
            cell.navigateToMovieDetail = { [weak self] id in
                self?.navigateToDetail(for: playlist, movieId: id)
            }
            cell.navigateToViewAll = { [weak self] in
                self?.navigateToViewAll(for: playlist)
            }
            return cell

        case .layout2:
            // Layout 2: Horizontal 2-row grid (MovieTableViewCell)
            guard let cell = tblHome.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as? MovieTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(title: title, movies: movies)
            cell.navigateToMovieDetail = { [weak self] id in
                self?.navigateToDetail(for: playlist, movieId: id)
            }
            cell.navigateToViewAll = { [weak self] in
                self?.navigateToViewAll(for: playlist)
            }
            return cell

        case .layout3:
            // Layout 3: Vertical list with image left, text right (SeriesTableViewCell)
            guard let cell = tblHome.dequeueReusableCell(withIdentifier: SeriesTableViewCell.identifier, for: indexPath) as? SeriesTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(title: title, movies: movies)
            cell.navigateToSeriesDetail = { [weak self] id in
                self?.navigateToDetail(for: playlist, movieId: id)
            }
            cell.navigateToViewAll = { [weak self] in
                self?.navigateToViewAll(for: playlist)
            }
            return cell

        case .layout4:
            // Layout 4: Large portrait posters 2 columns (PopularTableViewCell)
            guard let cell = tblHome.dequeueReusableCell(withIdentifier: PopularTableViewCell.identifier, for: indexPath) as? PopularTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(title: title, movies: movies)
            cell.navigateToDetail = { [weak self] id in
                self?.navigateToDetail(for: playlist, movieId: id)
            }
            cell.navigateToViewAll = { [weak self] in
                self?.navigateToViewAll(for: playlist)
            }
            return cell

        case .layout5:
            // Layout 5: Featured/Recent large landscape cards (RecentTableViewCell)
            guard let cell = tblHome.dequeueReusableCell(withIdentifier: RecentTableViewCell.identifier, for: indexPath) as? RecentTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(title: title, movies: movies)
            cell.navigateToMovieDetail = { [weak self] id in
                self?.navigateToDetail(for: playlist, movieId: id)
            }
            cell.navigateToViewAll = { [weak self] in
                self?.navigateToViewAll(for: playlist)
            }
            // Show delete button if title contains "recent" or "continue"
            let lowercaseTitle = title.lowercased()
            cell.showDeleteButton = lowercaseTitle.contains("recent") || lowercaseTitle.contains("continue")

            // Handle delete action
            cell.onDeleteMovie = { [weak self] movieId in
                self?.handleDeleteMovie(movieId: movieId)
            }

            // Show "See All" button for playlist sections
            cell.btnSeeAll.isHidden = false
            return cell

        case .layout6:
            // Layout 6: Vertical grid of portrait posters 2 columns (MovieCollectionTableViewCell)
            guard let cell = tblHome.dequeueReusableCell(withIdentifier: MovieCollectionTableViewCell.identifier, for: indexPath) as? MovieCollectionTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(title: title, movies: movies)
            cell.navigateToDetail = { [weak self] id in
                self?.navigateToDetail(for: playlist, movieId: id)
            }
            cell.navigateToViewAll = { [weak self] in
                self?.navigateToViewAll(for: playlist)
            }
            return cell
        }
    }

    // MARK: - Navigation Helpers
    private func navigateToDetail(for playlist: Playlist, movieId: Int) {
        // For movie detail, always go to detail screen regardless of redirectScreenType
        let movie = playlist.safeMovieList.first { $0.id == movieId }
        let detailType: DetailType = movie?.isSeries == true ? .series : .movie
        ViewNavigation.shared.showMovieDetail(detailType: detailType, movieId: movieId)
    }

    private func navigateToViewAll(for playlist: Playlist) {
        // All playlists navigate to CollectionResultViewController
        ViewNavigation.shared.showPlaylistDetail(
            playlistId: playlist.playlistId,
            title: playlist.safeTitle
        )
    }

    // MARK: - Handle Banner Tap
    private func handleBannerTap(_ banner: Banner) {
        guard let bannerType = banner.type else {
            print("⚠️ Unknown banner type")
            return
        }

        switch bannerType {
        case .normal:
            // Normal banner - use webUrl with Link Open Type
            handleNormalBanner(banner)

        case .movies:
            // Movie banner - navigate to movie detail
            if let movieId = banner.detailViewId, movieId > 0 {
                ViewNavigation.shared.showMovieDetail(detailType: .movie, movieId: movieId)
            }

        case .series:
            // Series banner - navigate to series detail
            if let seriesId = banner.detailViewId, seriesId > 0 {
                ViewNavigation.shared.showMovieDetail(detailType: .series, movieId: seriesId)
            }

        case .subscription, .package1, .package2:
            // Handle subscription and package banners
            // TODO: Implement subscription navigation if needed
            print("⚠️ Subscription/Package banner navigation not implemented")
        }
    }

    private func handleNormalBanner(_ banner: Banner) {
        guard let webUrl = banner.webUrl, !webUrl.isEmpty, let url = URL(string: webUrl) else {
            print("⚠️ Normal banner has no valid webUrl")
            return
        }

        switch banner.openType {
        case .inApp:
            // Open in-app using SFSafariViewController
            let safariVC = SFSafariViewController(url: url)
            safariVC.modalPresentationStyle = .pageSheet
            present(safariVC, animated: true)

        case .external:
            // Open in external browser
            UIApplication.shared.open(url)
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Show bottom constraint for last section
        if indexPath.section == viewModel.sectionCount - 1 {
            DispatchQueue.main.async {
                self.bottomConstraint.constant = 70
            }
        } else {
            DispatchQueue.main.async {
                self.bottomConstraint.constant = 0
            }
        }
    }
}

// MARK: - UIScrollViewDelegate (Load More)
extension HomeViewController {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height

        // Trigger load more when user scrolls near the bottom
        if offsetY > contentHeight - frameHeight - 100 {
            if viewModel.canLoadMore {
                viewModel.loadMoreData()
            }
        }
    }
}

extension HomeViewController {
    func setNavigationBarIcon() {
        let logoImageView = UIImageView(
            image: UIImage(named: "ic-nav-bar")
        )
        let logoItem = UIBarButtonItem(
            customView: logoImageView
        )
        navigationItem.leftBarButtonItem = logoItem
    }
    
    func setRightBarItems() {
        let searchItem = UIBarButtonItem(
            image:  UIImage(named: "ic-search")?.withRenderingMode(.alwaysOriginal),
            style: .done,
            target: self,
            action: #selector(presentSearch)
        )
        
        let notiItem = UIBarButtonItem(
            image:  UIImage(named: "ic-noti")?.withRenderingMode(.alwaysOriginal),
            style: .done,
            target: self,
            action: #selector(presentNoti)
        )
        
        navigationItem.rightBarButtonItems = [notiItem, searchItem]
    }
    
    @objc func presentSearch() {
        ViewNavigation.shared.showSearchView()
    }
    
    @objc func presentNoti() {
        ViewNavigation.shared.showNotification()
    }
}

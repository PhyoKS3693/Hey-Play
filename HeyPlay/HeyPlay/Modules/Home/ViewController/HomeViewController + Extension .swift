//
//  HomeViewController + Extension .swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 07/08/2025.
//

import Foundation
import UIKit

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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeUserInfoTableViewCell.identifier, for: indexPath) as? HomeUserInfoTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: viewModel.profile)
            cell.onSubscribeTapped = { [weak self] in
                // Navigate to subscription screen
                // TODO: Implement subscription navigation
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
            // Continue Watching doesn't have "View All" - don't set navigateToViewAll callback
            // The "See All" button will be hidden in the cell or do nothing
            cell.btnSeeAll.isHidden = true
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
            // Layout 1: Horizontal 2-row grid (MovieTableViewCell)
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

        case .layout2:
            // Layout 2: Horizontal scrolling smaller cards (LatestMovieTableViewCell)
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
            // Show "See All" button for playlist sections
            cell.btnSeeAll.isHidden = false
            return cell

        case .layout6:
            // Layout 6: Vertical grid of portrait posters 3 columns (MovieCollectionTableViewCell)
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
        if banner.hasWebUrl, let webUrl = banner.webUrl {
            if let url = URL(string: webUrl) {
                UIApplication.shared.open(url)
            }
        } else if banner.hasDetailView, let movieId = banner.detailViewId {
            let detailType: DetailType = banner.type == .series ? .series : .movie
            ViewNavigation.shared.showMovieDetail(detailType: detailType, movieId: movieId)
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

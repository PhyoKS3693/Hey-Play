//
//  HotViewController + Extension.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 10/08/2025.
//

import Foundation
import UIKit

extension HotViewController {
    func setupTableView() {
        tblHot.registerForCell(strID: HotTableViewCell.identifier)
        tblHot.showsVerticalScrollIndicator = false
        tblHot.isPagingEnabled = true
        tblHot.contentInset.top = 0
        tblHot.delegate = self
        tblHot.dataSource = self
        tblHot.separatorStyle = .none
        tblHot.backgroundColor = .black
        tblHot.reloadData()
    }
}

extension HotViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.reels.isEmpty ? 5 : viewModel.reelCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HotTableViewCell.identifier, for: indexPath) as? HotTableViewCell else {
            return UITableViewCell()
        }

        if let reel = viewModel.getReel(at: indexPath.row) {
            cell.configure(with: reel)

            // Handle favorite action
            cell.onFavoriteTapped = { [weak self] in
                print("🔥 [HotViewController] Favorite tapped at index: \(indexPath.row)")
                self?.viewModel.toggleFavorite(at: indexPath.row)
            }

            // Handle watch later action
            cell.onWatchLaterTapped = { [weak self] in
                self?.viewModel.toggleWatchLater(at: indexPath.row)
            }

            // Handle next/watch button
            cell.onNextTapped = { [weak self] in
                self?.navigateToContent(reel: reel)
            }
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.bounds.height
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Load more when reaching near the end
        if indexPath.row >= viewModel.reelCount - 2 {
            viewModel.loadMoreData()
        }

        // Auto-play video when cell becomes visible
        if let hotCell = cell as? HotTableViewCell {
            hotCell.playVideo()
        }
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // Pause video when cell scrolls out of view
        if let hotCell = cell as? HotTableViewCell {
            hotCell.pauseVideo()
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // Play video for the currently visible cell after scrolling stops
        playVisibleCellVideo()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // If no deceleration, play immediately
        if !decelerate {
            playVisibleCellVideo()
        }
    }

    // MARK: - Play Visible Cell Video
    private func playVisibleCellVideo() {
        guard let visibleIndexPaths = tblHot.indexPathsForVisibleRows,
              let mostVisibleIndexPath = visibleIndexPaths.first,
              let cell = tblHot.cellForRow(at: mostVisibleIndexPath) as? HotTableViewCell else {
            return
        }

        // Pause all other cells
        for indexPath in visibleIndexPaths {
            if indexPath != mostVisibleIndexPath,
               let otherCell = tblHot.cellForRow(at: indexPath) as? HotTableViewCell {
                otherCell.pauseVideo()
            }
        }

        // Play the most visible cell
        cell.playVideo()
    }

    // MARK: - Navigation
    private func navigateToContent(reel: Reel) {
        let detailType: DetailType = reel.isSeries ? .series : .movie
        let movieId = reel.movieId ?? 0
        ViewNavigation.shared.showMovieDetail(detailType: detailType, movieId: movieId)
    }
}

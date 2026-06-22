//
//  HotViewController.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 10/08/2025.
//

import UIKit
import Combine

class HotViewController: BaseViewController {

    @IBOutlet weak var tblHot: UITableView!

    // ViewModel
    let viewModel = HotViewModel()

    // Refresh Control
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupRefreshControl()
        bindViewModel()
        fetchData()
        self.navigationController?.navigationBar.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide navigation bar for Hot tab
        navigationController?.navigationBar.isHidden = true
        navigationController?.isNavigationBarHidden = true
        // Play video when screen appears
        playCurrentVideo()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Pause all videos when leaving screen
        pauseAllVideos()
    }

    override func setupUI() {
        super.setupUI()
        setBottomTabBar()
    }

    // MARK: - Video Playback Control
    func playCurrentVideo() {
        guard let visibleIndexPaths = tblHot.indexPathsForVisibleRows,
              let firstIndexPath = visibleIndexPaths.first,
              let cell = tblHot.cellForRow(at: firstIndexPath) as? HotTableViewCell else {
            return
        }
        cell.playVideo()
    }

    func pauseAllVideos() {
        guard let visibleCells = tblHot.visibleCells as? [HotTableViewCell] else { return }
        visibleCells.forEach { $0.pauseVideo() }
    }

    func setBottomTabBar() {
        selectedTabItem = .hot
        setupBottomBar()
        setTabBarItem()
    }

    // MARK: - Setup Refresh Control
    private func setupRefreshControl() {
        refreshControl.tintColor = .white
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tblHot.refreshControl = refreshControl
    }

    @objc private func handleRefresh() {
        viewModel.refreshData()
    }

    // MARK: - Bind ViewModel
    private func bindViewModel() {
        // Bind reels data - only reload for initial load and pagination
        viewModel.$reels
            .receive(on: DispatchQueue.main)
            .sink { [weak self] reels in
                guard let self = self else { return }
                // Only reload if count changed (new data loaded) or it's initial load
                if self.tblHot.numberOfRows(inSection: 0) != reels.count {
                    self.tblHot.reloadData()
                }
            }
            .store(in: &cancellables)

        // Bind loading state
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let self = self else { return }
                if isLoading {
                    if self.viewModel.reels.isEmpty {
                        self.showLoading(message: "Loading...")
                    }
                } else {
                    self.hideLoading()
                    self.refreshControl.endRefreshing()
                }
            }
            .store(in: &cancellables)

        // Bind error message
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .sink { [weak self] errorMessage in
                self?.showErrorAlert(message: errorMessage)
            }
            .store(in: &cancellables)

        // Listen to favorite toggle updates
        viewModel.onFavoriteToggled = { [weak self] index, isFavorite, likeCount in
            self?.updateFavoriteUI(at: index, isFavorite: isFavorite, likeCount: likeCount)
        }
    }

    // MARK: - Fetch Data
    private func fetchData() {
        viewModel.fetchReels()
    }

    // MARK: - Show Error Alert
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
            self?.fetchData()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    // MARK: - Update Favorite UI
    private func updateFavoriteUI(at index: Int, isFavorite: Bool, likeCount: Int) {
        let indexPath = IndexPath(row: index, section: 0)

        // Check if the cell is currently visible
        guard let cell = tblHot.cellForRow(at: indexPath) as? HotTableViewCell else {
            return
        }

        // Update the favorite view
        cell.favoriteView?.updateState(isActive: isFavorite)
        cell.favoriteView?.updateLikeCount(likeCount)
    }
}

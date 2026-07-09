//
//  HomeViewController.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 10/08/2025.
//

import UIKit
import Combine
import SwiftUI

class HomeViewController: BaseViewController {

    @IBOutlet weak var tblHome: UITableView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!

    // ViewModel
    let viewModel = HomeViewModel()

    // Loading Views
    private let loadMoreFooter = LoadMoreFooterView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60))
    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        bindViewModel()
        fetchData()
        setupNotificationObservers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("📱 [HomeViewController] viewWillAppear")
        // Show navigation bar (in case it was hidden by detail screen)
        navigationController?.navigationBar.isHidden = false
        navigationController?.isNavigationBarHidden = false
        // Restore navigation bar items every time view appears
        setNavigationBarIcon()
        setRightBarItems()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func setupUI() {
        super.setupUI()
        setBottomTabBar()
        setupTableView()
        setupRefreshControl()
        setupLoadMoreFooter()
        setNavigationBarIcon()
        setRightBarItems()
    }

    func setBottomTabBar() {
        selectedTabItem = .home
        setupBottomBar()
        setTabBarItem()
    }

    // MARK: - Setup Refresh Control (Pull to Refresh)
    private func setupRefreshControl() {
        refreshControl.tintColor = .white
        refreshControl.attributedTitle = NSAttributedString(
            string: "Pull to refresh",
            attributes: [.foregroundColor: UIColor.lightGray]
        )
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tblHome.refreshControl = refreshControl
    }

    // MARK: - Setup Load More Footer
    private func setupLoadMoreFooter() {
        loadMoreFooter.isHidden = true
        tblHome.tableFooterView = loadMoreFooter
    }

    @objc private func handleRefresh() {
        viewModel.refreshData()
    }

    // MARK: - Bind ViewModel
    private func bindViewModel() {
        // Bind home data
        viewModel.$homeData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] homeData in
                // Only reload if we have actual data (prevent double reload that causes button flash)
                guard homeData != nil else {
                    print("⏭️ [HomeViewController] homeData is nil - skipping reload")
                    return
                }
                print("🔄 [HomeViewController] homeData changed - reloading table (hasData: true)")
                self?.tblHome.reloadData()
            }
            .store(in: &cancellables)

        // Bind profile data - only reload user section AFTER initial homeData loads
        viewModel.$profile
            .dropFirst() // Skip initial nil value
            .receive(on: DispatchQueue.main)
            .sink { [weak self] profile in
                guard let self = self else { return }

                // Only reload user section if homeData has already loaded
                // This prevents double reload during initial app launch
                guard self.viewModel.homeData != nil else {
                    print("⏭️ [HomeViewController] profile changed but homeData not loaded yet - skipping user section reload")
                    return
                }

                print("👤 [HomeViewController] profile changed - reloading user section only")
                if let indexPath = self.indexPathForUserSection() {
                    UIView.performWithoutAnimation {
                        self.tblHome.reloadRows(at: [indexPath], with: .none)
                    }
                }
            }
            .store(in: &cancellables)

        // Bind initial loading state
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let self = self else { return }
                if isLoading {
                    // Only show full loading if no data yet
                    if self.viewModel.homeData == nil {
                        self.showLoading(message: "Loading...")
                    }
                } else {
                    self.hideLoading()
                    self.refreshControl.endRefreshing()
                }
            }
            .store(in: &cancellables)

        // Bind load more state
        viewModel.$isLoadingMore
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoadingMore in
                guard let self = self else { return }
                if isLoadingMore {
                    self.loadMoreFooter.startLoading()
                } else {
                    self.loadMoreFooter.stopLoading()
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
    }

    // MARK: - Fetch Data
    private func fetchData() {
        viewModel.fetchAllData()
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

    // MARK: - Notification Observers
    private func setupNotificationObservers() {
        // Observe VIP package purchase/subscription changes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleSubscriptionChanged),
            name: NSNotification.Name("SubscriptionChanged"),
            object: nil
        )

        // Observe login/logout events
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleLoginStatusChanged),
            name: NSNotification.Name("LoginStatusChanged"),
            object: nil
        )
    }

    @objc private func handleSubscriptionChanged() {
        print("📦 [HomeViewController] Subscription changed - refreshing user info")
        refreshUserInfoSection()
    }

    @objc private func handleLoginStatusChanged() {
        print("🔐 [HomeViewController] Login status changed - refreshing user info")
        refreshUserInfoSection()
    }

    private func refreshUserInfoSection() {
        // Fetch latest profile data
        viewModel.fetchProfile()

        // Update user info cell without animation
        if let indexPath = indexPathForUserSection() {
            UIView.performWithoutAnimation {
                tblHome.reloadRows(at: [indexPath], with: .none)
            }
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Helper Methods
    private func indexPathForUserSection() -> IndexPath? {
        let sections = viewModel.getAllSections()
        for (index, section) in sections.enumerated() {
            if case .user = section {
                return IndexPath(row: 0, section: index)
            }
        }
        return nil
    }

    // MARK: - Delete Movie from Last Watch
    func handleDeleteMovie(movieId: Int) {
        // Find the movie to get its lastWatchId
        guard let movie = viewModel.lastWatchList.first(where: { $0.id == movieId }),
              let lastWatchId = movie.lastWatchId else {
            print("⚠️ [Home] Cannot delete - lastWatchId not found for movie: \(movieId)")
            return
        }

        // Show confirmation alert
        let alert = UIAlertController(
            title: "Remove from Continue Watching",
            message: "Are you sure you want to remove \"\(movie.name ?? "this item")\" from your continue watching list?",
            preferredStyle: .alert
        )

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Remove", style: .destructive) { [weak self] _ in
            self?.deleteMovie(lastWatchId: String(lastWatchId))
        })

        present(alert, animated: true)
    }

    private func deleteMovie(lastWatchId: String) {
        showLoading(message: "Removing...")

        Task {
            let result = await LastWatchService.shared.deleteLastWatch(lastWatchId: lastWatchId)

            await MainActor.run {
                hideLoading()

                switch result {
                case .success:
                    // Refresh home data to update the list
                    viewModel.fetchAllData()

                case .failure(let error):
                    showErrorMessage(message: error.localizedDescription)
                }
            }
        }
    }

    private func showErrorMessage(message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

}

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

    // Force Update Dialog
    private var forceUpdateDialogHostingController: UIHostingController<AnyView>?
    private var hasCheckedForceUpdate = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        bindViewModel()
        fetchData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Show navigation bar (in case it was hidden by detail screen)
        navigationController?.navigationBar.isHidden = false
        navigationController?.isNavigationBarHidden = false
        // Restore navigation bar items every time view appears
        setNavigationBarIcon()
        setRightBarItems()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Check for force update only once when home screen appears
        if !hasCheckedForceUpdate {
            hasCheckedForceUpdate = true
            checkForForceUpdate()
        }
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
            .sink { [weak self] _ in
                self?.tblHome.reloadData()
            }
            .store(in: &cancellables)

        // Bind profile data
        viewModel.$profile
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                // Reload user info section when profile changes
                if let indexPath = self?.indexPathForUserSection() {
                    self?.tblHome.reloadRows(at: [indexPath], with: .none)
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

    // MARK: - Force Update Check
    private func checkForForceUpdate() {
        print("📱 [Home] Checking for force update...")

        Task {
            let result = await VersionCheckService.shared.checkAppVersion()

            await MainActor.run {
                switch result {
                case .success(let versionData):
                    if versionData.isForceUpdate {
                        // Show force update dialog (non-dismissible)
                        showForceUpdateDialog(versionData: versionData)
                    } else {
                        print("✅ [Home] No force update required")
                    }

                case .failure(let error):
                    print("⚠️ [Home] Version check failed: \(error.localizedDescription)")
                }
            }
        }
    }

    private func showForceUpdateDialog(versionData: VersionCheckData) {
        print("🚨 [Home] Showing force update dialog")

        if #available(iOS 14.0, *) {
            let dialogView = ForceUpdateDialog(
                title: versionData.safeTitle,
                message: versionData.safeMessage,
                onUpdate: {
                    self.openAppStore(url: versionData.safeStoreUrl)
                }
            )

            let hostingController = UIHostingController(rootView: AnyView(dialogView))
            hostingController.view.backgroundColor = .clear
            hostingController.modalPresentationStyle = .overFullScreen
            hostingController.modalTransitionStyle = .crossDissolve

            self.forceUpdateDialogHostingController = hostingController
            self.present(hostingController, animated: true)
        }
    }

    private func openAppStore(url: String) {
        guard !url.isEmpty, let storeURL = URL(string: url) else {
            print("⚠️ [Home] Invalid App Store URL")
            return
        }

        print("📱 [Home] Opening App Store: \(url)")
        UIApplication.shared.open(storeURL)
    }
}

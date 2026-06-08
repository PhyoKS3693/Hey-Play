//
//  HomeViewController.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 10/08/2025.
//

import UIKit
import Combine

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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
}

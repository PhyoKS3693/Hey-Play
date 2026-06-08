//
//  ViewNavigation.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 14/10/2025.
//

import Foundation
import UIKit
import SwiftUI

// MARK: - Custom Hosting Controller for Search
class SearchHostingController<Content: View>: UIHostingController<Content> {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ViewNavigation.shared.currentViewController = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ViewNavigation.shared.currentViewController = self
    }
}

class ViewNavigation {
    static let shared = ViewNavigation()
    var currentViewController: UIViewController?

    private var appWindow: UIWindow? {
        return (UIApplication.shared.delegate as? AppDelegate)?.window
    }

    func showMainTabBar() {
        print("✅ ViewNavigation.showMainTabBar() called")
        guard let window = appWindow else {
            print("❌ appWindow is nil!")
            return
        }

        let vc = HomeViewController()
        let navVC = UINavigationController(rootViewController: vc)
        navVC.navigationBar.isHidden = false

        print("✅ Setting rootViewController to HomeViewController")
        window.rootViewController = navVC
        window.makeKeyAndVisible()
        print("✅ Window made key and visible")
    }

    func showLoginView() {
        let controller = LoginViewController()
        let navVC = UINavigationController(rootViewController: controller)
        navVC.navigationBar.isHidden = true
        appWindow?.rootViewController = navVC
        appWindow?.makeKeyAndVisible()
    }
    
    func showMovieDetail(detailType : DetailType) {
        guard let vc = currentViewController as? HomeViewController else {
            return
        }
        let controller = MovieDetailViewController()
        controller.detailType = detailType
        vc.navigationController?.pushViewController(controller, animated: true)
    }

    func showMovieDetail(detailType: DetailType, movieId: Int) {
        guard let vc = currentViewController else { return }
        let controller = MovieDetailViewController()
        controller.detailType = detailType
        controller.movieId = movieId
        vc.navigationController?.pushViewController(controller, animated: true)
    }
    
    func showSearchView() {
        guard let vc = currentViewController else {
            return
        }
        let searchView = SearchView()
        let controller = SearchHostingController(rootView: searchView)
        let navController = UINavigationController(rootViewController: controller)
        navController.navigationBar.isHidden = true
        navController.modalPresentationStyle = .fullScreen
        vc.present(navController, animated: true)
    }
    
    func showMenu(){
        guard let vc = currentViewController as? SplashViewController else {
            return
        }
        let con = MenuViewController()
        vc.navigationController?.pushViewController(con, animated: true)
    }
    
    func showNotification() {
        guard let vc = currentViewController else {
            return
        }
        let controller = NotificationViewController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        vc.present(nav, animated: true)
    }
    
    func showNotificationDetailView(notificaiton : NotificationItem) {
        guard let vc = currentViewController as? NotificationViewController else {
            return
        }
        let notiDetailVC = NotificationDetailViewController()
        vc.navigationController?.pushViewController(notiDetailVC, animated: true)
    }

    func showNotificationDetail(notificationDetail: APINotificationDetail) {
        guard let vc = currentViewController as? NotificationViewController else {
            return
        }
        let notiDetailVC = NotificationDetailViewController()
        notiDetailVC.viewModel.notificationDetail = notificationDetail
        vc.navigationController?.pushViewController(notiDetailVC, animated: true)
    }

    // MARK: - Playlist Navigation based on redirectScreenType
    func navigateFromPlaylist(_ playlist: Playlist, movieId: Int? = nil) {
        switch playlist.redirectType {
        case .movie:
            // Navigate to Movie tab
            showMovieTab()
        case .series:
            // Navigate to Series tab
            showSeriesTab()
        case .playlistDetail:
            // Navigate to Playlist Detail screen
            showPlaylistDetail(playlistId: playlist.playlistId, title: playlist.safeTitle)
        }
    }

    func showMovieTab() {
        let vc = ViewPagerViewController()
        vc.movieSeriesType = .movie
        let navVC = UINavigationController(rootViewController: vc)
        navVC.navigationBar.isHidden = false
        appWindow?.rootViewController = navVC
        appWindow?.makeKeyAndVisible()
    }

    func showSeriesTab() {
        let vc = ViewPagerViewController()
        vc.movieSeriesType = .series
        let navVC = UINavigationController(rootViewController: vc)
        navVC.navigationBar.isHidden = false
        appWindow?.rootViewController = navVC
        appWindow?.makeKeyAndVisible()
    }

    func showPlaylistDetail(playlistId: Int, title: String) {
        guard let vc = currentViewController else { return }
        let controller = CollectionResultViewController()
        controller.playlistId = "\(playlistId)"
        controller.playlistTitle = title
        vc.navigationController?.pushViewController(controller, animated: true)
    }

    func showVideoPlayer(streamingUrl: String, title: String = "", movieId: Int = 0, episodeId: String? = nil) {
        guard let vc = currentViewController else { return }
        let controller = VideoPlayerViewController()
        controller.streamingUrl = streamingUrl
        controller.videoTitle = title
        controller.movieId = movieId
        controller.episodeId = episodeId
        controller.modalPresentationStyle = .fullScreen
        vc.present(controller, animated: true)
    }

}

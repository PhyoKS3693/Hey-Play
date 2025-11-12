//
//  ViewNavigation.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 14/10/2025.
//

import Foundation
import UIKit
import SwiftUI

class ViewNavigation : BaseViewController{
    static let shared = ViewNavigation()
    var currentViewController : UIViewController?
    
    func showMainTabBar() {
        let vc = HomeViewController()
        let navVC = UINavigationController(rootViewController: vc)
        navVC.navigationBar.isHidden = false
        delegate?.window?.rootViewController = navVC
        delegate?.window?.makeKeyAndVisible()
    }
    
    func showLoginView() {
        guard let vc = currentViewController as? SplashViewController else {
            return
        }
        let controller = LoginViewController()
        vc.navigationController?.pushViewController(controller, animated: true)
    }
    
    func showMovieDetail(detailType : DetailType) {
        guard let vc = currentViewController as? HomeViewController else {
            return
        }
        let controller = MovieDetailViewController()
        controller.detailType = detailType
        vc.navigationController?.pushViewController(controller, animated: true)
    }
    
    func showSearchView() {
        guard let vc = currentViewController as? HomeViewController else {
            return
        }
        let searchView = SearchView()
        let controller = UIHostingController(rootView: searchView)
        controller.modalPresentationStyle = .fullScreen
        vc.present(controller, animated: true)
    }
    
    func showMenu(){
        guard let vc = currentViewController as? SplashViewController else {
            return
        }
        let con = MenuViewController()
        vc.navigationController?.pushViewController(con, animated: true)
    }
    
    func showNotification() {
        guard let vc = currentViewController as? HomeViewController else {
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
}

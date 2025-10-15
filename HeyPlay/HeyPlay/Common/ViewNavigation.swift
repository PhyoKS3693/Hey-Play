//
//  ViewNavigation.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 14/10/2025.
//

import Foundation
import UIKit

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
    
}

//
//  MenuViewController.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 10/23/25.
//

import Foundation
import UIKit
import SwiftUI

final class MenuViewController: BaseViewController {
    
    let viewModel = MenuViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "black_Color")
        
        let menuView = MenuScreen(viewModel)
        
        let controller = UIHostingController(rootView: menuView)
        addChild(controller)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(controller.view)
        controller.view.backgroundColor = .black
        
        NSLayoutConstraint.activate([
            controller.view.topAnchor.constraint(equalTo: view.topAnchor),
            controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            controller.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            controller.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        controller.didMove(toParent: self)
        
        controller.rootView.didSelectProfile = { [weak self] in
            let controller = ProfileViewController()
            self?.navigationController?.pushViewController(controller, animated: true)
        }
        
        controller.rootView.didSelectChangePhoneNumber = { [weak self] in
            let controller = ChangePhoneViewController()
            self?.navigationController?.pushViewController(controller, animated: true)
        }
        
        controller.rootView.didSelectWatchList = { [weak self] in
            let controller = WatchListViewController()
            self?.navigationController?.pushViewController(controller, animated: true)
        }
        
        controller.rootView.didSelectSubscriptionPlan = { [weak self] in
            let controller = SubscriptionViewController()
            self?.navigationController?.pushViewController(controller, animated: true)
        }
        
        controller.rootView.didSelectVIPHistory = { [weak self] in
            let controller = VIPHistoryViewController()
            self?.navigationController?.pushViewController(controller, animated: true)
        }
        
        controller.rootView.didSelectRedemptionCode = { [weak self] in
            let controller = RedemptionCodeViewController()
            self?.navigationController?.pushViewController(controller, animated: true)
        }
        
        controller.rootView.didSelectPolicies = { [weak self] in
            let controller = PoliciesViewController()
            self?.navigationController?.pushViewController(controller, animated: true)
        }
        
        controller.rootView.didSelectAboutUs = { [weak self] in
            let controller = AboutUsViewController()
            self?.navigationController?.pushViewController(controller, animated: true)
        }

        controller.rootView.didSelectLogout = { [weak self] in
            self?.viewModel.logout()
        }

        // to show Top of the subviews
        setBottomTabBar()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func setupUI() {
        super.setupUI()
        
    }
    
    
    func setBottomTabBar() {
        selectedTabItem = .menu
        setupBottomBar()
        setTabBarItem()
    }
    
    func setNavTitle() {
        let titleItem = UIBarButtonItem(
            title: "Menu",
            style: .plain,
            target: nil,
            action: nil
        )
        navigationItem.leftBarButtonItem = titleItem
    }
    
    func setRightBarItems() {
        let searchImgView = UIImageView(
            image: UIImage(named: "ic-search")
        )
        let searchItem = UIBarButtonItem(
            customView: searchImgView
        )
        
        let notiImgView = UIImageView(
            image: UIImage(named: "ic-noti")
        )
        let notiItem = UIBarButtonItem(
            customView: notiImgView
        )
        
        navigationItem.rightBarButtonItems = [searchItem , notiItem]
    }
}

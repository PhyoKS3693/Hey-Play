//
//  MenuViewController.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 10/23/25.
//

import Foundation
import UIKit
import SwiftUI

final class MenuViewController: UIHostingController<MenuScreen> {
    
    let viewModel = MenuViewModel()
    
    init() {
        super.init(rootView: .init(viewModel))
        rootView.host = .init(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "black_Color")
        
        rootView.didSelectProfile = { [weak self] in
            let controller = ProfileViewController()
            self?.navigationController?.pushViewController(controller, animated: true)
        }
        
        rootView.didSelectChangePhoneNumber = { [weak self] in
            let controller = ChangePhoneViewController()
            self?.navigationController?.pushViewController(controller, animated: true)
        }
        
        rootView.didSelectWatchList = { [weak self] in
            let controller = WatchListViewController()
            self?.navigationController?.pushViewController(controller, animated: true)
        }
        
        rootView.didSelectSubscriptionPlan = { [weak self] in
            let controller = SubscriptionViewController()
            self?.navigationController?.pushViewController(controller, animated: true)
        }
        
        rootView.didSelectVIPHistory = { [weak self] in
            let controller = VIPHistoryViewController()
            self?.navigationController?.pushViewController(controller, animated: true)
        }
        
        rootView.didSelectRedemptionCode = { [weak self] in
            let controller = RedemptionCodeViewController()
            self?.navigationController?.pushViewController(controller, animated: true)
        }
        
        rootView.didSelectPolicies = { [weak self] in
            let controller = PoliciesViewController()
            self?.navigationController?.pushViewController(controller, animated: true)
        }
        
        rootView.didSelectAboutUs = { [weak self] in
            let controller = AboutUsViewController()
            self?.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

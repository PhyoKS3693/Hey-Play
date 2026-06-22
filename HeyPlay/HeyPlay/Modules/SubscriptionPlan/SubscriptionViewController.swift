//
//  SubscriptionViewController.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 10/24/25.
//

import Foundation
import UIKit
import SwiftUI

final class SubscriptionViewController: UIHostingController<SubscriptionScreen> {
    
    let viewModel = SubscriptionViewModel()
    
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

        rootView.didTapUpgradeToVIP = { [weak self] in
            let controller = PackageViewController()
            self?.navigationController?.pushViewController(controller, animated: true)

        }

        rootView.didTapBack = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar completely
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar when leaving this screen
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
}

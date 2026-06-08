//
//  NotificationViewController.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 30/10/2025.
//

import UIKit
import SwiftUI
import Combine

class NotificationViewController: BaseViewController {
    
    var viewModel = NotificationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var notiView = NotificationView(viewModel)
        notiView.onDismiss = { [weak self] in
            self?.dismiss(animated: true)
        }
        let hostingController = UIHostingController(rootView: notiView)
        addChild(hostingController)
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hostingController.view)

        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])

        hostingController.didMove(toParent: self)
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ViewNavigation.shared.currentViewController = self
    }
}

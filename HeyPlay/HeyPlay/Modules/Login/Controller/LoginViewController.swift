//
//  LoginViewController.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 14/10/2025.
//

import UIKit
import SwiftUI
import SnapKit
import Combine

class LoginViewController: BaseViewController {

    private var hasNavigated = false

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black

        let loginView = LoginView()
        let hostingController = UIHostingController(rootView: loginView)

        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)

        // Set constraints
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        hostingController.view.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalToSuperview().inset(0)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Start observing login success
        startObservingLoginSuccess()
    }

    private func startObservingLoginSuccess() {
        // Check for login success periodically (backup mechanism)
        Timer.publish(every: 0.3, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self, !self.hasNavigated else { return }

                if AppDefaultsManager.shared.isLoggedIn {
                    print("✅ LoginViewController detected login success")
                    self.navigateToHome()
                }
            }
            .store(in: &self.cancellables) // Use inherited cancellables from BaseViewController
    }

    private func navigateToHome() {
        guard !hasNavigated else { return }
        hasNavigated = true

        // Cancel timer
        cancellables.removeAll()

        print("✅ LoginViewController navigating to home")

        // Navigate to home immediately from the view controller level
        DispatchQueue.main.async {
            ViewNavigation.shared.showMainTabBar()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cancellables.removeAll()
    }
}

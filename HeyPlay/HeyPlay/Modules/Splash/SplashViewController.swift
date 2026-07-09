//
//  SplashViewController.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 14/10/2025.
//

import UIKit
import Combine
import SwiftUI
import Foundation

class SplashViewController: BaseViewController {

    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblMessage: UILabel!

    var countdownTime = 2
    private var updateDialogHostingController: UIHostingController<AnyView>?

    // MARK: - Testing Flags (Set to false for production)
    private let TESTING_FORCE_UPDATE = false   // Set to true to test force update dialog
    private let TESTING_NORMAL_UPDATE = false  // Set to true to test normal update dialog

    override func viewDidLoad() {
        super.viewDidLoad()

        // Initialize phoneUUID (will auto-generate on first launch)
        let uuid = AppDefaultsManager.shared.phoneUUID
        print("📱 [Splash] App launched with phoneUUID: \(uuid)")
    }
    
    override func bindObserver() {
        super.bindObserver()
        setupTimer()
        
        lblMessage.text = "splashTitle".localized()
        lblMessage.font = FontUtility.largeTitle()
        lblMessage.textColor = .white
    }
    
    func setupTimer() {
        Timer.publish(
            every: 1.0,
            on: .main,
            in: .common
        )
        .autoconnect()
        .sink { _ in
            self.countdownTime -= 1
            if self.countdownTime == 0 {
                self.navigateBasedOnSession()
            }
        }
        .store(in: &cancellables)
    }

    private func navigateBasedOnSession() {
        print("📱 [Splash] navigateBasedOnSession called")
        // Check app version first
        Task {
            print("📱 [Splash] Starting version check Task")
            await checkAppVersion()
            print("📱 [Splash] Version check Task completed")
        }
    }

    // MARK: - Version Check
    private func checkAppVersion() async {
        print("📱 [Splash] Checking app version...")

        // Testing mode - show dialog without API call
        if TESTING_FORCE_UPDATE || TESTING_NORMAL_UPDATE {
            print("🧪 [Splash] TESTING MODE - Showing test dialog")
            await MainActor.run {
                let testData = VersionCheckData(
                    title: TESTING_FORCE_UPDATE ? "Force Update" : "Normal Update",
                    message: TESTING_FORCE_UPDATE
                        ? "This is a force update alert! A new version is available with exciting features!"
                        : "This is a normal update alert! A new version is available with exciting features!",
                    isForceUpdateExist: TESTING_FORCE_UPDATE,
                    isNormalUpdateExist: TESTING_NORMAL_UPDATE,
                    storeUrl: "https://apps.apple.com/app/id123456789"
                )

                if TESTING_FORCE_UPDATE {
                    showForceUpdateDialog(versionData: testData)
                } else if TESTING_NORMAL_UPDATE {
                    showNormalUpdateDialog(versionData: testData)
                }
            }
            return
        }

        // Production mode - call API
        let result = await VersionCheckService.shared.checkAppVersion()

        await MainActor.run {
            print("📱 [Splash] Version check API response received")
            switch result {
            case .success(let versionData):
                print("📱 [Splash] Version check success - isForceUpdate: \(versionData.isForceUpdate), isNormalUpdate: \(versionData.isNormalUpdate)")
                if versionData.isForceUpdate {
                    // Show force update dialog (non-dismissible)
                    print("🚨 [Splash] Showing force update dialog")
                    showForceUpdateDialog(versionData: versionData)
                } else if versionData.isNormalUpdate {
                    // Show normal update dialog (dismissible)
                    print("📢 [Splash] Showing normal update dialog")
                    showNormalUpdateDialog(versionData: versionData)
                } else {
                    // No update needed, proceed to normal navigation
                    print("✅ [Splash] No update needed, proceeding to app")
                    proceedToApp()
                }

            case .failure(let error):
                // If version check fails, proceed to app anyway
                print("⚠️ [Splash] Version check failed: \(error.localizedDescription)")
                proceedToApp()
            }
        }
    }

    private func showForceUpdateDialog(versionData: VersionCheckData) {
        print("🚨 [Splash] Showing force update dialog")

        if #available(iOS 14.0, *) {
            let dialogView = CustomDialogView(
                iconName: "ic_force_update",
                title: versionData.safeTitle,
                message: versionData.safeMessage,
                showCloseButton: false, // Force update - no close button
                closeAction: nil,
                primaryButtonTitle: "Update Now",
                primaryAction: {
                    self.openAppStore(url: versionData.safeStoreUrl)
                },
                primaryButtonDisabled: false,
                secondaryButtonTitle: nil,
                secondaryAction: nil
            ) {
                EmptyView()
            }

            let hostingController = UIHostingController(rootView: AnyView(dialogView))
            hostingController.view.backgroundColor = .clear
            hostingController.modalPresentationStyle = .overFullScreen
            hostingController.modalTransitionStyle = .crossDissolve
            hostingController.isModalInPresentation = true // Prevent dismiss

            self.updateDialogHostingController = hostingController
            self.present(hostingController, animated: true)
        }
    }

    private func showNormalUpdateDialog(versionData: VersionCheckData) {
        print("📢 [Splash] Showing normal update dialog")

        if #available(iOS 14.0, *) {
            let dialogView = CustomDialogView(
                iconName: "ic_force_update",
                title: versionData.safeTitle,
                message: versionData.safeMessage,
                showCloseButton: true, // Normal update - allow close
                closeAction: {
                    self.updateDialogHostingController?.dismiss(animated: true) {
                        self.proceedToApp()
                    }
                },
                primaryButtonTitle: "Update Now",
                primaryAction: {
                    self.updateDialogHostingController?.dismiss(animated: true)
                    self.openAppStore(url: versionData.safeStoreUrl)
                },
                primaryButtonDisabled: false,
                secondaryButtonTitle: "Later",
                secondaryAction: {
                    self.updateDialogHostingController?.dismiss(animated: true) {
                        self.proceedToApp()
                    }
                }
            ) {
                EmptyView()
            }

            let hostingController = UIHostingController(rootView: AnyView(dialogView))
            hostingController.view.backgroundColor = .clear
            hostingController.modalPresentationStyle = .overFullScreen
            hostingController.modalTransitionStyle = .crossDissolve

            self.updateDialogHostingController = hostingController
            self.present(hostingController, animated: true)
        } else {
            proceedToApp()
        }
    }

    private func openAppStore(url: String) {
        guard !url.isEmpty, let storeURL = URL(string: url) else {
            print("⚠️ [Splash] Invalid App Store URL")
            return
        }

        print("📱 [Splash] Opening App Store: \(url)")
        UIApplication.shared.open(storeURL)
    }

    private func proceedToApp() {
        print("✅ [Splash] Proceeding to app")

        // Check if user is logged in
        if AppDefaultsManager.shared.isLoggedIn {
            // User is logged in → Go to Home
            ViewNavigation.shared.showMainTabBar()
        } else {
            // User is not logged in → Go to Login
            ViewNavigation.shared.showLoginView()
        }
    }

}

//
//  ErrorPresenter.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 02/09/26.
//

import UIKit
import SwiftUI

// MARK: - Error Presenter
class ErrorPresenter {
    static let shared = ErrorPresenter()

    private init() {}

    // Show error dialog from any view controller
    func showError(
        title: String = "Error",
        message: String,
        from viewController: UIViewController? = nil,
        onConfirm: (() -> Void)? = nil
    ) {
        DispatchQueue.main.async {
            let hostVC = viewController ?? self.topViewController()

            // Create SwiftUI error dialog
            let errorDialog = CustomErrorDialogHostingController(
                title: title,
                message: message,
                onConfirm: {
                    onConfirm?()
                }
            )
            errorDialog.modalPresentationStyle = .overFullScreen
            errorDialog.modalTransitionStyle = .crossDissolve

            hostVC?.present(errorDialog, animated: true)
        }
    }

    // Show error from Error object
    func showError(
        _ error: Error,
        title: String = "Error",
        from viewController: UIViewController? = nil,
        onConfirm: (() -> Void)? = nil
    ) {
        showError(
            title: title,
            message: error.localizedDescription,
            from: viewController,
            onConfirm: onConfirm
        )
    }

    // Get top view controller
    private func topViewController() -> UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }),
              var topController = window.rootViewController else {
            return nil
        }

        while let presentedViewController = topController.presentedViewController {
            topController = presentedViewController
        }

        if let navigationController = topController as? UINavigationController {
            return navigationController.visibleViewController
        }

        if let tabBarController = topController as? UITabBarController {
            if let selected = tabBarController.selectedViewController {
                return selected
            }
        }

        return topController
    }
}

// MARK: - Custom Error Dialog Hosting Controller
class CustomErrorDialogHostingController: UIHostingController<CustomErrorDialogWrapper> {
    init(title: String, message: String, onConfirm: @escaping () -> Void) {
        let view = CustomErrorDialogWrapper(
            title: title,
            message: message,
            onDismiss: {},
            onConfirm: onConfirm
        )
        super.init(rootView: view)
        self.view.backgroundColor = .clear
    }

    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }
}

// MARK: - Custom Error Dialog Wrapper
struct CustomErrorDialogWrapper: View {
    @Environment(\.presentationMode) var presentationMode
    let title: String
    let message: String
    let onDismiss: () -> Void
    let onConfirm: () -> Void

    var body: some View {
        ZStack {
            Color.clear
                .contentShape(Rectangle())

            CustomErrorDialog(
                isShow: Binding(
                    get: { true },
                    set: { if !$0 { dismiss() } }
                ),
                title: title,
                message: message,
                onConfirm: {
                    dismiss()
                    onConfirm()
                }
            )
        }
    }

    private func dismiss() {
        presentationMode.wrappedValue.dismiss()
        onDismiss()
    }
}

// MARK: - UIViewController Extension
extension UIViewController {
    func showErrorDialog(title: String = "Error", message: String, onConfirm: (() -> Void)? = nil) {
        ErrorPresenter.shared.showError(
            title: title,
            message: message,
            from: self,
            onConfirm: onConfirm
        )
    }

    func showErrorDialog(_ error: Error, title: String = "Error", onConfirm: (() -> Void)? = nil) {
        ErrorPresenter.shared.showError(
            error,
            title: title,
            from: self,
            onConfirm: onConfirm
        )
    }
}

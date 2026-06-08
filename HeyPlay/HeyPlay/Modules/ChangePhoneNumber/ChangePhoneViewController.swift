//
//  ChangePhoneViewController.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 10/24/25.
//

import Foundation
import UIKit
import SwiftUI

final class ChangePhoneViewController: UIHostingController<ChangePhoneNumberScreen> {
    
    let viewModel = ChangePhoneNumberViewModel()
    
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

        rootView.didTapBack = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }

        rootView.didTapContinue = { [weak self] in
            guard let self = self else {
                print("❌ [ChangePhoneViewController] Self is nil in didTapContinue")
                return
            }

            print("🔘 [ChangePhoneViewController] Continue button tapped")
            print("📱 [ChangePhoneViewController] Phone number: \(self.viewModel.newPhoneNumber)")

            Task { @MainActor in
                print("⏳ [ChangePhoneViewController] Task started, calling validateNewPhone()...")

                let isValid = await self.viewModel.validateNewPhone()

                print("📊 [ChangePhoneViewController] Validation result: \(isValid)")
                print("🔑 [ChangePhoneViewController] SecurityKey: \(self.viewModel.securityKey ?? "nil")")

                if isValid, let securityKey = self.viewModel.securityKey {
                    print("✅ [ChangePhoneViewController] Navigating to OTP screen")
                    let controller = VerifyOtpViewController()
                    controller.viewModel.newPhoneNumber = self.viewModel.newPhoneNumber
                    controller.viewModel.securityKey = securityKey
                    self.navigationController?.pushViewController(controller, animated: true)
                } else {
                    print("❌ [ChangePhoneViewController] Cannot navigate - isValid: \(isValid), securityKey: \(self.viewModel.securityKey ?? "nil")")
                }
            }
        }
    }
    
}

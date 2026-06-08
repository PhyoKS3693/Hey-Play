//
//  VerifyOtpViewController.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 10/30/25.
//

import Foundation
import UIKit
import SwiftUI

final class VerifyOtpViewController: UIHostingController<VerifyOtpScreen> {
    
    let viewModel = VerifyOtpViewModel()
    
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

        rootView.didTapVerifyOTP = { [weak self] in
            guard let self = self else { return }

            Task { @MainActor in
                let isSuccess = await self.viewModel.verifyOTP()

                if isSuccess {
                    let controller = SuccessfullyChangePhoneNumberViewController()
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            }
        }
    }
}



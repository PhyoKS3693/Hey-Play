//
//  BuyPlanViewController.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 11/8/25.
//

import Foundation
import UIKit
import SwiftUI

final class BuyPlanViewController: UIHostingController<BuyPlanViewScreen> {
    
    let viewModel = BuyPlanViewModel()

    var packageId: Int?
    var packageName: String
    var packageType: String
    var chargedAmount: String
    var paymentMethodId: Int?
    var paymentMethodName: String

    init() {
        self.packageId = nil
        self.packageName = ""
        self.packageType = ""
        self.chargedAmount = ""
        self.paymentMethodId = nil
        self.paymentMethodName = ""

        super.init(rootView: .init(viewModel))
        rootView.host = .init(self)
    }

    init(
        packageId: Int?,
        packageName: String,
        packageType: String,
        chargedAmount: String,
        paymentMethodId: Int?,
        paymentMethodName: String
    ) {
        self.packageId = packageId
        self.packageName = packageName
        self.packageType = packageType
        self.chargedAmount = chargedAmount
        self.paymentMethodId = paymentMethodId
        self.paymentMethodName = paymentMethodName

        super.init(rootView: .init(viewModel))
        rootView.host = .init(self)

        viewModel.packageId = packageId
        viewModel.packageName = packageName
        viewModel.packageType = packageType
        viewModel.chargedAmount = chargedAmount
        viewModel.paymentMethodId = paymentMethodId
        viewModel.paymentMethodName = paymentMethodName
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

        rootView.didCompletePurchase = { [weak self] paymentUrl in
            guard let self = self, let urlString = paymentUrl, !urlString.isEmpty else {
                print("❌ No payment URL received")
                return
            }

            guard let url = URL(string: urlString) else {
                print("❌ Invalid payment URL: \(urlString)")
                return
            }

            print("🌐 Opening payment URL in browser: \(urlString)")

            DispatchQueue.main.async {
                UIApplication.shared.open(url, options: [:]) { success in
                    if success {
                        print("✅ Successfully opened payment URL in browser")
                    } else {
                        print("❌ Failed to open payment URL in browser")
                    }
                }
            }
        }
    }
}


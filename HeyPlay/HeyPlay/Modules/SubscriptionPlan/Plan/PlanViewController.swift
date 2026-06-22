//
//  PlanViewController.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 11/6/25.
//

import Foundation
import UIKit
import SwiftUI

final class PlanViewController: UIHostingController<PlanViewScreen> {
    
    let viewModel = PlanViewModel()

    var packageName: String
    var packageType: String
    var chargedAmount: String

    init() {
        self.packageName = ""
        self.packageType = ""
        self.chargedAmount = ""
        super.init(rootView: .init(viewModel))
        rootView.host = .init(self)
    }

    init(name: String, type: String, amount: String, packageId: Int? = nil, paymentMethods: [PaymentMethod] = []) {
        self.packageName = name
        self.packageType = type
        self.chargedAmount = amount
        super.init(rootView: .init(viewModel))
        rootView.host = .init(self)

        viewModel.packageName = packageName
        viewModel.packageType = packageType
        viewModel.chargedAmount = chargedAmount
        viewModel.packageId = packageId

        // Use payment methods from previous screen or fetch if not provided
        if !paymentMethods.isEmpty {
            viewModel.paymentMethods = paymentMethods
            print("✅ Using \(paymentMethods.count) payment methods from previous screen")
        }
    }
 
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "black_Color")

        rootView.didSelectPaymentMethod = { [weak self] paymentMethodId, paymentMethodName in
            guard let self = self else { return }
            let controller = BuyPlanViewController(
                packageId: self.viewModel.packageId,
                packageName: self.packageName,
                packageType: self.packageType,
                chargedAmount: self.chargedAmount,
                paymentMethodId: paymentMethodId,
                paymentMethodName: paymentMethodName
            )
            self.navigationController?.pushViewController(controller, animated: true)
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

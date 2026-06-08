//
//  PackageViewController.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 11/6/25.
//

import Foundation
import UIKit
import SwiftUI

final class PackageViewController: UIHostingController<PackageScreen> {
    
    let viewModel = PackageViewModel()
    
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
        
        rootView.didSelectPaymentPlan = { [weak self] name, type, amount in
            guard let self = self else { return }
            let controller = PlanViewController(
                name: name,
                type: type,
                amount: amount,
                packageId: self.viewModel.selectedPackageId,
                paymentMethods: self.viewModel.paymentMethods
            )
            self.navigationController?.pushViewController(controller, animated: true)
        }
        
        rootView.didTapBack = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
}

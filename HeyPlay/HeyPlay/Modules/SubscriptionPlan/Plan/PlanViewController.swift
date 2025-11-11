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
    
    init(name: String, type: String, amount: String) {
        self.packageName = name
        self.packageType = type
        self.chargedAmount = amount
        super.init(rootView: .init(viewModel))
        rootView.host = .init(self)
        
        viewModel.packageName = packageName
        viewModel.packageType = packageType
        viewModel.chargedAmount = chargedAmount
    }
 
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "black_Color")
        
        rootView.didSelectPaymentMethod = { [weak self] name, type, amount, icon in
            let controller = BuyPlanViewController(name: name, type: type, amount: amount, icon: icon)
            self?.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}

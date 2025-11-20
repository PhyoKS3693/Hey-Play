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
    
    var packageName: String
    var packageType: String
    var chargedAmount: String
    var packageIcon: String
    
    init() {
        self.packageName = ""
        self.packageType = ""
        self.chargedAmount = ""
        self.packageIcon = ""
        
        super.init(rootView: .init(viewModel))
        rootView.host = .init(self)
    }
    
    init(name: String, type: String, amount: String, icon: String) {
        self.packageName = name
        self.packageType = type
        self.chargedAmount = amount
        self.packageIcon = icon
        super.init(rootView: .init(viewModel))
        rootView.host = .init(self)
        
        viewModel.packageName = packageName
        viewModel.packageType = packageType
        viewModel.chargedAmount = chargedAmount
        viewModel.paymentIcon = packageIcon
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
    }
}


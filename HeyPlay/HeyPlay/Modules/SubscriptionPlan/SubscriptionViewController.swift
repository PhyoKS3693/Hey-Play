//
//  SubscriptionViewController.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 10/24/25.
//

import Foundation
import UIKit
import SwiftUI

final class SubscriptionViewController: UIHostingController<SubscriptionScreen> {
    
    let viewModel = SubscriptionViewModel()
    
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
    }
    
}

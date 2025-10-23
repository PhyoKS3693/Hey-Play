//
//  MenuViewController.swift
//  HeyPlay
//
//  Created by Aye Myat Minn on 10/23/25.
//

import Foundation
import UIKit
import SwiftUI

final class MenuViewController: UIHostingController<MenuScreen> {
    
    let viewModel = MenuViewModel()
    
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

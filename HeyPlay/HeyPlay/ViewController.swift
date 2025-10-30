//
//  ViewController.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 07/08/2025.
//

import UIKit

class ViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func setupUI() {
        super.setupUI()
        setBottomTabBar()
    }
    func setBottomTabBar() {
        selectedTabItem = .menu
        setupBottomBar()
        setTabBarItem()
    }

}


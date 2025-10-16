//
//  HotViewController.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 10/08/2025.
//

import UIKit

class HotViewController: BaseViewController {
    @IBOutlet weak var tblHot : UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func setupUI() {
        super.setupUI()
        setBottomTabBar()
    }
    
    func setBottomTabBar() {
        setupBottomBar()
        setTabBarItem()
    }
}

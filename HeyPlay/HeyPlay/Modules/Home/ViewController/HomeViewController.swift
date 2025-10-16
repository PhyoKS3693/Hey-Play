//
//  HomeViewController.swift
//  HeyPlay
//
//  Created by Phyo Kyaw Swar on 10/08/2025.
//

import UIKit

class HomeViewController: BaseViewController {
    
    @IBOutlet weak var tblHome: UITableView! 
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    var sectionList : [HomeSection] = [.user, .banner , .recent , .movie , .series]
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func setupUI() {
        super.setupUI()
        setBottomTabBar()
        setupTableView()
        setNavigationBarIcon()
        setRightBarItems()
    }
    func setBottomTabBar() {
        setupBottomBar()
        setTabBarItem()
    }

}

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
        setupBottomBar()
        setupTableView()
        setNavigationBarIcon()
        setRightBarItems()
    }

}
